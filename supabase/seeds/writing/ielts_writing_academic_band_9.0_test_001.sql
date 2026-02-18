-- ============================================================
-- IELTS Practice Platform – Writing Test Seed Data
-- Test Type: Academic
-- Target Band: 9
-- Description: Carbon Capture Process (Task 1) & Scientific Priorities (Task 2)
-- ============================================================

-- NOTE: `created_by` uses a placeholder UUID. After seeding,
-- update it to a real user's auth.uid() so RLS allows access:
-- UPDATE writing_tests SET created_by = '<your-uid>';

-- ████████████████████████████████████████████████████████████
-- ██  WRITING TEST: ACADEMIC (BAND 9)                       ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('b3f12cc8-0b95-4315-bfb2-06e866bbcbfc', 'fe38ed89-f1fe-4b88-9609-8736be47f61e',
 'IELTS Academic Writing: Carbon Capture Process & Scientific Priorities (Band 9)', 'published');

-- ── Task 1: Academic Process Diagram Description ─────────────

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('ab235efc-98b3-4aff-bede-170aab8ea54c', 'b3f12cc8-0b95-4315-bfb2-06e866bbcbfc', 1,
 'task1', 'Writing Task 1: Carbon Capture and Storage (CCS) Process', '9', '20 mins',
 'The diagram below illustrates the technical process of Carbon Capture and Storage (CCS), which is designed to reduce greenhouse gas emissions from industrial power plants by capturing carbon dioxide and storing it deep underground.

Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
 150, '', '');

-- ── Task 2: Discursive Essay (To what extent do you agree?) ──

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('be22c111-4e35-49f6-b36b-ff901eeed3d9', 'b3f12cc8-0b95-4315-bfb2-06e866bbcbfc', 2,
 'task2', 'Writing Task 2: Priorities of Scientific Research', '9', '40 mins',
 'Some experts argue that the fundamental aim of all scientific research should be dedicated entirely to the protection and regeneration of the natural environment, rather than the pursuit of commercial profit or isolated technological advancement.

To what extent do you agree or disagree with this statement?

Give reasons for your answer and include any relevant examples from your own knowledge or experience.',
 250, '', '');

-- ============================================================
-- End of Seed Script
-- ============================================================
