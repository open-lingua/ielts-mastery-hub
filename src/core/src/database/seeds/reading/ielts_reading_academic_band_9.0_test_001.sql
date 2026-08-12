-- ============================================================
-- IELTS Practice Platform – Extended Seed Data
-- Target: Reading Module (Academic, Band 9 Difficulty)
-- Action: APPEND (No TRUNCATE)
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST ENTRY (Academic - Band 9)                           ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('ad7d581e-4b33-4741-ba6e-041273901f53', 'fe38ed89-f1fe-4b88-9609-8736be47f61e',
 'IELTS Academic Reading Mastery: Epigraphy, Digital Economics & Quantum Biology (Band 9)', 'Academic', '9', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: The Linguistic Decipherment of Linear Elamite (Q1–13)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('f6ee9a09-1b0e-4419-be98-fce92a3da9c3', 'ad7d581e-4b33-4741-ba6e-041273901f53', 1,
 'The Linguistic Decipherment of Linear Elamite',
 '(A) For over a century, the ancient script known as Linear Elamite stood as one of the great unresolved enigmas of early epigraphy. Originating in the contemporary region of southwestern Iran during the late 3rd millennium BCE, the script was coeval with the famed Mesopotamian Cuneiform but remained stubbornly undeciphered. This was largely due to a severe paucity of bilingual texts. Unlike the Rosetta Stone, which provided a direct isomorphic bridge between Egyptian Hieroglyphs and ancient Greek, the extant corpus of Linear Elamite comprised a mere 40 fragmentary inscriptions. These fragmented remnants, discovered primarily in the ancient metropolis of Susa, offered linguists an exceptionally narrow statistical dataset from which to extract grammatical or phonetic patterns.

(B) The breakthrough in decipherment did not occur through a singular, monolithic discovery, but rather through the meticulous, cumulative efforts of a team led by French archaeologist François Desset in the late 2010s. The turning point hinged upon the analysis of a specific group of artifacts known as the "gunagi" vessels—intricately engraved silver beakers recovered from the Kamtiri region. Crucially, these beakers bore inscriptions in both Mesopotamian Cuneiform and Linear Elamite, detailing the names and titularies of local rulers. By cross-referencing the known cuneiform phonetic values of these royal names with the unknown Elamite symbols, Desset''s team established a reliable phonetic anchor.

(C) What emerged from this linguistic excavation profoundly challenged established historiographical orthodoxies. Previously, prevailing scholarly consensus held that the development of writing was a strictly unilateral phenomenon, radiating outward from a single origin point in southern Mesopotamia. However, the structure of Linear Elamite suggested an independent, indigenous evolution of writing in the Iranian plateau. Furthermore, while early Mesopotamian scripts were heavily logophonetic—utilizing hundreds of symbols to represent entire words alongside syllables—Linear Elamite was revealed to be a highly streamlined, almost purely phonetic system utilizing merely 80 to 100 signs.

(D) The decipherment of Linear Elamite fundamentally restructures our understanding of Bronze Age communication networks. It indicates a sophisticated intellectual milieu in Elam, characterized by a deliberate departure from the cumbersome logographic systems of their western neighbors. The phonetic elegance of Linear Elamite arguably democratized record-keeping, allowing scribes to draft administrative, royal, and perhaps even literary texts with unprecedented efficiency. 

(E) Despite this monumental triumph, the translation of the entire Elamite corpus remains an ongoing endeavor. The script has been unlocked, but the underlying Elamite language itself—a language isolate with no known living relatives—continues to present formidable semantic challenges. Epigraphers now face the arduous task of reconstructing the lexicon and syntax of a civilization that has been silent for over four millennia, relying on the structural framework that Desset''s phonetic key has finally provided.');

-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c260a70a-88d5-4f54-8986-126bf0937a9d', 'f6ee9a09-1b0e-4419-be98-fce92a3da9c3', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the passage? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('26216a82-fa54-4328-a481-c7de928aa74d', 'c260a70a-88d5-4f54-8986-126bf0937a9d', 1,
 'The Rosetta Stone was utilized by François Desset to translate Linear Elamite.', 'FALSE', '["FALSE","False","false"]'),
('e8112125-5666-49fc-b7df-2cea1ebd290d', 'c260a70a-88d5-4f54-8986-126bf0937a9d', 2,
 'The surviving examples of Linear Elamite inscriptions were statistically limited.', 'TRUE', '["TRUE","True","true"]'),
('2e2fba74-4bff-4581-ac53-66f22204cb7f', 'c260a70a-88d5-4f54-8986-126bf0937a9d', 3,
 'The decipherment proved that writing originated exclusively in southern Mesopotamia.', 'FALSE', '["FALSE","False","false"]'),
('b765cb8a-5b65-46f3-9a66-2cdc0520efa1', 'c260a70a-88d5-4f54-8986-126bf0937a9d', 4,
 'Linear Elamite was predominantly used for agricultural accounting.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]');

-- ── Group 2: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('63eb35e0-ffec-4c1e-9d62-09b686b11ddb', 'f6ee9a09-1b0e-4419-be98-fce92a3da9c3', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('13422d6e-8903-491a-befe-bfb1922a1d04', '63eb35e0-ffec-4c1e-9d62-09b686b11ddb', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"Script Type","answer":""},{"id":"h2","gapText":"Key Characteristic","answer":""},{"id":"h3","gapText":"Primary Region","answer":""}]'),
('babd47f8-d469-4945-9e90-d92e9db23a89', '63eb35e0-ffec-4c1e-9d62-09b686b11ddb', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"Mesopotamian Cuneiform","answer":""},{"id":"c2","gapText":"","answer":"heavily logophonetic"},{"id":"c3","gapText":"Mesopotamia","answer":""}]'),
('cc978717-fed0-458c-8813-5eb7e248173f', '63eb35e0-ffec-4c1e-9d62-09b686b11ddb', 7,
 'Row 3', '',
 '[{"id":"c4","gapText":"Linear Elamite","answer":""},{"id":"c5","gapText":"Almost entirely {{gap}}","answer":"phonetic"},{"id":"c6","gapText":"Southwestern Iran","answer":""}]'),
('836ad13b-169e-4b77-9fae-1dd573fa1f84', '63eb35e0-ffec-4c1e-9d62-09b686b11ddb', 8,
 'Row 4', '',
 '[{"id":"c7","gapText":"Linear Elamite translated via","answer":""},{"id":"c8","gapText":"","answer":"silver beakers"},{"id":"c9","gapText":"Kamtiri region","answer":""}]'),
('bcbdd48f-0b0f-4416-8818-b1e657be0d9c', '63eb35e0-ffec-4c1e-9d62-09b686b11ddb', 9,
 'Row 5', '',
 '[{"id":"c10","gapText":"Original fragment discoveries","answer":""},{"id":"c11","gapText":"Fragmentary inscriptions","answer":""},{"id":"c12","gapText":"Ancient metropolis of {{gap}}","answer":"Susa"}]');

-- ── Group 3: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('d9f16e54-1bb2-433f-a23b-ed160b9366b6', 'f6ee9a09-1b0e-4419-be98-fce92a3da9c3', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS from the passage for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('e16994cf-58be-462f-91c2-9dfee08f7e52', 'd9f16e54-1bb2-433f-a23b-ed160b9366b6', 10,
 'What type of texts were notoriously lacking, hindering early decipherment efforts?', 'bilingual texts', '[{"id":"1","text":"bilingual texts"},{"id":"2","text":"bilingual"}]'),
('fdcffd8d-1440-407f-b211-797b8258f146', 'd9f16e54-1bb2-433f-a23b-ed160b9366b6', 11,
 'What specific term refers to the artifacts that ultimately provided the phonetic anchor?', 'gunagi vessels', '[{"id":"1","text":"gunagi vessels"},{"id":"2","text":"gunagi"}]'),
('e732deef-354d-4d9a-9a29-9ffb4ccecbb8', 'd9f16e54-1bb2-433f-a23b-ed160b9366b6', 12,
 'How many signs approximately did the Linear Elamite writing system utilize?', '80 to 100', '[{"id":"1","text":"80 to 100"},{"id":"2","text":"80-100"}]'),
('c5587695-a159-4e68-90f7-1891b4cd2b45', 'd9f16e54-1bb2-433f-a23b-ed160b9366b6', 13,
 'How is the Elamite language classified linguistically by modern epigraphers?', 'language isolate', '[{"id":"1","text":"language isolate"},{"id":"2","text":"a language isolate"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: The Economics of Attention in the Digital Anthropocene (Q14–27)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('a48fe0af-5503-4ab4-9393-d5396c7c53ee', 'ad7d581e-4b33-4741-ba6e-041273901f53', 2,
 'The Economics of Attention in the Digital Anthropocene',
 '(A) In the contemporary epoch, frequently colloquially termed the ''Digital Anthropocene'', human attention has been systematically transmuted from a cognitive faculty into a highly fungible macroeconomic commodity. The genesis of the "attention economy"—a paradigm initially postulated by polymath Herbert A. Simon in 1971—posits that an overabundance of information inexorably engenders a scarcity of attention. Today, this theoretical framework has been operationalised by ubiquitous algorithmic architectures designed to extract, quantify, and monetise human cognitive engagement with unprecedented granular precision.

(B) The fundamental friction in this economy arises from a profound biological bottleneck. While global data generation expands at an exponential velocity, the neurobiological capacity of the human brain to process sensory input remains strictly bounded by evolutionary constraints. We possess roughly 86 billion neurons, capable of processing only a finite bandwidth of stimuli before cognitive overload triggers profound executive dysfunction. Silicon Valley conglomerates actively exploit this asymmetry, deploying sophisticated interface designs that bypass higher-order rational deliberation, appealing directly to the primitive dopaminergic pathways of the basal ganglia.

(C) Chief among these exploitative mechanisms is the ''variable ratio schedule'' of reinforcement, a psychological principle imported directly from B.F. Skinner''s mid-20th-century operant conditioning paradigms. Features such as the ''infinite scroll'' or the unpredictable delivery of social validation notifications transform digital platforms into veritable psychological slot machines. Because the reward (a compelling piece of news, a humorous image, a social "like") is delivered at entirely randomized intervals, the user is locked into a compulsive loop of continuous checking, effectively surrendering their volitional autonomy to the architectural dictates of the application.

(D) The macroeconomic implications of this shift have been delineated by Harvard sociologist Shoshana Zuboff under the nomenclature of "surveillance capitalism." In this paradigm, digital conglomerates do not merely sell targeted advertising; they aggregate vast oceans of behavioral data to construct predictive models of future human action. These "behavioral futures" are traded in opaque secondary markets, rendering the human experience itself the raw material for algorithmic capital accumulation. The user is no longer the customer, nor even the product; rather, the user is the uncompensated terra nullius from which cognitive resources are ruthlessly strip-mined.

(E) The psychological externalities of this system are becoming increasingly quantifiable. Sociologists note a rising epidemic of "continuous partial attention," an unnatural cognitive state wherein an individual maintains a superficial, high-alert scan of multiple digital streams simultaneously, never achieving the deep, unfragmented focus required for complex analytical reasoning or meaningful empathetic connection. Longitudinal studies suggest this chronic attentional fragmentation correlates strongly with elevated cortisol levels, pervasive societal anxiety, and a measurable degradation in democratic discourse, as emotionally incendiary micro-content reliably outcompetes nuanced argumentation in algorithmic visibility.

(F) In response to this cognitive crisis, a nascent movement advocating for "cognitive ergonomics" and "time well spent" is gaining legislative traction. European regulatory bodies have begun floating the concept of a "Right to Disconnect," alongside proposals to strictly regulate persuasive design patterns. However, transitioning away from an attention-extractive economy necessitates a fundamental realignment of digital incentive structures—shifting the core metrics of technological success from raw "time-on-site" to the qualitative enhancement of human agency and well-being.');

-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('97374222-0209-475c-9723-70b930c31b41', 'a48fe0af-5503-4ab4-9393-d5396c7c53ee', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. The biological limitations of data processing","ii. Operant conditioning in user interface design","iii. Evaluating the societal and neurobiological toll","iv. Legislative efforts toward cognitive protection","v. The commodification of behavioral predictions","vi. A historical oversight in psychological research","vii. The foundational theory of information abundance","viii. Algorithms designed for educational enhancement"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('b6e7f79d-2c53-4eee-854e-eaff84094f14', '97374222-0209-475c-9723-70b930c31b41', 14, 'Paragraph A', 'vii'),
('145ff3c0-6b3e-42b1-8ef7-6f2a22d6ded7', '97374222-0209-475c-9723-70b930c31b41', 15, 'Paragraph B', 'i'),
('431b47a6-776d-4756-acc0-fc5c7e9b9115', '97374222-0209-475c-9723-70b930c31b41', 16, 'Paragraph C', 'ii'),
('a7c9691c-9328-4908-9895-76d16820a6ac', '97374222-0209-475c-9723-70b930c31b41', 17, 'Paragraph D', 'v'),
('3a11997a-193f-4596-a956-69c97b731d05', '97374222-0209-475c-9723-70b930c31b41', 18, 'Paragraph E', 'iii'),
('04a927a8-00ce-4cfc-86b6-bdb6820534a0', '97374222-0209-475c-9723-70b930c31b41', 19, 'Paragraph F', 'iv');

-- ── Group 5: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('31aa8d11-4efc-4fba-9143-1a20135f8aeb', 'a48fe0af-5503-4ab4-9393-d5396c7c53ee', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('32270e65-ad1c-4746-9309-b9b804544183', '31aa8d11-4efc-4fba-9143-1a20135f8aeb', 20,
 'A description of how unstructured, volatile digital streams degrade democratic interactions.', 'E',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('32cc42a5-19c7-478e-8708-b94fe72e1942', '31aa8d11-4efc-4fba-9143-1a20135f8aeb', 21,
 'An explanation of why the unpredictability of digital rewards forces compulsive user behavior.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('01f2ada9-400c-4cb0-91a3-25babbfa88a5', '31aa8d11-4efc-4fba-9143-1a20135f8aeb', 22,
 'The assertion that users are treated merely as territories to be mined for data.', 'D',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('ca3a5f09-a03d-48bb-9063-86ab560c021e', '31aa8d11-4efc-4fba-9143-1a20135f8aeb', 23,
 'Mention of a proposal to legally safeguard an individual''s right to detach from digital networks.', 'F',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');

-- ── Group 6: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('4d1c3bc0-fa49-4986-9368-38f86ff12097', 'a48fe0af-5503-4ab4-9393-d5396c7c53ee', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('cc2c0c29-e111-4451-b5fa-51f22368c8c1', '4d1c3bc0-fa49-4986-9368-38f86ff12097', 24,
 'According to Paragraph B, tech companies successfully manipulate users by:',
 'C',
 '[{"id":"A","text":"A. Expanding the neurobiological capacity of the human brain.","isCorrect":false},{"id":"B","text":"B. Overwhelming users with rational, highly complex arguments.","isCorrect":false},{"id":"C","text":"C. Circumventing rational thought to stimulate foundational reward pathways.","isCorrect":true},{"id":"D","text":"D. Decreasing the exponential velocity of global data generation.","isCorrect":false}]'),
('761077ac-3ebc-4ec2-8354-a55a328eb142', '4d1c3bc0-fa49-4986-9368-38f86ff12097', 25,
 'Shoshana Zuboff''s concept of "surveillance capitalism" implies that:',
 'B',
 '[{"id":"A","text":"A. Users directly purchase predictive models from technology conglomerates.","isCorrect":false},{"id":"B","text":"B. Human experiences are commodified into speculative assets traded by algorithms.","isCorrect":true},{"id":"C","text":"C. Targeted advertising is the sole mechanism of revenue generation.","isCorrect":false},{"id":"D","text":"D. Consumers maintain ownership over their granular behavioral data.","isCorrect":false}]'),
('fd320f20-b0b0-41e8-b8ee-ff14f825c66e', '4d1c3bc0-fa49-4986-9368-38f86ff12097', 26,
 'What is the primary consequence of "continuous partial attention" as identified in the text?',
 'D',
 '[{"id":"A","text":"A. A heightened ability to process emotionally incendiary content.","isCorrect":false},{"id":"B","text":"B. An improvement in multi-tasking and operational efficiency.","isCorrect":false},{"id":"C","text":"C. A decrease in cortisol levels during prolonged digital exposure.","isCorrect":false},{"id":"D","text":"D. An inability to engage in profound focus or meaningful empathy.","isCorrect":true}]'),
('55197073-7d33-4cb1-938c-9a213e9f2c14', '4d1c3bc0-fa49-4986-9368-38f86ff12097', 27,
 'The author''s stance on resolving the cognitive crisis involves:',
 'A',
 '[{"id":"A","text":"A. Shifting corporate metrics from engagement duration to user well-being.","isCorrect":true},{"id":"B","text":"B. Enhancing the variable ratio schedules used in platform interfaces.","isCorrect":false},{"id":"C","text":"C. Rejecting all forms of European technological regulation.","isCorrect":false},{"id":"D","text":"D. Acknowledging that information abundance is fundamentally irreversible.","isCorrect":false}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: Quantum Biology: Navigating the Subatomic Frontier of Life (Q28–40)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('41b97e01-0914-47e2-b751-b6cbeb56bb68', 'ad7d581e-4b33-4741-ba6e-041273901f53', 3,
 'Quantum Biology: Navigating the Subatomic Frontier of Life',
 '(A) The intersection of quantum mechanics and molecular biology—two disciplines traditionally isolated by vastly disparate spatial and temporal scales—has birthed the profoundly disruptive paradigm of quantum biology. For decades, classical biochemistry presupposed that the warm, chaotic, and macroscopic environment of living organisms would instantaneously collapse any delicate quantum superpositions, rendering phenomena like entanglement and quantum tunneling biologically inert. However, recent empirical breakthroughs have unequivocally demonstrated that life not only tolerates quantum anomalies but actively exploits them to achieve physiological efficiencies entirely unattainable by classical thermodynamics.

(B) Perhaps the most extensively corroborated instance of macroscopic quantum biology is avian magnetoreception. The European Robin (Erithacus rubecula) undertakes transcontinental migrations by navigating along the Earth''s extraordinarily weak magnetic field. Classical chemical reactions lack the sensitivity required to detect such minute magnetic variations. However, researchers have identified a light-sensitive protein in the avian retina called cryptochrome. When a photon strikes this protein, it creates a "radical pair" of electrons that exist in a state of quantum entanglement. The microscopic spin states of these entangled electrons oscillate in a manner exquisitely sensitive to the Earth''s magnetic inclination, effectively providing the bird with a subatomic quantum compass.

(C) Equally astonishing is the application of quantum coherence in photosynthesis. The Fenna-Matthews-Olson (FMO) complex, a pigment-protein structure found in green sulfur bacteria, operates as an energy funnel, transporting solar photons to a reaction center with an astoundingly near-perfect efficiency of 99 percent. Classical models, representing energy transfer as a random, localized ''drunkard''s walk'', fail entirely to account for this speed and efficiency. Advanced femtosecond spectroscopy has revealed that the excitation energy propagates through the FMO complex in a state of quantum coherence—simultaneously exploring every possible route to the reaction center and instantaneously collapsing into the most efficient pathway.

(D) The phenomenon of quantum tunneling—where a particle passes through an insurmountable energy barrier by virtue of its probabilistic wave function—has also been identified as a cornerstone of cellular enzymology. Enzymes are biological catalysts that accelerate chemical reactions by lowering activation energy barriers. However, experimental data shows that protons and electrons frequently bypass these barriers altogether via quantum tunneling. Without this subatomic shortcut, essential biological processes, including cellular respiration and DNA mutation, would proceed at rates far too sluggish to sustain complex biological life.

(E) A more speculative, yet highly compelling, frontier involves the physiology of olfaction. The traditional ''lock-and-key'' model of smell posits that odorant molecules fit perfectly into matching receptor proteins. Yet, molecules with entirely different shapes can smell identical, while molecular isotopes—which share the same shape but differ slightly in mass—smell distinct. The controversial ''vibration theory'' of olfaction suggests that olfactory receptors operate as nanoscale quantum spectrometers. When an odorant binds to a receptor, an electron quantum tunnels across the receptor, a process governed precisely by the molecular vibrational frequency of the odorant.

(F) The implications of these discoveries stretch deeply into evolutionary theory. If biological systems have evolved to maintain quantum coherence within the supposedly prohibitive ''hot and wet'' environment of a cell, it suggests that natural selection operates effectively at the deepest, most fundamental layers of physical reality. The biological exploitation of the quantum realm is not a bizarre anomaly; rather, it appears to be an inexorable, highly optimized strategy of life itself. As instrumentation continues to attain unprecedented precision, the artificial boundary demarcating classical biology from quantum physics will likely dissolve entirely.');

-- ── Group 7: YES/NO/NOT GIVEN (Q28–32) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('73dbee06-dd9e-425e-ab1f-7a8f6ca90d6e', '41b97e01-0914-47e2-b751-b6cbeb56bb68', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('c3f336c5-6559-4254-863a-3fa6413ce801', '73dbee06-dd9e-425e-ab1f-7a8f6ca90d6e', 28,
 'Classical biochemists initially believed that a living organism''s internal environment would destroy quantum states.', 'YES', '["YES","Yes","yes"]'),
('331fd6c2-fc1c-4fbc-b4a1-4a3a85777910', '73dbee06-dd9e-425e-ab1f-7a8f6ca90d6e', 29,
 'The cryptochrome protein relies on sound vibrations to maintain its quantum entanglement.', 'NO', '["NO","No","no"]'),
('8d1e8678-016e-4f57-8d8c-9d7ef53e32bd', '73dbee06-dd9e-425e-ab1f-7a8f6ca90d6e', 30,
 'Energy transfer in the FMO complex can be adequately explained by the classical "drunkard''s walk" model.', 'NO', '["NO","No","no"]'),
('184c145b-5df2-482a-bedc-1a328afddd53', '73dbee06-dd9e-425e-ab1f-7a8f6ca90d6e', 31,
 'Quantum tunneling is primarily responsible for preventing detrimental DNA mutations in humans.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('c0b3c3bb-1ca2-4048-bcd1-b7f947b32f5a', '73dbee06-dd9e-425e-ab1f-7a8f6ca90d6e', 32,
 'The vibration theory of olfaction proposes that receptors measure an odorant''s molecular vibrational frequency.', 'YES', '["YES","Yes","yes"]');

-- ── Group 8: MATCHING SENTENCE ENDINGS (Q33–36) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('9d7e41c2-5001-41a9-8ba3-c7c58ed013ad', '41b97e01-0914-47e2-b751-b6cbeb56bb68', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('e51092c7-8281-46b8-85f1-79411ae1fe0c', '9d7e41c2-5001-41a9-8ba3-c7c58ed013ad', 33,
 'The discovery of avian magnetoreception suggests that European Robins can',
 'D',
 '[{"id":"A","text":"simultaneously explore all potential paths to a reaction center.","isCorrect":false},{"id":"B","text":"overcome previously insurmountable chemical activation barriers.","isCorrect":false},{"id":"C","text":"predict the exact isotopic mass of scent molecules.","isCorrect":false},{"id":"D","text":"navigate using entangled electrons sensitive to magnetic fields.","isCorrect":true},{"id":"E","text":"maintain a chaotic cellular environment to prevent entanglement.","isCorrect":false},{"id":"F","text":"operate as nanoscale quantum spectrometers for visual stimuli.","isCorrect":false}]'),
('407b30d1-a244-444a-8ba5-bafe8ffff065', '9d7e41c2-5001-41a9-8ba3-c7c58ed013ad', 34,
 'Because excitation energy exists in a state of quantum coherence, it can',
 'A',
 '[{"id":"A","text":"simultaneously explore all potential paths to a reaction center.","isCorrect":true},{"id":"B","text":"overcome previously insurmountable chemical activation barriers.","isCorrect":false},{"id":"C","text":"predict the exact isotopic mass of scent molecules.","isCorrect":false},{"id":"D","text":"navigate using entangled electrons sensitive to magnetic fields.","isCorrect":false},{"id":"E","text":"maintain a chaotic cellular environment to prevent entanglement.","isCorrect":false},{"id":"F","text":"operate as nanoscale quantum spectrometers for visual stimuli.","isCorrect":false}]'),
('1f61e267-31da-4a79-9996-0f39a7e8a07e', '9d7e41c2-5001-41a9-8ba3-c7c58ed013ad', 35,
 'By utilizing the probabilistic subatomic wave function, cellular enzymes help particles',
 'B',
 '[{"id":"A","text":"simultaneously explore all potential paths to a reaction center.","isCorrect":false},{"id":"B","text":"overcome previously insurmountable chemical activation barriers.","isCorrect":true},{"id":"C","text":"predict the exact isotopic mass of scent molecules.","isCorrect":false},{"id":"D","text":"navigate using entangled electrons sensitive to magnetic fields.","isCorrect":false},{"id":"E","text":"maintain a chaotic cellular environment to prevent entanglement.","isCorrect":false},{"id":"F","text":"operate as nanoscale quantum spectrometers for visual stimuli.","isCorrect":false}]'),
('c7a21553-9b82-4ec7-8d10-136101369b85', '9d7e41c2-5001-41a9-8ba3-c7c58ed013ad', 36,
 'The failure of the traditional lock-and-key model of olfaction led to the hypothesis that receptors might',
 'C',  -- Actually, the text suggests they act as nanoscale quantum spectrometers measuring vibration, not predicting isotopic mass. Let's adjust the correct option carefully. Option C mentions isotopic mass, but the text says isotopes smell distinct. Wait, let's look at the options. 
 -- Correction: Let's make an option that fits perfectly.
 '[{"id":"A","text":"simultaneously explore all potential paths to a reaction center.","isCorrect":false},{"id":"B","text":"overcome previously insurmountable chemical activation barriers.","isCorrect":false},{"id":"C","text":"differentiate odorants based on their molecular vibrational frequency.","isCorrect":true},{"id":"D","text":"navigate using entangled electrons sensitive to magnetic fields.","isCorrect":false},{"id":"E","text":"maintain a chaotic cellular environment to prevent entanglement.","isCorrect":false},{"id":"F","text":"operate as nanoscale quantum spectrometers for visual stimuli.","isCorrect":false}]');

-- ── Group 9: SUMMARY COMPLETION with Word Bank (Q37–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('150caf5f-f4dc-424d-b001-99c64eefcf73', '41b97e01-0914-47e2-b751-b6cbeb56bb68', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["entanglement","coherence","tunneling","anomalies","spectrometers","vibrational","thermodynamics"]');

-- For SUMMARY_COMPLETION: first question text = summary template, subsequent ones are empty text.
INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('0d92e7d6-126c-4b19-8eb1-ddc8aac45f47', '150caf5f-f4dc-424d-b001-99c64eefcf73', 37,
 'Quantum biology explains how living organisms exploit quantum {{gap_150caf5f-f4dc-424d-b001-99c64eefcf73_0}} to perform highly efficient processes. For example, avian magnetoreception relies on the quantum {{gap_150caf5f-f4dc-424d-b001-99c64eefcf73_1}} of radical electron pairs. Similarly, the near-perfect efficiency of photosynthesis is driven by quantum {{gap_150caf5f-f4dc-424d-b001-99c64eefcf73_2}}, allowing energy to find optimal pathways. Furthermore, enzymes rapidly catalyze reactions via quantum {{gap_150caf5f-f4dc-424d-b001-99c64eefcf73_3}}, enabling particles to bypass massive energy barriers.',
 'anomalies'),
('ef86a55c-41ce-466d-af06-c8ba23e48fe5', '150caf5f-f4dc-424d-b001-99c64eefcf73', 38,
 '', 'entanglement'),
('69abe5cb-dfef-47be-ab35-ba5c107c721c', '150caf5f-f4dc-424d-b001-99c64eefcf73', 39,
 '', 'coherence'),
('f90fc483-d313-47cf-8c81-72f4e71ab129', '150caf5f-f4dc-424d-b001-99c64eefcf73', 40,
 '', 'tunneling');

-- ============================================================
-- NOTE: Please execute `UPDATE reading_tests SET created_by = '<your-uid>'` 
-- if required by your application's Row Level Security policies.
-- ============================================================
