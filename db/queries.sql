-- name: GetChineseItems :many
SELECT * FROM chinese_items
ORDER BY created_at;

-- name: GetLessons :many
SELECT * FROM lessons
ORDER BY created_at;

-- name: GetChineseItemsByLesson :many
SELECT * FROM chinese_items
WHERE lesson_id = $1
ORDER BY created_at;

-- name: GetChineseItemByID :one
SELECT * FROM chinese_items WHERE id = $1;

-- name: CreateLesson :one
INSERT INTO lessons (title, description)
VALUES ($1, $2)
RETURNING *;

-- name: CreateChineseItem :one
INSERT INTO chinese_items (character, pinyin, meaning, lesson_id)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: GetUserByDeviceID :one
SELECT * FROM users 
WHERE device_id = $1 
LIMIT 1;

-- name: CreateAnonymousUser :one
INSERT INTO users (device_id, created_at)
VALUES ($1, $2)
RETURNING *;

-- name: CreateFeedback :one
INSERT INTO feedbacks (user_id, item_id, feedback)
VALUES ($1, $2, $3)
RETURNING *;

-- name: GetFeedbacksByUserAndItem :many
SELECT * FROM feedbacks
WHERE user_id = $1 AND item_id = $2
ORDER BY created_at DESC;

-- name: GetFeedbacks :many
SELECT feedback, created_at FROM feedbacks
WHERE user_id = $1 AND item_id = $2
ORDER BY created_at DESC;

-- name: UpdateChineseItemAudio :one
UPDATE chinese_items
SET audio = $2,
    pitch = $3
WHERE id = $1
RETURNING id, character, pinyin, meaning, created_at, lesson_id, audio, pitch;
