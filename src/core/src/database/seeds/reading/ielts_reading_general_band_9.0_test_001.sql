-- ============================================================
-- IELTS Practice Platform – Extended Seed Data
-- Target: Reading Module (General Training, Band 9 Difficulty)
-- Action: APPEND (No TRUNCATE)
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST ENTRY (General Training - Band 9)                   ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('74d8bb40-8d16-45ee-b920-cb93b33a02da', 'aacb9b68-1ecd-49fe-bf2e-b621e68842a6',
 'IELTS General Training Reading: Complex Contracts, Corporate Protocols & Metacognition (Band 9)', 'General Training', '9', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: Titanium Corporate Fleet Leasing (Q1–13)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('98a2f7dd-4c70-4cca-868b-d666600e3cb3', '74d8bb40-8d16-45ee-b920-cb93b33a02da', 1,
 'Titanium Corporate Fleet Leasing: Executive Terms and Conditions',
 '(A) Operational Scope and Geographical Limitations
Vehicles leased under the Titanium Executive Tier are explicitly designated for corporate, non-commercial transit within a highly restricted operational radius. Unless an overriding cross-border addendum has been ratified by the Titanium Risk Assessment Board, vehicles must not be driven beyond a 500-mile radius of the lessee’s registered corporate headquarters. Interstate travel is permitted within this radius; however, all accumulated toll tariffs, emission zone surcharges, and congestion levies remain the exclusive financial liability of the lessee. GPS telematics are pre-installed to monitor geographical compliance; disabling these systems constitutes an unrectifiable breach of contract, resulting in immediate vehicle repossession without a preliminary grace period.

(B) Routine Maintenance and Authorized Servicing
To preserve the mechanical integrity and residual value of the fleet, Titanium assumes the cost of all routine preventative maintenance, including fluid replacements, brake pad renewals, and biennial diagnostic evaluations. Crucially, this provision is strictly contingent upon the lessee utilizing our pre-approved network of certified automotive technicians. Should a lessee authorize servicing at an unverified, independent facility, the maintenance warranty is voided instantaneously, and the lessee becomes liable for all subsequent mechanical failures, regardless of origin. In the event of a dashboard malfunction indicator light—specifically the red ''engine thermal threshold'' warning—the lessee must halt transit immediately and dispatch a Titanium recovery unit.

(C) Premium Liability and Collision Protocols
The Executive Tier incorporates our highest echelon of liability mitigation. In the event of a catastrophic collision rendering the vehicle a total loss, the insurance underwriter will absolve the lessee of the remaining depreciation deficit, provided a formal police report is filed within 24 hours and post-incident toxicology screenings return negative. While environmental damage (e.g., hail, flood) is fully covered under the premium tier, personal property left unattended within the cabin remains entirely uninsured by Titanium. 

(D) End-of-Term Surrender and Depreciation
Upon the expiration of the 36-month lease term, the vehicle must be surrendered at a designated Titanium terminal. A preliminary visual inspection will be conducted to assess compliance with the Fair Wear and Tear guidelines. Micro-abrasions to the clear-coat paintwork and minor interior upholstery creasing are deemed acceptable. However, any structural deformation to the alloy wheels, or nicotine residue permeating the ventilation system, will incur aggressive financial penalties, deducted directly from the corporate retainer fee held in escrow.');

-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('afa83cd8-8567-488a-ad53-c2cdc1dd8497', '98a2f7dd-4c70-4cca-868b-d666600e3cb3', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the text? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('626ecdba-6d6c-49f5-afb6-f74f4ec9e569', 'afa83cd8-8567-488a-ad53-c2cdc1dd8497', 1,
 'Lessees are exempt from paying toll charges if they are driving within the permitted 500-mile radius.', 'FALSE', '["FALSE","False","false"]'),
('ec9a60f0-33ed-40ea-a1b2-ac8056e1c008', 'afa83cd8-8567-488a-ad53-c2cdc1dd8497', 2,
 'Lessees will be given a warning period before repossession if they disconnect the vehicle’s tracking technology.', 'FALSE', '["FALSE","False","false"]'),
('76191585-18b8-413a-a3da-8d2cf6f1f912', 'afa83cd8-8567-488a-ad53-c2cdc1dd8497', 3,
 'The premium liability insurance will not compensate the lessee for laptops or briefcases stolen from the vehicle.', 'TRUE', '["TRUE","True","true"]'),
('903e75da-3885-48fa-b317-d5368ff1f00e', 'afa83cd8-8567-488a-ad53-c2cdc1dd8497', 4,
 'Titanium expects lessees to repair minor paintwork micro-abrasions before surrendering the vehicle.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]');

-- ── Group 2: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('d61b8b5b-b065-4f72-a5ff-30a96cab4bc4', '98a2f7dd-4c70-4cca-868b-d666600e3cb3', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN THREE WORDS from the text for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('899e1658-d80c-4071-bbb3-91a10de5281b', 'd61b8b5b-b065-4f72-a5ff-30a96cab4bc4', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"Category","answer":""},{"id":"h2","gapText":"Condition/Rule","answer":""},{"id":"h3","gapText":"Consequence/Status","answer":""}]'),
('59db019d-19a4-48ee-841f-7ca8a9032dd0', 'd61b8b5b-b065-4f72-a5ff-30a96cab4bc4', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"Geographical Limits","answer":""},{"id":"c2","gapText":"Requires an overriding {{gap}} for broader travel","answer":"cross-border addendum"},{"id":"c3","gapText":"Must be ratified by the Risk Assessment Board","answer":""}]'),
('47074d76-5785-4155-a3a0-ad50207a05e3', 'd61b8b5b-b065-4f72-a5ff-30a96cab4bc4', 7,
 'Row 3', '',
 '[{"id":"c4","gapText":"Maintenance","answer":""},{"id":"c5","gapText":"Using an {{gap}} to fix the car","answer":"unverified, independent facility"},{"id":"c6","gapText":"The warranty is {{gap}} immediately","answer":"voided"}]'),
('ee3afc55-787b-44a8-b33f-992711ef8d7f', 'd61b8b5b-b065-4f72-a5ff-30a96cab4bc4', 8,
 'Row 4', '',
 '[{"id":"c7","gapText":"Collision Protocol","answer":""},{"id":"c8","gapText":"Must submit a formal police report and pass {{gap}}","answer":"toxicology screenings"},{"id":"c9","gapText":"Lessee is absolved of the depreciation deficit","answer":""}]'),
('e3dff3ef-1e4d-4c48-97d6-ad233f6df5a2', 'd61b8b5b-b065-4f72-a5ff-30a96cab4bc4', 9,
 'Row 5', '',
 '[{"id":"c10","gapText":"End of Lease","answer":""},{"id":"c11","gapText":"Presence of {{gap}} in the vehicle’s vents","answer":"nicotine residue"},{"id":"c12","gapText":"Fines deducted from the corporate retainer fee","answer":""}]');

-- ── Group 3: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('c44192f2-f740-4a70-87e5-474b1a371116', '98a2f7dd-4c70-4cca-868b-d666600e3cb3', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS from the text for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('6ad32d6a-58a4-48ae-8505-7d434303b913', 'c44192f2-f740-4a70-87e5-474b1a371116', 10,
 'What equipment is used by Titanium to ensure lessees do not drive outside the permitted area?', 'GPS telematics', '[{"id":"1","text":"GPS telematics"}]'),
('15ce28b2-c1df-4e28-8480-a7cf37951b3a', 'c44192f2-f740-4a70-87e5-474b1a371116', 11,
 'What specific dashboard alert requires the driver to completely stop the vehicle without delay?', 'engine thermal threshold', '[{"id":"1","text":"engine thermal threshold"}]'),
('a5dc1b27-b3c9-47c3-a6ea-9bcd4837ce78', 'c44192f2-f740-4a70-87e5-474b1a371116', 12,
 'What process does Titanium use at the end of the lease to check the condition of the car?', 'preliminary visual inspection', '[{"id":"1","text":"preliminary visual inspection"},{"id":"2","text":"visual inspection"}]'),
('3e5f59fb-b359-4094-8aa9-a144e251aa92', 'c44192f2-f740-4a70-87e5-474b1a371116', 13,
 'What part of the vehicle is strictly evaluated for structural deformation at the end of the term?', 'alloy wheels', '[{"id":"1","text":"alloy wheels"},{"id":"2","text":"the alloy wheels"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Asynchronous Communication Protocols (Q14–27)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('3e6f15fa-dfd4-4790-aef6-cf18b483853c', '74d8bb40-8d16-45ee-b920-cb93b33a02da', 2,
 'Navigating Asynchronous Communication Protocols in Multinational Conglomerates',
 '(A) As modern conglomerates increasingly decentralize their operations across disparate global time zones, the traditional reliance on synchronous communication—characterized by real-time interactions such as live video conferences and immediate instant messaging—has proven fundamentally untenable. Synchronous models inadvertently penalize employees in non-dominant time zones, forcing them to operate during irregular hours to accommodate headquarters. In response, organizational architects are pivoting aggressively toward asynchronous communication protocols, wherein responses are neither expected nor demanded instantaneously.

(B) The transition to asynchronous workflows requires a radical overhaul of corporate culture, specifically regarding the psychological expectation of immediacy. In a synchronous culture, an employee’s value is often falsely equated with their hyper-responsiveness; the faster an email is answered, the more dedicated the employee is perceived to be. Asynchronous protocols dismantle this paradigm. By decoupling the sender’s dispatch of information from the recipient’s consumption and response, employees are empowered to carve out uninterrupted blocks of "deep work"—a state of distraction-free concentration that pushes their cognitive capacities to their limit, which is essential for complex problem-solving.

(C) Implementing these protocols, however, is not without severe friction. The most pronounced logistical hurdle is the phenomenon of "context switching" exacerbating project bottlenecks. When a team member blocks a task pending a colleague''s asynchronous response, they must shift their focus to an entirely different project. If the response arrives eight hours later, the original team member must expend significant cognitive energy re-familiarizing themselves with the initial task’s context. To mitigate this, conglomerates must invest heavily in comprehensive documentation software, ensuring that every thought process, decision metric, and project status is meticulously cataloged in a centralized, easily searchable repository, thereby reducing reliance on direct peer-to-peer questioning.

(D) Furthermore, the adoption of asynchronous communication inherently alters the trajectory of corporate conflict resolution. In real-time verbal debates, nuanced vocal inflections and facial micro-expressions help regulate emotional temperature and clarify intent. Text-heavy asynchronous communication is devoid of these vital non-verbal cues. Consequently, a bluntly phrased critique left in a project management tool can fester for hours before the author logs back on to clarify their intent, potentially irreparably damaging team cohesion. Management must therefore implement rigorous training in "compassionate clarity," teaching staff to over-communicate intent and assume positive intent from colleagues.

(E) A secondary, yet equally critical consequence of abandoning real-time interaction is the unintentional siloization of knowledge. When serendipitous "watercooler" conversations are engineered out of existence, junior employees lose passive exposure to the strategic decision-making processes of senior leadership. To counteract this intellectual isolation, forward-thinking conglomerates are instituting "transparent asynchronous broadcasting." This involves senior executives recording weekly, unedited video monologues detailing their strategic dilemmas and rationales, which are then disseminated globally for employees to consume and annotate at their discretion.

(F) Ultimately, the success of asynchronous communication hinges on the ruthless prioritization of explicit outputs over performative inputs. Managers can no longer assess productivity by scanning a bustling open-plan office or monitoring the green "active" dots on a corporate messaging platform. Instead, performance metrics must be entirely recalibrated to evaluate the tangible quality, ingenuity, and timeliness of delivered work. This shift demands a high degree of mutual trust and autonomy, effectively rendering micromanagement obsolete in the modern multinational enterprise.');

-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('52a229e8-8838-4f59-a843-4fdaeb7a7ca7', '3e6f15fa-dfd4-4790-aef6-cf18b483853c', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. The necessity of dismantling real-time operational models", "ii. The financial burden of upgrading internal databases", "iii. Redefining the metrics of employee evaluation", "iv. Replacing spontaneous learning with deliberate transparency", "v. The cognitive toll of delayed collaborative workflows", "vi. Reclaiming intellectual focus from a culture of immediacy", "vii. Overcoming the geographical boundaries of server networks", "viii. The escalation of misunderstandings without physical cues"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('a04dc186-56fa-49fc-b0ee-d8d52189c08d', '52a229e8-8838-4f59-a843-4fdaeb7a7ca7', 14, 'Paragraph A', 'i'),
('4139630f-0180-4980-8fd8-a5324869e8a0', '52a229e8-8838-4f59-a843-4fdaeb7a7ca7', 15, 'Paragraph B', 'vi'),
('0cd5739c-9c32-460f-9aee-ba4151cd701d', '52a229e8-8838-4f59-a843-4fdaeb7a7ca7', 16, 'Paragraph C', 'v'),
('9af29f35-00db-4ae8-8050-4c60b13bf5ac', '52a229e8-8838-4f59-a843-4fdaeb7a7ca7', 17, 'Paragraph D', 'viii'),
('65332a7a-d6fb-4477-b754-16205835d5e9', '52a229e8-8838-4f59-a843-4fdaeb7a7ca7', 18, 'Paragraph E', 'iv'),
('9bcbd027-4be8-4ed3-983b-94caa706a992', '52a229e8-8838-4f59-a843-4fdaeb7a7ca7', 19, 'Paragraph F', 'iii');

-- ── Group 5: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('b026787a-7d6c-45ce-925a-a7f6f24e7ed2', '3e6f15fa-dfd4-4790-aef6-cf18b483853c', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('5355af3b-7c32-4da2-b5c5-444fad695bda', 'b026787a-7d6c-45ce-925a-a7f6f24e7ed2', 20,
 'A specific communication framework taught to prevent textual communications from causing offense.', 'D',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('608a24f2-bc05-4f58-9c2c-24670b528724', 'b026787a-7d6c-45ce-925a-a7f6f24e7ed2', 21,
 'An unfair consequence suffered by staff who do not live near the company’s main office.', 'A',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('3e438ce8-4214-4427-a44b-2d789faff8aa', 'b026787a-7d6c-45ce-925a-a7f6f24e7ed2', 22,
 'The realization that closely supervising employees’ daily habits is no longer a viable management technique.', 'F',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('d6eec9cb-a386-4902-b69b-340da69a624b', 'b026787a-7d6c-45ce-925a-a7f6f24e7ed2', 23,
 'The necessity of meticulously recording internal logic so colleagues do not need to ask questions directly.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');

-- ── Group 6: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('5f4d2d38-138f-4452-8203-8bde0aece019', '3e6f15fa-dfd4-4790-aef6-cf18b483853c', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('7b751de6-c81f-479c-998d-18d6c103b09d', '5f4d2d38-138f-4452-8203-8bde0aece019', 24,
 'According to Paragraph B, how do traditional synchronous cultures misjudge employee dedication?',
 'A',
 '[{"id":"A","text":"A. By assuming that rapid email replies indicate higher levels of commitment.","isCorrect":true},{"id":"B","text":"B. By rewarding employees who work longer hours than their peers.","isCorrect":false},{"id":"C","text":"C. By failing to appreciate the value of complex problem-solving.","isCorrect":false},{"id":"D","text":"D. By criticizing staff who demand uninterrupted blocks of time.","isCorrect":false}]'),
('9e75d47b-0a5d-42f3-aafe-88800e2404af', '5f4d2d38-138f-4452-8203-8bde0aece019', 25,
 'In Paragraph C, "context switching" is portrayed primarily as a phenomenon that:',
 'C',
 '[{"id":"A","text":"A. Enhances an employee’s ability to manage multiple projects simultaneously.","isCorrect":false},{"id":"B","text":"B. Results from a lack of adequate centralized software.","isCorrect":false},{"id":"C","text":"C. Drains mental energy when returning to a task after a long delay.","isCorrect":true},{"id":"D","text":"D. Encourages colleagues to resolve project bottlenecks quickly.","isCorrect":false}]'),
('5fdd99d9-2c72-4d58-bd56-984e9010892c', '5f4d2d38-138f-4452-8203-8bde0aece019', 26,
 'What does the writer suggest in Paragraph E regarding junior employees in an asynchronous environment?',
 'D',
 '[{"id":"A","text":"A. They are often burdened with managing transparent broadcasting systems.","isCorrect":false},{"id":"B","text":"B. They prefer annotating videos over engaging in casual office chatter.","isCorrect":false},{"id":"C","text":"C. They intentionally isolate themselves from the strategic decision-making process.","isCorrect":false},{"id":"D","text":"D. They miss out on implicitly absorbing knowledge from senior executives.","isCorrect":true}]'),
('f7b716e7-5bc6-48a9-8404-d355830b4453', '5f4d2d38-138f-4452-8203-8bde0aece019', 27,
 'What is the writer’s main conclusion in Paragraph F regarding performance management?',
 'B',
 '[{"id":"A","text":"A. Managers must find alternative ways to monitor employee software usage.","isCorrect":false},{"id":"B","text":"B. Evaluation must shift away from visible effort and entirely toward the quality of the end product.","isCorrect":true},{"id":"C","text":"C. The concept of mutual trust will eventually replace all forms of performance metrics.","isCorrect":false},{"id":"D","text":"D. Micromanagement is still necessary, but it must be conducted asynchronously.","isCorrect":false}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: The Metacognitive Illusion (Q28–40)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('a33aa40c-5de9-4064-b5b4-94a71c7521cc', '74d8bb40-8d16-45ee-b920-cb93b33a02da', 3,
 'The Metacognitive Illusion: Why We Overestimate Our Competence',
 '(A) In 1995, a man named McArthur Wheeler walked into two Pittsburgh banks and robbed them in broad daylight, wearing no visible disguise. When police arrested him hours later, aided by pristine surveillance footage, Wheeler was genuinely incredulous. "But I wore the juice," he mumbled. Wheeler had fundamentally misunderstood the chemical properties of lemon juice; because it is used as invisible ink, he deduced that smearing it on his face would render him invisible to security cameras. This bizarre incident caught the attention of psychologists David Dunning and Justin Kruger, who utilized it as a springboard to investigate a pervasive cognitive bias: the profound inability of incompetent people to recognize their own incompetence, now formally enshrined in psychology as the Dunning-Kruger effect.

(B) The crux of the Dunning-Kruger effect lies in a deficit of metacognition—the ability to step back and objectively evaluate one’s own cognitive processes and skill levels. Dunning and Kruger’s seminal studies involved testing undergraduate students on logic, grammar, and humor. They found a striking inverse correlation: the students who scored in the lowest quartile consistently and drastically overestimated their performance, believing they had scored above average. Conversely, those in the top quartile slightly underestimated their performance. The researchers concluded that the exact same skills required to be highly proficient in a domain are the exact skills required to recognize proficiency. If you are terrible at grammar, you lack the grammatical knowledge necessary to realize how terrible your grammar is.

(C) This phenomenon is not merely an academic curiosity; its implications permeate professional, medical, and political spheres. In corporate environments, it manifests as the "illusory superiority" of middle management, where executives confidently execute flawed strategic pivots, entirely blind to the systemic risks they are introducing. In medicine, studies have repeatedly demonstrated that physicians with the poorest patient outcomes are the least likely to recognize their diagnostic deficiencies, often attributing failures to external complexities rather than internal knowledge gaps. This creates a dangerous feedback loop where those most in need of remedial training are the least likely to seek it.

(D) A common, yet dangerous, misconception regarding the Dunning-Kruger effect is that it only applies to the intellectually deficient or the uneducated. This is unequivocally false. The bias is domain-specific. An elite astrophysicist may possess extraordinary metacognition regarding quantum mechanics but suffer from severe Dunning-Kruger blindness when attempting to navigate personal financial investments or interpersonal relationships. Our brains are hardwired to extrapolate confidence from one area of genuine expertise and mistakenly apply it to an unrelated field—a phenomenon known as the "halo effect of competence."

(E) Overcoming this metacognitive blind spot is exceedingly difficult because the brain naturally deploys defense mechanisms to protect the ego. When confronted with objective evidence of their poor performance, individuals at the bottom of the competence hierarchy frequently deploy a strategy psychologists term "defensive externalization." Rather than updating their self-assessment, they attack the validity of the metric. They will argue that the test was inherently flawed, the examiners were biased, or the rules were inadequately explained. 

(F) Therefore, the mitigation of the Dunning-Kruger effect cannot rely on self-reflection alone. It necessitates the construction of external, immutable feedback architecture. In aviation and surgery, this takes the form of mandatory checklists and peer-reviewed morbidity conferences—systems designed specifically to bypass individual metacognitive failure by enforcing standardized, objective scrutiny. On a personal level, it requires cultivating intellectual humility: the conscious, uncomfortable practice of soliciting ruthless feedback from verified experts, and resisting the powerful cognitive urge to dismiss critiques that contradict our internalized self-image.');

-- ── Group 7: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('a2b25b29-2664-4a54-9e6f-ad7695dc0c9b', 'a33aa40c-5de9-4064-b5b4-94a71c7521cc', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('493a27ba-74c5-4eec-8579-23006590c3a1', 'a2b25b29-2664-4a54-9e6f-ad7695dc0c9b', 28,
 'McArthur Wheeler’s robbery attempt was the direct catalyst for Dunning and Kruger’s formal research into cognitive bias.', 'YES', '["YES","Yes","yes"]'),
('497b5ff4-63b9-4169-b764-597569c091f7', 'a2b25b29-2664-4a54-9e6f-ad7695dc0c9b', 29,
 'Top-performing students in Dunning and Kruger’s initial studies correctly predicted their exact scores.', 'NO', '["NO","No","no"]'),
('cdc69b06-5ba7-4681-8bd6-d222250bee4d', 'a2b25b29-2664-4a54-9e6f-ad7695dc0c9b', 30,
 'Medical professionals are generally more susceptible to the Dunning-Kruger effect than those working in corporate finance.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('fc90054b-92a3-43a9-aca7-e05fd2891047', 'a2b25b29-2664-4a54-9e6f-ad7695dc0c9b', 31,
 'A highly intelligent person can still fall victim to the Dunning-Kruger effect if they attempt tasks outside their specific area of expertise.', 'YES', '["YES","Yes","yes"]');

-- ── Group 8: MATCHING SENTENCE ENDINGS (Q32–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('6f251bab-0b6e-4a95-bbb6-cd67f375f287', 'a33aa40c-5de9-4064-b5b4-94a71c7521cc', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('c5fb2791-d3e1-49e2-90e6-b383e4151b3f', '6f251bab-0b6e-4a95-bbb6-cd67f375f287', 32,
 'The core reason incompetent individuals cannot recognize their flaws is that they',
 'D',
 '[{"id":"A","text":"often blame the testing methodology rather than admit they are unskilled.","isCorrect":false},{"id":"B","text":"rely on strict checklists to bypass the brain’s natural defense mechanisms.","isCorrect":false},{"id":"C","text":"assume their expertise in one specific subject naturally applies to all others.","isCorrect":false},{"id":"D","text":"do not possess the specific knowledge required to evaluate that particular skill.","isCorrect":true},{"id":"E","text":"suffer from a lack of general intelligence and formal education.","isCorrect":false},{"id":"F","text":"frequently attribute their poor performance to highly complex external factors.","isCorrect":false}]'),
('bb416482-c16e-4e5f-88b6-d96686fd7cf5', '6f251bab-0b6e-4a95-bbb6-cd67f375f287', 33,
 'Poorly performing physicians exacerbate their incompetence because they',
 'F',
 '[{"id":"A","text":"often blame the testing methodology rather than admit they are unskilled.","isCorrect":false},{"id":"B","text":"rely on strict checklists to bypass the brain’s natural defense mechanisms.","isCorrect":false},{"id":"C","text":"assume their expertise in one specific subject naturally applies to all others.","isCorrect":false},{"id":"D","text":"do not possess the specific knowledge required to evaluate that particular skill.","isCorrect":false},{"id":"E","text":"suffer from a lack of general intelligence and formal education.","isCorrect":false},{"id":"F","text":"frequently attribute their poor performance to highly complex external factors.","isCorrect":true}]'),
('334ed51e-536e-484b-9802-8cea0537a34e', '6f251bab-0b6e-4a95-bbb6-cd67f375f287', 34,
 'The "halo effect of competence" occurs when highly skilled professionals',
 'C',
 '[{"id":"A","text":"often blame the testing methodology rather than admit they are unskilled.","isCorrect":false},{"id":"B","text":"rely on strict checklists to bypass the brain’s natural defense mechanisms.","isCorrect":false},{"id":"C","text":"assume their expertise in one specific subject naturally applies to all others.","isCorrect":true},{"id":"D","text":"do not possess the specific knowledge required to evaluate that particular skill.","isCorrect":false},{"id":"E","text":"suffer from a lack of general intelligence and formal education.","isCorrect":false},{"id":"F","text":"frequently attribute their poor performance to highly complex external factors.","isCorrect":false}]'),
('40db2ce0-da76-440c-bd23-c92575c6392c', '6f251bab-0b6e-4a95-bbb6-cd67f375f287', 35,
 'When individuals engage in "defensive externalization," they',
 'A',
 '[{"id":"A","text":"often blame the testing methodology rather than admit they are unskilled.","isCorrect":true},{"id":"B","text":"rely on strict checklists to bypass the brain’s natural defense mechanisms.","isCorrect":false},{"id":"C","text":"assume their expertise in one specific subject naturally applies to all others.","isCorrect":false},{"id":"D","text":"do not possess the specific knowledge required to evaluate that particular skill.","isCorrect":false},{"id":"E","text":"suffer from a lack of general intelligence and formal education.","isCorrect":false},{"id":"F","text":"frequently attribute their poor performance to highly complex external factors.","isCorrect":false}]');

-- ── Group 9: SUMMARY COMPLETION with Word Bank (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('292fdec9-6f59-4316-8339-ae5e0bb06759', 'a33aa40c-5de9-4064-b5b4-94a71c7521cc', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["ego", "scrutiny", "infrastructure", "humility", "metacognition", "incompetence", "defense", "checklists"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('cd6de170-3d1b-4a83-a80f-27d5bcc74f18', '292fdec9-6f59-4316-8339-ae5e0bb06759', 36,
 'Because the brain naturally attempts to protect a person''s {{gap_292fdec9-6f59-4316-8339-ae5e0bb06759_0}}, simply asking someone to reflect on their own abilities is an ineffective way to combat the Dunning-Kruger effect. Instead, organizations must implement robust external systems that provide objective {{gap_292fdec9-6f59-4316-8339-ae5e0bb06759_1}}. High-stakes industries, such as surgery, achieve this by enforcing the use of standardized {{gap_292fdec9-6f59-4316-8339-ae5e0bb06759_2}} that bypass individual cognitive failures. For individuals seeking to overcome this bias in their personal lives, they must actively work to develop intellectual {{gap_292fdec9-6f59-4316-8339-ae5e0bb06759_3}} by seeking out and accepting harsh critiques, thereby improving their overall {{gap_292fdec9-6f59-4316-8339-ae5e0bb06759_4}}.',
 'ego'),
('54e56051-7f1e-4801-a411-03e0aed8e90b', '292fdec9-6f59-4316-8339-ae5e0bb06759', 37,
 '', 'scrutiny'),
('f08c5a4c-a961-47e4-bc22-ef4e869905e2', '292fdec9-6f59-4316-8339-ae5e0bb06759', 38,
 '', 'checklists'),
('01e497dc-21f2-40e3-b4d1-572563c22ae5', '292fdec9-6f59-4316-8339-ae5e0bb06759', 39,
 '', 'humility'),
('13cba8c6-fa84-4ffe-b306-d5c1f0c01f93', '292fdec9-6f59-4316-8339-ae5e0bb06759', 40,
 '', 'metacognition');

-- ============================================================
-- NOTE: Please execute `UPDATE reading_tests SET created_by = '<your-uid>'` 
-- if required by your application's Row Level Security policies.
-- ============================================================
