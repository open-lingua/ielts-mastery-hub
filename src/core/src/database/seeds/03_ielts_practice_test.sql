-- ============================================================
-- IELTS Practice Platform – Comprehensive Seed Data (Test 3)
-- VERSION FINAL: UUIDs validados y sin duplicados
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  1. READING TEST 3 – ALL QUESTION TYPES (40 questions)    ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('6b2c9e10-4d5e-4a3b-9c8d-1e2f3a4b5c6d', '80f68d7a-1b4e-4f92-9c3a-23456789abcd',
 'IELTS Academic Reading Practice Test 3', 'Academic', '7', '60 mins', 'published');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: The Birth of the Underground (Q1–13)        ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('7f8a9b0c-d1e2-4f3a-b4c5-d6e7f8a9b0c1', '6b2c9e10-4d5e-4a3b-9c8d-1e2f3a4b5c6d', 1,
 'The Birth of the London Underground',
 '(A) In the first half of the 19th century, London''s population grew at an astonishing rate... (B) The solution was proposed by Charles Pearson... (C) On January 10, 1863... (D) The true revolution... (E) As the network expanded...');

-- ── Group 23: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', '7f8a9b0c-d1e2-4f3a-b4c5-d6e7f8a9b0c1', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the passage? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d1e2f3a4-b5c6-4d7e-8f9a-0b1c2d3e4f5a', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 1, 'Main-line railways in the 1850s...', 'FALSE', '["FALSE","False","false"]'),
('f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 2, 'Charles Pearson personally funded...', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 3, 'The first underground trains...', 'TRUE', '["TRUE","True","true"]'),
('c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 4, 'The nickname "Tube" originated...', 'TRUE', '["TRUE","True","true"]');

-- ── Group 24: SHORT ANSWER (Q5–8) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', '7f8a9b0c-d1e2-4f3a-b4c5-d6e7f8a9b0c1', 2,
 'short-answer', 'Answer the questions below...', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 'e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 5, 'What construction method...', 'cut-and-cover', '[{"id":"1","text":"cut-and-cover"}]'),
('c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 'e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 6, 'How many passengers...', '38,000', '[{"id":"1","text":"38,000"}]'),
('e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 'e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 7, 'What equipment was used...', 'tunneling shield', '[{"id":"1","text":"tunneling shield"}]'),
('a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 'e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 8, 'What is the specific name...', 'roundel', '[{"id":"1","text":"roundel"}]');

-- ── Group 25: TABLE COMPLETION (Q9–13) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', '7f8a9b0c-d1e2-4f3a-b4c5-d6e7f8a9b0c1', 3,
 'table-completion', 'Complete the table below...', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 9, 'Row 1', '', '[{"id":"h1","gapText":"Year"}]'),
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 10, 'Row 2', '', '[{"id":"c1","gapText":"1860"}]'),
('c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 11, 'Row 3', '', '[{"id":"c3","gapText":"1890"}]'),
('e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 12, 'Row 4', '', '[{"id":"c5","gapText":"1908"}]'),
('a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 13, 'Row 5', '', '[{"id":"c7","gapText":"1933"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Vertical Farming (Q14–27)                   ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', '6b2c9e10-4d5e-4a3b-9c8d-1e2f3a4b5c6d', 2,
 'Vertical Farming: The Next Agricultural Revolution?', '...');

-- ── Group 26: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 1,
 'matching-headings', 'Choose the correct heading...', true, true, '["i. ...", "ii. ..."]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 'e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 14, 'Paragraph A', 'v'),
('c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 'e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 15, 'Paragraph B', 'ii'),
('f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 'e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 16, 'Paragraph C', 'vi'),
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 17, 'Paragraph D', 'i'),
('c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 'e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 18, 'Paragraph E', 'iv'),
('e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 'e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 19, 'Paragraph F', 'iii');

-- ── Group 27: MATCHING INFORMATION (Q20–23) ── (FIXED IDs) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 2,
 'matching-information', 'Which paragraph contains...', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 20, 'Reference to a method...', 'B', '[{"id":"1","right":"A"}]'),
('e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 21, 'An explanation of why...', 'E', '[{"id":"1","right":"A"}]'),
('a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 22, 'A statistic indicating...', 'A', '[{"id":"1","right":"A"}]'),
('c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 23, 'The reason why chemical...', 'C', '[{"id":"1","right":"A"}]');

-- ── Group 28: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 3,
 'multiple-choice', 'Choose the correct letter...', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 24, 'According to Paragraph C...', 'B', '[{"id":"B","text":"..."}]'),
('c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 'f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 25, 'The writer suggests...', 'C', '[{"id":"C","text":"..."}]'),
('e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 'f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 26, 'What is currently...', 'D', '[{"id":"D","text":"..."}]'),
('a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 'f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 27, 'What does the phrase...', 'A', '[{"id":"A","text":"..."}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: Biomimicry (Q28–40)                         ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b3c4d5e6-f7a8-4b9c-0d1e-2f3a4b5c6d7e', '6b2c9e10-4d5e-4a3b-9c8d-1e2f3a4b5c6d', 3,
 'Biomimicry: Engineering Inspired by Nature', '...');

-- ── Group 29: YES/NO/NOT GIVEN (Q28–32) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 'b3c4d5e6-f7a8-4b9c-0d1e-2f3a4b5c6d7e', 1,
 'yes-no-not-given', 'Do the following statements...', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 28, 'Janine Benyus...', 'NO', '["NO"]'),
('a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 29, 'George de Mestral...', 'YES', '["YES"]'),
('c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 30, 'The original bullet...', 'NOT GIVEN', '["NOT GIVEN"]'),
('f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 31, 'Sharklet surfaces...', 'NO', '["NO"]'),
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 32, 'The Eastgate Centre...', 'NO', '["NO"]');

-- ── Group 30: MATCHING SENTENCE ENDINGS (Q33–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 'b3c4d5e6-f7a8-4b9c-0d1e-2f3a4b5c6d7e', 2,
 'matching-sentence-endings', 'Complete each sentence...', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 'c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 33, 'The Shinkansen train...', 'E', '[{"id":"E","text":"..."}]'),
('a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 'c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 34, 'The unique micro-texture...', 'B', '[{"id":"B","text":"..."}]'),
('c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 'c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 35, 'The ventilation system...', 'C', '[{"id":"C","text":"..."}]');

-- ── Group 31: SUMMARY COMPLETION (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 'b3c4d5e6-f7a8-4b9c-0d1e-2f3a4b5c6d7e', 3,
 'summary-completion', 'Complete the summary...', true, true, '["burrs","speed","kingfisher","passive","chemicals","waste","shark"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 'e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 36, 'Biomimicry looks to nature...', 'burrs'),
('c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 'e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 37, '', 'kingfisher'),
('f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 'e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 38, '', 'shark'),
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 39, '', 'chemicals'),
('c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 'e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 40, '', 'passive');


-- ████████████████████████████████████████████████████████████
-- ██  2. LISTENING TEST 3                                   ██
-- ████████████████████████████████████████████████████████████

INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status) VALUES
('b3c4d5e6-a7b8-4c9d-e0f1-a2b3c4d5e6f7', '80f68d7a-1b4e-4f92-9c3a-23456789abcd',
 'IELTS Listening Practice Test 3', '7', '40 mins', 'published');

-- ── Section 1: Walking Tour Booking ─────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('e7f8a9b0-c1d2-4e3f-a4b5-6c7d8e9f0a1b', 'b3c4d5e6-a7b8-4c9d-e0f1-a2b3c4d5e6f7', 1,
 'Walking Tour Booking Enquiry', '...');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 'e7f8a9b0-c1d2-4e3f-a4b5-6c7d8e9f0a1b', 1,
 'sentence-completion', 'Complete the booking form...', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('c7d8e9f0-a1b2-4c3d-e4f5-6a7b8c9d0e1f', 'a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 1, 'Sarah ________', 'Mitchell', '["Mitchell"]'),
('e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 'a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 2, '14th ________', 'July', '["July"]'),
('a6b7c8d9-e0f1-4a2b-c3d4-5e6f7a8b9c0d', 'a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 3, '________ Tour', 'Ghost', '["Ghost"]'),
('c1d2e3f4-a5b6-4c7d-e8f9-0a1b2c3d4e5f', 'a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 4, 'Number of people: ________', '4', '["4"]'),
('f6a7b8c9-d0e1-4f2a-b3c4-5d6e7f8a9b0c', 'a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 5, 'Price per person: ________', '15', '["15"]'),
('a1b2c3d4-e5f6-4a7b-c8d9-0e1f2a3b4c5d', 'a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 6, 'Meeting point: ________', 'Cathedral', '["Cathedral"]'),
('c2d3e4f5-a6b7-4c8d-e9f0-1a2b3c4d5e6f', 'a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 7, 'Departure time: ________', '8.00 pm', '["8.00 pm"]'),
('e7f8a9b0-c1d2-4e3f-a4b5-6c7d8e9f0a1b', 'a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 8, 'Comfortable ________', 'shoes', '["shoes"]'),
('a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 'a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 9, 'Bring an ________', 'umbrella', '["umbrella"]'),
('c7d8e9f0-a1b2-4c3d-e4f5-6a7b8c9d0e1f', 'a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 10, 'Contact: ________', '07593 821', '["07593 821"]');

-- ── Section 2: Festival Volunteering ────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 'b3c4d5e6-a7b8-4c9d-e0f1-a2b3c4d5e6f7', 2,
 'Music Festival Volunteer Briefing', '...');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('a6b7c8d9-e0f1-4a2b-c3d4-5e6f7a8b9c0d', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 1,
 'multiple-choice', 'Choose A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('c1d2e3f4-a5b6-4c7d-e8f9-0a1b2c3d4e5f', 'a6b7c8d9-e0f1-4a2b-c3d4-5e6f7a8b9c0d', 11, 'Shift length?', '["A. 4 hours"]', 'A'),
('f6a7b8c9-d0e1-4f2a-b3c4-5d6e7f8a9b0c', 'a6b7c8d9-e0f1-4a2b-c3d4-5e6f7a8b9c0d', 12, 'Main duty?', '["B. Checking wristbands"]', 'B'),
('a1b2c3d4-e5f6-4a7b-c8d9-0e1f2a3b4c5d', 'a6b7c8d9-e0f1-4a2b-c3d4-5e6f7a8b9c0d', 13, 'Meal vouchers?', '["B. Two"]', 'B'),
('c2d3e4f5-a6b7-4c8d-e9f0-1a2b3c4d5e6f', 'a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 14, 'Used where?', '["C. Any food vendor"]', 'C'),
('e7f8a9b0-c1d2-4e3f-a4b5-6c7d8e9f0a1b', 'a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 15, 'Travel?', '["C. By shuttle bus"]', 'C');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 2,
 'matching-features', 'Label the map...', true, true, '["A. Main Stage", "B. First Aid", "C. Food Stalls", "D. Toilets", "E. Volunteer Tent"]');

INSERT INTO listening_questions (id, group_id, question_order, text, answer) VALUES
('c7d8e9f0-a1b2-4c3d-e4f5-6a7b8c9d0e1f', 'a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 16, 'Bottom of map', 'E'),
('e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 'a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 17, 'Centre', 'A'),
('a6b7c8d9-e0f1-4a2b-c3d4-5e6f7a8b9c0d', 'a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 18, 'To the left', 'B'),
('c1d2e3f4-a5b6-4c7d-e8f9-0a1b2c3d4e5f', 'a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 19, 'To the right', 'C'),
('f6a7b8c9-d0e1-4f2a-b3c4-5d6e7f8a9b0c', 'a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 20, 'Top right corner', 'D');

-- ── Section 3: Student-Tutor Discussion ─────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('a1b2c3d4-e5f6-4a7b-c8d9-0e1f2a3b4c5d', 'b3c4d5e6-a7b8-4c9d-e0f1-a2b3c4d5e6f7', 3,
 'Marketing Presentation Meeting', '...');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2d3e4f5-a6b7-4c8d-e9f0-1a2b3c4d5e6f', 'a1b2c3d4-e5f6-4a7b-c8d9-0e1f2a3b4c5d', 1,
 'multiple-choice', 'Choose A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('e7f8a9b0-c1d2-4e3f-a4b5-6c7d8e9f0a1b', 'c2d3e4f5-a6b7-4c8d-e9f0-1a2b3c4d5e6f', 21, 'Topic?', '["B. The decoy effect"]', 'B'),
('a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 'c2d3e4f5-a6b7-4c8d-e9f0-1a2b3c4d5e6f', 22, 'Decoy is...', '["C. Inferior"]', 'C'),
('c7d8e9f0-a1b2-4c3d-e4f5-6a7b8c9d0e1f', 'c2d3e4f5-a6b7-4c8d-e9f0-1a2b3c4d5e6f', 23, 'Length?', '["B. 15 minutes"]', 'B'),
('e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 'c2d3e4f5-a6b7-4c8d-e9f0-1a2b3c4d5e6f', 24, 'Reminded to...', '["B. A handout"]', 'B'),
('a6b7c8d9-e0f1-4a2b-c3d4-5e6f7a8b9c0d', 'c2d3e4f5-a6b7-4c8d-e9f0-1a2b3c4d5e6f', 25, 'Draft due?', '["B. Tuesday"]', 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('c1d2e3f4-a5b6-4c7d-e8f9-0a1b2c3d4e5f', 'a1b2c3d4-e5f6-4a7b-c8d9-0e1f2a3b4c5d', 2,
 'matching-features', 'Match tasks to person...', true, true, '["A. Sam", "B. Anna", "C. Both"]');

INSERT INTO listening_questions (id, group_id, question_order, text, answer) VALUES
('f6a7b8c9-d0e1-4f2a-b3c4-5d6e7f8a9b0c', 'c1d2e3f4-a5b6-4c7d-e8f9-0a1b2c3d4e5f', 26, 'Researching', 'A'),
('a1b2c3d4-e5f6-4a7b-c8d9-0e1f2a3b4c5d', 'c1d2e3f4-a5b6-4c7d-e8f9-0a1b2c3d4e5f', 27, 'Slides', 'B'),
('c2d3e4f5-a6b7-4c8d-e9f0-1a2b3c4d5e6f', 'c1d2e3f4-a5b6-4c7d-e8f9-0a1b2c3d4e5f', 28, 'Script', 'C'),
('e7f8a9b0-c1d2-4e3f-a4b5-6c7d8e9f0a1b', 'c1d2e3f4-a5b6-4c7d-e8f9-0a1b2c3d4e5f', 29, 'Printing', 'A'),
('a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 'c1d2e3f4-a5b6-4c7d-e8f9-0a1b2c3d4e5f', 30, 'Conclusion', 'B');

-- ── Section 4: Antarctic Exploration ────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('c7d8e9f0-a1b2-4c3d-e4f5-6a7b8c9d0e1f', 'b3c4d5e6-a7b8-4c9d-e0f1-a2b3c4d5e6f7', 4,
 'Lecture: History of Antarctic Exploration', '...');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 'c7d8e9f0-a1b2-4c3d-e4f5-6a7b8c9d0e1f', 1,
 'sentence-completion', 'Complete notes...', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('a6b7c8d9-e0f1-4a2b-c3d4-5e6f7a8b9c0d', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 31, 'Ended in year ________.', '1922', '["1922"]'),
('c1d2e3f4-a5b6-4c7d-e8f9-0a1b2c3d4e5f', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 32, 'South Pole', 'South Pole', '["South Pole"]'),
('f6a7b8c9-d0e1-4f2a-b3c4-5d6e7f8a9b0c', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 33, 'Norway', 'Norway', '["Norway"]'),
('a1b2c3d4-e5f6-4a7b-c8d9-0e1f2a3b4c5d', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 34, 'Amundsen used ________', 'sled dogs', '["sled dogs"]'),
('c2d3e4f5-a6b7-4c8d-e9f0-1a2b3c4d5e6f', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 35, 'Scott used ________', 'motorised', '["motorised"]'),
('e7f8a9b0-c1d2-4e3f-a4b5-6c7d8e9f0a1b', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 36, 'Animals died from ________', 'extreme cold', '["extreme cold"]'),
('a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 37, 'Died of cold and ________', 'starvation', '["starvation"]'),
('c7d8e9f0-a1b2-4c3d-e4f5-6a7b8c9d0e1f', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 38, 'Signed in ________', '1959', '["1959"]'),
('e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 39, 'Bans ________ activity', 'military', '["military"]'),
('a6b7c8d9-e0f1-4a2b-c3d4-5e6f7a8b9c0d', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 40, 'Reserves of ________', 'freshwater', '["freshwater"]');


-- ████████████████████████████████████████████████████████████
-- ██  3. WRITING TEST 3                                     ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('b3c4d5e6-a7b8-4c9d-e0f1-a2b3c4d5e6f7', '80f68d7a-1b4e-4f92-9c3a-23456789abcd',
 'IELTS Academic Writing Practice Test 3', 'published');

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('c1d2e3f4-a5b6-4c7d-e8f9-0a1b2c3d4e5f', 'b3c4d5e6-a7b8-4c9d-e0f1-a2b3c4d5e6f7', 1,
 'task1', 'Writing Task 1', '7', '20 mins', 'The line graph below shows...', 150, '', ''),
('f6a7b8c9-d0e1-4f2a-b3c4-5d6e7f8a9b0c', 'b3c4d5e6-a7b8-4c9d-e0f1-a2b3c4d5e6f7', 2,
 'task2', 'Writing Task 2', '7', '40 mins', 'The rise of convenience foods...', 250, '', '');

-- ════════════════════════════════════════════════════════════
-- End of IELTS Practice Test 3 Seed (Final Corrected)
-- ════════════════════════════════════════════════════════════
