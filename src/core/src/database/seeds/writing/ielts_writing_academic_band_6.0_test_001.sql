-- ============================================================
-- IELTS Practice Platform – Writing Test Seed Data
-- Test Type: Academic
-- Target Band: 6
-- Description: Land Degradation (Task 1) & Fast Food Tax (Task 2)
-- ============================================================

-- NOTE: `created_by` uses a placeholder UUID. After seeding,
-- update it to a real user's auth.uid() so RLS allows access:
-- UPDATE writing_tests SET created_by = '<your-uid>';

-- ████████████████████████████████████████████████████████████
-- ██  WRITING TEST: ACADEMIC (BAND 6)                       ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('f4a35d86-913d-4e7a-9cba-8214087e86e9', 'fe38ed89-f1fe-4b88-9609-8736be47f61e',
 'IELTS Academic Writing: Land Degradation & Fast Food Tax (Band 6)', 'published');

-- ── Task 1: Academic Data Analysis (Single Pie Chart) ────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('edaffced-93d8-4186-9926-4bbc8cf40b5a', 'f4a35d86-913d-4e7a-9cba-8214087e86e9', 1,
 'task1', 'Writing Task 1: Causes of Land Degradation', '6', '20 mins',
 'The pie chart below shows the main reasons why agricultural land becomes less productive globally.

Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
 150, '', '');

-- ── Task 2: Discursive Essay (Agree/Disagree) ────────────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('c8efeaef-e593-4a5d-9e3b-3cdf14bf284e', 'f4a35d86-913d-4e7a-9cba-8214087e86e9', 2,
 'task2', 'Writing Task 2: Tax on Fast Food', '6', '40 mins',
 'In many countries, the amount of fast food consumed has increased significantly. Some people think that the government should impose a higher tax on this kind of food to reduce its consumption and improve public health.

To what extent do you agree or disagree with this opinion?

Give reasons for your answer and include any relevant examples from your own knowledge or experience.',
 250, '', '');

-- ============================================================
-- End of Seed Script
-- ============================================================
