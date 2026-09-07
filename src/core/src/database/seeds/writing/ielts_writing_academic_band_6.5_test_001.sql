-- ============================================================
-- IELTS Practice Platform – Writing Test Seed Data
-- Test Type: Academic
-- Target Band: 6.5
-- Description: Water Consumption (Task 1) & Remote Work (Task 2)
-- ============================================================

-- NOTE: `created_by` uses a placeholder UUID. After seeding,
-- update it to a real user's auth.uid() so RLS allows access:
-- UPDATE writing_tests SET created_by = '<your-uid>';

-- ████████████████████████████████████████████████████████████
-- ██  WRITING TEST: ACADEMIC (BAND 6.5)                     ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('b49499a8-d846-483e-8231-40bacb92aab1', '75f9fcf6-5617-4b05-92ca-794630d32041',
 'IELTS Academic Writing: Water Consumption & Remote Work (Band 6.5)', 'published');

-- ── Task 1: Academic Data Analysis (Line Graph) ────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url, figure_description) VALUES
('629da1fd-518b-4333-aa71-79d58178e86b', 'b49499a8-d846-483e-8231-40bacb92aab1', 1,
 'task1', 'Writing Task 1: Sectoral Water Consumption', '6.5', '20 mins',
 'The line graph below shows the water consumption (in millions of cubic meters) for agriculture, industry, and domestic use in a particular country from 2000 to 2020.

Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
 150, '', '', 'A line graph titled ''Water Consumption by Sector (2000-2020)''. The x-axis represents years in 5-year intervals (2000, 2005, 2010, 2015, 2020). The y-axis represents water consumption in millions of cubic meters, ranging from 0 to 500 in increments of 100. There are three line series: ''Agriculture'' (green line) starting at 300 in 2000, rising steadily to 450 in 2020. ''Industry'' (blue line) starting at 100 in 2000, dipping to 80 in 2005, then rising sharply to 250 in 2020. ''Domestic'' (red line) starting at 50 in 2000, increasing slowly but steadily to reach 120 in 2020. The chart includes a legend at the top right and gridlines for readability.');

-- ── Task 2: Discursive Essay (Advantages / Disadvantages) ────────────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url, figure_description) VALUES
('7614ff9b-de0e-4258-8ac3-e283759ef418', 'b49499a8-d846-483e-8231-40bacb92aab1', 2,
 'task2', 'Writing Task 2: Remote Work Advantages and Disadvantages', '6.5', '40 mins',
 'More and more people are choosing to work remotely rather than commuting to a traditional office environment. 

Do the advantages of this trend outweigh the disadvantages?

Give reasons for your answer and include any relevant examples from your own knowledge or experience.',
 250, '', '', '');

-- ============================================================
-- End of Seed Script
-- ============================================================
