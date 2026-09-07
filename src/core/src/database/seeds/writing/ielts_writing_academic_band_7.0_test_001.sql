-- ============================================================
-- IELTS Practice Platform – Writing Test Seed Data
-- Test Type: Academic
-- Target Band: 7
-- Description: Geothermal Energy Process (Task 1) & Space Exploration (Task 2)
-- ============================================================

-- NOTE: `created_by` uses a placeholder UUID. After seeding,
-- update it to a real user's auth.uid() so RLS allows access:
-- UPDATE writing_tests SET created_by = '<your-uid>';

-- ████████████████████████████████████████████████████████████
-- ██  WRITING TEST: ACADEMIC (BAND 7)                       ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('596bd5cf-53ba-407d-bb35-6152f275f2d1', 'cd57c079-40aa-4311-ac9e-1796407191b5',
 'IELTS Academic Writing: Geothermal Energy & Space Exploration (Band 7)', 'published');

-- ── Task 1: Academic Data Analysis (Process Diagram) ────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url, figure_description) VALUES
('5fc33d1f-35ed-47d6-9fac-e14b7fb83ed2', '596bd5cf-53ba-407d-bb35-6152f275f2d1', 1,
 'task1', 'Writing Task 1: Geothermal Power Plant Process', '7', '20 mins',
 'The diagram below shows how geothermal energy is used to produce electricity.

Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
 150, '', '', 'A detailed schematic diagram illustrating the process of generating electricity in a geothermal power plant. The diagram features a continuous, closed-loop system. On the left side, at the surface level, a pump forces cold water down a deep pipe into an ''Injection Well''. Below ground, this pipe reaches a ''Geothermal Zone'' composed of hot rocks. As the water passes through this zone, it is heated and turns into a mixture of hot water and steam. This heated mixture rises back to the surface through a second pipe called a ''Production Well''. At the surface, the steam enters a ''Condenser/Separator'', where steam is separated from water. The high-pressure steam is directed into a ''Turbine'', causing its blades to spin. The spinning turbine is mechanically connected to a ''Generator'', which produces electricity. This electricity is then sent out to the electrical grid via ''Transmission Lines''. Finally, the leftover water from the separator and the condensed steam from the turbine are routed back to the initial pump to be sent down the injection well, restarting the cycle. Directional arrows clearly indicate the flow of water and steam throughout the entire process.');

-- ── Task 2: Discursive Essay (Agree/Disagree) ────────────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url, figure_description) VALUES
('0d29daa9-a425-4da0-9fc3-1e4ac332f3ff', '596bd5cf-53ba-407d-bb35-6152f275f2d1', 2,
 'task2', 'Writing Task 2: Funding for Space Exploration', '7', '40 mins',
 'In the future, it seems it will be increasingly difficult to sustain human life on Earth due to environmental degradation and resource depletion. Some people think that governments should allocate more funding to researching other planets to live on, such as Mars.

To what extent do you agree or disagree with this statement?

Give reasons for your answer and include any relevant examples from your own knowledge or experience.',
 250, '', '', '');

-- ============================================================
-- End of Seed Script
-- ============================================================
