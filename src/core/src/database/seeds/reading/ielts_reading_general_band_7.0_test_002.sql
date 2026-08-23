-- ============================================================
-- IELTS Practice Platform – Extended Seed Data
-- Target: Reading Module (General Training, Band 7 Difficulty)
-- Action: APPEND (No TRUNCATE)
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST ENTRY (General Training - Band 7)                   ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('3e173f35-ce2d-40a5-96ec-ebb55767c4d1', '90e8ca58-4280-493f-99fc-f8a396635cde',
 'IELTS General Training Reading: Transit Guidelines, Workplace Grievances & Urban Beekeeping (Band 7)', 'General Training', '7', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: Metro Transit Commuter Guidelines (Q1–13)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('30fe82b9-0eb9-4dc7-9bbe-92aed279e1ac', '3e173f35-ce2d-40a5-96ec-ebb55767c4d1', 1,
 'Metropolitan Transit Authority: Commuter Guidelines and Fares',
 'Welcome to the Metropolitan Transit Authority (MTA). To ensure a seamless and comfortable journey for all passengers, we request that you familiarize yourself with our updated ticketing policies and commuter code of conduct.

Ticketing and Fares
All passengers must possess a valid ticket or a registered SmartPass before boarding any train or bus. Single-journey paper tickets can be purchased at the automated kiosks located at every station. Please note that these kiosks no longer accept physical cash; transactions must be made using a debit or credit card. 

For regular commuters, the SmartPass offers a more economical option. It automatically applies a 15% discount to all fares. You can top up your SmartPass online via the MTA app or at any station kiosk. If you fail to tap your card against the reader when exiting a train station, you will be charged the maximum daily fare of $12.00, regardless of the actual distance traveled. 

Baggage and Bicycles
Passengers are welcome to bring luggage and folding bicycles on board at no extra cost. However, full-sized, non-folding bicycles are strictly prohibited during peak commuter hours (6:30 AM to 9:00 AM, and 4:00 PM to 6:30 PM) on weekdays. On weekends and public holidays, full-sized bicycles are permitted at all times, provided they are stored in the designated cycle racks located in the rearmost carriage of the train.

Accessibility and Priority Seating
Every carriage features designated priority seating near the doors. These seats are intended for elderly passengers, pregnant women, and individuals with disabilities. By law, you must vacate these seats if requested by someone who requires them. Furthermore, all main interchange stations are equipped with elevator access to the platforms. If you require assistance boarding the train, please notify a platform attendant at least 10 minutes prior to your scheduled departure.

Lost Property
If you leave a personal item on a train or bus, you should contact the MTA Lost Property Office. Items found by staff are logged and kept at the central depot for a maximum of 30 days. Perishable goods, such as groceries or takeaway food, are disposed of at the end of the operating day for hygiene reasons.');

-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('6bea68e6-51b0-4430-a624-a244f2cb190f', '30fe82b9-0eb9-4dc7-9bbe-92aed279e1ac', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the text? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('c6a44241-b8d5-4efd-84f6-5ead94d8b502', '6bea68e6-51b0-4430-a624-a244f2cb190f', 1,
 'Passengers can use coins and banknotes to buy single-journey tickets at station kiosks.', 'FALSE', '["FALSE","False","false"]'),
('320aed9d-6029-40b8-82fb-fd3a84cb5050', '6bea68e6-51b0-4430-a624-a244f2cb190f', 2,
 'SmartPass users receive a discount on their travel fares.', 'TRUE', '["TRUE","True","true"]'),
('3548e5e3-b133-4cd1-981d-70def84c87b3', '6bea68e6-51b0-4430-a624-a244f2cb190f', 3,
 'Folding bicycles must be stored in the rearmost carriage of the train.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('d1b2d5c8-63e3-4315-aaa5-069a0e99190b', '6bea68e6-51b0-4430-a624-a244f2cb190f', 4,
 'The Lost Property Office keeps all found items for three months before selling them.', 'FALSE', '["FALSE","False","false"]');

-- ── Group 2: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('67a5ebff-6f44-4f47-98fd-4ee31e669c90', '30fe82b9-0eb9-4dc7-9bbe-92aed279e1ac', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN TWO WORDS from the text for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('a2879181-ce69-4a69-83bf-dd10ca175d8a', '67a5ebff-6f44-4f47-98fd-4ee31e669c90', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"Situation / Item","answer":""},{"id":"h2","gapText":"Policy / Consequence","answer":""}]'),
('501ae6a0-0e16-4039-9221-d04c398d86d9', '67a5ebff-6f44-4f47-98fd-4ee31e669c90', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"Failing to tap your SmartPass on exit","answer":""},{"id":"c2","gapText":"You will be charged the {{gap}}","answer":"maximum daily fare"}]'),
('efe0d12b-aa69-480c-a33f-e390db79a53c', '67a5ebff-6f44-4f47-98fd-4ee31e669c90', 7,
 'Row 3', '',
 '[{"id":"c3","gapText":"Full-sized bicycles","answer":""},{"id":"c4","gapText":"Not allowed during {{gap}} on weekdays","answer":"peak commuter hours"}]'),
('9d48bb1f-e2b2-498f-a7f9-a04b5802e3dd', '67a5ebff-6f44-4f47-98fd-4ee31e669c90', 8,
 'Row 4', '',
 '[{"id":"c5","gapText":"Needing help boarding the train","answer":""},{"id":"c6","gapText":"Must notify a {{gap}} in advance","answer":"platform attendant"}]'),
('38114a7d-632d-473e-a0a5-6e66e4d6f85a', '67a5ebff-6f44-4f47-98fd-4ee31e669c90', 9,
 'Row 5', '',
 '[{"id":"c7","gapText":"Lost perishable goods","answer":""},{"id":"c8","gapText":"Will be {{gap}} at the end of the day","answer":"disposed of"}]');

-- ── Group 3: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('4dafc8b4-beb6-4d99-b598-96c26f483376', '30fe82b9-0eb9-4dc7-9bbe-92aed279e1ac', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS from the text for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('36443e2f-79d8-4e64-a94d-2526109d39fe', '4dafc8b4-beb6-4d99-b598-96c26f483376', 10,
 'Where are the automated kiosks situated?', 'at every station', '[{"id":"1","text":"every station"},{"id":"2","text":"at every station"}]'),
('0c8ee781-a9f0-4e98-b8b7-8901619873cd', '4dafc8b4-beb6-4d99-b598-96c26f483376', 11,
 'What amount of money will a passenger be charged if they forget to tap out?', '$12.00', '[{"id":"1","text":"$12.00"},{"id":"2","text":"12.00"},{"id":"3","text":"12 dollars"}]'),
('910fb714-aeeb-4911-a16b-d615c9a2d7ac', '4dafc8b4-beb6-4d99-b598-96c26f483376', 12,
 'Where should non-folding bikes be placed on weekends?', 'designated cycle racks', '[{"id":"1","text":"designated cycle racks"},{"id":"2","text":"cycle racks"}]'),
('ec437147-7c77-4c28-8683-9d24d8332145', '4dafc8b4-beb6-4d99-b598-96c26f483376', 13,
 'Where are all lost items kept by the transit authority?', 'the central depot', '[{"id":"1","text":"the central depot"},{"id":"2","text":"central depot"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Managing Workplace Grievances (Q14–27)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('36b04177-0ee3-4716-a900-7a411061d071', '3e173f35-ce2d-40a5-96ec-ebb55767c4d1', 2,
 'Employee Guide: Managing Workplace Conflict and Grievances',
 '(A) Disagreements in the workplace are inevitable. When individuals from diverse backgrounds collaborate under tight deadlines, friction can occasionally occur. However, Vertex Solutions believes that unaddressed conflicts can severely impact team morale and productivity. It is essential that employees differentiate between a minor difference of opinion and a substantial grievance. A grievance is formally defined as a prolonged, unresolved dispute or a situation where an employee feels they have been treated unfairly, discriminated against, or bullied by a colleague or manager.

(B) The company encourages employees to resolve minor disputes informally whenever possible. Often, a calm and direct conversation between the individuals involved can clear up misunderstandings. Employees are advised to use "I" statements to express how a specific behavior affects them, rather than making accusatory "You" statements. If direct communication feels too daunting, an employee may approach their immediate supervisor to act as an informal mediator to help guide the conversation constructively.

(C) If the informal approach fails, or if the nature of the issue is particularly severe (such as harassment or discrimination), the employee should initiate the formal grievance procedure. This involves submitting a written document outlining the exact nature of the complaint to the Human Resources (HR) department. The document must include specific dates, times, and descriptions of the incidents, as well as the names of any witnesses. Vague accusations without supporting details cannot be adequately investigated.

(D) Upon receiving a formal written grievance, HR will launch an internal investigation within five working days. During this process, confidentiality is paramount. Details of the complaint will only be shared with personnel who are directly involved in the investigation. The investigator will conduct separate, private interviews with the complainant, the accused party, and any identified witnesses. It is crucial that all employees cooperate fully and truthfully with the investigator.

(E) Vertex Solutions operates on a zero-tolerance policy regarding retaliation. An employee who files a grievance in good faith, or anyone who participates in an investigation as a witness, is strictly protected. Any attempt by the accused party or management to penalize, demote, or create a hostile environment for the complainant will result in immediate disciplinary action, which may include termination of employment.

(F) Following the conclusion of the investigation, HR will issue a written report detailing their findings and recommended actions. If the grievance is upheld, management will take appropriate corrective steps. This could range from mandatory conflict resolution training for the offending party to formal warnings or dismissal. If the complainant is unsatisfied with the outcome, they have the right to lodge an appeal with the Board of Directors within fourteen days of receiving the report.');

-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('9d343323-07e8-45a7-8062-e11d71615759', '36b04177-0ee3-4716-a900-7a411061d071', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. Formal procedures for logging a grievance", "ii. The financial cost of workplace disputes", "iii. Confidentiality during the investigation process", "iv. Recognizing the difference between a dispute and a grievance", "v. Appealing a decision made by HR", "vi. Protection against punishment for reporting an issue", "vii. Informal approaches to conflict resolution", "viii. Outcomes and the right to challenge them"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('39133846-5534-494d-a26a-b1322f109812', '9d343323-07e8-45a7-8062-e11d71615759', 14, 'Paragraph A', 'iv'),
('7286a4a0-e4a4-4afb-9d46-26f2f72bf556', '9d343323-07e8-45a7-8062-e11d71615759', 15, 'Paragraph B', 'vii'),
('975db98c-459d-43c4-bc58-b5626422bdf0', '9d343323-07e8-45a7-8062-e11d71615759', 16, 'Paragraph C', 'i'),
('9c455abb-eee5-409c-a237-b2c3b2ee4e27', '9d343323-07e8-45a7-8062-e11d71615759', 17, 'Paragraph D', 'iii'),
('002c2868-db81-4d62-8f13-a88a929062f2', '9d343323-07e8-45a7-8062-e11d71615759', 18, 'Paragraph E', 'vi'),
('70fa0bc8-52dc-48b0-b7c2-67a7948a3a40', '9d343323-07e8-45a7-8062-e11d71615759', 19, 'Paragraph F', 'viii');

-- ── Group 5: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('06e5a5a6-f55c-4bb0-b2e8-b7a04bdde511', '36b04177-0ee3-4716-a900-7a411061d071', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('8a6f4b8f-bfe8-48e5-949c-e255a04113eb', '06e5a5a6-f55c-4bb0-b2e8-b7a04bdde511', 20,
 'A suggestion on how to phrase sentences during a difficult conversation.', 'B',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('35b5fa4a-18f8-4d8b-85e1-855b0a3a6a3b', '06e5a5a6-f55c-4bb0-b2e8-b7a04bdde511', 21,
 'The timeframe within which an investigation must begin.', 'D',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('e434673a-064b-43b4-8f36-458334ad0f97', '06e5a5a6-f55c-4bb0-b2e8-b7a04bdde511', 22,
 'The potential penalties for an employee found guilty of a grievance.', 'F',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('9236d37c-547f-4546-b851-bd8ccb534317', '06e5a5a6-f55c-4bb0-b2e8-b7a04bdde511', 23,
 'The specific details that must be included in a formal written complaint.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');

-- ── Group 6: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('fad3378c-19d4-4c64-b29f-75dd85c74588', '36b04177-0ee3-4716-a900-7a411061d071', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('1479dfe7-00f8-4ba3-b406-8bdac3b3e470', 'fad3378c-19d4-4c64-b29f-75dd85c74588', 24,
 'According to Paragraph A, a grievance is best described as:',
 'C',
 '[{"id":"A","text":"A. A temporary difference of opinion regarding deadlines.","isCorrect":false},{"id":"B","text":"B. A minor conflict between individuals from diverse backgrounds.","isCorrect":false},{"id":"C","text":"C. A situation where an employee experiences ongoing unfair treatment.","isCorrect":true},{"id":"D","text":"D. A failure to communicate directly with a supervisor.","isCorrect":false}]'),
('6619512f-fa92-4517-a567-38f26b96cc6c', 'fad3378c-19d4-4c64-b29f-75dd85c74588', 25,
 'Paragraph B suggests that an immediate supervisor can help by:',
 'A',
 '[{"id":"A","text":"A. Guiding an informal discussion between the people involved.","isCorrect":true},{"id":"B","text":"B. Issuing a formal warning to the accused party.","isCorrect":false},{"id":"C","text":"C. Writing the grievance document on behalf of the employee.","isCorrect":false},{"id":"D","text":"D. Forcing the individuals to use \"I\" statements.","isCorrect":false}]'),
('fb67bf95-e58c-4faf-96e2-2eb83cf4d8aa', 'fad3378c-19d4-4c64-b29f-75dd85c74588', 26,
 'During an investigation, the HR investigator will:',
 'D',
 '[{"id":"A","text":"A. Share the complaint details with the whole department.","isCorrect":false},{"id":"B","text":"B. Interview the complainant and accused in the same room.","isCorrect":false},{"id":"C","text":"C. Only speak to the person who filed the complaint.","isCorrect":false},{"id":"D","text":"D. Speak privately to all parties, including witnesses.","isCorrect":true}]'),
('7039fcc2-e0fd-43a7-a62b-c02ddc10e044', 'fad3378c-19d4-4c64-b29f-75dd85c74588', 27,
 'What is the company’s stance on retaliation, as mentioned in Paragraph E?',
 'B',
 '[{"id":"A","text":"A. Retaliation is allowed if the grievance is proven to be false.","isCorrect":false},{"id":"B","text":"B. Anyone punishing an employee for complaining faces severe discipline.","isCorrect":true},{"id":"C","text":"C. Witnesses are protected, but the complainant is not.","isCorrect":false},{"id":"D","text":"D. It is handled informally by the immediate supervisor.","isCorrect":false}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: Urban Beekeeping (Q28–40)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('c5fd28c0-6e59-4796-bbe5-28986ba59b61', '3e173f35-ce2d-40a5-96ec-ebb55767c4d1', 3,
 'Urban Beekeeping: A Modern Solution to Biodiversity Decline',
 '(A) When most people envision a beekeeper, they picture a rural setting: someone in a white suit tending to wooden hives in a sunlit meadow or a sprawling orchard. However, over the past decade, a quiet revolution has been taking place on the rooftops of major cities across the globe. From London to New York, and Paris to Tokyo, urban beekeeping has surged in popularity. High above the noisy, concrete streets, thousands of honeybee colonies are thriving. This trend is not merely a hipster hobby; it is a critical response to the alarming global decline in bee populations, a phenomenon largely driven by habitat loss, pesticide use, and climate change in rural areas.

(B) The honeybee (Apis mellifera) is remarkably adaptable, and surprisingly, cities can offer a highly hospitable environment for them. While rural agricultural lands often feature massive monocultures—miles of a single crop that blooms for only a few weeks a year—cities provide a diverse, year-round floral buffet. Urban parks, community gardens, balcony planters, and tree-lined streets offer a wide variety of nectar sources. Because cities are typically warmer than surrounding rural areas, owing to the "urban heat island" effect, flowers tend to bloom earlier in the spring and last longer into the autumn, giving bees a more extended foraging season.

(C) Furthermore, urban environments are generally free from the heavy industrial pesticides that have devastated rural colonies. Neonicotinoids, a class of insecticides widely used in commercial farming, have been strongly linked to Colony Collapse Disorder (CCD), a phenomenon where the majority of worker bees abandon a hive. In cities, while local councils may use mild herbicides on municipal flowerbeds, the sheer volume of toxic chemicals is drastically lower. As a result, urban bees often boast higher survival rates over the winter and produce yields of honey that frequently surpass those of their country-dwelling counterparts.

(D) Despite its environmental benefits, the rise of urban beekeeping has not been without controversy. Some ecologists warn of the potential negative impact on wild, native bee species. The honeybee is just one of over 20,000 species of bees worldwide. Many native bees are solitary, do not produce harvestable honey, and are highly specialized to pollinate specific local plants. Introducing large numbers of managed honeybees into a concentrated urban area can create intense competition for limited nectar and pollen resources. Critics argue that well-intentioned urban beekeepers may inadvertently be driving vulnerable native pollinators toward localized extinction.

(E) To mitigate these concerns, city governments are increasingly stepping in to regulate the practice. In many municipalities, prospective beekeepers must now register their hives with local authorities. There are often restrictions on the number of hives permitted per square mile, ensuring the local floral ecosystem is not overwhelmed. Additionally, public education campaigns are encouraging city residents to focus not just on keeping honeybees, but on creating pollinator-friendly habitats. This involves planting native wildflowers and providing "bee hotels"—small structures made of hollow reeds or drilled wood that offer nesting sites for solitary native bees.

(F) Ultimately, urban beekeeping serves as a powerful educational tool. It connects city dwellers, who are often entirely alienated from agricultural processes, to the natural world and the food supply chain. When a corporate office building installs a beehive on its roof, it prompts employees to consider the broader ecological implications of pollination. While keeping honeybees on skyscrapers will not single-handedly solve the global biodiversity crisis, it fosters a crucial awareness. It reminds urbanites that human survival is inextricably linked to the health of the smallest insects, even in the heart of the concrete jungle.');

-- ── Group 7: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('20e6c64e-8817-4bac-bde2-c4209690aa13', 'c5fd28c0-6e59-4796-bbe5-28986ba59b61', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('f3285263-4bdb-4b4a-b679-998d0b47bf6a', '20e6c64e-8817-4bac-bde2-c4209690aa13', 28,
 'The global decline in bee populations is partly caused by the use of chemicals in farming.', 'YES', '["YES","Yes","yes"]'),
('0881632e-ae44-4e26-9ca4-5d18ac1c1aac', '20e6c64e-8817-4bac-bde2-c4209690aa13', 29,
 'Rural farmland provides bees with a better variety of food throughout the year than cities do.', 'NO', '["NO","No","no"]'),
('1b2de900-456a-4749-b225-0668ccba3bb7', '20e6c64e-8817-4bac-bde2-c4209690aa13', 30,
 'Honey produced in urban areas is safer for human consumption than rural honey.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('c6323ada-85d4-43bf-a99d-c67a4d79d8e8', '20e6c64e-8817-4bac-bde2-c4209690aa13', 31,
 'Urban beekeeping makes city residents more aware of where their food comes from.', 'YES', '["YES","Yes","yes"]');

-- ── Group 8: MATCHING SENTENCE ENDINGS (Q32–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('7e1fe358-3b53-4504-8e50-2b53e91fc1a8', 'c5fd28c0-6e59-4796-bbe5-28986ba59b61', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('d44c52de-b98d-4f02-b53f-c44a51d8ffa8', '7e1fe358-3b53-4504-8e50-2b53e91fc1a8', 32,
 'The "urban heat island" effect is beneficial because it',
 'D',
 '[{"id":"A","text":"restricts the number of hives that can be placed in one area.","isCorrect":false},{"id":"B","text":"can negatively affect the survival of wild, native pollinators.","isCorrect":false},{"id":"C","text":"have caused many rural honeybee colonies to collapse entirely.","isCorrect":false},{"id":"D","text":"lengthens the amount of time flowers are available for bees to feed on.","isCorrect":true},{"id":"E","text":"provides solitary bees with a safe place to build their nests.","isCorrect":false},{"id":"F","text":"encourages the planting of native wildflowers in community gardens.","isCorrect":false}]'),
('4d9d6dcc-a717-4426-8c4d-da95479abb5d', '7e1fe358-3b53-4504-8e50-2b53e91fc1a8', 33,
 'Certain toxic chemicals used in commercial agriculture',
 'C',
 '[{"id":"A","text":"restricts the number of hives that can be placed in one area.","isCorrect":false},{"id":"B","text":"can negatively affect the survival of wild, native pollinators.","isCorrect":false},{"id":"C","text":"have caused many rural honeybee colonies to collapse entirely.","isCorrect":true},{"id":"D","text":"lengthens the amount of time flowers are available for bees to feed on.","isCorrect":false},{"id":"E","text":"provides solitary bees with a safe place to build their nests.","isCorrect":false},{"id":"F","text":"encourages the planting of native wildflowers in community gardens.","isCorrect":false}]'),
('f2a7278b-2a7f-48b8-97a5-061b1a57e2be', '7e1fe358-3b53-4504-8e50-2b53e91fc1a8', 34,
 'Keeping large amounts of honeybees in a city',
 'B',
 '[{"id":"A","text":"restricts the number of hives that can be placed in one area.","isCorrect":false},{"id":"B","text":"can negatively affect the survival of wild, native pollinators.","isCorrect":true},{"id":"C","text":"have caused many rural honeybee colonies to collapse entirely.","isCorrect":false},{"id":"D","text":"lengthens the amount of time flowers are available for bees to feed on.","isCorrect":false},{"id":"E","text":"provides solitary bees with a safe place to build their nests.","isCorrect":false},{"id":"F","text":"encourages the planting of native wildflowers in community gardens.","isCorrect":false}]'),
('80d5322f-2b12-496b-8aed-c2b1a00f1e1f', '7e1fe358-3b53-4504-8e50-2b53e91fc1a8', 35,
 'Local government legislation often',
 'A',
 '[{"id":"A","text":"restricts the number of hives that can be placed in one area.","isCorrect":true},{"id":"B","text":"can negatively affect the survival of wild, native pollinators.","isCorrect":false},{"id":"C","text":"have caused many rural honeybee colonies to collapse entirely.","isCorrect":false},{"id":"D","text":"lengthens the amount of time flowers are available for bees to feed on.","isCorrect":false},{"id":"E","text":"provides solitary bees with a safe place to build their nests.","isCorrect":false},{"id":"F","text":"encourages the planting of native wildflowers in community gardens.","isCorrect":false}]');

-- ── Group 9: SUMMARY COMPLETION with Word Bank (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('2bea3957-4d1b-421d-a74d-a53603f3a6c2', 'c5fd28c0-6e59-4796-bbe5-28986ba59b61', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["yields", "adaptable", "regulations", "decline", "pesticides", "competition", "concrete", "pollination"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('1c6e7591-9781-4e34-9783-37dfc1560a5f', '2bea3957-4d1b-421d-a74d-a53603f3a6c2', 36,
 'Urban beekeeping is a growing trend driven by the rapid {{gap_2bea3957-4d1b-421d-a74d-a53603f3a6c2_0}} of rural bee populations. Because honeybees are highly {{gap_2bea3957-4d1b-421d-a74d-a53603f3a6c2_1}}, they flourish in cities where they can forage on a wide variety of plants year-round. They also benefit from the absence of harmful {{gap_2bea3957-4d1b-421d-a74d-a53603f3a6c2_2}} used in commercial farming, often resulting in larger honey {{gap_2bea3957-4d1b-421d-a74d-a53603f3a6c2_3}}. However, introducing too many honeybees can cause intense {{gap_2bea3957-4d1b-421d-a74d-a53603f3a6c2_4}} for nectar, threatening solitary native species. To manage this, authorities are introducing rules and encouraging the creation of habitats for all pollinators.',
 'decline'),
('a3ae863c-db24-4969-8ea0-01fe2adf1605', '2bea3957-4d1b-421d-a74d-a53603f3a6c2', 37,
 '', 'adaptable'),
('f5b78544-db01-4a01-8478-8886e699d594', '2bea3957-4d1b-421d-a74d-a53603f3a6c2', 38,
 '', 'pesticides'),
('e516832b-53bf-4767-94bf-77d9ae82af54', '2bea3957-4d1b-421d-a74d-a53603f3a6c2', 39,
 '', 'yields'),
('9dfe659d-29bc-4654-92f7-5e3d3e3b1804', '2bea3957-4d1b-421d-a74d-a53603f3a6c2', 40,
 '', 'competition');

-- ============================================================
-- NOTE: Please execute `UPDATE reading_tests SET created_by = '<your-uid>'` 
-- if required by your application's Row Level Security policies.
-- ============================================================
