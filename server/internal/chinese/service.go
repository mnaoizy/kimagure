package chinese

import (
	"bytes"
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/langrics/kimagure-server/db"
	chinesev1 "github.com/langrics/kimagure-server/gen/proto/chinese/v1"
	"github.com/langrics/kimagure-server/internal/contextkey"
	"github.com/langrics/kimagure-server/internal/llm"
	"github.com/langrics/kimagure-server/internal/praat"
	"github.com/langrics/kimagure-server/internal/transcription"
	"go.uber.org/zap"
)

type Service struct {
	queries       *db.Queries
	praat         *praat.Service
	transcription *transcription.Service
	llm           *llm.Service
	logger        *zap.Logger
}

func NewService(dbPool *pgxpool.Pool, transcriptionService *transcription.Service, llmService *llm.Service, logger *zap.Logger) *Service {
	praatService := praat.NewService("/usr/local/bin/praat", "/app/praat")
	return &Service{
		queries:       db.New(dbPool),
		praat:         praatService,
		transcription: transcriptionService,
		llm:           llmService,
		logger:        logger,
	}
}

func (s *Service) GetLessons(
	ctx context.Context,
	req *connect.Request[chinesev1.GetLessonsRequest],
) (*connect.Response[chinesev1.GetLessonsResponse], error) {

	userID, ok := ctx.Value(contextkey.UserIDKey).(string)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, fmt.Errorf("userID not found in context"))
	}

	// userID を使って DB クエリなどを行う
	fmt.Println("Authenticated user:", userID)

	dbLessons, err := s.queries.GetLessons(ctx)
	if err != nil {
		s.logger.Error("GetLessons DB error", zap.Error(err))
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	lessons := make([]*chinesev1.Lesson, len(dbLessons))
	for i, lesson := range dbLessons {
		lessons[i] = &chinesev1.Lesson{
			Id:          fmt.Sprint(lesson.ID),
			Title:       lesson.Title,
			Description: lesson.Description.String,
		}
	}

	res := connect.NewResponse(&chinesev1.GetLessonsResponse{
		Lessons: lessons,
	})

	return res, nil
}

func (s *Service) UploadRecording(
	ctx context.Context,
	req *connect.Request[chinesev1.UploadRecordingRequest],
) (*connect.Response[chinesev1.UploadRecordingResponse], error) {
	// Create upload directory if not exists
	uploadDir := "/tmp/uploads"
	if err := os.MkdirAll(uploadDir, 0755); err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to create upload directory: %w", err))
	}

	// Generate filename and full path
	filename := fmt.Sprintf("%s_%d.aac", req.Msg.ItemId, time.Now().Unix())
	containerPath := filepath.Join(uploadDir, filename)

	// Save original AAC file
	startSave := time.Now()
	if err := os.WriteFile(containerPath, req.Msg.AudioData, 0644); err != nil {
		s.logger.Error("Failed to save audio file",
			zap.String("path", containerPath),
			zap.Error(err),
		)
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to save audio file: %w", err))
	}

	// Register cleanup immediately after file creation
	defer func() {
		if err := os.Remove(containerPath); err != nil && !os.IsNotExist(err) {
			s.logger.Error("Failed to clean up AAC file",
				zap.String("path", containerPath),
				zap.Error(err),
			)
		}
	}()

	s.logger.Info("Audio file saved",
		zap.String("path", containerPath),
		zap.Int64("size", int64(len(req.Msg.AudioData))),
		zap.Duration("duration", time.Since(startSave)),
	)

	// Convert to WAV for processing
	startConvert := time.Now()
	wavPath := strings.TrimSuffix(containerPath, filepath.Ext(containerPath)) + ".wav"
	cmd := exec.Command("ffmpeg",
		"-y",
		"-i", containerPath,
		"-acodec", "pcm_s16le",
		"-ar", "16000", // サンプルレートを16kHzに低下
		"-ac", "1", // モノラル化
		"-threads", "0", // 自動スレッド並列化
		wavPath)
	var stderr bytes.Buffer
	cmd.Stderr = &stderr

	if err := cmd.Run(); err != nil {
		s.logger.Error("FFmpeg conversion failed",
			zap.String("input", containerPath),
			zap.String("output", wavPath),
			zap.String("error", stderr.String()),
		)
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to convert to WAV: %w (FFmpeg output: %s)", err, stderr.String()))
	}

	s.logger.Info("Audio converted to WAV",
		zap.String("input", containerPath),
		zap.String("output", wavPath),
		zap.Duration("duration", time.Since(startConvert)),
	)

	// Check for silent audio using FFmpeg
	cmd = exec.Command("ffmpeg",
		"-i", wavPath,
		"-af", "volumedetect",
		"-f", "null",
		"/dev/null")
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to analyze audio volume: %w", err))
	}

	// Parse FFmpeg output to get actual volume level
	volumeRegex := regexp.MustCompile(`mean_volume: ([-+]?[0-9]*\.?[0-9]+) dB`)
	matches := volumeRegex.FindStringSubmatch(stderr.String())
	if len(matches) < 2 {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to parse audio volume"))
	}

	volume, err := strconv.ParseFloat(matches[1], 64)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to parse volume level: %w", err))
	}

	// Reject if volume is below -30 dB (more strict threshold)
	if volume < -50.0 {
		return nil, connect.NewError(connect.CodeInvalidArgument,
			fmt.Errorf("audio is too quiet (volume: %.1f dB, minimum: -30 dB)", volume))
	}

	// Get file size
	fileInfo, err := os.Stat(containerPath)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// 並列処理用の変数
	var (
		wg          sync.WaitGroup
		pitches     []float32
		transResult *transcription.TranscriptionResult
		pitchErr    error
		transErr    error
		feedback    string
		feedbackErr error
	)

	// Praat分析をgoroutineで実行
	wg.Add(1)
	go func() {
		startPitch := time.Now()
		defer wg.Done()
		pitches, pitchErr = s.praat.AnalyzePitch(wavPath)
		if pitchErr != nil {
			s.logger.Error("Failed to analyze pitch",
				zap.String("path", wavPath),
				zap.Error(pitchErr),
			)
		} else {
			s.logger.Info("Pitch analysis completed",
				zap.String("path", wavPath),
				zap.Int("points", len(pitches)),
				zap.Duration("duration", time.Since(startPitch)),
			)
		}
	}()

	// 音声認識とフィードバック生成をgoroutineで実行
	wg.Add(1)
	go func() {
		startTrans := time.Now()
		defer wg.Done()
		transResult, transErr = s.transcription.TranscribeFile(ctx, wavPath)
		if transErr != nil {
			s.logger.Error("Failed to transcribe audio",
				zap.String("path", wavPath),
				zap.Error(transErr),
			)
			return
		}
		s.logger.Info("Audio transcription completed",
			zap.String("text", transResult.Text),
			zap.Float64("audioDuration", transResult.Duration),
			zap.Duration("processDuration", time.Since(startTrans)),
		)

		// item_idからChineseItemをDB取得
		itemID, err := strconv.ParseInt(req.Msg.ItemId, 10, 64)
		if err != nil {
			feedbackErr = fmt.Errorf("invalid item_id: %w", err)
			return
		}
		dbItem, err := s.queries.GetChineseItemByID(ctx, int32(itemID))
		if err != nil {
			feedbackErr = fmt.Errorf("failed to get ChineseItem: %w", err)
			return
		}

		// LLMでフィードバック生成
		res, err := s.llm.GetChineseFeedback(ctx, dbItem.Character, dbItem.Pinyin, transResult.Text)
		if err != nil {
			s.logger.Error("LLM feedback error",
				zap.String("text", transResult.Text),
				zap.Error(err),
			)
			feedbackErr = err
			return
		}
		s.logger.Info("LLM feedback generated",
			zap.String("text", transResult.Text),
			zap.String("feedback", res.Feedback),
			zap.Duration("duration", time.Since(startTrans)),
		)
		feedback = res.Feedback
	}()

	// 両方の処理が完了するのを待つ
	wg.Wait()

	// エラーチェック
	if pitchErr != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to analyze pitch: %v", pitchErr))
	}
	if feedbackErr != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to generate feedback: %v", feedbackErr))
	}

	// Register WAV cleanup immediately after conversion
	defer func() {
		if err := os.Remove(wavPath); err != nil && !os.IsNotExist(err) {
			s.logger.Error("Failed to clean up WAV file",
				zap.String("path", wavPath),
				zap.Error(err),
			)
		}
	}()

	// Save feedback to database
	userID, ok := ctx.Value(contextkey.UserIDKey).(string)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, fmt.Errorf("userID not found in context"))
	}

	itemID, err := strconv.ParseInt(req.Msg.ItemId, 10, 64)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("invalid item_id: %w", err))
	}

	userIDInt, err := strconv.ParseInt(userID, 10, 64)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("invalid user_id: %w", err))
	}

	startDB := time.Now()
	_, err = s.queries.CreateFeedback(ctx, db.CreateFeedbackParams{
		UserID:   int32(userIDInt),
		ItemID:   int32(itemID),
		Feedback: feedback,
	})
	if err != nil {
		s.logger.Error("Failed to save feedback",
			zap.String("userID", userID),
			zap.String("itemID", req.Msg.ItemId),
			zap.Error(err),
		)
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to save feedback: %w", err))
	}
	s.logger.Info("Feedback saved to database",
		zap.String("userID", userID),
		zap.String("itemID", req.Msg.ItemId),
		zap.Duration("duration", time.Since(startDB)),
	)

	return connect.NewResponse(&chinesev1.UploadRecordingResponse{
		Size:     fileInfo.Size(),
		Pitches:  pitches,
		Feedback: feedback,
	}), nil
}

func (s *Service) GetFeedbacks(
	ctx context.Context,
	req *connect.Request[chinesev1.GetFeedbackRequest],
) (*connect.Response[chinesev1.GetFeedbacksResponse], error) {
	userID, ok := ctx.Value(contextkey.UserIDKey).(string)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, fmt.Errorf("userID not found in context"))
	}

	itemID, err := strconv.ParseInt(req.Msg.ItemId, 10, 64)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("invalid item_id: %w", err))
	}

	userIDInt, err := strconv.ParseInt(userID, 10, 64)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("invalid user_id: %w", err))
	}

	feedbacks, err := s.queries.GetFeedbacks(ctx, db.GetFeedbacksParams{
		UserID: int32(userIDInt),
		ItemID: int32(itemID),
	})
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to get feedbacks: %w", err))
	}

	feedbackResponses := make([]*chinesev1.Feedback, len(feedbacks))
	for i, f := range feedbacks {
		var createdAt string
		if f.CreatedAt.Valid {
			createdAt = f.CreatedAt.Time.Format(time.RFC3339)
		} else {
			createdAt = time.Now().Format(time.RFC3339)
		}
		feedbackResponses[i] = &chinesev1.Feedback{
			Text:      f.Feedback,
			CreatedAt: createdAt,
		}
	}

	return connect.NewResponse(&chinesev1.GetFeedbacksResponse{
		Feedbacks: feedbackResponses,
	}), nil
}

func (s *Service) GetChineseList(
	ctx context.Context,
	req *connect.Request[chinesev1.GetChineseListRequest],
) (*connect.Response[chinesev1.GetChineseListResponse], error) {

	_, ok := ctx.Value(contextkey.UserIDKey).(string)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, fmt.Errorf("userID not found in context"))
	}

	lessonID, err := strconv.ParseInt(req.Msg.LessonId, 10, 64)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("invalid lesson_id"))
	}

	dbItems, err := s.queries.GetChineseItemsByLesson(ctx, pgtype.Int4{Int32: int32(lessonID), Valid: true})
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	items := make([]*chinesev1.ChineseItem, len(dbItems))
	for i, item := range dbItems {
		items[i] = &chinesev1.ChineseItem{
			Id:        fmt.Sprint(item.ID),
			Character: item.Character,
			Pinyin:    item.Pinyin,
			Meaning:   item.Meaning,
			LessonId:  fmt.Sprint(item.LessonID),
			AudioUrl:  item.Audio.String,
			PitchData: item.Pitch,
		}
	}

	res := connect.NewResponse(&chinesev1.GetChineseListResponse{
		Items: items,
	})
	return res, nil
}
