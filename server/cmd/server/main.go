package main

import (
	"context"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"

	"connectrpc.com/connect"
	"github.com/golang-jwt/jwt"
	"github.com/joho/godotenv"
	"github.com/langrics/kimagure-server/gen/proto/auth/v1/authv1connect"
	"github.com/langrics/kimagure-server/gen/proto/chinese/v1/chinesev1connect"
	"github.com/langrics/kimagure-server/internal/auth"
	"github.com/langrics/kimagure-server/internal/chinese"
	"github.com/langrics/kimagure-server/internal/config"
	"github.com/langrics/kimagure-server/internal/contextkey"
	"github.com/langrics/kimagure-server/internal/database"
	"github.com/langrics/kimagure-server/internal/llm"
	"github.com/langrics/kimagure-server/internal/transcription"
	"go.uber.org/zap"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
)

const tokenHeader = "Authorization"
const shutdownTimeout = 30 * time.Second

func NewAuthInterceptor() connect.UnaryInterceptorFunc {
	interceptor := func(next connect.UnaryFunc) connect.UnaryFunc {
		return connect.UnaryFunc(func(
			ctx context.Context,
			req connect.AnyRequest,
		) (connect.AnyResponse, error) {
			authHeader := req.Header().Get(tokenHeader)
			if authHeader == "" {
				return nil, connect.NewError(
					connect.CodeUnauthenticated,
					errors.New("no Authorization header provided"),
				)
			}

			// "Bearer <token>"形式かチェック
			parts := strings.SplitN(authHeader, " ", 2)
			if len(parts) != 2 || !strings.EqualFold(parts[0], "Bearer") {
				return nil, connect.NewError(
					connect.CodeUnauthenticated,
					errors.New("invalid Authorization header format"),
				)
			}
			tokenString := parts[1]

			// JWT検証
			token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
				// HS256のみ許可
				if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
					return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
				}
				return []byte(auth.JwtSecret), nil
			})
			if err != nil || !token.Valid {
				return nil, connect.NewError(
					connect.CodeUnauthenticated,
					errors.New("invalid or expired JWT"),
				)
			}

			// userID等をcontextにセット（"sub"クレームを使う例）
			claims, ok := token.Claims.(jwt.MapClaims)
			if !ok {
				return nil, connect.NewError(
					connect.CodeUnauthenticated,
					errors.New("invalid JWT claims"),
				)
			}
			var userID string
			switch v := claims["sub"].(type) {
			case float64:
				userID = fmt.Sprintf("%d", int(v))
			case int:
				userID = fmt.Sprintf("%d", v)
			case string:
				userID = v
			default:
				return nil, connect.NewError(
					connect.CodeUnauthenticated,
					errors.New("JWT missing or invalid sub claim"),
				)
			}

			ctx = context.WithValue(ctx, contextkey.UserIDKey, userID)
			return next(ctx, req)
		})
	}
	return connect.UnaryInterceptorFunc(interceptor)
}

func main() {
	// グレースフルシャットダウンのためのコンテキスト作成
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	// Load environment variables - try container path first, then local dev path
	if err := godotenv.Load("/app/.env"); err != nil {
		if err := godotenv.Load("../../.env"); err != nil {
			log.Printf("Warning: failed to load .env file: %v", err)
		}
	}

	// Load configuration
	cfg := config.Load()

	// Initialize database connection
	dbPool, err := database.NewPool(ctx, cfg.DatabaseURL)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer dbPool.Close()

	// Initialize services
	logger, _ := zap.NewProduction()
	defer logger.Sync()

	// 音声認識サービスを初期化（プール実装有効化）
	transcriptionService := transcription.NewService(
		"/app/sherpa-onnx-paraformer-zh-2023-09-14/model.int8.onnx",
		"/app/sherpa-onnx-paraformer-zh-2023-09-14/tokens.txt",
		logger,
		transcription.WithRecognizerPool(true),
		transcription.WithNumThreads(4),
	)
	// サーバー終了時に明示的にシャットダウン
	defer transcriptionService.Shutdown()

	// LLMサービスの初期化
	llmService := llm.NewService(
		os.Getenv("GEMINI_API_KEY"),
		logger,
	)

	// サービスの初期化
	chineseService := chinese.NewService(dbPool, transcriptionService, llmService, logger)
	authService := auth.NewService(dbPool, logger)

	// Setup HTTP server
	mux := http.NewServeMux()

	// Register gRPC services
	interceptors := connect.WithInterceptors(NewAuthInterceptor())

	mux.Handle(chinesev1connect.NewChineseServiceHandler(chineseService, interceptors))
	mux.Handle(authv1connect.NewAuthServiceHandler(authService))

	// Start server
	port := os.Getenv("PORT")
	if port == "" {
		port = cfg.ServerPort // fallback
	}

	server := &http.Server{
		Addr:    ":" + port,
		Handler: h2c.NewHandler(mux, &http2.Server{}),
	}

	// 別goroutineでサーバー起動
	go func() {
		logger.Info("Server starting", zap.String("port", port))
		if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			logger.Fatal("Server failed", zap.Error(err))
		}
	}()

	// シグナル待機
	<-ctx.Done()

	// グレースフルシャットダウンの開始
	logger.Info("Server shutdown initiated")

	// シャットダウン用のタイムアウト付きコンテキスト
	shutdownCtx, cancel := context.WithTimeout(context.Background(), shutdownTimeout)
	defer cancel()

	// サービスのシャットダウン処理
	if err := server.Shutdown(shutdownCtx); err != nil {
		logger.Error("Server shutdown error", zap.Error(err))
	}

	logger.Info("Server gracefully stopped")
}
