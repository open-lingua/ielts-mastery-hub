-- ============================================================
-- IELTS Practice Platform – Comprehensive Seed Data
-- Run: supabase db reset   (applies migrations then this seed)
-- ============================================================
-- NOTE: `created_by` uses a placeholder UUID. After seeding,
-- update it to a real user's auth.uid() so RLS allows access:
--   UPDATE reading_tests  SET created_by = '<your-uid>';
--   UPDATE listening_tests SET created_by = '<your-uid>';
--   UPDATE writing_tests  SET created_by = '<your-uid>';
-- ============================================================

-- Clean slate (cascade deletes children)
TRUNCATE TABLE writing_tasks, writing_tests CASCADE;
TRUNCATE TABLE listening_questions, listening_question_groups, listening_sections, listening_tests CASCADE;
TRUNCATE TABLE reading_questions, reading_question_groups, reading_passages, reading_tests CASCADE;

-- Placeholder author
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM auth.users WHERE id = '80f68d7a-1b4e-4f92-9c3a-23456789abcd') THEN
  NULL;
END IF; END $$;


-- ████████████████████████████████████████████████████████████████
-- ██  1. READING TEST – ALL 13 QUESTION TYPES (40 questions)   ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('f47ac10b-58cc-4372-a567-0e02b2c3d471', '80f68d7a-1b4e-4f92-9c3a-23456789abcd',
 'IELTS Academic Reading Practice Test 1', 'Academic', '7', '60 mins', 'published');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: The Evolution of the Bicycle (Q1–13)        ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('7b2c9e10-3d4f-4a5b-8c6d-1e2f3a4b5c6d', 'f47ac10b-58cc-4372-a567-0e02b2c3d471', 1,
 'The Evolution of the Bicycle',
 '(A) The bicycle is one of the most successful human-powered means of transport ever devised. Its origins can be traced to the early nineteenth century, when a German inventor named Karl von Drais created the "Laufmaschine" (running machine) in 1817. This device, also known as a draisine, consisted of two wheels connected by a wooden frame, with a handlebar for steering. The rider sat astride the frame and propelled the machine by pushing against the ground with alternating feet — there were no pedals. Despite its simplicity, the draisine proved popular among European aristocrats as a novel form of recreation.

(B) The next major development came in the 1860s, when French metalworkers Pierre Michaux and Pierre Lallement attached cranks and pedals directly to the front wheel of a draisine-style frame. The resulting machine, known as the velocipede or "boneshaker," represented a fundamental advance because it allowed riders to propel themselves without touching the ground. However, the direct-drive mechanism meant that one revolution of the pedals produced only one revolution of the wheel, limiting the machine''s speed. To compensate, manufacturers began making the front wheel larger, culminating in the penny-farthing of the 1870s, which featured a front wheel up to 1.5 metres in diameter.

(C) The penny-farthing, while faster than its predecessors, was inherently dangerous. Riders sat high above the ground, and any sudden obstruction could pitch them forward over the handlebars in a fall known as "taking a header." The machine was also difficult to mount and dismount, and required considerable physical strength to operate. These limitations meant that cycling remained an activity primarily for young, athletic men.

(D) The invention that truly democratised cycling was the safety bicycle, developed in the 1880s by John Kemp Starley in Coventry, England. Starley''s design featured two wheels of equal size, a chain-driven rear wheel, and a diamond-shaped frame that placed the rider closer to the ground. The Rover Safety Bicycle, introduced in 1885, is widely regarded as the prototype for the modern bicycle. Within a decade, the addition of pneumatic tyres — invented by John Boyd Dunlop in 1888 — and the development of reliable braking systems made the bicycle both comfortable and safe enough for widespread adoption.

(E) The social impact of the safety bicycle was profound. For the first time, ordinary people of modest means could travel independently at speeds of 15 to 20 kilometres per hour, dramatically expanding their range of movement. The bicycle proved particularly liberating for women, who had previously been largely confined to walking or horse-drawn transport. The American suffragist Susan B. Anthony declared in 1896 that the bicycle had "done more to emancipate women than anything else in the world." Cycling clubs and touring societies flourished, and the bicycle became a symbol of personal freedom and modernity.

(F) Today, an estimated one billion bicycles are in use worldwide — more than twice the number of motor vehicles. In countries such as the Netherlands and Denmark, bicycles account for over 25 percent of all urban trips. Modern innovations include electric-assist bicycles, carbon-fibre frames, and bike-sharing systems that have been adopted by hundreds of cities around the globe. The fundamental design, however, remains remarkably similar to Starley''s safety bicycle of 1885, a testament to the elegance and efficiency of his original concept.');


-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–3) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('e2d3c4b5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', '7b2c9e10-3d4f-4a5b-8c6d-1e2f3a4b5c6d', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the passage? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d5e6f7a8-b9c0-4d1e-2f3a-4b5c6d7e8f9a', 'e2d3c4b5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 1,
 'Karl von Drais''s original machine included pedals for propulsion.', 'FALSE', '["FALSE","False","false"]'::jsonb),
('f1a2b3c4-d5e6-4a7b-8c9d-0e1f2a3b4c5d', 'e2d3c4b5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 2,
 'The penny-farthing was safer to ride than earlier bicycle designs.', 'FALSE', '["FALSE","False","false"]'::jsonb),
('b9c0d1e2-f3a4-4b5c-6d7e-8f9a0b1c2d3e', 'e2d3c4b5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 3,
 'John Boyd Dunlop was a colleague of John Kemp Starley.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'::jsonb);


-- ── Group 2: SHORT ANSWER (Q4–6) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('a0b1c2d3-e4f5-4a6b-7c8d-9e0f1a2b3c4d', '7b2c9e10-3d4f-4a5b-8c6d-1e2f3a4b5c6d', 2,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS from the passage for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('c5d6e7f8-a9b0-4c1d-2e3f-4a5b6c7d8e9f', 'a0b1c2d3-e4f5-4a6b-7c8d-9e0f1a2b3c4d', 4,
 'What was the other name for the draisine?', 'running machine', '[{"id":"1","text":"running machine"},{"id":"2","text":"Laufmaschine"}]'::jsonb),
('e9f0a1b2-c3d4-4e5f-6a7b-8c9d0e1f2a3b', 'a0b1c2d3-e4f5-4a6b-7c8d-9e0f1a2b3c4d', 5,
 'In which English city was the safety bicycle developed?', 'Coventry', '[{"id":"1","text":"Coventry"},{"id":"2","text":"coventry"}]'::jsonb),
('d4e5f6a7-b8c9-4d0e-1f2a-3b4c5d6e7f8a', 'a0b1c2d3-e4f5-4a6b-7c8d-9e0f1a2b3c4d', 6,
 'How many bicycles are estimated to be in use worldwide today?', 'one billion', '[{"id":"1","text":"one billion"},{"id":"2","text":"1 billion"}]'::jsonb);


-- ── Group 3: SENTENCE COMPLETION (Q7–8) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('b1c2d3e4-f5a6-4b7c-8d9e-0f1a2b3c4d5e', '7b2c9e10-3d4f-4a5b-8c6d-1e2f3a4b5c6d', 3,
 'sentence-completion', 'Complete the sentences below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 'b1c2d3e4-f5a6-4b7c-8d9e-0f1a2b3c4d5e', 7,
 'The velocipede was nicknamed the {{gap}} because of its uncomfortable ride.', 'boneshaker', '[{"id":"1","text":"boneshaker"}]'::jsonb),
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'b1c2d3e4-f5a6-4b7c-8d9e-0f1a2b3c4d5e', 8,
 'Susan B. Anthony said the bicycle helped to {{gap}} women.', 'emancipate', '[{"id":"1","text":"emancipate"}]'::jsonb);


-- ── Group 4: TABLE COMPLETION (Q9–11) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('d2e3f4a5-b6c7-4d8e-9f0a-1b2c3d4e5f6a', '7b2c9e10-3d4f-4a5b-8c6d-1e2f3a4b5c6d', 4,
 'table-completion', 'Complete the table below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('f7a8b9c0-d1e2-4f3a-4b5c-6d7e8f9a0b1c', 'd2e3f4a5-b6c7-4d8e-9f0a-1b2c3d4e5f6a', 9,
 'Row 1', '',
 '[{"id":"h1","gapText":"Era","answer":""},{"id":"h2","gapText":"Innovation","answer":""},{"id":"h3","gapText":"Key Feature","answer":""}]'::jsonb),
('b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 'd2e3f4a5-b6c7-4d8e-9f0a-1b2c3d4e5f6a', 10,
 'Row 2', '',
 '[{"id":"c1","gapText":"1817","answer":""},{"id":"c2","gapText":"Draisine","answer":""},{"id":"c3","gapText":"","answer":"wooden frame"}]'::jsonb),
('d5e6f7a8-b9c0-4d1e-2f3a-4b5c6d7e8f9a', 'd2e3f4a5-b6c7-4d8e-9f0a-1b2c3d4e5f6a', 11,
 'Row 3', '',
 '[{"id":"c4","gapText":"1860s","answer":""},{"id":"c5","gapText":"","answer":"velocipede"},{"id":"c6","gapText":"cranks and pedals","answer":""}]'::jsonb);


-- ── Group 5: NOTE COMPLETION (Q12–13) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', '7b2c9e10-3d4f-4a5b-8c6d-1e2f3a4b5c6d', 5,
 'note-completion', 'Complete the notes below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('e2f3a4b5-c6d7-4e8f-9a0b-1c2d3e4f5a6b', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 12,
 'The penny-farthing''s front wheel could be up to {{gap}} in diameter.', '1.5 metres', '[{"id":"1","text":"1.5 metres"},{"id":"2","text":"1.5 meters"}]'::jsonb),
('a7b8c9d0-e1f2-4a3b-4c5d-6e7f8a9b0c1d', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 13,
 'In the Netherlands and Denmark, bicycles account for over {{gap}} of urban trips.', '25 percent', '[{"id":"1","text":"25 percent"},{"id":"2","text":"25%"}]'::jsonb);


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: AI on Workspaces (Q14–27)                   ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('5d6e7f8a-9b0c-4d1e-2f3a-4b5c6d7e8f9a', 'f47ac10b-58cc-4372-a567-0e02b2c3d471', 2,
 'The Impact of Artificial Intelligence on Workspaces',
 '(A) Artificial intelligence is transforming the modern workplace at an unprecedented pace. From automated customer-service chatbots to sophisticated data-analysis platforms, AI technologies are being integrated into virtually every industry. A 2024 survey by McKinsey Global Institute found that 72 percent of companies had adopted at least one AI capability, up from 55 percent just two years earlier. This rapid adoption has sparked both enthusiasm about productivity gains and anxiety about potential job displacement.

(B) The most immediate impact of AI has been on routine, repetitive tasks. In manufacturing, robotic process automation (RPA) has been deployed to handle assembly-line operations, quality-control inspections, and inventory management with greater speed and consistency than human workers. In the service sector, natural language processing algorithms now handle a significant proportion of customer enquiries, from answering frequently asked questions to processing insurance claims. A study by the World Economic Forum estimated that by 2025, machines would perform more task hours than humans in the workplace for the first time.

(C) However, the relationship between AI and employment is more nuanced than simple replacement. While AI excels at tasks that are structured, data-intensive, and rule-based, it struggles with activities requiring creativity, empathy, complex judgment, and interpersonal communication. Many experts argue that AI is more likely to augment human capabilities than to replace entire jobs. Dr. Elena Vasquez of MIT has described this as "the collaboration model," in which humans and machines each contribute their comparative advantages. For example, a radiologist might use an AI system to flag potential anomalies in medical images, but the final diagnosis and patient communication remain firmly in the hands of the human doctor.

(D) The rise of AI has also created entirely new categories of employment. Roles such as AI trainer, data curator, machine learning engineer, and algorithmic ethics officer did not exist a decade ago but are now among the fastest-growing occupations. Professor Kenji Tanaka of Tokyo University has noted that historically, every major technological revolution — from the steam engine to the internet — has ultimately created more jobs than it destroyed, though the transition period can be disruptive and painful for affected workers.

(E) Organisations are increasingly recognising the importance of reskilling and upskilling their workforce to prepare for an AI-augmented future. Major technology companies including Google, Amazon, and Microsoft have launched free or subsidised training programmes in AI literacy, data science, and digital skills. Governments in countries such as Singapore, Finland, and Canada have implemented national AI strategies that include significant investments in education and retraining. The consensus among policymakers is that proactive investment in human capital is essential to ensure that the benefits of AI are broadly shared.

(F) Ethical considerations surrounding AI in the workplace are receiving growing attention. Concerns include algorithmic bias in hiring and promotion decisions, surveillance of employee behaviour through AI-powered monitoring tools, and the erosion of worker autonomy as AI systems increasingly dictate task allocation and scheduling. The European Union''s AI Act, which came into force in 2024, represents the first comprehensive regulatory framework for artificial intelligence, establishing risk categories and mandatory requirements for high-risk AI applications in employment.');


-- ── Group 6: MATCHING HEADINGS (Q14–17) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', '5d6e7f8a-9b0c-4d1e-2f3a-4b5c6d7e8f9a', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for paragraphs B, C, D and E from the list of headings below.', true,
 true, '["i. The automation of routine work","ii. Regulation and ethical concerns","iii. A balanced view of AI and jobs","iv. Investing in workforce adaptation","v. New roles born from technology","vi. The global spread of AI adoption"]'::jsonb);

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('d1e2f3a4-b5c6-4d7e-8f9a-0b1c2d3e4f5a', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 14, 'B', 'i'),
('f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 15, 'C', 'iii'),
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 16, 'D', 'v'),
('c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 17, 'E', 'iv');


-- ── Group 7: MATCHING INFORMATION (Q18–21) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', '5d6e7f8a-9b0c-4d1e-2f3a-4b5c6d7e8f9a', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 'e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 18,
 'A prediction about machines performing more work than humans', 'B',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'::jsonb),
('c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 'e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 19,
 'An example of how AI and humans can work together in healthcare', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'::jsonb),
('e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 'e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 20,
 'Reference to a specific piece of AI legislation', 'F',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'::jsonb),
('a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 'e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 21,
 'A historical comparison between AI and previous technological changes', 'D',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'::jsonb);


-- ── Group 8: MULTIPLE CHOICE (Q22–24) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', '5d6e7f8a-9b0c-4d1e-2f3a-4b5c6d7e8f9a', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 22,
 'According to the passage, AI is LEAST effective at tasks that require',
 'B',
 '[{"id":"A","text":"A. processing large datasets","isCorrect":false},{"id":"B","text":"B. creativity and empathy","isCorrect":true},{"id":"C","text":"C. following established rules","isCorrect":false},{"id":"D","text":"D. repetitive quality checks","isCorrect":false}]'::jsonb),
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 23,
 'Dr. Elena Vasquez describes the ideal AI-workplace relationship as',
 'C',
 '[{"id":"A","text":"A. full automation of all tasks","isCorrect":false},{"id":"B","text":"B. a temporary transition phase","isCorrect":false},{"id":"C","text":"C. a collaboration model","isCorrect":true},{"id":"D","text":"D. a replacement strategy","isCorrect":false}]'::jsonb),
('c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 24,
 'The McKinsey survey found that AI adoption among companies',
 'A',
 '[{"id":"A","text":"A. increased significantly over a two-year period","isCorrect":true},{"id":"B","text":"B. remained stable since 2020","isCorrect":false},{"id":"C","text":"C. was concentrated in manufacturing only","isCorrect":false},{"id":"D","text":"D. declined due to regulatory concerns","isCorrect":false}]'::jsonb);


-- ── Group 9: FLOWCHART COMPLETION (Q25–27) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', '5d6e7f8a-9b0c-4d1e-2f3a-4b5c6d7e8f9a', 4,
 'flowchart-completion', 'Complete the flowchart below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 'e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 25,
 'AI systems handle {{gap}} tasks in manufacturing and services', 'routine'),
('c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 'e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 26,
 'This leads to concerns about {{gap}} for affected workers', 'job displacement'),
('e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 'e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 27,
 'Companies respond by investing in {{gap}} programmes', 'reskilling');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: Consumer Behavior Psychology (Q28–40)       ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 'f47ac10b-58cc-4372-a567-0e02b2c3d471', 3,
 'The Psychology of Consumer Behaviour',
 '(A) Why do people buy what they buy? This seemingly simple question has occupied researchers in psychology, economics, and marketing for over a century. Consumer behaviour — the study of how individuals make decisions about what to purchase, use, and discard — sits at the intersection of multiple academic disciplines and has profound implications for businesses, policymakers, and society at large.

(B) One of the foundational theories in consumer psychology is Maslow''s hierarchy of needs, which suggests that people prioritise purchases that fulfil basic physiological and safety needs before spending on higher-order desires such as social belonging, esteem, and self-actualisation. However, modern research has shown that consumers frequently deviate from this rational hierarchy. Professor Sarah Chen of Harvard Business School has demonstrated that emotional factors often override practical considerations, with consumers regularly paying premium prices for brands that align with their personal identity or social aspirations.

(C) The concept of "bounded rationality," introduced by Nobel laureate Herbert Simon, provides another lens for understanding consumer decisions. Simon argued that people do not optimise their choices by evaluating all available options; instead, they "satisfice" — settling for the first option that meets a minimum threshold of acceptability. This insight has been further developed by Dr. Robert Hartley of the London School of Economics, who has shown that the abundance of choice in modern markets can actually paralyse consumers, a phenomenon he terms "choice overload." In experiments, Hartley found that consumers presented with 24 options were ten times less likely to make a purchase than those offered only 6 options.

(D) Social influence plays a powerful role in shaping consumer behaviour. Dr. Maria Gonzalez of Stanford University has researched how peer recommendations and online reviews have become the dominant factors in purchase decisions, surpassing traditional advertising in their persuasive impact. Her work shows that consumers trust recommendations from other consumers approximately three times more than they trust brand-generated content. The rise of social media influencer marketing is a direct consequence of this dynamic.

(E) The field of behavioural economics has revealed numerous cognitive biases that systematically affect consumer choices. The "anchoring effect" causes consumers to rely heavily on the first price they encounter, making an initial high price seem reasonable when followed by a discounted offer. The "endowment effect" leads people to value items more highly once they own them, which is why free trials and money-back guarantees are such effective marketing strategies. Dr. Hartley has extended this research to show that the "decoy effect" — introducing a clearly inferior third option — can increase sales of a target product by up to 40 percent.

(F) Neuromarketing, which uses brain-imaging technology to study consumer responses, represents the cutting edge of the field. Research using functional magnetic resonance imaging (fMRI) has shown that brand logos can activate the same neural pathways associated with personal relationships and self-identity. Professor Chen has argued that this finding explains why brand loyalty often persists even when competing products offer objectively better value. Critics, including Dr. Gonzalez, have cautioned that neuromarketing raises significant ethical questions about the potential for manipulation of consumer decision-making.');


-- ── Group 10: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 'a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 28,
 'Consumers always follow Maslow''s hierarchy when making purchases.', 'NO', '["NO","No","no"]'::jsonb),
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 29,
 'Having more options available makes it easier for consumers to decide.', 'NO', '["NO","No","no"]'::jsonb),
('c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 30,
 'Social media influencer marketing has declined in effectiveness recently.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'::jsonb),
('e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 31,
 'Neuromarketing research has been banned in some countries.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'::jsonb);


-- ── Group 11: MATCHING FEATURES (Q32–34) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 'a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 2,
 'matching-features', 'Look at the following statements and the list of researchers below. Match each statement with the correct researcher, A, B or C.', true,
 true, '["A. Professor Sarah Chen","B. Dr. Robert Hartley","C. Dr. Maria Gonzalez"]'::jsonb);

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 32,
 'Showed that an inferior third option can boost sales of a target product.', 'B. Dr. Robert Hartley'),
('e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 33,
 'Found that consumers trust other consumers far more than brand messaging.', 'C. Dr. Maria Gonzalez'),
('a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 34,
 'Argues that brand logos activate neural pathways related to personal identity.', 'A. Professor Sarah Chen');


-- ── Group 12: MATCHING SENTENCE ENDINGS (Q35–37) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 'a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 3,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–E, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 35,
 'Herbert Simon argued that consumers do not evaluate all options but instead',
 'C',
 '[{"id":"A","text":"activate neural pathways associated with personal identity.","isCorrect":false},{"id":"B","text":"trust peer recommendations more than brand advertising.","isCorrect":false},{"id":"C","text":"settle for the first acceptable choice they find.","isCorrect":true},{"id":"D","text":"pay premium prices for emotionally appealing brands.","isCorrect":false},{"id":"E","text":"become paralysed when faced with too many options.","isCorrect":false}]'::jsonb),
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 36,
 'According to the passage, the endowment effect explains why consumers',
 'D',
 '[{"id":"A","text":"activate neural pathways associated with personal identity.","isCorrect":false},{"id":"B","text":"trust peer recommendations more than brand advertising.","isCorrect":false},{"id":"C","text":"settle for the first acceptable choice they find.","isCorrect":false},{"id":"D","text":"value items more once they possess them.","isCorrect":true},{"id":"E","text":"become paralysed when faced with too many options.","isCorrect":false}]'::jsonb),
('c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 37,
 'Research using brain imaging has shown that brand logos can',
 'A',
 '[{"id":"A","text":"activate neural pathways associated with personal identity.","isCorrect":true},{"id":"B","text":"trust peer recommendations more than brand advertising.","isCorrect":false},{"id":"C","text":"settle for the first acceptable choice they find.","isCorrect":false},{"id":"D","text":"value items more once they possess them.","isCorrect":false},{"id":"E","text":"become paralysed when faced with too many options.","isCorrect":false}]'::jsonb);


-- ── Group 13: SUMMARY COMPLETION with Word Bank (Q38–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 'a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 4,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["satisfice","anchoring","decoy","endowment","overload","bounded","manipulation"]'::jsonb);

-- For SUMMARY_COMPLETION: first question text = summary template, all questions provide answers
INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 'e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 38,
 'Herbert Simon''s concept of {{gap_e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b_0}} rationality explains that consumers do not fully optimise decisions. Instead, they {{gap_e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b_1}} by choosing the first acceptable option. Retailers exploit the {{gap_e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b_2}} effect by introducing an inferior option to steer buyers toward a target product.',
 'bounded'),
('c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 'e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 39,
 '', 'satisfice'),
('e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 'e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 40,
 '', 'decoy');


-- ████████████████████████████████████████████████████████████
-- ██  2. LISTENING TEST                                     ██
-- ████████████████████████████████████████████████████████████

INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status) VALUES
('f9a8b7c6-d5e4-4a3b-2c1d-0e1f2a3b4c5d', '80f68d7a-1b4e-4f92-9c3a-23456789abcd',
 'IELTS Listening Practice Test 1', '7', '40 mins', 'published');

-- ── Section 1: Hotel Booking ────────────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 'f9a8b7c6-d5e4-4a3b-2c1d-0e1f2a3b4c5d', 1,
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
('c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 1,
 'sentence-completion', 'Complete the booking form below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 1,
 'Guest name: Margaret ________', 'Thornton', '["Thornton","thornton","THORNTON"]'::jsonb),
('a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 2,
 'Check-in date: ________ March', '14th', '["14th","14","14th of"]'::jsonb),
('c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 3,
 'Number of nights: ________', '3', '["3","three","Three"]'::jsonb),
('f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 4,
 'Room type: ________', 'standard', '["standard","Standard","standard room"]'::jsonb),
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 5,
 'Price per night: ________ pounds', '85', '["85","£85","85 pounds"]'::jsonb),
('c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 6,
 'Phone number: ________', '07742 539 168', '["07742 539 168","07742539168"]'::jsonb),
('e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 7,
 'Airport transfer from: ________', 'Heathrow', '["Heathrow","heathrow","HEATHROW"]'::jsonb),
('a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 8,
 'Arrival time: ________', '2.30 pm', '["2.30 pm","2:30 pm","2.30","14:30"]'::jsonb),
('c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 9,
 'Transfer cost (one way): ________ pounds', '45', '["45","£45","45 pounds"]'::jsonb),
('e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 10,
 'Parking: ________', 'complimentary', '["complimentary","free","Complimentary","Free"]'::jsonb);

-- ── Section 2: Museum Tour ──────────────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('5d6e7f8a-9b0c-4d1e-2f3a-4b5c6d7e8f9a', 'f9a8b7c6-d5e4-4a3b-2c1d-0e1f2a3b4c5d', 2,
 'City Museum Guided Tour',
 'Guide: Welcome to the City Museum. The museum was originally built in 1856 as a private residence for the industrialist William Harding. It was converted into a public museum in 1923. The museum now houses over 15,000 artefacts across three floors.

On the ground floor you''ll find the Natural History gallery and the Ancient Civilisations gallery. The first floor has the Art and Culture wing with a current exhibition of contemporary photography from South-East Asia. The second floor is dedicated to Science and Technology with an interactive Engineering Lab. The planetarium runs shows every hour — tickets are 5 pounds for adults. Photography is permitted but please do not use flash in the Art and Culture wing.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', '5d6e7f8a-9b0c-4d1e-2f3a-4b5c6d7e8f9a', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('d1e2f3a4-b5c6-4d7e-8f9a-0b1c2d3e4f5a', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 11,
 'The museum building was originally used as',
 '["A. a government office", "B. a private home", "C. a school"]'::jsonb, 'B'),
('f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 12,
 'How many artefacts does the museum currently contain?',
 '["A. over 5,000", "B. over 10,000", "C. over 15,000"]'::jsonb, 'C'),
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 13,
 'The current rotating exhibition features',
 '["A. paintings from Europe", "B. photography from South-East Asia", "C. sculptures from Africa"]'::jsonb, 'B'),
('c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 14,
 'The planetarium ticket for an adult costs',
 '["A. 3 pounds", "B. 4 pounds", "C. 5 pounds"]'::jsonb, 'C'),
('e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 15,
 'Flash photography is not allowed in',
 '["A. the Natural History gallery", "B. the Art and Culture wing", "C. the Science and Technology floor"]'::jsonb, 'B');

-- ── Section 3: Student-Tutor Discussion ─────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 'f9a8b7c6-d5e4-4a3b-2c1d-0e1f2a3b4c5d', 3,
 'Research Project Discussion',
 'Tutor: So, James, how is your research project on renewable energy coming along?
James: I''ve finished the literature review and started collecting data, but the survey response rate has been low — only 43 responses from 200 households.
Tutor: Have you considered supplementing with qualitative data?
James: My partner Mei suggested interviewing 15 to 20 households in depth.
Tutor: Good idea. Focus on households with solar panels. Also attend Dr Patel''s statistics workshop on Thursdays for help with regression modelling.
James: When is the submission deadline?
Tutor: The 28th of November. Have a first draft ready by the 14th. Include survey data and interview transcripts in the appendix, and address ethical considerations — your ethics approval was approved last week.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 1,
 'sentence-completion', 'Complete the notes below. Write NO MORE THAN THREE WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 16,
 'Research topic: ________ energy', 'renewable', '["renewable","Renewable"]'::jsonb),
('a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 17,
 'Number of survey responses received so far: ________', '43', '["43","forty-three"]'::jsonb),
('c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 18,
 'Mei suggests interviewing ________ households in depth.', '15 to 20', '["15 to 20","15-20","fifteen to twenty"]'::jsonb),
('f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 19,
 'Focus interviews on households that have installed ________.', 'solar panels', '["solar panels","Solar panels"]'::jsonb),
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 20,
 'James is not confident with ________ modelling.', 'regression', '["regression","Regression"]'::jsonb),
('c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 21,
 'Statistics workshop leader: Dr ________', 'Patel', '["Patel","patel","PATEL"]'::jsonb),
('e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 22,
 'Report submission deadline: ________ November', '28th', '["28th","28","28th of"]'::jsonb),
('a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 23,
 'First draft should be ready by the ________ of November.', '14th', '["14th","14"]'::jsonb),
('c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 24,
 'James has already received approval for the ________ form.', 'ethics', '["ethics","ethics approval","Ethics"]'::jsonb),
('e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 'c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 25,
 'Appendix should include survey data and interview ________.', 'transcripts', '["transcripts","Transcripts"]'::jsonb);

-- ── Section 4: Coral Reef Lecture ───────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('5d6e7f8a-9b0c-4d1e-2f3a-4b5c6d7e8f9a', 'f9a8b7c6-d5e4-4a3b-2c1d-0e1f2a3b4c5d', 4,
 'Lecture: Coral Reef Ecosystems',
 'Professor: Today we look at coral reefs — the rainforests of the sea. They cover less than one percent of the ocean floor yet host about 25 percent of all marine species. Corals are colonial animals (phylum Cnidaria) whose polyps secrete calcium carbonate skeletons. They live in symbiosis with zooxanthellae algae that provide up to 90 percent of their energy. Elevated water temperatures cause coral bleaching. The Great Barrier Reef''s 2016-2017 bleaching affected two-thirds of the reef. Since 2009, roughly 14 percent of global reefs have been lost. Conservation includes marine protected areas, heat-resistant breeding, genetic modification, and transplanting laboratory-grown fragments.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', '5d6e7f8a-9b0c-4d1e-2f3a-4b5c6d7e8f9a', 1,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('d1e2f3a4-b5c6-4d7e-8f9a-0b1c2d3e4f5a', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 26,
 'What percentage of the ocean floor do coral reefs cover?',
 '["A. less than 1%", "B. about 5%", "C. approximately 10%", "D. around 25%"]'::jsonb, 'A'),
('f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 27,
 'Zooxanthellae provide corals with',
 '["A. calcium carbonate", "B. protection from predators", "C. energy through photosynthesis", "D. reproductive cells"]'::jsonb, 'C'),
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 28,
 'Coral bleaching is caused by',
 '["A. predation by fish", "B. lack of sunlight", "C. elevated water temperatures", "D. chemical pollution"]'::jsonb, 'C'),
('c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 29,
 'The 2016-2017 bleaching affected approximately what proportion of the Great Barrier Reef?',
 '["A. one quarter", "B. one third", "C. one half", "D. two thirds"]'::jsonb, 'D'),
('e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 30,
 'Since 2009, the world has lost roughly what percentage of its coral reefs?',
 '["A. 5%", "B. 14%", "C. 25%", "D. 50%"]'::jsonb, 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', '5d6e7f8a-9b0c-4d1e-2f3a-4b5c6d7e8f9a', 2,
 'sentence-completion', 'Complete the sentences below. Write NO MORE THAN TWO WORDS for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 31,
 'Coral reefs are often called the ________ of the sea.', 'rainforests', '["rainforests","Rainforests"]'::jsonb),
('e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 32,
 'Individual coral animals are called ________.', 'polyps', '["polyps","Polyps","polyp"]'::jsonb),
('a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 33,
 'Coral skeletons are made of ________.', 'calcium carbonate', '["calcium carbonate","Calcium carbonate"]'::jsonb),
('c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 34,
 'At current rates, most reef systems could reach functional extinction by ________.', '2050', '["2050"]'::jsonb),
('f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 35,
 'Heat-resistant corals are being developed through selective breeding and ________.', 'genetic modification', '["genetic modification","Genetic modification"]'::jsonb),
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 36,
 'Reef restoration involves transplanting ________ coral fragments.', 'laboratory-grown', '["laboratory-grown","lab-grown","laboratory grown"]'::jsonb),
('c2d3e4f5-a6b7-4c8d-9e0f-1a2b3c4d5e6f', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 37,
 'Corals belong to the phylum ________.', 'Cnidaria', '["Cnidaria","cnidaria"]'::jsonb),
('e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 38,
 'A localised threat to reefs is pollution from ________ runoff.', 'agricultural', '["agricultural","Agricultural"]'::jsonb),
('a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 39,
 'Marine ________ areas are one conservation strategy.', 'protected', '["protected","Protected"]'::jsonb),
('c7d8e9f0-a1b2-4c3d-4e5f-6a7b8c9d0e1f', 'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d', 40,
 'Reefs support about ________ percent of all marine species.', '25', '["25","twenty-five"]'::jsonb);


-- ████████████████████████████████████████████████████████████
-- ██  3. WRITING TEST                                       ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('b3c4d5e6-f7a8-4b9c-0d1e-2f3a4b5c6d7e', '80f68d7a-1b4e-4f92-9c3a-23456789abcd',
 'IELTS Academic Writing Practice Test 1', 'published');

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b', 'b3c4d5e6-f7a8-4b9c-0d1e-2f3a4b5c6d7e', 1,
 'task1', 'Writing Task 1', '7', '20 mins',
 'The chart below shows the percentage of households in owned and rented accommodation in England and Wales between 1918 and 2011.

Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
 150, '', ''),
('a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d', 'b3c4d5e6-f7a8-4b9c-0d1e-2f3a4b5c6d7e', 2,
 'task2', 'Writing Task 2', '7', '40 mins',
 'Some people think that the best way to reduce crime is to give longer prison sentences. Others, however, believe there are better alternative ways of reducing crime.

Discuss both views and give your own opinion.',
 250, '', '');


-- ════════════════════════════════════════════════════════════
-- Done! Remember to update `created_by` to your auth user id.
-- ════════════════════════════════════════════════════════════
