CREATE TABLE IF NOT EXISTS profiles (
    id TEXT NOT NULL PRIMARY KEY,
    full_name TEXT,
    avatar_url TEXT,
    plan_type TEXT NOT NULL DEFAULT 'free' CHECK (plan_type IN ('free', 'premium')),
    email TEXT,
    is_banned INTEGER NOT NULL DEFAULT 0,
    ban_reason TEXT,
    banned_until TEXT,
    updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

CREATE INDEX IF NOT EXISTS idx_profiles_email ON profiles(email);

CREATE TABLE IF NOT EXISTS user_roles (
    id TEXT NOT NULL PRIMARY KEY,
    user_id TEXT NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('student', 'super_admin')),
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    UNIQUE (user_id, role)
);

CREATE TABLE IF NOT EXISTS reading_tests (
    id TEXT NOT NULL PRIMARY KEY,
    created_by TEXT NOT NULL,
    title TEXT NOT NULL DEFAULT '',
    test_type TEXT NOT NULL DEFAULT 'Academic',
    difficulty TEXT NOT NULL DEFAULT '7',
    duration TEXT NOT NULL DEFAULT '60 mins',
    status TEXT NOT NULL DEFAULT 'draft',
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

CREATE INDEX IF NOT EXISTS idx_reading_tests_created_by ON reading_tests(created_by);

CREATE TABLE IF NOT EXISTS reading_passages (
    id TEXT NOT NULL PRIMARY KEY,
    test_id TEXT NOT NULL REFERENCES reading_tests(id) ON DELETE CASCADE,
    passage_number INTEGER NOT NULL DEFAULT 1,
    title TEXT NOT NULL DEFAULT '',
    content TEXT NOT NULL DEFAULT '',
    notes TEXT DEFAULT '',
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

CREATE INDEX IF NOT EXISTS idx_reading_passages_test_id ON reading_passages(test_id);

CREATE TABLE IF NOT EXISTS reading_question_groups (
    id TEXT NOT NULL PRIMARY KEY,
    passage_id TEXT NOT NULL REFERENCES reading_passages(id) ON DELETE CASCADE,
    group_order INTEGER NOT NULL DEFAULT 0,
    question_type TEXT NOT NULL DEFAULT 'multiple-choice',
    instructions TEXT NOT NULL DEFAULT '',
    word_limit TEXT DEFAULT '',
    has_word_bank INTEGER NOT NULL DEFAULT 0,
    word_bank TEXT NOT NULL DEFAULT '[]',
    sequential_order INTEGER NOT NULL DEFAULT 1,
    multiple_selection INTEGER NOT NULL DEFAULT 0,
    select_count INTEGER NOT NULL DEFAULT 1,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

CREATE INDEX IF NOT EXISTS idx_reading_question_groups_passage_id ON reading_question_groups(passage_id);

CREATE TABLE IF NOT EXISTS reading_questions (
    id TEXT NOT NULL PRIMARY KEY,
    group_id TEXT NOT NULL REFERENCES reading_question_groups(id) ON DELETE CASCADE,
    question_order INTEGER NOT NULL DEFAULT 0,
    text TEXT NOT NULL DEFAULT '',
    answer TEXT DEFAULT '',
    options TEXT NOT NULL DEFAULT '[]',
    matching_pairs TEXT NOT NULL DEFAULT '[]',
    completion_gaps TEXT NOT NULL DEFAULT '[]',
    accepted_answers TEXT NOT NULL DEFAULT '[]',
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

CREATE INDEX IF NOT EXISTS idx_reading_questions_group_id ON reading_questions(group_id);

CREATE TABLE IF NOT EXISTS writing_tests (
    id TEXT NOT NULL PRIMARY KEY,
    created_by TEXT NOT NULL,
    title TEXT NOT NULL DEFAULT '',
    status TEXT NOT NULL DEFAULT 'draft',
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

CREATE INDEX IF NOT EXISTS idx_writing_tests_created_by ON writing_tests(created_by);

CREATE TABLE IF NOT EXISTS writing_tasks (
    id TEXT NOT NULL PRIMARY KEY,
    test_id TEXT NOT NULL REFERENCES writing_tests(id) ON DELETE CASCADE,
    task_number INTEGER NOT NULL DEFAULT 1,
    task_type TEXT NOT NULL DEFAULT 'task1',
    title TEXT NOT NULL DEFAULT '',
    difficulty TEXT NOT NULL DEFAULT '7',
    suggested_time TEXT NOT NULL DEFAULT '20 mins',
    prompt TEXT NOT NULL DEFAULT '',
    min_words INTEGER NOT NULL DEFAULT 150,
    max_words TEXT DEFAULT '',
    image_url TEXT DEFAULT '',
    include_model_answer INTEGER NOT NULL DEFAULT 0,
    model_answer TEXT DEFAULT '',
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

CREATE INDEX IF NOT EXISTS idx_writing_tasks_test_id ON writing_tasks(test_id);

CREATE TABLE IF NOT EXISTS listening_tests (
    id TEXT NOT NULL PRIMARY KEY,
    created_by TEXT NOT NULL,
    title TEXT NOT NULL DEFAULT '',
    difficulty TEXT NOT NULL DEFAULT '7',
    duration TEXT NOT NULL DEFAULT '40 mins',
    status TEXT NOT NULL DEFAULT 'draft',
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

CREATE INDEX IF NOT EXISTS idx_listening_tests_created_by ON listening_tests(created_by);

CREATE TABLE IF NOT EXISTS listening_sections (
    id TEXT NOT NULL PRIMARY KEY,
    test_id TEXT NOT NULL REFERENCES listening_tests(id) ON DELETE CASCADE,
    section_number INTEGER NOT NULL DEFAULT 1,
    title TEXT NOT NULL DEFAULT '',
    transcript TEXT DEFAULT '',
    audio_url TEXT DEFAULT '',
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

CREATE INDEX IF NOT EXISTS idx_listening_sections_test_id ON listening_sections(test_id);

CREATE TABLE IF NOT EXISTS listening_question_groups (
    id TEXT NOT NULL PRIMARY KEY,
    section_id TEXT NOT NULL REFERENCES listening_sections(id) ON DELETE CASCADE,
    group_order INTEGER NOT NULL DEFAULT 0,
    question_type TEXT NOT NULL DEFAULT 'multiple-choice',
    instructions TEXT NOT NULL DEFAULT '',
    word_limit TEXT DEFAULT '',
    has_word_bank INTEGER NOT NULL DEFAULT 0,
    word_bank TEXT NOT NULL DEFAULT '[]',
    sequential_order INTEGER NOT NULL DEFAULT 1,
    multiple_selection INTEGER NOT NULL DEFAULT 0,
    select_count INTEGER NOT NULL DEFAULT 1,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

CREATE INDEX IF NOT EXISTS idx_listening_question_groups_section_id ON listening_question_groups(section_id);

CREATE TABLE IF NOT EXISTS listening_questions (
    id TEXT NOT NULL PRIMARY KEY,
    group_id TEXT NOT NULL REFERENCES listening_question_groups(id) ON DELETE CASCADE,
    question_order INTEGER NOT NULL DEFAULT 0,
    text TEXT NOT NULL DEFAULT '',
    answer TEXT DEFAULT '',
    options TEXT NOT NULL DEFAULT '[]',
    matching_pairs TEXT NOT NULL DEFAULT '[]',
    completion_gaps TEXT NOT NULL DEFAULT '[]',
    accepted_answers TEXT NOT NULL DEFAULT '[]',
    timestamp TEXT DEFAULT '',
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

CREATE INDEX IF NOT EXISTS idx_listening_questions_group_id ON listening_questions(group_id);

CREATE TABLE IF NOT EXISTS user_test_sessions (
    id TEXT NOT NULL PRIMARY KEY,
    user_id TEXT NOT NULL,
    test_id TEXT NOT NULL,
    test_type TEXT NOT NULL CHECK (test_type IN ('reading', 'writing', 'listening')),
    status TEXT NOT NULL DEFAULT 'in_progress' CHECK (status IN ('in_progress', 'completed')),
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

CREATE INDEX IF NOT EXISTS idx_user_test_sessions_user_id ON user_test_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_test_sessions_lookup ON user_test_sessions(user_id, test_id, test_type, attempt_number);
