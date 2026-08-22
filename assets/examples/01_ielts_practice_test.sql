-- ============================================================
-- IELTS Practice Platform – Comprehensive Seed Data
-- Run: sqlite3 <db-path> < 01_ielts_practice_test.sql   (after applying migrations)
-- ============================================================
-- NOTE: `created_by` uses a placeholder UUID. After seeding,
-- update it to a real user id so the app associates this content
-- with the correct user:
--   UPDATE reading_tests  SET created_by = '<your-uid>';
--   UPDATE listening_tests SET created_by = '<your-uid>';
--   UPDATE writing_tests  SET created_by = '<your-uid>';
-- ============================================================

-- Clean slate (cascade deletes children)
DELETE FROM writing_tasks;
DELETE FROM writing_tests;
DELETE FROM listening_questions;
DELETE FROM listening_question_groups;
DELETE FROM listening_sections;
DELETE FROM listening_tests;
DELETE FROM reading_questions;
DELETE FROM reading_question_groups;
DELETE FROM reading_passages;
DELETE FROM reading_tests;

-- Placeholder author
-- (auth.users check removed: not applicable to SQLite)


-- ████████████████████████████████████████████████████████████████
-- ██  1. READING TEST – ALL 13 QUESTION TYPES (40 questions)   ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('c574e32b-ddec-402d-9fbf-772f4c92dce8', 'fe38ed89-f1fe-4b88-9609-8736be47f61e',
 'IELTS Comprehensive Practice Test: Technology, Psychology & Evolution (Band 7)', 'Academic', '7', '60 mins', 'published');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: The Evolution of the Bicycle (Q1–13)        ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('5e4a4573-84f0-43ed-bd6b-495d8176884a', 'c574e32b-ddec-402d-9fbf-772f4c92dce8', 1,
 'The Evolution of the Bicycle',
 '(A) The bicycle is one of the most successful human-powered means of transport ever devised. Its origins can be traced to the early nineteenth century, when a German inventor named Karl von Drais created the "Laufmaschine" (running machine) in 1817. This device, also known as a draisine, consisted of two wheels connected by a wooden frame, with a handlebar for steering. The rider sat astride the frame and propelled the machine by pushing against the ground with alternating feet — there were no pedals. Despite its simplicity, the draisine proved popular among European aristocrats as a novel form of recreation.

(B) The next major development came in the 1860s, when French metalworkers Pierre Michaux and Pierre Lallement attached cranks and pedals directly to the front wheel of a draisine-style frame. The resulting machine, known as the velocipede or "boneshaker," represented a fundamental advance because it allowed riders to propel themselves without touching the ground. However, the direct-drive mechanism meant that one revolution of the pedals produced only one revolution of the wheel, limiting the machine''s speed. To compensate, manufacturers began making the front wheel larger, culminating in the penny-farthing of the 1870s, which featured a front wheel up to 1.5 metres in diameter.

(C) The penny-farthing, while faster than its predecessors, was inherently dangerous. Riders sat high above the ground, and any sudden obstruction could pitch them forward over the handlebars in a fall known as "taking a header." The machine was also difficult to mount and dismount, and required considerable physical strength to operate. These limitations meant that cycling remained an activity primarily for young, athletic men.

(D) The invention that truly democratised cycling was the safety bicycle, developed in the 1880s by John Kemp Starley in Coventry, England. Starley''s design featured two wheels of equal size, a chain-driven rear wheel, and a diamond-shaped frame that placed the rider closer to the ground. The Rover Safety Bicycle, introduced in 1885, is widely regarded as the prototype for the modern bicycle. Within a decade, the addition of pneumatic tyres — invented by John Boyd Dunlop in 1888 — and the development of reliable braking systems made the bicycle both comfortable and safe enough for widespread adoption.

(E) The social impact of the safety bicycle was profound. For the first time, ordinary people of modest means could travel independently at speeds of 15 to 20 kilometres per hour, dramatically expanding their range of movement. The bicycle proved particularly liberating for women, who had previously been largely confined to walking or horse-drawn transport. The American suffragist Susan B. Anthony declared in 1896 that the bicycle had "done more to emancipate women than anything else in the world." Cycling clubs and touring societies flourished, and the bicycle became a symbol of personal freedom and modernity.

(F) Today, an estimated one billion bicycles are in use worldwide — more than twice the number of motor vehicles. In countries such as the Netherlands and Denmark, bicycles account for over 25 percent of all urban trips. Modern innovations include electric-assist bicycles, carbon-fibre frames, and bike-sharing systems that have been adopted by hundreds of cities around the globe. The fundamental design, however, remains remarkably similar to Starley''s safety bicycle of 1885, a testament to the elegance and efficiency of his original concept.');


-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–3) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('85ccb4be-900f-435e-a3cb-394e4b108b3b', '5e4a4573-84f0-43ed-bd6b-495d8176884a', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the passage? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('5275dbd9-5b38-4171-9821-7c6942bfa612', '85ccb4be-900f-435e-a3cb-394e4b108b3b', 1,
 'Karl von Drais''s original machine included pedals for propulsion.', 'FALSE', '["FALSE","False","false"]'),
('3fe008ba-5768-4c71-ad62-0eef504499d1', '85ccb4be-900f-435e-a3cb-394e4b108b3b', 2,
 'The penny-farthing was safer to ride than earlier bicycle designs.', 'FALSE', '["FALSE","False","false"]'),
('ab7a787b-c39a-4186-b8ea-34cdcdb0fe1e', '85ccb4be-900f-435e-a3cb-394e4b108b3b', 3,
 'John Boyd Dunlop was a colleague of John Kemp Starley.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]');


-- ── Group 2: SHORT ANSWER (Q4–6) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('1e149b5f-71fb-426c-ae37-40129c54f125', '5e4a4573-84f0-43ed-bd6b-495d8176884a', 2,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS from the passage for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('5bf4fdb8-1340-4ef4-b1b5-5baf79a4ef74', '1e149b5f-71fb-426c-ae37-40129c54f125', 4,
 'What was the other name for the draisine?', 'running machine', '[{"id":"1","text":"running machine"},{"id":"2","text":"Laufmaschine"}]'),
('d3b7b440-6f44-4ad2-bfb5-7047cea3a83f', '1e149b5f-71fb-426c-ae37-40129c54f125', 5,
 'In which English city was the safety bicycle developed?', 'Coventry', '[{"id":"1","text":"Coventry"},{"id":"2","text":"coventry"}]'),
('1c7d0bdf-f4b1-49cb-9bea-de6f2b4fdb2c', '1e149b5f-71fb-426c-ae37-40129c54f125', 6,
 'How many bicycles are estimated to be in use worldwide today?', 'one billion', '[{"id":"1","text":"one billion"},{"id":"2","text":"1 billion"}]');


-- ── Group 3: SENTENCE COMPLETION (Q7–8) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('78e93d83-7920-4476-9a15-04e698d8befc', '5e4a4573-84f0-43ed-bd6b-495d8176884a', 3,
 'sentence-completion', 'Complete the sentences below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('a62ac865-8a6b-41f7-876f-08f154a13954', '78e93d83-7920-4476-9a15-04e698d8befc', 7,
 'The velocipede was nicknamed the {{gap}} because of its uncomfortable ride.', 'boneshaker', '[{"id":"1","text":"boneshaker"}]'),
('9113e59a-71f0-4421-9d2b-02dace46e1cf', '78e93d83-7920-4476-9a15-04e698d8befc', 8,
 'Susan B. Anthony said the bicycle helped to {{gap}} women.', 'emancipate', '[{"id":"1","text":"emancipate"}]');


-- ── Group 4: TABLE COMPLETION (Q9–11) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('98ead4d1-787b-4dab-804a-ed80fd6e9aba', '5e4a4573-84f0-43ed-bd6b-495d8176884a', 4,
 'table-completion', 'Complete the table below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('fea07731-73c7-405f-a473-aa3ce408dc9a', '98ead4d1-787b-4dab-804a-ed80fd6e9aba', 9,
 'Row 1', '',
 '[{"id":"h1","gapText":"Era","answer":""},{"id":"h2","gapText":"Innovation","answer":""},{"id":"h3","gapText":"Key Feature","answer":""}]'),
('22ac46b6-008f-4810-86c5-889e9ee09a05', '98ead4d1-787b-4dab-804a-ed80fd6e9aba', 10,
 'Row 2', '',
 '[{"id":"c1","gapText":"1817","answer":""},{"id":"c2","gapText":"Draisine","answer":""},{"id":"c3","gapText":"","answer":"wooden frame"}]'),
('c70d827f-f3dd-4986-959d-50c50b3f9361', '98ead4d1-787b-4dab-804a-ed80fd6e9aba', 11,
 'Row 3', '',
 '[{"id":"c4","gapText":"1860s","answer":""},{"id":"c5","gapText":"","answer":"velocipede"},{"id":"c6","gapText":"cranks and pedals","answer":""}]');


-- ── Group 5: NOTE COMPLETION (Q12–13) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('3111ccb8-7fc4-419b-b2ee-60b0ec988384', '5e4a4573-84f0-43ed-bd6b-495d8176884a', 5,
 'note-completion', 'Complete the notes below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('e3fe23fb-0e6a-40bd-95c2-3bad243dea4e', '3111ccb8-7fc4-419b-b2ee-60b0ec988384', 12,
 'The penny-farthing''s front wheel could be up to {{gap}} in diameter.', '1.5 metres', '[{"id":"1","text":"1.5 metres"},{"id":"2","text":"1.5 meters"}]'),
('0ea44d62-6906-476a-b31a-4924c5872b88', '3111ccb8-7fc4-419b-b2ee-60b0ec988384', 13,
 'In the Netherlands and Denmark, bicycles account for over {{gap}} of urban trips.', '25 percent', '[{"id":"1","text":"25 percent"},{"id":"2","text":"25%"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: AI on Workspaces (Q14–27)                   ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('501a1d6f-ece1-4fcc-89c6-18ae4b94ef89', 'c574e32b-ddec-402d-9fbf-772f4c92dce8', 2,
 'The Impact of Artificial Intelligence on Workspaces',
 '(A) Artificial intelligence is transforming the modern workplace at an unprecedented pace. From automated customer-service chatbots to sophisticated data-analysis platforms, AI technologies are being integrated into virtually every industry. A 2024 survey by McKinsey Global Institute found that 72 percent of companies had adopted at least one AI capability, up from 55 percent just two years earlier. This rapid adoption has sparked both enthusiasm about productivity gains and anxiety about potential job displacement.

(B) The most immediate impact of AI has been on routine, repetitive tasks. In manufacturing, robotic process automation (RPA) has been deployed to handle assembly-line operations, quality-control inspections, and inventory management with greater speed and consistency than human workers. In the service sector, natural language processing algorithms now handle a significant proportion of customer enquiries, from answering frequently asked questions to processing insurance claims. A study by the World Economic Forum estimated that by 2025, machines would perform more task hours than humans in the workplace for the first time.

(C) However, the relationship between AI and employment is more nuanced than simple replacement. While AI excels at tasks that are structured, data-intensive, and rule-based, it struggles with activities requiring creativity, empathy, complex judgment, and interpersonal communication. Many experts argue that AI is more likely to augment human capabilities than to replace entire jobs. Dr. Elena Vasquez of MIT has described this as "the collaboration model," in which humans and machines each contribute their comparative advantages. For example, a radiologist might use an AI system to flag potential anomalies in medical images, but the final diagnosis and patient communication remain firmly in the hands of the human doctor.

(D) The rise of AI has also created entirely new categories of employment. Roles such as AI trainer, data curator, machine learning engineer, and algorithmic ethics officer did not exist a decade ago but are now among the fastest-growing occupations. Professor Kenji Tanaka of Tokyo University has noted that historically, every major technological revolution — from the steam engine to the internet — has ultimately created more jobs than it destroyed, though the transition period can be disruptive and painful for affected workers.

(E) Organisations are increasingly recognising the importance of reskilling and upskilling their workforce to prepare for an AI-augmented future. Major technology companies including Google, Amazon, and Microsoft have launched free or subsidised training programmes in AI literacy, data science, and digital skills. Governments in countries such as Singapore, Finland, and Canada have implemented national AI strategies that include significant investments in education and retraining. The consensus among policymakers is that proactive investment in human capital is essential to ensure that the benefits of AI are broadly shared.

(F) Ethical considerations surrounding AI in the workplace are receiving growing attention. Concerns include algorithmic bias in hiring and promotion decisions, surveillance of employee behaviour through AI-powered monitoring tools, and the erosion of worker autonomy as AI systems increasingly dictate task allocation and scheduling. The European Union''s AI Act, which came into force in 2024, represents the first comprehensive regulatory framework for artificial intelligence, establishing risk categories and mandatory requirements for high-risk AI applications in employment.');


-- ── Group 6: MATCHING HEADINGS (Q14–17) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('bb43b38f-b448-46c5-b0a1-ea8d0148de54', '501a1d6f-ece1-4fcc-89c6-18ae4b94ef89', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for paragraphs B, C, D and E from the list of headings below.', true,
 true, '["i. The automation of routine work","ii. Regulation and ethical concerns","iii. A balanced view of AI and jobs","iv. Investing in workforce adaptation","v. New roles born from technology","vi. The global spread of AI adoption"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('9bfe4d52-185f-477a-9c36-7b4551ed0657', 'bb43b38f-b448-46c5-b0a1-ea8d0148de54', 14, 'B', 'i'),
('d46fec97-2894-4ae3-8dba-5583828f217f', 'bb43b38f-b448-46c5-b0a1-ea8d0148de54', 15, 'C', 'iii'),
('f56c9109-f2b3-4fa2-890c-328ab9a8d6cd', 'bb43b38f-b448-46c5-b0a1-ea8d0148de54', 16, 'D', 'v'),
('b78102bd-8f2e-4527-998a-6b760509e612', 'bb43b38f-b448-46c5-b0a1-ea8d0148de54', 17, 'E', 'iv');


-- ── Group 7: MATCHING INFORMATION (Q18–21) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('d4d9f1c2-d8c3-4f50-87b5-6c6317c1beb8', '501a1d6f-ece1-4fcc-89c6-18ae4b94ef89', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('dba737f1-4c4e-4c1a-9b89-4bf0206e481a', 'd4d9f1c2-d8c3-4f50-87b5-6c6317c1beb8', 18,
 'A prediction about machines performing more work than humans', 'B',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('8f939d09-5dd3-4edd-a43b-7adee781f47f', 'd4d9f1c2-d8c3-4f50-87b5-6c6317c1beb8', 19,
 'An example of how AI and humans can work together in healthcare', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('017dc069-0dd4-4759-a0df-533143c8c00c', 'd4d9f1c2-d8c3-4f50-87b5-6c6317c1beb8', 20,
 'Reference to a specific piece of AI legislation', 'F',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('68297aeb-57ec-45b3-a9ce-4db9b0a66f87', 'd4d9f1c2-d8c3-4f50-87b5-6c6317c1beb8', 21,
 'A historical comparison between AI and previous technological changes', 'D',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');


-- ── Group 8: MULTIPLE CHOICE (Q22–24) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('ac239171-43c7-461b-a223-aaeb2bca699c', '501a1d6f-ece1-4fcc-89c6-18ae4b94ef89', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('8394783a-53f1-4731-8272-493fe098404e', 'ac239171-43c7-461b-a223-aaeb2bca699c', 22,
 'According to the passage, AI is LEAST effective at tasks that require',
 'B',
 '[{"id":"A","text":"A. processing large datasets","isCorrect":false},{"id":"B","text":"B. creativity and empathy","isCorrect":true},{"id":"C","text":"C. following established rules","isCorrect":false},{"id":"D","text":"D. repetitive quality checks","isCorrect":false}]'),
('c775af6b-826f-44ac-a891-d07e3537328c', 'ac239171-43c7-461b-a223-aaeb2bca699c', 23,
 'Dr. Elena Vasquez describes the ideal AI-workplace relationship as',
 'C',
 '[{"id":"A","text":"A. full automation of all tasks","isCorrect":false},{"id":"B","text":"B. a temporary transition phase","isCorrect":false},{"id":"C","text":"C. a collaboration model","isCorrect":true},{"id":"D","text":"D. a replacement strategy","isCorrect":false}]'),
('e1199203-bc9f-4788-b6a7-82490af87c5d', 'ac239171-43c7-461b-a223-aaeb2bca699c', 24,
 'The McKinsey survey found that AI adoption among companies',
 'A',
 '[{"id":"A","text":"A. increased significantly over a two-year period","isCorrect":true},{"id":"B","text":"B. remained stable since 2020","isCorrect":false},{"id":"C","text":"C. was concentrated in manufacturing only","isCorrect":false},{"id":"D","text":"D. declined due to regulatory concerns","isCorrect":false}]');


-- ── Group 9: FLOWCHART COMPLETION (Q25–27) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('cb704b3c-20f5-4c77-94af-273b8d9a3d27', '501a1d6f-ece1-4fcc-89c6-18ae4b94ef89', 4,
 'flowchart-completion', 'Complete the flowchart below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('b4f493aa-4f30-44f1-8272-cf2b6a8a630f', 'cb704b3c-20f5-4c77-94af-273b8d9a3d27', 25,
 'AI systems handle {{gap}} tasks in manufacturing and services', 'routine'),
('b458fcea-a71d-4c45-b792-d0374fdf090d', 'cb704b3c-20f5-4c77-94af-273b8d9a3d27', 26,
 'This leads to concerns about {{gap}} for affected workers', 'job displacement'),
('8d154a74-4e71-4d3e-85b9-722d2eee8c58', 'cb704b3c-20f5-4c77-94af-273b8d9a3d27', 27,
 'Companies respond by investing in {{gap}} programmes', 'reskilling');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: Consumer Behavior Psychology (Q28–40)       ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('c9d1c541-9b45-431c-bebb-73170ef4d5aa', 'c574e32b-ddec-402d-9fbf-772f4c92dce8', 3,
 'The Psychology of Consumer Behaviour',
 '(A) Why do people buy what they buy? This seemingly simple question has occupied researchers in psychology, economics, and marketing for over a century. Consumer behaviour — the study of how individuals make decisions about what to purchase, use, and discard — sits at the intersection of multiple academic disciplines and has profound implications for businesses, policymakers, and society at large.

(B) One of the foundational theories in consumer psychology is Maslow''s hierarchy of needs, which suggests that people prioritise purchases that fulfil basic physiological and safety needs before spending on higher-order desires such as social belonging, esteem, and self-actualisation. However, modern research has shown that consumers frequently deviate from this rational hierarchy. Professor Sarah Chen of Harvard Business School has demonstrated that emotional factors often override practical considerations, with consumers regularly paying premium prices for brands that align with their personal identity or social aspirations.

(C) The concept of "bounded rationality," introduced by Nobel laureate Herbert Simon, provides another lens for understanding consumer decisions. Simon argued that people do not optimise their choices by evaluating all available options; instead, they "satisfice" — settling for the first option that meets a minimum threshold of acceptability. This insight has been further developed by Dr. Robert Hartley of the London School of Economics, who has shown that the abundance of choice in modern markets can actually paralyse consumers, a phenomenon he terms "choice overload." In experiments, Hartley found that consumers presented with 24 options were ten times less likely to make a purchase than those offered only 6 options.

(D) Social influence plays a powerful role in shaping consumer behaviour. Dr. Maria Gonzalez of Stanford University has researched how peer recommendations and online reviews have become the dominant factors in purchase decisions, surpassing traditional advertising in their persuasive impact. Her work shows that consumers trust recommendations from other consumers approximately three times more than they trust brand-generated content. The rise of social media influencer marketing is a direct consequence of this dynamic.

(E) The field of behavioural economics has revealed numerous cognitive biases that systematically affect consumer choices. The "anchoring effect" causes consumers to rely heavily on the first price they encounter, making an initial high price seem reasonable when followed by a discounted offer. The "endowment effect" leads people to value items more highly once they own them, which is why free trials and money-back guarantees are such effective marketing strategies. Dr. Hartley has extended this research to show that the "decoy effect" — introducing a clearly inferior third option — can increase sales of a target product by up to 40 percent.

(F) Neuromarketing, which uses brain-imaging technology to study consumer responses, represents the cutting edge of the field. Research using functional magnetic resonance imaging (fMRI) has shown that brand logos can activate the same neural pathways associated with personal relationships and self-identity. Professor Chen has argued that this finding explains why brand loyalty often persists even when competing products offer objectively better value. Critics, including Dr. Gonzalez, have cautioned that neuromarketing raises significant ethical questions about the potential for manipulation of consumer decision-making.');


-- ── Group 10: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('85ecae3f-c150-410b-9bed-b41364fc4bdf', 'c9d1c541-9b45-431c-bebb-73170ef4d5aa', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('52d374a9-955d-44ff-964f-cd119458f219', '85ecae3f-c150-410b-9bed-b41364fc4bdf', 28,
 'Consumers always follow Maslow''s hierarchy when making purchases.', 'NO', '["NO","No","no"]'),
('5f6b02f7-05c0-454d-bec0-6bde8634d6af', '85ecae3f-c150-410b-9bed-b41364fc4bdf', 29,
 'Having more options available makes it easier for consumers to decide.', 'NO', '["NO","No","no"]'),
('2d98e398-a5a7-4dbc-beda-5a28679547a1', '85ecae3f-c150-410b-9bed-b41364fc4bdf', 30,
 'Social media influencer marketing has declined in effectiveness recently.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('d5cb8f89-fdae-403c-af6b-3b242cc942c6', '85ecae3f-c150-410b-9bed-b41364fc4bdf', 31,
 'Neuromarketing research has been banned in some countries.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]');


-- ── Group 11: MATCHING FEATURES (Q32–34) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('5f885113-2766-45d6-84b2-1743984eb3a8', 'c9d1c541-9b45-431c-bebb-73170ef4d5aa', 2,
 'matching-features', 'Look at the following statements and the list of researchers below. Match each statement with the correct researcher, A, B or C.', true,
 true, '["A. Professor Sarah Chen","B. Dr. Robert Hartley","C. Dr. Maria Gonzalez"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('0f077494-fb0b-4957-a2b4-77364b0ce0a1', '5f885113-2766-45d6-84b2-1743984eb3a8', 32,
 'Showed that an inferior third option can boost sales of a target product.', 'B. Dr. Robert Hartley'),
('8f76a698-7bbf-4a27-9a8a-585c56d284d8', '5f885113-2766-45d6-84b2-1743984eb3a8', 33,
 'Found that consumers trust other consumers far more than brand messaging.', 'C. Dr. Maria Gonzalez'),
('13ebd53e-a89e-452f-a92f-475736b6a59c', '5f885113-2766-45d6-84b2-1743984eb3a8', 34,
 'Argues that brand logos activate neural pathways related to personal identity.', 'A. Professor Sarah Chen');


-- ── Group 12: MATCHING SENTENCE ENDINGS (Q35–37) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('17f55ea3-3a26-4540-a642-2799e169eaf7', 'c9d1c541-9b45-431c-bebb-73170ef4d5aa', 3,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–E, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('138cfaa3-9a99-4775-95a2-5c9f1cde59cc', '17f55ea3-3a26-4540-a642-2799e169eaf7', 35,
 'Herbert Simon argued that consumers do not evaluate all options but instead',
 'C',
 '[{"id":"A","text":"activate neural pathways associated with personal identity.","isCorrect":false},{"id":"B","text":"trust peer recommendations more than brand advertising.","isCorrect":false},{"id":"C","text":"settle for the first acceptable choice they find.","isCorrect":true},{"id":"D","text":"pay premium prices for emotionally appealing brands.","isCorrect":false},{"id":"E","text":"become paralysed when faced with too many options.","isCorrect":false}]'),
('0fecb879-6932-4b5a-ae91-42fa1ab15835', '17f55ea3-3a26-4540-a642-2799e169eaf7', 36,
 'According to the passage, the endowment effect explains why consumers',
 'D',
 '[{"id":"A","text":"activate neural pathways associated with personal identity.","isCorrect":false},{"id":"B","text":"trust peer recommendations more than brand advertising.","isCorrect":false},{"id":"C","text":"settle for the first acceptable choice they find.","isCorrect":false},{"id":"D","text":"value items more once they possess them.","isCorrect":true},{"id":"E","text":"become paralysed when faced with too many options.","isCorrect":false}]'),
('64f94f5f-7670-445e-982c-5d07e6c50292', '17f55ea3-3a26-4540-a642-2799e169eaf7', 37,
 'Research using brain imaging has shown that brand logos can',
 'A',
 '[{"id":"A","text":"activate neural pathways associated with personal identity.","isCorrect":true},{"id":"B","text":"trust peer recommendations more than brand advertising.","isCorrect":false},{"id":"C","text":"settle for the first acceptable choice they find.","isCorrect":false},{"id":"D","text":"value items more once they possess them.","isCorrect":false},{"id":"E","text":"become paralysed when faced with too many options.","isCorrect":false}]');


-- ── Group 13: SUMMARY COMPLETION with Word Bank (Q38–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('40d2a520-a742-412e-886f-d36cc3428d6f', 'c9d1c541-9b45-431c-bebb-73170ef4d5aa', 4,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["satisfice","anchoring","decoy","endowment","overload","bounded","manipulation"]');

-- For SUMMARY_COMPLETION: first question text = summary template, all questions provide answers
INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('a2663d8a-0c07-4c46-8c2c-b35a9d9901b2', '40d2a520-a742-412e-886f-d36cc3428d6f', 38,
 'Herbert Simon''s concept of {{gap_40d2a520-a742-412e-886f-d36cc3428d6f_0}} rationality explains that consumers do not fully optimise decisions. Instead, they {{gap_40d2a520-a742-412e-886f-d36cc3428d6f_1}} by choosing the first acceptable option. Retailers exploit the {{gap_40d2a520-a742-412e-886f-d36cc3428d6f_2}} effect by introducing an inferior option to steer buyers toward a target product.',
 'bounded'),
('5ca9cd91-5d12-4c6c-9352-81272e2d660a', '40d2a520-a742-412e-886f-d36cc3428d6f', 39,
 '', 'satisfice'),
('65824d6e-01ef-481f-b8c6-514c9531fc16', '40d2a520-a742-412e-886f-d36cc3428d6f', 40,
 '', 'decoy');


-- ████████████████████████████████████████████████████████████
-- ██  2. LISTENING TEST                                     ██
-- ████████████████████████████████████████████████████████████

INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status) VALUES
('ac2b9026-21d2-4e09-8f7e-cac388435b16', 'fe38ed89-f1fe-4b88-9609-8736be47f61e',
 'IELTS Listening: Travel, Culture & Environmental Science (Band 7)', '7', '40 mins', 'published');

-- ── Section 1: Hotel Booking ────────────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('de9f3a2b-3e7c-45ae-9283-8851265aaf9e', 'ac2b9026-21d2-4e09-8f7e-cac388435b16', 1,
 'Hotel Booking Enquiry',
 'Receptionist: Good morning, Riverside Hotel. How can I help you?
Caller: Hello, I''d like to book a room for next weekend, please.
Receptionist: Certainly. Could I take your name?
Caller: Yes, it''s Margaret Thornton. That''s T-H-O-R-N-T-O-N.
Receptionist: Thank you, Ms Thornton. And what dates were you looking at?
Caller: I''d like to check in on Friday the 14th of March and check out on Monday the 17th. So that''s three nights.
Receptionist: Let me check availability... Yes, we have rooms available. Would you prefer a standard room or a deluxe suite?
Caller: What''s the price difference?
Receptionist: A standard room is 85 pounds per night and the deluxe suite is 140 pounds per night. Both include breakfast.
Caller: I''ll go with the standard room, please.
Receptionist: Excellent. And could I have a contact telephone number?
Caller: Yes, it''s 07742 539 168.
Receptionist: Thank you. Will you be requiring parking?
Caller: Yes, please. Is there a charge?
Receptionist: Parking is complimentary for all guests. I''ll note that down. Is there anything else?
Caller: Actually, could you arrange an airport transfer for me? I''m arriving at Heathrow at 2.30 pm.
Receptionist: Of course. The transfer service costs 45 pounds each way. Shall I book a return as well?
Caller: Just the one way for now, thanks.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('1819acfa-9001-4fb2-bbfc-8f928a5e4931', 'de9f3a2b-3e7c-45ae-9283-8851265aaf9e', 1,
 'sentence-completion', 'Complete the booking form below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('626a5b8d-5cbe-413f-bf53-b4c29052cd1b', '1819acfa-9001-4fb2-bbfc-8f928a5e4931', 1,
 'Guest name: Margaret ________', 'Thornton', '["Thornton","thornton","THORNTON"]'),
('02c1f5a7-0ced-48f7-ba7f-724491c565c4', '1819acfa-9001-4fb2-bbfc-8f928a5e4931', 2,
 'Check-in date: ________ March', '14th', '["14th","14","14th of"]'),
('7396a667-1e19-4e06-ac0b-5826d96190c4', '1819acfa-9001-4fb2-bbfc-8f928a5e4931', 3,
 'Number of nights: ________', '3', '["3","three","Three"]'),
('1f547811-a08f-48de-9713-86c05b771821', '1819acfa-9001-4fb2-bbfc-8f928a5e4931', 4,
 'Room type: ________', 'standard', '["standard","Standard","standard room"]'),
('28bac9aa-4131-4a54-8911-c7b4f746890c', '1819acfa-9001-4fb2-bbfc-8f928a5e4931', 5,
 'Price per night: ________ pounds', '85', '["85","£85","85 pounds"]'),
('9937c8aa-5ddf-4480-a020-b068796ead65', '1819acfa-9001-4fb2-bbfc-8f928a5e4931', 6,
 'Phone number: ________', '07742 539 168', '["07742 539 168","07742539168"]'),
('17afa91d-cd70-460b-805f-e5f5cf980a9b', '1819acfa-9001-4fb2-bbfc-8f928a5e4931', 7,
 'Airport transfer from: ________', 'Heathrow', '["Heathrow","heathrow","HEATHROW"]'),
('86eb115b-bd2f-4c41-b586-967b24d01dd9', '1819acfa-9001-4fb2-bbfc-8f928a5e4931', 8,
 'Arrival time: ________', '2.30 pm', '["2.30 pm","2:30 pm","2.30","14:30"]'),
('50002e8f-701a-41bc-9751-a130966f604a', '1819acfa-9001-4fb2-bbfc-8f928a5e4931', 9,
 'Transfer cost (one way): ________ pounds', '45', '["45","£45","45 pounds"]'),
('a66bb0b3-0010-4920-93f8-cddb390166da', '1819acfa-9001-4fb2-bbfc-8f928a5e4931', 10,
 'Parking: ________', 'complimentary', '["complimentary","free","Complimentary","Free"]');

-- ── Section 2: Museum Tour ──────────────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('4a3cf26c-3824-48e2-b24f-e8f60263e2a8', 'ac2b9026-21d2-4e09-8f7e-cac388435b16', 2,
 'City Museum Guided Tour',
 'Guide: Welcome to the City Museum. The museum was originally built in 1856 as a private residence for the industrialist William Harding. It was converted into a public museum in 1923. The museum now houses over 15,000 artefacts across three floors.

On the ground floor you''ll find the Natural History gallery and the Ancient Civilisations gallery. The first floor has the Art and Culture wing with a current exhibition of contemporary photography from South-East Asia. The second floor is dedicated to Science and Technology with an interactive Engineering Lab. The planetarium runs shows every hour — tickets are 5 pounds for adults. Photography is permitted but please do not use flash in the Art and Culture wing.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('17895bb7-1e5d-4cb0-90a5-5f4d9320cc7d', '4a3cf26c-3824-48e2-b24f-e8f60263e2a8', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('1ba46472-f43f-471f-90ba-955587ff2e57', '17895bb7-1e5d-4cb0-90a5-5f4d9320cc7d', 11,
 'The museum building was originally used as',
 '["A. a government office", "B. a private home", "C. a school"]', 'B'),
('bc1b8f64-7c28-4a39-9d30-4e3eaae4969c', '17895bb7-1e5d-4cb0-90a5-5f4d9320cc7d', 12,
 'How many artefacts does the museum currently contain?',
 '["A. over 5,000", "B. over 10,000", "C. over 15,000"]', 'C'),
('19a96acd-380b-4f8d-9f4c-ccf9e9b2fe7d', '17895bb7-1e5d-4cb0-90a5-5f4d9320cc7d', 13,
 'The current rotating exhibition features',
 '["A. paintings from Europe", "B. photography from South-East Asia", "C. sculptures from Africa"]', 'B'),
('25ea6827-beb1-487d-a065-2acf85d84182', '17895bb7-1e5d-4cb0-90a5-5f4d9320cc7d', 14,
 'The planetarium ticket for an adult costs',
 '["A. 3 pounds", "B. 4 pounds", "C. 5 pounds"]', 'C'),
('c0b40eb9-2a90-48e0-a4d3-4a11f582dae1', '17895bb7-1e5d-4cb0-90a5-5f4d9320cc7d', 15,
 'Flash photography is not allowed in',
 '["A. the Natural History gallery", "B. the Art and Culture wing", "C. the Science and Technology floor"]', 'B');

-- ── Section 3: Student-Tutor Discussion ─────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('ee6d108d-4c0d-4c49-84cd-fc7b68eb0e2a', 'ac2b9026-21d2-4e09-8f7e-cac388435b16', 3,
 'Research Project Discussion',
 'Tutor: So, James, how is your research project on renewable energy coming along?
James: I''ve finished the literature review and started collecting data, but the survey response rate has been low — only 43 responses from 200 households.
Tutor: Have you considered supplementing with qualitative data?
James: My partner Mei suggested interviewing 15 to 20 households in depth.
Tutor: Good idea. Focus on households with solar panels. Also attend Dr Patel''s statistics workshop on Thursdays for help with regression modelling.
James: When is the submission deadline?
Tutor: The 28th of November. Have a first draft ready by the 14th. Include survey data and interview transcripts in the appendix, and address ethical considerations — your ethics approval was approved last week.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('36886de8-f1d7-4ab6-96ac-55bd67b8044b', 'ee6d108d-4c0d-4c49-84cd-fc7b68eb0e2a', 1,
 'sentence-completion', 'Complete the notes below. Write NO MORE THAN THREE WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d6094042-4217-43f1-b56d-e448b1d31016', '36886de8-f1d7-4ab6-96ac-55bd67b8044b', 16,
 'Research topic: ________ energy', 'renewable', '["renewable","Renewable"]'),
('3b2d1370-17aa-4c07-9df0-98319ba22f51', '36886de8-f1d7-4ab6-96ac-55bd67b8044b', 17,
 'Number of survey responses received so far: ________', '43', '["43","forty-three"]'),
('c27ef1a0-c3d3-4674-a74c-47353f4d6d6a', '36886de8-f1d7-4ab6-96ac-55bd67b8044b', 18,
 'Mei suggests interviewing ________ households in depth.', '15 to 20', '["15 to 20","15-20","fifteen to twenty"]'),
('b6f3ab4f-8b2b-4cd3-bc97-40d3a54b665f', '36886de8-f1d7-4ab6-96ac-55bd67b8044b', 19,
 'Focus interviews on households that have installed ________.', 'solar panels', '["solar panels","Solar panels"]'),
('d5b2fcb2-6c3e-4d40-b4b1-bb69b62f559b', '36886de8-f1d7-4ab6-96ac-55bd67b8044b', 20,
 'James is not confident with ________ modelling.', 'regression', '["regression","Regression"]'),
('a80a7195-a83d-4c31-9a74-d4b6ec340fc2', '36886de8-f1d7-4ab6-96ac-55bd67b8044b', 21,
 'Statistics workshop leader: Dr ________', 'Patel', '["Patel","patel","PATEL"]'),
('3672d5c3-fc8f-4ed3-b6c8-5dc6392121e7', '36886de8-f1d7-4ab6-96ac-55bd67b8044b', 22,
 'Report submission deadline: ________ November', '28th', '["28th","28","28th of"]'),
('7cd08ab1-2d7c-47b2-bd77-2f1618a815df', '36886de8-f1d7-4ab6-96ac-55bd67b8044b', 23,
 'First draft should be ready by the ________ of November.', '14th', '["14th","14"]'),
('f1931de7-b9cc-433b-8bd2-48f8c6eb5e57', '36886de8-f1d7-4ab6-96ac-55bd67b8044b', 24,
 'James has already received approval for the ________ form.', 'ethics', '["ethics","ethics approval","Ethics"]'),
('a629813c-ccbb-49e0-a7d5-d72111d51a65', '36886de8-f1d7-4ab6-96ac-55bd67b8044b', 25,
 'Appendix should include survey data and interview ________.', 'transcripts', '["transcripts","Transcripts"]');

-- ── Section 4: Coral Reef Lecture ───────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('2a94ffd4-0c79-4015-81f6-ad0f80a90daa', 'ac2b9026-21d2-4e09-8f7e-cac388435b16', 4,
 'Lecture: Coral Reef Ecosystems',
 'Professor: Today we look at coral reefs — the rainforests of the sea. They cover less than one percent of the ocean floor yet host about 25 percent of all marine species. Corals are colonial animals (phylum Cnidaria) whose polyps secrete calcium carbonate skeletons. They live in symbiosis with zooxanthellae algae that provide up to 90 percent of their energy. Elevated water temperatures cause coral bleaching. The Great Barrier Reef''s 2016-2017 bleaching affected two-thirds of the reef. Since 2009, roughly 14 percent of global reefs have been lost. Conservation includes marine protected areas, heat-resistant breeding, genetic modification, and transplanting laboratory-grown fragments.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('4abbe729-4a46-4e0a-9802-74538f909a02', '2a94ffd4-0c79-4015-81f6-ad0f80a90daa', 1,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('f4228965-c949-43a0-be16-8db79927cfc1', '4abbe729-4a46-4e0a-9802-74538f909a02', 26,
 'What percentage of the ocean floor do coral reefs cover?',
 '["A. less than 1%", "B. about 5%", "C. approximately 10%", "D. around 25%"]', 'A'),
('c82ab1f5-e461-460b-857f-5a6399bd6fc2', '4abbe729-4a46-4e0a-9802-74538f909a02', 27,
 'Zooxanthellae provide corals with',
 '["A. calcium carbonate", "B. protection from predators", "C. energy through photosynthesis", "D. reproductive cells"]', 'C'),
('de6a11e0-eaf9-4780-87ef-3bc2d61d152c', '4abbe729-4a46-4e0a-9802-74538f909a02', 28,
 'Coral bleaching is caused by',
 '["A. predation by fish", "B. lack of sunlight", "C. elevated water temperatures", "D. chemical pollution"]', 'C'),
('3a7f6f1c-7705-4f36-9b57-dfef716c680f', '4abbe729-4a46-4e0a-9802-74538f909a02', 29,
 'The 2016-2017 bleaching affected approximately what proportion of the Great Barrier Reef?',
 '["A. one quarter", "B. one third", "C. one half", "D. two thirds"]', 'D'),
('794e5a96-a36c-48c9-9bb5-0f6ef53713f0', '4abbe729-4a46-4e0a-9802-74538f909a02', 30,
 'Since 2009, the world has lost roughly what percentage of its coral reefs?',
 '["A. 5%", "B. 14%", "C. 25%", "D. 50%"]', 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('118482ad-701b-47e6-bd17-3bf0aae0b45c', '2a94ffd4-0c79-4015-81f6-ad0f80a90daa', 2,
 'sentence-completion', 'Complete the sentences below. Write NO MORE THAN TWO WORDS for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('c5e4b2d6-fb9a-4c28-98e9-d9229f5f0a44', '118482ad-701b-47e6-bd17-3bf0aae0b45c', 31,
 'Coral reefs are often called the ________ of the sea.', 'rainforests', '["rainforests","Rainforests"]'),
('eb663d27-99e7-4940-b88a-d7ab0e722881', '118482ad-701b-47e6-bd17-3bf0aae0b45c', 32,
 'Individual coral animals are called ________.', 'polyps', '["polyps","Polyps","polyp"]'),
('1f126f5d-6b57-41a4-9e32-a50d2bc4a8cd', '118482ad-701b-47e6-bd17-3bf0aae0b45c', 33,
 'Coral skeletons are made of ________.', 'calcium carbonate', '["calcium carbonate","Calcium carbonate"]'),
('80d22c95-364e-4f39-b9d9-bb4d2b2cd283', '118482ad-701b-47e6-bd17-3bf0aae0b45c', 34,
 'At current rates, most reef systems could reach functional extinction by ________.', '2050', '["2050"]'),
('4a25af0d-45db-4ef0-bd70-a8dcf84a5be6', '118482ad-701b-47e6-bd17-3bf0aae0b45c', 35,
 'Heat-resistant corals are being developed through selective breeding and ________.', 'genetic modification', '["genetic modification","Genetic modification"]'),
('71df4cc3-2aeb-49fc-9e90-c116c21e6490', '118482ad-701b-47e6-bd17-3bf0aae0b45c', 36,
 'Reef restoration involves transplanting ________ coral fragments.', 'laboratory-grown', '["laboratory-grown","lab-grown","laboratory grown"]'),
('d46d5106-cc55-46a2-a9b0-9e6db73afab8', '118482ad-701b-47e6-bd17-3bf0aae0b45c', 37,
 'Corals belong to the phylum ________.', 'Cnidaria', '["Cnidaria","cnidaria"]'),
('a17f8a7c-df8b-4a6c-9a40-e0c2f82161b3', '118482ad-701b-47e6-bd17-3bf0aae0b45c', 38,
 'A localised threat to reefs is pollution from ________ runoff.', 'agricultural', '["agricultural","Agricultural"]'),
('c408f6d2-9988-4f81-ba55-901ff21ef583', '118482ad-701b-47e6-bd17-3bf0aae0b45c', 39,
 'Marine ________ areas are one conservation strategy.', 'protected', '["protected","Protected"]'),
('58c35a82-f470-49b8-a1e4-f3c5b8b51d5c', '118482ad-701b-47e6-bd17-3bf0aae0b45c', 40,
 'Reefs support about ________ percent of all marine species.', '25', '["25","twenty-five"]');


-- ████████████████████████████████████████████████████████████
-- ██  3. WRITING TEST                                       ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('b7f284e3-82a1-4de2-ba78-4f15d9a90cd6', 'fe38ed89-f1fe-4b88-9609-8736be47f61e',
 'IELTS Academic Writing: Housing Trends & Crime Prevention (Band 7)', 'published');

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('f1a3d02a-9e73-45a8-bc6f-706f9d45e4ab', 'b7f284e3-82a1-4de2-ba78-4f15d9a90cd6', 1,
 'task1', 'Writing Task 1', '7', '20 mins',
 'The chart below shows the percentage of households in owned and rented accommodation in England and Wales between 1918 and 2011.

Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
 150, '', ''),
('c83b10b9-d2b5-4b51-b0db-5fc5ba8623ad', 'b7f284e3-82a1-4de2-ba78-4f15d9a90cd6', 2,
 'task2', 'Writing Task 2', '7', '40 mins',
 'Some people think that the best way to reduce crime is to give longer prison sentences. Others, however, believe there are better alternative ways of reducing crime.

Discuss both views and give your own opinion.',
 250, '', '');


-- ════════════════════════════════════════════════════════════
-- Done! Remember to update `created_by` to your auth user id.
-- ════════════════════════════════════════════════════════════
