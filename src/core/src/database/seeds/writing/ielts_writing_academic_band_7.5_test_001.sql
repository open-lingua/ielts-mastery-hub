-- ============================================================
-- IELTS Practice Platform – Writing Test Seed Data
-- Test Type: Academic
-- Target Band: 7.5
-- Description: Energy Consumption Trends (Task 1) & Space Exploration (Task 2)
-- ============================================================

-- NOTE: `created_by` uses a placeholder UUID. After seeding,
-- update it to a real user's auth.uid() so RLS allows access:
-- UPDATE writing_tests SET created_by = '<your-uid>';

-- ████████████████████████████████████████████████████████████
-- ██  WRITING TEST: ACADEMIC (BAND 7.5)                     ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('034fa0d8-422c-41f2-99c2-6f5ac7519c32', 'fe38ed89-f1fe-4b88-9609-8736be47f61e',
 'IELTS Academic Writing: Energy Consumption & Space Exploration (Band 7.5)', 'published');

-- ── Task 1: Academic Data Analysis (Line Graph with Projections) ──

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('c8b82628-2ea3-40e2-9315-2a7f311d7b08', '034fa0d8-422c-41f2-99c2-6f5ac7519c32', 1,
 'task1', 'Writing Task 1: Historical and Projected Energy Consumption', '7.5', '20 mins',
 'The line graph below shows the actual and projected energy consumption by fuel type (coal, oil, natural gas, renewable energy, and nuclear power) in a particular country from 1980 to 2030.

Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
 150, '', '');

-- ── Task 2: Discursive Essay (To what extent do you agree?) ──

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('38705acf-0c9c-451b-9ad4-068127d68801', '034fa0d8-422c-41f2-99c2-6f5ac7519c32', 2,
 'task2', 'Writing Task 2: Funding for Space Exploration', '7.5', '40 mins',
 'Some people believe that governments are spending too much money on space exploration and that these funds should instead be allocated to solving urgent problems on Earth, such as poverty and environmental degradation.

To what extent do you agree or disagree with this statement?

Give reasons for your answer and include any relevant examples from your own knowledge or experience.',
 250, '', '');

-- ============================================================
-- End of Seed Script
-- ============================================================
