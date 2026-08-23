-- ============================================================
-- IELTS Practice Platform – Extended Seed Data
-- Target: Reading Module (General Training, Band 8 Difficulty)
-- Action: APPEND (No TRUNCATE)
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST ENTRY (General Training - Band 8)                   ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('5622a4a1-b5b8-4c94-b6a2-7e02bd642cf4', '7a02baf6-5692-4269-94f4-dae3e51ed951',
 'IELTS General Training Reading: Aviation Security, Executive Coaching & High-Frequency Trading (Band 8)', 'General Training', '8', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: Aviation Ground Operations (Q1–13)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('2de8f7b1-375a-4a83-a159-a84a36f027c8', '5622a4a1-b5b8-4c94-b6a2-7e02bd642cf4', 1,
 'Horizon Aviation Ground Operations: Security and Compliance Manual',
 'Access Control and Identification 
All ground staff must prominently display their Aviation Security Identification Card (ASIC) above the waist at all times while within the Security Restricted Area (SRA). Personnel found without valid, visible identification will be immediately escorted from the premises and subjected to a mandatory formal disciplinary hearing. ASICs are strictly non-transferable; any employee caught facilitating unauthorized access by "tailgating"—allowing another individual to pass through a secure door behind them without swiping their own card—will face instant dismissal. Temporary visitor passes are available from the central security office but require a minimum of 48 hours advance notice and a comprehensive background check.

Baggage Reconciliation System (BRS) 
To comply with international counter-terrorism directives, Horizon Aviation employs a strict Baggage Reconciliation System. Under no circumstances may a piece of checked luggage be loaded onto an aircraft if the corresponding passenger has not physically boarded the flight. If a passenger fails to present themselves at the boarding gate by the stipulated cut-off time, the ground handling crew must locate and offload their luggage. This process must be completed within 15 minutes to prevent departure delays. If the offload exceeds this timeframe, the Ramp Supervisor must submit a Delay Attribution Report to the operations control center.

Hazardous Materials (HAZMAT) Handling 
Ground handlers frequently encounter goods that are classified as hazardous materials. Proper categorization and handling are vital. 
- Category 1 (Explosives & Flammables): Items such as fireworks, flares, and industrial solvents are unequivocally prohibited from passenger aircraft holds and must be redirected to dedicated cargo freighters.
- Category 2 (Lithium Batteries): Loose lithium-ion batteries are banned from checked luggage due to the risk of thermal runaway. However, batteries that are integrated into electronic devices (e.g., laptops, smartphones) are permissible, provided the device is completely powered off and not left in "sleep" mode.
- Category 3 (Biological Substances): Medical samples and biological specimens may be transported in the hold, but they must be encased in triple-layer, temperature-controlled packaging bearing the exact UN3373 classification label.

Incident Reporting 
Any breach of security protocols, no matter how ostensibly minor, must be documented. The observer must fill out a Form 14-B (Security Incident Report) and submit it to the Duty Manager before the conclusion of their shift. Failure to report a known security anomaly is treated with the same severity as committing the breach itself. Employees should be aware that all ramp activities are monitored by high-definition, closed-circuit surveillance, and footage is randomly audited on a weekly basis by federal aviation inspectors.');

-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('fa1072df-8b6b-481b-8396-a549e05b8491', '2de8f7b1-375a-4a83-a159-a84a36f027c8', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the text? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('6f72da1d-534b-4977-bb1d-62970193bc80', 'fa1072df-8b6b-481b-8396-a549e05b8491', 1,
 'An employee can be fired immediately for holding a secure door open for someone who does not swipe their card.', 'TRUE', '["TRUE","True","true"]'),
('8de0647d-1775-494b-bdee-477a5cb3850e', 'fa1072df-8b6b-481b-8396-a549e05b8491', 2,
 'Visitor passes can be issued immediately on the day if requested by a senior manager.', 'FALSE', '["FALSE","False","false"]'),
('9006df4b-c207-4844-9d4c-f23af3d18aa0', 'fa1072df-8b6b-481b-8396-a549e05b8491', 3,
 'Federal aviation inspectors conduct their weekly audits of surveillance footage remotely from an external office.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('5d47243d-6911-4c47-b1c8-5d1fb2373937', 'fa1072df-8b6b-481b-8396-a549e05b8491', 4,
 'Checked luggage cannot travel on an aircraft if the passenger is not on board.', 'TRUE', '["TRUE","True","true"]');

-- ── Group 2: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('4b7ca8ac-1a42-4352-ad19-c9a4a72fbd09', '2de8f7b1-375a-4a83-a159-a84a36f027c8', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN TWO WORDS from the text for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('08197010-d3c4-4466-bdc2-db88c502403f', '4b7ca8ac-1a42-4352-ad19-c9a4a72fbd09', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"HAZMAT Category","answer":""},{"id":"h2","gapText":"Examples","answer":""},{"id":"h3","gapText":"Handling Rule","answer":""}]'),
('b697195d-b17f-4897-b18d-617d93089aaa', '4b7ca8ac-1a42-4352-ad19-c9a4a72fbd09', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"Category 1","answer":""},{"id":"c2","gapText":"Fireworks, industrial solvents","answer":""},{"id":"c3","gapText":"Must be sent to {{gap}}","answer":"cargo freighters"}]'),
('41b44cc5-2cd5-40c1-a1cf-d042704f09d0', '4b7ca8ac-1a42-4352-ad19-c9a4a72fbd09', 7,
 'Row 3', '',
 '[{"id":"c4","gapText":"Category 2","answer":""},{"id":"c5","gapText":"{{gap}} batteries","answer":"Loose lithium-ion"},{"id":"c6","gapText":"Banned due to thermal runaway risk","answer":""}]'),
('5e85a084-65e0-4313-be39-706c3aeef7c3', '4b7ca8ac-1a42-4352-ad19-c9a4a72fbd09', 8,
 'Row 4', '',
 '[{"id":"c7","gapText":"Category 2 (Devices)","answer":""},{"id":"c8","gapText":"Laptops, smartphones","answer":""},{"id":"c9","gapText":"Allowed if device is completely {{gap}}","answer":"powered off"}]'),
('89470c73-5f0e-4944-9a0d-753358781bd5', '4b7ca8ac-1a42-4352-ad19-c9a4a72fbd09', 9,
 'Row 5', '',
 '[{"id":"c10","gapText":"Category 3","answer":""},{"id":"c11","gapText":"Medical samples","answer":""},{"id":"c12","gapText":"Must have the correct {{gap}} attached","answer":"classification label"}]');

-- ── Group 3: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('beda0d07-1cb3-42a4-8f4b-82204b6ad15e', '2de8f7b1-375a-4a83-a159-a84a36f027c8', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS AND/OR A NUMBER from the text for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('9c903d55-9add-46db-84c8-7d373fdfdf10', 'beda0d07-1cb3-42a4-8f4b-82204b6ad15e', 10,
 'What specific document must be submitted if removing a passenger’s bag takes too long?', 'Delay Attribution Report', '[{"id":"1","text":"Delay Attribution Report"},{"id":"2","text":"a Delay Attribution Report"}]'),
('8702f741-dbfb-4fce-b276-afa7e2a39ea9', 'beda0d07-1cb3-42a4-8f4b-82204b6ad15e', 11,
 'What is the maximum time allowed to locate and remove the baggage of a missing passenger?', '15 minutes', '[{"id":"1","text":"15 minutes"},{"id":"2","text":"fifteen minutes"}]'),
('cacb4078-44a6-476c-86f5-a8c7038bced3', 'beda0d07-1cb3-42a4-8f4b-82204b6ad15e', 12,
 'What type of packaging is required for biological specimens transported in the hold?', 'triple-layer, temperature-controlled', '[{"id":"1","text":"triple-layer, temperature-controlled"},{"id":"2","text":"temperature-controlled packaging"}]'),
('0e8b980a-9bea-4db7-8b16-d325aeabea3f', 'beda0d07-1cb3-42a4-8f4b-82204b6ad15e', 13,
 'Who must receive a Form 14-B before an employee finishes their shift?', 'Duty Manager', '[{"id":"1","text":"Duty Manager"},{"id":"2","text":"the Duty Manager"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Executive Coaching Framework (Q14–27)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('ffdb858c-ed7e-41e8-bae5-007404fc1f77', '5622a4a1-b5b8-4c94-b6a2-7e02bd642cf4', 2,
 'Stratagem Consulting: Navigating the Executive Coaching Framework',
 '(A) In the contemporary corporate landscape, the transition from middle management to senior executive leadership is fraught with paradigm shifts. Technical proficiency, while previously paramount, becomes subordinate to emotional intelligence, strategic foresight, and stakeholder management. Recognizing this, Stratagem Consulting has instituted a mandatory Executive Coaching Framework for all newly promoted directors. This initiative is not a remedial measure for underperformance; rather, it is a proactive investment in human capital designed to accelerate the acclimatization process and mitigate the inherent risks of executive derailment.

(B) The coaching engagement spans a rigorous six-month period, commencing with a comprehensive 360-degree diagnostic assessment. This evaluation involves soliciting anonymous feedback from the executive’s subordinates, peers, and superiors, thereby circumventing the self-reporting bias that often plagues traditional appraisals. The aggregated data provides a granular, unvarnished portrait of the executive’s behavioral blind spots and leadership efficacy. Crucially, the results are treated with absolute confidentiality; they are utilized solely by the external coach and the executive to formulate a bespoke development plan, and are explicitly excluded from the company’s formal performance review metrics.

(C) Following the diagnostic phase, the coach and executive engage in bi-weekly, intensive one-on-one sessions. These meetings are heavily focused on cognitive reframing—a psychological technique wherein the executive is challenged to dismantle ingrained, counterproductive thought patterns. For instance, a common hurdle for new directors is the reluctance to delegate, rooted in a perfectionist desire to maintain granular control over outputs. The coach facilitates a shift in this mindset, guiding the executive to recognize that their primary mandate is no longer operational execution, but rather capacity building and strategic delegation.

(D) A cornerstone of the Stratagem methodology is "contextual application." Abstract leadership theories are of limited utility if they cannot be operationalized within the specific cultural nuances of the organization. Therefore, the coach frequently requires the executive to "shadow" complex stakeholder meetings or high-stakes negotiations, observing the executive''s interpersonal dynamics in real-time. Subsequent sessions are then utilized to dissect these interactions, analyzing non-verbal cues, negotiation tactics, and the efficacy of the executive’s persuasion strategies. 

(E) Despite its benefits, the coaching framework occasionally encounters resistance. Some executives harbor deeply ingrained skepticism, viewing the process as an intrusive psychoanalysis rather than professional development. This defensiveness is often exacerbated by a corporate culture that historically penalized vulnerability. To counter this, coaches establish a strictly non-judgmental environment, emphasizing that the coaching space is a "psychological safe zone" where strategic failures can be hypothesized and dissected without professional repercussions. 

(F) The culmination of the six-month engagement involves a formal alignment review. However, measuring the Return on Investment (ROI) of executive coaching is notoriously elusive, as the outcomes—enhanced emotional regulation, improved team cohesion, and sharper strategic vision—are inherently qualitative. Stratagem Consulting attempts to quantify this by conducting a second, modified 360-degree assessment at the end of the term, measuring delta shifts in peer perception. Ultimately, the success of the framework is judged not merely by the individual’s progression, but by the measurable uplift in the performance metrics of the departments they lead.');

-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('4fcca3a3-5f27-4040-ab5a-636fcde12d12', 'ffdb858c-ed7e-41e8-bae5-007404fc1f77', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. Evaluating the intangible benefits of the program", "ii. Overcoming participant reluctance and defensiveness", "iii. The rationale behind providing coaching to new leaders", "iv. Financial penalties for failing to complete the program", "v. Altering fundamental approaches to work and control", "vi. Identifying flaws through anonymous, multi-level feedback", "vii. Applying psychological theories to recruitment", "viii. Observing and analyzing real-world workplace interactions"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('83496171-bb5e-4400-ba31-42e28fb834c1', '4fcca3a3-5f27-4040-ab5a-636fcde12d12', 14, 'Paragraph A', 'iii'),
('6f1cf2fd-4736-4be0-bcb6-e9d91cc28e5e', '4fcca3a3-5f27-4040-ab5a-636fcde12d12', 15, 'Paragraph B', 'vi'),
('59100316-9e15-47bd-ad39-36a55983836d', '4fcca3a3-5f27-4040-ab5a-636fcde12d12', 16, 'Paragraph C', 'v'),
('f4d54c3c-2aee-4b4e-a909-d181e496011c', '4fcca3a3-5f27-4040-ab5a-636fcde12d12', 17, 'Paragraph D', 'viii'),
('a88313b6-3dde-47bd-857e-bc3b9ff8757a', '4fcca3a3-5f27-4040-ab5a-636fcde12d12', 18, 'Paragraph E', 'ii'),
('cfd83658-3b25-4dac-942a-25f4892b9166', '4fcca3a3-5f27-4040-ab5a-636fcde12d12', 19, 'Paragraph F', 'i');

-- ── Group 5: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('7e923110-5861-4a01-aa59-61808488b5c9', 'ffdb858c-ed7e-41e8-bae5-007404fc1f77', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('c7e26930-bf64-4fac-ae51-7429d6e24920', '7e923110-5861-4a01-aa59-61808488b5c9', 20,
 'A mechanism used to prevent the coaching from affecting official company performance ratings.', 'B',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('246e8a96-720e-490e-832d-f6b4dd89dc51', '7e923110-5861-4a01-aa59-61808488b5c9', 21,
 'An explanation of why calculating the precise financial value of the coaching is difficult.', 'F',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('b1ad10da-b940-48b0-8803-90a841ac8cbd', '7e923110-5861-4a01-aa59-61808488b5c9', 22,
 'An example of a specific mindset that frequently causes problems for recently promoted directors.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('81e54e09-dcd1-4755-abd0-d4700215dd81', '7e923110-5861-4a01-aa59-61808488b5c9', 23,
 'A historical reason why some staff might be afraid to show weakness during the sessions.', 'E',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');

-- ── Group 6: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('03529a48-935b-44b2-9869-32909b11640e', 'ffdb858c-ed7e-41e8-bae5-007404fc1f77', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('f65511f3-be3e-49b2-afda-d89c11833b75', '03529a48-935b-44b2-9869-32909b11640e', 24,
 'According to Paragraph A, the coaching program is primarily implemented to:',
 'D',
 '[{"id":"A","text":"A. Address technical deficiencies in underperforming managers.","isCorrect":false},{"id":"B","text":"B. Teach new executives how to handle disciplinary hearings.","isCorrect":false},{"id":"C","text":"C. Replace the need for traditional stakeholder management.","isCorrect":false},{"id":"D","text":"D. Help new directors adapt quickly and avoid failure.","isCorrect":true}]'),
('459128f9-bd68-4e7f-b97c-c49bb5f4e44a', '03529a48-935b-44b2-9869-32909b11640e', 25,
 'Why does the company use a 360-degree assessment instead of a standard appraisal?',
 'B',
 '[{"id":"A","text":"A. It is significantly cheaper and faster to administer.","isCorrect":false},{"id":"B","text":"B. It avoids the bias of individuals evaluating their own performance.","isCorrect":true},{"id":"C","text":"C. It allows human resources to formally track executive mistakes.","isCorrect":false},{"id":"D","text":"D. It forces subordinates to confront their managers publicly.","isCorrect":false}]'),
('60d404c9-2897-4a7d-ab47-c46f28f45814', '03529a48-935b-44b2-9869-32909b11640e', 26,
 'The technique of "contextual application" mentioned in Paragraph D involves:',
 'C',
 '[{"id":"A","text":"A. Forcing executives to read extensive psychological literature.","isCorrect":false},{"id":"B","text":"B. Role-playing fictional scenarios in an isolated boardroom.","isCorrect":false},{"id":"C","text":"C. The coach observing the executive during actual business meetings.","isCorrect":true},{"id":"D","text":"D. Changing the overarching corporate culture of Stratagem Consulting.","isCorrect":false}]'),
('9c6dee68-df8c-473c-8e48-0835d425f64f', '03529a48-935b-44b2-9869-32909b11640e', 27,
 'How does Stratagem Consulting attempt to measure the ultimate success of the coaching program?',
 'A',
 '[{"id":"A","text":"A. By looking for improvements in the performance of the executive’s team.","isCorrect":true},{"id":"B","text":"B. By calculating the exact financial profit generated during the six months.","isCorrect":false},{"id":"C","text":"C. By publishing the results of the second 360-degree diagnostic.","isCorrect":false},{"id":"D","text":"D. By testing the executive’s theoretical knowledge of emotional intelligence.","isCorrect":false}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: High-Frequency Trading (Q28–40)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('4fd237c7-42e1-4a22-9239-62093ebf6f3e', '5622a4a1-b5b8-4c94-b6a2-7e02bd642cf4', 3,
 'Algorithmic Markets: The Hidden Architecture of Modern Finance',
 '(A) If you picture a stock exchange, you likely envision a chaotic room filled with traders shouting orders and waving frantically at digital screens. This cinematic cliché, however, is a relic of the past. Today, the world’s financial markets are shockingly quiet. The frantic shouting has been replaced by the silent hum of servers located in heavily guarded, climate-controlled data centers. Modern trading is overwhelmingly dominated by High-Frequency Trading (HFT) algorithms—sophisticated mathematical models executing thousands of trades per second, far beyond the threshold of human perception.

(B) The premise of HFT is fundamentally rooted in latency arbitrage. In the financial sector, "latency" refers to the time it takes for a data packet to travel from an exchange to a trader’s computer and back. We are no longer measuring this in seconds, but in microseconds (millionths of a second). HFT firms spend billions of dollars to shave fractions of a microsecond off their transmission times. They lay straight-line fiber-optic cables through mountains and utilize microwave towers simply to receive market data a fraction of an instant before their competitors. By seeing price changes infinitesimally earlier, these algorithms can buy a stock and immediately sell it to a slower market participant for a micro-fraction of a cent in profit. Multiply this by millions of trades a day, and the profits are astronomical.

(C) Proponents of HFT argue that these algorithms provide a vital service to the market: liquidity. Because HFT systems are constantly buying and selling, they ensure that there is always a counterparty available when an ordinary investor wishes to trade. This continuous activity narrows the "bid-ask spread"—the difference between the highest price a buyer is willing to pay and the lowest price a seller is willing to accept. According to HFT advocates, this tight spread effectively lowers transaction costs for everyone, including pension funds and retail investors, making the market highly efficient.

(D) However, this supposed liquidity is highly controversial. Critics, including many prominent economists, argue that the liquidity provided by HFT is "phantom liquidity." Because the algorithms are programmed to cancel orders within microseconds if market conditions shift slightly, the promised liquidity can vanish exactly when it is needed most. This phenomenon was starkly demonstrated during the "Flash Crash" of 2010. Over the course of just 36 minutes, the Dow Jones Industrial Average plunged by nearly 1,000 points, temporarily wiping out a trillion dollars in market value, before inexplicably rebounding. Subsequent investigations revealed that HFT algorithms, reacting to a large sell order, essentially panicked and withdrew their capital from the market simultaneously, creating a catastrophic vacuum.

(E) Furthermore, the arms race for speed has created an environment where fundamental economic valuation is often ignored. Traditional investors analyze a company’s earnings, leadership, and market potential to determine its stock value. HFT algorithms, conversely, are largely agnostic to the actual companies they are trading. They are programmed to detect momentum, pattern anomalies, and the electronic footprints of large institutional orders, exploiting these structural mechanics rather than investing in economic growth. This decoupling of share price from underlying corporate reality raises profound philosophical questions about the purpose of capital markets.

(F) Regulators are currently struggling to adapt to this hyper-accelerated landscape. Implementing effective oversight is exceptionally difficult when the regulators themselves lack the technological infrastructure to monitor trading activity occurring at light speed. Proposals such as implementing a "Tobin tax"—a microscopic tax on every financial transaction designed to make high-frequency flipping unprofitable—have been fiercely lobbied against by the financial industry. Until regulatory frameworks catch up to the technology, the global economy remains tethered to a digital architecture that operates faster than human comprehension, optimizing for microsecond profits rather than long-term stability.');

-- ── Group 7: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('b7334522-46c9-4dd0-955a-22f9e9da0fa8', '4fd237c7-42e1-4a22-9239-62093ebf6f3e', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('e1c6b633-62e9-40ca-953a-203252e40bdc', 'b7334522-46c9-4dd0-955a-22f9e9da0fa8', 28,
 'The physical layout of modern stock exchanges resembles the chaotic trading floors shown in older movies.', 'NO', '["NO","No","no"]'),
('15a58fb5-bd95-4678-8346-2a2af4473c4b', 'b7334522-46c9-4dd0-955a-22f9e9da0fa8', 29,
 'High-frequency trading firms generate revenue by making a large profit margin on a small number of carefully chosen stocks.', 'NO', '["NO","No","no"]'),
('a7e32d25-45b1-471d-b270-851ddad6e620', 'b7334522-46c9-4dd0-955a-22f9e9da0fa8', 30,
 'HFT advocates claim that algorithmic trading ultimately reduces the cost of trading for everyday investors.', 'YES', '["YES","Yes","yes"]'),
('3d921d46-21ff-4741-9dc3-a7588a44b5c7', 'b7334522-46c9-4dd0-955a-22f9e9da0fa8', 31,
 'The 2010 Flash Crash resulted in permanent financial losses that bankrupted several major pension funds.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]');

-- ── Group 8: MATCHING SENTENCE ENDINGS (Q32–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('d2c13241-88c2-4d67-bba2-cd5559fec0d8', '4fd237c7-42e1-4a22-9239-62093ebf6f3e', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('52249cd5-e0e0-4f23-8c4d-fbcd9d88dfdc', 'd2c13241-88c2-4d67-bba2-cd5559fec0d8', 32,
 'To minimize latency, HFT companies',
 'F',
 '[{"id":"A","text":"have successfully implemented a small tax on every financial transaction.","isCorrect":false},{"id":"B","text":"often disappear entirely when the market experiences sudden volatility.","isCorrect":false},{"id":"C","text":"focus entirely on analyzing a company’s leadership and long-term earnings potential.","isCorrect":false},{"id":"D","text":"do not have the necessary computing power to properly oversee HFT algorithms.","isCorrect":false},{"id":"E","text":"rely on detecting electronic patterns rather than assessing real corporate value.","isCorrect":false},{"id":"F","text":"invest heavily in building direct, high-speed physical communication networks.","isCorrect":true}]'),
('ac195fa9-cb40-4212-9579-3c3b2d961801', 'd2c13241-88c2-4d67-bba2-cd5559fec0d8', 33,
 'Critics point out that the liquidity provided by HFT can',
 'B',
 '[{"id":"A","text":"have successfully implemented a small tax on every financial transaction.","isCorrect":false},{"id":"B","text":"often disappear entirely when the market experiences sudden volatility.","isCorrect":true},{"id":"C","text":"focus entirely on analyzing a company’s leadership and long-term earnings potential.","isCorrect":false},{"id":"D","text":"do not have the necessary computing power to properly oversee HFT algorithms.","isCorrect":false},{"id":"E","text":"rely on detecting electronic patterns rather than assessing real corporate value.","isCorrect":false},{"id":"F","text":"invest heavily in building direct, high-speed physical communication networks.","isCorrect":false}]'),
('99cd2d53-45bd-4416-9536-5fb9447a49d1', 'd2c13241-88c2-4d67-bba2-cd5559fec0d8', 34,
 'Unlike traditional investors, HFT algorithms',
 'E',
 '[{"id":"A","text":"have successfully implemented a small tax on every financial transaction.","isCorrect":false},{"id":"B","text":"often disappear entirely when the market experiences sudden volatility.","isCorrect":false},{"id":"C","text":"focus entirely on analyzing a company’s leadership and long-term earnings potential.","isCorrect":false},{"id":"D","text":"do not have the necessary computing power to properly oversee HFT algorithms.","isCorrect":false},{"id":"E","text":"rely on detecting electronic patterns rather than assessing real corporate value.","isCorrect":true},{"id":"F","text":"invest heavily in building direct, high-speed physical communication networks.","isCorrect":false}]'),
('a03aa605-10d1-4d0f-850a-2f91a1de39f2', 'd2c13241-88c2-4d67-bba2-cd5559fec0d8', 35,
 'Government financial regulators currently',
 'D',
 '[{"id":"A","text":"have successfully implemented a small tax on every financial transaction.","isCorrect":false},{"id":"B","text":"often disappear entirely when the market experiences sudden volatility.","isCorrect":false},{"id":"C","text":"focus entirely on analyzing a company’s leadership and long-term earnings potential.","isCorrect":false},{"id":"D","text":"do not have the necessary computing power to properly oversee HFT algorithms.","isCorrect":true},{"id":"E","text":"rely on detecting electronic patterns rather than assessing real corporate value.","isCorrect":false},{"id":"F","text":"invest heavily in building direct, high-speed physical communication networks.","isCorrect":false}]');

-- ── Group 9: SUMMARY COMPLETION with Word Bank (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('82bf431c-139e-4dea-9c19-13deb01faafa', '4fd237c7-42e1-4a22-9239-62093ebf6f3e', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["vacuum", "latency", "agnostic", "liquidity", "valuation", "tax", "infrastructure", "momentum"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('96d50d11-0280-4c2d-9371-cf58b67e712d', '82bf431c-139e-4dea-9c19-13deb01faafa', 36,
 'High-frequency trading utilizes advanced technology to exploit microsecond differences in data transmission, a concept known as {{gap_82bf431c-139e-4dea-9c19-13deb01faafa_0}} arbitrage. While supporters claim these systems benefit markets by providing constant {{gap_82bf431c-139e-4dea-9c19-13deb01faafa_1}}, critics argue this is unreliable and can lead to severe crashes when algorithms suddenly withdraw. Furthermore, HFT represents a shift away from traditional investing because algorithms are entirely {{gap_82bf431c-139e-4dea-9c19-13deb01faafa_2}} to the real-world value of a company, focusing instead on market {{gap_82bf431c-139e-4dea-9c19-13deb01faafa_3}}. Attempts to control this industry, such as introducing a transaction {{gap_82bf431c-139e-4dea-9c19-13deb01faafa_4}}, have faced massive opposition, leaving regulators struggling to catch up.',
 'latency'),
('429157e5-ef7f-4c6a-b365-1ab69184315e', '82bf431c-139e-4dea-9c19-13deb01faafa', 37,
 '', 'liquidity'),
('459a64de-915e-425b-9cf3-268a2b6ebd27', '82bf431c-139e-4dea-9c19-13deb01faafa', 38,
 '', 'agnostic'),
('f90187d4-ba35-4b40-bbae-04f8d31faab9', '82bf431c-139e-4dea-9c19-13deb01faafa', 39,
 '', 'momentum'),
('52fa3953-3a34-44c5-b28d-022e504777be', '82bf431c-139e-4dea-9c19-13deb01faafa', 40,
 '', 'tax');

-- ============================================================
-- NOTE: Please execute `UPDATE reading_tests SET created_by = '<your-uid>'` 
-- if required by your application's Row Level Security policies.
-- ============================================================
