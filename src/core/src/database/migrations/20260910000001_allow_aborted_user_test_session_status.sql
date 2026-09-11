-- Widen the user_test_sessions.status CHECK constraint to allow an explicit
-- terminal "aborted" state (in addition to "in_progress" / "completed").
-- Previously an aborted test could only be removed via DELETE; if that
-- delete failed (e.g. IPC error), the row stayed "in_progress" forever and
-- permanently blocked starting new tests. SQLite does not support altering a
-- CHECK constraint in place, so the table is rebuilt.

PRAGMA foreign_keys=off;

CREATE TABLE user_test_sessions_new (
    id TEXT NOT NULL PRIMARY KEY,
    user_id TEXT NOT NULL,
    test_id TEXT NOT NULL,
    test_type TEXT NOT NULL CHECK (test_type IN ('reading', 'writing', 'listening')),
    status TEXT NOT NULL DEFAULT 'in_progress' CHECK (status IN ('in_progress', 'completed', 'aborted')),
    progress_percent INTEGER NOT NULL DEFAULT 0 CHECK (progress_percent >= 0 AND progress_percent <= 100),
    score_band REAL,
    attempt_number INTEGER NOT NULL DEFAULT 1,
    answers TEXT DEFAULT NULL,
    feedback_data TEXT DEFAULT NULL,
    started_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    completed_at TEXT,
    last_active_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

INSERT INTO user_test_sessions_new
SELECT id, user_id, test_id, test_type, status, progress_percent, score_band,
       attempt_number, answers, feedback_data, started_at, completed_at,
       last_active_at, created_at
FROM user_test_sessions;

DROP TABLE user_test_sessions;
ALTER TABLE user_test_sessions_new RENAME TO user_test_sessions;

CREATE INDEX IF NOT EXISTS idx_user_test_sessions_user_id ON user_test_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_test_sessions_lookup ON user_test_sessions(user_id, test_id, test_type, attempt_number);

PRAGMA foreign_keys=on;
