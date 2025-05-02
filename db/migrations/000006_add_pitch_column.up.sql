-- Add pitch column to store pitch analysis results
ALTER TABLE chinese_items
ADD COLUMN pitch FLOAT4[];
