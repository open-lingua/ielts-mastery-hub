-- ============================================================
-- IELTS Practice Platform – Writing Test Seed Data
-- Test Type: Academic
-- Target Band: 9
-- Description: Global Energy Transition (Task 1) & Cognitive Delegation to AI (Task 2)
-- ============================================================

-- NOTE: `created_by` uses a placeholder UUID. After seeding,
-- update it to a real user's auth.uid() so RLS allows access:
-- UPDATE writing_tests SET created_by = '<your-uid>';

-- ████████████████████████████████████████████████████████████
-- ██  WRITING TEST: ACADEMIC (BAND 9)                       ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('fc931ab6-ee2b-41dc-a99a-ee10a4bc80bb', '04704ce2-0d81-4c14-bb7f-af6eebd171ae',
 'IELTS Academic Writing: Global Energy Transition & Cognitive Delegation (Band 9)', 'published');

-- ── Task 1: Academic Data Analysis (Complex Mixed Charts) ────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url, figure_description) VALUES
('7b2f349d-b359-4e57-8c97-fde94bac1716', 'fc931ab6-ee2b-41dc-a99a-ee10a4bc80bb', 1,
 'task1', 'Writing Task 1: Global Energy Production and Transition Projections', '9', '20 mins',
 'The provided infographics illustrate the historical and projected global energy production by source from 2000 to 2050, alongside the corresponding carbon dioxide emissions and the projected financial investments required for the transition to renewable energy.

Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
 150, '', '', 'Three interlinked charts displaying complex energy data. Chart 1: A stacked area graph showing Global Energy Production (2000-2050) in Exajoules (EJ). The x-axis spans 2000 to 2050 in 10-year increments. The y-axis ranges from 0 to 1000 EJ. Categories from bottom to top: Coal (dark grey, peaking at 160 EJ in 2020, declining to 30 EJ by 2050), Oil (black, peaking at 200 EJ in 2025, declining to 80 EJ), Natural Gas (blue, rising to 180 EJ in 2030, then falling to 120 EJ), Nuclear (purple, steady at approximately 50 EJ throughout), and Renewables (green, starting at 40 EJ in 2000, growing exponentially to reach 550 EJ by 2050). Chart 2: A line graph superimposed over the stacked area chart showing total CO2 emissions in Gigatonnes (red line, corresponding to a right-hand y-axis from 0 to 50 Gt), which peaks at 37 Gt in 2025 and plummets to 10 Gt by 2050. Chart 3: A horizontal bar chart located below the main graph showing ''Required Capital Investment by 2050'' in Trillions USD. Categories include: Solar Infrastructure ($25T), Wind Infrastructure ($18T), Grid Modernization ($12T), and Fossil Fuel Decommissioning ($5T).');

-- ── Task 2: Discursive Essay (Discuss Both Views / Abstract Nuance) ────────────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url, figure_description) VALUES
('1c9aa7a2-0d49-42ef-9f05-fe2f54845279', 'fc931ab6-ee2b-41dc-a99a-ee10a4bc80bb', 2,
 'task2', 'Writing Task 2: Cognitive Delegation and Artificial Intelligence', '9', '40 mins',
 'The increasing delegation of cognitive tasks and decision-making processes to artificial intelligence systems has led some sociologists to argue that humanity is facing a fundamental degradation of independent critical thinking and ethical reasoning. Others contend that this delegation liberates human intellect from mundane analysis, allowing for higher-order conceptualisation and unprecedented societal advancement.

Discuss both these views and give your own opinion.

Give reasons for your answer and include any relevant examples from your own knowledge or experience.',
 250, '', '', '');

-- ============================================================
-- End of Seed Script
-- ============================================================
