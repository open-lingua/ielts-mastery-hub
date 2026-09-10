CREATE TABLE IF NOT EXISTS ai_configurations (
  provider_id TEXT PRIMARY KEY NOT NULL,
  is_active INTEGER NOT NULL DEFAULT 0,
  credentials_json TEXT NOT NULL DEFAULT '',
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
