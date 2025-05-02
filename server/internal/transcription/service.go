package transcription

import (
	"bytes"
	"context"
	"encoding/binary"
	"fmt"
	"os"
	"sync"
	"time"

	sherpa "github.com/k2-fsa/sherpa-onnx-go-linux"
	"github.com/youpy/go-wav"
	"go.uber.org/zap"
)

// ServiceOption は Service の設定オプションを定義する関数型
type ServiceOption func(*Service)

// WithRecognizerPool はRecognizerPoolを有効/無効にするオプション
func WithRecognizerPool(enabled bool) ServiceOption {
	return func(s *Service) {
		s.usePool = enabled
	}
}

// WithNumThreads はモデル推論に使用するスレッド数を設定するオプション
func WithNumThreads(threads int) ServiceOption {
	return func(s *Service) {
		s.numThreads = threads
	}
}

// WithCacheEnabled はキャッシュを有効/無効にするオプション
func WithCacheEnabled(enabled bool) ServiceOption {
	return func(s *Service) {
		s.useCache = enabled
	}
}

// Service は音声認識サービスを提供する構造体
type Service struct {
	paraformerModel string
	tokensFile      string
	logger          *zap.Logger

	// 認識器プール関連のフィールド
	recognizer      *sherpa.OfflineRecognizer
	recognizerMutex sync.RWMutex
	initOnce        sync.Once
	initialized     bool
	usePool         bool
	numThreads      int

	// キャッシュ機能
	useCache    bool
	cache       map[string]*TranscriptionResult
	cacheMutex  sync.RWMutex
	cacheHits   int64
	cacheMisses int64
}

// NewService はtranscription.Serviceの新しいインスタンスを作成する
func NewService(paraformerModel, tokensFile string, logger *zap.Logger, options ...ServiceOption) *Service {
	s := &Service{
		paraformerModel: paraformerModel,
		tokensFile:      tokensFile,
		logger:          logger,
		usePool:         false, // デフォルトはプールを使用しない
		numThreads:      1,     // デフォルトは1スレッド
		useCache:        false, // デフォルトはキャッシュを使用しない
		cache:           make(map[string]*TranscriptionResult),
	}

	// オプションの適用
	for _, option := range options {
		option(s)
	}

	// プールを使用する場合は初期化
	if s.usePool {
		s.initRecognizer()
	}

	return s
}

// initRecognizer は音声認識器を初期化する
func (s *Service) initRecognizer() {
	s.initOnce.Do(func() {
		startTime := time.Now()
		s.logger.Info("Initializing sherpa-onnx recognizer pool",
			zap.String("model", s.paraformerModel),
			zap.String("tokens", s.tokensFile),
			zap.Int("numThreads", s.numThreads),
		)

		// ファイルの存在確認
		if _, err := os.Stat(s.paraformerModel); os.IsNotExist(err) {
			s.logger.Error("Model file not found", zap.Error(err), zap.String("path", s.paraformerModel))
			return
		}
		if _, err := os.Stat(s.tokensFile); os.IsNotExist(err) {
			s.logger.Error("Tokens file not found", zap.Error(err), zap.String("path", s.tokensFile))
			return
		}

		config := sherpa.OfflineRecognizerConfig{
			ModelConfig: sherpa.OfflineModelConfig{
				Paraformer: sherpa.OfflineParaformerModelConfig{
					Model: s.paraformerModel,
				},
				Tokens:     s.tokensFile,
				ModelType:  "paraformer",
				Debug:      0,
				NumThreads: s.numThreads,
			},
			DecodingMethod: "greedy_search",
		}

		// 認識器をロック下で初期化
		s.recognizerMutex.Lock()
		defer s.recognizerMutex.Unlock()

		s.recognizer = sherpa.NewOfflineRecognizer(&config)
		if s.recognizer == nil {
			s.logger.Error("Failed to initialize recognizer, got nil")
			return
		}

		s.initialized = true
		s.logger.Info("Sherpa-onnx recognizer pool initialized successfully",
			zap.Duration("initTime", time.Since(startTime)),
		)
	})
}

// TranscriptionResult は音声認識結果を表す構造体
type TranscriptionResult struct {
	Text       string    `json:"text"`
	Language   string    `json:"language"`
	Duration   float64   `json:"duration"`
	Tokens     []string  `json:"tokens"`
	Timestamps []float32 `json:"timestamps"`
}

// TranscribeFile は音声ファイルを認識して結果を返す
func (s *Service) TranscribeFile(ctx context.Context, audioPath string) (*TranscriptionResult, error) {
	startTime := time.Now()
	s.logger.Info("Initializing sherpa-onnx recognizer",
		zap.String("file", audioPath),
	)

	// キャッシュチェック（有効な場合）
	if s.useCache {
		cacheKey := audioPath
		s.cacheMutex.RLock()
		if result, ok := s.cache[cacheKey]; ok {
			s.cacheMutex.RUnlock()
			s.logger.Debug("Cache hit", zap.String("file", audioPath))
			return result, nil
		}
		s.cacheMutex.RUnlock()
	}

	var recognizer *sherpa.OfflineRecognizer
	var needCleanup bool

	// プール使用時の処理
	if s.usePool {
		// 認識器が初期化されていない場合
		if !s.initialized {
			s.initRecognizer()
			if !s.initialized {
				return nil, fmt.Errorf("failed to initialize recognizer")
			}
		}

		// 認識器の読み取りロックを取得
		s.recognizerMutex.RLock()
		defer s.recognizerMutex.RUnlock()

		// 認識器が初期化されているか確認
		if s.recognizer == nil {
			return nil, fmt.Errorf("recognizer not initialized")
		}

		recognizer = s.recognizer
		needCleanup = false
	} else {
		// 従来の処理（毎回初期化）
		config := sherpa.OfflineRecognizerConfig{
			ModelConfig: sherpa.OfflineModelConfig{
				Paraformer: sherpa.OfflineParaformerModelConfig{
					Model: s.paraformerModel,
				},
				Tokens:     s.tokensFile,
				ModelType:  "paraformer",
				Debug:      0,
				NumThreads: s.numThreads,
			},
			DecodingMethod: "greedy_search",
		}

		recognizer = sherpa.NewOfflineRecognizer(&config)
		if recognizer == nil {
			return nil, fmt.Errorf("failed to create recognizer")
		}
		needCleanup = true
	}

	// 後処理でクリーンアップが必要な場合
	if needCleanup {
		defer sherpa.DeleteOfflineRecognizer(recognizer)
	}

	// ストリームを作成（これは軽量なので都度作成）
	stream := sherpa.NewOfflineStream(recognizer)
	if stream == nil {
		return nil, fmt.Errorf("failed to create stream")
	}
	defer sherpa.DeleteOfflineStream(stream)

	// 音声データの読み込み
	samples, sampleRate := readWave(audioPath)
	if len(samples) == 0 || sampleRate == 0 {
		return nil, fmt.Errorf("failed to read audio file or empty audio")
	}

	// 音声認識の実行
	streamStartTime := time.Now()
	stream.AcceptWaveform(sampleRate, samples)
	recognizer.Decode(stream)
	result := stream.GetResult()
	processingTime := time.Since(streamStartTime)

	if result == nil {
		return nil, fmt.Errorf("transcription returned nil result")
	}

	// Initialize with empty values in case any result fields are nil
	transcriptionResult := &TranscriptionResult{
		Text:       "",
		Language:   "zh",
		Duration:   float64(len(samples)) / float64(sampleRate),
		Tokens:     []string{},
		Timestamps: []float32{},
	}

	if result.Text != "" {
		transcriptionResult.Text = result.Text
	}
	if result.Tokens != nil {
		transcriptionResult.Tokens = result.Tokens
	}
	if result.Timestamps != nil {
		transcriptionResult.Timestamps = result.Timestamps
	}

	s.logger.Info("Transcription completed",
		zap.String("text", transcriptionResult.Text),
		zap.Any("tokens", transcriptionResult.Tokens),
		zap.Any("timestamps", transcriptionResult.Timestamps),
		zap.Duration("processingTime", processingTime),
		zap.Duration("totalTime", time.Since(startTime)),
	)

	// キャッシュに追加（有効な場合）
	if s.useCache {
		cacheKey := audioPath
		s.cacheMutex.Lock()
		s.cache[cacheKey] = transcriptionResult
		s.cacheMutex.Unlock()
	}

	return transcriptionResult, nil
}

// Shutdown はサービスのリソースを解放する
func (s *Service) Shutdown() {
	if s.usePool && s.initialized {
		s.recognizerMutex.Lock()
		defer s.recognizerMutex.Unlock()

		if s.recognizer != nil {
			sherpa.DeleteOfflineRecognizer(s.recognizer)
			s.recognizer = nil
			s.initialized = false
			s.logger.Info("Sherpa-onnx recognizer pool shutdown")
		}
	}
}

// GetCacheStats はキャッシュの統計情報を返す
func (s *Service) GetCacheStats() (hits, misses int64) {
	return s.cacheHits, s.cacheMisses
}

// ClearCache はキャッシュをクリアする
func (s *Service) ClearCache() {
	if s.useCache {
		s.cacheMutex.Lock()
		defer s.cacheMutex.Unlock()

		s.cache = make(map[string]*TranscriptionResult)
		s.logger.Info("Transcription cache cleared")
	}
}

// readWave はWAVファイルを読み込んでサンプルとサンプルレートを返す
func readWave(filename string) (samples []float32, sampleRate int) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, 0
	}
	defer file.Close()

	reader := wav.NewReader(file)
	format, err := reader.Format()
	if err != nil {
		return nil, 0
	}

	if format.AudioFormat != 1 {
		return nil, 0
	}

	if format.NumChannels != 1 {
		return nil, 0
	}

	if format.BitsPerSample != 16 {
		return nil, 0
	}

	reader.Duration() // Initialize reader.Size

	buf := make([]byte, reader.Size)
	n, err := reader.Read(buf)
	if n != int(reader.Size) {
		return nil, 0
	}

	samples = samplesInt16ToFloat(buf)
	sampleRate = int(format.SampleRate)

	return
}

// samplesInt16ToFloat は16ビット整数のサンプルを[-1.0, 1.0]の範囲の浮動小数点に変換する
func samplesInt16ToFloat(inSamples []byte) []float32 {
	numSamples := len(inSamples) / 2
	outSamples := make([]float32, numSamples)

	for i := 0; i != numSamples; i++ {
		s := inSamples[i*2 : (i+1)*2]

		var s16 int16
		buf := bytes.NewReader(s)
		err := binary.Read(buf, binary.LittleEndian, &s16)
		if err != nil {
			return nil
		}
		outSamples[i] = float32(s16) / 32768
	}

	return outSamples
}
