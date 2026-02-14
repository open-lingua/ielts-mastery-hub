-- ============================================================
-- IELTS Practice Platform – Comprehensive Seed Data (Test 3)
-- Appends to: 02_ielts_practice_test.sql
-- ============================================================
-- NOTE: `created_by` uses a placeholder UUID. After seeding,
-- update it to a real user's auth.uid() so RLS allows access:
--   UPDATE reading_tests  SET created_by = '<your-uid>' WHERE id = 'a1000000-0000-0000-0000-000000000003';
--   UPDATE listening_tests SET created_by = '<your-uid>' WHERE id = 'a2000000-0000-0000-0000-000000000003';
--   UPDATE writing_tests  SET created_by = '<your-uid>' WHERE id = 'a3000000-0000-0000-0000-000000000003';
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
 '(A) In the first half of the 19th century, London''s population grew at an astonishing rate, expanding from roughly one million in 1800 to over two and a half million by 1850. The resulting congestion on the city''s narrow medieval streets was catastrophic. Horse-drawn omnibuses, carts, and pedestrians engaged in a daily struggle for space. The situation was exacerbated by the arrival of main-line railways, which brought hundreds of thousands of commuters to terminals on the edge of the city center but were forbidden by Parliament from entering the heart of the capital.

(B) The solution was proposed by Charles Pearson, a visionary city solicitor who campaigned tirelessly for a subterranean railway linking the mainline stations. Despite widespread skepticism—with critics warning that the tunnels would collapse or that the subterranean atmosphere would poison passengers—Pearson secured funding. The Metropolitan Railway was established, and construction began in 1860 using the "cut-and-cover" method. This involved digging a massive trench along the route of existing streets, laying down brick retaining walls and an arched roof, and then rebuilding the road surface on top.

(C) On January 10, 1863, the Metropolitan Railway opened to the public, becoming the world''s first underground passenger railway. The initial route ran for nearly four miles between Paddington and Farringdon. It was an instant success, carrying 38,000 passengers on its opening day. However, the early travel experience was far from pleasant. The trains were pulled by steam locomotives, and despite attempts to condense the exhaust, the tunnels were constantly filled with thick, choking smoke and soot. 

(D) The true revolution in underground travel came with the advent of electricity. In 1890, the City and South London Railway opened as the first deep-level, electrically operated railway. Because electric trains did not emit smoke, tunnels could be bored deep underground using a tunneling shield, without the need for ventilation shafts. These circular, deep-level tunnels gave rise to the system''s famous nickname, the "Tube." 

(E) As the network expanded with different private companies operating competing lines, navigating the system became confusing. In 1908, the operators collaborated to produce the first unified map of the network, and introduced the now-iconic UNDERGROUND brand featuring a red circle with a blue bar, known as the roundel. Finally, in 1933, the various private lines were nationalised and merged into a single public entity, the London Passenger Transport Board, securing the future of the iconic transport network.');

-- ── Group 23: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1100000-0000-0000-0000-000000000023', 'b1100000-0000-0000-0000-000000000007', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the passage? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d1100000-0000-0000-0000-000000000081', 'c1100000-0000-0000-0000-000000000023', 1,
 'Main-line railways in the 1850s were permitted to build terminals directly in the center of London.', 'FALSE', '["FALSE","False","false"]'::jsonb),
('d1100000-0000-0000-0000-000000000082', 'c1100000-0000-0000-0000-000000000023', 2,
 'Charles Pearson personally funded the construction of the Metropolitan Railway.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'::jsonb),
('d1100000-0000-0000-0000-000000000083', 'c1100000-0000-0000-0000-000000000023', 3,
 'The first underground trains were powered by steam locomotives.', 'TRUE', '["TRUE","True","true"]'::jsonb),
('d1100000-0000-0000-0000-000000000084', 'c1100000-0000-0000-0000-000000000023', 4,
 'The nickname "Tube" originated from the shape of the deep-level tunnels.', 'TRUE', '["TRUE","True","true"]'::jsonb);

-- ── Group 24: SHORT ANSWER (Q5–8) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('c1100000-0000-0000-0000-000000000024', 'b1100000-0000-0000-0000-000000000007', 2,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS from the passage for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d1100000-0000-0000-0000-000000000085', 'c1100000-0000-0000-0000-000000000024', 5,
 'What construction method was used for the Metropolitan Railway?', 'cut-and-cover', '[{"id":"1","text":"cut-and-cover"},{"id":"2","text":"cut and cover"}]'::jsonb),
('d1100000-0000-0000-0000-000000000086', 'c1100000-0000-0000-0000-000000000024', 6,
 'How many passengers travelled on the Metropolitan Railway on its opening day?', '38,000', '[{"id":"1","text":"38,000"},{"id":"2","text":"38000"}]'::jsonb),
('d1100000-0000-0000-0000-000000000087', 'c1100000-0000-0000-0000-000000000024', 7,
 'What equipment was used to dig the deep-level tunnels?', 'tunneling shield', '[{"id":"1","text":"tunneling shield"},{"id":"2","text":"a tunneling shield"}]'::jsonb),
('d1100000-0000-0000-0000-000000000088', 'c1100000-0000-0000-0000-000000000024', 8,
 'What is the specific name given to the red circle and blue bar logo?', 'roundel', '[{"id":"1","text":"roundel"},{"id":"2","text":"the roundel"}]'::jsonb);

-- ── Group 25: TABLE COMPLETION (Q9–13) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('c1100000-0000-0000-0000-000000000025', 'b1100000-0000-0000-0000-000000000007', 3,
 'table-completion', 'Complete the table below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('d1100000-0000-0000-0000-000000000089', 'c1100000-0000-0000-0000-000000000025', 9,
 'Row 1', '',
 '[{"id":"h1","gapText":"Year","answer":""},{"id":"h2","gapText":"Event / Development","answer":""}]'::jsonb),
('d1100000-0000-0000-0000-000000000090', 'c1100000-0000-0000-0000-000000000025', 10,
 'Row 2', '',
 '[{"id":"c1","gapText":"1860","answer":""},{"id":"c2","gapText":"Construction began on the ","answer":"Metropolitan Railway"}]'::jsonb),
('d1100000-0000-0000-0000-000000000091', 'c1100000-0000-0000-0000-000000000025', 11,
 'Row 3', '',
 '[{"id":"c3","gapText":"1890","answer":""},{"id":"c4","gapText":"First deep-level line opened, powered by ","answer":"electricity"}]'::jsonb),
('d1100000-0000-0000-0000-000000000092', 'c1100000-0000-0000-0000-000000000025', 12,
 'Row 4', '',
 '[{"id":"c5","gapText":"1908","answer":""},{"id":"c6","gapText":"Introduction of the first ","answer":"unified map"}]'::jsonb),
('d1100000-0000-0000-0000-000000000093', 'c1100000-0000-0000-0000-000000000025', 13,
 'Row 5', '',
 '[{"id":"c7","gapText":"1933","answer":""},{"id":"c8","gapText":"Competing lines merged into a single ","answer":"public entity"}]'::jsonb);


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Vertical Farming (Q14–27)                   ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b1100000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000003', 2,
 'Vertical Farming: The Next Agricultural Revolution?',
 '(A) By the year 2050, the global human population is projected to reach 9.7 billion. To feed everyone, the UN Food and Agriculture Organisation estimates that global food production will need to increase by 70%. However, with over 80% of the world''s arable land already in use, finding new space for traditional agriculture is virtually impossible. In response to this looming crisis, agronomists are turning their attention skyward to a concept known as vertical farming.

(B) Vertical farming involves growing crops in stacked layers, often incorporated into structures like skyscrapers, shipping containers, or repurposed warehouses. Rather than relying on soil and natural sunlight, these farms utilise controlled-environment agriculture (CEA) technology. Plants are grown using hydroponics (roots submerged in nutrient-rich water) or aeroponics (roots misted with nutrients). Artificial LED lighting, tailored to the specific photosynthetic needs of each plant, replaces the sun. 

(C) The advantages of this system are remarkably compelling. Traditional farming consumes roughly 70% of the world''s freshwater. Vertical farms, which recycle their water in closed-loop systems, use up to 95% less water than outdoor farms. Furthermore, because these farms are entirely enclosed, they are immune to unpredictable weather events, droughts, and pests. This eliminates the need for chemical pesticides and allows for year-round harvesting, drastically increasing the yield per square metre compared to field farming.

(D) Despite these benefits, vertical farming faces significant economic and environmental hurdles. The most pressing issue is energy consumption. Powering thousands of LED lights and complex climate-control systems 24 hours a day requires massive amounts of electricity. If this energy is sourced from fossil fuels, the carbon footprint of a vertical farm can far exceed that of a traditional farm. Additionally, the initial capital required to build a vertical farm and purchase the high-tech sensors and lighting is astronomically high, making it difficult for start-ups to achieve profitability.

(E) Currently, the crop variety in vertical farms is somewhat limited. Because of the cost of lighting and space constraints, it is only economically viable to grow fast-growing, high-margin crops like leafy greens, microgreens, and herbs. Caloric staple crops such as wheat, corn, and rice, which require vast amounts of space and long growing cycles, cannot yet be grown profitably indoors. 

(F) Nevertheless, proponents argue that vertical farming is not meant to replace traditional agriculture entirely, but rather to supplement it. By placing vertical farms directly in urban centres, food miles (the distance food travels from farm to plate) are reduced to near zero, cutting transportation emissions and ensuring fresher produce for city dwellers. As renewable energy becomes cheaper and LED technology becomes more efficient, the viability of vertical farming will only increase, securing its place in the future of global food security.');

-- ── Group 26: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('c1100000-0000-0000-0000-000000000026', 'b1100000-0000-0000-0000-000000000008', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. The problem of high energy demands","ii. How the indoor growing system works","iii. Bringing agriculture closer to the consumer","iv. The limitation on what can be grown","v. A demographic and spatial crisis","vi. Environmental and yield benefits","vii. The history of agricultural development"]'::jsonb);

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('d1100000-0000-0000-0000-000000000094', 'c1100000-0000-0000-0000-000000000026', 14, 'Paragraph A', 'v'),
('d1100000-0000-0000-0000-000000000095', 'c1100000-0000-0000-0000-000000000026', 15, 'Paragraph B', 'ii'),
('d1100000-0000-0000-0000-000000000096', 'c1100000-0000-0000-0000-000000000026', 16, 'Paragraph C', 'vi'),
('d1100000-0000-0000-0000-000000000097', 'c1100000-0000-0000-0000-000000000026', 17, 'Paragraph D', 'i'),
('d1100000-0000-0000-0000-000000000098', 'c1100000-0000-0000-0000-000000000026', 18, 'Paragraph E', 'iv'),
('d1100000-0000-0000-0000-000000000099', 'c1100000-0000-0000-0000-000000000026', 19, 'Paragraph F', 'iii');

-- ── Group 27: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1100000-0000-0000-0000-000000000027', 'b1100000-0000-0000-0000-000000000008', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('d1100000-0000-0000-0000-0000000000100', 'c1100000-0000-0000-0000-000000000027', 20,
 'Reference to a method of growing plants where roots are sprayed with a mist.', 'B',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'::jsonb),
('d1100000-0000-0000-0000-0000000000101', 'c1100000-0000-0000-0000-000000000027', 21,
 'An explanation of why certain crops like wheat are not suitable for this method.', 'E',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'::jsonb),
('d1100000-0000-0000-0000-0000000000102', 'c1100000-0000-0000-0000-000000000027', 22,
 'A statistic indicating how much more food the world will need.', 'A',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'::jsonb),
('d1100000-0000-0000-0000-0000000000103', 'c1100000-0000-0000-0000-000000000027', 23,
 'The reason why chemical pesticides are unnecessary in vertical farming.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'::jsonb);

-- ── Group 28: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1100000-0000-0000-0000-000000000028', 'b1100000-0000-0000-0000-000000000008', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('d1100000-0000-0000-0000-0000000000104', 'c1100000-0000-0000-0000-000000000028', 24,
 'According to Paragraph C, how do vertical farms achieve massive water savings?',
 'B',
 '[{"id":"A","text":"A. By growing crops that naturally require less water.","isCorrect":false},{"id":"B","text":"B. By recycling water within a closed-loop system.","isCorrect":true},{"id":"C","text":"C. By capturing rainwater from the roofs of skyscrapers.","isCorrect":false},{"id":"D","text":"D. By limiting the number of harvests per year.","isCorrect":false}]'::jsonb),
('d1100000-0000-0000-0000-0000000000105', 'c1100000-0000-0000-0000-000000000028', 25,
 'The writer suggests in Paragraph D that vertical farming could actually harm the environment if:',
 'C',
 '[{"id":"A","text":"A. they use too much municipal water.","isCorrect":false},{"id":"B","text":"B. start-ups fail to make a profit.","isCorrect":false},{"id":"C","text":"C. the electricity used comes from fossil fuels.","isCorrect":true},{"id":"D","text":"D. LED lights produce too much heat.","isCorrect":false}]'::jsonb),
('d1100000-0000-0000-0000-0000000000106', 'c1100000-0000-0000-0000-000000000028', 26,
 'What is currently the most profitable crop type for vertical farms?',
 'D',
 '[{"id":"A","text":"A. Root vegetables like potatoes.","isCorrect":false},{"id":"B","text":"B. Caloric staples like rice.","isCorrect":false},{"id":"C","text":"C. Fruit trees.","isCorrect":false},{"id":"D","text":"D. Leafy greens and herbs.","isCorrect":true}]'::jsonb),
('d1100000-0000-0000-0000-0000000000107', 'c1100000-0000-0000-0000-000000000028', 27,
 'What does the phrase "food miles" refer to?',
 'A',
 '[{"id":"A","text":"A. The distance produce travels from the farm to the consumer.","isCorrect":true},{"id":"B","text":"B. The amount of land required to grow food.","isCorrect":false},{"id":"C","text":"C. The length of the growing cycle of a crop.","isCorrect":false},{"id":"D","text":"D. The height of the stacked layers in a vertical farm.","isCorrect":false}]'::jsonb);

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: Biomimicry (Q28–40)                         ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b1100000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000003', 3,
 'Biomimicry: Engineering Inspired by Nature',
 '(A) For billions of years, the natural world has been operating as an immense research and development laboratory. Through the relentless process of natural selection, evolution has solved many of the engineering challenges that humans grapple with today—from energy generation and temperature regulation to aerodynamic efficiency and structural strength. Biomimicry is the scientific discipline that seeks to study these natural blueprints and adapt them to solve modern human problems.

(B) The term "biomimicry" was popularised by scientist Janine Benyus in her 1997 book. She argued that humans should look at nature not as a resource to be extracted, but as a mentor to be learned from. One of the earliest and most famous examples of biomimicry occurred in the 1940s when Swiss engineer George de Mestral took his dog for a walk in the woods. Upon returning, he noticed burrs stuck tightly to his trousers and his dog''s fur. Examining them under a microscope, he discovered they were covered in tiny, flexible hooks that latched onto loops of thread. This observation led directly to his invention of Velcro.

(C) More recently, biomimicry has solved complex aerodynamic issues. When Japan''s Shinkansen "bullet train" was first introduced, it suffered from a major flaw: as it exited tunnels at high speeds, it created a massive sonic boom that shattered nearby windows and woke residents. The chief engineer, Eiji Nakatsu, happened to be an avid birdwatcher. He noticed that the kingfisher bird could dive from the air into water with barely a splash, thanks to its streamlined, aerodynamic beak. By redesigning the nose of the train to mimic the kingfisher''s beak, Nakatsu not only eliminated the sonic boom but also made the train 10% faster and 15% more energy-efficient.

(D) In the field of medicine, biomimicry is fighting the rise of antibiotic-resistant bacteria. Hospitals struggle with bacteria settling on surfaces, which traditionally required harsh chemicals to clean. Researchers studying sharks noticed that despite moving slowly through the ocean, shark skin is completely free of algae and barnacles. Microscopically, shark skin is covered in overlapping, diamond-shaped scales called dermal denticles that create a highly textured surface, making it mechanically impossible for bacteria to attach and form colonies. This discovery led to the creation of "Sharklet," a synthetic surface texture applied to hospital bedrails and door handles that repels bacteria without the use of toxic chemicals.

(E) Architecture has also benefited immensely from observing nature. The Eastgate Centre in Harare, Zimbabwe, is a large office and shopping complex that operates without a conventional air-conditioning system, a remarkable feat in a hot climate. Architect Mick Pearce modeled the building on the cooling chimneys of African termite mounds. Termites constantly open and close vents throughout their mounds to regulate temperature and airflow. By adopting a similar passive cooling system of structural flues and vents, the Eastgate Centre uses 90% less energy for ventilation than a similarly sized conventional building.

(F) As the threat of climate change intensifies, biomimicry offers a pathway to sustainable innovation. By acknowledging that nature has already solved our most pressing design challenges with a total reliance on solar energy and without producing toxic waste, human engineers can design technologies that are not only highly efficient but also harmoniously integrated with the Earth''s ecosystems.');

-- ── Group 29: YES/NO/NOT GIVEN (Q28–32) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1100000-0000-0000-0000-000000000029', 'b1100000-0000-0000-0000-000000000009', 1,
 'yes-no-not-given', 'Do the following statements agree with the views of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d1100000-0000-0000-0000-0000000000108', 'c1100000-0000-0000-0000-000000000029', 28,
 'Janine Benyus was the first person to ever use biological inspiration in an invention.', 'NO', '["NO","No","no"]'::jsonb),
('d1100000-0000-0000-0000-0000000000109', 'c1100000-0000-0000-0000-000000000029', 29,
 'George de Mestral invented Velcro after examining plant burrs under a microscope.', 'YES', '["YES","Yes","yes"]'::jsonb),
('d1100000-0000-0000-0000-0000000000110', 'c1100000-0000-0000-0000-000000000029', 30,
 'The original bullet train was too slow to meet the demands of Japanese commuters.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'::jsonb),
('d1100000-0000-0000-0000-0000000000111', 'c1100000-0000-0000-0000-000000000029', 31,
 'Sharklet surfaces kill bacteria upon contact using natural chemicals.', 'NO', '["NO","No","no"]'::jsonb),
('d1100000-0000-0000-0000-0000000000112', 'c1100000-0000-0000-0000-000000000029', 32,
 'The Eastgate Centre relies heavily on conventional air-conditioning during the summer.', 'NO', '["NO","No","no"]'::jsonb);

-- ── Group 30: MATCHING SENTENCE ENDINGS (Q33–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1100000-0000-0000-0000-000000000030', 'b1100000-0000-0000-0000-000000000009', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('d1100000-0000-0000-0000-0000000000113', 'c1100000-0000-0000-0000-000000000030', 33,
 'The Shinkansen train was redesigned with a new nose cone which',
 'E',
 '[{"id":"A","text":"allowed it to dive into water without splashing.","isCorrect":false},{"id":"B","text":"prevents bacteria from attaching and forming colonies.","isCorrect":false},{"id":"C","text":"regulates airflow without using electricity.","isCorrect":false},{"id":"D","text":"latches onto loops of thread effectively.","isCorrect":false},{"id":"E","text":"resolved the issue of the sonic boom exiting tunnels.","isCorrect":true},{"id":"F","text":"relied entirely on solar energy for propulsion.","isCorrect":false}]'::jsonb),
('d1100000-0000-0000-0000-0000000000114', 'c1100000-0000-0000-0000-000000000030', 34,
 'The unique micro-texture of a shark''s skin is useful for hospitals because it',
 'B',
 '[{"id":"A","text":"allowed it to dive into water without splashing.","isCorrect":false},{"id":"B","text":"prevents bacteria from attaching and forming colonies.","isCorrect":true},{"id":"C","text":"regulates airflow without using electricity.","isCorrect":false},{"id":"D","text":"latches onto loops of thread effectively.","isCorrect":false},{"id":"E","text":"resolved the issue of the sonic boom exiting tunnels.","isCorrect":false},{"id":"F","text":"relied entirely on solar energy for propulsion.","isCorrect":false}]'::jsonb),
('d1100000-0000-0000-0000-0000000000115', 'c1100000-0000-0000-0000-000000000030', 35,
 'The ventilation system inside termite mounds',
 'C',
 '[{"id":"A","text":"allowed it to dive into water without splashing.","isCorrect":false},{"id":"B","text":"prevents bacteria from attaching and forming colonies.","isCorrect":false},{"id":"C","text":"regulates airflow without using conventional electricity.","isCorrect":true},{"id":"D","text":"latches onto loops of thread effectively.","isCorrect":false},{"id":"E","text":"resolved the issue of the sonic boom exiting tunnels.","isCorrect":false},{"id":"F","text":"relied entirely on solar energy for propulsion.","isCorrect":false}]'::jsonb);

-- ── Group 31: SUMMARY COMPLETION with Word Bank (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('c1100000-0000-0000-0000-000000000031', 'b1100000-0000-0000-0000-000000000009', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["burrs","speed","kingfisher","passive","chemicals","waste","shark"]'::jsonb);

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('d1100000-0000-0000-0000-0000000000116', 'c1100000-0000-0000-0000-000000000031', 36,
 'Biomimicry looks to nature to solve human design flaws. Velcro was inspired by the tiny hooks found on plant {{gap_c1100000-0000-0000-0000-000000000031_0}}. A Japanese engineer altered a train''s design based on the beak of a {{gap_c1100000-0000-0000-0000-000000000031_1}}, which improved aerodynamic efficiency. In hospitals, surfaces mimicking {{gap_c1100000-0000-0000-0000-000000000031_2}} skin prevent bacterial growth without using harsh {{gap_c1100000-0000-0000-0000-000000000031_3}}. Finally, architecture has utilised the {{gap_c1100000-0000-0000-0000-000000000031_4}} cooling methods of termite mounds to save energy.',
 'burrs'),
('d1100000-0000-0000-0000-0000000000117', 'c1100000-0000-0000-0000-000000000031', 37,
 '', 'kingfisher'),
('d1100000-0000-0000-0000-0000000000118', 'c1100000-0000-0000-0000-000000000031', 38,
 '', 'shark'),
('d1100000-0000-0000-0000-0000000000119', 'c1100000-0000-0000-0000-000000000031', 39,
 '', 'chemicals'),
('d1100000-0000-0000-0000-0000000000120', 'c1100000-0000-0000-0000-000000000031', 40,
 '', 'passive');


-- ████████████████████████████████████████████████████████████
-- ██  2. LISTENING TEST 3                                   ██
-- ████████████████████████████████████████████████████████████

INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status) VALUES
('a2000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001',
 'IELTS Listening Practice Test 3', '7', '40 mins', 'published');

-- ── Section 1: Walking Tour Booking ─────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('b2000000-0000-0000-0000-000000000009', 'a2000000-0000-0000-0000-000000000003', 1,
 'Walking Tour Booking Enquiry',
 'Agent: Good afternoon, City Heritage Tours. How can I help?
Customer: Hi, I''d like to book a walking tour for my family for next weekend, please.
Agent: Certainly. Can I have your name?
Customer: Yes, it''s Sarah Mitchell. That''s M-I-T-C-H-E-L-L.
Agent: Thank you. And what date did you want to do the tour?
Customer: Saturday the 14th of July, please.
Agent: We have the Historical City Tour at 10 am, and the Ghost Tour at 8 pm. Which would you prefer?
Customer: Oh, the teenagers would love the Ghost Tour.
Agent: Great. How many people will be joining?
Customer: There will be 4 of us in total. 
Agent: That will be 15 pounds per person. The meeting point for the evening tour is outside the Cathedral, by the main steps.
Customer: Outside the Cathedral, got it. What time should we get there?
Agent: The tour leaves exactly at 8.00 pm, so please arrive 10 minutes early. And I always advise guests to wear comfortable shoes because there are a lot of cobblestone streets.
Customer: Good to know. What happens if it rains?
Agent: The tour goes ahead in all weather, so please bring an umbrella just in case. Finally, can I get a mobile number?
Customer: Yes, it''s 07593 821.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2000000-0000-0000-0000-000000000012', 'b2000000-0000-0000-0000-000000000009', 1,
 'sentence-completion', 'Complete the booking form below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d2000000-0000-0000-0000-000000000081', 'c2000000-0000-0000-0000-000000000012', 1,
 'Customer Name: Sarah ________', 'Mitchell', '["Mitchell","mitchell","MITCHELL"]'::jsonb),
('d2000000-0000-0000-0000-000000000082', 'c2000000-0000-0000-0000-000000000012', 2,
 'Tour Date: 14th ________', 'July', '["July","july"]'::jsonb),
('d2000000-0000-0000-0000-000000000083', 'c2000000-0000-0000-0000-000000000012', 3,
 'Tour Type chosen: ________ Tour', 'Ghost', '["Ghost","ghost"]'::jsonb),
('d2000000-0000-0000-0000-000000000084', 'c2000000-0000-0000-0000-000000000012', 4,
 'Number of people: ________', '4', '["4","four","Four"]'::jsonb),
('d2000000-0000-0000-0000-000000000085', 'c2000000-0000-0000-0000-000000000012', 5,
 'Price per person: ________ pounds', '15', '["15","£15","fifteen"]'::jsonb),
('d2000000-0000-0000-0000-000000000086', 'c2000000-0000-0000-0000-000000000012', 6,
 'Meeting point: outside the ________', 'Cathedral', '["Cathedral","cathedral"]'::jsonb),
('d2000000-0000-0000-0000-000000000087', 'c2000000-0000-0000-0000-000000000012', 7,
 'Departure time: ________', '8.00 pm', '["8.00 pm","8 pm","20:00"]'::jsonb),
('d2000000-0000-0000-0000-000000000088', 'c2000000-0000-0000-0000-000000000012', 8,
 'Advised to wear comfortable ________', 'shoes', '["shoes"]'::jsonb),
('d2000000-0000-0000-0000-000000000089', 'c2000000-0000-0000-0000-000000000012', 9,
 'Advised to bring an ________ in case of rain', 'umbrella', '["umbrella"]'::jsonb),
('d2000000-0000-0000-0000-000000000090', 'c2000000-0000-0000-0000-000000000012', 10,
 'Contact number: ________', '07593 821', '["07593 821","07593821"]'::jsonb);

-- ── Section 2: Festival Volunteering ────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('b2000000-0000-0000-0000-000000000010', 'a2000000-0000-0000-0000-000000000003', 2,
 'Music Festival Volunteer Briefing',
 'Coordinator: Welcome everyone, and thank you for volunteering at the Summer Valley Music Festival! Your shifts will be 4 hours long. Your main duty this year will be checking wristbands at the entrance points; security staff will handle the bag searches. In return for your help, you get free entry to the festival and two meal vouchers per day, which you can use at any vendor. Please note that parking is not free; you''ll have to take the shuttle bus.

Let''s look at the festival map. We are currently in the Volunteer Tent, which is at the very bottom of your map, near the South Gate. The Main Stage is located right in the centre of the field. To the left of the Main Stage, you will find the First Aid tent. To the right of the Main Stage are the Food Stalls. Finally, the Toilets are situated in the top right corner of the map, near the North Exit.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2000000-0000-0000-0000-000000000013', 'b2000000-0000-0000-0000-000000000010', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('d2000000-0000-0000-0000-000000000091', 'c2000000-0000-0000-0000-000000000013', 11,
 'How long is a volunteer shift?',
 '["A. 4 hours", "B. 6 hours", "C. 8 hours"]'::jsonb, 'A'),
('d2000000-0000-0000-0000-000000000092', 'c2000000-0000-0000-0000-000000000013', 12,
 'What is the main duty of the volunteers?',
 '["A. Searching bags", "B. Checking wristbands", "C. Selling tickets"]'::jsonb, 'B'),
('d2000000-0000-0000-0000-000000000093', 'c2000000-0000-0000-0000-000000000013', 13,
 'How many meal vouchers do volunteers get per day?',
 '["A. One", "B. Two", "C. Three"]'::jsonb, 'B'),
('d2000000-0000-0000-0000-000000000094', 'c2000000-0000-0000-0000-000000000013', 14,
 'Where can the meal vouchers be used?',
 '["A. Only at the staff canteen", "B. At specific volunteer stalls", "C. At any food vendor"]'::jsonb, 'C'),
('d2000000-0000-0000-0000-000000000095', 'c2000000-0000-0000-0000-000000000013', 15,
 'How are volunteers expected to travel to the site?',
 '["A. By car using free parking", "B. By walking", "C. By shuttle bus"]'::jsonb, 'C');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('c2000000-0000-0000-0000-000000000014', 'b2000000-0000-0000-0000-000000000010', 2,
 'matching-features', 'Label the map below. Write the correct letter, A–E, next to questions 16–20.', true, true,
 '["A. Main Stage", "B. First Aid", "C. Food Stalls", "D. Toilets", "E. Volunteer Tent"]'::jsonb);

INSERT INTO listening_questions (id, group_id, question_order, text, answer) VALUES
('d2000000-0000-0000-0000-000000000096', 'c2000000-0000-0000-0000-000000000014', 16, 'At the bottom of the map, near South Gate', 'E'),
('d2000000-0000-0000-0000-000000000097', 'c2000000-0000-0000-0000-000000000014', 17, 'Right in the centre of the field', 'A'),
('d2000000-0000-0000-0000-000000000098', 'c2000000-0000-0000-0000-000000000014', 18, 'To the left of the Main Stage', 'B'),
('d2000000-0000-0000-0000-000000000099', 'c2000000-0000-0000-0000-000000000014', 19, 'To the right of the Main Stage', 'C'),
('d2000000-0000-0000-0000-0000000000100', 'c2000000-0000-0000-0000-000000000014', 20, 'Top right corner, near North Exit', 'D');

-- ── Section 3: Student-Tutor Discussion ─────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('b2000000-0000-0000-0000-000000000011', 'a2000000-0000-0000-0000-000000000003', 3,
 'Marketing Presentation Meeting',
 'Tutor: Hello Sam, Anna. Let''s discuss your upcoming marketing presentation. You''ve chosen to present on consumer psychology and the ''decoy effect'', right?
Anna: Yes, we found it fascinating how pricing a third, inferior option changes buying habits. 
Tutor: It''s a strong topic. Your presentation needs to be 15 minutes long. How are you splitting the work?
Sam: I''m going to research the historical case studies of the decoy effect. Anna is brilliant at design, so she will create the presentation slides.
Anna: And I thought we should both work on the final script so it flows naturally.
Tutor: Good plan. Don''t forget to prepare a handout for the audience.
Sam: Oh, I''ll handle formatting and printing the handout.
Anna: And I''ll write the conclusion to wrap everything up.
Tutor: Excellent. Please send me a draft by Tuesday.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2000000-0000-0000-0000-000000000015', 'b2000000-0000-0000-0000-000000000011', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('d2000000-0000-0000-0000-0000000000101', 'c2000000-0000-0000-0000-000000000015', 21,
 'What topic did the students choose for their presentation?',
 '["A. Social media marketing", "B. The decoy effect", "C. Brand loyalty"]'::jsonb, 'B'),
('d2000000-0000-0000-0000-0000000000102', 'c2000000-0000-0000-0000-000000000015', 22,
 'The decoy effect involves introducing a third option that is:',
 '["A. Superior", "B. Cheaper", "C. Inferior"]'::jsonb, 'C'),
('d2000000-0000-0000-0000-0000000000103', 'c2000000-0000-0000-0000-000000000015', 23,
 'How long must the presentation be?',
 '["A. 10 minutes", "B. 15 minutes", "C. 20 minutes"]'::jsonb, 'B'),
('d2000000-0000-0000-0000-0000000000104', 'c2000000-0000-0000-0000-000000000015', 24,
 'What did the tutor remind them to prepare?',
 '["A. A video clip", "B. A handout", "C. A questionnaire"]'::jsonb, 'B'),
('d2000000-0000-0000-0000-0000000000105', 'c2000000-0000-0000-0000-000000000015', 25,
 'When does the tutor want to see a draft?',
 '["A. Monday", "B. Tuesday", "C. Friday"]'::jsonb, 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('c2000000-0000-0000-0000-000000000016', 'b2000000-0000-0000-0000-000000000011', 2,
 'matching-features', 'Who will be responsible for the following tasks? Match the tasks (26-30) to the person (A-C).', true, true,
 '["A. Sam", "B. Anna", "C. Both Sam and Anna"]'::jsonb);

INSERT INTO listening_questions (id, group_id, question_order, text, answer) VALUES
('d2000000-0000-0000-0000-0000000000106', 'c2000000-0000-0000-0000-000000000016', 26, 'Researching case studies', 'A'),
('d2000000-0000-0000-0000-0000000000107', 'c2000000-0000-0000-0000-000000000016', 27, 'Creating presentation slides', 'B'),
('d2000000-0000-0000-0000-0000000000108', 'c2000000-0000-0000-0000-000000000016', 28, 'Writing the final script', 'C'),
('d2000000-0000-0000-0000-0000000000109', 'c2000000-0000-0000-0000-000000000016', 29, 'Printing the handout', 'A'),
('d2000000-0000-0000-0000-0000000000110', 'c2000000-0000-0000-0000-000000000016', 30, 'Writing the conclusion', 'B');

-- ── Section 4: Antarctic Exploration ────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('b2000000-0000-0000-0000-000000000012', 'a2000000-0000-0000-0000-000000000003', 4,
 'Lecture: History of Antarctic Exploration',
 'Professor: Let''s move to the Heroic Age of Antarctic Exploration, which spanned roughly from the late 19th century to 1922. It was a period of extreme physical endurance. The primary goal for many was reaching the Geographic South Pole. 

In 1911, two rival expeditions raced to the Pole. The Norwegian team was led by Roald Amundsen. He made the crucial decision to use sled dogs for transport, which were perfectly adapted to the cold. Amundsen successfully reached the Pole on December 14th, 1911.

His British rival, Robert Falcon Scott, arrived a month later. Tragically, Scott had chosen to rely on motorised sledges and ponies, which broke down and died in the extreme cold, forcing his men to pull the sledges themselves. Scott and his entire team died on the return journey due to starvation and extreme cold.

Today, Antarctica is protected by the Antarctic Treaty of 1959. It designates the continent as a scientific preserve, bans military activity, and currently holds the world''s largest reserves of freshwater in its ice sheet.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2000000-0000-0000-0000-000000000017', 'b2000000-0000-0000-0000-000000000012', 1,
 'sentence-completion', 'Complete the notes below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d2000000-0000-0000-0000-0000000000111', 'c2000000-0000-0000-0000-000000000017', 31,
 'The Heroic Age ended roughly in the year ________.', '1922', '["1922"]'::jsonb),
('d2000000-0000-0000-0000-0000000000112', 'c2000000-0000-0000-0000-000000000017', 32,
 'The primary goal was reaching the Geographic ________.', 'South Pole', '["South Pole","south pole"]'::jsonb),
('d2000000-0000-0000-0000-0000000000113', 'c2000000-0000-0000-0000-000000000017', 33,
 'Roald Amundsen led the team from ________.', 'Norway', '["Norway","norway"]'::jsonb),
('d2000000-0000-0000-0000-0000000000114', 'c2000000-0000-0000-0000-000000000017', 34,
 'Amundsen successfully used ________ for transport.', 'sled dogs', '["sled dogs","dogs"]'::jsonb),
('d2000000-0000-0000-0000-0000000000115', 'c2000000-0000-0000-0000-000000000017', 35,
 'Robert Falcon Scott''s team relied on ponies and ________ sledges.', 'motorised', '["motorised","motorized"]'::jsonb),
('d2000000-0000-0000-0000-0000000000116', 'c2000000-0000-0000-0000-000000000017', 36,
 'Scott''s men had to pull the sledges themselves when the animals died from the ________.', 'extreme cold', '["extreme cold","cold"]'::jsonb),
('d2000000-0000-0000-0000-0000000000117', 'c2000000-0000-0000-0000-000000000017', 37,
 'Scott''s team ultimately died of extreme cold and ________.', 'starvation', '["starvation"]'::jsonb),
('d2000000-0000-0000-0000-0000000000118', 'c2000000-0000-0000-0000-000000000017', 38,
 'The Antarctic Treaty was signed in ________.', '1959', '["1959"]'::jsonb),
('d2000000-0000-0000-0000-0000000000119', 'c2000000-0000-0000-0000-000000000017', 39,
 'The treaty bans any ________ activity on the continent.', 'military', '["military"]'::jsonb),
('d2000000-0000-0000-0000-0000000000120', 'c2000000-0000-0000-0000-000000000017', 40,
 'Antarctica holds the world''s largest reserves of ________.', 'freshwater', '["freshwater","fresh water"]'::jsonb);


-- ████████████████████████████████████████████████████████████
-- ██  3. WRITING TEST 3                                     ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('a3000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001',
 'IELTS Academic Writing Practice Test 3', 'published');

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('d3000000-0000-0000-0000-000000000005', 'a3000000-0000-0000-0000-000000000003', 1,
 'task1', 'Writing Task 1', '7', '20 mins',
 'The line graph below shows the consumption of three different types of fast food (Pizza, Fish and Chips, and Hamburgers) in the UK between 1970 and 1990. 

Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
 150, '', ''),
('d3000000-0000-0000-0000-000000000006', 'a3000000-0000-0000-0000-000000000003', 2,
 'task2', 'Writing Task 2', '7', '40 mins',
 'The rise of convenience foods and fast-food restaurants has helped people keep up with the speed of the modern lifestyle. 

What are the advantages and disadvantages of this trend?
Give reasons for your answer and include any relevant examples from your own knowledge or experience.',
 250, '', '');

-- ════════════════════════════════════════════════════════════
-- End of IELTS Practice Test 3 Seed
-- ════════════════════════════════════════════════════════════
