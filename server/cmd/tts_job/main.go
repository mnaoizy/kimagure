package main

import (
	"bytes"
	"context"
	"math"
	"os"

	"cloud.google.com/go/storage"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/k2-fsa/sherpa-onnx-go/sherpa_onnx"
	"github.com/langrics/kimagure-server/db"
	"github.com/langrics/kimagure-server/internal/praat"
	"github.com/youpy/go-wav"
	"go.uber.org/zap"
)

func main() {
	// ロガー初期化
	logger, err := zap.NewProduction()
	if err != nil {
		panic(err)
	}
	defer logger.Sync()

	logger.Info("Starting TTS Job...")

	// 環境変数の確認
	dbURL := ""
	if dbURL == "" {
		logger.Fatal("DATABASE_URL environment variable is required")
	}

	modelPath := "kokoro-multi-lang-v1_0"
	if modelPath == "" {
		logger.Fatal("TTS_MODEL_PATH environment variable is required")
	}

	bucketName := "kimagure-tts"
	if bucketName == "" {
		logger.Fatal("GCS_BUCKET_NAME environment variable is required")
	}

	// Cloud Storageクライアント初期化
	ctx := context.Background()
	client, err := storage.NewClient(ctx)
	if err != nil {
		logger.Fatal("Failed to create GCS client", zap.Error(err))
	}
	defer client.Close()

	bucket := client.Bucket(bucketName)

	// TTSクライアント初期化
	ttsConfig := &sherpa_onnx.OfflineTtsConfig{
		Model: sherpa_onnx.OfflineTtsModelConfig{
			// Kokoro: sherpa_onnx.OfflineTtsKokoroModelConfig{
			// 	Model:       "kokoro-multi-lang-v1_0/model.onnx",
			// 	Voices:      "kokoro-multi-lang-v1_0/voices.bin",
			// 	Lexicon:     "kokoro-multi-lang-v1_0/lexicon-zh.txt",
			// 	Tokens:      "kokoro-multi-lang-v1_0/tokens.txt",
			// 	DataDir:     "kokoro-multi-lang-v1_0/espeak-ng-data",
			// 	DictDir:     "kokoro-multi-lang-v1_0/dict",
			// 	LengthScale: 1.0,
			// },
			// Vits: sherpa_onnx.OfflineTtsVitsModelConfig{
			// 	Model:       "vits-melo-tts-zh_en/model.onnx",
			// 	Lexicon:     "vits-melo-tts-zh_en/lexicon.txt",
			// 	Tokens:      "vits-melo-tts-zh_en/tokens.txt",
			// 	DictDir:     "vits-melo-tts-zh_en/dict",
			// 	LengthScale: 1, // Slightly faster speech
			// },
			Matcha: sherpa_onnx.OfflineTtsMatchaModelConfig{
				AcousticModel: "/app/matcha-icefall-zh-baker/model-steps-3.onnx",
				Vocoder:       "/app/matcha-icefall-zh-baker/vocos-22khz-univ.onnx",
				Lexicon:       "/app/matcha-icefall-zh-baker/lexicon.txt",
				Tokens:        "/app/matcha-icefall-zh-baker/tokens.txt",
				DictDir:       "/app/matcha-icefall-zh-baker/dict",
				LengthScale:   1.2,
			},
			NumThreads: 4,
			Debug:      0,
			Provider:   "cpu",
		},
	}

	tts := sherpa_onnx.NewOfflineTts(ttsConfig)
	if tts == nil {
		logger.Fatal("Failed to initialize TTS")
	}

	// データベース接続
	connConfig, err := pgx.ParseConfig(dbURL)
	if err != nil {
		logger.Fatal("Failed to parse database URL", zap.Error(err))
	}
	// Supabase用にプリペアドステートメントを無効化
	connConfig.DefaultQueryExecMode = pgx.QueryExecModeSimpleProtocol

	conn, err := pgx.ConnectConfig(ctx, connConfig)
	if err != nil {
		logger.Fatal("Failed to connect to database", zap.Error(err))
	}
	defer conn.Close(ctx)
	// sqlcクエリの初期化
	queries := db.New(conn)

	// chinese_itemsテーブルから全データ取得
	items, err := queries.GetChineseItems(ctx)
	if err != nil {
		logger.Fatal("Failed to get chinese items", zap.Error(err))
	}

	// 取得したデータを処理
	logger.Info("Fetched chinese items", zap.Int("count", len(items)))
	for _, item := range items {
		logger.Info("Processing Chinese Item",
			zap.Int32("id", item.ID),
			zap.String("character", item.Character),
		)

		// TTSで音声生成 (sid=0, speed=1.0)
		audio := tts.Generate(item.Character, 0, 1.0)
		if audio == nil {
			logger.Error("Failed to generate TTS audio",
				zap.String("text", item.Character),
			)
			continue
		}

		// Normalize and convert float32 samples to 16-bit PCM
		samples := make([]int16, len(audio.Samples))
		var maxSample float32 = 0
		for _, v := range audio.Samples {
			if abs := float32(math.Abs(float64(v))); abs > maxSample {
				maxSample = abs
			}
		}

		scale := float32(math.MaxInt16) / maxSample
		for i, v := range audio.Samples {
			samples[i] = int16(v * scale)
		}

		// Convert to wav.Sample format
		wavSamples := make([]wav.Sample, len(samples))
		for i, s := range samples {
			wavSamples[i] = wav.Sample{Values: [2]int{int(s), int(s)}}
		}

		// WAVデータ作成
		var buf bytes.Buffer
		w := wav.NewWriter(&buf, uint32(len(wavSamples)), 1, uint32(audio.SampleRate), 16)
		if err := w.WriteSamples(wavSamples); err != nil {
			logger.Error("Failed to write WAV data", zap.Error(err))
			continue
		}

		// Cloud Storageにアップロード
		objectName := "tts/" + uuid.New().String() + ".wav"
		obj := bucket.Object(objectName)
		wc := obj.NewWriter(ctx)

		if _, err := wc.Write(buf.Bytes()); err != nil {
			logger.Error("Failed to write to GCS", zap.Error(err))
			wc.Close()
			continue
		}

		if err := wc.Close(); err != nil {
			logger.Error("Failed to close GCS writer", zap.Error(err))
			continue
		}

		// 公開URLを生成
		url := "https://storage.googleapis.com/" + bucketName + "/" + objectName

		// Save temporary WAV file for pitch analysis
		tmpWavPath := "/tmp/" + uuid.New().String() + ".wav"
		if err := os.WriteFile(tmpWavPath, buf.Bytes(), 0644); err != nil {
			logger.Error("Failed to save temporary WAV file",
				zap.Int32("id", item.ID),
				zap.Error(err),
			)
			continue
		}
		defer os.Remove(tmpWavPath)

		// Analyze pitch of the generated audio
		praatService := praat.NewService("/usr/local/bin/praat", "/app/praat")
		pitches, err := praatService.AnalyzePitch(tmpWavPath)
		if err != nil {
			logger.Error("Failed to analyze pitch",
				zap.Int32("id", item.ID),
				zap.Error(err),
			)
			continue
		}

		// Convert pitch array to []float32
		pitchArray := make([]float32, len(pitches))
		copy(pitchArray, pitches)

		// データベースに保存 (URLとピッチ配列を保存)
		if _, err := queries.UpdateChineseItemAudio(ctx, db.UpdateChineseItemAudioParams{
			ID:    item.ID,
			Audio: pgtype.Text{String: url, Valid: true},
			Pitch: pitchArray,
		}); err != nil {
			logger.Error("Failed to update database with audio URL and pitch array",
				zap.Int32("id", item.ID),
				zap.String("audio_url", url),
				zap.Int("pitch_points", len(pitches)),
				zap.Error(err),
			)
			continue
		}

		logger.Info("Successfully processed TTS audio",
			zap.Int32("id", item.ID),
			zap.String("character", item.Character),
			zap.String("audio_url", url),
		)
	}

	logger.Info("TTS Job completed successfully")
}
