-- ============================================================
-- IELTS Practice Platform – Extended Seed Data
-- Target: Reading Module (Academic, Band 7 Difficulty)
-- Action: APPEND (No TRUNCATE)
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST ENTRY (Academic - Band 7)                           ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('c29f560c-edc2-4d9f-aed2-7fda4988bb1e', 'cd80388f-4604-48f4-a84a-0d673deeb7e1',
 'IELTS Academic Reading: Engineering, Neuroscience & Psychology (Band 7)', 'Academic', '7', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: The Evolution of the Bicycle (Q1–13)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b5becda5-6149-428f-8665-a95c9b60fefa', 'c29f560c-edc2-4d9f-aed2-7fda4988bb1e', 1,
 'The Evolution of the Bicycle',
 '(A) The bicycle is widely recognized as one of the most efficient modes of human-powered transportation ever invented. However, the modern bicycle is the result of nearly a century of iterative engineering. The earliest recognizable ancestor of the bicycle was the "dandy horse" or Draisienne, invented by German baron Karl von Drais in 1817. Propelled by the rider pushing their feet against the ground, this heavy wooden contraption lacked pedals and a chain. It was intended as an alternative to horse transport after a massive volcanic eruption in Indonesia caused widespread crop failures and a subsequent shortage of horses across Europe.

(B) It was not until the 1860s in France that rotary cranks and pedals were attached to the front wheel hub, creating the "velocipede." Popularly known as the "boneshaker," this machine featured a stiff wrought-iron frame and wooden wheels with solid iron tires. As the nickname suggests, riding a velocipede on the cobblestone roads of the era was an incredibly uncomfortable experience. To achieve higher speeds, inventors realized they needed a larger front wheel, as the distance covered in a single pedal stroke is dictated by the circumference of the driven wheel.

(C) This realization led to the development of the "penny-farthing" or high-wheel bicycle in the 1870s. Characterized by a massive front wheel—often up to 1.5 meters in diameter—and a tiny rear wheel, it was the first machine to be officially called a "bicycle." While the large wheel provided a much smoother ride and allowed for greater speeds, it was inherently dangerous. The rider sat high above the center of gravity, and any sudden stop caused by a rut or a dog in the road would send the rider pitching headfirst over the handlebars.

(D) The true revolution in cycling came in 1885 with the introduction of the Rover Safety Bicycle, designed by Englishman John Kemp Starley. The Rover featured a steerable front wheel, two wheels of similar size, and a chain drive that transferred power from the pedals to the rear wheel. This design placed the rider much lower to the ground, significantly reducing the risk of fatal crashes. The safety bicycle democratized cycling, transforming it from a dangerous sport for adventurous young men into a practical mode of transport for the general public, including women, who adopted it enthusiastically as a symbol of newfound independence.

(E) The final crucial piece of the puzzle was the invention of the pneumatic (air-filled) tire. While Robert William Thomson had patented a pneumatic tire in 1845, it was virtually ignored. It wasn''t until 1888 that John Boyd Dunlop, a Scottish veterinarian living in Belfast, reinvented it to make his young son''s tricycle more comfortable to ride. Dunlop’s invention replaced the jarring solid rubber tires of the day, drastically improving traction and comfort. By the 1890s, the combination of the safety frame and pneumatic tires triggered the "Golden Age of Bicycles," fundamentally altering urban mobility and paving the way for the eventual development of the automobile.');

-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c3fe8fe0-ee29-4a40-84ad-2cf7749203eb', 'b5becda5-6149-428f-8665-a95c9b60fefa', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the passage? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('e05d273b-f6a7-47b9-9f73-4a2c935bd543', 'c3fe8fe0-ee29-4a40-84ad-2cf7749203eb', 1,
 'The invention of the Draisienne was prompted by a shortage of agricultural crops for human consumption.', 'FALSE', '["FALSE","False","false"]'),
('e46f68f5-5cf6-475c-b16b-c7c193744b8b', 'c3fe8fe0-ee29-4a40-84ad-2cf7749203eb', 2,
 'The nickname "boneshaker" referred to the velocipede’s metal frame and solid iron tires.', 'TRUE', '["TRUE","True","true"]'),
('1a8b3f79-966a-4882-8735-9006b2fd4729', 'c3fe8fe0-ee29-4a40-84ad-2cf7749203eb', 3,
 'Women initially preferred the high-wheel penny-farthing before the safety bicycle was introduced.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('0cb1cb63-df25-4073-81ff-ed51c24a25c7', 'c3fe8fe0-ee29-4a40-84ad-2cf7749203eb', 4,
 'John Boyd Dunlop was the first person to ever patent the pneumatic tire.', 'FALSE', '["FALSE","False","false"]');

-- ── Group 2: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('0c22f054-25ec-499e-bd5d-58b84448e113', 'b5becda5-6149-428f-8665-a95c9b60fefa', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('1e6cfecb-1db1-4b88-af58-34d7f1645f44', '0c22f054-25ec-499e-bd5d-58b84448e113', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"Era","answer":""},{"id":"h2","gapText":"Bicycle Name / Invention","answer":""},{"id":"h3","gapText":"Key Characteristics","answer":""}]'),
('01d9d047-4efb-4f37-8dbf-e02b841fe3dd', '0c22f054-25ec-499e-bd5d-58b84448e113', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"1817","answer":""},{"id":"c2","gapText":"Draisienne","answer":""},{"id":"c3","gapText":"Had no {{gap}} or chain","answer":"pedals"}]'),
('13a29f9a-0cc7-4646-a84e-fe1597c0c412', '0c22f054-25ec-499e-bd5d-58b84448e113', 7,
 'Row 3', '',
 '[{"id":"c4","gapText":"1870s","answer":""},{"id":"c5","gapText":"{{gap}} bicycle","answer":"high-wheel"},{"id":"c6","gapText":"Smoother ride but dangerous center of gravity","answer":""}]'),
('f5853a09-ff4a-4526-9f97-67cca8d8516f', '0c22f054-25ec-499e-bd5d-58b84448e113', 8,
 'Row 4', '',
 '[{"id":"c7","gapText":"1885","answer":""},{"id":"c8","gapText":"Rover Safety Bicycle","answer":""},{"id":"c9","gapText":"Utilized a {{gap}} for power transfer","answer":"chain drive"}]'),
('f1ccd913-04de-42a4-b6f9-260efd147afa', '0c22f054-25ec-499e-bd5d-58b84448e113', 9,
 'Row 5', '',
 '[{"id":"c10","gapText":"1888","answer":""},{"id":"c11","gapText":"{{gap}} tire","answer":"pneumatic"},{"id":"c12","gapText":"Replaced solid rubber, improving traction","answer":""}]');

-- ── Group 3: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('8e124494-d668-4878-a147-f909917d75b9', 'b5becda5-6149-428f-8665-a95c9b60fefa', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS from the passage for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('1ea48572-856e-45a9-b6d4-fb1cf79378b5', '8e124494-d668-4878-a147-f909917d75b9', 10,
 'What environmental event led to a widespread shortage of horses across Europe?', 'volcanic eruption', '[{"id":"1","text":"volcanic eruption"},{"id":"2","text":"massive volcanic eruption"}]'),
('e46bf251-99b9-44ee-9bb8-7931f83a71ca', '8e124494-d668-4878-a147-f909917d75b9', 11,
 'What dictated the distance a velocipede could cover in a single pedal stroke?', 'circumference', '[{"id":"1","text":"the circumference"},{"id":"2","text":"circumference"}]'),
('a60fadca-63b3-4a6a-a41d-5c1b5e5a0c59', '8e124494-d668-4878-a147-f909917d75b9', 12,
 'Who designed the Rover Safety Bicycle in 1885?', 'John Kemp Starley', '[{"id":"1","text":"John Kemp Starley"},{"id":"2","text":"Starley"}]'),
('6c963930-6f88-4d41-9afb-0a0f577086c1', '8e124494-d668-4878-a147-f909917d75b9', 13,
 'For whose vehicle did John Boyd Dunlop originally reinvent the air-filled tire?', 'his young son''s', '[{"id":"1","text":"his young son''s"},{"id":"2","text":"his son''s tricycle"},{"id":"3","text":"young son''s tricycle"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Memory Consolidation During Sleep (Q14–27)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('3fab6ef8-01b5-4b4a-8e1f-debeed6c0405', 'c29f560c-edc2-4d9f-aed2-7fda4988bb1e', 2,
 'Memory Consolidation During Sleep',
 '(A) For centuries, sleep was considered a passive state of rest, a time when the brain simply powered down to recover from the waking hours. However, modern neuroscience has revealed that the sleeping brain is highly active, orchestrating a complex set of biological processes. Among the most critical of these is memory consolidation—the process by which fragile, newly formed memories are transformed into stable, long-term representations. This realization has profoundly shifted our understanding of why we sleep, suggesting that it is not merely for physical restoration, but essential for cognitive function and learning.

(B) Sleep is broadly divided into two main categories: Rapid Eye Movement (REM) sleep and Non-REM (NREM) sleep. NREM sleep is further subdivided into several stages, the deepest of which is known as Slow-Wave Sleep (SWS). During SWS, the brain generates slow, synchronous electrical waves. It is during this deep sleep phase that declarative memories—factual information and events, such as a list of vocabulary words or the layout of a new city—are primarily consolidated. REM sleep, characterized by rapid eye movements and vivid dreaming, is believed to play a larger role in the consolidation of procedural memories (motor skills like riding a bike) and emotional memory processing.

(C) The mechanism behind memory consolidation during SWS involves a dynamic dialogue between two critical brain structures: the hippocampus and the neocortex. The hippocampus acts as a temporary storage site, rapidly acquiring new information throughout the day. However, it has a limited capacity and its memory traces are highly unstable. During deep sleep, the hippocampus repeatedly "replays" the neural activity patterns that occurred during waking learning. This high-speed replay is transmitted to the neocortex, the brain’s long-term storage vault. Gradually, over days and weeks, the neocortex integrates this new information into existing associative networks, eventually becoming independent of the hippocampus.

(D) Strong evidence for this replay mechanism comes from spatial navigation experiments in rodents. Researchers implanted electrodes into the brains of rats to monitor individual neurons as they navigated a maze. They identified specific "place cells" that fired in a distinct sequence as the rat moved through different parts of the maze. Crucially, when the rats subsequently entered SWS, researchers observed the exact same sequence of neuronal firing in the hippocampus, occurring at a highly accelerated rate. The sleeping brain was literally replaying the maze runs, solidifying the spatial map.

(E) An alternative, though complementary, theory to memory replay is the Synaptic Homeostasis Hypothesis (SHY), proposed by neuroscientists Giulio Tononi and Chiara Cirelli. According to SHY, waking life is characterized by a net increase in synaptic strength across the brain as we constantly learn and encode new experiences. However, sustaining these strong connections requires immense energy and takes up physical space. SHY posits that the primary function of sleep, particularly slow-wave sleep, is to broadly scale down or "prune" synaptic connections. 

(F) This pruning process during sleep ensures that only the strongest, most important neural connections survive, while the weaker, less relevant synapses are downscaled. By selectively erasing the "noise" of the day, sleep essentially increases the signal-to-noise ratio, making the important memories stand out more clearly in the morning. Furthermore, this global downscaling restores the brain to a baseline state of energy efficiency, preparing it to learn anew the following day. Thus, forgetting the trivial is just as vital as remembering the important.');

-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('e05d273b-f6a7-47b9-9f73-4a2c935bd543', '3fab6ef8-01b5-4b4a-8e1f-debeed6c0405', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. Experimental proof of neurological rehearsal", "ii. The role of the neocortex in rapid learning", "iii. Shifting perspectives on the purpose of sleep", "iv. Enhancing clarity through selective deletion", "v. Different sleep stages for different memory types", "vi. The energy costs of maintaining neural networks", "vii. Transferring data from temporary to permanent storage", "viii. Why REM sleep is crucial for emotional stability"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('75844cce-7622-4e5f-bc89-495d334746a7', 'e05d273b-f6a7-47b9-9f73-4a2c935bd543', 14, 'Paragraph A', 'iii'),
('7b04d050-139a-4339-bb3e-d6da7566a4f1', 'e05d273b-f6a7-47b9-9f73-4a2c935bd543', 15, 'Paragraph B', 'v'),
('deb003a8-4a49-40dc-b581-f57a0e1af4e5', 'e05d273b-f6a7-47b9-9f73-4a2c935bd543', 16, 'Paragraph C', 'vii'),
('2b80d3ee-b60e-453a-9467-7954d21cf75f', 'e05d273b-f6a7-47b9-9f73-4a2c935bd543', 17, 'Paragraph D', 'i'),
('426c63c4-9384-47d8-9226-e6757dd90446', 'e05d273b-f6a7-47b9-9f73-4a2c935bd543', 18, 'Paragraph E', 'vi'),
('65e0b001-e486-4802-b461-fa02cad61dba', 'e05d273b-f6a7-47b9-9f73-4a2c935bd543', 19, 'Paragraph F', 'iv');

-- ── Group 5: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('e46f68f5-5cf6-475c-b16b-c7c193744b8b', '3fab6ef8-01b5-4b4a-8e1f-debeed6c0405', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('de05f4b3-09f3-4605-b714-a0f4d702a230', 'e46f68f5-5cf6-475c-b16b-c7c193744b8b', 20,
 'A description of an animal study monitoring brain activity.', 'D',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('e3b07647-b874-4c87-ac64-dd1d9af6aa37', 'e46f68f5-5cf6-475c-b16b-c7c193744b8b', 21,
 'An explanation of how the brain restores its energy capacity for the next day.', 'F',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('60386082-6952-4e76-94c4-0b537862e2b1', 'e46f68f5-5cf6-475c-b16b-c7c193744b8b', 22,
 'A contrast between the consolidation of factual data and physical abilities.', 'B',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('fce41362-a9a2-4a14-9f87-9c6345557694', 'e46f68f5-5cf6-475c-b16b-c7c193744b8b', 23,
 'The idea that a specific brain region has restricted storage space for new data.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');

-- ── Group 6: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('1a8b3f79-966a-4882-8735-9006b2fd4729', '3fab6ef8-01b5-4b4a-8e1f-debeed6c0405', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('cea9c189-a34e-4751-ac73-076cc12c4910', '1a8b3f79-966a-4882-8735-9006b2fd4729', 24,
 'What does the passage identify as the main function of the hippocampus?',
 'A',
 '[{"id":"A","text":"A. Acting as a short-term holding area for new memories.","isCorrect":true},{"id":"B","text":"B. Consolidating procedural memories like riding a bike.","isCorrect":false},{"id":"C","text":"C. Serving as the brain’s permanent storage vault for all knowledge.","isCorrect":false},{"id":"D","text":"D. Pruning unnecessary synapses to save energy.","isCorrect":false}]'),
('075ee066-f6af-419d-afd6-318cdbed4e42', '1a8b3f79-966a-4882-8735-9006b2fd4729', 25,
 'During the spatial navigation experiments, researchers discovered that rats in deep sleep:',
 'B',
 '[{"id":"A","text":"A. Developed new place cells that did not exist while awake.","isCorrect":false},{"id":"B","text":"B. Replayed their physical movements at an accelerated speed neurologically.","isCorrect":true},{"id":"C","text":"C. Required REM sleep to properly navigate the maze the next day.","isCorrect":false},{"id":"D","text":"D. Showed a massive reduction in overall synaptic connections.","isCorrect":false}]'),
('65c8833d-702e-4bcc-8a64-51f5ff0261d3', '1a8b3f79-966a-4882-8735-9006b2fd4729', 26,
 'The Synaptic Homeostasis Hypothesis (SHY) argues that:',
 'C',
 '[{"id":"A","text":"A. Synaptic connections only grow stronger when we are asleep.","isCorrect":false},{"id":"B","text":"B. Energy consumption in the brain is highest during Slow-Wave Sleep.","isCorrect":false},{"id":"C","text":"C. Sleep selectively reduces the strength of neural connections.","isCorrect":true},{"id":"D","text":"D. The hippocampus is solely responsible for synaptic pruning.","isCorrect":false}]'),
('48231d05-6fbe-4351-844e-94e0caf1724e', '1a8b3f79-966a-4882-8735-9006b2fd4729', 27,
 'According to the passage, the selective removal of trivial memories during sleep:',
 'B',
 '[{"id":"A","text":"A. Causes temporary confusion upon waking up.","isCorrect":false},{"id":"B","text":"B. Enhances the prominence of important memories.","isCorrect":true},{"id":"C","text":"C. Primarily occurs during REM sleep cycles.","isCorrect":false},{"id":"D","text":"D. Prevents the neocortex from overloading with declarative data.","isCorrect":false}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: The Paradox of Choice in Consumer Psychology (Q28–40)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('39b53ec6-9e26-4f1a-b404-e0746b614c07', 'c29f560c-edc2-4d9f-aed2-7fda4988bb1e', 3,
 'The Paradox of Choice in Consumer Psychology',
 '(A) In modern capitalist societies, the dominant dogma holds that to maximize the welfare of citizens, one must maximize individual freedom. The prevailing logic suggests that the most direct way to maximize freedom is to maximize choice. Walk into any major supermarket, and you are presented with staggering variety: hundreds of types of cereal, dozens of variations of toothpaste, and an endless array of snack foods. Intuitively, this abundance of choice seems like an unalloyed good. However, psychological research conducted over the last two decades tells a vastly different story, suggesting that a profound overabundance of choice can lead to decision paralysis, increased anxiety, and decreased life satisfaction.

(B) The seminal work on this topic was popularized by psychologist Barry Schwartz in his 2004 book, "The Paradox of Choice." Schwartz synthesized a growing body of behavioral economics and psychology research, most notably the famous "jam experiment" conducted by Sheena Iyengar and Mark Lepper in 2000. In their study, researchers set up a tasting booth at an upscale grocery store. On some days, the booth offered a staggering 24 varieties of gourmet jam. On other days, it offered a modest six varieties. While the large display attracted more initial interest, the sales data was startling: 30% of consumers who viewed the small assortment purchased a jar, compared to a mere 3% of those presented with the 24-jam display. 

(C) The cognitive load required to evaluate 24 options essentially overwhelmed the consumers'' decision-making faculties. This phenomenon is termed "choice overload." When faced with too many variables, the human brain struggles to compute the relative utility of each option. The sheer mental effort required to make an informed decision becomes a barrier to making any decision at all. Consequently, consumers often resort to a default action: walking away empty-handed.

(D) Even when consumers do manage to make a choice in a high-option environment, they frequently end up less satisfied with their selection than they would have been with fewer options. Schwartz attributes this to several psychological mechanisms. The first is "opportunity cost." Every choice we make inherently involves rejecting the alternatives. When there are dozens of alternatives, the combined perceived value of the rejected options subtracts heavily from the satisfaction derived from the chosen item. A buyer might purchase an excellent digital camera, but the lingering thought of the features offered by the 15 unchosen cameras diminishes their overall happiness with the purchase.

(E) Furthermore, an abundance of choices inevitably escalates our expectations. If there are only two types of jeans available, and neither fits perfectly, you intuitively blame the world—the market just doesn''t offer good jeans. But if there are hundreds of styles, fits, and washes available, and the pair you choose isn''t flawless, you blame yourself. The implicit assumption is that with so many options, the perfect pair must exist, and your failure to find it is a personal failing.

(F) To navigate this psychological minefield, researchers distinguish between two primary decision-making styles: maximizing and satisficing. "Maximizers" are individuals who strive to make the absolute best possible choice. They obsessively compare features, read endless reviews, and agonize over minute details. While maximizers may occasionally secure objectively better outcomes, they generally experience higher levels of regret, anxiety, and depression. Conversely, "satisficers" have predetermined criteria and settle for the first option that meets their threshold of acceptability. They do not worry about missing out on a hypothetically superior alternative once their needs are met.

(G) The paradox of choice does not argue that zero choice is preferable to some choice. Autonomy is fundamentally necessary for psychological well-being. The issue arises when choice transitions from a liberating force to a debilitating one. Designing systems that deliberately curate choices—reducing friction without eliminating agency—may be the most effective way to help consumers navigate modern markets while preserving their mental health.');

-- ── Group 7: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('0cb1cb63-df25-4073-81ff-ed51c24a25c7', '39b53ec6-9e26-4f1a-b404-e0746b614c07', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('39ac165b-e420-4658-b241-a7a800816376', '0cb1cb63-df25-4073-81ff-ed51c24a25c7', 28,
 'The common logic in capitalist societies is that limiting consumer options restricts personal freedom.', 'YES', '["YES","Yes","yes"]'),
('486731b0-59ff-420e-b43a-35a7cd652030', '0cb1cb63-df25-4073-81ff-ed51c24a25c7', 29,
 'Barry Schwartz was the primary researcher who conducted the 2000 grocery store jam experiment.', 'NO', '["NO","No","no"]'),
('c479e2ed-f156-4218-a82f-b785ec78bf88', '0cb1cb63-df25-4073-81ff-ed51c24a25c7', 30,
 'Maximizers tend to secure higher-paying jobs than satisficers due to their intensive research habits.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('4f61d91d-7467-473d-9fb8-a83fd5c42f8b', '0cb1cb63-df25-4073-81ff-ed51c24a25c7', 31,
 'Consumers in a high-option environment tend to blame themselves if their final choice is flawed.', 'YES', '["YES","Yes","yes"]');

-- ── Group 8: MATCHING SENTENCE ENDINGS (Q32–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('1e6cfecb-1db1-4b88-af58-34d7f1645f44', '39b53ec6-9e26-4f1a-b404-e0746b614c07', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('1af1ab85-1c67-42b6-87aa-6a1d4076c991', '1e6cfecb-1db1-4b88-af58-34d7f1645f44', 32,
 'According to the results of the jam experiment, a massive display of choices frequently causes consumers to',
 'E',
 '[{"id":"A","text":"experience lower levels of depression and regret.","isCorrect":false},{"id":"B","text":"carefully select the option that perfectly fits their needs.","isCorrect":false},{"id":"C","text":"feel dissatisfied because they rejected so many attractive alternatives.","isCorrect":false},{"id":"D","text":"blame the manufacturer for producing substandard goods.","isCorrect":false},{"id":"E","text":"avoid making any purchasing decision at all.","isCorrect":true},{"id":"F","text":"rely exclusively on brand reputation rather than features.","isCorrect":false}]'),
('70012385-d239-4c0a-a7a4-b5d689bee925', '1e6cfecb-1db1-4b88-af58-34d7f1645f44', 33,
 'Because of the concept of opportunity cost, selecting an item from a large array of options often leads people to',
 'C',
 '[{"id":"A","text":"experience lower levels of depression and regret.","isCorrect":false},{"id":"B","text":"carefully select the option that perfectly fits their needs.","isCorrect":false},{"id":"C","text":"feel dissatisfied because they rejected so many attractive alternatives.","isCorrect":true},{"id":"D","text":"blame the manufacturer for producing substandard goods.","isCorrect":false},{"id":"E","text":"avoid making any purchasing decision at all.","isCorrect":false},{"id":"F","text":"rely exclusively on brand reputation rather than features.","isCorrect":false}]'),
('d53c8cb9-9128-4b09-81e9-c766fc8b1d82', '1e6cfecb-1db1-4b88-af58-34d7f1645f44', 34,
 'When faced with a very limited selection of products, dissatisfied buyers are more likely to',
 'D',
 '[{"id":"A","text":"experience lower levels of depression and regret.","isCorrect":false},{"id":"B","text":"carefully select the option that perfectly fits their needs.","isCorrect":false},{"id":"C","text":"feel dissatisfied because they rejected so many attractive alternatives.","isCorrect":false},{"id":"D","text":"blame the manufacturer for producing substandard goods.","isCorrect":true},{"id":"E","text":"avoid making any purchasing decision at all.","isCorrect":false},{"id":"F","text":"rely exclusively on brand reputation rather than features.","isCorrect":false}]'),
('e41d7887-d8a8-4714-bf1e-d3ff5a356a19', '1e6cfecb-1db1-4b88-af58-34d7f1645f44', 35,
 'Compared to maximizers, individuals who utilize a satisficing approach generally',
 'A',
 '[{"id":"A","text":"experience lower levels of depression and regret.","isCorrect":true},{"id":"B","text":"carefully select the option that perfectly fits their needs.","isCorrect":false},{"id":"C","text":"feel dissatisfied because they rejected so many attractive alternatives.","isCorrect":false},{"id":"D","text":"blame the manufacturer for producing substandard goods.","isCorrect":false},{"id":"E","text":"avoid making any purchasing decision at all.","isCorrect":false},{"id":"F","text":"rely exclusively on brand reputation rather than features.","isCorrect":false}]');

-- ── Group 9: SUMMARY COMPLETION with Word Bank (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('01d9d047-4efb-4f37-8dbf-e02b841fe3dd', '39b53ec6-9e26-4f1a-b404-e0746b614c07', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["anxiety", "satisficers", "expectations", "paralysis", "curation", "maximizers", "autonomy", "welfare", "effort"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('c2763c9c-b289-40f6-b2e7-96540bf9b650', '01d9d047-4efb-4f37-8dbf-e02b841fe3dd', 36,
 'The abundance of options in modern markets can have unintended negative consequences. While freedom is generally associated with increased {{gap_01d9d047-4efb-4f37-8dbf-e02b841fe3dd_0}}, research indicates that offering too many choices often requires immense cognitive {{gap_01d9d047-4efb-4f37-8dbf-e02b841fe3dd_1}}. This overload can result in decision {{gap_01d9d047-4efb-4f37-8dbf-e02b841fe3dd_2}}, where consumers choose not to buy anything at all. When people do make a choice, having vast options raises their {{gap_01d9d047-4efb-4f37-8dbf-e02b841fe3dd_3}} regarding the product’s perfection, leading to self-blame if the item is flawed. To cope with this, some consumers act as {{gap_01d9d047-4efb-4f37-8dbf-e02b841fe3dd_4}}, simply accepting the first product that meets their basic criteria, a strategy that generally leads to greater happiness.',
 'welfare'),
('a1738667-a5d9-49ba-8746-60a8b8c01f8b', '01d9d047-4efb-4f37-8dbf-e02b841fe3dd', 37,
 '', 'effort'),
('7ea68875-e243-44b8-aaa4-18369d74c3d7', '01d9d047-4efb-4f37-8dbf-e02b841fe3dd', 38,
 '', 'paralysis'),
('d8137c1e-ef06-4332-a104-ff7cc50ca66b', '01d9d047-4efb-4f37-8dbf-e02b841fe3dd', 39,
 '', 'expectations'),
('eea8c028-08bc-46ce-80d0-34cc33ce362d', '01d9d047-4efb-4f37-8dbf-e02b841fe3dd', 40,
 '', 'satisficers');

-- ============================================================
-- NOTE: Please execute `UPDATE reading_tests SET created_by = '<your-uid>'` 
-- if required by your application's Row Level Security policies.
-- ============================================================