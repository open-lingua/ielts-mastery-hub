-- ============================================================
-- IELTS Practice Platform – Extended Seed Data
-- Target: Reading Module (General Training, Band 7 Difficulty)
-- Action: APPEND (No TRUNCATE)
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST ENTRY (General Training - Band 7)                   ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('de9ddd44-93dc-4f8e-83db-6a92a5585041', 'd735efb3-a9f3-4736-8053-07394ff2f2fd',
 'IELTS General Training Reading: Urban Transport, Workplace Policies & Psychology (Band 7)', 'General Training', '7', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: Metropolitan Transit Authority Guide (Q1–13)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('1f7c0d76-41e9-494a-973b-5a80b23fc126', 'de9ddd44-93dc-4f8e-83db-6a92a5585041', 1,
 'Metropolitan Transit Authority: Passenger Pass Guide',
 '(A) Navigating the city''s comprehensive transit network has never been easier thanks to our updated ticketing system. The Metropolitan Transit Authority (MTA) offers several pass options tailored to different commuting needs, whether you are a daily worker, a student, or a weekend explorer. All passes are loaded onto the reusable ''MetroCard'', which can be purchased for a one-off fee of $3 at any station kiosk, participating convenience store, or via the official MTA mobile app.

(B) The Commuter Plus Pass
Priced at $120 per month, the Commuter Plus is our most popular option. It provides unlimited travel on all city buses, underground subway lines, and the elevated light rail system. Commuter Plus cardholders also receive complimentary access to secure bicycle storage facilities located at major transit hubs. However, please note that this pass does not cover travel on the regional express trains that service the outer suburbs; these require a separate supplementary ticket.

(C) The Flexi-Trip Pass
Designed for those who work from home part-time or travel less frequently, the Flexi-Trip pass costs $45 and grants the user 20 individual journeys that can be used at any time within a 90-day period. A journey is defined as starting when you tap your card at a terminal and ending up to two hours later, regardless of how many transfers you make between buses and subways. Unused trips will expire automatically 90 days after purchase and are strictly non-refundable.

(D) The Weekend Explorer
For just $15, the Weekend Explorer allows unlimited travel from 6:00 PM on Friday until midnight on Sunday. It is valid across all regular MTA services, including the scenic ferry routes that operate along the harbor. It’s an ideal choice for tourists and residents looking to sightsee. Be aware that the ferries are highly susceptible to weather conditions, and services may be suspended without prior notice during heavy storms. 

(E) General Regulations
All passengers must tap their MetroCard on the electronic readers before boarding buses or passing through subway turnstiles. Failure to produce a valid, activated ticket when approached by a Transit Inspector will result in an immediate on-the-spot fine of $75. If you lose a registered MetroCard, you must report it to our customer service hotline immediately. Your remaining balance will be transferred to a new card, minus a $5 processing fee.');

-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('34a8d36b-f5cb-4c47-a8f9-2fb02a5fbba6', '1f7c0d76-41e9-494a-973b-5a80b23fc126', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the text? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d3a28bec-5453-4ccb-9195-4c915fb38e67', '34a8d36b-f5cb-4c47-a8f9-2fb02a5fbba6', 1,
 'The physical MetroCard must be replaced and paid for every year.', 'FALSE', '["FALSE","False","false"]'),
('1142babe-1530-4df3-a431-580d49e25c1e', '34a8d36b-f5cb-4c47-a8f9-2fb02a5fbba6', 2,
 'The Commuter Plus Pass includes travel on the regional express trains.', 'FALSE', '["FALSE","False","false"]'),
('3d16a5ec-7e78-4290-bedd-b80aa2636d6f', '34a8d36b-f5cb-4c47-a8f9-2fb02a5fbba6', 3,
 'Flexi-Trip users can transfer between different modes of transport during a single journey.', 'TRUE', '["TRUE","True","true"]'),
('79ec9c35-2bd4-42df-a857-3a0a20c427c0', '34a8d36b-f5cb-4c47-a8f9-2fb02a5fbba6', 4,
 'The Weekend Explorer is mostly purchased by international tourists.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]');

-- ── Group 2: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('bcc4b87e-69c0-4fd9-9171-c401f9e07c21', '1f7c0d76-41e9-494a-973b-5a80b23fc126', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN TWO WORDS AND/OR A NUMBER from the text for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('9c95c434-12ae-4ccc-99e6-7bbc51e296cd', 'bcc4b87e-69c0-4fd9-9171-c401f9e07c21', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"Pass Type","answer":""},{"id":"h2","gapText":"Cost","answer":""},{"id":"h3","gapText":"Special Features / Restrictions","answer":""}]'),
('c9537d1a-212d-4384-8fa1-8172acb6ca41', 'bcc4b87e-69c0-4fd9-9171-c401f9e07c21', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"Commuter Plus","answer":""},{"id":"c2","gapText":"$120 per month","answer":""},{"id":"c3","gapText":"Offers free use of {{gap}} facilities","answer":"bicycle storage"}]'),
('97f7439c-f096-4a33-b06e-57302148907b', 'bcc4b87e-69c0-4fd9-9171-c401f9e07c21', 7,
 'Row 3', '',
 '[{"id":"c4","gapText":"{{gap}}","answer":"Flexi-Trip"},{"id":"c5","gapText":"$45","answer":""},{"id":"c6","gapText":"Trips that are unused are strictly {{gap}}","answer":"non-refundable"}]'),
('e14e6ffe-0454-4e6e-940d-c901aab56355', 'bcc4b87e-69c0-4fd9-9171-c401f9e07c21', 8,
 'Row 4', '',
 '[{"id":"c7","gapText":"Weekend Explorer","answer":""},{"id":"c8","gapText":"{{gap}}","answer":"$15"},{"id":"c9","gapText":"Includes rides on the {{gap}}","answer":"ferry routes"}]'),
('1e4f455b-b877-4d24-add6-5c228505f8c0', 'bcc4b87e-69c0-4fd9-9171-c401f9e07c21', 9,
 'Row 5', '',
 '[{"id":"c10","gapText":"General Rules","answer":""},{"id":"c11","gapText":"-","answer":""},{"id":"c12","gapText":"A {{gap}} of $5 is charged for replacing lost cards","answer":"processing fee"}]');

-- ── Group 3: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('a9b0d911-783a-4f89-9995-5c88b7bc7507', '1f7c0d76-41e9-494a-973b-5a80b23fc126', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS AND/OR A NUMBER from the text for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('8bf884ed-bb88-456a-b992-8098dfa8fb21', 'a9b0d911-783a-4f89-9995-5c88b7bc7507', 10,
 'Where can you purchase a MetroCard using your smartphone?', 'official MTA app', '[{"id":"1","text":"official MTA app"},{"id":"2","text":"official mobile app"},{"id":"3","text":"the official MTA app"},{"id":"4","text":"mobile app"}]'),
('6cb35075-e801-4c50-a508-dececc83cf82', 'a9b0d911-783a-4f89-9995-5c88b7bc7507', 11,
 'How long is a single journey valid for when using a Flexi-Trip pass?', 'two hours', '[{"id":"1","text":"two hours"},{"id":"2","text":"2 hours"},{"id":"3","text":"up to two hours"}]'),
('88c82441-26b8-4585-8881-4c795ede9b10', 'a9b0d911-783a-4f89-9995-5c88b7bc7507', 12,
 'What could cause weekend ferry services to stop running without warning?', 'heavy storms', '[{"id":"1","text":"heavy storms"},{"id":"2","text":"weather conditions"}]'),
('50766320-2f0d-4fee-a224-2399ec97a28b', 'a9b0d911-783a-4f89-9995-5c88b7bc7507', 13,
 'What will you receive if you do not have an activated ticket when checked by an inspector?', 'on-the-spot fine', '[{"id":"1","text":"on-the-spot fine"},{"id":"2","text":"an on-the-spot fine"},{"id":"3","text":"fine of $75"},{"id":"4","text":"$75 fine"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Remote Work & Telecommuting Policy (Q14–27)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('d0daf879-e31b-4356-a4af-ea9a51dcd3f3', 'de9ddd44-93dc-4f8e-83db-6a92a5585041', 2,
 'Corporate Guidelines: Remote Work and Telecommuting Policy',
 '(A) As part of our commitment to fostering a flexible and dynamic workplace, NovaTech Solutions has updated its telecommuting policies. Remote work is viewed as a mutually beneficial arrangement that enhances employee productivity while supporting a healthy work-life balance. However, telecommuting is not a universal right. It is a privilege granted at the discretion of department heads, based primarily on the nature of the employee’s role and their historical performance record. Not all positions are suitable for remote work, particularly those requiring direct client interaction or physical presence in the laboratory.

(B) Employees wishing to transition to a hybrid or fully remote schedule must first submit a formal Telecommuting Request Form to their immediate supervisor. This proposal should detail the requested schedule, the primary location from which they will be working, and a self-assessment of how their daily responsibilities will be managed off-site. Supervisors are required to review the application and provide a written decision within 15 business days. If denied, the supervisor must provide specific reasons, and the employee must wait a minimum of six months before reapplying.

(C) It is imperative that all remote workers maintain a safe, distraction-free environment that meets the company’s basic ergonomic and security standards. NovaTech Solutions will provide a standard tech bundle consisting of a laptop, a dual-monitor setup, and a secure VPN router. However, employees are responsible for ensuring they have a reliable, high-speed internet connection at their own expense. The IT department will not provide technical support for personal internet outages or non-company issued hardware.

(D) To ensure seamless collaboration, remote employees are expected to adhere to standard company operating hours (9:00 AM to 5:00 PM, Time Zone specific to their home office). While flexibility is a key benefit of remote work, team members must be fully accessible via the corporate messaging platform and email during these core hours. Any required deviation from this schedule, such as for a midday medical appointment, must be communicated to the team lead at least 24 hours in advance.

(E) A common concern regarding telecommuting is the potential isolation and disconnect from the company culture. To mitigate this, NovaTech requires all remote and hybrid employees to attend the "Quarterly Sync" meeting in person at the regional headquarters. Furthermore, individual departments are encouraged to host virtual social events, such as coffee breaks or trivia sessions, to maintain team cohesion. Managers should proactively schedule weekly one-on-one video calls with their remote staff to check on their well-being and project progress.

(F) Performance evaluations for remote workers will be conducted using the same metrics and standards applied to in-office staff. The focus will remain on deliverables, project completion rates, and the quality of work, rather than the volume of hours logged online. However, if a remote employee’s performance falls below expectations, their telecommuting privileges may be temporarily suspended or permanently revoked, requiring them to return to the office full-time to undergo a performance improvement plan.');

-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('99c49627-c3fb-4cc7-9043-525644647eed', 'd0daf879-e31b-4356-a4af-ea9a51dcd3f3', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. Evaluating output rather than visibility", "ii. Maintaining communication and engagement", "iii. The procedure for requesting remote work", "iv. Health and safety in the home office", "v. Eligibility requirements for remote roles", "vi. Financial support for home utilities", "vii. Equipment provision and connectivity expectations", "viii. Maintaining availability during the workday"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('0b5b7cf8-ca8f-4331-95c2-03893f6c498d', '99c49627-c3fb-4cc7-9043-525644647eed', 14, 'Paragraph A', 'v'),
('d23f227c-cfe4-4b2d-885a-035ff7fa6852', '99c49627-c3fb-4cc7-9043-525644647eed', 15, 'Paragraph B', 'iii'),
('29f6d7cb-f114-40e7-942e-ded9d23c3b7a', '99c49627-c3fb-4cc7-9043-525644647eed', 16, 'Paragraph C', 'vii'),
('4ac6ed4c-6b3c-4270-93d9-4933189ab8a8', '99c49627-c3fb-4cc7-9043-525644647eed', 17, 'Paragraph D', 'viii'),
('b1bc46ec-f843-43e7-b1d8-6386489ec06a', '99c49627-c3fb-4cc7-9043-525644647eed', 18, 'Paragraph E', 'ii'),
('3fbc6af1-0c81-4914-adb4-31481351c537', '99c49627-c3fb-4cc7-9043-525644647eed', 19, 'Paragraph F', 'i');

-- ── Group 5: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c62dda80-eb82-4e87-a0af-ddece7615734', 'd0daf879-e31b-4356-a4af-ea9a51dcd3f3', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('efb2e2f3-7a1a-412a-9f5b-0ac45902a6df', 'c62dda80-eb82-4e87-a0af-ddece7615734', 20,
 'Examples of jobs that cannot be performed from home.', 'A',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('2e169fc8-ea80-4675-bfd1-9fb68b326f86', 'c62dda80-eb82-4e87-a0af-ddece7615734', 21,
 'The mandatory in-person event that telecommuters must travel to.', 'E',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('51256270-f7ee-46f7-b98f-9c92c7470023', 'c62dda80-eb82-4e87-a0af-ddece7615734', 22,
 'What happens if a remote employee fails to deliver quality work.', 'F',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('046dcfba-c00a-45c5-b7ee-66378de8d403', 'c62dda80-eb82-4e87-a0af-ddece7615734', 23,
 'How long an employee must wait to submit a second application if the first is rejected.', 'B',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');

-- ── Group 6: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('b896afa7-7318-42d6-8977-5158539ade41', 'd0daf879-e31b-4356-a4af-ea9a51dcd3f3', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('74965eea-a3ec-4960-bc51-39ad0a3f8fa4', 'b896afa7-7318-42d6-8977-5158539ade41', 24,
 'According to Paragraph C, which of the following expenses must the employee pay for themselves?',
 'C',
 '[{"id":"A","text":"A. A secondary monitor.","isCorrect":false},{"id":"B","text":"B. The secure VPN router.","isCorrect":false},{"id":"C","text":"C. The monthly internet bill.","isCorrect":true},{"id":"D","text":"D. Repairs for the company laptop.","isCorrect":false}]'),
('1e9d7af5-360c-43dc-b65b-74f70823e0b3', 'b896afa7-7318-42d6-8977-5158539ade41', 25,
 'If an employee needs to be away from their computer during core hours, they must:',
 'A',
 '[{"id":"A","text":"A. Notify their team lead at least a day beforehand.","isCorrect":true},{"id":"B","text":"B. Make up the missed hours over the weekend.","isCorrect":false},{"id":"C","text":"C. Request official permission from the department head.","isCorrect":false},{"id":"D","text":"D. Leave an automated out-of-office message.","isCorrect":false}]'),
('16728f26-876e-4544-8b44-e44c76834a27', 'b896afa7-7318-42d6-8977-5158539ade41', 26,
 'Why are managers encouraged to conduct weekly video calls with remote staff?',
 'D',
 '[{"id":"A","text":"A. To track the number of hours they are logged in.","isCorrect":false},{"id":"B","text":"B. To ensure their home internet is functioning properly.","isCorrect":false},{"id":"C","text":"C. To prepare them for the Quarterly Sync meeting.","isCorrect":false},{"id":"D","text":"D. To monitor their well-being and project updates.","isCorrect":true}]'),
('0e7ca052-cc85-4c91-8943-577eb1c09308', 'b896afa7-7318-42d6-8977-5158539ade41', 27,
 'How does the company assess the success of a remote worker?',
 'B',
 '[{"id":"A","text":"A. By comparing them only to other remote workers.","isCorrect":false},{"id":"B","text":"B. By measuring the quality and completion of their deliverables.","isCorrect":true},{"id":"C","text":"C. By the amount of time they are active on the corporate messenger.","isCorrect":false},{"id":"D","text":"D. By reviewing the physical setup of their home office.","isCorrect":false}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: The Psychology of Decision Fatigue (Q28–40)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('061d6c63-87f6-4023-b79e-904d0540f993', 'de9ddd44-93dc-4f8e-83db-6a92a5585041', 3,
 'The Psychology of Decision Fatigue: Why Our Brains Get Tired',
 '(A) Every day, the average adult makes roughly 35,000 remotely conscious decisions. These range from the trivial, such as choosing what to eat for breakfast or which shoes to wear, to the highly complex, like negotiating a business contract or managing household finances. While human brains are remarkably powerful processors, they have a limited store of mental energy. Psychological researchers have coined the term "decision fatigue" to describe the deteriorating quality of choices made by an individual after a long session of decision making. 

(B) The concept is grounded in the psychological theory of ego depletion. Proposed by social psychologist Roy Baumeister in the late 1990s, this theory suggests that willpower and self-control draw upon a finite pool of mental resources. Just as a muscle becomes exhausted after lifting heavy weights, the brain’s capacity to regulate behavior and evaluate options tires after repeated use. When decision fatigue sets in, the brain actively seeks mental shortcuts. This typically manifests in two distinct ways: acting impulsively, or doing absolutely nothing.

(C) Impulsive decision-making occurs when the exhausted brain defaults to the easiest or most immediately rewarding option, bypassing logical evaluation. This is why supermarkets place candy and sugary snacks at the checkout counter. By the time shoppers have navigated the aisles—making dozens of micro-decisions about brands, prices, and quantities—their mental stamina is depleted. They are significantly more likely to succumb to a sugar craving at the register than they were when they first walked through the doors. 

(D) The alternative manifestation of decision fatigue is decision avoidance. When the cognitive load becomes too heavy, a person might simply refuse to make a choice, maintaining the status quo. In a famous study analyzing the rulings of parole board judges, researchers found a startling correlation between the time of day and the likelihood of a prisoner being granted parole. Prisoners who appeared before the board early in the morning were paroled about 65% of the time. However, for those appearing late in the afternoon, the favorable ruling rate dropped to nearly zero. The judges, mentally exhausted from hours of weighing complex evidence, defaulted to the safest, easiest option: keeping the prisoner locked up.

(E) Understanding decision fatigue has led many successful individuals to alter their daily routines. Tech entrepreneurs and politicians are often noted for wearing the exact same outfit every day. By eliminating the morning dilemma of what to wear, they conserve a small portion of their mental energy for more critical business or policy decisions later in the day. Similarly, financial advisors recommend that people automate their savings and bill payments to remove the constant, draining choice of whether or not to transfer money.

(F) Fortunately, cognitive exhaustion is not permanent. The brain''s energy reserves can be replenished. Studies have shown that consuming glucose—essentially, eating a nutritious snack—can provide a short-term boost to willpower. More importantly, taking regular, genuine breaks where no choices are required allows the mental "muscle" to recover. Ultimately, by recognizing that our cognitive energy is a limited resource, we can strategically structure our days to ensure that we tackle our most important decisions when our minds are freshest.');

-- ── Group 7: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('cdbf4a50-229b-4755-ace2-a47df4afb5ce', '061d6c63-87f6-4023-b79e-904d0540f993', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('dd1f2645-5aee-4844-89cf-09becdd56b87', 'cdbf4a50-229b-4755-ace2-a47df4afb5ce', 28,
 'Roy Baumeister based his theory of ego depletion on previous research into muscle fatigue.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('9e57f0d9-fa39-4632-9c70-f46a9ea238c1', 'cdbf4a50-229b-4755-ace2-a47df4afb5ce', 29,
 'People are more likely to buy junk food at the checkout because they have already exhausted their willpower in the store.', 'YES', '["YES","Yes","yes"]'),
('538e870e-54b2-411c-a68d-b4d2736a4314', 'cdbf4a50-229b-4755-ace2-a47df4afb5ce', 30,
 'Parole board judges deliberately choose to be stricter with prisoners in the afternoon.', 'NO', '["NO","No","no"]'),
('8f82a4d2-ada3-43f8-915f-dfdae0ac0405', 'cdbf4a50-229b-4755-ace2-a47df4afb5ce', 31,
 'Eating food containing glucose permanently cures decision fatigue.', 'NO', '["NO","No","no"]');

-- ── Group 8: MATCHING SENTENCE ENDINGS (Q32–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('2328e5fc-4e1b-477e-9bbc-c3a699a46d3e', '061d6c63-87f6-4023-b79e-904d0540f993', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('6c04c12f-95d7-47d1-b53a-4a19881c8efb', '2328e5fc-4e1b-477e-9bbc-c3a699a46d3e', 32,
 'When the brain is affected by decision fatigue, it generally attempts to',
 'C',
 '[{"id":"A","text":"find the most logical solution to the problem.","isCorrect":false},{"id":"B","text":"save mental energy for important tasks in the evening.","isCorrect":false},{"id":"C","text":"find easier alternatives or avoid making choices entirely.","isCorrect":true},{"id":"D","text":"maintain the status quo because it is the safest option.","isCorrect":false},{"id":"E","text":"prevent themselves from wasting time on clothing choices.","isCorrect":false},{"id":"F","text":"automate important financial investments.","isCorrect":false}]'),
('89262f9d-f3f3-4396-bfd5-c483278d5de4', '2328e5fc-4e1b-477e-9bbc-c3a699a46d3e', 33,
 'Tired parole judges often deny prisoners parole because they wish to',
 'D',
 '[{"id":"A","text":"find the most logical solution to the problem.","isCorrect":false},{"id":"B","text":"save mental energy for important tasks in the evening.","isCorrect":false},{"id":"C","text":"find easier alternatives or avoid making choices entirely.","isCorrect":false},{"id":"D","text":"maintain the status quo because it is the safest option.","isCorrect":true},{"id":"E","text":"prevent themselves from wasting time on clothing choices.","isCorrect":false},{"id":"F","text":"automate important financial investments.","isCorrect":false}]'),
('870ad1a2-d11b-4f9c-9323-33f37ecf4ea1', '2328e5fc-4e1b-477e-9bbc-c3a699a46d3e', 34,
 'Certain famous business leaders wear identical outfits daily to',
 'E',
 '[{"id":"A","text":"find the most logical solution to the problem.","isCorrect":false},{"id":"B","text":"save mental energy for important tasks in the evening.","isCorrect":false},{"id":"C","text":"find easier alternatives or avoid making choices entirely.","isCorrect":false},{"id":"D","text":"maintain the status quo because it is the safest option.","isCorrect":false},{"id":"E","text":"prevent themselves from wasting time on clothing choices.","isCorrect":true},{"id":"F","text":"automate important financial investments.","isCorrect":false}]'),
('fe9eb93c-2c81-49fd-88d1-5e115cfe88d7', '2328e5fc-4e1b-477e-9bbc-c3a699a46d3e', 35,
 'A recommended strategy for managing household bills is to',
 'F',
 '[{"id":"A","text":"find the most logical solution to the problem.","isCorrect":false},{"id":"B","text":"save mental energy for important tasks in the evening.","isCorrect":false},{"id":"C","text":"find easier alternatives or avoid making choices entirely.","isCorrect":false},{"id":"D","text":"maintain the status quo because it is the safest option.","isCorrect":false},{"id":"E","text":"prevent themselves from wasting time on clothing choices.","isCorrect":false},{"id":"F","text":"automate important financial investments.","isCorrect":true}]');

-- ── Group 9: SUMMARY COMPLETION with Word Bank (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('9ec718e8-30d6-4e5b-8624-d864d724634f', '061d6c63-87f6-4023-b79e-904d0540f993', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["infinite", "limited", "glucose", "clothing", "shortcuts", "willpower", "breaks", "judges"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('2391e540-1e87-4c3e-a700-83dc79be1e0e', '9ec718e8-30d6-4e5b-8624-d864d724634f', 36,
 'The theory of ego depletion argues that human self-control relies on a {{gap_9ec718e8-30d6-4e5b-8624-d864d724634f_0}} amount of mental resources. When we make too many choices, we experience decision fatigue. Our brains then look for cognitive {{gap_9ec718e8-30d6-4e5b-8624-d864d724634f_1}}, causing us to either make impulsive decisions or avoid making them at all. To combat this, experts suggest reducing minor daily choices, such as selecting {{gap_9ec718e8-30d6-4e5b-8624-d864d724634f_2}}, to conserve energy. Additionally, consuming {{gap_9ec718e8-30d6-4e5b-8624-d864d724634f_3}} can provide a temporary increase in mental strength, but the best way to recover cognitive stamina is by taking genuine {{gap_9ec718e8-30d6-4e5b-8624-d864d724634f_4}}.',
 'limited'),
('16d92a93-5180-4980-aa68-158b3293fc88', '9ec718e8-30d6-4e5b-8624-d864d724634f', 37,
 '', 'shortcuts'),
('fb314bc4-a58c-43df-88a6-d1dd1173837c', '9ec718e8-30d6-4e5b-8624-d864d724634f', 38,
 '', 'clothing'),
('61a8af10-0aa1-465c-8609-b48f5889191c', '9ec718e8-30d6-4e5b-8624-d864d724634f', 39,
 '', 'glucose'),
('1b89ce5d-b938-4a14-8173-073ab346a43d', '9ec718e8-30d6-4e5b-8624-d864d724634f', 40,
 '', 'breaks');

-- ============================================================
-- NOTE: Please execute `UPDATE reading_tests SET created_by = '<your-uid>'` 
-- if required by your application's Row Level Security policies.
-- ============================================================
