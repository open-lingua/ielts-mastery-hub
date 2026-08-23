-- ============================================================
-- IELTS Practice Platform – Extended Seed Data
-- Target: Reading Module (Academic, Band 8 Difficulty)
-- Action: APPEND (No TRUNCATE)
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST ENTRY (Academic - Band 8)                           ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('3c34ab7c-07fc-41b5-a34f-8cab934829f7', '1184289b-9434-4f24-ac7b-d7b8c1afac0a',
 'IELTS Academic Reading: Geopolitics, Psycholinguistics & Epistemology (Band 8)', 'Academic', '8', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: The Geopolitics of Rare Earth Elements (Q1–13)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('45a7f544-d6fa-4bbd-affa-f18515ed25b8', '3c34ab7c-07fc-41b5-a34f-8cab934829f7', 1,
 'The Geopolitics of Rare Earth Elements',
 '(A) Despite their nomenclature, rare earth elements (REEs) are not particularly scarce in the Earth’s crust. Cerium, for instance, is as abundant as copper. The designation "rare" stems from their geochemical properties; they are seldom found in concentrated, economically viable ore deposits, but are instead dispersed widely, inextricably bound to complex mineral matrices. Extracting and refining these seventeen chemically similar metallic elements requires highly intensive metallurgical processes that yield significant, and often highly toxic, environmental byproducts, making their production a formidable ecological and economic challenge.

(B) The ubiquity of REEs in modern technology cannot be overstated. They are the invisible backbone of the 21st-century technological landscape, essential for manufacturing neodymium-iron-boron magnets used in wind turbine generators, electric vehicle motors, and precision guided munitions. Lanthanum is critical for camera lenses and battery electrodes, while europium is indispensable for the luminescence of digital displays. As the global transition toward a low-carbon economy accelerates, the demand for these elements is projected to increase exponentially, transforming them from niche industrial inputs into focal points of geopolitical strategy.

(C) Historically, the United States dominated global REE production, primarily through the Mountain Pass mine in California. However, beginning in the 1980s, shifting environmental regulations and the emergence of lower-cost competitors catalyzed a dramatic restructuring of the global supply chain. By the early 2000s, production had shifted overwhelmingly to East Asia, with a single nation controlling over 90% of the world’s mining, refining, and processing capacity. This monopolistic concentration created an unprecedented supply bottleneck, rendering the global high-tech and defense industries acutely vulnerable to export quotas and geopolitical leveraging.

(D) The fragility of this supply chain was starkly illuminated during a 2010 diplomatic dispute, which resulted in a de facto embargo on REE exports to a major manufacturing nation. In the aftermath, the prices of elements like dysprosium and neodymium spiked by several hundred percent, triggering widespread panic among international technology conglomerates. This crisis acted as a catalyst for western nations, prompting sudden, albeit belated, efforts to diversify supply chains, reopen dormant mines, and invest in alternative processing technologies. 

(E) However, breaking the monopoly has proven exceedingly difficult. The barrier to entry in the rare earth sector is not merely access to raw ore, but rather the highly specialized intellectual property and infrastructure required for the separation and refining of the elements. Building a processing facility can take up to a decade and requires billions of dollars in capital expenditure. Furthermore, Western attempts to establish independent supply chains have frequently been undercut by volatile pricing dynamics in the global market, which often render newly opened mines financially insolvent before they reach full operational capacity.

(F) In response to these persistent vulnerabilities, scientists are exploring paradigm-shifting alternatives. Advanced research is increasingly focused on the development of synthetic substitutes, such as iron-nitride magnets, which do not require rare earth inputs. Concurrently, efforts in urban mining—recovering REEs from discarded electronics—are gaining traction, though logistical and chemical extraction hurdles remain substantial. Ultimately, until these nascent technologies achieve commercial scale, REEs will remain a critical nexus of environmental risk, technological advancement, and international geopolitical tension.');

-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('cc79bcb0-6f6a-416d-991c-f7bd8dfe81d7', '45a7f544-d6fa-4bbd-affa-f18515ed25b8', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the passage? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('5b146cbb-f921-450f-9359-0a44c7d14c23', 'cc79bcb0-6f6a-416d-991c-f7bd8dfe81d7', 1,
 'The term "rare" accurately reflects the overall scarcity of these elements in the Earth’s crust.', 'FALSE', '["FALSE","False","false"]'),
('57a66d66-57a6-4ee7-bd55-a5a23e58d543', 'cc79bcb0-6f6a-416d-991c-f7bd8dfe81d7', 2,
 'The refining process for rare earth elements produces waste materials that are damaging to the environment.', 'TRUE', '["TRUE","True","true"]'),
('d56d8c1d-6f9b-4c23-bdf0-374d4fb72d96', 'cc79bcb0-6f6a-416d-991c-f7bd8dfe81d7', 3,
 'The United States closed the Mountain Pass mine primarily due to a depletion of usable ore.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('9547f159-ab73-44dc-a8ad-b4f914b93692', 'cc79bcb0-6f6a-416d-991c-f7bd8dfe81d7', 4,
 'A significant diplomatic event in 2010 caused an immediate and permanent shift away from rare earth element usage.', 'FALSE', '["FALSE","False","false"]');

-- ── Group 2: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('40dc8fab-deb3-4c94-9678-5160a49ec8ca', '45a7f544-d6fa-4bbd-affa-f18515ed25b8', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('2be8315c-b838-4f46-ae1e-a80f00f03c48', '40dc8fab-deb3-4c94-9678-5160a49ec8ca', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"Factor / Element","answer":""},{"id":"h2","gapText":"Application / Issue","answer":""}]'),
('1a08e08f-bd74-40bf-822b-bda727c6401b', '40dc8fab-deb3-4c94-9678-5160a49ec8ca', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"Neodymium","answer":""},{"id":"c2","gapText":"Essential for manufacturing magnets used in wind turbines and {{gap}}","answer":"electric vehicle"}]'),
('a1d6735f-72d5-4ccc-9a45-5f0950f249c8', '40dc8fab-deb3-4c94-9678-5160a49ec8ca', 7,
 'Row 3', '',
 '[{"id":"c3","gapText":"Europium","answer":""},{"id":"c4","gapText":"Provides the necessary {{gap}} for modern digital screens.","answer":"luminescence"}]'),
('7f5ec98a-2564-42b8-95f2-7913f06638a2', '40dc8fab-deb3-4c94-9678-5160a49ec8ca', 8,
 'Row 4', '',
 '[{"id":"c5","gapText":"Supply Chain Vulnerability","answer":""},{"id":"c6","gapText":"Establishing new processing facilities is difficult due to the need for specialized {{gap}}.","answer":"intellectual property"}]'),
('50b3a652-3f43-4e2a-9598-2a402db84da8', '40dc8fab-deb3-4c94-9678-5160a49ec8ca', 9,
 'Row 5', '',
 '[{"id":"c7","gapText":"Alternative Solutions","answer":""},{"id":"c8","gapText":"Recovering REEs from discarded devices, known as {{gap}}, faces chemical extraction hurdles.","answer":"urban mining"}]');

-- ── Group 3: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('21ebd7b1-5496-4d13-989b-960d6db7d28f', '45a7f544-d6fa-4bbd-affa-f18515ed25b8', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS from the passage for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('6eef1710-f3c1-4e6f-8681-38dc70de6b30', '21ebd7b1-5496-4d13-989b-960d6db7d28f', 10,
 'To what are rare earth elements intricately bound, making their extraction difficult?', 'complex mineral matrices', '[{"id":"1","text":"complex mineral matrices"},{"id":"2","text":"mineral matrices"}]'),
('babe5325-d9ce-4777-8d50-0f5e5cc5b834', '21ebd7b1-5496-4d13-989b-960d6db7d28f', 11,
 'What economic trend is primarily responsible for the projected exponential increase in REE demand?', 'low-carbon economy', '[{"id":"1","text":"low-carbon economy"},{"id":"2","text":"a low-carbon economy"}]'),
('68fad7b3-c78b-4b07-91ae-11cda54037d9', '21ebd7b1-5496-4d13-989b-960d6db7d28f', 12,
 'What external factor frequently forces newly established Western REE mines to become financially insolvent?', 'volatile pricing dynamics', '[{"id":"1","text":"volatile pricing dynamics"},{"id":"2","text":"pricing dynamics"}]'),
('623d9ef8-3337-498a-82a8-f0ddc4dd4e07', '21ebd7b1-5496-4d13-989b-960d6db7d28f', 13,
 'What type of synthetic magnets are scientists researching to bypass the need for rare earth materials?', 'iron-nitride magnets', '[{"id":"1","text":"iron-nitride magnets"},{"id":"2","text":"synthetic substitutes"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Neurolinguistic Programming and Syntactic Ambiguity (Q14–27)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('d0082d96-4483-4b49-8ddb-db717764a627', '3c34ab7c-07fc-41b5-a34f-8cab934829f7', 2,
 'Neurolinguistic Programming and Syntactic Ambiguity',
 '(A) The cognitive mechanisms underlying human language comprehension constitute one of the most rigorously debated subjects in psycholinguistics. As a sentence is read or heard, the human brain must perform "syntactic parsing"—the rapid, unconscious assignment of grammatical structure to incoming streams of words. For straightforward sentences, this process appears seamless. However, linguists rely heavily on grammatically correct but structurally ambiguous sentences to expose the underlying architecture of the parsing mechanism. These anomalous structures force the brain to reveal whether it processes grammatical structure instantaneously or builds interpretations iteratively.

(B) The most famous instruments for testing these cognitive constraints are "garden path" sentences. A classic example is: "The complex houses married and single soldiers and their families." Upon reading the first few words ("The complex houses"), the dominant heuristic of the human brain immediately interprets "complex" as an adjective modifying the noun "houses." It is only upon reaching the phrase "married and single soldiers" that a parsing failure occurs. The brain realizes the initial interpretation is syntactically untenable, forcing a rapid cognitive recalibration where "complex" is re-categorized as a noun and "houses" as a verb. This momentary confusion provides crucial empirical data regarding how linguistic information is temporally processed.

(C) Historically, psycholinguistic theories were divided into two fiercely opposed camps regarding how syntactic ambiguity is resolved. The "serial processing" model, heavily influenced by early computational linguistics, posited that the brain constructs a single, highly probable syntactic tree during comprehension. If subsequent information invalidates this tree, the parsing mechanism crashes, backtracks, and computes the next most probable structure. This model elegantly explained the jarring hesitation readers experience during garden path sentences, aligning with the concept of cognitive economy, wherein the brain minimizes immediate energy expenditure.

(D) Conversely, the "parallel processing" or constraint-based model argued that the brain operates much like a sophisticated probability matrix. According to this theory, multiple syntactic interpretations of an ambiguous sentence are generated simultaneously in the subconscious. These competing interpretations are continuously weighted against contextual clues, semantic plausibility, and lexical frequency. When the sentence resolves, the interpretation with the highest probabilistic weight is thrust into conscious awareness. While this model requires significantly more instantaneous computational power, it accounts for the brain’s extraordinary ability to fluidly interpret ambiguous sentences when sufficient prior context is provided.

(E) The advent of high-resolution neuroimaging, specifically functional magnetic resonance imaging (fMRI) and electroencephalography (EEG), allowed researchers to observe parsing mechanisms in real time. EEG studies measuring event-related potentials (ERPs) identified a specific neurological signature known as the P600 effect—a positive spike in brain electrical activity occurring approximately 600 milliseconds after encountering a syntactic violation or a severe garden path anomaly. Crucially, neuroimaging demonstrated that while the brain does display strong serial tendencies in a vacuum, the introduction of rich semantic context instantaneously shifts the neurological response toward a parallel, constraint-based methodology. 

(F) Consequently, modern psycholinguistics has largely abandoned the strict dichotomy of serial versus parallel processing, embracing a hybrid, dynamic framework. The brain is now understood to be an exceptionally agile organ, defaulting to computationally efficient serial heuristics when processing isolated or highly predictable statements, yet seamlessly upregulating its cognitive architecture to process multiple syntactic pathways simultaneously when confronting nuanced, context-heavy, or deeply ambiguous linguistic environments. This plasticity highlights the evolutionary sophistication of human language centers, designed not just for communication, but for rapid adaptation to structural chaos.');

-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('b9d90afd-d01a-4b5f-a09d-beffdfae5156', 'd0082d96-4483-4b49-8ddb-db717764a627', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. The integration of competing cognitive theories","ii. The failure of modern linguistic models","iii. Evaluating the brain as a probability calculator","iv. Using deliberate confusion to understand comprehension","v. Real-time neurological evidence of linguistic processing","vi. Why the brain prefers semantic over syntactic data","vii. The single-pathway approach to grammatical interpretation","viii. Defining the subconscious sorting of sentence structure"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('d44bacec-1b80-4c1f-9b55-5da86c407d15', 'b9d90afd-d01a-4b5f-a09d-beffdfae5156', 14, 'Paragraph A', 'viii'),
('f9f8f5ec-c0b8-4034-95ad-a6cac743154e', 'b9d90afd-d01a-4b5f-a09d-beffdfae5156', 15, 'Paragraph B', 'iv'),
('3b5201ff-6080-4538-ab75-001e6f9e07e8', 'b9d90afd-d01a-4b5f-a09d-beffdfae5156', 16, 'Paragraph C', 'vii'),
('0b010a59-060d-480a-81fd-8c8af324ebee', 'b9d90afd-d01a-4b5f-a09d-beffdfae5156', 17, 'Paragraph D', 'iii'),
('4e2a928e-d968-4c9f-8cd6-2e1eb081174b', 'b9d90afd-d01a-4b5f-a09d-beffdfae5156', 18, 'Paragraph E', 'v'),
('bcfead35-91fe-49dd-ac78-faca0979d1c1', 'b9d90afd-d01a-4b5f-a09d-beffdfae5156', 19, 'Paragraph F', 'i');

-- ── Group 5: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('bdf52453-fee6-4058-aaf5-2e2388f540b9', 'd0082d96-4483-4b49-8ddb-db717764a627', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('01adf02a-42e4-419b-a160-38085e933bea', 'bdf52453-fee6-4058-aaf5-2e2388f540b9', 20,
 'A specific example illustrating how word categorization triggers structural collapse.', 'B',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('f8bbdc6d-694f-4a92-a16a-7d8ea3b99d63', 'bdf52453-fee6-4058-aaf5-2e2388f540b9', 21,
 'An explanation of how contextual information dictates the brain’s choice of parsing strategy.', 'E',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('053b8006-82c8-45da-8484-5216168724d3', 'bdf52453-fee6-4058-aaf5-2e2388f540b9', 22,
 'The argument that the brain conserves energy by committing to one initial interpretation.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('267081cf-3ca0-4245-998f-dc29a3e1eb39', 'bdf52453-fee6-4058-aaf5-2e2388f540b9', 23,
 'The conclusion that the human brain seamlessly switches between processing modes based on linguistic complexity.', 'F',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');

-- ── Group 6: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('81b7152f-efcc-4e33-98d0-ddde84657bf6', 'd0082d96-4483-4b49-8ddb-db717764a627', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('6192ad30-59ee-4ba5-80bc-bece78ff5066', '81b7152f-efcc-4e33-98d0-ddde84657bf6', 24,
 'According to the passage, linguists study "garden path" sentences primarily because they:',
 'B',
 '[{"id":"A","text":"A. Highlight the superiority of parallel processing over serial processing.","isCorrect":false},{"id":"B","text":"B. Exploit structural ambiguity to reveal the underlying mechanics of comprehension.","isCorrect":true},{"id":"C","text":"C. Demonstrate that semantic context is irrelevant to syntactic parsing.","isCorrect":false},{"id":"D","text":"D. Prove that humans cannot comprehend grammatically anomalous structures.","isCorrect":false}]'),
('f4cd35b4-723c-4981-85ee-30a0372e3d97', '81b7152f-efcc-4e33-98d0-ddde84657bf6', 25,
 'The "constraint-based" model (Paragraph D) differs from the "serial processing" model by asserting that:',
 'D',
 '[{"id":"A","text":"A. The brain frequently crashes and backtracks to conserve energy.","isCorrect":false},{"id":"B","text":"B. Syntactic interpretation relies solely on lexical frequency rather than context.","isCorrect":false},{"id":"C","text":"C. The brain evaluates a single syntactic tree before considering semantic plausibility.","isCorrect":false},{"id":"D","text":"D. Multiple grammatical interpretations are generated and weighted concurrently.","isCorrect":true}]'),
('e1138cc4-699a-48e2-8b17-be295dcaa526', '81b7152f-efcc-4e33-98d0-ddde84657bf6', 26,
 'What did the discovery of the P600 effect indicate about language processing?',
 'C',
 '[{"id":"A","text":"A. The brain requires exactly 600 milliseconds to parse straightforward sentences.","isCorrect":false},{"id":"B","text":"B. Parallel processing is entirely a myth generated by faulty computational models.","isCorrect":false},{"id":"C","text":"C. There is a distinct, measurable neurological reaction to syntactical anomalies.","isCorrect":true},{"id":"D","text":"D. Readers completely ignore syntax when provided with rich semantic clues.","isCorrect":false}]'),
('b68e8330-a7dd-4858-9767-30acc8919a96', '81b7152f-efcc-4e33-98d0-ddde84657bf6', 27,
 'The writer''s overall view of the human brain in the final paragraph is that it is:',
 'A',
 '[{"id":"A","text":"A. A highly flexible organ capable of dynamically altering its processing strategies.","isCorrect":true},{"id":"B","text":"B. Fundamentally limited by its reliance on energy-efficient serial processing.","isCorrect":false},{"id":"C","text":"C. Unable to cope efficiently with deeply ambiguous or chaotic linguistic inputs.","isCorrect":false},{"id":"D","text":"D. Designed strictly for communication rather than complex structural analysis.","isCorrect":false}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: The Epistemological Crisis in Post-Normal Science (Q28–40)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('124a6346-c48d-4ebd-9380-969d1f0e762a', '3c34ab7c-07fc-41b5-a34f-8cab934829f7', 3,
 'The Epistemological Crisis in Post-Normal Science',
 '(A) For centuries, the framework governing scientific inquiry was rooted in the Kuhnian concept of "normal science"—a paradigm in which highly trained experts work within established boundaries to solve discrete puzzles. In this traditional model, uncertainty is treated as a manageable anomaly, reducible through increased empirical observation and refined instrumentation. The objective neutrality of the scientist was assumed inviolable, and the resulting empirical facts were considered the ultimate arbiters of public policy. However, the dawn of the 21st century has seen this paradigm fracture under the weight of unprecedented, complex global crises, precipitating what philosophers of science term an epistemological crisis.

(B) The concept of "Post-Normal Science" (PNS), pioneered by Silvio Funtowicz and Jerome Ravetz in the early 1990s, provides a theoretical scaffolding for understanding this fracture. Funtowicz and Ravetz argued that traditional scientific methodologies are profoundly inadequate when addressing contemporary meta-crises—such as anthropogenic climate change, synthetic biology, and global pandemic modeling. In these domains, two critical variables are invariably maximized: "systems uncertainty" and "decision stakes." When the potential consequences of a policy decision are planetary in scale, and the underlying systems are too complex to yield precise predictive models, science ceases to be an exercise in mere puzzle-solving.

(C) Under post-normal conditions, the traditional epistemological boundary between objective "fact" and subjective "value" dissolves. Because irreducible uncertainty is inherent to these complex systems, scientists are increasingly forced to make methodological choices based on subjective risk assessments and value judgments. For instance, in modeling sea-level rise, the decision to prioritize avoiding "false alarms" versus avoiding "missed catastrophes" is not a purely scientific calculation; it is inherently political. Consequently, the facade of the dispassionate, entirely neutral scientist is increasingly viewed not just as an illusion, but as a potentially dangerous obfuscation of the value-laden nature of modern scientific pronouncements.

(D) To mitigate the democratic deficit created by this shift, PNS advocates for the implementation of an "extended peer community." In normal science, the validity of a claim is determined exclusively by a closed circle of domain-specific experts through traditional peer review. Funtowicz and Ravetz contend that when science is deployed to manage high-stakes, highly uncertain societal risks, the monopoly on expertise must be broken. An extended peer community incorporates not only interdisciplinary scholars but also "lay experts"—journalists, indigenous populations, and local stakeholders whose experiential knowledge and ethical perspectives are deemed vital for assessing the quality and viability of policy-oriented science.

(E) Unsurprisingly, the transition toward a post-normal framework has met ferocious resistance from institutional traditionalists. Critics argue that democratizing the scientific process risks opening the floodgates to epistemological relativism, wherein established physical laws are subjected to the whims of public opinion or political populism. They posit that while extending the peer community might enhance the democratic legitimacy of environmental policy, it severely compromises the methodological rigor required to actually solve complex ecological challenges. The fear is that "lay expertise" is a euphemism for scientific illiteracy, leading to policy paralysis driven by competing, incommensurable ideologies.

(F) Despite these critiques, the trajectory of contemporary ecological and technological crises ensures that a return to the insulated sanctuary of normal science is impossible. The scientific community is currently undergoing a painful maturation process, learning to articulate its findings not as irrefutable truths, but as highly informed, probabilistic assessments operating under conditions of deep uncertainty. Resolving this epistemological crisis requires a delicate balancing act: maintaining rigorous empirical standards while simultaneously integrating the broader societal values necessary to navigate the perilous, high-stakes decisions of the modern era.');

-- ── Group 7: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('a5f512f0-72d9-430d-8dcd-11cd9f465dcb', '124a6346-c48d-4ebd-9380-969d1f0e762a', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('29f1172a-75ee-4488-8008-f8fe7418db78', 'a5f512f0-72d9-430d-8dcd-11cd9f465dcb', 28,
 'In the traditional paradigm of "normal science", scientists believed that all uncertainty could eventually be eliminated through better methodology.', 'YES', '["YES","Yes","yes"]'),
('dda57a37-0fde-4414-8ff0-62c681a2d42c', 'a5f512f0-72d9-430d-8dcd-11cd9f465dcb', 29,
 'Funtowicz and Ravetz originally developed the theory of Post-Normal Science while researching global pandemic models.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('44be590f-2580-4b70-a718-0d7be1a14b18', 'a5f512f0-72d9-430d-8dcd-11cd9f465dcb', 30,
 'Under post-normal conditions, methodological choices in scientific modeling are entirely insulated from political or subjective bias.', 'NO', '["NO","No","no"]'),
('3db9a539-d123-4362-a0e7-3f93ee5c21a7', 'a5f512f0-72d9-430d-8dcd-11cd9f465dcb', 31,
 'Institutional traditionalists support the inclusion of "lay experts" as long as it does not affect environmental policy.', 'NO', '["NO","No","no"]');

-- ── Group 8: MATCHING SENTENCE ENDINGS (Q32–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c792c62a-8ff3-4e2b-8627-73aa883770a4', '124a6346-c48d-4ebd-9380-969d1f0e762a', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('a6a558e1-0567-4d74-9d2b-e448f5869efc', 'c792c62a-8ff3-4e2b-8627-73aa883770a4', 32,
 'According to traditional scientific methodology, the role of a highly trained expert was to',
 'E',
 '[{"id":"A","text":"increase democratic legitimacy despite complex ecological challenges.","isCorrect":false},{"id":"B","text":"present scientific findings as absolute and irrefutable truths.","isCorrect":false},{"id":"C","text":"incorporate subjective risk assessments into environmental modeling.","isCorrect":false},{"id":"D","text":"address contemporary issues where systems uncertainty is inherently high.","isCorrect":false},{"id":"E","text":"function within established frameworks to solve clearly defined puzzles.","isCorrect":true},{"id":"F","text":"invite public participation in highly speculative biological research.","isCorrect":false}]'),
('65505dac-a0b0-4780-bef9-7904ddb416a7', 'c792c62a-8ff3-4e2b-8627-73aa883770a4', 33,
 'The theoretical framework of Post-Normal Science (PNS) is specifically designed to',
 'D',
 '[{"id":"A","text":"increase democratic legitimacy despite complex ecological challenges.","isCorrect":false},{"id":"B","text":"present scientific findings as absolute and irrefutable truths.","isCorrect":false},{"id":"C","text":"incorporate subjective risk assessments into environmental modeling.","isCorrect":false},{"id":"D","text":"address contemporary issues where systems uncertainty is inherently high.","isCorrect":true},{"id":"E","text":"function within established frameworks to solve clearly defined puzzles.","isCorrect":false},{"id":"F","text":"invite public participation in highly speculative biological research.","isCorrect":false}]'),
('38ca5983-d215-4add-a75f-d0595e731d92', 'c792c62a-8ff3-4e2b-8627-73aa883770a4', 34,
 'Advocates of the "extended peer community" believe that expanding who assesses science will',
 'C',
 '[{"id":"A","text":"increase democratic legitimacy despite complex ecological challenges.","isCorrect":false},{"id":"B","text":"present scientific findings as absolute and irrefutable truths.","isCorrect":false},{"id":"C","text":"incorporate subjective risk assessments into environmental modeling.","isCorrect":true},{"id":"D","text":"address contemporary issues where systems uncertainty is inherently high.","isCorrect":false},{"id":"E","text":"function within established frameworks to solve clearly defined puzzles.","isCorrect":false},{"id":"F","text":"invite public participation in highly speculative biological research.","isCorrect":false}]'),
('5b337c7d-12c7-4db4-a1a9-4fdfb7b4898e', 'c792c62a-8ff3-4e2b-8627-73aa883770a4', 35,
 'Currently, the broader scientific establishment must learn to abandon the tendency to',
 'B',
 '[{"id":"A","text":"increase democratic legitimacy despite complex ecological challenges.","isCorrect":false},{"id":"B","text":"present scientific findings as absolute and irrefutable truths.","isCorrect":true},{"id":"C","text":"incorporate subjective risk assessments into environmental modeling.","isCorrect":false},{"id":"D","text":"address contemporary issues where systems uncertainty is inherently high.","isCorrect":false},{"id":"E","text":"function within established frameworks to solve clearly defined puzzles.","isCorrect":false},{"id":"F","text":"invite public participation in highly speculative biological research.","isCorrect":false}]');

-- ── Group 9: SUMMARY COMPLETION with Word Bank (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('21c5d122-0e60-467b-b918-5f2e864c0ee2', '124a6346-c48d-4ebd-9380-969d1f0e762a', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["anomaly", "values", "relativism", "uncertainty", "paralysis", "stakeholders", "neutrality", "populism", "methodology"]');

-- For SUMMARY_COMPLETION: first question text = summary template, subsequent ones are empty text.
INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('7c18101b-9952-4e5e-80f0-0a7791569f2c', '21c5d122-0e60-467b-b918-5f2e864c0ee2', 36,
 'The shift toward Post-Normal Science forces a re-evaluation of how scientific authority is constructed. In traditional paradigms, scientific {{gap_21c5d122-0e60-467b-b918-5f2e864c0ee2_0}} was unquestioned, and facts were distinct from societal ethics. However, modern global crises involve such profound {{gap_21c5d122-0e60-467b-b918-5f2e864c0ee2_1}} that objective calculations are no longer sufficient. To ensure policy is democratic, Funtowicz and Ravetz propose involving diverse {{gap_21c5d122-0e60-467b-b918-5f2e864c0ee2_2}}, including non-scientists, in the review process. Detractors fear that this democratization will erode rigorous standards and foster epistemological {{gap_21c5d122-0e60-467b-b918-5f2e864c0ee2_3}}, leading to decision-making driven by ideology rather than evidence. Despite this resistance, scientists must learn to present their probabilistic models while acknowledging the deep societal {{gap_21c5d122-0e60-467b-b918-5f2e864c0ee2_4}} required to act upon them.',
 'neutrality'),
('b116656a-c2c0-485b-bdf0-8b8eafda614a', '21c5d122-0e60-467b-b918-5f2e864c0ee2', 37,
 '', 'uncertainty'),
('1e057d9a-16c8-484d-9690-72789049935c', '21c5d122-0e60-467b-b918-5f2e864c0ee2', 38,
 '', 'stakeholders'),
('8f3db036-8987-49bb-9057-d879a05a4f34', '21c5d122-0e60-467b-b918-5f2e864c0ee2', 39,
 '', 'relativism'),
('d49f4f75-4881-4c83-ad21-ce86e4045b8b', '21c5d122-0e60-467b-b918-5f2e864c0ee2', 40,
 '', 'values');

-- ============================================================
-- NOTE: Please execute `UPDATE reading_tests SET created_by = '<your-uid>'` 
-- if required by your application's Row Level Security policies.
-- ============================================================
