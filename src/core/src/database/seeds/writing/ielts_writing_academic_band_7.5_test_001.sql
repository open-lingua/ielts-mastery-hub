-- ============================================================
-- IELTS Practice Platform – Writing Test Seed Data
-- Test Type: Academic
-- Target Band: 7.5
-- Description: Student Enrollment & Retention (Task 1) and AI in High-Skilled Jobs (Task 2)
-- ============================================================

-- NOTE: `created_by` uses a placeholder UUID. After seeding,
-- update it to a real user's auth.uid() so RLS allows access:
-- UPDATE writing_tests SET created_by = '<your-uid>';

-- ████████████████████████████████████████████████████████████
-- ██  WRITING TEST: ACADEMIC (BAND 7.5)                     ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('321dfd2f-5307-44d7-a9c4-50122dd14cb4', '51f36519-cc94-4ffa-bd0c-ff0a1f20d1b3',
 'IELTS Academic Writing: Student Enrollment & AI in High-Skilled Jobs (Band 7.5)', 'published');

-- ── Task 1: Academic Data Analysis (Mixed Charts: Bar & Line) ────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url, figure_description) VALUES
('0ae6b9c7-5bd8-49a6-a22c-5114ce53173e', '321dfd2f-5307-44d7-a9c4-50122dd14cb4', 1,
 'task1', 'Writing Task 1: International Student Enrollment and Graduate Retention', '7.5', '20 mins',
 'The bar chart below shows the number of international students enrolled in universities in three different countries from 2010 to 2020. The line graph illustrates the percentage of these students who secured employment and remained in those countries after graduation over the same period.

Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
 150, '', '', 'Two charts placed side-by-side. The first chart is a clustered bar chart titled ''International Student Enrollment (2010-2020)''. The x-axis shows three years: 2010, 2015, and 2020. The y-axis shows the number of students in thousands, ranging from 0 to 500. There are three countries represented by different colored bars: Country A (blue), Country B (green), and Country C (orange). Data: In 2010, Country A had 150k, Country B had 200k, and Country C had 100k. In 2015, Country A had 250k, Country B had 220k, and Country C had 300k. In 2020, Country A had 400k, Country B had 250k, and Country C had 450k. The second chart is a line graph titled ''Graduate Retention Rates (2010-2020)''. The x-axis matches the bar chart (2010, 2015, 2020). The y-axis shows percentages from 0% to 100%. Three lines correspond to the same three countries. Data: Country A (blue line) starts at 30% in 2010, dips to 25% in 2015, and rises to 45% in 2020. Country B (green line) starts at 50%, remains steady at 50% in 2015, and drops to 35% in 2020. Country C (orange line) starts at 20%, rises sharply to 60% in 2015, and reaches 75% in 2020.');

-- ── Task 2: Discursive Essay (Discuss Both Views and Give Opinion) ────────────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url, figure_description) VALUES
('9e0008e6-230d-4822-b8cd-a6e7fe73e274', '321dfd2f-5307-44d7-a9c4-50122dd14cb4', 2,
 'task2', 'Writing Task 2: AI and Automation in High-Skilled Professions', '7.5', '40 mins',
 'In recent years, advancements in artificial intelligence and automation have begun to impact not only manual labour but also high-skilled professions such as medicine, law, and engineering. 

Some argue that this will lead to unprecedented unemployment among professionals, while others believe it will enhance their capabilities and create new types of highly specialized roles.

Discuss both these views and give your own opinion.

Give reasons for your answer and include any relevant examples from your own knowledge or experience.',
 250, '', '', '');

-- ============================================================
-- End of Seed Script
-- ============================================================
