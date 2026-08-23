-- ============================================================
-- IELTS Practice Platform – Extended Seed Data
-- Target: Reading Module (Academic, Band 6 Difficulty)
-- Action: APPEND (No TRUNCATE)
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST ENTRY (Academic - Band 6)                           ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('f68bce16-3330-4c03-8cae-6bac17ae825d', '805cda42-4ea9-4b91-b728-4d085d90c2f3',
 'IELTS Academic Reading: Innovation, Agriculture & Psychology (Band 6)', 'Academic', '6', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: The Evolution of the Bicycle (Q1–13)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('6fad0a25-db22-438a-874d-8d4e3ff59271', 'f68bce16-3330-4c03-8cae-6bac17ae825d', 1,
 'The Evolution of the Bicycle',
 '(A) The bicycle is one of the most ubiquitous and enduring forms of personal transport in the world. Today, there are over a billion bicycles in use globally, providing a cheap, environmentally friendly, and healthy means of getting around. However, the modern bicycle did not appear overnight. It is the result of a long process of evolution, characterized by a series of mechanical improvements over more than two centuries. The earliest incarnations of the bicycle looked very different from the sleek, multi-geared machines we are familiar with today.

(B) The first verifiable claim for a practically used bicycle belongs to a German baron named Karl Drais. In 1817, Drais introduced a two-wheeled, human-powered vehicle that he called the "Laufmaschine", which translates from German as the running machine. This early device consisted of a wooden frame and two wooden wheels, but it had no pedals. The rider sat on a saddle and propelled the machine forward by pushing their feet against the ground, much like a modern toddler’s balance bike. While it enjoyed a brief period of popularity among wealthy young men in Europe, it was largely seen as a novelty and was difficult to ride on the rough, unpaved roads of the era.

(C) The next major developmental leap occurred in France during the early 1860s. Inventors Pierre Michaux and Pierre Lallement are widely credited with attaching pedals and rotary cranks to the front wheel of a two-wheeled machine. This invention allowed the rider to propel the vehicle continuously without their feet touching the ground. Known as the "velocipede," it became extremely popular. However, because it was constructed with a stiff iron frame and wooden wheels surrounded by iron tires, the ride was incredibly bumpy. This uncomfortable experience earned the velocipede the popular nickname of the "boneshaker."

(D) In the 1870s, the desire for greater speed led to the development of the high-wheel bicycle, famously known in Britain as the Penny Farthing. To increase the distance covered with a single rotation of the pedals, manufacturers drastically increased the size of the front wheel, sometimes up to 1.5 meters in diameter. The small rear wheel provided balance. While the Penny Farthing was undeniably faster than the boneshaker, it was also highly dangerous. The rider sat high above the ground, and because the center of gravity was positioned so far forward, any sudden stop—such as hitting a rock or a rut in the road—would send the rider flying forward over the handlebars.

(E) The inherent dangers of the Penny Farthing limited its appeal to athletic, risk-taking young men. The bicycle truly became a vehicle for the masses in 1885, when English inventor John Kemp Starley introduced the Rover Safety Bicycle. This revolutionary design featured two wheels of equal size, a steerable front fork, and a chain drive that transferred power from the pedals to the rear wheel. This allowed the rider to sit lower to the ground, dramatically improving stability and safety. The Safety Bicycle was a massive commercial success and opened up cycling to a much broader demographic, including women, for whom it offered a new sense of independence and mobility.

(F) While the Safety Bicycle established the basic geometry still used today, one final crucial invention was needed to ensure a comfortable ride. In 1888, a Scottish veterinarian named John Boyd Dunlop invented the pneumatic rubber tyre. Originally designed to make his son’s tricycle more comfortable to ride on cobbled streets, Dunlop’s air-filled tyres absorbed bumps and shocks far better than solid iron or solid rubber. By the 1890s, the combination of the safety frame and the pneumatic tyre triggered a worldwide bicycle craze. Today, while frame materials have evolved from steel to lightweight aluminum and carbon fibre, the fundamental mechanics of the bicycle remain remarkably unchanged from Starley’s original vision.');

-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('d345b1b4-78df-40b1-90ad-2cd6ed407f91', '6fad0a25-db22-438a-874d-8d4e3ff59271', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the passage? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('c54d3d52-8e2d-4936-9e6c-31ce89292049', 'd345b1b4-78df-40b1-90ad-2cd6ed407f91', 1,
 'Karl Drais''s invention featured pedals attached to the front wheel.', 'FALSE', '["FALSE","False","false"]'),
('e3999a7b-67d9-410b-99a3-effe884bd9ff', 'd345b1b4-78df-40b1-90ad-2cd6ed407f91', 2,
 'The velocipede was popular among women in the 1860s.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('d2046be6-81e0-43a5-b3cf-d379aea3fb78', 'd345b1b4-78df-40b1-90ad-2cd6ed407f91', 3,
 'The Penny Farthing was faster than the velocipede but posed a greater risk of accidents.', 'TRUE', '["TRUE","True","true"]'),
('f4a22110-aab2-46ae-8209-821455b39097', 'd345b1b4-78df-40b1-90ad-2cd6ed407f91', 4,
 'John Kemp Starley''s bicycle design used a chain drive connected to the front wheel.', 'FALSE', '["FALSE","False","false"]');

-- ── Group 2: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('fc28035d-a115-46c6-ba6d-ec1b681c4697', '6fad0a25-db22-438a-874d-8d4e3ff59271', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('d935f936-4d49-48b5-b877-34bbaff04894', 'fc28035d-a115-46c6-ba6d-ec1b681c4697', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"Era","answer":""},{"id":"h2","gapText":"Innovation","answer":""},{"id":"h3","gapText":"Significance / Detail","answer":""}]'),
('d56f6784-32af-47c9-88bb-49ce99331871', 'fc28035d-a115-46c6-ba6d-ec1b681c4697', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"1817","answer":""},{"id":"c2","gapText":"Karl Drais invents the {{gap}}","answer":"running machine"},{"id":"c3","gapText":"Riders pushed their feet against the ground.","answer":""}]'),
('bf9db30f-1a2d-4acf-8cc8-9ded4e34b305', 'fc28035d-a115-46c6-ba6d-ec1b681c4697', 7,
 'Row 3', '',
 '[{"id":"c4","gapText":"1860s","answer":""},{"id":"c5","gapText":"Addition of {{gap}}","answer":"pedals"},{"id":"c6","gapText":"Allowed for continuous propulsion without touching the ground.","answer":""}]'),
('e8940f84-5d36-4ca5-b34f-b6535f896075', 'fc28035d-a115-46c6-ba6d-ec1b681c4697', 8,
 'Row 4', '',
 '[{"id":"c7","gapText":"1885","answer":""},{"id":"c8","gapText":"Introduction of the {{gap}}","answer":"Safety Bicycle"},{"id":"c9","gapText":"Featured equal-sized wheels and improved stability.","answer":""}]'),
('d51441fb-bfc0-405a-b26a-e7aaca652dc4', 'fc28035d-a115-46c6-ba6d-ec1b681c4697', 9,
 'Row 5', '',
 '[{"id":"c10","gapText":"1888","answer":""},{"id":"c11","gapText":"Invention of the pneumatic {{gap}}","answer":"rubber tyre"},{"id":"c12","gapText":"Absorbed shocks and made riding much more comfortable.","answer":""}]');

-- ── Group 3: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('df39ff26-8894-496c-b10f-420dcc67362e', '6fad0a25-db22-438a-874d-8d4e3ff59271', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('869fa764-b8f1-41a3-9aff-ff5c270d3efd', 'df39ff26-8894-496c-b10f-420dcc67362e', 10,
 'What popular nickname was given to the velocipede because of its stiff ride?', 'boneshaker', '[{"id":"1","text":"boneshaker"},{"id":"2","text":"the boneshaker"}]'),
('4476c4a0-3b69-4339-812a-45f487592a81', 'df39ff26-8894-496c-b10f-420dcc67362e', 11,
 'What was positioned far forward on the Penny Farthing, making it dangerous?', 'center of gravity', '[{"id":"1","text":"center of gravity"}]'),
('7494856e-f2d5-4c44-970e-dbb7ffa902b3', 'df39ff26-8894-496c-b10f-420dcc67362e', 12,
 'Who originally inspired John Boyd Dunlop to invent a better tyre?', 'his son', '[{"id":"1","text":"his son"},{"id":"2","text":"son"}]'),
('b12e9bdc-6243-4ea8-9bce-884565cdd9f2', 'df39ff26-8894-496c-b10f-420dcc67362e', 13,
 'Apart from aluminum, what lightweight material is used to construct modern bicycle frames?', 'carbon fibre', '[{"id":"1","text":"carbon fibre"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: The Rise of Vertical Farming (Q14–27)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('89eecbe5-68ac-4520-bae7-a2ae6c22abb4', 'f68bce16-3330-4c03-8cae-6bac17ae825d', 2,
 'The Rise of Vertical Farming',
 '(A) By the year 2050, the global human population is projected to reach roughly 9.7 billion. To feed this rapidly expanding population, agricultural experts estimate that worldwide food production must increase by up to 70%. Traditional agriculture is struggling to meet this demand, largely because most of the arable land on the planet is already in use. Furthermore, traditional farming is highly vulnerable to unpredictable weather patterns, droughts, and pests, all of which are being exacerbated by climate change. In response to these pressing challenges, scientists and entrepreneurs are looking upwards, advocating for a revolutionary agricultural method: vertical farming.

(B) Vertical farming is the practice of growing crops in vertically stacked layers, often integrated into other structures like skyscrapers, shipping containers, or repurposed warehouses. Unlike traditional horizontal farming, which relies on vast expanses of outdoor land and natural sunlight, vertical farms operate entirely indoors. These facilities utilize Controlled Environment Agriculture (CEA) technology, which allows farmers to artificially manage temperature, humidity, lighting, and nutrient distribution. This means crops can be grown 365 days a year, regardless of the season or external weather conditions.

(C) The environmental benefits of vertical farming are substantial. Perhaps the most significant advantage is water conservation. Through closed-loop hydroponic or aeroponic systems, vertical farms can use up to 95% less water than conventional outdoor farms. Water that transpires from the plants is captured, condensed, and recycled back into the system. Additionally, because the crops are grown in a secure, sealed indoor environment, there is virtually no need for chemical pesticides or herbicides. This eliminates agricultural runoff, a major source of pollution in global waterways, and produces cleaner, safer food.

(D) Despite its promise, vertical farming is not without its critics and significant operational barriers. The most glaring challenge is the financial cost. Purchasing urban real estate and installing complex climate control systems requires massive initial capital investment. Moreover, the ongoing operational costs are exceptionally high. Because vertical farms do not use natural sunlight, they must rely entirely on artificial lighting to drive photosynthesis. Providing enough light for thousands of plants across multiple stacked layers consumes a tremendous amount of electricity, which can make the food produced much more expensive than conventionally farmed crops.

(E) However, recent technological breakthroughs have begun to improve the economic viability of vertical farms. The most critical advancement has been the rapid development of Light Emitting Diode (LED) technology. Older artificial lights, such as high-pressure sodium bulbs, were inefficient and produced too much heat, requiring extra air conditioning. Modern LED lights are highly energy-efficient and run cool. More importantly, LEDs can be customized to emit specific wavelengths of light—primarily red and blue—that plants absorb most efficiently for photosynthesis, entirely omitting the green spectrum that plants reflect. This targeted lighting significantly reduces energy waste and accelerates plant growth.

(F) Looking to the future, proponents of vertical farming envision a world where every major city has its own network of indoor farms. This would drastically reduce the "food miles"—the distance food travels from farm to plate—cutting down on transportation emissions and ensuring urban populations have access to fresh, locally grown produce within hours of harvesting. While vertical farming is unlikely to entirely replace traditional agriculture, especially for staple crops like wheat or corn which require too much space, it offers a highly efficient, sustainable supplement for cultivating leafy greens, herbs, and fast-growing vegetables in the heart of our urban centers.');

-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('2976b2ca-f266-4f81-a952-7dafd66a964c', '89eecbe5-68ac-4520-bae7-a2ae6c22abb4', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. A crucial technological breakthrough","ii. The growing demand for food","iii. Why staple crops cannot be grown indoors","iv. Positive effects on the environment","v. Financial and operational barriers","vi. What is vertical farming?","vii. The farms of tomorrow","viii. The history of indoor agriculture"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('0bc7067f-cbdd-4069-bfe0-3885e899be07', '2976b2ca-f266-4f81-a952-7dafd66a964c', 14, 'Paragraph A', 'ii'),
('98eb9c32-5c5f-4d0e-9c7d-39ad87169819', '2976b2ca-f266-4f81-a952-7dafd66a964c', 15, 'Paragraph B', 'vi'),
('8b82c31b-01d1-43b2-a544-4bff3a4c4131', '2976b2ca-f266-4f81-a952-7dafd66a964c', 16, 'Paragraph C', 'iv'),
('bb0093f8-9c0e-4db7-b0a4-de2a95daaf8b', '2976b2ca-f266-4f81-a952-7dafd66a964c', 17, 'Paragraph D', 'v'),
('67d53af4-3e29-448a-9a07-cd6f2db3a672', '2976b2ca-f266-4f81-a952-7dafd66a964c', 18, 'Paragraph E', 'i'),
('089153f8-82f5-4edd-afc4-038f9a9e0058', '2976b2ca-f266-4f81-a952-7dafd66a964c', 19, 'Paragraph F', 'vii');

-- ── Group 5: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('6b49cada-0d98-426a-b8f5-fab7910a09ab', '89eecbe5-68ac-4520-bae7-a2ae6c22abb4', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('456ffd71-9e2b-4068-a965-c00637febee8', '6b49cada-0d98-426a-b8f5-fab7910a09ab', 20,
 'A reference to the exact percentage of water that can be saved compared to traditional farming.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('d6e6fd73-08c1-471c-9d9c-e9e071d96023', '6b49cada-0d98-426a-b8f5-fab7910a09ab', 21,
 'An explanation of how specific light wavelengths are selected to accelerate plant growth.', 'E',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('4422e268-1215-4e1e-bfdf-26f2148911be', '6b49cada-0d98-426a-b8f5-fab7910a09ab', 22,
 'The primary reason why traditional agriculture is failing to meet future demands.', 'A',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('36cf16ea-5db5-4eca-a773-48ba7c5aae15', '6b49cada-0d98-426a-b8f5-fab7910a09ab', 23,
 'An explanation of the term ''food miles'' and how indoor farming addresses it.', 'F',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');

-- ── Group 6: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('bd426ad1-7353-4042-a1b0-9ce255f592e6', '89eecbe5-68ac-4520-bae7-a2ae6c22abb4', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('ba3fa13e-f71a-4eff-afc8-a864685554f6', 'bd426ad1-7353-4042-a1b0-9ce255f592e6', 24,
 'Vertical farming is fundamentally different from traditional farming because it:',
 'B',
 '[{"id":"A","text":"A. Only grows crops during the summer months.","isCorrect":false},{"id":"B","text":"B. Grows plants in stacked layers inside climate-controlled structures.","isCorrect":true},{"id":"C","text":"C. Relies heavily on natural sunlight and rainwater.","isCorrect":false},{"id":"D","text":"D. Focuses entirely on staple crops like wheat and corn.","isCorrect":false}]'),
('c0fca811-f3e7-4338-b2e5-389cfe3207a1', 'bd426ad1-7353-4042-a1b0-9ce255f592e6', 25,
 'According to Paragraph C, how does vertical farming prevent the pollution of global waterways?',
 'C',
 '[{"id":"A","text":"A. By filtering the rainwater before it leaves the building.","isCorrect":false},{"id":"B","text":"B. By only growing crops that naturally repel pests.","isCorrect":false},{"id":"C","text":"C. By operating in a sealed environment that requires no chemical pesticides.","isCorrect":true},{"id":"D","text":"D. By using soil that naturally absorbs agricultural runoff.","isCorrect":false}]'),
('861900a7-70aa-4c3c-b740-09084d905129', 'bd426ad1-7353-4042-a1b0-9ce255f592e6', 26,
 'The writer identifies the most significant challenge to vertical farming as:',
 'A',
 '[{"id":"A","text":"A. The immense cost of real estate and electrical power for lighting.","isCorrect":true},{"id":"B","text":"B. A lack of consumer interest in indoor-grown vegetables.","isCorrect":false},{"id":"C","text":"C. The difficulty of finding experienced indoor farmers.","isCorrect":false},{"id":"D","text":"D. The excessive heat produced by modern LED lighting.","isCorrect":false}]'),
('a2d916ea-88f2-4506-bd5f-93a2f8201f67', 'bd426ad1-7353-4042-a1b0-9ce255f592e6', 27,
 'LED lights are particularly advantageous for vertical farming because they:',
 'D',
 '[{"id":"A","text":"A. Are extremely cheap to purchase compared to older bulbs.","isCorrect":false},{"id":"B","text":"B. Produce the necessary heat to keep the indoor farms warm.","isCorrect":false},{"id":"C","text":"C. Emit a green light that plants easily reflect.","isCorrect":false},{"id":"D","text":"D. Can be programmed to emit only the specific light wavelengths plants need.","isCorrect":true}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: The Psychology of Choice (Q28–40)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b5df61d5-99f0-4120-9284-e085f183f983', 'f68bce16-3330-4c03-8cae-6bac17ae825d', 3,
 'The Psychology of Choice',
 '(A) In modern society, freedom and autonomy are universally highly prized. Logically, we assume that maximizing freedom means maximizing choice. If one brand of toothpaste is good, surely fifty brands are better. However, a growing body of psychological research suggests the opposite: an overabundance of choices can actually lead to anxiety, indecision, and dissatisfaction. This phenomenon, popularized by psychologist Barry Schwartz in the early 2000s, is known as the "paradox of choice." Schwartz argued that while a certain amount of choice is essential for well-being, surpassing a specific threshold transforms choice from a liberating force into a paralyzing one.

(B) To understand how individuals handle the burden of choice, Schwartz divided consumers into two broad psychological categories: "maximizers" and "satisficers." Maximizers are individuals who feel compelled to make the absolute best possible choice in any given situation. If a maximizer is buying a television, they will spend weeks reading reviews, comparing specifications, and visiting multiple stores to ensure their decision is flawless. Satisficers, on the other hand, establish a set of criteria and choose the first option that meets those standards. Once they find a "good enough" television, they buy it and stop looking. Research consistently shows that while maximizers may objectively make slightly better purchases, satisficers are fundamentally much happier with their outcomes, as they do not suffer from the agonizing regret of "what if" that plagues maximizers.

(C) Another crucial factor in understanding how we make choices is the concept of "decision fatigue." The human brain, despite representing only 2% of the body’s weight, consumes 20% of its energy. Making decisions requires significant cognitive effort, drawing upon a limited daily reserve of willpower. As the day progresses and a person makes hundreds of minor choices—what to wear, what to eat, how to reply to an email—this cognitive reserve is depleted. By the evening, decision fatigue sets in. In this state, people are far more likely to make impulsive, irrational choices, or simply avoid making a decision altogether, opting for the path of least resistance. 

(D) To cope with the overwhelming number of choices and the threat of decision fatigue, the brain frequently relies on "heuristics"—mental shortcuts that allow us to make quick, energy-efficient judgments without analyzing every detail. One common heuristic is the "anchoring effect," where an individual relies too heavily on the first piece of information they receive. For example, if a car salesman initially suggests a price of $20,000, a final price of $18,000 feels like a massive bargain, even if the car’s true value is only $15,000. The brain anchored onto the initial high number, skewing the perception of value.

(E) Corporations and marketers are acutely aware of these psychological mechanisms and frequently manipulate them to influence consumer behavior. One of the most powerful tools in behavioral economics is the use of the "default option." Because humans are prone to decision fatigue and inherently biased toward the status quo, they will rarely opt out of a pre-selected choice. For instance, countries where organ donation is the default option (an "opt-out" system) routinely see participation rates above 90%, whereas countries requiring citizens to actively register (an "opt-in" system) struggle to reach 30%. Marketers use this exact principle to auto-renew subscriptions or pre-select expensive shipping options, knowing most consumers will not expend the cognitive effort to change it.

(F) Ultimately, understanding the psychology of choice provides us with practical tools for improving our mental health. Psychologists advise that individuals can increase their daily happiness by consciously limiting their options. This can be achieved by deliberately adopting a satisficing mindset for low-stakes decisions, delegating choices to others, or creating strict routines that eliminate morning decisions entirely. By removing the friction of constant, trivial choices, we preserve our cognitive energy for the decisions that truly matter.');

-- ── Group 7: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('156be994-8a89-4d5c-bea9-a68b2486511b', 'b5df61d5-99f0-4120-9284-e085f183f983', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('0899b952-6942-4b6f-aab2-31f314f9fcdf', '156be994-8a89-4d5c-bea9-a68b2486511b', 28,
 'Barry Schwartz argued that having zero choices is the best way to achieve happiness.', 'NO', '["NO","No","no"]'),
('ad060e93-0d6f-4880-9dcd-9799bffee4a8', '156be994-8a89-4d5c-bea9-a68b2486511b', 29,
 'Maximizers generally feel more satisfied with their purchases than satisficers do.', 'NO', '["NO","No","no"]'),
('88c6dcfe-9402-425c-abc3-ece3a7b166b3', '156be994-8a89-4d5c-bea9-a68b2486511b', 30,
 'Supermarkets use the anchoring effect by placing expensive items at the front of the store.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('733dbc34-7b23-4f3b-b946-62a462d8dd7e', '156be994-8a89-4d5c-bea9-a68b2486511b', 31,
 'Decision fatigue makes people more prone to making impulsive choices late in the day.', 'YES', '["YES","Yes","yes"]');

-- ── Group 8: MATCHING SENTENCE ENDINGS (Q32–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('0e42de8b-db19-41a3-9748-f8eae9eee27c', 'b5df61d5-99f0-4120-9284-e085f183f983', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('4955700e-cf04-4c08-8dc9-59e9dfaa0195', '0e42de8b-db19-41a3-9748-f8eae9eee27c', 32,
 'The phenomenon known as the ''paradox of choice'' suggests that having too many options',
 'B',
 '[{"id":"A","text":"constantly search for the absolute perfect outcome.","isCorrect":false},{"id":"B","text":"can lead to feelings of anxiety and paralysis.","isCorrect":true},{"id":"C","text":"allow the brain to make fast, energy-efficient judgments.","isCorrect":false},{"id":"D","text":"influence consumer behavior without actively forcing them.","isCorrect":false},{"id":"E","text":"are completely immune to decision fatigue.","isCorrect":false},{"id":"F","text":"stop searching once they find a product that is good enough.","isCorrect":false}]'),
('08d69cde-1d80-45f0-ac54-50aabc434f53', '0e42de8b-db19-41a3-9748-f8eae9eee27c', 33,
 'Consumers categorized as ''satisficers'' will usually',
 'F',
 '[{"id":"A","text":"constantly search for the absolute perfect outcome.","isCorrect":false},{"id":"B","text":"can lead to feelings of anxiety and paralysis.","isCorrect":false},{"id":"C","text":"allow the brain to make fast, energy-efficient judgments.","isCorrect":false},{"id":"D","text":"influence consumer behavior without actively forcing them.","isCorrect":false},{"id":"E","text":"are completely immune to decision fatigue.","isCorrect":false},{"id":"F","text":"stop searching once they find a product that is good enough.","isCorrect":true}]'),
('47cbce76-89c9-40de-a96e-bf0e3594e440', '0e42de8b-db19-41a3-9748-f8eae9eee27c', 34,
 'Cognitive shortcuts, also known as ''heuristics'', are useful because they',
 'C',
 '[{"id":"A","text":"constantly search for the absolute perfect outcome.","isCorrect":false},{"id":"B","text":"can lead to feelings of anxiety and paralysis.","isCorrect":false},{"id":"C","text":"allow the brain to make fast, energy-efficient judgments.","isCorrect":true},{"id":"D","text":"influence consumer behavior without actively forcing them.","isCorrect":false},{"id":"E","text":"are completely immune to decision fatigue.","isCorrect":false},{"id":"F","text":"stop searching once they find a product that is good enough.","isCorrect":false}]'),
('942730e2-bece-4597-89c2-44a78613194d', '0e42de8b-db19-41a3-9748-f8eae9eee27c', 35,
 'Marketers heavily utilize the ''default option'' strategy in order to',
 'D',
 '[{"id":"A","text":"constantly search for the absolute perfect outcome.","isCorrect":false},{"id":"B","text":"can lead to feelings of anxiety and paralysis.","isCorrect":false},{"id":"C","text":"allow the brain to make fast, energy-efficient judgments.","isCorrect":false},{"id":"D","text":"influence consumer behavior without actively forcing them.","isCorrect":true},{"id":"E","text":"are completely immune to decision fatigue.","isCorrect":false},{"id":"F","text":"stop searching once they find a product that is good enough.","isCorrect":false}]');

-- ── Group 9: SUMMARY COMPLETION with Word Bank (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('0a3332c5-8b40-45cd-87c5-92d27b9a2a82', 'b5df61d5-99f0-4120-9284-e085f183f983', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["fatigue", "routines", "willpower", "anchoring", "heuristics", "happiness", "delegating", "options", " regret"]');

-- For SUMMARY_COMPLETION: first question text = summary template, subsequent ones are empty text.
INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('9530365e-de0d-4bf5-af85-135fdee74715', '0a3332c5-8b40-45cd-87c5-92d27b9a2a82', 36,
 'As the day progresses, the cognitive energy required to make constant choices is drained, a condition psychologists call decision {{gap_0a3332c5-8b40-45cd-87c5-92d27b9a2a82_0}}. This loss of {{gap_0a3332c5-8b40-45cd-87c5-92d27b9a2a82_1}} makes individuals prone to poor decision-making. To conserve mental energy, the brain relies on cognitive shortcuts known as {{gap_0a3332c5-8b40-45cd-87c5-92d27b9a2a82_2}}. One famous example is the {{gap_0a3332c5-8b40-45cd-87c5-92d27b9a2a82_3}} effect, where people rely too much on the very first piece of information they are given. By understanding these concepts and intentionally establishing strict daily {{gap_0a3332c5-8b40-45cd-87c5-92d27b9a2a82_4}} to minimize trivial choices, individuals can improve their psychological well-being.',
 'fatigue'),
('6bf60488-60c3-49ec-af3d-b2639b830835', '0a3332c5-8b40-45cd-87c5-92d27b9a2a82', 37,
 '', 'willpower'),
('bec04e14-89be-4599-b517-93f658740b98', '0a3332c5-8b40-45cd-87c5-92d27b9a2a82', 38,
 '', 'heuristics'),
('a83871bb-c739-4b84-af75-24cde4f41caf', '0a3332c5-8b40-45cd-87c5-92d27b9a2a82', 39,
 '', 'anchoring'),
('41ac1351-f95f-4ef6-9325-9ba176a5a450', '0a3332c5-8b40-45cd-87c5-92d27b9a2a82', 40,
 '', 'routines');

-- ============================================================
-- NOTE: Please execute `UPDATE reading_tests SET created_by = '<your-uid>'` 
-- if required by your application's Row Level Security policies.
-- ============================================================