-- ============================================================
-- IELTS Practice Platform – Reading Test Seed Data
-- Test Type: Academic | Target Band: 8
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST RECORD                                               ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('e38beedd-01aa-436e-a15f-18ed203ca819', 'fe38ed89-f1fe-4b88-9609-8736be47f61e',
 'IELTS Academic Reading Practice: Advanced Sciences (Band 8)', 'Academic', '8', '60 mins', 'published');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: The Antikythera Mechanism (Q1–13)           ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('a2564b7d-4f3c-4b5c-b7a6-22ca5f7d3605', 'e38beedd-01aa-436e-a15f-18ed203ca819', 1,
 'The Mechanics of Ancient Astronomy: The Antikythera Mechanism',
 '(A) In 1901, a group of Greek sponge divers sheltering from a severe storm off the coast of the island of Antikythera inadvertently discovered a sprawling Roman shipwreck. Resting at a depth of 45 metres, the wreck yielded a treasure trove of magnificent bronze and marble statues, exquisite glassware, and ancient silver coins. Among these spectacular artistic treasures was a heavily corroded, unassuming lump of bronze and wood. Initially ignored by marine archaeologists in favour of the more aesthetically pleasing artefacts, the calcified block sat undisturbed in the National Archaeological Museum in Athens. It was not until 1902 that archaeologist Valerios Stais, while examining the crumbling artefact, noticed a small, precisely cut gear wheel embedded in the rock, revealing it to be a highly sophisticated mechanical device rather than a mere statue fragment.

(B) For decades, the artefact completely baffled historians and classicists alike. Its sheer mechanical complexity seemed entirely anachronistic for its estimated construction date of the 2nd century BC. At the time, conventional historical narratives dictated that while the ancient Greeks were exceptionally adept at theoretical mathematics and geometry, they lacked the practical metallurgical and engineering skills required to create such a precise machine. The intricate gear trains within the Antikythera Mechanism rivalled the complexity of 18th-century European clocks. This staggering disparity led some early researchers to mistakenly assume it was a modern astrolabe that had been accidentally dropped into the ancient wreck centuries later. 

(C) The true function and origin of the mechanism were slowly unveiled through successive technological advancements in the late 20th and early 21st centuries. In the 1970s, British science historian Derek de Solla Price used early 2D X-ray imaging to count the gear teeth, proposing it was an astronomical computer designed to calculate celestial positions. Later, in 2005, the Antikythera Mechanism Research Project (AMRP) employed cutting-edge microfocus X-ray computed tomography to peer inside the remaining fragments without causing physical damage. They revealed a sophisticated, hand-powered orrery capable of tracking the Metonic cycle (the 19-year lunar calendar), charting the movements of the five classical planets, and accurately predicting lunar and solar eclipses using the 223-month Saros cycle.

(D) The specific creator of the device remains entirely unknown, though many prominent scholars theorise it may have been constructed by, or under the guidance of, the eminent ancient Greek astronomer Hipparchus. This hypothesis is supported by the machine''s mechanical incorporation of Hipparchus''s theory regarding the moon''s elliptical orbit, which explained its variable speed across the sky. Tragically, the trajectory of this mechanical genius was abruptly cut short. The expanding Roman conquest of the Mediterranean, which culminated in the systematic looting of Greek city-states, fundamentally shifted the regional cultural focus from scientific inquiry and philosophy to imperial administration, military engineering, and warfare. The ship carrying the mechanism was, in all likelihood, a Roman vessel transporting looted Greek treasures back to Rome when it sank.

(E) The Antikythera Mechanism fundamentally rewrites the history of technology. It proves unequivocally that ancient engineers possessed a profound, applied understanding of kinematics, capable of translating highly complex astronomical cycles into miniature bronze gears. Following the eventual collapse of the Greco-Roman world, this astonishing level of mechanical sophistication disappeared entirely from the historical record, only re-emerging during the European Renaissance over a millennium later. It stands as a profound testament to a lost technological revolution, leaving modern historians to wonder what other mechanical marvels the ancient world might have produced had its intellectual trajectory not been severed.');


-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('1a71c25b-36fd-4f36-b1a5-45602449906e', 'a2564b7d-4f3c-4b5c-b7a6-22ca5f7d3605', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the passage? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('11a8b648-8133-4009-9953-7f059e74df4c', '1a71c25b-36fd-4f36-b1a5-45602449906e', 1,
 'The sponge divers immediately recognised the scientific significance of the bronze mechanism in 1901.', 'FALSE', '["FALSE","False","false"]'),
('421d8522-6065-4d19-b6c6-442f7e2b1946', '1a71c25b-36fd-4f36-b1a5-45602449906e', 2,
 'Early historians believed the ancient Greeks were incapable of producing such precise metallurgical engineering.', 'TRUE', '["TRUE","True","true"]'),
('76e9f27a-f022-4564-b3c2-bad5199e6b60', '1a71c25b-36fd-4f36-b1a5-45602449906e', 3,
 'Derek de Solla Price built a fully functioning physical replica of the device to prove his theories.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('0be1ca32-adfa-4bbb-b21f-515a3daead40', '1a71c25b-36fd-4f36-b1a5-45602449906e', 4,
 'The device incorporated mathematical theories regarding the variable speed of the moon.', 'TRUE', '["TRUE","True","true"]');


-- ── Group 2: TABLE COMPLETION (Q5–8) ──────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('b6dd143f-4e08-41ef-869b-48a206d0967e', 'a2564b7d-4f3c-4b5c-b7a6-22ca5f7d3605', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('e1152689-f4c9-43aa-a410-b3802e1fb277', 'b6dd143f-4e08-41ef-869b-48a206d0967e', 5,
 'Row 1', '',
 '[{"id":"c1","gapText":"1902","answer":""},{"id":"c2","gapText":"Valerios Stais","answer":""},{"id":"c3","gapText":"Identified a","answer":"gear wheel"},{"id":"c4","gapText":"inside the rock","answer":""}]'),
('17b2f7ee-9321-4f2d-87fc-35e6d7b1f0ac', 'b6dd143f-4e08-41ef-869b-48a206d0967e', 6,
 'Row 2', '',
 '[{"id":"c5","gapText":"1970s","answer":""},{"id":"c6","gapText":"Derek de Solla Price","answer":""},{"id":"c7","gapText":"Used early X-ray imaging to count the","answer":"gear teeth"}]'),
('9805928c-6982-41a7-9d65-9ccf9fa4fd67', 'b6dd143f-4e08-41ef-869b-48a206d0967e', 7,
 'Row 3', '',
 '[{"id":"c8","gapText":"2005","answer":""},{"id":"c9","gapText":"AMRP","answer":""},{"id":"c10","gapText":"Employed microfocus","answer":"X-ray tomography"},{"id":"c11","gapText":"to view internal fragments","answer":""}]'),
('5ec77174-841e-434a-a3d5-e6ead9223d2b', 'b6dd143f-4e08-41ef-869b-48a206d0967e', 8,
 'Row 4', '',
 '[{"id":"c12","gapText":"1st Century BC","answer":""},{"id":"c13","gapText":"Romans","answer":""},{"id":"c14","gapText":"Looted the device during their expanding","answer":"Roman conquest"},{"id":"c15","gapText":"of the Mediterranean","answer":""}]');


-- ── Group 3: SHORT ANSWER (Q9–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('01e67076-4ecb-45f8-aa87-1bc4c691f158', 'a2564b7d-4f3c-4b5c-b7a6-22ca5f7d3605', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS from the passage for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('36844375-2571-4a0d-9f72-832c78d57775', '01e67076-4ecb-45f8-aa87-1bc4c691f158', 9,
 'What specific celestial cycle did the mechanism utilise to predict eclipses?', 'Saros cycle', '[{"id":"1","text":"Saros cycle"},{"id":"2","text":"the Saros cycle"}]'),
('9f42a10d-fa1f-45e9-b112-e662771eb456', '01e67076-4ecb-45f8-aa87-1bc4c691f158', 10,
 'Which eminent Greek astronomer is most commonly theorised to be the device''s creator?', 'Hipparchus', '[{"id":"1","text":"Hipparchus"}]'),
('bd570036-c7d8-48d2-9263-fbb9685f495e', '01e67076-4ecb-45f8-aa87-1bc4c691f158', 11,
 'What was the primary material the device was originally manufactured from?', 'bronze', '[{"id":"1","text":"bronze"}]'),
('d23851c2-d528-4186-adcb-6994e643e7ed', '01e67076-4ecb-45f8-aa87-1bc4c691f158', 12,
 'During which later historical period did comparable mechanical complexity finally reappear in Europe?', 'European Renaissance', '[{"id":"1","text":"European Renaissance"},{"id":"2","text":"the European Renaissance"}]'),
('cb1cbcf7-cc34-4ded-83f0-aaa007d0f1c9', '01e67076-4ecb-45f8-aa87-1bc4c691f158', 13,
 'What type of ancient vessel was likely transporting the mechanism when it sank?', 'Roman vessel', '[{"id":"1","text":"Roman vessel"},{"id":"2","text":"a Roman vessel"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Soil Microbiomes (Q14–27)                   ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('df8aeea9-f33d-403c-9c3f-3a5c2cf04f72', 'e38beedd-01aa-436e-a15f-18ed203ca819', 2,
 'The Ecology of Soil Microbiomes and Agricultural Resilience',
 '(A) For much of modern agricultural history, soil has been treated fundamentally as an inert physical medium—a mere structural anchor designed to hold roots and absorb synthetic chemical inputs. However, contemporary ecological science has completely overturned this reductive paradigm, revealing the soil, particularly the rhizosphere (the narrow biological region immediately surrounding plant roots), as one of the most biodiverse, competitive, and biologically active ecosystems on Earth. To provide scale, a single teaspoon of healthy, undisturbed agricultural soil can contain over a billion bacteria, several miles of microscopic fungal filaments, and tens of thousands of species of protozoa and nematodes, all locked in a ceaseless biochemical dialogue.

(B) Central to this subterranean ecosystem are mycorrhizal fungi, ancient organisms which form deeply symbiotic relationships with over 80 percent of all terrestrial plant species. These microscopic fungi effectively act as secondary root systems. They extend their hyphae—thread-like structures—far beyond the plant''s own roots to access remote moisture and extract essential, chemically bound minerals, particularly phosphorus, from the soil matrix. In return for these vital services, the host plant deliberately secretes a substantial portion of its photosynthesised carbon directly into the soil as root exudates—a highly targeted, sugary chemical cocktail designed to feed and cultivate its specific microbial community. Furthermore, these fungal networks produce a sticky, recalcitrant glycoprotein called glomalin, which binds loose soil particles into highly stable aggregates, thereby preventing catastrophic erosion and vastly improving the soil''s water infiltration and retention capacities.

(C) The global advent of conventional, industrialised farming has, unfortunately, severely compromised this delicate microbial matrix. Deep mechanical tillage, a standard practice for weed control and seedbed preparation, routinely slices through delicate fungal networks, physically destroying the structural and biological integrity of the soil. Simultaneously, the heavy, continual application of synthetic nitrogen and phosphorus fertilisers creates a state of artificial nutrient abundance. Consequently, plants register this abundance and actively cease releasing root exudates, effectively starving their symbiotic microbial partners. Over time, the soil microbiome collapses entirely, leaving the crops exclusively dependent on continuous artificial inputs—a dangerous ecological spiral that leading agronomists refer to as chemical dependency.

(D) As the global climate inevitably becomes increasingly volatile, the severe consequences of operating with degraded soil microbiomes are becoming painfully apparent. Conversely, robust microbial communities confer extraordinary, multifaceted resilience to environmental stressors. Certain strains of soil bacteria naturally produce specific enzymatic compounds that actively prime the host plant''s innate immune system, enabling it to fend off viral pathogens and voracious pests much more effectively than isolated plants. During periods of severe drought, intact, vast fungal networks can physically transport retained water from deep subterranean reserves directly to the plant roots, significantly enhancing drought tolerance and ensuring crop survival even when adjacent, conventionally managed fields succumb to the heat.

(E) Acknowledging these complex dynamics, a rapidly growing vanguard of commercial farmers and academic researchers are pioneering regenerative agricultural practices aimed strictly at microbial recovery. Techniques such as continuous no-till farming, the strategic integration of multi-species cover crops to ensure living roots are present year-round, and the precise application of biologically rich bio-inoculants are purposefully designed to re-establish and nurture soil life. However, transitioning to these regenerative methods requires considerable patience and financial fortitude; as the soil biology painstakingly regenerates, farmers almost universally experience a temporary, albeit sharp, decline in crop yields before the new ecological balance stabilises and natural fertility is fully restored.

(F) Looking forward, the seamless integration of microbiology with cutting-edge digital technology promises to revolutionise global farming operations. Precision agriculture is increasingly incorporating advanced microbial mapping, allowing farmers to understand and target the specific biological deficits of their land at a granular level. Furthermore, rapid advancements in genomic sequencing are actively enabling scientists to isolate, identify, and cultivate highly specific microbial strains that can drastically enhance soil carbon sequestration and natural nitrogen fixation, paving the way for a truly sustainable, resilient, and highly productive agricultural future.');


-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('bc596421-cde2-4e4e-ab21-c911b6b0343b', 'df8aeea9-f33d-403c-9c3f-3a5c2cf04f72', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. The vital role of fungal networks", "ii. A paradigm shift in soil perception", "iii. Navigating the regenerative transition", "iv. Technological frontiers in soil mapping", "v. The chemical dependency of modern farming", "vi. Enhancing drought and disease resistance", "vii. The historical origins of agriculture", "viii. Synthesizing artificial fertilizers"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('3a6f7bc2-a808-43df-afd8-1408bbca3c17', 'bc596421-cde2-4e4e-ab21-c911b6b0343b', 14, 'Paragraph A', 'ii'),
('b4cdfb7c-8f74-4692-bd54-c2449a1f29b7', 'bc596421-cde2-4e4e-ab21-c911b6b0343b', 15, 'Paragraph B', 'i'),
('c09482b3-2599-4969-bc18-cfa3553bbfbc', 'bc596421-cde2-4e4e-ab21-c911b6b0343b', 16, 'Paragraph C', 'v'),
('b6531a5c-2d3c-41fd-a3a3-77a273f15468', 'bc596421-cde2-4e4e-ab21-c911b6b0343b', 17, 'Paragraph D', 'vi'),
('26154bd4-d991-4d26-a8d2-99a3a1f25f59', 'bc596421-cde2-4e4e-ab21-c911b6b0343b', 18, 'Paragraph E', 'iii'),
('49c88ae7-814c-4e3d-9b6f-ec71752f5558', 'bc596421-cde2-4e4e-ab21-c911b6b0343b', 19, 'Paragraph F', 'iv');


-- ── Group 5: MATCHING INFORMATION (Q20–24) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('dea4cc27-6f2e-4f4e-b719-cdc2d4475ac6', 'df8aeea9-f33d-403c-9c3f-3a5c2cf04f72', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('810c7cfd-91ba-404a-b201-f4619671a383', 'dea4cc27-6f2e-4f4e-b719-cdc2d4475ac6', 20,
 'A description of a specific protein that maintains the structural integrity of the earth.', 'B',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('74887709-5175-4bf2-8bb5-389ffeb2b7bf', 'dea4cc27-6f2e-4f4e-b719-cdc2d4475ac6', 21,
 'An explanation of why transitioning to sustainable farming methods initially reduces harvest output.', 'E',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('ae3fcd7c-f05c-4072-b25b-a1f6f1e32a17', 'dea4cc27-6f2e-4f4e-b719-cdc2d4475ac6', 22,
 'The estimated quantity of microscopic organisms found in a tiny, undisturbed soil sample.', 'A',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('7c75c860-fbe1-4c7c-bd4b-4b9ffeb4d573', 'dea4cc27-6f2e-4f4e-b719-cdc2d4475ac6', 23,
 'How an intact microbiome can help crops survive severe, prolonged water shortages.', 'D',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('b48ad920-962f-48c2-ba7a-cba8a5df68d6', 'dea4cc27-6f2e-4f4e-b719-cdc2d4475ac6', 24,
 'The practice of evaluating a specific farm''s biological deficits using modern genomic technology.', 'F',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');


-- ── Group 6: MULTIPLE CHOICE (Q25–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('b4d8c216-1a13-427d-9c73-74192f147d5a', 'df8aeea9-f33d-403c-9c3f-3a5c2cf04f72', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('676b98a2-2f66-47e8-bd59-bed6dbaf7d38', 'b4d8c216-1a13-427d-9c73-74192f147d5a', 25,
 'According to Paragraph C, the heavy application of synthetic fertilisers ultimately results in',
 'B',
 '[{"id":"A","text":"A. an uncontrollable overgrowth of fungal hyphae.","isCorrect":false},{"id":"B","text":"B. plants actively ceasing to feed their microbial partners.","isCorrect":true},{"id":"C","text":"C. an immediate and permanent collapse of all crop yields.","isCorrect":false},{"id":"D","text":"D. the physical destruction of the soil''s geometric structure.","isCorrect":false}]'),
('15e79081-299c-48f8-b4f7-1569017019a2', 'b4d8c216-1a13-427d-9c73-74192f147d5a', 26,
 'What is a key benefit of the enzymatic compounds produced by certain soil bacteria, as mentioned in Paragraph D?',
 'C',
 '[{"id":"A","text":"A. They directly attack and kill agricultural pests.","isCorrect":false},{"id":"B","text":"B. They act as a total substitute for water during droughts.","isCorrect":false},{"id":"C","text":"C. They proactively stimulate the plant''s natural immune defences.","isCorrect":true},{"id":"D","text":"D. They prevent the need for any future chemical interventions.","isCorrect":false}]'),
('5bfac454-784a-4196-8518-fc95b777c6e1', 'b4d8c216-1a13-427d-9c73-74192f147d5a', 27,
 'What is the primary purpose of the writer in this passage?',
 'D',
 '[{"id":"A","text":"A. To argue strictly against all forms of modern technological agriculture.","isCorrect":false},{"id":"B","text":"B. To calculate the economic benefits of reducing synthetic fertiliser usage.","isCorrect":false},{"id":"C","text":"C. To detail the exhaustive history of farming practices since the industrial revolution.","isCorrect":false},{"id":"D","text":"D. To highlight the profound ecological importance of the soil microbiome and its restoration.","isCorrect":true}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: The Illusion of Conscious Will (Q28–40)     ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('ba648949-9961-4790-af50-c8e8aeb4ffc4', 'e38beedd-01aa-436e-a15f-18ed203ca819', 3,
 'The Illusion of Conscious Will: Neurobiological Perspectives',
 '(A) The subjective, internal experience of conscious will—the profound feeling that "I" am the independent author of my own actions—is so fundamentally woven into human existence that it forms the undisputed bedrock of our personal identities, our complex social interactions, and our entire legal and judicial systems. However, a rapidly growing body of sophisticated neurobiological research suggests that this deeply intuitive sense of agency may, in fact, be an elaborate cognitive illusion generated by the brain after the fact. The origins of this fiercely controversial scientific perspective can be directly traced back to the groundbreaking experiments conducted by neurophysiologist Benjamin Libet in the early 1980s.

(B) Libet asked volunteer participants to perform a highly simple, spontaneous motor task, such as flicking their wrist or pressing a button, whenever they arbitrarily felt the urge to do so. Crucially, they were also asked to note the exact, precise moment they became consciously aware of their intention to move by watching a rapidly rotating dot on a specially designed clock face. Simultaneously, Libet meticulously monitored their cortical brain activity using continuous electroencephalography (EEG). The empirical results were startling and deeply unsettling to traditional philosophers. The EEG revealed a distinct buildup of neurological activity in the motor cortex—a measurable electrical phenomenon known as the readiness potential (Bereitschaftspotential)—which demonstrably began approximately 350 milliseconds before the participants reported any conscious awareness of their intention to act.

(C) The philosophical implication of Libet’s findings was profound: the physical brain had already subconsciously initiated the action before the conscious mind was even tangentially aware of it. Eminent Harvard psychologist Daniel Wegner later expanded significantly upon these findings in his seminal book, "The Illusion of Conscious Will". Wegner argued aggressively for an epiphenomenalist view of human consciousness, suggesting that conscious will is merely a secondary, passive byproduct of underlying brain activity rather than an active driving force. According to Wegner’s framework, the brain simultaneously generates both the physical action and the subsequent conscious thought about the action, creating a compelling but entirely false perception of causality. Interestingly, Libet himself was deeply uncomfortable with absolute determinism and subsequently proposed the concept of "free won’t"—the hypothesis that while the brain unconsciously initiates an impulse, the conscious mind retains a brief 100-millisecond window to actively veto or suppress the action before it physically occurs.

(D) More recent technological advancements have pushed this deterministic view even further into the mainstream. Renowned neuroscientist John-Dylan Haynes utilised advanced functional magnetic resonance imaging (fMRI) to study the hidden mechanics of decision-making. In his highly publicised experiments, participants were asked to freely choose between pressing a button with their left or right hand. By aggressively analysing the real-time fMRI data using advanced machine learning pattern-recognition algorithms, Haynes’s research team discovered they could accurately predict which hand the participant would ultimately choose up to ten full seconds before the participant was consciously aware of having made their own decision. This research provides exceptionally compelling empirical evidence that our choices are determined by completely unconscious neural processes long before they ever enter our conscious awareness.

(E) If the traditional, libertarian concept of free will is indeed a comforting neurobiological fiction, the societal implications are practically staggering. The philosophical stance of incompatibilism actively asserts that a strictly deterministic universe is fundamentally incompatible with the concept of moral responsibility. Our entire legal and justice system is firmly predicated on the core assumption that individuals possess the conscious, independent agency to rationally choose between right and wrong. If a violent criminal act is merely the inevitable, inescapable result of unconscious neural events strictly preceding the conscious intention, the philosophical justification for retributive justice—punishing individuals simply because they "deserve" it—begins to crumble, shifting the institutional focus entirely toward rehabilitative justice and proactive societal protection.

(F) Despite the immense weight of this neurobiological evidence, many prominent philosophers and cognitive scientists urge extreme caution regarding these conclusions. Critics frequently point out that the sterile laboratory tasks used in these deterministic experiments—spontaneously flicking a wrist or pressing a plastic button for absolutely no particular reason—are completely divorced from the complex, deliberate, and deeply meaningful decision-making processes that actually define human life. Deciding to marry a partner, pursue a specific, gruelling career path, or commit a premeditated crime involves prolonged conscious deliberation, the careful weighing of long-term consequences, and the active integration of abstract personal values—a macroscopic cognitive process vastly different from simply generating a random motor impulse in a scanner. Until neuroscience can accurately predict these complex, real-world, highly deliberative choices, the fierce debate over conscious will remains far from settled.');


-- ── Group 7: YES/NO/NOT GIVEN (Q28–32) ────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('ba3b8170-bfac-464f-8b47-6e96a5aca976', 'ba648949-9961-4790-af50-c8e8aeb4ffc4', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('89d83dbe-6ffd-4fa0-bc3e-b41a9e48352a', 'ba3b8170-bfac-464f-8b47-6e96a5aca976', 28,
 'Benjamin Libet''s experiments proved unequivocally that humans have absolutely no control over their actions.', 'NO', '["NO","No","no"]'),
('6f80aa1a-fe04-474f-bf13-35444d09926a', 'ba3b8170-bfac-464f-8b47-6e96a5aca976', 29,
 'Daniel Wegner argued that the conscious will is merely an afterthought rather than a driving force of action.', 'YES', '["YES","Yes","yes"]'),
('5d92cf4d-519e-42a4-846e-a8d8d4f9ed9f', 'ba3b8170-bfac-464f-8b47-6e96a5aca976', 30,
 'John-Dylan Haynes''s research contradicted the core findings of Libet''s original EEG experiments.', 'NO', '["NO","No","no"]'),
('bac84eed-b8f8-4494-8ad6-72e1e56aea72', 'ba3b8170-bfac-464f-8b47-6e96a5aca976', 31,
 'Modern legal systems generally operate on the assumption that individuals possess free will.', 'YES', '["YES","Yes","yes"]'),
('00090587-0670-4840-9924-8e53e5fb0f85', 'ba3b8170-bfac-464f-8b47-6e96a5aca976', 32,
 'Recent studies on complex life decisions have yielded the exact same neurological results as simple button-pressing tasks.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]');


-- ── Group 8: MATCHING SENTENCE ENDINGS (Q33–36) ───────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('85b8bd28-52ef-4aef-8c1d-46db8fe5110c', 'ba648949-9961-4790-af50-c8e8aeb4ffc4', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('44f321ed-f7ba-4504-b40c-a0049adc4107', '85b8bd28-52ef-4aef-8c1d-46db8fe5110c', 33,
 'The presence of the "readiness potential" in Libet''s experiments indicates that',
 'C',
 '[{"id":"A","text":"A. consciously intercept and abort an action before it is executed.","isCorrect":false},{"id":"B","text":"B. holding individuals morally responsible for their actions is unjustified.","isCorrect":false},{"id":"C","text":"C. the brain initiates physical movement before the person is aware of the choice.","isCorrect":true},{"id":"D","text":"D. laboratory experiments do not accurately replicate complex human decision-making.","isCorrect":false},{"id":"E","text":"E. the sense of conscious agency is merely a byproduct of underlying neural events.","isCorrect":false},{"id":"F","text":"F. individuals are entirely capable of overriding deterministic neurobiology.","isCorrect":false}]'),
('934839ac-ab8e-4102-aab3-110183929a2c', '85b8bd28-52ef-4aef-8c1d-46db8fe5110c', 34,
 'Daniel Wegner’s epiphenomenalist perspective proposes that',
 'E',
 '[{"id":"A","text":"A. consciously intercept and abort an action before it is executed.","isCorrect":false},{"id":"B","text":"B. holding individuals morally responsible for their actions is unjustified.","isCorrect":false},{"id":"C","text":"C. the brain initiates physical movement before the person is aware of the choice.","isCorrect":false},{"id":"D","text":"D. laboratory experiments do not accurately replicate complex human decision-making.","isCorrect":false},{"id":"E","text":"E. the sense of conscious agency is merely a byproduct of underlying neural events.","isCorrect":true},{"id":"F","text":"F. individuals are entirely capable of overriding deterministic neurobiology.","isCorrect":false}]'),
('b7c9c8dc-d8ba-4341-b139-0277792ee919', '85b8bd28-52ef-4aef-8c1d-46db8fe5110c', 35,
 'The philosophical stance of incompatibilism argues that if neurobiology is strictly deterministic, then',
 'B',
 '[{"id":"A","text":"A. consciously intercept and abort an action before it is executed.","isCorrect":false},{"id":"B","text":"B. holding individuals morally responsible for their actions is unjustified.","isCorrect":true},{"id":"C","text":"C. the brain initiates physical movement before the person is aware of the choice.","isCorrect":false},{"id":"D","text":"D. laboratory experiments do not accurately replicate complex human decision-making.","isCorrect":false},{"id":"E","text":"E. the sense of conscious agency is merely a byproduct of underlying neural events.","isCorrect":false},{"id":"F","text":"F. individuals are entirely capable of overriding deterministic neurobiology.","isCorrect":false}]'),
('07844d7d-690c-44b8-8522-9b7aa75cf9d4', '85b8bd28-52ef-4aef-8c1d-46db8fe5110c', 36,
 'Critics urge caution regarding the findings of Libet and Haynes, pointing out that',
 'D',
 '[{"id":"A","text":"A. consciously intercept and abort an action before it is executed.","isCorrect":false},{"id":"B","text":"B. holding individuals morally responsible for their actions is unjustified.","isCorrect":false},{"id":"C","text":"C. the brain initiates physical movement before the person is aware of the choice.","isCorrect":false},{"id":"D","text":"D. laboratory experiments do not accurately replicate complex human decision-making.","isCorrect":true},{"id":"E","text":"E. the sense of conscious agency is merely a byproduct of underlying neural events.","isCorrect":false},{"id":"F","text":"F. individuals are entirely capable of overriding deterministic neurobiology.","isCorrect":false}]');


-- ── Group 9: SUMMARY COMPLETION (Q37–40) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('f9320d56-0d69-4024-a831-e384b7244fe0', 'ba648949-9961-4790-af50-c8e8aeb4ffc4', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD ONLY from the box for each answer.', true, '1',
 true, '["epiphenomenon", "veto", "readiness potential", "fMRI", "justice", "illusion", "EEG", "rehabilitative"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('03cf2044-3822-41ce-a78d-1f7950cd6a27', 'f9320d56-0d69-4024-a831-e384b7244fe0', 37,
 'Neurobiological research has significantly challenged the traditional concept of free will. Libet''s studies revealed that brain activity, known as a {{gap_f9320d56-0d69-4024-a831-e384b7244fe0_0}}, begins milliseconds prior to a person''s conscious decision to move. Wegner built upon this to describe consciousness as an {{gap_f9320d56-0d69-4024-a831-e384b7244fe0_1}}, suggesting it does not cause actions but merely observes them. More recently, Haynes used sophisticated {{gap_f9320d56-0d69-4024-a831-e384b7244fe0_2}} technology to predict decisions seconds in advance. These findings raise profound questions about moral responsibility and the foundations of our {{gap_f9320d56-0d69-4024-a831-e384b7244fe0_3}} system.',
 'readiness potential'),
('8aa33068-b15c-4c35-9ab8-349993bcee5a', 'f9320d56-0d69-4024-a831-e384b7244fe0', 38,
 '', 'epiphenomenon'),
('d45a5dc7-5f7c-4709-97b0-69780e7ef874', 'f9320d56-0d69-4024-a831-e384b7244fe0', 39,
 '', 'fMRI'),
('eda65e16-87a9-4901-ba5a-033d48779b10', 'f9320d56-0d69-4024-a831-e384b7244fe0', 40,
 '', 'justice');

-- ══════════════════════════════════════════════════════════════
-- End of Seed Data
-- ══════════════════════════════════════════════════════════════
