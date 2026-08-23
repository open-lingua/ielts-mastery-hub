-- ============================================================
-- IELTS Practice Platform – Extended Seed Data
-- Target: Reading Module (General Training, Band 6 Difficulty)
-- Action: APPEND (No TRUNCATE)
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST ENTRY (General Training - Band 6)                   ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('034f8a01-2885-46de-bf1e-25db819cf7b4', '8db8023b-49c6-4e11-9e31-1e15c14373b6',
 'IELTS General Training Reading: Everyday Life, Workplace & History (Band 6)', 'General Training', '6', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: City Community Centre (Q1–13)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('be0a9452-d7aa-4a4e-ae80-cd3debabc530', '034f8a01-2885-46de-bf1e-25db819cf7b4', 1,
 'City Community Centre: Classes and Facilities',
 '(A) Welcome to the City Community Centre! We offer a wide range of facilities and classes designed to keep you active, creative, and engaged. Whether you are looking to improve your fitness, learn a new hobby, or simply meet new people in your neighborhood, we have something for everyone. Annual membership is $50, which grants you free access to the swimming pool during open hours and a 10% discount on all paid classes. Non-members are also welcome to use the facilities by paying a daily guest pass fee of $5.

(B) Fitness Classes
We offer several fitness options for all skill levels. Our popular Yoga Flow class runs every Monday and Wednesday evening from 6:00 PM to 7:00 PM. The cost is $10 per session, and participants are required to bring their own mat. For those looking for a higher intensity workout, we host a Bootcamp session on Saturday mornings at 9:00 AM. This class is held outdoors on the sports field (weather permitting) and costs $12. No equipment is necessary, but a water bottle is highly recommended. 

(C) Arts and Crafts
If you prefer creative activities, join our Beginner’s Pottery workshop on Thursday evenings. The class runs for two hours and costs $25 per week. Please note that clay and tools are provided, but participants must pay a small extra fee to have their finished items fired in the kiln. Because this class is very popular, the maximum number of people in a pottery class is strictly limited to twelve. We also offer a free Community Painting session every Sunday afternoon. Basic paints and brushes are supplied, but you must bring your own canvas.

(D) Booking and General Rules
To ensure a spot in any of our classes, you must book online at least 48 hours in advance. Cancellations made less than 24 hours before the class begins will not be refunded. If you wish to use the badminton or tennis courts, you do not need to book a week in advance; you can reserve court space on the same day by calling the reception desk, subject to availability. Please remember that all children under the age of 12 must be accompanied by an adult when using the swimming pool or sports facilities.');

-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('f490c95e-4a4d-42a1-9dd8-e4961a9e3b6d', 'be0a9452-d7aa-4a4e-ae80-cd3debabc530', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the text? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('f1c03bfb-b53c-48e5-a1cd-df089c8b0a80', 'f490c95e-4a4d-42a1-9dd8-e4961a9e3b6d', 1,
 'People who pay the annual membership fee can swim for free.', 'TRUE', '["TRUE","True","true"]'),
('e54aa0b3-e78a-427d-867b-164d09bfa0be', 'f490c95e-4a4d-42a1-9dd8-e4961a9e3b6d', 2,
 'The Yoga Flow class is available to visitors every day of the week.', 'FALSE', '["FALSE","False","false"]'),
('b4f555a8-48ca-4a43-8ea3-bb556652218a', 'f490c95e-4a4d-42a1-9dd8-e4961a9e3b6d', 3,
 'The Bootcamp instructor is a fully qualified personal trainer.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('5c8a5694-fb4d-4cae-8fe5-95c458b6afb6', 'f490c95e-4a4d-42a1-9dd8-e4961a9e3b6d', 4,
 'You are required to book the tennis courts at least a week before you want to play.', 'FALSE', '["FALSE","False","false"]');

-- ── Group 2: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('7afa46b9-1b9d-4236-a534-aabca7935987', 'be0a9452-d7aa-4a4e-ae80-cd3debabc530', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN TWO WORDS AND/OR A NUMBER from the text for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('d83c93b1-2921-4927-b202-d7b5e03042e2', '7afa46b9-1b9d-4236-a534-aabca7935987', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"Class Name","answer":""},{"id":"h2","gapText":"Day(s)","answer":""},{"id":"h3","gapText":"Cost / Notes","answer":""}]'),
('78004b96-4419-4dde-aa5d-4f1acca24290', '7afa46b9-1b9d-4236-a534-aabca7935987', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"Yoga Flow","answer":""},{"id":"c2","gapText":"Monday and {{gap}}","answer":"Wednesday"},{"id":"c3","gapText":"$10 per session","answer":""}]'),
('21e17c2a-053e-4b25-b287-2a975ed348f4', '7afa46b9-1b9d-4236-a534-aabca7935987', 7,
 'Row 3', '',
 '[{"id":"c4","gapText":"{{gap}}","answer":"Bootcamp"},{"id":"c5","gapText":"Saturday","answer":""},{"id":"c6","gapText":"$12; Held on the {{gap}}","answer":"sports field"}]'),
('618bc56b-e53f-4468-9085-4bcb15adf747', '7afa46b9-1b9d-4236-a534-aabca7935987', 8,
 'Row 4', '',
 '[{"id":"c7","gapText":"Beginner’s Pottery","answer":""},{"id":"c8","gapText":"Thursday","answer":""},{"id":"c9","gapText":"$25; An {{gap}} is charged for using the kiln","answer":"extra fee"}]'),
('146da115-2df4-42fd-991a-7b4e932f7065', '7afa46b9-1b9d-4236-a534-aabca7935987', 9,
 'Row 5', '',
 '[{"id":"c10","gapText":"Community Painting","answer":""},{"id":"c11","gapText":"{{gap}}","answer":"Sunday"},{"id":"c12","gapText":"Free; Need to bring your own canvas","answer":""}]');

-- ── Group 3: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('eeb41735-5c9f-4c82-ae8a-4f1485664617', 'be0a9452-d7aa-4a4e-ae80-cd3debabc530', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS from the text for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('68ea4c10-d2b7-42db-8ac8-e044b53f6a85', 'eeb41735-5c9f-4c82-ae8a-4f1485664617', 10,
 'How much do non-members pay to enter the facility for a single day?', 'daily guest pass', '[{"id":"1","text":"$5"},{"id":"2","text":"5 dollars"},{"id":"3","text":"5"}]'),
('aaaab90d-74dd-4c02-af9b-df32da183f56', 'eeb41735-5c9f-4c82-ae8a-4f1485664617', 11,
 'What personal item must participants bring to the Yoga Flow class?', 'own mat', '[{"id":"1","text":"their own mat"},{"id":"2","text":"own mat"},{"id":"3","text":"mat"}]'),
('d31533e2-b4e0-45e0-9b8e-84bd7b04b5ec', 'eeb41735-5c9f-4c82-ae8a-4f1485664617', 12,
 'What is the highest number of students allowed in a pottery class?', 'twelve', '[{"id":"1","text":"twelve"},{"id":"2","text":"12"}]'),
('b70d4bf9-ae86-4918-90ea-7fbc7c3b2f43', 'eeb41735-5c9f-4c82-ae8a-4f1485664617', 13,
 'How early must you cancel a class booking if you want a refund?', '24 hours', '[{"id":"1","text":"24 hours"},{"id":"2","text":"twenty-four hours"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Employee Guidelines: Health and Safety (Q14–27)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('0f4ef5b5-330b-4dc4-a0b9-b176a9d2007b', '034f8a01-2885-46de-bf1e-25db819cf7b4', 2,
 'Employee Guidelines: Health and Safety in the Office',
 '(A) The management is committed to providing a safe and healthy working environment for all employees. It is the responsibility of everyone to be aware of the safety procedures and to report any hazards immediately. These guidelines have been created to outline the basic safety protocols you must follow while working in the office building. Please read them carefully and consult your line manager if you have any questions.

(B) Many office workers suffer from back pain or eye strain due to poor posture and prolonged screen time. To prevent this, your workstation should be adjusted to fit your body. Your chair should support your lower back, and your feet should rest flat on the floor. The top of your computer monitor should be at eye level to prevent neck strain. Furthermore, you should take a short five-minute break away from your screen every hour to rest your eyes and stretch your legs.

(C) In the event of a fire alarm sounding, you must stop what you are doing and exit the building immediately via the nearest emergency stairwell. Do not stop to collect your personal belongings, and never use the elevator during a fire evacuation. Once outside, assemble at the designated meeting point in the main parking lot. Do not re-enter the building until the fire warden has given official clearance that it is safe to do so.

(D) The office kitchen is a shared space, and maintaining hygiene is crucial to prevent illness. All staff must wash their own dishes after use and ensure that the sink area is kept clean. Do not leave perishable food on the counters. Any food stored in the communal refrigerator must be clearly labeled with your name and the date. To maintain hygiene standards, the cleaning staff will throw away any unlabelled or out-of-date food every Friday afternoon.

(E) If you encounter a safety hazard, such as a loose cable, a broken chair, or a spill on the floor, do not attempt to fix it yourself unless it is a minor issue you can easily resolve safely. All hazards should be reported immediately using the online Maintenance Request Portal on the company intranet. For urgent hazards that pose an immediate risk of injury, please call the facilities team directly on extension 404.

(F) Even in an office environment, minor accidents can happen. If you suffer an injury at work, no matter how small, you must notify the designated First Aid Officer for your department. Their names and contact details are listed on the notice board in the breakroom. There are fully stocked first aid kits located next to the main elevators on every floor. By law, all workplace injuries must be officially documented in the company accident logbook within 24 hours of the incident occurring.');

-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('5bae28a0-4f89-44ee-a877-a247724edf13', '0f4ef5b5-330b-4dc4-a0b9-b176a9d2007b', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. Safe evacuation procedures","ii. Rules for the dining area","iii. Who to contact for payroll issues","iv. How to handle workplace injuries","v. Arranging your desk for comfort","vi. Informing staff of potential dangers","vii. General safety responsibilities","viii. Commuting to the office safely"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('cac9e149-dc96-4a42-a4eb-a2bfd524a110', '5bae28a0-4f89-44ee-a877-a247724edf13', 14, 'Paragraph A', 'vii'),
('c2c2c619-7d7c-4fb4-ace3-295a781112b2', '5bae28a0-4f89-44ee-a877-a247724edf13', 15, 'Paragraph B', 'v'),
('44f8765a-d1dc-45c0-b16b-d7e8a21b637e', '5bae28a0-4f89-44ee-a877-a247724edf13', 16, 'Paragraph C', 'i'),
('aef6d002-3c32-44f3-8e16-bd3d10a3c5dc', '5bae28a0-4f89-44ee-a877-a247724edf13', 17, 'Paragraph D', 'ii'),
('5fd22b2e-0be6-436d-aaaf-c64cf0f8fdd8', '5bae28a0-4f89-44ee-a877-a247724edf13', 18, 'Paragraph E', 'vi'),
('327fae8a-8148-45ab-bfb2-baf7b2c8ab77', '5bae28a0-4f89-44ee-a877-a247724edf13', 19, 'Paragraph F', 'iv');

-- ── Group 5: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('7218513a-ce99-4cf3-a184-8e1812a52747', '0f4ef5b5-330b-4dc4-a0b9-b176a9d2007b', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('fbd43fab-1de5-47ef-a614-32e851c3ebf0', '7218513a-ce99-4cf3-a184-8e1812a52747', 20,
 'Instructions on what to do if you spill a drink and cannot clean it up easily.', 'E',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('93911ebd-f11e-4b0d-83db-d8dc8c2f3681', '7218513a-ce99-4cf3-a184-8e1812a52747', 21,
 'The location where employees should gather during an emergency.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('5617bacf-c832-4599-b1e8-63ae4a3b87f3', '7218513a-ce99-4cf3-a184-8e1812a52747', 22,
 'Where to find medical supplies if you cut your finger.', 'F',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('609ebc72-0382-4c98-a1fc-d564c086acd4', '7218513a-ce99-4cf3-a184-8e1812a52747', 23,
 'Advice on how often you should step away from your computer.', 'B',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');

-- ── Group 6: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('fe189913-58a0-456d-9a27-de15ece2ce7f', '0f4ef5b5-330b-4dc4-a0b9-b176a9d2007b', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('42fb96e4-38b7-4f9f-afbc-20439d688655', 'fe189913-58a0-456d-9a27-de15ece2ce7f', 24,
 'According to Paragraph B, the top of your computer monitor should be:',
 'C',
 '[{"id":"A","text":"A. Tilted slightly downwards.","isCorrect":false},{"id":"B","text":"B. Positioned below your line of sight.","isCorrect":false},{"id":"C","text":"C. Level with your eyes.","isCorrect":true},{"id":"D","text":"D. Adjusted every hour.","isCorrect":false}]'),
('4760344f-23b3-466e-980d-cdd54bf40443', 'fe189913-58a0-456d-9a27-de15ece2ce7f', 25,
 'If the fire alarm rings, what must an employee do?',
 'D',
 '[{"id":"A","text":"A. Take the elevator down to the ground floor quickly.","isCorrect":false},{"id":"B","text":"B. Pack up their laptop and bag before leaving.","isCorrect":false},{"id":"C","text":"C. Wait at their desk for the fire warden.","isCorrect":false},{"id":"D","text":"D. Leave the building immediately using the stairs.","isCorrect":true}]'),
('b2865eec-9a7b-4303-a497-ba6a10fbde59', 'fe189913-58a0-456d-9a27-de15ece2ce7f', 26,
 'What happens to food in the kitchen fridge if it does not have a name label?',
 'B',
 '[{"id":"A","text":"A. It is shared among the office staff.","isCorrect":false},{"id":"B","text":"B. It will be thrown away by the cleaners on Friday.","isCorrect":true},{"id":"C","text":"C. It is returned to the kitchen cupboards.","isCorrect":false},{"id":"D","text":"D. It is kept until the end of the month.","isCorrect":false}]'),
('25f34975-bfde-421a-a6e4-5518cb75b044', 'fe189913-58a0-456d-9a27-de15ece2ce7f', 27,
 'How soon must an accident be recorded in the official logbook?',
 'A',
 '[{"id":"A","text":"A. Within 24 hours of it happening.","isCorrect":true},{"id":"B","text":"B. By the end of the working week.","isCorrect":false},{"id":"C","text":"C. Immediately, before seeing the First Aid Officer.","isCorrect":false},{"id":"D","text":"D. Only if the injury is considered major.","isCorrect":false}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: The History of the Modern Postcard (Q28–40)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('8e22d8a5-2577-4d31-a849-9150a444ca74', '034f8a01-2885-46de-bf1e-25db819cf7b4', 3,
 'The History of the Modern Postcard',
 '(A) Today, sending a postcard from a holiday destination is a charming, somewhat nostalgic tradition. However, in the late 19th and early 20th centuries, the postcard was a revolutionary form of communication. Before the postcard, written correspondence meant composing a formal letter, sealing it in an envelope, and paying a high postage fee. The postcard offered a fast, cheap, and informal alternative. The concept originated in Europe; Austria-Hungary issued the world’s first "Correspondenz-Karte" (correspondence card) in 1869. It was a simple piece of stiff paper with space for an address on one side and a short message on the other. It featured no pictures, but it cost half the price of a standard letter to send.

(B) The idea was an immediate success, and other European countries quickly followed suit. However, it was the addition of illustrations that truly ignited the public’s imagination. In the 1870s, private companies began printing cards with small engravings of famous landmarks, cities, or humorous cartoons in the corner. These early illustrated cards were restricted by postal regulations, which dictated that the entire back of the card had to be reserved exclusively for the recipient’s address. Therefore, any message had to be squeezed onto the front side, writing directly over or around the picture.

(C) The turn of the 20th century ushered in what is now known as the "Golden Age of Postcards" (roughly 1898 to 1914). In 1902, the British Post Office made a crucial rule change: they introduced the "divided back." This meant a line was drawn down the middle of the back of the card; the address went on the right, and the message on the left. This freed up the entire front of the card for a large, high-quality picture. With advances in color printing and photography, postcards became beautiful objects. People didn''t just send them; they avidly collected them, arranging them in specialized albums. During this period, billions of postcards passed through global postal systems every year.

(D) Postcards served multiple functions in society before the widespread availability of telephones or daily newspapers with photographs. They were the "text messages" of the Edwardian era, used to arrange immediate meetings, send brief greetings, or confirm safe arrivals. Furthermore, they were a primary source of visual news. If a significant event occurred—such as a train crash, a royal parade, or a natural disaster—local photographers would rush to take pictures, print them onto postcards, and sell them on the streets within hours.

(E) The decline of the postcard began during the First World War. The cost of postage increased, and the high-quality printing presses of Germany, which had supplied much of the world with beautiful cards, were cut off from international markets. In the decades that followed, the telephone became common in middle-class homes, drastically reducing the need to send short, quick written messages. By the mid-20th century, the postcard had largely been relegated to its modern role: a cheap souvenir bought by tourists on holiday to show friends and family where they were staying.

(F) Despite their decline in daily use, old postcards have become highly sought after by historians and collectors. They provide an invaluable visual record of the past. Because they feature photographs of ordinary streets, local shops, and everyday people—subjects rarely deemed important enough to be painted or formally documented—they offer a unique window into social history. Today, the humble postcard is recognized not just as a piece of stationary, but as a vital historical artifact.');

-- ── Group 7: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('fc2f9db9-ffcd-4ed1-91c8-e2d405f73be8', '8e22d8a5-2577-4d31-a849-9150a444ca74', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('f2f198b2-dd66-419e-b3d7-6c181d3cde43', 'fc2f9db9-ffcd-4ed1-91c8-e2d405f73be8', 28,
 'The very first correspondence cards produced in Austria-Hungary featured beautiful color photographs.', 'NO', '["NO","No","no"]'),
('ee19309a-5ba2-482f-b79b-e6f274000b01', 'fc2f9db9-ffcd-4ed1-91c8-e2d405f73be8', 29,
 'Early postal rules stated that messages had to be written on the same side as the illustration.', 'YES', '["YES","Yes","yes"]'),
('d6f36211-2ac1-4c69-9ccf-1aa141280630', 'fc2f9db9-ffcd-4ed1-91c8-e2d405f73be8', 30,
 'The British Post Office charged more to send a divided-back postcard than a traditional one.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('821f2bc4-9b66-416a-9174-80f5a2e4b6ff', 'fc2f9db9-ffcd-4ed1-91c8-e2d405f73be8', 31,
 'Postcards were sometimes used to quickly spread news of important or tragic events.', 'YES', '["YES","Yes","yes"]');

-- ── Group 8: MATCHING SENTENCE ENDINGS (Q32–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('50a9cb24-397d-433c-8f02-b204d6cf94b3', '8e22d8a5-2577-4d31-a849-9150a444ca74', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('8260d90b-73bf-4338-a46f-96ee342aacae', '50a9cb24-397d-433c-8f02-b204d6cf94b3', 32,
 'Before the invention of the postcard, writing to someone was',
 'B',
 '[{"id":"A","text":"were often displayed in special albums by collectors.","isCorrect":false},{"id":"B","text":"a formal and relatively expensive process.","isCorrect":true},{"id":"C","text":"decreased because telephones became more popular.","isCorrect":false},{"id":"D","text":"allowed the whole front to be used for a single picture.","isCorrect":false},{"id":"E","text":"show everyday streets and ordinary working people.","isCorrect":false},{"id":"F","text":"because German printers charged too much money.","isCorrect":false}]'),
('0f76afde-cc7f-4a9d-96c9-f85676c6891f', '50a9cb24-397d-433c-8f02-b204d6cf94b3', 33,
 'The introduction of the "divided back" design',
 'D',
 '[{"id":"A","text":"were often displayed in special albums by collectors.","isCorrect":false},{"id":"B","text":"a formal and relatively expensive process.","isCorrect":false},{"id":"C","text":"decreased because telephones became more popular.","isCorrect":false},{"id":"D","text":"allowed the whole front to be used for a single picture.","isCorrect":true},{"id":"E","text":"show everyday streets and ordinary working people.","isCorrect":false},{"id":"F","text":"because German printers charged too much money.","isCorrect":false}]'),
('d2629004-1b94-459a-948d-a3f989548b6e', '50a9cb24-397d-433c-8f02-b204d6cf94b3', 34,
 'During the early 20th century, beautifully printed postcards',
 'A',
 '[{"id":"A","text":"were often displayed in special albums by collectors.","isCorrect":true},{"id":"B","text":"a formal and relatively expensive process.","isCorrect":false},{"id":"C","text":"decreased because telephones became more popular.","isCorrect":false},{"id":"D","text":"allowed the whole front to be used for a single picture.","isCorrect":false},{"id":"E","text":"show everyday streets and ordinary working people.","isCorrect":false},{"id":"F","text":"because German printers charged too much money.","isCorrect":false}]'),
('6b5d5849-76e4-43de-85a6-506961372103', '50a9cb24-397d-433c-8f02-b204d6cf94b3', 35,
 'Modern historians value old postcards highly because they',
 'E',
 '[{"id":"A","text":"were often displayed in special albums by collectors.","isCorrect":false},{"id":"B","text":"a formal and relatively expensive process.","isCorrect":false},{"id":"C","text":"decreased because telephones became more popular.","isCorrect":false},{"id":"D","text":"allowed the whole front to be used for a single picture.","isCorrect":false},{"id":"E","text":"show everyday streets and ordinary working people.","isCorrect":true},{"id":"F","text":"because German printers charged too much money.","isCorrect":false}]');

-- ── Group 9: SUMMARY COMPLETION with Word Bank (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('d9e8791c-049c-45ca-af24-ba28f8fc255e', '8e22d8a5-2577-4d31-a849-9150a444ca74', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["telephone", "souvenir", "expensive", "inexpensive", "television", "photography", "Germany", "messages"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('18ca1bef-fa61-4912-9c91-15a8d39930ea', 'd9e8791c-049c-45ca-af24-ba28f8fc255e', 36,
 'The Golden Age of Postcards ended around the time of the First World War. This was partly due to rising postal costs and the loss of high-quality printing materials from {{gap_d9e8791c-049c-45ca-af24-ba28f8fc255e_0}}. Following the war, society began to change. Sending short written {{gap_d9e8791c-049c-45ca-af24-ba28f8fc255e_1}} via the post became less necessary for the middle class because the {{gap_d9e8791c-049c-45ca-af24-ba28f8fc255e_2}} was increasingly being installed in residential homes. Eventually, the postcard lost its status as a vital daily communication tool. Today, it is mostly bought by tourists looking for an {{gap_d9e8791c-049c-45ca-af24-ba28f8fc255e_3}} visual {{gap_d9e8791c-049c-45ca-af24-ba28f8fc255e_4}} of their holidays.',
 'Germany'),
('26066881-6ea0-4fd4-b8f6-324b6641eef7', 'd9e8791c-049c-45ca-af24-ba28f8fc255e', 37,
 '', 'messages'),
('0d836d47-0392-4609-811f-2cd41a119698', 'd9e8791c-049c-45ca-af24-ba28f8fc255e', 38,
 '', 'telephone'),
('a783c54a-4448-42d8-8950-8141d956ecfb', 'd9e8791c-049c-45ca-af24-ba28f8fc255e', 39,
 '', 'inexpensive'),
('69945f22-e7f3-49de-8bdb-1deefa508df2', 'd9e8791c-049c-45ca-af24-ba28f8fc255e', 40,
 '', 'souvenir');

-- ============================================================
-- NOTE: Please execute `UPDATE reading_tests SET created_by = '<your-uid>'` 
-- if required by your application's Row Level Security policies.
-- ============================================================
