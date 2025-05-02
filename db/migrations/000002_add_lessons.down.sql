-- Remove lesson_id from chinese_items
ALTER TABLE chinese_items DROP COLUMN lesson_id;

-- Remove lessons table
DROP TABLE lessons;
