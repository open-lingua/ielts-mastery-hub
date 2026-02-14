-- ============================================================
-- IELTS Practice Platform – Comprehensive Seed Data (Test 3)
-- VERSION FINAL: UUIDs validados y sin duplicados
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  1. READING TEST 3 – ALL QUESTION TYPES (40 questions)    ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('a1000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001',
 'IELTS Academic Reading Practice Test 3', 'Academic', '7', '60 mins', 'published');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: The Birth of the Underground (Q1–13)        ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b1100000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000003', 1,
 'The Birth of the London Underground',
 '(A) In the first half of the 19th century, London''s population grew at an astonishing rate... (B) The solution was proposed by Charles Pearson... (C) On January 10, 1863... (D) The true revolution... (E) As the network expanded...');

-- ── Group 23: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1100000-0000-0000-0000-000000000023', 'b1100000-0000-0000-0000-000000000007', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the passage? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d1100000-0000-0000-0000-000000000081', 'c1100000-0000-0000-0000-000000000023', 1, 'Main-line railways in the 1850s...', 'FALSE', '["FALSE","False","false"]'::jsonb),
('d1100000-0000-0000-0000-000000000082', 'c1100000-0000-0000-0000-000000000023', 2, 'Charles Pearson personally funded...', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'::jsonb),
('d1100000-0000-0000-0000-000000000083', 'c1100000-0000-0000-0000-000000000023', 3, 'The first underground trains...', 'TRUE', '["TRUE","True","true"]'::jsonb),
('d1100000-0000-0000-0000-000000000084', 'c1100000-0000-0000-0000-000000000023', 4, 'The nickname "Tube" originated...', 'TRUE', '["TRUE","True","true"]'::jsonb);

-- ── Group 24: SHORT ANSWER (Q5–8) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('c1100000-0000-0000-0000-000000000024', 'b1100000-0000-0000-0000-000000000007', 2,
 'short-answer', 'Answer the questions below...', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d1100000-0000-0000-0000-000000000085', 'c1100000-0000-0000-0000-000000000024', 5, 'What construction method...', 'cut-and-cover', '[{"id":"1","text":"cut-and-cover"}]'::jsonb),
('d1100000-0000-0000-0000-000000000086', 'c1100000-0000-0000-0000-000000000024', 6, 'How many passengers...', '38,000', '[{"id":"1","text":"38,000"}]'::jsonb),
('d1100000-0000-0000-0000-000000000087', 'c1100000-0000-0000-0000-000000000024', 7, 'What equipment was used...', 'tunneling shield', '[{"id":"1","text":"tunneling shield"}]'::jsonb),
('d1100000-0000-0000-0000-000000000088', 'c1100000-0000-0000-0000-000000000024', 8, 'What is the specific name...', 'roundel', '[{"id":"1","text":"roundel"}]'::jsonb);

-- ── Group 25: TABLE COMPLETION (Q9–13) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('c1100000-0000-0000-0000-000000000025', 'b1100000-0000-0000-0000-000000000007', 3,
 'table-completion', 'Complete the table below...', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('d1100000-0000-0000-0000-000000000089', 'c1100000-0000-0000-0000-000000000025', 9, 'Row 1', '', '[{"id":"h1","gapText":"Year"}]'::jsonb),
('d1100000-0000-0000-0000-000000000090', 'c1100000-0000-0000-0000-000000000025', 10, 'Row 2', '', '[{"id":"c1","gapText":"1860"}]'::jsonb),
('d1100000-0000-0000-0000-000000000091', 'c1100000-0000-0000-0000-000000000025', 11, 'Row 3', '', '[{"id":"c3","gapText":"1890"}]'::jsonb),
('d1100000-0000-0000-0000-000000000092', 'c1100000-0000-0000-0000-000000000025', 12, 'Row 4', '', '[{"id":"c5","gapText":"1908"}]'::jsonb),
('d1100000-0000-0000-0000-000000000093', 'c1100000-0000-0000-0000-000000000025', 13, 'Row 5', '', '[{"id":"c7","gapText":"1933"}]'::jsonb);


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Vertical Farming (Q14–27)                   ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b1100000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000003', 2,
 'Vertical Farming: The Next Agricultural Revolution?', '...');

-- ── Group 26: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('c1100000-0000-0000-0000-000000000026', 'b1100000-0000-0000-0000-000000000008', 1,
 'matching-headings', 'Choose the correct heading...', true, true, '["i. ...", "ii. ..."]'::jsonb);

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('d1100000-0000-0000-0000-000000000094', 'c1100000-0000-0000-0000-000000000026', 14, 'Paragraph A', 'v'),
('d1100000-0000-0000-0000-000000000095', 'c1100000-0000-0000-0000-000000000026', 15, 'Paragraph B', 'ii'),
('d1100000-0000-0000-0000-000000000096', 'c1100000-0000-0000-0000-000000000026', 16, 'Paragraph C', 'vi'),
('d1100000-0000-0000-0000-000000000097', 'c1100000-0000-0000-0000-000000000026', 17, 'Paragraph D', 'i'),
('d1100000-0000-0000-0000-000000000098', 'c1100000-0000-0000-0000-000000000026', 18, 'Paragraph E', 'iv'),
('d1100000-0000-0000-0000-000000000099', 'c1100000-0000-0000-0000-000000000026', 19, 'Paragraph F', 'iii');

-- ── Group 27: MATCHING INFORMATION (Q20–23) ── (FIXED IDs) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1100000-0000-0000-0000-000000000027', 'b1100000-0000-0000-0000-000000000008', 2,
 'matching-information', 'Which paragraph contains...', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('d1100000-0000-0000-0000-000000000100', 'c1100000-0000-0000-0000-000000000027', 20, 'Reference to a method...', 'B', '[{"id":"1","right":"A"}]'::jsonb),
('d1100000-0000-0000-0000-000000000101', 'c1100000-0000-0000-0000-000000000027', 21, 'An explanation of why...', 'E', '[{"id":"1","right":"A"}]'::jsonb),
('d1100000-0000-0000-0000-000000000102', 'c1100000-0000-0000-0000-000000000027', 22, 'A statistic indicating...', 'A', '[{"id":"1","right":"A"}]'::jsonb),
('d1100000-0000-0000-0000-000000000103', 'c1100000-0000-0000-0000-000000000027', 23, 'The reason why chemical...', 'C', '[{"id":"1","right":"A"}]'::jsonb);

-- ── Group 28: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1100000-0000-0000-0000-000000000028', 'b1100000-0000-0000-0000-000000000008', 3,
 'multiple-choice', 'Choose the correct letter...', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('d1100000-0000-0000-0000-000000000104', 'c1100000-0000-0000-0000-000000000028', 24, 'According to Paragraph C...', 'B', '[{"id":"B","text":"..."}]'::jsonb),
('d1100000-0000-0000-0000-000000000105', 'c1100000-0000-0000-0000-000000000028', 25, 'The writer suggests...', 'C', '[{"id":"C","text":"..."}]'::jsonb),
('d1100000-0000-0000-0000-000000000106', 'c1100000-0000-0000-0000-000000000028', 26, 'What is currently...', 'D', '[{"id":"D","text":"..."}]'::jsonb),
('d1100000-0000-0000-0000-000000000107', 'c1100000-0000-0000-0000-000000000028', 27, 'What does the phrase...', 'A', '[{"id":"A","text":"..."}]'::jsonb);


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: Biomimicry (Q28–40)                         ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b1100000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000003', 3,
 'Biomimicry: Engineering Inspired by Nature', '...');

-- ── Group 29: YES/NO/NOT GIVEN (Q28–32) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1100000-0000-0000-0000-000000000029', 'b1100000-0000-0000-0000-000000000009', 1,
 'yes-no-not-given', 'Do the following statements...', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d1100000-0000-0000-0000-000000000108', 'c1100000-0000-0000-0000-000000000029', 28, 'Janine Benyus...', 'NO', '["NO"]'::jsonb),
('d1100000-0000-0000-0000-000000000109', 'c1100000-0000-0000-0000-000000000029', 29, 'George de Mestral...', 'YES', '["YES"]'::jsonb),
('d1100000-0000-0000-0000-000000000110', 'c1100000-0000-0000-0000-000000000029', 30, 'The original bullet...', 'NOT GIVEN', '["NOT GIVEN"]'::jsonb),
('d1100000-0000-0000-0000-000000000111', 'c1100000-0000-0000-0000-000000000029', 31, 'Sharklet surfaces...', 'NO', '["NO"]'::jsonb),
('d1100000-0000-0000-0000-000000000112', 'c1100000-0000-0000-0000-000000000029', 32, 'The Eastgate Centre...', 'NO', '["NO"]'::jsonb);

-- ── Group 30: MATCHING SENTENCE ENDINGS (Q33–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1100000-0000-0000-0000-000000000030', 'b1100000-0000-0000-0000-000000000009', 2,
 'matching-sentence-endings', 'Complete each sentence...', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('d1100000-0000-0000-0000-000000000113', 'c1100000-0000-0000-0000-000000000030', 33, 'The Shinkansen train...', 'E', '[{"id":"E","text":"..."}]'::jsonb),
('d1100000-0000-0000-0000-000000000114', 'c1100000-0000-0000-0000-000000000030', 34, 'The unique micro-texture...', 'B', '[{"id":"B","text":"..."}]'::jsonb),
('d1100000-0000-0000-0000-000000000115', 'c1100000-0000-0000-0000-000000000030', 35, 'The ventilation system...', 'C', '[{"id":"C","text":"..."}]'::jsonb);

-- ── Group 31: SUMMARY COMPLETION (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('c1100000-0000-0000-0000-000000000031', 'b1100000-0000-0000-0000-000000000009', 3,
 'summary-completion', 'Complete the summary...', true, true, '["burrs","speed","kingfisher","passive","chemicals","waste","shark"]'::jsonb);

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('d1100000-0000-0000-0000-000000000116', 'c1100000-0000-0000-0000-000000000031', 36, 'Biomimicry looks to nature...', 'burrs'),
('d1100000-0000-0000-0000-000000000117', 'c1100000-0000-0000-0000-000000000031', 37, '', 'kingfisher'),
('d1100000-0000-0000-0000-000000000118', 'c1100000-0000-0000-0000-000000000031', 38, '', 'shark'),
('d1100000-0000-0000-0000-000000000119', 'c1100000-0000-0000-0000-000000000031', 39, '', 'chemicals'),
('d1100000-0000-0000-0000-000000000120', 'c1100000-0000-0000-0000-000000000031', 40, '', 'passive');


-- ████████████████████████████████████████████████████████████
-- ██  2. LISTENING TEST 3                                   ██
-- ████████████████████████████████████████████████████████████

INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status) VALUES
('a2000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001',
 'IELTS Listening Practice Test 3', '7', '40 mins', 'published');

-- ── Section 1: Walking Tour Booking ─────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('b2000000-0000-0000-0000-000000000009', 'a2000000-0000-0000-0000-000000000003', 1,
 'Walking Tour Booking Enquiry', '...');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2000000-0000-0000-0000-000000000012', 'b2000000-0000-0000-0000-000000000009', 1,
 'sentence-completion', 'Complete the booking form...', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d2000000-0000-0000-0000-000000000081', 'c2000000-0000-0000-0000-000000000012', 1, 'Sarah ________', 'Mitchell', '["Mitchell"]'::jsonb),
('d2000000-0000-0000-0000-000000000082', 'c2000000-0000-0000-0000-000000000012', 2, '14th ________', 'July', '["July"]'::jsonb),
('d2000000-0000-0000-0000-000000000083', 'c2000000-0000-0000-0000-000000000012', 3, '________ Tour', 'Ghost', '["Ghost"]'::jsonb),
('d2000000-0000-0000-0000-000000000084', 'c2000000-0000-0000-0000-000000000012', 4, 'Number of people: ________', '4', '["4"]'::jsonb),
('d2000000-0000-0000-0000-000000000085', 'c2000000-0000-0000-0000-000000000012', 5, 'Price per person: ________', '15', '["15"]'::jsonb),
('d2000000-0000-0000-0000-000000000086', 'c2000000-0000-0000-0000-000000000012', 6, 'Meeting point: ________', 'Cathedral', '["Cathedral"]'::jsonb),
('d2000000-0000-0000-0000-000000000087', 'c2000000-0000-0000-0000-000000000012', 7, 'Departure time: ________', '8.00 pm', '["8.00 pm"]'::jsonb),
('d2000000-0000-0000-0000-000000000088', 'c2000000-0000-0000-0000-000000000012', 8, 'Comfortable ________', 'shoes', '["shoes"]'::jsonb),
('d2000000-0000-0000-0000-000000000089', 'c2000000-0000-0000-0000-000000000012', 9, 'Bring an ________', 'umbrella', '["umbrella"]'::jsonb),
('d2000000-0000-0000-0000-000000000090', 'c2000000-0000-0000-0000-000000000012', 10, 'Contact: ________', '07593 821', '["07593 821"]'::jsonb);

-- ── Section 2: Festival Volunteering ────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('b2000000-0000-0000-0000-000000000010', 'a2000000-0000-0000-0000-000000000003', 2,
 'Music Festival Volunteer Briefing', '...');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2000000-0000-0000-0000-000000000013', 'b2000000-0000-0000-0000-000000000010', 1,
 'multiple-choice', 'Choose A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('d2000000-0000-0000-0000-000000000091', 'c2000000-0000-0000-0000-000000000013', 11, 'Shift length?', '["A. 4 hours"]'::jsonb, 'A'),
('d2000000-0000-0000-0000-000000000092', 'c2000000-0000-0000-0000-000000000013', 12, 'Main duty?', '["B. Checking wristbands"]'::jsonb, 'B'),
('d2000000-0000-0000-0000-000000000093', 'c2000000-0000-0000-0000-000000000013', 13, 'Meal vouchers?', '["B. Two"]'::jsonb, 'B'),
('d2000000-0000-0000-0000-000000000094', 'c2000000-0000-0000-0000-000000000013', 14, 'Used where?', '["C. Any food vendor"]'::jsonb, 'C'),
('d2000000-0000-0000-0000-000000000095', 'c2000000-0000-0000-0000-000000000013', 15, 'Travel?', '["C. By shuttle bus"]'::jsonb, 'C');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('c2000000-0000-0000-0000-000000000014', 'b2000000-0000-0000-0000-000000000010', 2,
 'matching-features', 'Label the map...', true, true, '["A. Main Stage", "B. First Aid", "C. Food Stalls", "D. Toilets", "E. Volunteer Tent"]'::jsonb);

INSERT INTO listening_questions (id, group_id, question_order, text, answer) VALUES
('d2000000-0000-0000-0000-000000000096', 'c2000000-0000-0000-0000-000000000014', 16, 'Bottom of map', 'E'),
('d2000000-0000-0000-0000-000000000097', 'c2000000-0000-0000-0000-000000000014', 17, 'Centre', 'A'),
('d2000000-0000-0000-0000-000000000098', 'c2000000-0000-0000-0000-000000000014', 18, 'To the left', 'B'),
('d2000000-0000-0000-0000-000000000099', 'c2000000-0000-0000-0000-000000000014', 19, 'To the right', 'C'),
('d2000000-0000-0000-0000-000000000100', 'c2000000-0000-0000-0000-000000000014', 20, 'Top right corner', 'D');

-- ── Section 3: Student-Tutor Discussion ─────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('b2000000-0000-0000-0000-000000000011', 'a2000000-0000-0000-0000-000000000003', 3,
 'Marketing Presentation Meeting', '...');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2000000-0000-0000-0000-000000000015', 'b2000000-0000-0000-0000-000000000011', 1,
 'multiple-choice', 'Choose A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('d2000000-0000-0000-0000-000000000101', 'c2000000-0000-0000-0000-000000000015', 21, 'Topic?', '["B. The decoy effect"]'::jsonb, 'B'),
('d2000000-0000-0000-0000-000000000102', 'c2000000-0000-0000-0000-000000000015', 22, 'Decoy is...', '["C. Inferior"]'::jsonb, 'C'),
('d2000000-0000-0000-0000-000000000103', 'c2000000-0000-0000-0000-000000000015', 23, 'Length?', '["B. 15 minutes"]'::jsonb, 'B'),
('d2000000-0000-0000-0000-000000000104', 'c2000000-0000-0000-0000-000000000015', 24, 'Reminded to...', '["B. A handout"]'::jsonb, 'B'),
('d2000000-0000-0000-0000-000000000105', 'c2000000-0000-0000-0000-000000000015', 25, 'Draft due?', '["B. Tuesday"]'::jsonb, 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('c2000000-0000-0000-0000-000000000016', 'b2000000-0000-0000-0000-000000000011', 2,
 'matching-features', 'Match tasks to person...', true, true, '["A. Sam", "B. Anna", "C. Both"]'::jsonb);

INSERT INTO listening_questions (id, group_id, question_order, text, answer) VALUES
('d2000000-0000-0000-0000-000000000106', 'c2000000-0000-0000-0000-000000000016', 26, 'Researching', 'A'),
('d2000000-0000-0000-0000-000000000107', 'c2000000-0000-0000-0000-000000000016', 27, 'Slides', 'B'),
('d2000000-0000-0000-0000-000000000108', 'c2000000-0000-0000-0000-000000000016', 28, 'Script', 'C'),
('d2000000-0000-0000-0000-000000000109', 'c2000000-0000-0000-0000-000000000016', 29, 'Printing', 'A'),
('d2000000-0000-0000-0000-000000000110', 'c2000000-0000-0000-0000-000000000016', 30, 'Conclusion', 'B');

-- ── Section 4: Antarctic Exploration ────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('b2000000-0000-0000-0000-000000000012', 'a2000000-0000-0000-0000-000000000003', 4,
 'Lecture: History of Antarctic Exploration', '...');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2000000-0000-0000-0000-000000000017', 'b2000000-0000-0000-0000-000000000012', 1,
 'sentence-completion', 'Complete notes...', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d2000000-0000-0000-0000-000000000111', 'c2000000-0000-0000-0000-000000000017', 31, 'Ended in year ________.', '1922', '["1922"]'::jsonb),
('d2000000-0000-0000-0000-000000000112', 'c2000000-0000-0000-0000-000000000017', 32, 'South Pole', 'South Pole', '["South Pole"]'::jsonb),
('d2000000-0000-0000-0000-000000000113', 'c2000000-0000-0000-0000-000000000017', 33, 'Norway', 'Norway', '["Norway"]'::jsonb),
('d2000000-0000-0000-0000-000000000114', 'c2000000-0000-0000-0000-000000000017', 34, 'Amundsen used ________', 'sled dogs', '["sled dogs"]'::jsonb),
('d2000000-0000-0000-0000-000000000115', 'c2000000-0000-0000-0000-000000000017', 35, 'Scott used ________', 'motorised', '["motorised"]'::jsonb),
('d2000000-0000-0000-0000-000000000116', 'c2000000-0000-0000-0000-000000000017', 36, 'Animals died from ________', 'extreme cold', '["extreme cold"]'::jsonb),
('d2000000-0000-0000-0000-000000000117', 'c2000000-0000-0000-0000-000000000017', 37, 'Died of cold and ________', 'starvation', '["starvation"]'::jsonb),
('d2000000-0000-0000-0000-000000000118', 'c2000000-0000-0000-0000-000000000017', 38, 'Signed in ________', '1959', '["1959"]'::jsonb),
('d2000000-0000-0000-0000-000000000119', 'c2000000-0000-0000-0000-000000000017', 39, 'Bans ________ activity', 'military', '["military"]'::jsonb),
('d2000000-0000-0000-0000-000000000120', 'c2000000-0000-0000-0000-000000000017', 40, 'Reserves of ________', 'freshwater', '["freshwater"]'::jsonb);


-- ████████████████████████████████████████████████████████████
-- ██  3. WRITING TEST 3                                     ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('a3000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001',
 'IELTS Academic Writing Practice Test 3', 'published');

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('d3000000-0000-0000-0000-000000000005', 'a3000000-0000-0000-0000-000000000003', 1,
 'task1', 'Writing Task 1', '7', '20 mins', 'The line graph below shows...', 150, '', ''),
('d3000000-0000-0000-0000-000000000006', 'a3000000-0000-0000-0000-000000000003', 2,
 'task2', 'Writing Task 2', '7', '40 mins', 'The rise of convenience foods...', 250, '', '');

-- ════════════════════════════════════════════════════════════
-- End of IELTS Practice Test 3 Seed (Final Corrected)
-- ════════════════════════════════════════════════════════════
