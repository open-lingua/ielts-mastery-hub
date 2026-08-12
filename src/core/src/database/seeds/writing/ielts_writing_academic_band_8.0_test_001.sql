-- ============================================================
-- IELTS Practice Platform – Writing Test Seed Data
-- Test Type: Academic
-- Target Band: 8
-- Description: High-Tech Exports (Task 1) & AI Automation (Task 2)
-- ============================================================

-- NOTE: `created_by` uses a placeholder UUID. After seeding,
-- update it to a real user's auth.uid() so RLS allows access:
-- UPDATE writing_tests SET created_by = '<your-uid>';

-- ████████████████████████████████████████████████████████████
-- ██  WRITING TEST: ACADEMIC (BAND 8)                       ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('50e2a43c-0861-43c0-8d00-89eff24acb23', 'fe38ed89-f1fe-4b88-9609-8736be47f61e',
 'IELTS Academic Writing: High-Tech Exports & AI Automation (Band 8)', 'published');

-- ── Task 1: Academic Data Synthesis (Bar Chart & Pie Chart) ──

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('ac690e24-f116-4a6a-b88f-467930064dcf', '50e2a43c-0861-43c0-8d00-89eff24acb23', 1,
 'task1', 'Writing Task 1: High-Tech Exports Distribution', '8', '20 mins',
 'The bar chart below shows the total value of high-technology exports from Country A, Country B, and Country C between 2000 and 2020. The pie chart illustrates the distribution of these exports across four distinct sectors (Pharmaceuticals, Aerospace, Telecommunications, and Electronics) for Country B in 2020.

Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
 150, '', '');

-- ── Task 2: Discursive Essay (Discuss Both Views & Opinion) ──

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('ea23452d-0c5c-4c03-9c08-d4b945fbeff2', '50e2a43c-0861-43c0-8d00-89eff24acb23', 2,
 'task2', 'Writing Task 2: AI and Automation in the Workforce', '8', '40 mins',
 'In many countries, the rapid advancement of artificial intelligence and automation has led to significant changes in the workforce. While some argue that these technologies will create unprecedented economic growth and new professional opportunities, others fear they will lead to widespread unemployment and deepen social inequality.

Discuss both these views and give your own opinion.

Give reasons for your answer and include any relevant examples from your own knowledge or experience.',
 250, '', '');

-- ============================================================
-- End of Seed Script
-- ============================================================
