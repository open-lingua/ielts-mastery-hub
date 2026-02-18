-- ============================================================
-- IELTS Practice Platform – Writing Test Seed Data
-- Test Type: Academic
-- Target Band: 7
-- Description: Tourist Transport Trends (Task 1) & Remote Work (Task 2)
-- ============================================================

-- NOTE: `created_by` uses a placeholder UUID. After seeding,
-- update it to a real user's auth.uid() so RLS allows access:
-- UPDATE writing_tests SET created_by = '<your-uid>';

-- ████████████████████████████████████████████████████████████
-- ██  WRITING TEST: ACADEMIC (BAND 7)                       ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('79dced6a-55f6-445c-8192-0f5d60d4546a', 'fe38ed89-f1fe-4b88-9609-8736be47f61e',
 'IELTS Academic Writing: Tourist Transport Trends & Remote Work (Band 7)', 'published');

-- ── Task 1: Academic Data Analysis (Line Graph) ──────────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('69af1b06-9a5d-4ac7-8a26-8b89b4171f3d', '79dced6a-55f6-445c-8192-0f5d60d4546a', 1,
 'task1', 'Writing Task 1: Tourist Transport Trends', '7', '20 mins',
 'The line graph below shows the percentage of tourists using three different modes of transport (train, car, and flying) to travel within a particular European country between 2000 and 2020.

Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
 150, '', '');

-- ── Task 2: Discursive Essay (Agree/Disagree) ────────────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('9f7307a6-0d4e-443a-92c0-a8a04779faeb', '79dced6a-55f6-445c-8192-0f5d60d4546a', 2,
 'task2', 'Writing Task 2: The Impact of Remote Work', '7', '40 mins',
 'An increasing number of professionals are now working from home rather than commuting to a central office. Some people argue that this trend has a negative impact on both employees and employers.

To what extent do you agree or disagree?

Give reasons for your answer and include any relevant examples from your own knowledge or experience.',
 250, '', '');

-- ============================================================
-- End of Seed Script
-- ============================================================
