-- ============================================================
-- IELTS Practice Platform – Extended Seed Data
-- Target: Reading Module (General Training, Band 8 Difficulty)
-- Action: APPEND (No TRUNCATE)
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST ENTRY (General Training - Band 8)                   ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('085501c0-b658-4be9-97f2-dc4de265f68e', '5f53df15-e980-48f3-9a51-40199ed2e143',
 'IELTS General Training Reading: Tenancy, Corporate IP & Cognitive Science (Band 8)', 'General Training', '8', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: Oakwood Estate Tenancy Agreement (Q1–13)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('7afd2ef3-3e29-467b-8d50-f9a34a3307f6', '085501c0-b658-4be9-97f2-dc4de265f68e', 1,
 'Oakwood Estate Residential Tenancy Agreement: Key Terms and Conditions',
 '(A) Rent and Security Deposit
The Tenant agrees to pay the Landlord a monthly rental fee of $2,450, due on the first calendar day of each month. Payments remitted after the fifth day will incur a mandatory late surcharge of 5% of the outstanding balance. A security deposit equivalent to one and a half months’ rent must be provided prior to occupying the premises. This deposit is held in an escrow account and will be fully refunded within 21 days of the termination of this agreement, subject to a final property inspection. Deductions will be made for substantial structural damage, but not for reasonable wear and tear.

(B) Maintenance and Alterations
The Landlord is legally obligated to ensure all major plumbing, electrical, and heating systems are functional. The Tenant, however, assumes liability for routine upkeep, including the replacement of light fixtures, HVAC filters, and minor landscaping tasks. Under no circumstances may the Tenant execute structural alterations, paint walls, or install permanent fixtures without procuring a written consent form from the Landlord at least 30 days prior to the commencement of such work. Unauthorized modifications will result in the immediate forfeiture of the security deposit.

(C) Subletting and Occupancy Limits
The premises are to be occupied exclusively by the individuals explicitly named on the lease agreement. Subletting, either in whole or in part, through short-term rental platforms (e.g., Airbnb) or private arrangement, is strictly prohibited unless formal, notarized approval is granted by the Estate Management Board. Visitors are permitted for a maximum consecutive period of 14 days; any guest exceeding this duration will be legally classified as an unauthorized tenant, constituting a direct breach of contract.

(D) Termination of Agreement
To terminate this lease at the conclusion of the specified term, either party must provide a minimum of 60 days’ written notice. Should the Tenant wish to break the lease prematurely, they are liable for rent until a suitable replacement tenant is secured, alongside a re-letting fee of $500. The Landlord reserves the right to initiate immediate eviction proceedings, waiving the 60-day notice period, in instances of illicit activities conducted on the premises or failure to remit rent for two consecutive months.');

-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('250f7f53-d20f-4aec-97e0-0c7a39c0893f', '7afd2ef3-3e29-467b-8d50-f9a34a3307f6', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the text? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('a46668f5-a7f8-4098-95ff-224c9cdbec7d', '250f7f53-d20f-4aec-97e0-0c7a39c0893f', 1,
 'A tenant will lose their deposit if the carpet shows signs of normal daily use over the year.', 'FALSE', '["FALSE","False","false"]'),
('22cd48b3-d8d5-4494-af73-96f63689d581', '250f7f53-d20f-4aec-97e0-0c7a39c0893f', 2,
 'Tenants must obtain legal notarization to use short-term rental platforms legally.', 'TRUE', '["TRUE","True","true"]'),
('17f72155-3317-44cd-b035-ca7ad36b6b02', '250f7f53-d20f-4aec-97e0-0c7a39c0893f', 3,
 'The Landlord must always provide 60 days’ notice before forcing a tenant to leave the property.', 'FALSE', '["FALSE","False","false"]'),
('a675f916-bf64-470b-a794-c9481429b64f', '250f7f53-d20f-4aec-97e0-0c7a39c0893f', 4,
 'The escrow account used for the security deposit accrues annual interest for the tenant.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]');

-- ── Group 2: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('dc31bb6f-4605-4593-a074-ffb186608171', '7afd2ef3-3e29-467b-8d50-f9a34a3307f6', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN THREE WORDS AND/OR A NUMBER from the text for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('433f9097-414b-467c-8d2b-9a232c964522', 'dc31bb6f-4605-4593-a074-ffb186608171', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"Clause Category","answer":""},{"id":"h2","gapText":"Specific Rule / Condition","answer":""},{"id":"h3","gapText":"Penalty / Consequence","answer":""}]'),
('95e12894-0a18-4829-babf-4dedcd7a5d38', 'dc31bb6f-4605-4593-a074-ffb186608171', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"Rent Payment","answer":""},{"id":"c2","gapText":"Must be paid by the {{gap}} of the month","answer":"fifth day"},{"id":"c3","gapText":"5% late surcharge","answer":""}]'),
('a86df8b6-c58d-456d-b86a-001497a3678f', 'dc31bb6f-4605-4593-a074-ffb186608171', 7,
 'Row 3', '',
 '[{"id":"c4","gapText":"Alterations","answer":""},{"id":"c5","gapText":"Requires written consent 30 days prior","answer":""},{"id":"c6","gapText":"Immediate {{gap}} of the deposit","answer":"forfeiture"}]'),
('01094aa2-9421-491e-a4c7-0e65d6e4b11f', 'dc31bb6f-4605-4593-a074-ffb186608171', 8,
 'Row 4', '',
 '[{"id":"c7","gapText":"Occupancy","answer":""},{"id":"c8","gapText":"Guests cannot stay more than {{gap}}","answer":"14 days"},{"id":"c9","gapText":"Guest is classified as an {{gap}}","answer":"unauthorized tenant"}]'),
('e79a1746-22bf-4fb6-8f1c-db641cc80ec8', 'dc31bb6f-4605-4593-a074-ffb186608171', 9,
 'Row 5', '',
 '[{"id":"c10","gapText":"Early Termination","answer":""},{"id":"c11","gapText":"Tenant breaks lease prematurely","answer":""},{"id":"c12","gapText":"Must pay rent until replaced, plus a {{gap}}","answer":"re-letting fee"}]');

-- ── Group 3: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('c78db3b0-46a1-449f-98b8-6fd097e4ed42', '7afd2ef3-3e29-467b-8d50-f9a34a3307f6', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS from the text for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('fb2692d1-8baa-4916-94f3-17d9e7d4bbb3', 'c78db3b0-46a1-449f-98b8-6fd097e4ed42', 10,
 'What type of account is used to securely hold the security deposit?', 'escrow account', '[{"id":"1","text":"an escrow account"},{"id":"2","text":"escrow account"},{"id":"3","text":"escrow"}]'),
('3fddf974-18d0-4617-8d29-2a4d0ce28c02', 'c78db3b0-46a1-449f-98b8-6fd097e4ed42', 11,
 'What must be conducted before the landlord refunds the security deposit?', 'final property inspection', '[{"id":"1","text":"final property inspection"},{"id":"2","text":"property inspection"}]'),
('8b98d548-6702-407e-acc3-2bb0ffb9e136', 'c78db3b0-46a1-449f-98b8-6fd097e4ed42', 12,
 'What specific document must a tenant secure before painting a wall?', 'written consent form', '[{"id":"1","text":"written consent form"},{"id":"2","text":"consent form"}]'),
('23e7eb03-c112-497c-845b-fb1bec42fe35', 'c78db3b0-46a1-449f-98b8-6fd097e4ed42', 13,
 'Who has the authority to approve a subletting arrangement?', 'Estate Management Board', '[{"id":"1","text":"Estate Management Board"},{"id":"2","text":"the Estate Management Board"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Aegis Corporation Intellectual Property (Q14–27)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('facbd347-2938-4dae-b6e3-74a2305dd365', '085501c0-b658-4be9-97f2-dc4de265f68e', 2,
 'Aegis Corporation: Mentorship Protocol and Intellectual Property Guidelines',
 '(A) Aegis Corporation is steadfast in its dedication to cultivating internal talent through its structured Mentorship Protocol. However, as innovation is the bedrock of our competitive advantage, this protocol operates concurrently with strict Intellectual Property (IP) guidelines. Mentorship is designed to foster professional development; it is not a conduit for the unauthorized dissemination of proprietary methodologies or sensitive client data. All employees, regardless of seniority, are bound by the Non-Disclosure Agreement (NDA) executed upon their initial hiring.

(B) Mentors are tasked with guiding junior staff through complex problem-solving scenarios. While demonstrating operational frameworks is encouraged, mentors must exercise profound discretion. Source code, unreleased marketing algorithms, and prospective acquisition strategies are strictly compartmentalized. Should a mentee require access to restricted data to complete a training module, the mentor must lodge a formal petition with the Information Security (InfoSec) department. Approval is exclusively contingent upon the mentee signing a temporary, project-specific confidentiality waiver.

(C) A critical facet of the Aegis employment contract concerns the ownership of Intellectual Property. Any software, design, literary work, or patentable invention created by an employee during their tenure belongs unequivocally and irreversibly to Aegis Corporation. This stipulation applies even if the creation occurs outside of standard working hours or off company premises, provided the invention utilizes corporate resources, hardware, or relates directly to the company’s current or anticipated research and development trajectories.

(D) Employees who independently develop concepts entirely unrelated to Aegis Corporation’s business scope on their personal time using private resources retain full ownership of those concepts. However, to prevent future legal ambiguity, the burden of proof lies with the employee. Prior to commercializing or patenting any independent project, the employee must disclose the nature of the work to the Legal Compliance Office. The office will review the submission and issue a "Certificate of Non-Interference" if no conflict of interest is identified.

(E) In instances where a mentee and mentor collaboratively develop an innovative solution or workflow optimization that significantly benefits the company, Aegis Corporation operates a robust Internal Patent and Reward scheme. The company assumes the financial burden of filing the patent globally. In return, the creators are recognized as "Inventors" on the official patent documentation and are awarded a progressive financial bonus commensurate with the invention’s subsequent commercial yield.

(F) Violations of the IP guidelines are treated with utmost severity. Unauthorized transmission of corporate assets to external servers, cloud storage, or third-party entities—whether intentional or resulting from negligent security practices—triggers an automatic suspension pending an internal audit. If malicious intent or gross negligence is corroborated, the employee faces immediate termination and potential civil litigation to recover damages.');

-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('dd5f9441-2440-4067-8e65-b5fcb950e9ab', 'facbd347-2938-4dae-b6e3-74a2305dd365', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. The burden of avoiding conflicts of interest", "ii. Acknowledgment and compensation for internal innovation", "iii. Repercussions for compromising company data", "iv. Balancing professional guidance with data security", "v. The broad scope of corporate ownership rights", "vi. Navigating the external patent application process", "vii. Procedures for sharing restricted knowledge internally", "viii. Establishing the boundaries of the mentorship program"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('836a4538-7ebd-4e72-b7cd-1b2cf87a0941', 'dd5f9441-2440-4067-8e65-b5fcb950e9ab', 14, 'Paragraph A', 'viii'),
('39c03cbf-e71a-4fab-ae30-7af6039cfa51', 'dd5f9441-2440-4067-8e65-b5fcb950e9ab', 15, 'Paragraph B', 'vii'),
('015677a6-23f9-45bf-b36d-711a21be1b9a', 'dd5f9441-2440-4067-8e65-b5fcb950e9ab', 16, 'Paragraph C', 'v'),
('00a9869a-0fb3-45cb-8655-de6f014bf6d1', 'dd5f9441-2440-4067-8e65-b5fcb950e9ab', 17, 'Paragraph D', 'i'),
('8ee6c0d0-3b88-4a95-95b1-577b100d97c1', 'dd5f9441-2440-4067-8e65-b5fcb950e9ab', 18, 'Paragraph E', 'ii'),
('822b8071-0cc4-4743-b39f-45d1c4e1c8e1', 'dd5f9441-2440-4067-8e65-b5fcb950e9ab', 19, 'Paragraph F', 'iii');

-- ── Group 5: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('7ececce4-c0f8-451a-857b-66139a6146b2', 'facbd347-2938-4dae-b6e3-74a2305dd365', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('15895957-cd73-4a0a-a423-418ebffcf210', '7ececce4-c0f8-451a-857b-66139a6146b2', 20,
 'A reference to the legal document required before viewing highly sensitive material.', 'B',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('05b3c970-3edc-4f67-af63-05497625cde1', '7ececce4-c0f8-451a-857b-66139a6146b2', 21,
 'A condition where the company will take an employee to court to seek financial restitution.', 'F',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('4307aa40-1650-44d1-840c-7b53ab8cb7da', '7ececce4-c0f8-451a-857b-66139a6146b2', 22,
 'The criteria determining if something created at home still belongs to the corporation.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('858d9ce9-7fc8-4f0d-9107-80df1a4fa2ec', '7ececce4-c0f8-451a-857b-66139a6146b2', 23,
 'The specific paperwork granted to an employee to prove their personal project is legally theirs.', 'D',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');

-- ── Group 6: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('2fa9c9c6-ef24-43d1-a859-979537133679', 'facbd347-2938-4dae-b6e3-74a2305dd365', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('0da27efc-76bf-40bd-b2cc-41c395270269', '2fa9c9c6-ef24-43d1-a859-979537133679', 24,
 'According to Paragraph A, the Non-Disclosure Agreement (NDA) is:',
 'C',
 '[{"id":"A","text":"A. Only required for staff entering the Mentorship Protocol.","isCorrect":false},{"id":"B","text":"B. Re-signed annually to ensure compliance.","isCorrect":false},{"id":"C","text":"C. A mandatory requirement agreed to when an employee is hired.","isCorrect":true},{"id":"D","text":"D. Exclusively applicable to senior management handling client data.","isCorrect":false}]'),
('82668219-113f-4279-8a59-0c17a6ba224e', '2fa9c9c6-ef24-43d1-a859-979537133679', 25,
 'Paragraph C states that an invention created by an employee belongs to Aegis Corporation if:',
 'A',
 '[{"id":"A","text":"A. It is linked to the company’s future research plans.","isCorrect":true},{"id":"B","text":"B. It is created during standard 9-to-5 working hours.","isCorrect":false},{"id":"C","text":"C. It is successfully patented by the employee.","isCorrect":false},{"id":"D","text":"D. It is developed solely for a mentorship training module.","isCorrect":false}]'),
('2030775d-1d32-4fc6-b774-440bd1690448', '2fa9c9c6-ef24-43d1-a859-979537133679', 26,
 'How does Aegis Corporation reward internal innovation as described in Paragraph E?',
 'D',
 '[{"id":"A","text":"A. By transferring patent ownership entirely to the creators.","isCorrect":false},{"id":"B","text":"B. By offering immediate promotions to both mentor and mentee.","isCorrect":false},{"id":"C","text":"C. By paying a fixed, upfront cash bonus to the inventors.","isCorrect":false},{"id":"D","text":"D. By covering global patent costs and providing profit-linked bonuses.","isCorrect":true}]'),
('b693ca30-03a3-4302-aec6-651a4124f777', '2fa9c9c6-ef24-43d1-a859-979537133679', 27,
 'What happens if an employee accidentally compromises company data through poor security practices?',
 'B',
 '[{"id":"A","text":"A. They receive a formal warning from the Legal Compliance Office.","isCorrect":false},{"id":"B","text":"B. They are immediately suspended while an investigation takes place.","isCorrect":true},{"id":"C","text":"C. They are instantly terminated without an audit.","isCorrect":false},{"id":"D","text":"D. They must personally pay for the financial damages incurred.","isCorrect":false}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: The Malleability of Human Memory (Q28–40)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('fe7479f0-c0e9-401c-b91d-5553988c59ff', '085501c0-b658-4be9-97f2-dc4de265f68e', 3,
 'The Malleability of Human Memory: Constructive Retrieval',
 '(A) For decades, the prevailing metaphor for human memory was that of a video camera. It was widely assumed by the general public, and even early psychologists, that the brain recorded events precisely as they occurred and stored them in a pristine mental archive. When a memory was recalled, it was simply "played back." However, modern cognitive science has comprehensively dismantled this notion. Memory is not a passive recording mechanism; it is an active, ongoing process of reconstruction. Every time a memory is accessed, the brain reconstructs the event using fragments of stored data, filling in the gaps with plausible inferences based on current beliefs, emotions, and external suggestions. 

(B) The phenomenon of reconstructive memory was most famously elucidated by cognitive psychologist Elizabeth Loftus in the 1970s through her groundbreaking work on the "misinformation effect." In one classic experiment, participants watched a video of a minor car accident. Afterward, they were asked to estimate the speed of the vehicles. Crucially, the phrasing of the question varied. Participants who were asked how fast the cars were going when they "smashed" into each other estimated significantly higher speeds than those asked how fast they were going when they "hit" each other. Furthermore, the "smashed" group was more likely to falsely recall seeing broken glass in the video a week later. The introduction of a single suggestive word fundamentally altered the architecture of their memory.

(C) This inherent malleability is largely due to a cognitive glitch known as "source monitoring error." When we recall a piece of information, the brain must identify its origin—did we witness it, read it, dream it, or were we told about it? Often, the brain struggles to accurately tag the source. Therefore, a detail mentioned by a news anchor after an event can seamlessly integrate into a person’s firsthand memory of that event. Over time, the individual becomes genuinely unable to distinguish between what they experienced and what they acquired post-event.

(D) The implications of this are profound, particularly within the judicial system. Eyewitness testimony has historically been treated as the gold standard of evidence. Juries tend to find confident witnesses highly persuasive. Yet, research demonstrates that confidence is a notoriously poor indicator of accuracy. A witness can be entirely confident and completely wrong. The very act of police interrogation—asking leading questions or presenting suspects in a lineup—can inadvertently contaminate a witness’s memory. Once a memory is contaminated, it cannot be "purified." The witness isn’t lying; they are truthfully reporting a falsely constructed reality.

(E) Neuroimaging studies using fMRI (functional magnetic resonance imaging) have provided biological context to these behavioral observations. When a memory is recalled, the neural pathways associated with that memory become pliable—a state known as "reconsolidation." During this brief window, the memory is vulnerable to alteration before it is stored away again. Scientists have even successfully used chemical inhibitors during the reconsolidation phase in animals to selectively erase specific fear-based memories. While human applications remain highly controversial and ethically fraught, the science confirms that recalling a memory is the very act that risks changing it.

(F) Accepting the fallibility of memory requires a paradigm shift. It forces us to confront the uncomfortable reality that our personal histories are partly fictionalized. However, this reconstructive system is not a design flaw; it is an evolutionary advantage. The brain does not need to store perfect records of the past; it needs to use past experiences to predict and navigate the future. A flexible, updating memory system allows humans to integrate new knowledge, adapt to changing environments, and imagine future scenarios. Perfection is sacrificed for utility.');

-- ── Group 7: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('6fc7ec49-1704-4547-850a-94f940ba1680', 'fe7479f0-c0e9-401c-b91d-5553988c59ff', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d0afec77-dc55-45ac-80d9-65d4fdfea0e7', '6fc7ec49-1704-4547-850a-94f940ba1680', 28,
 'Early psychologists accurately understood how the brain stored and retrieved information.', 'NO', '["NO","No","no"]'),
('98861c91-e28b-4a3d-bd1d-386b4fb0518c', '6fc7ec49-1704-4547-850a-94f940ba1680', 29,
 'Participants in Elizabeth Loftus’s study were shown actual broken glass in the car crash video.', 'NO', '["NO","No","no"]'),
('881f9c76-adc5-4790-befd-92e3ef9ef646', '6fc7ec49-1704-4547-850a-94f940ba1680', 30,
 'Juries are generally skeptical of eyewitnesses who display high levels of confidence.', 'NO', '["NO","No","no"]'),
('c37461f0-1745-4d33-bdbc-ca3043e208d3', '6fc7ec49-1704-4547-850a-94f940ba1680', 31,
 'Scientists believe the ability to alter human memories with chemicals will soon be commonplace in therapy.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]');

-- ── Group 8: MATCHING SENTENCE ENDINGS (Q32–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('970ce18c-4ded-46aa-acc0-5f2548ce1a7e', 'fe7479f0-c0e9-401c-b91d-5553988c59ff', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('b7704902-9c3f-4074-acba-b2e97a90a3f3', '970ce18c-4ded-46aa-acc0-5f2548ce1a7e', 32,
 'When individuals suffer from source monitoring error, they',
 'D',
 '[{"id":"A","text":"are unable to forget traumatic events they witnessed firsthand.","isCorrect":false},{"id":"B","text":"intentionally lie to investigators to protect their own interests.","isCorrect":false},{"id":"C","text":"helps humans adapt to new situations and predict future events.","isCorrect":false},{"id":"D","text":"fail to correctly identify where a specific piece of information came from.","isCorrect":true},{"id":"E","text":"accidentally alter a witness’s recollection through suggestive questioning.","isCorrect":false},{"id":"F","text":"becomes chemically locked and cannot be altered further.","isCorrect":false}]'),
('c6a6641e-df0f-4b86-beb2-8fceefd0b7cb', '970ce18c-4ded-46aa-acc0-5f2548ce1a7e', 33,
 'During a police interrogation, law enforcement officers may',
 'E',
 '[{"id":"A","text":"are unable to forget traumatic events they witnessed firsthand.","isCorrect":false},{"id":"B","text":"intentionally lie to investigators to protect their own interests.","isCorrect":false},{"id":"C","text":"helps humans adapt to new situations and predict future events.","isCorrect":false},{"id":"D","text":"fail to correctly identify where a specific piece of information came from.","isCorrect":false},{"id":"E","text":"accidentally alter a witness’s recollection through suggestive questioning.","isCorrect":true},{"id":"F","text":"becomes chemically locked and cannot be altered further.","isCorrect":false}]'),
('ddb2e361-eadb-4e42-ae05-8e1df0c4372a', '970ce18c-4ded-46aa-acc0-5f2548ce1a7e', 34,
 'A witness who provides inaccurate testimony rarely does so because they',
 'B',
 '[{"id":"A","text":"are unable to forget traumatic events they witnessed firsthand.","isCorrect":false},{"id":"B","text":"intentionally lie to investigators to protect their own interests.","isCorrect":true},{"id":"C","text":"helps humans adapt to new situations and predict future events.","isCorrect":false},{"id":"D","text":"fail to correctly identify where a specific piece of information came from.","isCorrect":false},{"id":"E","text":"accidentally alter a witness’s recollection through suggestive questioning.","isCorrect":false},{"id":"F","text":"becomes chemically locked and cannot be altered further.","isCorrect":false}]'),
('e50b8504-61d7-404e-800c-39ba2dbe3359', '970ce18c-4ded-46aa-acc0-5f2548ce1a7e', 35,
 'The writer argues that the reconstructive nature of memory actually',
 'C',
 '[{"id":"A","text":"are unable to forget traumatic events they witnessed firsthand.","isCorrect":false},{"id":"B","text":"intentionally lie to investigators to protect their own interests.","isCorrect":false},{"id":"C","text":"helps humans adapt to new situations and predict future events.","isCorrect":true},{"id":"D","text":"fail to correctly identify where a specific piece of information came from.","isCorrect":false},{"id":"E","text":"accidentally alter a witness’s recollection through suggestive questioning.","isCorrect":false},{"id":"F","text":"becomes chemically locked and cannot be altered further.","isCorrect":false}]');

-- ── Group 9: SUMMARY COMPLETION with Word Bank (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('4ee797c2-d82c-4635-aaa5-3b812c171856', 'fe7479f0-c0e9-401c-b91d-5553988c59ff', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["permanent", "pliable", "reconstruction", "vulnerable", "fictionalized", "flaw", "utility", "advantage"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('d71148dd-ed10-4d2e-a5b0-8711d16ff06f', '4ee797c2-d82c-4635-aaa5-3b812c171856', 36,
 'Scientific research using fMRI scans has revealed that recalling a memory places it in a state of reconsolidation. During this period, the memory pathways become highly {{gap_4ee797c2-d82c-4635-aaa5-3b812c171856_0}}, making the memory {{gap_4ee797c2-d82c-4635-aaa5-3b812c171856_1}} to external influences and permanent alteration before it is stored away again. Consequently, much of what we consider our personal history is actually partially {{gap_4ee797c2-d82c-4635-aaa5-3b812c171856_2}}. While this may seem like a cognitive {{gap_4ee797c2-d82c-4635-aaa5-3b812c171856_3}}, it is actually an evolutionary necessity. A dynamic memory system prioritizes {{gap_4ee797c2-d82c-4635-aaa5-3b812c171856_4}} over perfect accuracy, allowing us to adapt to the future.',
 'pliable'),
('c570d8ee-d028-43a3-a5f7-04c57f6b0d74', '4ee797c2-d82c-4635-aaa5-3b812c171856', 37,
 '', 'vulnerable'),
('0ad87ed1-9a65-4943-93b1-800a13bbc578', '4ee797c2-d82c-4635-aaa5-3b812c171856', 38,
 '', 'fictionalized'),
('acc3fdf0-6b16-40d9-ad57-343bfeafb039', '4ee797c2-d82c-4635-aaa5-3b812c171856', 39,
 '', 'flaw'),
('a7acbf78-92a4-4028-91d1-c138c0a214b0', '4ee797c2-d82c-4635-aaa5-3b812c171856', 40,
 '', 'utility');

-- ============================================================
-- NOTE: Please execute `UPDATE reading_tests SET created_by = '<your-uid>'` 
-- if required by your application's Row Level Security policies.
-- ============================================================
