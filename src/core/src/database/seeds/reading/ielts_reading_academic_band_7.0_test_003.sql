-- ============================================================
-- IELTS Practice Platform – Extended Seed Data
-- Target: Reading Module (Academic, Band 7 Difficulty)
-- Action: APPEND (No TRUNCATE)
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST ENTRY (Academic - Band 7)                           ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('af23d8b2-f092-4e5b-bd38-77a627d173db', '9d61cffc-9252-413e-ab61-2b76d0ab7f9f',
 'IELTS Academic Reading: Commerce, Ecology & Psychology (Band 7)', 'Academic', '7', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: The Development of the Barcode (Q1–13)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b569b159-116b-40de-af56-fc33c910c3ba', 'af23d8b2-f092-4e5b-bd38-77a627d173db', 1,
 'The Development of the Barcode',
 '(A) In the late 1940s, the global retail industry was expanding rapidly, but the checkout process remained a significant bottleneck. Grocery store cashiers had to manually read prices on every item and type them into mechanical cash registers. This process was inherently slow, labor-intensive, and prone to human error. A local supermarket executive approached the Drexel Institute of Technology in Philadelphia, pleading for a system to automate product data reading at checkout. While the dean of the institute dismissed the idea, a graduate student named Bernard Silver overheard the conversation and shared the problem with his friend, Norman Joseph Woodland. 

(B) Intrigued by the challenge, Silver and Woodland began exploring solutions. Their initial concept utilized patterns of ultraviolet (UV) ink that glowed under blacklight. However, they soon discovered that the UV ink faded quickly, and the necessary printing equipment was prohibitively expensive. Undeterred, Woodland moved to Florida to focus entirely on the project. Inspired by his Boy Scout training, Woodland drew a series of dots and dashes—Morse code—in the sand on a beach. He then dragged his fingers downward, extending the dots and dashes into thick and thin parallel lines. This simple act birthed the concept of the linear barcode.

(C) To make the symbol readable from any direction, Woodland adapted his parallel lines into a circular "bullseye" design, consisting of a series of concentric circles. In 1952, Woodland and Silver were granted a US patent for their "Classifying Apparatus and Method." Despite the brilliant theoretical design, the computing power and laser technology required to read the symbol quickly and accurately did not yet exist. In 1962, the inventors sold their patent to the Philco corporation, which later sold it to RCA. It wasn''t until 1972 that RCA tested the bullseye barcode in a Kroger supermarket in Cincinnati.

(D) The Kroger trial revealed a critical flaw: the printing presses of the era often smeared ink in the direction the paper moved. While straight lines could survive a little smudging, the circular bullseye became distorted and unreadable. The retail industry realized they needed an industry-wide standard and formed a committee to evaluate different designs. IBM engineer George Laurer stepped in, discarding Woodland’s circular design in favor of a rectangular pattern that could withstand ink smudging. Laurer''s design became known as the Universal Product Code (UPC).

(E) On June 26, 1974, at a Marsh supermarket in Troy, Ohio, a pack of Wrigley’s Juicy Fruit chewing gum became the first retail product ever sold using a barcode scanner. Following this successful scan, adoption of the UPC exploded. The barcode revolutionized global commerce, allowing for instantaneous price lookup, radically reducing human error at the checkout, and transforming inventory management into a highly precise science.');

-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('68c9bb72-4163-46e2-9954-1c43a37f8e2e', 'b569b159-116b-40de-af56-fc33c910c3ba', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the passage? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('88a65ff4-9ec0-4b62-a271-8fc06c834839', '68c9bb72-4163-46e2-9954-1c43a37f8e2e', 1,
 'Silver and Woodland met while they were working at a grocery store in Philadelphia.', 'FALSE', '["FALSE","False","false"]'),
('77861d49-1cd3-4a27-a367-b78432afabe6', '68c9bb72-4163-46e2-9954-1c43a37f8e2e', 2,
 'Woodland''s first visual concept for the barcode was inspired by Morse code.', 'TRUE', '["TRUE","True","true"]'),
('cd2dbe30-3e97-471b-8799-353d38a056f8', '68c9bb72-4163-46e2-9954-1c43a37f8e2e', 3,
 'The dean of the Drexel Institute provided funding for Silver and Woodland’s research.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('bfb558ac-509f-4c79-8cf6-e797c098a565', '68c9bb72-4163-46e2-9954-1c43a37f8e2e', 4,
 'George Laurer invented the circular "bullseye" barcode to prevent printing errors.', 'FALSE', '["FALSE","False","false"]');

-- ── Group 2: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('069c1bd0-cde9-4ae0-92ae-c9b5b42d1d79', 'b569b159-116b-40de-af56-fc33c910c3ba', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN THREE WORDS from the passage for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('cd6ed035-22ad-4942-af4d-d18bab68b5fb', '069c1bd0-cde9-4ae0-92ae-c9b5b42d1d79', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"Inventor / Designer","answer":""},{"id":"h2","gapText":"Design / Technology","answer":""},{"id":"h3","gapText":"Drawback / Outcome","answer":""}]'),
('fdaf41bf-cfb3-4857-a657-80271a1b35a9', '069c1bd0-cde9-4ae0-92ae-c9b5b42d1d79', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"Silver & Woodland","answer":""},{"id":"c2","gapText":"Ultraviolet (UV) ink","answer":""},{"id":"c3","gapText":"Equipment was expensive and ink {{gap}}","answer":"faded quickly"}]'),
('df45634d-0f0c-44f1-986a-9d32ccc98cba', '069c1bd0-cde9-4ae0-92ae-c9b5b42d1d79', 7,
 'Row 3', '',
 '[{"id":"c4","gapText":"Woodland","answer":""},{"id":"c5","gapText":"Circular bullseye","answer":""},{"id":"c6","gapText":"Became unreadable due to {{gap}} from printing presses","answer":"smearing"}]'),
('dfdd4040-863b-4cc8-8afb-39ae342b6147', '069c1bd0-cde9-4ae0-92ae-c9b5b42d1d79', 8,
 'Row 4', '',
 '[{"id":"c7","gapText":"George Laurer","answer":""},{"id":"c8","gapText":"Rectangular shape known as the {{gap}}","answer":"Universal Product Code"}]'),
('ff229f4a-81cf-43d7-ab0e-45134598b83e', '069c1bd0-cde9-4ae0-92ae-c9b5b42d1d79', 9,
 'Row 5', '',
 '[{"id":"c10","gapText":"Global Retail Industry","answer":""},{"id":"c11","gapText":"Worldwide standard adoption","answer":""},{"id":"c12","gapText":"Transformed {{gap}} into a highly precise science","answer":"inventory management"}]');

-- ── Group 3: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('2ddfff1f-3e3c-46a4-b6d2-d1d7ff5a427b', 'b569b159-116b-40de-af56-fc33c910c3ba', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS from the passage for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('37460a41-71c0-4eaa-92a6-a1d24e83373d', '2ddfff1f-3e3c-46a4-b6d2-d1d7ff5a427b', 10,
 'Where did Norman Joseph Woodland relocate to work exclusively on his invention?', 'Florida', '[{"id":"1","text":"Florida"}]'),
('25e124a9-e8aa-4868-8683-3ad4f204b5fb', '2ddfff1f-3e3c-46a4-b6d2-d1d7ff5a427b', 11,
 'What corporation originally purchased the barcode patent from Woodland and Silver in 1962?', 'Philco corporation', '[{"id":"1","text":"Philco corporation"},{"id":"2","text":"Philco"}]'),
('b2774e6a-f27f-4f5c-aa56-860383d21a1b', '2ddfff1f-3e3c-46a4-b6d2-d1d7ff5a427b', 12,
 'In what shape was George Laurer’s successful barcode redesign?', 'rectangular', '[{"id":"1","text":"rectangular"},{"id":"2","text":"rectangular pattern"}]'),
('26f4c2d3-531b-47bc-8586-bc26cb740291', '2ddfff1f-3e3c-46a4-b6d2-d1d7ff5a427b', 13,
 'What exact product was the first to be scanned at a retail checkout in 1974?', 'chewing gum', '[{"id":"1","text":"chewing gum"},{"id":"2","text":"Juicy Fruit gum"},{"id":"3","text":"Juicy Fruit chewing gum"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: The Ecological Role of the Sea Otter (Q14–27)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('a873c68a-1e91-42f3-a734-d9e98bd5735b', 'af23d8b2-f092-4e5b-bd38-77a627d173db', 2,
 'The Ecological Role of the Sea Otter',
 '(A) In ecology, a "keystone species" is a plant or animal that plays a unique and crucial role in the way an ecosystem functions. Without keystone species, the ecosystem would be dramatically different or cease to exist altogether, much like an arch collapsing without its central keystone. One of the most famous and extensively studied examples of a keystone species is the sea otter (Enhydra lutris), a marine mammal native to the coasts of the northern and eastern North Pacific Ocean.

(B) The importance of the sea otter to its habitat became tragically apparent during the 18th and 19th centuries. Possessing the densest fur of any animal on Earth, sea otters were hunted to the brink of extinction by maritime fur traders. By the early 1900s, the global population, which once numbered in the hundreds of thousands, had plummeted to fewer than 2,000 individuals scattered in isolated colonies. The near-eradication of the sea otter triggered a devastating "trophic cascade"—an ecological phenomenon triggered by the removal of a top predator, which results in dramatic changes to the populations of species lower down the food chain.

(C) The primary prey of the sea otter is the sea urchin, a spiky, spherical echinoderm that feeds voraciously on kelp. In a healthy ecosystem, sea otters keep the urchin population in check. However, with the otters gone, sea urchin populations exploded. These massive armies of urchins scoured the ocean floor, consuming the holdfasts (root-like structures) of the giant kelp, severing the kelp fronds from the seabed. This led to the widespread destruction of kelp forests, replacing them with barren expanses of rock known as "urchin barrens." The loss of the kelp forests was catastrophic, as they provided essential nursery habitats and food sources for hundreds of species of fish, crabs, and other marine life.

(D) The sea otter was eventually saved from absolute extinction by the signing of the International Fur Seal Treaty in 1911, which banned commercial hunting. In the 1970s, significant conservation efforts, including the relocation of otters to their historic ranges along the North American coast, helped jumpstart their recovery. As the otters returned, they consumed the excess sea urchins, which allowed the kelp forests to regenerate. The return of the kelp forests brought a resurgence of biodiversity, clearly demonstrating the otter’s keystone role.

(E) Despite these successes, the modern sea otter faces a complex web of new threats. Oil spills are particularly lethal; because otters rely on their fur rather than blubber for insulation, a coating of oil destroys their fur’s water-repellent properties, leading to fatal hypothermia. Furthermore, in regions like the Aleutian Islands, sea otter populations have inexplicably crashed in recent years. Researchers theorize that killer whales (orcas) have begun preying on sea otters. It is believed that the orcas'' traditional prey—great whales and seals—have declined due to commercial whaling and climate change, forcing the orcas to switch to smaller, less caloric prey like the sea otter.

(F) The recovery of the sea otter has also sparked significant economic debate. While conservationists and ecotourism operators celebrate their return, commercial and recreational fishers often view sea otters as aggressive competitors. Otters consume large quantities of commercially valuable shellfish, such as abalone, Dungeness crab, and sea urchins. In some areas, the return of the sea otter has essentially eliminated local commercial shellfisheries. This conflict highlights the complicated reality of ecosystem restoration: returning an environment to its natural, balanced state can sometimes conflict with established human economic interests.');

-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('5d2dfda4-1c08-4332-8b2a-24f9038f4991', 'a873c68a-1e91-42f3-a734-d9e98bd5735b', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. Conflicting financial interests", "ii. The destruction of underwater forests", "iii. The definition of a crucial ecological concept", "iv. Finding new locations for kelp forests", "v. New and emerging dangers for the species", "vi. The historical exploitation and its immediate aftermath", "vii. How killer whales communicate underwater", "viii. Legal protection and efforts to rebuild populations"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('75bec7c8-81ec-4f75-92fb-ce6f37ecddab', '5d2dfda4-1c08-4332-8b2a-24f9038f4991', 14, 'Paragraph A', 'iii'),
('4ed662c0-96c7-4ac8-9d1d-75a447074bf4', '5d2dfda4-1c08-4332-8b2a-24f9038f4991', 15, 'Paragraph B', 'vi'),
('e280b223-3260-4301-bd5c-df0db549b6c3', '5d2dfda4-1c08-4332-8b2a-24f9038f4991', 16, 'Paragraph C', 'ii'),
('2e756fd8-28ea-458c-bb0e-116a7cc00452', '5d2dfda4-1c08-4332-8b2a-24f9038f4991', 17, 'Paragraph D', 'viii'),
('328bb551-491d-4dbc-920f-ff279c0eb67f', '5d2dfda4-1c08-4332-8b2a-24f9038f4991', 18, 'Paragraph E', 'v'),
('257701ee-0d31-456a-bc97-28b30d42bfe6', '5d2dfda4-1c08-4332-8b2a-24f9038f4991', 19, 'Paragraph F', 'i');

-- ── Group 5: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('a15dbb9c-7262-44e9-9aea-fc66ecf369a0', 'a873c68a-1e91-42f3-a734-d9e98bd5735b', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('03e56852-9fc9-41c5-acdd-aa1a372f5977', 'a15dbb9c-7262-44e9-9aea-fc66ecf369a0', 20,
 'A description of how a particular marine plant is destroyed by an exploding population.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('82fc5691-fde8-4511-83b5-1b5eda06d6fa', 'a15dbb9c-7262-44e9-9aea-fc66ecf369a0', 21,
 'Mention of a shift in the hunting habits of a large marine predator.', 'E',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('497daa31-ef9e-4890-9caa-f08897feff05', 'a15dbb9c-7262-44e9-9aea-fc66ecf369a0', 22,
 'An argument that returning ecosystems to their natural state can harm human livelihoods.', 'F',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('e4e7c1cc-1250-4517-b5fb-aa11becfdbf6', 'a15dbb9c-7262-44e9-9aea-fc66ecf369a0', 23,
 'The name of the international treaty that ultimately saved the species from extinction.', 'D',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');

-- ── Group 6: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('07ecd070-8448-42d9-8fe3-85519b7ae639', 'a873c68a-1e91-42f3-a734-d9e98bd5735b', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('b2f6753b-89a0-441b-bd35-939b84097b54', '07ecd070-8448-42d9-8fe3-85519b7ae639', 24,
 'Sea otters are considered a "keystone species" because they:',
 'C',
 '[{"id":"A","text":"A. Provide a vital food source for traditional maritime hunters.","isCorrect":false},{"id":"B","text":"B. Are the only marine mammals with highly insulated fur.","isCorrect":false},{"id":"C","text":"C. Have a disproportionately large and crucial impact on their ecosystem.","isCorrect":true},{"id":"D","text":"D. Migrate across vast expanses of the North Pacific Ocean.","isCorrect":false}]'),
('db5fb242-1d7c-450e-a680-7600b96c12c9', '07ecd070-8448-42d9-8fe3-85519b7ae639', 25,
 'According to the passage, "urchin barrens" are formed when:',
 'A',
 '[{"id":"A","text":"A. An overpopulation of sea urchins consumes all the kelp holdfasts.","isCorrect":true},{"id":"B","text":"B. Sea otters eat too many urchins, leaving bare rocks.","isCorrect":false},{"id":"C","text":"C. Chemical changes in the water kill off fish and crabs.","isCorrect":false},{"id":"D","text":"D. Oil spills destroy the underlying root systems of aquatic plants.","isCorrect":false}]'),
('f3a38b74-e52e-4dd4-966f-114cf5a88ada', '07ecd070-8448-42d9-8fe3-85519b7ae639', 26,
 'What is believed to have caused killer whales to begin preying on sea otters?',
 'B',
 '[{"id":"A","text":"A. A sudden increase in sea otter populations across the Aleutian Islands.","isCorrect":false},{"id":"B","text":"B. A sharp decline in the availability of their usual mammalian prey.","isCorrect":true},{"id":"C","text":"C. The introduction of the International Fur Seal Treaty in 1911.","isCorrect":false},{"id":"D","text":"D. Aggressive competition from commercial and recreational fishers.","isCorrect":false}]'),
('92f553e8-dfbc-48c0-a119-16c9be454149', '07ecd070-8448-42d9-8fe3-85519b7ae639', 27,
 'What is the main point of the final paragraph?',
 'D',
 '[{"id":"A","text":"A. Ecotourism is a more profitable industry than commercial fishing.","isCorrect":false},{"id":"B","text":"B. Sea otters should be relocated to avoid competing with humans.","isCorrect":false},{"id":"C","text":"C. Shellfish stocks are declining globally due to ocean acidification.","isCorrect":false},{"id":"D","text":"D. The recovery of the sea otter brings mixed economic consequences for humans.","isCorrect":true}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: The Psychology of Nostalgia (Q28–40)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('53441151-62d6-4fef-a606-9823cfe9e25e', 'af23d8b2-f092-4e5b-bd38-77a627d173db', 3,
 'The Psychology of Nostalgia',
 '(A) The word "nostalgia" evokes a bittersweet longing for the past. Interestingly, the term was originally coined in 1688 by a Swiss medical student named Johannes Hofer to describe a very different phenomenon: a severe, sometimes fatal medical disease. Hofer used the term (from the Greek "nostos" for homecoming and "algos" for pain) to diagnose the intense physical homesickness experienced by Swiss mercenaries fighting in foreign lands. Symptoms included melancholia, loss of appetite, and fainting. For centuries, nostalgia was treated as a psychiatric disorder. Only in the late 20th century did psychologists begin to view nostalgia not as a malady, but as a complex, broadly experienced, and often beneficial human emotion.

(B) The physical triggers of nostalgia are deeply rooted in the brain’s anatomy. The olfactory bulb, the brain structure responsible for processing smells, has direct neural connections to the amygdala and the hippocampus—regions strongly implicated in emotion and memory. This explains the "Proustian moment," named after author Marcel Proust, who famously described how the scent and taste of a madeleine cake instantly transported him back to his childhood. Auditory stimuli, such as a song from one’s teenage years, can similarly act as a powerful neural catalyst, instantly resurrecting dormant emotional landscapes.

(C) Far from being a sign of mental weakness, contemporary research suggests that nostalgia serves a critical psychological function. Dr. Constantine Sedikides, a leading researcher in the field, argues that nostalgia acts as an existential buffer. His studies demonstrate that engaging in nostalgic reflection temporarily increases an individual’s self-esteem, fosters a sense of social connectedness, and enhances their perception of meaning in life. When people look back fondly on their past, they are typically recalling moments of triumph, warmth, and close relationships, which provides a psychological defense against current stresses.

(D) Because of its protective properties, nostalgia is often utilized as a coping mechanism during difficult times. Research shows that people are significantly more likely to experience nostalgia during periods of major life transition, feelings of loneliness, or existential crisis. By retreating into the comforting familiarity of the past, individuals can stabilize their sense of identity and find the psychological anchor needed to navigate present uncertainties. It is a psychological immune response that helps maintain emotional equilibrium.

(E) However, there is a darker, socio-political side to this emotion, often referred to as historical nostalgia. Cultural theorist Svetlana Boym distinguished between two distinct types of nostalgia: "reflective" and "restorative." Reflective nostalgia is a personal, bittersweet longing that accepts the past is gone and simply dwells in the emotional resonance of memory. Restorative nostalgia, by contrast, is characterized by a desire to actually rebuild a lost era. This type of nostalgia often mythologizes the past, ignoring its flaws in favor of a curated, perfect history. Sociologists warn that restorative nostalgia is frequently co-opted by political movements to fuel nationalism, creating an "us versus them" dynamic based on a fictionalized past.

(F) In the commercial sphere, nostalgia has become a highly lucrative tool. Nostalgia marketing capitalizes on consumers’ yearning for simpler times to build brand trust and drive sales. By associating a product with a cherished era, advertisers can effectively bypass consumers'' rational financial decision-making processes. When a buyer purchases a retro video game console or a vintage-style soda bottle, they are not merely paying for the physical object; they are paying for the transient feeling of comfort and the temporary illusion of reclaiming their youth.');

-- ── Group 7: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('20902105-5f9b-4bd9-aa6c-fba209ed8883', '53441151-62d6-4fef-a606-9823cfe9e25e', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d781bc06-d53d-4cbe-983f-957d20bc5e6c', '20902105-5f9b-4bd9-aa6c-fba209ed8883', 28,
 'Johannes Hofer considered nostalgia to be a serious and potentially fatal medical illness.', 'YES', '["YES","Yes","yes"]'),
('7b03199b-856d-48d9-a31a-47cc6ef25383', '20902105-5f9b-4bd9-aa6c-fba209ed8883', 29,
 'The olfactory bulb processes visual memories more efficiently than auditory ones.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('0a098343-89b7-435c-965b-be7bae741487', '20902105-5f9b-4bd9-aa6c-fba209ed8883', 30,
 'Research by Constantine Sedikides indicates that nostalgia generally decreases a person''s self-esteem.', 'NO', '["NO","No","no"]'),
('b60f70ed-7639-4a0d-b1a6-2c3a62c93a6a', '20902105-5f9b-4bd9-aa6c-fba209ed8883', 31,
 'Restorative nostalgia involves a desire to perfectly recreate an idealized version of history.', 'YES', '["YES","Yes","yes"]');

-- ── Group 8: MATCHING SENTENCE ENDINGS (Q32–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('081837d6-6aa4-43b7-901b-dba426da07f9', '53441151-62d6-4fef-a606-9823cfe9e25e', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('9fd32b6a-b358-416a-a634-2922e430ad61', '081837d6-6aa4-43b7-901b-dba426da07f9', 32,
 'The term nostalgia was originally created to describe',
 'E',
 '[{"id":"A","text":"the brain''s olfactory center is closely linked to emotion and memory.","isCorrect":false},{"id":"B","text":"create a false sense of security that worsens existential crises.","isCorrect":false},{"id":"C","text":"bypass consumers'' logical evaluation of a product''s value.","isCorrect":false},{"id":"D","text":"it is considered a sign of severe mental illness in the 21st century.","isCorrect":false},{"id":"E","text":"the intense homesickness experienced by Swiss soldiers.","isCorrect":true},{"id":"F","text":"rely on nostalgic memories as a psychological anchor.","isCorrect":false}]'),
('fe9638c4-a6a0-460e-af5e-4d5003084234', '081837d6-6aa4-43b7-901b-dba426da07f9', 33,
 'Smells are particularly effective at triggering memories because',
 'A',
 '[{"id":"A","text":"the brain''s olfactory center is closely linked to emotion and memory.","isCorrect":true},{"id":"B","text":"create a false sense of security that worsens existential crises.","isCorrect":false},{"id":"C","text":"bypass consumers'' logical evaluation of a product''s value.","isCorrect":false},{"id":"D","text":"it is considered a sign of severe mental illness in the 21st century.","isCorrect":false},{"id":"E","text":"the intense homesickness experienced by Swiss soldiers.","isCorrect":false},{"id":"F","text":"rely on nostalgic memories as a psychological anchor.","isCorrect":false}]'),
('1a2a9c5b-458e-4769-b91e-cb059b2b6406', '081837d6-6aa4-43b7-901b-dba426da07f9', 34,
 'During periods of significant life transition or loneliness, individuals tend to',
 'F',
 '[{"id":"A","text":"the brain''s olfactory center is closely linked to emotion and memory.","isCorrect":false},{"id":"B","text":"create a false sense of security that worsens existential crises.","isCorrect":false},{"id":"C","text":"bypass consumers'' logical evaluation of a product''s value.","isCorrect":false},{"id":"D","text":"it is considered a sign of severe mental illness in the 21st century.","isCorrect":false},{"id":"E","text":"the intense homesickness experienced by Swiss soldiers.","isCorrect":false},{"id":"F","text":"rely on nostalgic memories as a psychological anchor.","isCorrect":true}]'),
('9fc08c26-7f93-4987-9b59-c84ca37b0dbe', '081837d6-6aa4-43b7-901b-dba426da07f9', 35,
 'Corporations utilize nostalgia in their advertising campaigns in order to',
 'C',
 '[{"id":"A","text":"the brain''s olfactory center is closely linked to emotion and memory.","isCorrect":false},{"id":"B","text":"create a false sense of security that worsens existential crises.","isCorrect":false},{"id":"C","text":"bypass consumers'' logical evaluation of a product''s value.","isCorrect":true},{"id":"D","text":"it is considered a sign of severe mental illness in the 21st century.","isCorrect":false},{"id":"E","text":"the intense homesickness experienced by Swiss soldiers.","isCorrect":false},{"id":"F","text":"rely on nostalgic memories as a psychological anchor.","isCorrect":false}]');

-- ── Group 9: SUMMARY COMPLETION with Word Bank (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('0b673524-68a5-4d92-a34a-c32d5675d6d8', '53441151-62d6-4fef-a606-9823cfe9e25e', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["restorative", "reflective", "disease", "nationalism", "mythologized", "longing", "marketing", "future", "forgotten"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('3b1caea5-581c-4882-b2b3-80b259b4e8a2', '0b673524-68a5-4d92-a34a-c32d5675d6d8', 36,
 'Svetlana Boym categorizes nostalgia into two distinct types. The first, known as {{gap_0b673524-68a5-4d92-a34a-c32d5675d6d8_0}} nostalgia, is often associated with political {{gap_0b673524-68a5-4d92-a34a-c32d5675d6d8_1}}. It relies on the belief that a perfect, historical era can be rebuilt, even if that era is largely {{gap_0b673524-68a5-4d92-a34a-c32d5675d6d8_2}}. In contrast, {{gap_0b673524-68a5-4d92-a34a-c32d5675d6d8_3}} nostalgia does not seek to recreate the past. Instead, it simply embraces the bittersweet feeling of {{gap_0b673524-68a5-4d92-a34a-c32d5675d6d8_4}} for times gone by.',
 'restorative'),
('bb911524-f0ce-42ce-ae65-7d32a91d41c6', '0b673524-68a5-4d92-a34a-c32d5675d6d8', 37,
 '', 'nationalism'),
('23d727cb-f74f-48dc-80ac-93232e7f3d4c', '0b673524-68a5-4d92-a34a-c32d5675d6d8', 38,
 '', 'mythologized'),
('341da4ed-4c50-4625-ae04-c4c392a33ea9', '0b673524-68a5-4d92-a34a-c32d5675d6d8', 39,
 '', 'reflective'),
('75824693-805b-444e-9d38-a3e24c1eaf60', '0b673524-68a5-4d92-a34a-c32d5675d6d8', 40,
 '', 'longing');

-- ============================================================
-- NOTE: Please execute `UPDATE reading_tests SET created_by = '<your-uid>'` 
-- if required by your application's Row Level Security policies.
-- ============================================================