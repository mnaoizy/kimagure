-- Add lessons table
CREATE TABLE lessons (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Add lesson_id to chinese_items
ALTER TABLE chinese_items ADD COLUMN lesson_id INTEGER REFERENCES lessons(id) DEFAULT 1;