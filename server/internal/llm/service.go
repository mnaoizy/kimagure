package llm

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"regexp"
	"strings"
	"time"

	"github.com/google/generative-ai-go/genai"
	"github.com/mozillazg/go-pinyin"
	"go.uber.org/zap"
	"google.golang.org/api/option"
)

type Service struct {
	apiKey string
	client *http.Client
	logger *zap.Logger
}

func NewService(apiKey string, logger *zap.Logger) *Service {
	return &Service{
		apiKey: apiKey,
		client: &http.Client{Timeout: 30 * time.Second},
		logger: logger,
	}
}

type FeedbackRequest struct {
	TargetText   string `json:"target_text"`
	UserText     string `json:"user_text"`
	UserLanguage string `json:"user_language"`
}

type FeedbackResponse struct {
	Feedback string `json:"feedback"`
}

type ParsedContent struct {
	Feedback string `json:"feedback"`
}

// JSONを抽出するための正規表現
var jsonRegex = regexp.MustCompile(`(?s)\{.*\}`)

// JSONを整形して解析する
func extractAndParseJSON(content string) (*ParsedContent, error) {
	// 余分なマークダウンやテキストを取り除く
	content = strings.TrimSpace(content)

	// コードブロックやバッククォートを削除
	content = strings.Replace(content, "```json", "", -1)
	content = strings.Replace(content, "```", "", -1)
	content = strings.Replace(content, "`", "", -1)

	// JSONオブジェクトを抽出
	matches := jsonRegex.FindString(content)
	if matches == "" {
		return nil, fmt.Errorf("no JSON object found in response: %s", content)
	}

	// JSONを解析
	var parsed ParsedContent
	if err := json.Unmarshal([]byte(matches), &parsed); err != nil {
		return nil, fmt.Errorf("invalid JSON format: %w, content: %s", err, matches)
	}

	if parsed.Feedback == "" {
		return nil, fmt.Errorf("feedback field is empty in parsed JSON: %s", matches)
	}

	return &parsed, nil
}

func (s *Service) callAPI(ctx context.Context, targetText, targetPinyin, userText string, userPinyinStr string) (*struct {
	Content string
}, error) {
	client, err := genai.NewClient(ctx, option.WithAPIKey(s.apiKey))
	if err != nil {
		return nil, err
	}
	defer client.Close()

	model := client.GenerativeModel("gemini-2.0-flash")

	prompt := fmt.Sprintf(`
	あなたは中国語音声学の専門家です。目標文とユーザーの発音を拼音化したもの差異を分析し、フィードバックをJSON形式で返してください。このフィードバックはエンドユーザーが直接受け取るものであり、ユーザーが理解できるようにしてください。
	かならず、書き起こしの結果を含めてください。
	例：车展（chēzhǎn）の発音が车长（chē zh**ǎng**）になっています。**ǎn**が**āng**になっており、声調も異なる可能性があるので伝わらないかもしれません。**ǎng**の発音は鼻音で、口を開けたまま息を鼻から出しながら「ん」と発音します
	例：完璧な発音です！车展の発音は難しいので素晴らしいです！（一致した場合）
	必ず日本語でフィードバックを行い、フィードバックに含まれる中国語は簡体字に統一して回答してください。
	Markdown記法は強調のみを使用してください。
	目標文: %s (%s)
	ユーザーの発音: %s (%s)
	以下の形式の有効なJSONのみを返してください。マークダウン記法や追加の説明は含めないでください:
	{
		"feedback": "フィードバック内容"
	}`, targetText, targetPinyin, userText, userPinyinStr)

	resp, err := model.GenerateContent(ctx, genai.Text(prompt))
	if err != nil {
		return nil, err
	}

	var content string
	for _, cand := range resp.Candidates {
		if cand.Content != nil {
			for _, part := range cand.Content.Parts {
				content += fmt.Sprintf("%v", part)
			}
		}
	}

	return &struct {
		Content string
	}{
		Content: content,
	}, nil
}

func (s *Service) GetChineseFeedback(ctx context.Context, targetText, targetPinyin, userText string) (*FeedbackResponse, error) {
	var lastErr error

	for attempt := 1; attempt <= 3; attempt++ {
		userPinyinArr := pinyin.Pinyin(userText, pinyin.NewArgs())
		userPinyinStr := ""
		for _, p := range userPinyinArr {
			userPinyinStr += strings.Join(p, " ") + " "
		}
		userPinyinStr = strings.TrimSpace(userPinyinStr)

		s.logger.Info("Attempting request",
			zap.Int("attempt", attempt),
			zap.String("targetText", targetText),
			zap.String("targetPinyin", targetPinyin),
			zap.String("userText", userText),
			zap.String("userPinyin", userPinyinStr))

		resp, err := s.callAPI(ctx, targetText, targetPinyin, userText, userPinyinStr)
		if err != nil {
			lastErr = err
			s.logger.Warn("API call failed", zap.Error(err))
			time.Sleep(time.Duration(attempt) * time.Second) // 簡単なbackoff
			continue
		}

		s.logger.Debug("Received API response", zap.String("content", resp.Content))

		parsed, err := extractAndParseJSON(resp.Content)
		if err != nil {
			lastErr = err
			s.logger.Warn("JSON parsing failed",
				zap.Error(err),
				zap.String("original_content", resp.Content))
			time.Sleep(time.Duration(attempt) * time.Second)
			continue
		}

		return &FeedbackResponse{
			Feedback: parsed.Feedback,
		}, nil
	}

	return nil, fmt.Errorf("all retries failed: %w", lastErr)
}
