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
('198f1268-fc16-4b13-aeef-ad69b1b73e92', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 2, 'Charles Pearson personally funded...', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('07f34d85-6cac-4a4a-b073-2d98c2faae3b', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 3, 'The first underground trains...', 'TRUE', '["TRUE","True","true"]'),
('38a766a3-02f9-4d09-bdf5-bdc22887a5f4', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 4, 'The nickname "Tube" originated...', 'TRUE', '["TRUE","True","true"]');

-- ── Group 24: SHORT ANSWER (Q5–8) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('111eeb9a-e070-4510-8b6b-4db9a05f7893', '7f8a9b0c-d1e2-4f3a-b4c5-d6e7f8a9b0c1', 2,
 'short-answer', 'Answer the questions below...', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('4e353ff4-8dba-48b2-8154-8b7b9c971842', '111eeb9a-e070-4510-8b6b-4db9a05f7893', 5, 'What construction method...', 'cut-and-cover', '[{"id":"1","text":"cut-and-cover"}]'),
('bb9da838-6af8-4267-914a-c470b3e7ce2b', '111eeb9a-e070-4510-8b6b-4db9a05f7893', 6, 'How many passengers...', '38,000', '[{"id":"1","text":"38,000"}]'),
('0130db05-a3d2-40b1-baa0-b1dae4aa4480', '111eeb9a-e070-4510-8b6b-4db9a05f7893', 7, 'What equipment was used...', 'tunneling shield', '[{"id":"1","text":"tunneling shield"}]'),
('74cfc4b0-7665-48ee-a422-e85595022ea2', '111eeb9a-e070-4510-8b6b-4db9a05f7893', 8, 'What is the specific name...', 'roundel', '[{"id":"1","text":"roundel"}]');

-- ── Group 25: TABLE COMPLETION (Q9–13) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', '7f8a9b0c-d1e2-4f3a-b4c5-d6e7f8a9b0c1', 3,
 'table-completion', 'Complete the table below...', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('d1807e84-59e2-4464-9083-b0d8c29ec26d', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 9, 'Row 1', '', '[{"id":"h1","gapText":"Year"}]'),
('bdd902ad-5ae6-498b-a3dc-e79058f8c61a', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 10, 'Row 2', '', '[{"id":"c1","gapText":"1860"}]'),
('f8346cb9-0f7d-4fd9-aed5-7793ecfb4892', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 11, 'Row 3', '', '[{"id":"c3","gapText":"1890"}]'),
('c9d680ea-d0ae-41e1-b957-31f9d4ebb784', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 12, 'Row 4', '', '[{"id":"c5","gapText":"1908"}]'),
('6cb97eb1-eccc-427a-9c08-0e0a9872c44c', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 13, 'Row 5', '', '[{"id":"c7","gapText":"1933"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Vertical Farming (Q14–27)                   ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b029c498-0e9f-450e-8365-7dae619ca2e8', '6b2c9e10-4d5e-4a3b-9c8d-1e2f3a4b5c6d', 2,
 'Vertical Farming: The Next Agricultural Revolution?', '...');

-- ── Group 26: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('3e9fbc2b-1d9b-42c0-985c-1688fbd13986', 'b029c498-0e9f-450e-8365-7dae619ca2e8', 1,
 'matching-headings', 'Choose the correct heading...', true, true, '["i. ...", "ii. ..."]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('c802aefa-61e0-451e-8fb1-42af708ff3e9', '3e9fbc2b-1d9b-42c0-985c-1688fbd13986', 14, 'Paragraph A', 'v'),
('f6a74e0f-f063-4862-8518-7d0ff97811d7', '3e9fbc2b-1d9b-42c0-985c-1688fbd13986', 15, 'Paragraph B', 'ii'),
('764ef38f-aad2-4330-9f98-f52e2e656cf0', '3e9fbc2b-1d9b-42c0-985c-1688fbd13986', 16, 'Paragraph C', 'vi'),
('87ebda1f-0cbc-4adf-bb34-ac57e6905197', '3e9fbc2b-1d9b-42c0-985c-1688fbd13986', 17, 'Paragraph D', 'i'),
('6ac1873c-aaed-4531-828b-f7826d95e818', '3e9fbc2b-1d9b-42c0-985c-1688fbd13986', 18, 'Paragraph E', 'iv'),
('7ef416b8-4e60-4c87-a294-7c3687cec0d0', '3e9fbc2b-1d9b-42c0-985c-1688fbd13986', 19, 'Paragraph F', 'iii');

-- ── Group 27: MATCHING INFORMATION (Q20–23) ── (FIXED IDs) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 'b029c498-0e9f-450e-8365-7dae619ca2e8', 2,
 'matching-information', 'Which paragraph contains...', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('ba95021a-2703-40cd-8cf2-1611ec341549', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 20, 'Reference to a method...', 'B', '[{"id":"1","right":"A"}]'),
('dc1e90eb-5312-430c-b797-62fabb294a92', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 21, 'An explanation of why...', 'E', '[{"id":"1","right":"A"}]'),
('256ed200-0760-4f85-9167-46c9736049ed', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 22, 'A statistic indicating...', 'A', '[{"id":"1","right":"A"}]'),
('b176408e-a2ca-4bbd-85c4-97e2645f7820', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 23, 'The reason why chemical...', 'C', '[{"id":"1","right":"A"}]');

-- ── Group 28: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('6767b5d9-2c5c-41fb-8b63-c91cba006c83', 'b029c498-0e9f-450e-8365-7dae619ca2e8', 3,
 'multiple-choice', 'Choose the correct letter...', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('3b38ee8e-d6f4-4ead-9071-1bfc4172999f', '6767b5d9-2c5c-41fb-8b63-c91cba006c83', 24, 'According to Paragraph C...', 'B', '[{"id":"B","text":"..."}]'),
('c3d62cd1-2bb3-4a2a-97d1-36c88a8a0d97', '6767b5d9-2c5c-41fb-8b63-c91cba006c83', 25, 'The writer suggests...', 'C', '[{"id":"C","text":"..."}]'),
('415a16dc-8a44-4d07-aa6a-a93ba9956f89', '6767b5d9-2c5c-41fb-8b63-c91cba006c83', 26, 'What is currently...', 'D', '[{"id":"D","text":"..."}]'),
('6c94e2d5-5079-4f99-8ada-2aa013f1142d', '6767b5d9-2c5c-41fb-8b63-c91cba006c83', 27, 'What does the phrase...', 'A', '[{"id":"A","text":"..."}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: Biomimicry (Q28–40)                         ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b3c4d5e6-f7a8-4b9c-0d1e-2f3a4b5c6d7e', '6b2c9e10-4d5e-4a3b-9c8d-1e2f3a4b5c6d', 3,
 'Biomimicry: Engineering Inspired by Nature', '...');

-- ── Group 29: YES/NO/NOT GIVEN (Q28–32) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('5cbd2c66-74a1-41ee-bc58-c5c7609dbc4a', 'b3c4d5e6-f7a8-4b9c-0d1e-2f3a4b5c6d7e', 1,
 'yes-no-not-given', 'Do the following statements...', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('e3056697-7978-41cb-9219-c0bf33a900d0', '5cbd2c66-74a1-41ee-bc58-c5c7609dbc4a', 28, 'Janine Benyus...', 'NO', '["NO"]'),
('92f05a64-9244-49c5-bb8e-5fe9fe2e2253', '5cbd2c66-74a1-41ee-bc58-c5c7609dbc4a', 29, 'George de Mestral...', 'YES', '["YES"]'),
('08859d7e-943b-4546-b617-cbdb1772b3d8', '5cbd2c66-74a1-41ee-bc58-c5c7609dbc4a', 30, 'The original bullet...', 'NOT GIVEN', '["NOT GIVEN"]'),
('009a1a72-7097-45f0-8693-743c78b1324f', '5cbd2c66-74a1-41ee-bc58-c5c7609dbc4a', 31, 'Sharklet surfaces...', 'NO', '["NO"]'),
('62bf5787-5ab7-4f89-8781-761fbb911076', '5cbd2c66-74a1-41ee-bc58-c5c7609dbc4a', 32, 'The Eastgate Centre...', 'NO', '["NO"]');

-- ── Group 30: MATCHING SENTENCE ENDINGS (Q33–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('8c0b8cdc-6627-4e15-bde8-d305e7554068', 'b3c4d5e6-f7a8-4b9c-0d1e-2f3a4b5c6d7e', 2,
 'matching-sentence-endings', 'Complete each sentence...', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('efdb925d-d9cc-4c48-9ab7-b1fb072a5935', '8c0b8cdc-6627-4e15-bde8-d305e7554068', 33, 'The Shinkansen train...', 'E', '[{"id":"E","text":"..."}]'),
('479c4bd0-6874-42c5-be2e-2428ac5cca91', '8c0b8cdc-6627-4e15-bde8-d305e7554068', 34, 'The unique micro-texture...', 'B', '[{"id":"B","text":"..."}]'),
('0df8d3cc-f5f3-4fa9-aa66-7c6a845b75c1', '8c0b8cdc-6627-4e15-bde8-d305e7554068', 35, 'The ventilation system...', 'C', '[{"id":"C","text":"..."}]');

-- ── Group 31: SUMMARY COMPLETION (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('3899386b-3ea1-4890-8d88-f0f4eb8c3d30', 'b3c4d5e6-f7a8-4b9c-0d1e-2f3a4b5c6d7e', 3,
 'summary-completion', 'Complete the summary...', true, true, '["burrs","speed","kingfisher","passive","chemicals","waste","shark"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('4e6168c7-f1d1-49b3-9d93-c17f54cdf174', '3899386b-3ea1-4890-8d88-f0f4eb8c3d30', 36, 'Biomimicry looks to nature...', 'burrs'),
('ea3d30ea-7962-4190-b82e-4a735dae2dd5', '3899386b-3ea1-4890-8d88-f0f4eb8c3d30', 37, '', 'kingfisher'),
('77cc93bc-b451-436f-85f5-b98b058e2f66', '3899386b-3ea1-4890-8d88-f0f4eb8c3d30', 38, '', 'shark'),
('c847f3ef-4513-40c6-923f-dfd9bee1065f', '3899386b-3ea1-4890-8d88-f0f4eb8c3d30', 39, '', 'chemicals'),
('201df2b2-ae1f-424c-9b8f-98c9b52dfb18', '3899386b-3ea1-4890-8d88-f0f4eb8c3d30', 40, '', 'passive');


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
('01b213cb-2519-4f67-b308-79094f9a5e75', 'a2b3c4d5-e6f7-4a8b-c9d0-1e2f3a4b5c6d', 10, 'Contact: ________', '07593 821', '["07593 821"]');

-- ── Section 2: Festival Volunteering ────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 'b3c4d5e6-a7b8-4c9d-e0f1-a2b3c4d5e6f7', 2,
 'Music Festival Volunteer Briefing', '...');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('a6b7c8d9-e0f1-4a2b-c3d4-5e6f7a8b9c0d', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 1,
 'multiple-choice', 'Choose A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('06917677-7436-445d-aff1-d10076f74521', 'a6b7c8d9-e0f1-4a2b-c3d4-5e6f7a8b9c0d', 11, 'Shift length?', '["A. 4 hours"]', 'A'),
('c60a2750-eb17-4d31-9e6d-2c72be074ee8', 'a6b7c8d9-e0f1-4a2b-c3d4-5e6f7a8b9c0d', 12, 'Main duty?', '["B. Checking wristbands"]', 'B'),
('392f730c-7b00-4e7b-8d4a-174e4b92de37', 'a6b7c8d9-e0f1-4a2b-c3d4-5e6f7a8b9c0d', 13, 'Meal vouchers?', '["B. Two"]', 'B'),
('d86101e5-a022-45fe-990c-e122ab8c4d4c', 'a6b7c8d9-e0f1-4a2b-c3d4-5e6f7a8b9c0d', 14, 'Used where?', '["C. Any food vendor"]', 'C'),
('26c8947f-7f86-4b48-8c8c-383f6c5306ec', 'a6b7c8d9-e0f1-4a2b-c3d4-5e6f7a8b9c0d', 15, 'Travel?', '["C. By shuttle bus"]', 'C');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('bc691639-f0a4-40d9-8d32-1b27a6704d89', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 2,
 'matching-features', 'Label the map...', true, true, '["A. Main Stage", "B. First Aid", "C. Food Stalls", "D. Toilets", "E. Volunteer Tent"]');

INSERT INTO listening_questions (id, group_id, question_order, text, answer) VALUES
('5f122238-5e5d-4e0e-97ca-b18a620a2989', 'bc691639-f0a4-40d9-8d32-1b27a6704d89', 16, 'Bottom of map', 'E'),
('5f013b87-bfe2-4bf4-a7d4-1bc48f6ce9c3', 'bc691639-f0a4-40d9-8d32-1b27a6704d89', 17, 'Centre', 'A'),
('e3fa1d1c-b918-424e-9335-97d6c98dfa78', 'bc691639-f0a4-40d9-8d32-1b27a6704d89', 18, 'To the left', 'B'),
('cae4a780-e16f-451d-bdc9-3b7e29ef02a1', 'bc691639-f0a4-40d9-8d32-1b27a6704d89', 19, 'To the right', 'C'),
('2fc873e1-eabf-4c27-a818-1c928d3bdf6b', 'bc691639-f0a4-40d9-8d32-1b27a6704d89', 20, 'Top right corner', 'D');

-- ── Section 3: Student-Tutor Discussion ─────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('a1b2c3d4-e5f6-4a7b-c8d9-0e1f2a3b4c5d', 'b3c4d5e6-a7b8-4c9d-e0f1-a2b3c4d5e6f7', 3,
 'Marketing Presentation Meeting', '...');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2d3e4f5-a6b7-4c8d-e9f0-1a2b3c4d5e6f', 'a1b2c3d4-e5f6-4a7b-c8d9-0e1f2a3b4c5d', 1,
 'multiple-choice', 'Choose A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('10f63699-2dc9-4f67-9745-3825b98174e3', 'c2d3e4f5-a6b7-4c8d-e9f0-1a2b3c4d5e6f', 21, 'Topic?', '["B. The decoy effect"]', 'B'),
('d7e29b12-5705-4a14-9164-bac8987caf54', 'c2d3e4f5-a6b7-4c8d-e9f0-1a2b3c4d5e6f', 22, 'Decoy is...', '["C. Inferior"]', 'C'),
('3436677c-33a5-49d9-8a35-8a62be858651', 'c2d3e4f5-a6b7-4c8d-e9f0-1a2b3c4d5e6f', 23, 'Length?', '["B. 15 minutes"]', 'B'),
('cb5ee4ba-f37f-4a79-93d7-1b934f95c0b2', 'c2d3e4f5-a6b7-4c8d-e9f0-1a2b3c4d5e6f', 24, 'Reminded to...', '["B. A handout"]', 'B'),
('790e9fa2-4452-4fec-b128-f07281305e9c', 'c2d3e4f5-a6b7-4c8d-e9f0-1a2b3c4d5e6f', 25, 'Draft due?', '["B. Tuesday"]', 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('c1d2e3f4-a5b6-4c7d-e8f9-0a1b2c3d4e5f', 'a1b2c3d4-e5f6-4a7b-c8d9-0e1f2a3b4c5d', 2,
 'matching-features', 'Match tasks to person...', true, true, '["A. Sam", "B. Anna", "C. Both"]');

INSERT INTO listening_questions (id, group_id, question_order, text, answer) VALUES
('38d150a2-7fc6-4cab-bc44-a4085ec7c96e', 'c1d2e3f4-a5b6-4c7d-e8f9-0a1b2c3d4e5f', 26, 'Researching', 'A'),
('7c427623-57b3-4f64-a0e2-c0a36fbd30bd', 'c1d2e3f4-a5b6-4c7d-e8f9-0a1b2c3d4e5f', 27, 'Slides', 'B'),
('e09c2f44-f224-4ee1-815f-09b90ac23e73', 'c1d2e3f4-a5b6-4c7d-e8f9-0a1b2c3d4e5f', 28, 'Script', 'C'),
('d2668a47-80ac-4ac5-8b92-f2be5e06fb31', 'c1d2e3f4-a5b6-4c7d-e8f9-0a1b2c3d4e5f', 29, 'Printing', 'A'),
('56e9824f-1e56-46c3-9100-4128f8e11292', 'c1d2e3f4-a5b6-4c7d-e8f9-0a1b2c3d4e5f', 30, 'Conclusion', 'B');

-- ── Section 4: Antarctic Exploration ────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('c7d8e9f0-a1b2-4c3d-e4f5-6a7b8c9d0e1f', 'b3c4d5e6-a7b8-4c9d-e0f1-a2b3c4d5e6f7', 4,
 'Lecture: History of Antarctic Exploration', '...');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 'c7d8e9f0-a1b2-4c3d-e4f5-6a7b8c9d0e1f', 1,
 'sentence-completion', 'Complete notes...', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('c27bf401-b9cf-437e-9899-cd1a87e8aa59', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 31, 'Ended in year ________.', '1922', '["1922"]'),
('b99a99fc-d6aa-486f-ba1a-97e2f2eefab1', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 32, 'South Pole', 'South Pole', '["South Pole"]'),
('6e03ecc0-29bf-4060-a790-605789c2b368', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 33, 'Norway', 'Norway', '["Norway"]'),
('6f67c961-3064-4d5e-8453-fc2650254f1e', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 34, 'Amundsen used ________', 'sled dogs', '["sled dogs"]'),
('8f63c08f-4395-472e-9424-c029c1b1a051', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 35, 'Scott used ________', 'motorised', '["motorised"]'),
('23263144-c53e-421a-9544-ac35d218c331', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 36, 'Animals died from ________', 'extreme cold', '["extreme cold"]'),
('c451adb2-4f38-443b-8d3c-0317a4ea8275', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 37, 'Died of cold and ________', 'starvation', '["starvation"]'),
('618bbac7-54c2-44ff-9bfd-2410985e1fd5', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 38, 'Signed in ________', '1959', '["1959"]'),
('a98b3429-8bda-4168-af0c-9e0b6bc8146c', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 39, 'Bans ________ activity', 'military', '["military"]'),
('e48bc352-29ff-4b51-8027-f2a1b3b75ab1', 'e1f2a3b4-c5d6-4e7f-a8b9-0c1d2e3f4a5b', 40, 'Reserves of ________', 'freshwater', '["freshwater"]');


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
