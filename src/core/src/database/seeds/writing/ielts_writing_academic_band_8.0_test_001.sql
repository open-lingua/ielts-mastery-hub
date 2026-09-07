-- ============================================================
-- IELTS Practice Platform – Writing Test Seed Data
-- Test Type: Academic
-- Target Band: 8
-- Description: Government Expenditure (Task 1) & Modernization of Family Structures (Task 2)
-- ============================================================

-- NOTE: `created_by` uses a placeholder UUID. After seeding,
-- update it to a real user's auth.uid() so RLS allows access:
-- UPDATE writing_tests SET created_by = '<your-uid>';

-- ████████████████████████████████████████████████████████████
-- ██  WRITING TEST: ACADEMIC (BAND 8)                       ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('b683cf92-eb33-4600-ac58-1057cee2da87', '046670db-a454-4b91-97a2-1de5a5d63f71',
 'IELTS Academic Writing: Government Expenditure & Family Structures (Band 8)', 'published');

-- ── Task 1: Academic Data Analysis (Mixed Data: Table & Pie Chart) ────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url, figure_description) VALUES
('1d7b83aa-314c-4418-89bf-c79f8e66a196', 'b683cf92-eb33-4600-ac58-1057cee2da87', 1,
 'task1', 'Writing Task 1: Government Expenditure by Sector', '8', '20 mins',
 'The table below shows government expenditure on various sectors (Education, Healthcare, Infrastructure, and Defense) in five different countries in 2022 as a percentage of total GDP. The pie chart illustrates the global average expenditure across these same sectors for the same year.

Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
 150, '', '', 'Two figures are presented. The first is a table titled ''Government Expenditure by Sector (2022)''. The columns represent four sectors: ''Education'', ''Healthcare'', ''Infrastructure'', and ''Defense'', with values given as a percentage of total GDP. The rows correspond to five countries: Country A (Education: 5.2%, Healthcare: 8.1%, Infrastructure: 2.3%, Defense: 1.5%), Country B (Education: 6.0%, Healthcare: 9.5%, Infrastructure: 3.1%, Defense: 2.0%), Country C (Education: 4.1%, Healthcare: 6.2%, Infrastructure: 4.5%, Defense: 3.8%), Country D (Education: 7.3%, Healthcare: 10.2%, Infrastructure: 1.8%, Defense: 1.1%), and Country E (Education: 3.5%, Healthcare: 5.0%, Infrastructure: 5.5%, Defense: 4.2%). The second figure is a pie chart titled ''Global Average Expenditure (2022)''. It displays four distinct colored slices showing the global average distribution: Healthcare (Blue slice) at 35%, Education (Green slice) at 30%, Infrastructure (Orange slice) at 20%, and Defense (Red slice) at 15%.');

-- ── Task 2: Discursive Essay (Discuss Both Views and Give Opinion) ────────────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url, figure_description) VALUES
('1c601d5a-e727-4be8-a58b-7c95bd039ce4', 'b683cf92-eb33-4600-ac58-1057cee2da87', 2,
 'task2', 'Writing Task 2: Modernization and Traditional Family Structures', '8', '40 mins',
 'In contemporary society, some sociologists argue that rapid economic development and urbanization inevitably lead to the erosion of traditional family structures and values. Conversely, others maintain that modernization merely transforms these structures, ultimately strengthening familial bonds in novel ways.

Discuss both these views and give your own opinion.

Give reasons for your answer and include any relevant examples from your own knowledge or experience.',
 250, '', '', '');

-- ============================================================
-- End of Seed Script
-- ============================================================
