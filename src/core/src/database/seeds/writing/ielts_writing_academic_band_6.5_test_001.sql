-- ============================================================
-- IELTS Practice Platform – Writing Test Seed Data
-- Test Type: Academic
-- Target Band: 6.5
-- Description: Sports Participation (Task 1) & City Life (Task 2)
-- ============================================================

-- NOTE: `created_by` uses a placeholder UUID. After seeding,
-- update it to a real user's auth.uid() so RLS allows access:
-- UPDATE writing_tests SET created_by = '<your-uid>';

-- ████████████████████████████████████████████████████████████
-- ██  WRITING TEST: ACADEMIC (BAND 6.5)                     ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('f2c32a8c-ecc9-415f-80b0-b3dc6dccd668', 'fe38ed89-f1fe-4b88-9609-8736be47f61e',
 'IELTS Academic Writing: Sports Participation & Challenges of City Life (Band 6.5)', 'published');

-- ── Task 1: Academic Data Analysis (Bar Chart) ──────────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('5f2a310e-4d25-4fb3-8c2d-01549ca2cdcf', 'f2c32a8c-ecc9-415f-80b0-b3dc6dccd668', 1,
 'task1', 'Writing Task 1: Sports Participation by Age', '6.5', '20 mins',
 'The bar chart below shows the percentage of people in three different age groups (15-24, 25-44, and 45-64) who participated in five different sports in a European country in 2022.

Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
 150, '', '');

-- ── Task 2: Discursive Essay (Causes and Solutions) ──────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('4cf29f91-5f59-42d2-8fda-b6f9255a2833', 'f2c32a8c-ecc9-415f-80b0-b3dc6dccd668', 2,
 'task2', 'Writing Task 2: The Challenges of Urbanization', '6.5', '40 mins',
 'More and more people are migrating to cities in search of a better life, but city life can be extremely difficult. 

Explain some of the main difficulties of living in a city. How can governments make urban life better for everyone?

Give reasons for your answer and include any relevant examples from your own knowledge or experience.',
 250, '', '');

-- ============================================================
-- End of Seed Script
-- ============================================================
