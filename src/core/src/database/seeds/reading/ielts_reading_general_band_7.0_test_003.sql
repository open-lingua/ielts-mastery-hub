-- ============================================================
-- IELTS Practice Platform – Extended Seed Data
-- Target: Reading Module (General Training, Band 7 Difficulty)
-- Action: APPEND (No TRUNCATE)
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST ENTRY (General Training - Band 7)                   ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('ade2bff5-810d-4b5d-813a-2db8a7cdafae', 'cc2cdc04-428e-45cb-9a9d-6572111e0a10',
 'IELTS General Training Reading: Gym Rules, Workplace Ergonomics & The Journey of Coffee (Band 7)', 'General Training', '7', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: Core Fitness Club Membership Rules (Q1–13)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('18509aa1-fd04-4e31-9233-99df3aeb3128', 'ade2bff5-810d-4b5d-813a-2db8a7cdafae', 1,
 'Core Fitness Club: Membership Terms and Facility Guidelines',
 'Welcome to Core Fitness Club! To ensure a safe, clean, and welcoming environment for all our members, we ask that you familiarise yourself with the following guidelines.

(A) Membership Access and Fees
Your membership card is for your personal use only. If you lose your card, a replacement can be issued at the front desk for a fee of $15. Memberships are billed on the 1st of every month. If your payment is declined, you will have a grace period of 7 days to settle the balance before a late fee of $10 is automatically applied to your account. You may freeze your membership for up to three months per calendar year for medical or travel reasons, provided you submit a request in writing at least 14 days in advance. 

(B) Gym Floor Etiquette
During peak hours (5:00 PM – 8:00 PM on weekdays), time limits on cardiovascular equipment (treadmills, ellipticals, and stationary bikes) are strictly limited to 30 minutes per person. Please be considerate and allow others to work in on weight machines between your sets. Members must wipe down all equipment with the provided antibacterial wipes immediately after use. Gym bags and outdoor coats are not permitted on the gym floor; they must be securely stored in the locker rooms.

(C) Class Bookings and Cancellations
Group fitness classes are included in premium memberships, while basic members must pay a $5 drop-in fee per class. Classes can be booked up to 48 hours in advance via our mobile app. If you cannot attend a booked class, you must cancel at least 4 hours before the start time. Failure to do so will result in a "no-show" strike. Accumulating three strikes within a 30-day period will result in a temporary two-week ban from booking any future classes.

(D) Safety and Personal Training
For your safety, closed-toe athletic shoes are mandatory at all times on the gym floor. Sandals, boots, or bare feet are strictly prohibited. Independent personal trainers are not allowed to conduct business on the premises. If you require professional guidance, you must book a session with one of our certified in-house Core Fitness trainers. Your first orientation session with an in-house trainer is completely free of charge upon joining.');

-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('91836768-325a-4785-8c90-82d1cd4cc1b3', '18509aa1-fd04-4e31-9233-99df3aeb3128', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the text? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('6160e47c-10c8-44fb-a955-79ec2b41c363', '91836768-325a-4785-8c90-82d1cd4cc1b3', 1,
 'You can request to freeze your membership over the phone if you are traveling.', 'FALSE', '["FALSE","False","false"]'),
('299b9f80-dd66-4530-9ffb-aa1dc972cf74', '91836768-325a-4785-8c90-82d1cd4cc1b3', 2,
 'Members are allowed to use treadmills for more than 30 minutes during the morning hours.', 'TRUE', '["TRUE","True","true"]'),
('0d67c9c3-d1e0-45b9-9c1e-4146a4a90e1e', '91836768-325a-4785-8c90-82d1cd4cc1b3', 3,
 'The antibacterial wipes provided by the gym are environmentally friendly.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('122298e0-5d35-482d-ae55-68cb4aace946', '91836768-325a-4785-8c90-82d1cd4cc1b3', 4,
 'Basic members can attend group fitness classes for free.', 'FALSE', '["FALSE","False","false"]');

-- ── Group 2: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('713ca4d8-c7f8-423e-a616-32c1df796f99', '18509aa1-fd04-4e31-9233-99df3aeb3128', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN TWO WORDS AND/OR A NUMBER from the text for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('79706c18-d774-4929-a296-c149e135632d', '713ca4d8-c7f8-423e-a616-32c1df796f99', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"Situation","answer":""},{"id":"h2","gapText":"Rule / Consequence","answer":""}]'),
('f2709a60-8df1-4b3f-8f0f-4d7dfd76c6d5', '713ca4d8-c7f8-423e-a616-32c1df796f99', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"Missing a payment","answer":""},{"id":"c2","gapText":"You are given a {{gap}} to pay before being charged a $10 fee.","answer":"grace period"}]'),
('dd5926ee-6651-4205-aa7d-c3deb38214fc', '713ca4d8-c7f8-423e-a616-32c1df796f99', 7,
 'Row 3', '',
 '[{"id":"c3","gapText":"Carrying gym bags on the floor","answer":""},{"id":"c4","gapText":"Not allowed; must be kept in the {{gap}}.","answer":"locker rooms"}]'),
('fb732956-d0d4-429b-8bed-71480d74bb66', '713ca4d8-c7f8-423e-a616-32c1df796f99', 8,
 'Row 4', '',
 '[{"id":"c5","gapText":"Getting 3 strikes for missed classes","answer":""},{"id":"c6","gapText":"Results in a {{gap}} on making new bookings.","answer":"temporary ban"}]'),
('57427b05-68c7-4755-b1af-207cb4ea37b0', '713ca4d8-c7f8-423e-a616-32c1df796f99', 9,
 'Row 5', '',
 '[{"id":"c7","gapText":"Joining the gym for the first time","answer":""},{"id":"c8","gapText":"Includes one free {{gap}} with an in-house trainer.","answer":"orientation session"}]');

-- ── Group 3: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('a7907f95-34c3-4da4-8272-f9328f81a069', '18509aa1-fd04-4e31-9233-99df3aeb3128', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN TWO WORDS AND/OR A NUMBER from the text for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('cecf273c-f8de-4edd-aeea-984ec36ab41f', 'a7907f95-34c3-4da4-8272-f9328f81a069', 10,
 'How much does it cost to replace a lost membership card?', '$15', '[{"id":"1","text":"$15"},{"id":"2","text":"15 dollars"}]'),
('dea60191-d390-465b-a1f3-52b77d1e900c', 'a7907f95-34c3-4da4-8272-f9328f81a069', 11,
 'What time does the gym consider to be the start of its peak hours on weekdays?', '5:00 PM', '[{"id":"1","text":"5:00 PM"},{"id":"2","text":"5:00 pm"},{"id":"3","text":"5 PM"}]'),
('e91cc2e7-ecf0-4a38-85f6-1d59d33abc4a', 'a7907f95-34c3-4da4-8272-f9328f81a069', 12,
 'Through what method should members reserve their spot in group fitness classes?', 'mobile app', '[{"id":"1","text":"mobile app"},{"id":"2","text":"our mobile app"}]'),
('0ba2d03c-f2fb-42fe-b6fe-f1e9f53e104b', 'a7907f95-34c3-4da4-8272-f9328f81a069', 13,
 'What type of footwear must members wear on the gym floor?', 'closed-toe', '[{"id":"1","text":"closed-toe"},{"id":"2","text":"closed-toe shoes"},{"id":"3","text":"athletic shoes"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Workplace Ergonomics and Safety (Q14–27)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('a6f4af5a-d2c6-4b5c-ac3c-d08bdb96337d', 'ade2bff5-810d-4b5d-813a-2db8a7cdafae', 2,
 'Best Practices for Workplace Ergonomics and Employee Safety',
 '(A) Ergonomics is the science of designing the workplace to fit the capabilities and limitations of the worker, rather than forcing the worker to adapt to the physical environment. Poor ergonomic design can lead to musculoskeletal disorders (MSDs), which affect the muscles, nerves, blood vessels, and tendons. The most common MSDs include carpal tunnel syndrome, tendinitis, and lower back pain. By implementing ergonomic best practices, companies can significantly reduce the risk of these injuries, leading to a healthier workforce and a decrease in absenteeism.

(B) The computer workstation is a primary source of ergonomic strain in modern offices. A properly configured workstation begins with the chair. An ideal office chair should have adjustable height, lumbar support for the lower back, and armrests that allow the shoulders to remain relaxed. When seated, an employee’s feet should rest flat on the floor, and their knees should be at or slightly below hip level. If the chair cannot be lowered sufficiently without compromising desk height, a sturdy footrest should be provided to ensure proper lower body circulation.

(C) Screen positioning is equally critical to prevent neck and eye strain. The top of the computer monitor should be at or slightly below eye level, and the screen should be positioned roughly an arm’s length away. Dual-monitor setups, which are increasingly common, require special attention. If both screens are used equally, they should be placed symmetrically in front of the user. If one screen is used more frequently, it should be placed directly in front, with the secondary monitor placed off to the dominant side, angled slightly inward.

(D) Despite perfect posture and workstation setup, the human body is not designed for prolonged periods of static sitting. The "20-20-20 rule" is highly recommended by occupational health professionals to reduce eye fatigue: every 20 minutes, look at an object at least 20 feet away for 20 seconds. In addition to visual breaks, physical micro-breaks are essential. Employees should stand, stretch, or take a short walk for at least two minutes every hour to stimulate blood flow and reduce muscle tension.

(E) For employees whose roles require heavy lifting or manual material handling, ergonomic guidelines shift from posture to biomechanics. The golden rule of lifting is to lift with the legs, not the back. Workers should keep the load as close to their body as possible and avoid twisting their torso while holding a heavy object. If an object weighs more than 50 pounds, or if its shape makes it awkward to carry, employees are required to use mechanical lifting aids, such as a hand truck or a forklift, or seek assistance from a colleague.

(F) Implementing a successful ergonomics program requires active participation from both management and staff. Management must be willing to invest in adjustable furniture and proper training. However, employees bear the responsibility of adjusting their workstations according to the training provided and reporting any early signs of discomfort to human resources. Early intervention is the most effective way to prevent a minor ache from developing into a chronic, debilitating injury that requires medical leave.');

-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('fc077794-49f5-4983-a8e3-b4872b020354', 'a6f4af5a-d2c6-4b5c-ac3c-d08bdb96337d', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. Safe practices for transporting heavy items", "ii. The shared duties of employers and workers", "iii. The importance of regular movement and visual rest", "iv. Adjusting your seating for optimal posture", "v. Understanding ergonomics and its health benefits", "vi. Treating serious repetitive strain injuries", "vii. Arranging visual displays to avoid strain", "viii. Why standing desks are becoming mandatory"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('a27c33d6-53f3-4127-9d2c-8e69e6b81f3c', 'fc077794-49f5-4983-a8e3-b4872b020354', 14, 'Paragraph A', 'v'),
('d697e230-3ee9-4088-a750-d03171535361', 'fc077794-49f5-4983-a8e3-b4872b020354', 15, 'Paragraph B', 'iv'),
('1a5705b9-c1f2-4e16-ae21-5ddb09e9b69e', 'fc077794-49f5-4983-a8e3-b4872b020354', 16, 'Paragraph C', 'vii'),
('c02ec6d1-8388-4c7a-a0df-e1f11c08fa68', 'fc077794-49f5-4983-a8e3-b4872b020354', 17, 'Paragraph D', 'iii'),
('c7b78835-b979-417d-b685-bb5bc5ead6d6', 'fc077794-49f5-4983-a8e3-b4872b020354', 18, 'Paragraph E', 'i'),
('4146b2fb-7ed6-4654-b7c9-1d99d50babb2', 'fc077794-49f5-4983-a8e3-b4872b020354', 19, 'Paragraph F', 'ii');

-- ── Group 5: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('49ea24cb-2f4d-45d2-8b53-e75d31579c69', 'a6f4af5a-d2c6-4b5c-ac3c-d08bdb96337d', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('491fb6a7-97bb-4d8d-9815-b919608936de', '49ea24cb-2f4d-45d2-8b53-e75d31579c69', 20,
 'A specific technique designed to relieve eye fatigue.', 'D',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('36364082-53ae-46aa-b4cf-0b2da8ae8880', '49ea24cb-2f4d-45d2-8b53-e75d31579c69', 21,
 'Examples of the physical conditions caused by poorly designed workspaces.', 'A',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('4ca9eda4-577e-41e8-867c-4e77d05f6f1e', '49ea24cb-2f4d-45d2-8b53-e75d31579c69', 22,
 'Instructions on what to do if a piece of equipment cannot be safely carried by one person.', 'E',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('12f04980-59a2-4391-b08e-e415657bab27', '49ea24cb-2f4d-45d2-8b53-e75d31579c69', 23,
 'The correct way to set up two computer monitors of unequal usage.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');

-- ── Group 6: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('37e46728-ee6c-4774-aae0-4fa6d89c4bdb', 'a6f4af5a-d2c6-4b5c-ac3c-d08bdb96337d', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('7e0912fa-8e6c-4db5-b842-4821e9c381de', '37e46728-ee6c-4774-aae0-4fa6d89c4bdb', 24,
 'What should an employee do if their chair is too high for their feet to rest flat on the floor?',
 'C',
 '[{"id":"A","text":"A. Lower the desk to match the chair height.","isCorrect":false},{"id":"B","text":"B. Cross their legs to improve circulation.","isCorrect":false},{"id":"C","text":"C. Use a footrest to support their feet.","isCorrect":true},{"id":"D","text":"D. Request a new, custom-built chair from HR.","isCorrect":false}]'),
('9caa3e52-ecab-42d6-b08e-e5e28bdd92bd', '37e46728-ee6c-4774-aae0-4fa6d89c4bdb', 25,
 'According to Paragraph D, why are physical micro-breaks important?',
 'A',
 '[{"id":"A","text":"A. They stimulate blood flow and reduce muscle tension.","isCorrect":true},{"id":"B","text":"B. They provide time to communicate with colleagues.","isCorrect":false},{"id":"C","text":"C. They allow the eyes to focus on screens more clearly.","isCorrect":false},{"id":"D","text":"D. They guarantee perfect posture for the rest of the day.","isCorrect":false}]'),
('78a0b2ee-2acb-4b68-92fe-f8b15b836faf', '37e46728-ee6c-4774-aae0-4fa6d89c4bdb', 26,
 'When lifting a heavy object, the passage warns workers to avoid:',
 'B',
 '[{"id":"A","text":"A. Keeping the load close to the body.","isCorrect":false},{"id":"B","text":"B. Twisting the torso while holding the item.","isCorrect":true},{"id":"C","text":"C. Bending at the knees to pick up the object.","isCorrect":false},{"id":"D","text":"D. Using a hand truck for items over 50 pounds.","isCorrect":false}]'),
('566b160a-d862-4e5f-a1ca-9d7d976a96b4', '37e46728-ee6c-4774-aae0-4fa6d89c4bdb', 27,
 'What is the main point made in Paragraph F?',
 'D',
 '[{"id":"A","text":"A. Management is entirely responsible for preventing injuries.","isCorrect":false},{"id":"B","text":"B. Employees should wait until they are in severe pain to report issues.","isCorrect":false},{"id":"C","text":"C. Ergonomic furniture is too expensive for most companies.","isCorrect":false},{"id":"D","text":"D. Ergonomics relies on management investment and employee compliance.","isCorrect":true}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: The Global Journey of Coffee (Q28–40)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('d086ce1e-2626-4675-8d18-bd39a1b582d8', 'ade2bff5-810d-4b5d-813a-2db8a7cdafae', 3,
 'The Global Journey of Coffee: From Ethiopian Forests to Modern Cafes',
 '(A) Today, coffee is one of the most widely consumed beverages in the world, fueling early morning commutes and late-night study sessions alike. However, the origin of this ubiquitous drink is shrouded in legend. The most famous tale involves a 9th-century Ethiopian goatherd named Kaldi. According to local lore, Kaldi noticed that his goats became exceptionally energetic and refused to sleep after eating the red berries from a certain tree. Intrigued, he reported his findings to the abbot of a local monastery, who brewed a drink with the berries and discovered it kept him alert through long hours of evening prayer. While historians debate the factual accuracy of the Kaldi myth, botanical evidence confirms that the Coffea arabica plant did indeed originate in the lush highlands of Ethiopia.

(B) By the 15th century, coffee had made its way across the Red Sea to the Arabian Peninsula, specifically to the Sufi monasteries of Yemen. Here, coffee was roasted and brewed in a manner strikingly similar to how it is prepared today. The Yemenis called the drink "qahwa," a term originally used for wine, and it quickly became an integral part of their religious and social culture. To maintain a monopoly on this lucrative new crop, Arabian traders strictly prohibited the export of fertile coffee beans. Only beans that had been boiled or parched—rendering them unable to germinate—were permitted to leave the region.

(C) Despite these strict trade protections, coffee’s global expansion was inevitable. In the 17th century, a pilgrim named Baba Budan famously smuggled seven fertile coffee seeds out of Mecca by strapping them to his chest. He planted them in the hills of southern India, successfully establishing the first coffee plantations outside the Arab world. Around the same time, Venetian merchants introduced coffee to Europe. Initially, it was met with suspicion and condemned by some local clergy as the "bitter invention of Satan." However, upon tasting the beverage, Pope Clement VIII reportedly found it so satisfying that he gave it papal approval, accelerating its popularity across the continent.

(D) The rapid spread of coffee houses in 17th-century Europe had profound social implications. Unlike taverns, which were often rowdy and centered around alcohol, coffee houses became hubs of intellectual exchange, political debate, and business networking. In London, they were dubbed "penny universities" because, for the price of a penny, one could purchase a cup of coffee and engage in stimulating conversation with scholars, artists, and merchants. The renowned insurance market Lloyd’s of London originated in Edward Lloyd’s coffee house, where shipowners and merchants gathered to share maritime news.

(E) The Dutch played a pivotal role in transforming coffee into a truly global commodity. In the late 17th century, they managed to obtain coffee seedlings and began cultivating them in their colonies, most notably on the island of Java in present-day Indonesia. The success of the Javanese plantations was staggering, allowing the Dutch to dominate the global coffee trade for decades. Following their success, coffee cultivation spread rapidly to the Americas. In 1723, a French naval officer named Gabriel de Clieu endured a perilous transatlantic voyage, sacrificing his own limited water rations to keep a single coffee seedling alive. This solitary plant eventually became the ancestor of millions of coffee trees throughout the Caribbean and Central America.

(F) Today, the coffee industry is a massive economic engine, supporting the livelihoods of over 125 million people globally. However, the modern coffee trade faces significant challenges. Climate change poses a severe threat to coffee cultivation, particularly to the delicate Arabica species, which requires specific temperature and rainfall patterns to thrive. Furthermore, the economic disparity between the farmers who grow the beans in developing nations and the multi-national corporations that roast and sell them remains a pressing ethical issue. As consumer awareness grows, there is an increasing demand for fair-trade and sustainably sourced coffee, signaling a potential shift towards a more equitable future for the industry.');

-- ── Group 7: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('304ec89a-7419-426d-a7a9-463c69b71997', 'd086ce1e-2626-4675-8d18-bd39a1b582d8', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('bc49e5db-5a32-48c2-ad38-e4c479f40f38', '304ec89a-7419-426d-a7a9-463c69b71997', 28,
 'Historians have conclusively proven that the story of Kaldi the goatherd is true.', 'NO', '["NO","No","no"]'),
('5cd71c55-91c1-43e3-8b6f-d0d3e28f52e7', '304ec89a-7419-426d-a7a9-463c69b71997', 29,
 'Arabian traders boiled coffee beans before exporting them to prevent others from growing the plant.', 'YES', '["YES","Yes","yes"]'),
('f46f63f5-5274-4e3d-a15a-6743f83566d3', '304ec89a-7419-426d-a7a9-463c69b71997', 30,
 'Pope Clement VIII banned coffee after deciding it was an unholy beverage.', 'NO', '["NO","No","no"]'),
('dca4395b-d142-4f85-9ae1-232cc87f138b', '304ec89a-7419-426d-a7a9-463c69b71997', 31,
 'The Dutch colonists forced indigenous people to work on their coffee plantations in Java.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]');

-- ── Group 8: MATCHING SENTENCE ENDINGS (Q32–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('7b89015c-edd5-4019-9556-0b329db4bbf3', 'd086ce1e-2626-4675-8d18-bd39a1b582d8', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('d41fd939-a810-48f0-8804-669ec2b37c5c', '7b89015c-edd5-4019-9556-0b329db4bbf3', 32,
 'Baba Budan changed the course of coffee history when he',
 'C',
 '[{"id":"A","text":"offered a penny to scholars and artists for their advice.","isCorrect":false},{"id":"B","text":"shared his limited water to keep a coffee plant alive on a ship.","isCorrect":false},{"id":"C","text":"secretly took fertile coffee seeds out of Mecca.","isCorrect":true},{"id":"D","text":"require highly specific weather conditions to survive.","isCorrect":false},{"id":"E","text":"became centers for business networking and intellectual debate.","isCorrect":false},{"id":"F","text":"gained absolute control of the global market for a short time.","isCorrect":false}]'),
('03d45368-9781-41fd-b6f8-e656860e8b77', '7b89015c-edd5-4019-9556-0b329db4bbf3', 33,
 'In 17th-century London, coffee houses were unique because they',
 'E',
 '[{"id":"A","text":"offered a penny to scholars and artists for their advice.","isCorrect":false},{"id":"B","text":"shared his limited water to keep a coffee plant alive on a ship.","isCorrect":false},{"id":"C","text":"secretly took fertile coffee seeds out of Mecca.","isCorrect":false},{"id":"D","text":"require highly specific weather conditions to survive.","isCorrect":false},{"id":"E","text":"became centers for business networking and intellectual debate.","isCorrect":true},{"id":"F","text":"gained absolute control of the global market for a short time.","isCorrect":false}]'),
('b1fe89d9-3894-4f79-abce-dd2925c8ed2a', '7b89015c-edd5-4019-9556-0b329db4bbf3', 34,
 'Gabriel de Clieu demonstrated immense dedication when he',
 'B',
 '[{"id":"A","text":"offered a penny to scholars and artists for their advice.","isCorrect":false},{"id":"B","text":"shared his limited water to keep a coffee plant alive on a ship.","isCorrect":true},{"id":"C","text":"secretly took fertile coffee seeds out of Mecca.","isCorrect":false},{"id":"D","text":"require highly specific weather conditions to survive.","isCorrect":false},{"id":"E","text":"became centers for business networking and intellectual debate.","isCorrect":false},{"id":"F","text":"gained absolute control of the global market for a short time.","isCorrect":false}]'),
('2aefd95b-a0a9-4087-accb-525ee3f3cd4d', '7b89015c-edd5-4019-9556-0b329db4bbf3', 35,
 'One of the major threats to modern Arabica coffee plants is that they',
 'D',
 '[{"id":"A","text":"offered a penny to scholars and artists for their advice.","isCorrect":false},{"id":"B","text":"shared his limited water to keep a coffee plant alive on a ship.","isCorrect":false},{"id":"C","text":"secretly took fertile coffee seeds out of Mecca.","isCorrect":false},{"id":"D","text":"require highly specific weather conditions to survive.","isCorrect":true},{"id":"E","text":"became centers for business networking and intellectual debate.","isCorrect":false},{"id":"F","text":"gained absolute control of the global market for a short time.","isCorrect":false}]');

-- ── Group 9: SUMMARY COMPLETION with Word Bank (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('2fd3b670-8f57-408a-805b-282a321ad3c6', 'd086ce1e-2626-4675-8d18-bd39a1b582d8', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["monopoly", "colonies", "commodity", "climate", "livelihoods", "disparity", "suspicion", "beverage"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('a472b574-01ea-44c1-ab8a-628cfdb5697a', '2fd3b670-8f57-408a-805b-282a321ad3c6', 36,
 'The global spread of coffee was initially hindered by Arabian traders who sought to maintain a {{gap_2fd3b670-8f57-408a-805b-282a321ad3c6_0}} on its trade. However, plants were eventually smuggled out, and by the 17th century, European nations like the Dutch began growing coffee extensively in their {{gap_2fd3b670-8f57-408a-805b-282a321ad3c6_1}}. This widespread cultivation transformed coffee into a major international {{gap_2fd3b670-8f57-408a-805b-282a321ad3c6_2}}. Today, while the industry supports millions of people, it faces serious issues. Environmental changes threaten crops, and there is a significant economic {{gap_2fd3b670-8f57-408a-805b-282a321ad3c6_3}} between the farmers in developing countries and the large corporations that profit from their labor.',
 'monopoly'),
('abf669c3-8e16-4a7f-bc0f-3f23b2ddacd0', '2fd3b670-8f57-408a-805b-282a321ad3c6', 37,
 '', 'colonies'),
('75e3b85c-305b-409e-aff7-bcb427cb7b2d', '2fd3b670-8f57-408a-805b-282a321ad3c6', 38,
 '', 'commodity'),
('1a359d99-2109-44fe-97dd-811c46f28447', '2fd3b670-8f57-408a-805b-282a321ad3c6', 39,
 '', 'disparity');

-- ============================================================
-- NOTE: Please execute `UPDATE reading_tests SET created_by = '<your-uid>'` 
-- if required by your application's Row Level Security policies.
-- ============================================================