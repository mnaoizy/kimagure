package auth

import (
	"context"
	"database/sql"
	"errors"
	"log"
	"strconv"
	"time"

	"github.com/jackc/pgx/v5"

	"connectrpc.com/connect"
	"github.com/golang-jwt/jwt"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/langrics/kimagure-server/db"
	authv1 "github.com/langrics/kimagure-server/gen/proto/auth/v1"
	"go.uber.org/zap"
)

const JwtSecret = "your_jwt_secret" // JWTシークレットキーは環境変数や設定ファイルから取得することをお勧めします

type Service struct {
	queries *db.Queries
	logger  *zap.Logger
}

func NewService(dbPool *pgxpool.Pool, logger *zap.Logger) *Service {
	return &Service{
		queries: db.New(dbPool),
		logger:  logger,
	}
}

func (s *Service) AuthenticateAnonymously(
	ctx context.Context,
	req *connect.Request[authv1.AuthenticateAnonymouslyRequest],
) (*connect.Response[authv1.AuthenticateAnonymouslyResponse], error) {
	deviceID := req.Msg.DeviceId
	if deviceID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("device_id is required"))
	}

	user, err := s.queries.GetUserByDeviceID(ctx, deviceID)

	//check err != sql.ErrNoRows
	log.Println("err:", err)

	log.Printf("deviceID: %s, user: %+v, err: %v", deviceID, user, err)
	if err != nil && err != sql.ErrNoRows && err != pgx.ErrNoRows {
		s.logger.Error("GetUserByDeviceID DB error", zap.Error(err))
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	if err == sql.ErrNoRows || err == pgx.ErrNoRows {
		// 新規ユーザー作成
		s.logger.Info("Creating new anonymous user", zap.String("deviceID", deviceID))
		user, err = s.queries.CreateAnonymousUser(ctx, db.CreateAnonymousUserParams{
			DeviceID:  deviceID,
			CreatedAt: pgtype.Timestamptz{Time: time.Now(), Valid: true},
		})
		if err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
	} else if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	// JWTトークン生成
	token, err := generateJWT(user.ID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	res := connect.NewResponse(&authv1.AuthenticateAnonymouslyResponse{
		Token:  token,
		UserId: strconv.Itoa(int(user.ID)),
	})

	return res, nil
}

func generateJWT(userID int32) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"sub":  userID,
		"iat":  time.Now().Unix(),
		"exp":  time.Now().Add(time.Hour * 24 * 30).Unix(), // 30日間有効
		"type": "anonymous",
	})

	return token.SignedString([]byte(JwtSecret))
}
