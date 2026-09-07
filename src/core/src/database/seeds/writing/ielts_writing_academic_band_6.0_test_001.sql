-- ============================================================
-- IELTS Practice Platform – Writing Test Seed Data
-- Test Type: Academic
-- Target Band: 6
-- Description: University Enrollment (Task 1) & Free University Education (Task 2)
-- ============================================================

-- NOTE: `created_by` uses a placeholder UUID. After seeding,
-- update it to a real user's auth.uid() so RLS allows access:
-- UPDATE writing_tests SET created_by = '<your-uid>';

-- ████████████████████████████████████████████████████████████
-- ██  WRITING TEST: ACADEMIC (BAND 6)                       ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('c7e68c96-589d-4ed0-8223-da0825b86abb', '8dae9222-5c27-44b4-9438-e7b75ccc8cf2',
 'IELTS Academic Writing: University Enrollment & Free Education (Band 6)', 'published');

-- ── Task 1: Academic Data Analysis (Bar Chart) ────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url, figure_description) VALUES
('bd89c04d-0a4f-42f5-9f07-96e98bc45a74', 'c7e68c96-589d-4ed0-8223-da0825b86abb', 1,
 'task1', 'Writing Task 1: University Enrollment by Gender', '6', '20 mins',
 'The bar chart below shows the percentage of male and female students enrolled in three different degree courses at a university in 2020.

Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
 150, '', '', 'A clustered bar chart titled ''Student Enrollment by Course and Gender, 2020''. The x-axis shows three degree courses: ''Engineering'', ''Arts'', and ''Science''. The y-axis represents the percentage of total students, ranging from 0% to 100% in increments of 10. There are two data series: ''Male'' (blue bars) and ''Female'' (red bars). Data points: Engineering: Male 70%, Female 30%. Arts: Male 25%, Female 75%. Science: Male 55%, Female 45%.');

-- ── Task 2: Discursive Essay (Discuss Both Views) ────────────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url, figure_description) VALUES
('84d5a81a-276d-470d-bd60-9eafd59d2f4f', 'c7e68c96-589d-4ed0-8223-da0825b86abb', 2,
 'task2', 'Writing Task 2: Free University Education', '6', '40 mins',
 'Some people believe that university education should be free for everyone, while others think that students should pay for their higher education.

Discuss both these views and give your own opinion.

Give reasons for your answer and include any relevant examples from your own knowledge or experience.',
 250, '', '', '');

-- ============================================================
-- End of Seed Script
-- ============================================================
