-- ============================================================
-- IELTS Practice Platform – Comprehensive Seed Data (Test 2)
-- Appends to: 01_ielts_practice_test_1.sql
-- ============================================================
-- NOTE: `created_by` uses a placeholder UUID. After seeding,
-- update it to a real user's auth.uid() so RLS allows access:
--   UPDATE reading_tests  SET created_by = '<your-uid>' WHERE id = 'a1000000-0000-0000-0000-000000000002';
--   UPDATE listening_tests SET created_by = '<your-uid>' WHERE id = 'a2000000-0000-0000-0000-000000000002';
--   UPDATE writing_tests  SET created_by = '<your-uid>' WHERE id = 'a3000000-0000-0000-0000-000000000002';
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  1. READING TEST 2 – ALL QUESTION TYPES (40 questions)    ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('a1000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001',
 'IELTS Academic Reading Practice Test 2', 'Academic', '7', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: The History of Tea (Q1–13)                  ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b1100000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000002', 1,
 'The History of Tea: From Medicine to Global Beverage',
 '(A) According to Chinese legend, the history of tea began in 2737 BCE when the Emperor Shennong, a skilled ruler and scientist, accidentally discovered the beverage. While he was boiling water in the garden, a leaf from an overhanging wild tea tree drifted into his pot. The Emperor enjoyed the refreshing concoction, and thus, tea was born. While this is a myth, archaeological evidence suggests that tea was indeed first cultivated in China, initially consumed not as a recreational drink, but as a medicinal tonic.

(B) During the Tang Dynasty (618–907 CE), tea drinking evolved from a medical remedy into a cultural phenomenon. The writer Lu Yu authored "The Classic of Tea," the definitive guide detailing the methods of cultivating, preparing, and drinking tea. It was during this period that Japanese Buddhist monks travelling in China encountered the beverage and brought tea seeds back to Japan, where it eventually became deeply integrated into Japanese culture through the elaborate tea ceremony.

(C) Tea did not reach Europe until the early 17th century. The Dutch East India Company successfully imported the first major shipment of tea to Amsterdam in 1606. It quickly became a fashionable, albeit highly expensive, drink among the wealthy classes of the Netherlands, and later, Portugal. When the Portuguese princess Catherine of Braganza married England''s King Charles II in 1662, she brought her love of tea to the English court, single-handedly establishing tea as a staple of British high society.

(D) As demand in Britain soared, the British East India Company began establishing a monopoly on tea imports from China. To counter the massive trade deficit caused by purchasing tea with silver, the British began illegally exporting opium to China. This unethical trade practice culminated in the First Opium War (1839-1842). Following the war, Britain sought to break the Chinese monopoly on tea production by secretly sending botanist Robert Fortune to smuggle tea plants and experienced growers out of China to establish plantations in the British colony of India. 

(E) The Indian experiments were wildly successful, particularly in regions like Assam and Darjeeling. By the late 19th century, Indian tea had surpassed Chinese tea in British consumption. Today, tea is the second most consumed beverage in the world, surpassed only by water. Modern production has expanded globally, with nations like Kenya and Sri Lanka becoming top exporters, driving a multi-billion-dollar global industry.');

-- ── Group 14: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1100000-0000-0000-0000-000000000014', 'b1100000-0000-0000-0000-000000000004', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the passage? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d1100000-0000-0000-0000-000000000041', 'c1100000-0000-0000-0000-000000000014', 1,
 'Archaeological evidence proves that Emperor Shennong discovered tea in 2737 BCE.', 'FALSE', '["FALSE","False","false"]'::jsonb),
('d1100000-0000-0000-0000-000000000042', 'c1100000-0000-0000-0000-000000000014', 2,
 'Tea was originally consumed in China for health purposes.', 'TRUE', '["TRUE","True","true"]'::jsonb),
('d1100000-0000-0000-0000-000000000043', 'c1100000-0000-0000-0000-000000000014', 3,
 'Lu Yu was a Japanese Buddhist monk who wrote about tea.', 'FALSE', '["FALSE","False","false"]'::jsonb),
('d1100000-0000-0000-0000-000000000044', 'c1100000-0000-0000-0000-000000000014', 4,
 'The Dutch East India Company made a large profit from their first shipment of tea.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'::jsonb);

-- ── Group 15: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('c1100000-0000-0000-0000-000000000015', 'b1100000-0000-0000-0000-000000000004', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN THREE WORDS from the passage for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('d1100000-0000-0000-0000-000000000045', 'c1100000-0000-0000-0000-000000000015', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"Time Period","answer":""},{"id":"h2","gapText":"Event / Person","answer":""},{"id":"h3","gapText":"Details","answer":""}]'::jsonb),
('d1100000-0000-0000-0000-000000000046', 'c1100000-0000-0000-0000-000000000015', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"Tang Dynasty","answer":""},{"id":"c2","gapText":"Lu Yu","answer":""},{"id":"c3","gapText":"Wrote a guide called ","answer":"The Classic of Tea"}]'::jsonb),
('d1100000-0000-0000-0000-000000000047', 'c1100000-0000-0000-0000-000000000015', 7,
 'Row 3', '',
 '[{"id":"c4","gapText":"Early 17th century","answer":""},{"id":"c5","gapText":"","answer":"Dutch East India Company"},{"id":"c6","gapText":"Imported the first major shipment to Amsterdam.","answer":""}]'::jsonb),
('d1100000-0000-0000-0000-000000000048', 'c1100000-0000-0000-0000-000000000015', 8,
 'Row 4', '',
 '[{"id":"c7","gapText":"1662","answer":""},{"id":"c8","gapText":"Catherine of Braganza","answer":""},{"id":"c9","gapText":"Popularised tea among British ","answer":"high society"}]'::jsonb),
('d1100000-0000-0000-0000-000000000049', 'c1100000-0000-0000-0000-000000000015', 9,
 'Row 5', '',
 '[{"id":"c10","gapText":"19th century","answer":""},{"id":"c11","gapText":"","answer":"Robert Fortune"},{"id":"c12","gapText":"Smuggled tea plants to establish plantations in India.","answer":""}]'::jsonb);

-- ── Group 16: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('c1100000-0000-0000-0000-000000000016', 'b1100000-0000-0000-0000-000000000004', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d1100000-0000-0000-0000-000000000050', 'c1100000-0000-0000-0000-000000000016', 10,
 'What did the British illegally export to China to pay for tea?', 'opium', '[{"id":"1","text":"opium"}]'::jsonb),
('d1100000-0000-0000-0000-000000000051', 'c1100000-0000-0000-0000-000000000016', 11,
 'Where did Britain establish tea plantations using smuggled plants?', 'India', '[{"id":"1","text":"India"}]'::jsonb),
('d1100000-0000-0000-0000-000000000052', 'c1100000-0000-0000-0000-000000000016', 12,
 'Which country, alongside Sri Lanka, is mentioned as a top modern tea exporter?', 'Kenya', '[{"id":"1","text":"Kenya"}]'::jsonb),
('d1100000-0000-0000-0000-000000000053', 'c1100000-0000-0000-0000-000000000016', 13,
 'What is the only beverage consumed more than tea globally?', 'water', '[{"id":"1","text":"water"}]'::jsonb);

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: The Future of Smart Cities (Q14–27)         ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b1100000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000002', 2,
 'The Future of Smart Cities: Technology and Urban Life',
 '(A) By 2050, the United Nations projects that 68% of the world''s population will live in urban areas. This rapid municipal expansion puts immense pressure on infrastructure, environmental resources, and public services. In response, urban planners and technologists are turning to the concept of the "smart city"—an urban area that uses different types of electronic Internet of Things (IoT) sensors to collect data and then uses insights gained from that data to manage assets, resources, and services efficiently.

(B) The foundation of a smart city lies in its invisible infrastructure. Millions of interconnected sensors are embedded into roads, buildings, and public spaces. For instance, in Barcelona, smart bins equipped with ultrasonic sensors notify waste management teams only when they are over 80% full, reducing unnecessary garbage truck journeys by up to 30%. Similarly, smart streetlights adjust their brightness based on pedestrian presence, cutting municipal electricity costs significantly.

(C) Perhaps the most visible impact of smart city technology is in traffic and transportation management. Cities like Singapore and Copenhagen utilize real-time data from GPS-equipped public transit, traffic cameras, and smartphone apps to optimise traffic light timings and alleviate congestion. Furthermore, the integration of autonomous vehicles into these digital grids promises to drastically reduce traffic accidents, which are primarily caused by human error.

(D) Environmental sustainability is another core objective. Smart grids allow for two-way communication between electricity providers and consumers, enabling dynamic pricing and encouraging the use of renewable energy during off-peak hours. Buildings, which account for nearly 40% of global energy consumption, are being retrofitted with intelligent climate control systems that adjust heating and cooling based on occupancy and weather forecasts.

(E) However, the transition to smart cities is not without significant hurdles. The collection of vast amounts of granular data on citizens'' movements, consumption habits, and daily routines raises profound privacy and surveillance concerns. Cybersecurity experts warn that a centralised digital infrastructure makes smart cities highly vulnerable to hacking. A successful cyberattack on a city''s power grid or water supply could result in catastrophic real-world consequences.

(F) Ultimately, the success of future smart cities will depend on striking a balance between technological optimisation and human-centric design. Critics argue that a top-down, tech-first approach risks creating sterile environments that cater to efficiency over community. Forward-thinking municipalities are now focusing on "civic tech"—tools designed to empower citizens to participate in local governance, report issues, and shape the digital evolution of their own neighbourhoods.');

-- ── Group 17: MATCHING HEADINGS (Q14–18) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('c1100000-0000-0000-0000-000000000017', 'b1100000-0000-0000-0000-000000000005', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for paragraphs B, C, D, E and F from the list of headings below.', true,
 true, '["i. The risks of digital centralisation","ii. Defining the demographic challenge","iii. Keeping citizens at the heart of design","iv. Revolutionising urban mobility","v. Lowering energy footprints","vi. The unseen network of data collection","vii. The cost of smart infrastructure"]'::jsonb);

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('d1100000-0000-0000-0000-000000000054', 'c1100000-0000-0000-0000-000000000017', 14, 'Paragraph B', 'vi'),
('d1100000-0000-0000-0000-000000000055', 'c1100000-0000-0000-0000-000000000017', 15, 'Paragraph C', 'iv'),
('d1100000-0000-0000-0000-000000000056', 'c1100000-0000-0000-0000-000000000017', 16, 'Paragraph D', 'v'),
('d1100000-0000-0000-0000-000000000057', 'c1100000-0000-0000-0000-000000000017', 17, 'Paragraph E', 'i'),
('d1100000-0000-0000-0000-000000000058', 'c1100000-0000-0000-0000-000000000017', 18, 'Paragraph F', 'iii');

-- ── Group 18: MATCHING INFORMATION (Q19–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1100000-0000-0000-0000-000000000018', 'b1100000-0000-0000-0000-000000000005', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('d1100000-0000-0000-0000-000000000059', 'c1100000-0000-0000-0000-000000000018', 19,
 'An example of technology reducing the frequency of municipal vehicle trips.', 'B',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'::jsonb),
('d1100000-0000-0000-0000-000000000060', 'c1100000-0000-0000-0000-000000000018', 20,
 'A statistical projection regarding future global living patterns.', 'A',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'::jsonb),
('d1100000-0000-0000-0000-000000000061', 'c1100000-0000-0000-0000-000000000018', 21,
 'Mention of a theoretical disaster caused by malicious software.', 'E',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'::jsonb),
('d1100000-0000-0000-0000-000000000062', 'c1100000-0000-0000-0000-000000000018', 22,
 'The primary cause of current road traffic accidents.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'::jsonb),
('d1100000-0000-0000-0000-000000000063', 'c1100000-0000-0000-0000-000000000018', 23,
 'How energy consumers are encouraged to alter their usage times.', 'D',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'::jsonb);

-- ── Group 19: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1100000-0000-0000-0000-000000000019', 'b1100000-0000-0000-0000-000000000005', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('d1100000-0000-0000-0000-000000000064', 'c1100000-0000-0000-0000-000000000019', 24,
 'According to Paragraph B, smart streetlights in Barcelona are designed to:',
 'B',
 '[{"id":"A","text":"A. notify waste management teams of garbage levels.","isCorrect":false},{"id":"B","text":"B. change brightness depending on if people are nearby.","isCorrect":true},{"id":"C","text":"C. track the exact movements of citizens at night.","isCorrect":false},{"id":"D","text":"D. run entirely on solar power.","isCorrect":false}]'::jsonb),
('d1100000-0000-0000-0000-000000000065', 'c1100000-0000-0000-0000-000000000019', 25,
 'What does the writer suggest about autonomous vehicles in Paragraph C?',
 'C',
 '[{"id":"A","text":"A. They will completely replace public transit.","isCorrect":false},{"id":"B","text":"B. They are currently causing congestion in Singapore.","isCorrect":false},{"id":"C","text":"C. They have the potential to make roads safer.","isCorrect":true},{"id":"D","text":"D. They rely exclusively on smartphone applications.","isCorrect":false}]'::jsonb),
('d1100000-0000-0000-0000-000000000066', 'c1100000-0000-0000-0000-000000000019', 26,
 'The main concern highlighted in Paragraph E is that:',
 'D',
 '[{"id":"A","text":"A. citizens are unwilling to share their personal data.","isCorrect":false},{"id":"B","text":"B. building the infrastructure is too expensive.","isCorrect":false},{"id":"C","text":"C. autonomous vehicles are susceptible to hacking.","isCorrect":false},{"id":"D","text":"D. centralised networks pose serious security and privacy risks.","isCorrect":true}]'::jsonb),
('d1100000-0000-0000-0000-000000000067', 'c1100000-0000-0000-0000-000000000019', 27,
 'What is "civic tech" designed to do?',
 'A',
 '[{"id":"A","text":"A. Give citizens a voice in their city''s digital development.","isCorrect":true},{"id":"B","text":"B. Prioritise municipal efficiency over human needs.","isCorrect":false},{"id":"C","text":"C. Replace human government officials with AI.","isCorrect":false},{"id":"D","text":"D. Create a sterile but safe urban environment.","isCorrect":false}]'::jsonb);

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: Language Acquisition (Q28–40)               ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b1100000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000002', 3,
 'Language Acquisition in Children: Nature vs. Nurture',
 '(A) The process by which infants learn to understand and speak their native language is one of the most remarkable feats of human cognitive development. By the age of five, most children have mastered the complex grammatical rules and accumulated a vocabulary of thousands of words, all without formal instruction. Historically, the debate surrounding language acquisition has been sharply divided between two primary camps: the behaviorists and the nativists.

(B) In the mid-20th century, the behaviorist perspective, championed by B.F. Skinner, dominated psychological thought. Skinner argued that language is a learned behavior acquired through operant conditioning. According to this model, infants learn language through imitation, reinforcement, and reward. When a baby babbles a sound resembling "mama" and receives a smile and a hug from their mother, the behavior is reinforced, making the child more likely to repeat it.

(C) This view was forcefully challenged in 1959 by linguist Noam Chomsky, who argued that behaviorism could not explain the speed and creativity of language development. Chomsky pointed out that children frequently generate novel sentences they have never heard before, such as "I holded the rabbit," an over-regularisation of a grammar rule. To explain this, Chomsky proposed the "nativist" theory, suggesting that humans are born with a Language Acquisition Device (LAD)—an innate neuro-cognitive framework containing universal grammatical rules. In Chomsky''s view, exposure to a specific language simply triggers the LAD to adapt its universal parameters to the local language.

(D) A critical component often discussed alongside the nativist theory is the Critical Period Hypothesis, formulated by Eric Lenneberg in 1967. Lenneberg proposed that there is a biologically determined window—typically from early childhood to puberty—during which language acquisition occurs effortlessly. If a child is not exposed to language during this window, achieving native-like fluency becomes virtually impossible. Evidence for this hypothesis is tragically drawn from cases of "feral children" or victims of severe abuse, such as the famous case of "Genie," who was isolated until age 13 and never fully acquired syntax.

(E) Modern linguists and psychologists largely reject the strict dichotomy of nature versus nurture, favouring an "interactionist" approach. Inspired by the theories of Lev Vygotsky, this perspective acknowledges biological predispositions but emphasises the crucial role of social interaction. Interactionists focus on "Child-Directed Speech" (formerly known as motherese)—the exaggerated, high-pitched, and simplified speech adults naturally use with infants. This modified speech is believed to serve as a vital scaffold, helping infants parse the continuous stream of sounds into distinct words and grammatical structures.

(F) Recent advancements in neuroimaging have further illuminated how the developing brain processes language. We now know that the infant brain exhibits extraordinary neuroplasticity. Furthermore, studies on bilingualism have revealed that children raised in bilingual environments exhibit enhanced executive functioning and cognitive flexibility compared to their monolingual peers, suggesting that the effort of managing two linguistic systems provides broad neurological benefits.');

-- ── Group 20: YES/NO/NOT GIVEN (Q28–32) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1100000-0000-0000-0000-000000000020', 'b1100000-0000-0000-0000-000000000006', 1,
 'yes-no-not-given', 'Do the following statements agree with the views of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d1100000-0000-0000-0000-000000000068', 'c1100000-0000-0000-0000-000000000020', 28,
 'Children require formal classroom instruction to master their native language before age five.', 'NO', '["NO","No","no"]'::jsonb),
('d1100000-0000-0000-0000-000000000069', 'c1100000-0000-0000-0000-000000000020', 29,
 'Chomsky believed that children learn language primarily by copying the adults around them.', 'NO', '["NO","No","no"]'::jsonb),
('d1100000-0000-0000-0000-000000000070', 'c1100000-0000-0000-0000-000000000020', 30,
 'Lenneberg argued that it is extremely difficult to achieve fluency if language is not learned before puberty.', 'YES', '["YES","Yes","yes"]'::jsonb),
('d1100000-0000-0000-0000-000000000071', 'c1100000-0000-0000-0000-000000000020', 31,
 'Adults deliberately teach grammar rules when using Child-Directed Speech.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'::jsonb),
('d1100000-0000-0000-0000-000000000072', 'c1100000-0000-0000-0000-000000000020', 32,
 'Bilingual children generally perform better on certain cognitive tasks than monolingual children.', 'YES', '["YES","Yes","yes"]'::jsonb);

-- ── Group 21: MATCHING SENTENCE ENDINGS (Q33–36) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1100000-0000-0000-0000-000000000021', 'b1100000-0000-0000-0000-000000000006', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('d1100000-0000-0000-0000-000000000073', 'c1100000-0000-0000-0000-000000000021', 33,
 'B.F. Skinner''s behaviorist approach asserts that language',
 'E',
 '[{"id":"A","text":"is an innate biological framework present from birth.","isCorrect":false},{"id":"B","text":"helps infants identify distinct words.","isCorrect":false},{"id":"C","text":"prevents the acquisition of syntax in later life.","isCorrect":false},{"id":"D","text":"results in enhanced executive functioning.","isCorrect":false},{"id":"E","text":"is acquired through systems of reward and repetition.","isCorrect":true},{"id":"F","text":"generates sentences that have never been heard before.","isCorrect":false}]'::jsonb),
('d1100000-0000-0000-0000-000000000074', 'c1100000-0000-0000-0000-000000000021', 34,
 'Noam Chomsky highlighted that children often',
 'F',
 '[{"id":"A","text":"is an innate biological framework present from birth.","isCorrect":false},{"id":"B","text":"helps infants identify distinct words.","isCorrect":false},{"id":"C","text":"prevents the acquisition of syntax in later life.","isCorrect":false},{"id":"D","text":"results in enhanced executive functioning.","isCorrect":false},{"id":"E","text":"is acquired through systems of reward and repetition.","isCorrect":false},{"id":"F","text":"generates sentences that have never been heard before.","isCorrect":true}]'::jsonb),
('d1100000-0000-0000-0000-000000000075', 'c1100000-0000-0000-0000-000000000021', 35,
 'The interactionist approach suggests that Child-Directed Speech',
 'B',
 '[{"id":"A","text":"is an innate biological framework present from birth.","isCorrect":false},{"id":"B","text":"helps infants identify distinct words.","isCorrect":true},{"id":"C","text":"prevents the acquisition of syntax in later life.","isCorrect":false},{"id":"D","text":"results in enhanced executive functioning.","isCorrect":false},{"id":"E","text":"is acquired through systems of reward and repetition.","isCorrect":false},{"id":"F","text":"generates sentences that have never been heard before.","isCorrect":false}]'::jsonb),
('d1100000-0000-0000-0000-000000000076', 'c1100000-0000-0000-0000-000000000021', 36,
 'Research into bilingualism indicates that managing two languages',
 'D',
 '[{"id":"A","text":"is an innate biological framework present from birth.","isCorrect":false},{"id":"B","text":"helps infants identify distinct words.","isCorrect":false},{"id":"C","text":"prevents the acquisition of syntax in later life.","isCorrect":false},{"id":"D","text":"results in enhanced executive functioning.","isCorrect":true},{"id":"E","text":"is acquired through systems of reward and repetition.","isCorrect":false},{"id":"F","text":"generates sentences that have never been heard before.","isCorrect":false}]'::jsonb);

-- ── Group 22: SUMMARY COMPLETION with Word Bank (Q37–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('c1100000-0000-0000-0000-000000000022', 'b1100000-0000-0000-0000-000000000006', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["window","reward","imitation","device","interaction","isolation","flexibility"]'::jsonb);

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('d1100000-0000-0000-0000-000000000077', 'c1100000-0000-0000-0000-000000000022', 37,
 'There are multiple theories regarding how children acquire language. Skinner believed it relied on reinforcement and {{gap_c1100000-0000-0000-0000-000000000022_0}}. In contrast, Chomsky proposed humans possess an innate linguistic {{gap_c1100000-0000-0000-0000-000000000022_1}}. Lenneberg added that there is a specific time {{gap_c1100000-0000-0000-0000-000000000022_2}} for optimal learning, which is supported by evidence from children who suffered from extreme {{gap_c1100000-0000-0000-0000-000000000022_3}}.',
 'reward'),
('d1100000-0000-0000-0000-000000000078', 'c1100000-0000-0000-0000-000000000022', 38,
 '', 'device'),
('d1100000-0000-0000-0000-000000000079', 'c1100000-0000-0000-0000-000000000022', 39,
 '', 'window'),
('d1100000-0000-0000-0000-000000000080', 'c1100000-0000-0000-0000-000000000022', 40,
 '', 'isolation');


-- ████████████████████████████████████████████████████████████
-- ██  2. LISTENING TEST 2                                   ██
-- ████████████████████████████████████████████████████████████

INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status) VALUES
('a2000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001',
 'IELTS Listening Practice Test 2', '7', '40 mins', 'published');

-- ── Section 1: Car Rental Enquiry ───────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('b2000000-0000-0000-0000-000000000005', 'a2000000-0000-0000-0000-000000000002', 1,
 'Car Rental Enquiry',
 'Agent: Good morning, Apex Car Rentals. How can I assist you?
Customer: Hi, I''m looking to rent a vehicle for a family holiday in Scotland.
Agent: Great. Let''s get some details. What dates did you have in mind?
Customer: We''ll need it from the 9th to the 16th of August.
Agent: Right, a one-week rental. And what type of vehicle were you looking for? A compact car or an SUV?
Customer: An SUV, please. We have a lot of camping gear.
Agent: Excellent. I can offer you a Ford Kuga. The base rate for a week is 245 pounds. Can I take your name?
Customer: Yes, it''s John Patterson. That''s P-A-T-T-E-R-S-O-N.
Agent: Thank you. And your driving license number?
Customer: It''s PAT 8492.
Agent: Perfect. Now, regarding insurance, the basic package is included, but I highly recommend the Premium Cover, which protects against windshield and tire damage. It''s an extra 30 pounds for the week.
Customer: Yes, let''s add the Premium Cover. The roads up there can be rough.
Agent: Will you need any extras, like a GPS navigation system or a child seat?
Customer: I''ll use my phone for navigation, but we do need one child seat for a three-year-old.
Agent: Not a problem. That will be an additional 15 pounds. So your total comes to 290 pounds.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2000000-0000-0000-0000-000000000006', 'b2000000-0000-0000-0000-000000000005', 1,
 'sentence-completion', 'Complete the rental form below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d2000000-0000-0000-0000-000000000041', 'c2000000-0000-0000-0000-000000000006', 1,
 'Customer Name: John ________', 'Patterson', '["Patterson","patterson","PATTERSON"]'::jsonb),
('d2000000-0000-0000-0000-000000000042', 'c2000000-0000-0000-0000-000000000006', 2,
 'Destination: ________', 'Scotland', '["Scotland","scotland"]'::jsonb),
('d2000000-0000-0000-0000-000000000043', 'c2000000-0000-0000-0000-000000000006', 3,
 'Start Date: 9th ________', 'August', '["August","august"]'::jsonb),
('d2000000-0000-0000-0000-000000000044', 'c2000000-0000-0000-0000-000000000006', 4,
 'Vehicle Type: ________', 'SUV', '["SUV","suv"]'::jsonb),
('d2000000-0000-0000-0000-000000000045', 'c2000000-0000-0000-0000-000000000006', 5,
 'Base Rate: ________ pounds', '245', '["245","£245"]'::jsonb),
('d2000000-0000-0000-0000-000000000046', 'c2000000-0000-0000-0000-000000000006', 6,
 'License Number: ________', 'PAT 8492', '["PAT 8492","pat 8492","PAT8492"]'::jsonb),
('d2000000-0000-0000-0000-000000000047', 'c2000000-0000-0000-0000-000000000006', 7,
 'Insurance Type selected: ________ Cover', 'Premium', '["Premium","premium"]'::jsonb),
('d2000000-0000-0000-0000-000000000048', 'c2000000-0000-0000-0000-000000000006', 8,
 'Insurance covers windshield and ________ damage', 'tire', '["tire","tyre","tires","tyres"]'::jsonb),
('d2000000-0000-0000-0000-000000000049', 'c2000000-0000-0000-0000-000000000006', 9,
 'Extra required: ________', 'child seat', '["child seat","Child seat"]'::jsonb),
('d2000000-0000-0000-0000-000000000050', 'c2000000-0000-0000-0000-000000000006', 10,
 'Total Cost: ________ pounds', '290', '["290","£290"]'::jsonb);

-- ── Section 2: Sports Centre Tour ───────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('b2000000-0000-0000-0000-000000000006', 'a2000000-0000-0000-0000-000000000002', 2,
 'Community Sports Centre Tour',
 'Manager: Welcome to the newly refurbished Oakwood Community Sports Centre. Let me tell you about our new facilities. Our gym membership is now 35 pounds a month, which includes all fitness classes. We are open from 6:00 AM to 10:00 PM on weekdays, and 8:00 AM to 8:00 PM on weekends. 

If you look at the map I''ve handed out: you are currently standing at the Reception in the main entrance hall. If you go straight through the double doors, you''ll find the Main Sports Hall directly in front of you. To the right of the Reception is the Café, which serves healthy snacks and smoothies. Down the corridor to the left of Reception, the first room on your right is the Cardiovascular Gym. Continue to the end of that corridor, and the large area is our new 25-metre Swimming Pool. Finally, the Changing Rooms are located just behind the Café.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2000000-0000-0000-0000-000000000007', 'b2000000-0000-0000-0000-000000000006', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('d2000000-0000-0000-0000-000000000051', 'c2000000-0000-0000-0000-000000000007', 11,
 'How much is the monthly gym membership?',
 '["A. 25 pounds", "B. 35 pounds", "C. 45 pounds"]'::jsonb, 'B'),
('d2000000-0000-0000-0000-000000000052', 'c2000000-0000-0000-0000-000000000007', 12,
 'Does the membership fee include fitness classes?',
 '["A. Yes, all of them", "B. Yes, but only on weekends", "C. No, they cost extra"]'::jsonb, 'A'),
('d2000000-0000-0000-0000-000000000053', 'c2000000-0000-0000-0000-000000000007', 13,
 'What time does the centre close on weekdays?',
 '["A. 8:00 PM", "B. 9:00 PM", "C. 10:00 PM"]'::jsonb, 'C'),
('d2000000-0000-0000-0000-000000000054', 'c2000000-0000-0000-0000-000000000007', 14,
 'What time does the centre open on weekends?',
 '["A. 6:00 AM", "B. 7:00 AM", "C. 8:00 AM"]'::jsonb, 'C'),
('d2000000-0000-0000-0000-000000000055', 'c2000000-0000-0000-0000-000000000007', 15,
 'What type of drinks does the Café specialise in?',
 '["A. Protein shakes", "B. Smoothies", "C. Energy drinks"]'::jsonb, 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('c2000000-0000-0000-0000-000000000008', 'b2000000-0000-0000-0000-000000000006', 2,
 'matching-features', 'Label the map below. Write the correct letter, A–E, next to questions 16–20.', true, true,
 '["A. Main Sports Hall", "B. Café", "C. Cardiovascular Gym", "D. Swimming Pool", "E. Changing Rooms"]'::jsonb);

INSERT INTO listening_questions (id, group_id, question_order, text, answer) VALUES
('d2000000-0000-0000-0000-000000000056', 'c2000000-0000-0000-0000-000000000008', 16, 'Straight through the double doors from Reception', 'A'),
('d2000000-0000-0000-0000-000000000057', 'c2000000-0000-0000-0000-000000000008', 17, 'To the right of the Reception', 'B'),
('d2000000-0000-0000-0000-000000000058', 'c2000000-0000-0000-0000-000000000008', 18, 'First room on the right, down the left corridor', 'C'),
('d2000000-0000-0000-0000-000000000059', 'c2000000-0000-0000-0000-000000000008', 19, 'At the end of the left corridor', 'D'),
('d2000000-0000-0000-0000-000000000060', 'c2000000-0000-0000-0000-000000000008', 20, 'Just behind the Café', 'E');


-- ── Section 3: Student-Tutor Discussion ─────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('b2000000-0000-0000-0000-000000000007', 'a2000000-0000-0000-0000-000000000002', 3,
 'Marine Biology Project Meeting',
 'Dr Aris: Good morning Emma, Liam. Let''s review your marine biology research project. You''re investigating microplastics in local marine life, correct?
Emma: Yes, specifically in Mussels. We collected 100 samples from the harbour last week.
Dr Aris: Excellent. How will you divide the workload for the analysis phase?
Liam: Well, Emma is much better at the laboratory work, so she will handle the chemical digestion of the mussel tissue.
Dr Aris: Sounds sensible. And what about filtering the microplastics and examining them under the microscope?
Liam: I''ll take care of the filtering and the microscopic analysis. 
Dr Aris: Good. Once you have the data, who will run the statistical analysis?
Emma: We plan to do the statistical modelling together. 
Dr Aris: Perfect. Finally, don''t forget the literature review section of the report.
Liam: I''ve already started writing that up, so I''ll finish it. Emma is going to design the visual graphs for the presentation.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2000000-0000-0000-0000-000000000009', 'b2000000-0000-0000-0000-000000000007', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('d2000000-0000-0000-0000-000000000061', 'c2000000-0000-0000-0000-000000000009', 21,
 'What specific marine life are the students investigating?',
 '["A. Fish", "B. Mussels", "C. Seaweed"]'::jsonb, 'B'),
('d2000000-0000-0000-0000-000000000062', 'c2000000-0000-0000-0000-000000000009', 22,
 'How many samples did they collect?',
 '["A. 50", "B. 100", "C. 150"]'::jsonb, 'B'),
('d2000000-0000-0000-0000-000000000063', 'c2000000-0000-0000-0000-000000000009', 23,
 'Where were the samples collected from?',
 '["A. The open ocean", "B. A local beach", "C. The harbour"]'::jsonb, 'C'),
('d2000000-0000-0000-0000-000000000064', 'c2000000-0000-0000-0000-000000000009', 24,
 'When did they collect the samples?',
 '["A. Yesterday", "B. Last week", "C. Last month"]'::jsonb, 'B'),
('d2000000-0000-0000-0000-000000000065', 'c2000000-0000-0000-0000-000000000009', 25,
 'What type of pollutant are they looking for?',
 '["A. Oil spills", "B. Heavy metals", "C. Microplastics"]'::jsonb, 'C');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('c2000000-0000-0000-0000-000000000010', 'b2000000-0000-0000-0000-000000000007', 2,
 'matching-features', 'Who will be responsible for the following tasks? Match the tasks (26-30) to the person (A-C).', true, true,
 '["A. Emma", "B. Liam", "C. Both Emma and Liam"]'::jsonb);

INSERT INTO listening_questions (id, group_id, question_order, text, answer) VALUES
('d2000000-0000-0000-0000-000000000066', 'c2000000-0000-0000-0000-000000000010', 26, 'Chemical digestion of tissue', 'A'),
('d2000000-0000-0000-0000-000000000067', 'c2000000-0000-0000-0000-000000000010', 27, 'Microscopic analysis', 'B'),
('d2000000-0000-0000-0000-000000000068', 'c2000000-0000-0000-0000-000000000010', 28, 'Statistical modelling', 'C'),
('d2000000-0000-0000-0000-000000000069', 'c2000000-0000-0000-0000-000000000010', 29, 'Writing the literature review', 'B'),
('d2000000-0000-0000-0000-000000000070', 'c2000000-0000-0000-0000-000000000010', 30, 'Designing visual graphs', 'A');

-- ── Section 4: Lecture on Mars Exploration ──────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('b2000000-0000-0000-0000-000000000008', 'a2000000-0000-0000-0000-000000000002', 4,
 'Lecture: The History of Mars Rovers',
 'Professor: Let''s turn our attention to planetary science, specifically the robotic exploration of Mars. Our understanding of the Red Planet changed forever in 1997 with the landing of Sojourner, a microwave-sized rover that operated for just 83 days but proved that mobile exploration was possible.

This paved the way for the twin rovers, Spirit and Opportunity, which landed in 2004. Their primary mission was to search for geological evidence of past water activity. Opportunity was remarkably resilient; designed to last 90 days, it functioned for nearly 15 years, finally succumbing to a global dust storm in 2018.

In 2012, NASA landed Curiosity. This was a massive upgrade—the size of a small car and powered by a nuclear radioisotope generator. Curiosity confirmed that Mars once had the chemical ingredients and liquid water necessary to support microbial life.

The current flagship is Perseverance, which landed in 2021. Its main objective is astrobiology—searching for direct signs of ancient life. It is equipped with a drill to collect rock cores, which are being sealed in titanium tubes. The plan is for a future joint NASA-ESA mission to retrieve these tubes and return them to Earth by the early 2030s for complex laboratory analysis.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2000000-0000-0000-0000-000000000011', 'b2000000-0000-0000-0000-000000000008', 1,
 'sentence-completion', 'Complete the notes below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d2000000-0000-0000-0000-000000000071', 'c2000000-0000-0000-0000-000000000011', 31,
 'Sojourner landed on Mars in the year ________.', '1997', '["1997"]'::jsonb),
('d2000000-0000-0000-0000-000000000072', 'c2000000-0000-0000-0000-000000000011', 32,
 'Sojourner was roughly the size of a ________.', 'microwave', '["microwave"]'::jsonb),
('d2000000-0000-0000-0000-000000000073', 'c2000000-0000-0000-0000-000000000011', 33,
 'Spirit and Opportunity searched for evidence of past ________.', 'water activity', '["water activity","water"]'::jsonb),
('d2000000-0000-0000-0000-000000000074', 'c2000000-0000-0000-0000-000000000011', 34,
 'The Opportunity rover was eventually disabled by a ________.', 'dust storm', '["dust storm","storm"]'::jsonb),
('d2000000-0000-0000-0000-000000000075', 'c2000000-0000-0000-0000-000000000011', 35,
 'Curiosity is powered by a ________ generator.', 'nuclear', '["nuclear","radioisotope"]'::jsonb),
('d2000000-0000-0000-0000-000000000076', 'c2000000-0000-0000-0000-000000000011', 36,
 'Curiosity confirmed Mars once had the conditions to support ________ life.', 'microbial', '["microbial","microbial life"]'::jsonb),
('d2000000-0000-0000-0000-000000000077', 'c2000000-0000-0000-0000-000000000011', 37,
 'The main objective of the Perseverance rover is ________.', 'astrobiology', '["astrobiology"]'::jsonb),
('d2000000-0000-0000-0000-000000000078', 'c2000000-0000-0000-0000-000000000011', 38,
 'Perseverance is storing rock cores inside ________ tubes.', 'titanium', '["titanium"]'::jsonb),
('d2000000-0000-0000-0000-000000000079', 'c2000000-0000-0000-0000-000000000011', 39,
 'A future mission will return these samples to Earth by the early ________.', '2030s', '["2030s","2030"]'::jsonb),
('d2000000-0000-0000-0000-000000000080', 'c2000000-0000-0000-0000-000000000011', 40,
 'The sample return is a joint mission between NASA and ________.', 'ESA', '["ESA","esa"]'::jsonb);


-- ████████████████████████████████████████████████████████████
-- ██  3. WRITING TEST 2                                     ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('a3000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001',
 'IELTS Academic Writing Practice Test 2', 'published');

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('d3000000-0000-0000-0000-000000000003', 'a3000000-0000-0000-0000-000000000002', 1,
 'task1', 'Writing Task 1', '7', '20 mins',
 'The diagrams below show the stages and equipment used in the cement-making process, and how cement is used to produce concrete for building purposes. 

Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
 150, '', ''),
('d3000000-0000-0000-0000-000000000004', 'a3000000-0000-0000-0000-000000000002', 2,
 'task2', 'Writing Task 2', '7', '40 mins',
 'In many countries, schools have severe problems with student behaviour. 

What do you think are the causes of this? 
What solutions can you suggest?',
 250, '', '');

-- ════════════════════════════════════════════════════════════
-- End of IELTS Practice Test 2 Seed
-- ════════════════════════════════════════════════════════════
