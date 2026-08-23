-- ============================================================
-- IELTS Practice Platform – Extended Seed Data
-- Target: Reading Module (General Training, Band 6 Difficulty)
-- Action: APPEND (No TRUNCATE)
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST ENTRY (General Training - Band 6)                   ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('357fc4ff-d461-49ba-b4ba-35d2fedb4efe', 'de6cb73e-1297-46fa-bd61-3e621e29b69a',
 'IELTS General Training Reading: Recycling Guidelines, Remote Work & Traditional Bookbinding (Band 6)', 'General Training', '6', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: Westfield Community Recycling Centre (Q1–13)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('c819404d-38e3-4bca-aff8-eeacb759c603', '357fc4ff-d461-49ba-b4ba-35d2fedb4efe', 1,
 'Westfield Community Recycling Centre: Visitor Guidelines',
 'Welcome to the Westfield Community Recycling Centre. To ensure a safe and efficient experience for everyone, please read the following guidelines before your visit.

General Information
The recycling centre is located at 45 Industrial Way. We are open from Tuesday to Sunday between 8:00 AM and 4:30 PM. The centre is closed on Mondays and all public holidays. This facility is strictly for Westfield residents. Upon arrival, you must present a valid driver’s license or a recent utility bill as proof of address to the attendant at the main gate.

Preparing Your Recyclables
To prevent contamination, it is vital that you sort and prepare your items correctly before placing them in the designated bins. 
- Glass and Plastics: All food containers, jars, and plastic bottles must be rinsed thoroughly with water. Lids and caps should be removed and thrown into the general waste bin, as they are often made of non-recyclable plastics.
- Paper and Cardboard: Newspapers, magazines, and office paper can be mixed. However, all large cardboard boxes must be flattened to save space in the containers. Please note that cardboard stained with food, such as greasy pizza boxes, will not be accepted and should be put in your household rubbish.

Disposing of Special Items
Some items cannot go into standard recycling bins and require special handling.
- Electronic Waste (E-waste): Old computers, mobile phones, and printers must be handed directly to our staff at the E-waste counter. Do not leave them on the ground. There is a limit of two large televisions per vehicle per visit.
- Hazardous Materials: Car batteries, motor oil, and leftover household paints must be taken to the Hazardous Waste Zone at the rear of the facility. These materials pose a severe environmental risk and must be processed by specialists.
- Large Appliances: We accept washing machines and ovens free of charge. However, due to the environmental regulations surrounding cooling gases, there is a $15 fee to dispose of a refrigerator or freezer.

Need Help?
If you have heavy items, such as furniture or large appliances, please inform the gate attendant when you arrive. They will radio one of our site volunteers, who will be happy to assist you in unloading your vehicle safely.');

-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('3861dc0b-0b99-4cf1-b0ba-d523d96aba1a', 'c819404d-38e3-4bca-aff8-eeacb759c603', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the text? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('1caced8e-f3c6-4bb5-bfd9-ad2b60d2cd8f', '3861dc0b-0b99-4cf1-b0ba-d523d96aba1a', 1,
 'The recycling centre is open seven days a week.', 'FALSE', '["FALSE","False","false"]'),
('5a0dc6dd-ca99-42a6-bf6e-682d530a0d35', '3861dc0b-0b99-4cf1-b0ba-d523d96aba1a', 2,
 'Visitors need to show a document to prove they live in the Westfield area.', 'TRUE', '["TRUE","True","true"]'),
('dc0673f2-6655-4df0-adbd-92386387e585', '3861dc0b-0b99-4cf1-b0ba-d523d96aba1a', 3,
 'The centre plans to start accepting food-stained pizza boxes next year.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('c5ae9589-47f4-439f-83a9-b7089a1efaf6', '3861dc0b-0b99-4cf1-b0ba-d523d96aba1a', 4,
 'Washing machines cost $15 to drop off at the recycling centre.', 'FALSE', '["FALSE","False","false"]');

-- ── Group 2: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('0c5f8d26-e5b1-4bf7-87f5-6445233bf54a', 'c819404d-38e3-4bca-aff8-eeacb759c603', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN TWO WORDS from the text for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('b739e1f8-658a-4bcc-ae6a-455141f67d69', '0c5f8d26-e5b1-4bf7-87f5-6445233bf54a', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"Item Category","answer":""},{"id":"h2","gapText":"Preparation Rule","answer":""},{"id":"h3","gapText":"Special Notes","answer":""}]'),
('0fbbe246-8527-4fe0-b127-6e10b262bd13', '0c5f8d26-e5b1-4bf7-87f5-6445233bf54a', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"Glass and Plastics","answer":""},{"id":"c2","gapText":"Must be {{gap}} with water","answer":"rinsed thoroughly"},{"id":"c3","gapText":"Put lids in the general waste","answer":""}]'),
('3c983475-7602-4bc6-a21d-701d2e1a73d5', '0c5f8d26-e5b1-4bf7-87f5-6445233bf54a', 7,
 'Row 3', '',
 '[{"id":"c4","gapText":"Cardboard","answer":""},{"id":"c5","gapText":"Boxes need to be {{gap}}","answer":"flattened"},{"id":"c6","gapText":"No food stains allowed","answer":""}]'),
('2056d5d5-fabd-4b2f-b413-17b1afdba01d', '0c5f8d26-e5b1-4bf7-87f5-6445233bf54a', 8,
 'Row 4', '',
 '[{"id":"c7","gapText":"Electronic Waste","answer":""},{"id":"c8","gapText":"Give items to the {{gap}}","answer":"staff"},{"id":"c9","gapText":"Max of two televisions per visit","answer":""}]'),
('44cc6337-f8aa-4cd9-949e-6021c86b37b9', '0c5f8d26-e5b1-4bf7-87f5-6445233bf54a', 9,
 'Row 5', '',
 '[{"id":"c10","gapText":"Car batteries & paint","answer":""},{"id":"c11","gapText":"Take to the {{gap}}","answer":"Hazardous Waste"},{"id":"c12","gapText":"Handled by specialists","answer":""}]');

-- ── Group 3: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('337b8153-fd76-4f52-ad29-57dfd892e169', 'c819404d-38e3-4bca-aff8-eeacb759c603', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS from the text for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('a1cec4ec-65e5-4f9a-a990-d17ed9c8d903', '337b8153-fd76-4f52-ad29-57dfd892e169', 10,
 'What document besides a driver’s license can be used to show your address?', 'utility bill', '[{"id":"1","text":"utility bill"},{"id":"2","text":"recent utility bill"},{"id":"3","text":"a utility bill"}]'),
('4e48310b-8cf6-42a5-adb1-e63c6829074d', '337b8153-fd76-4f52-ad29-57dfd892e169', 11,
 'Where should plastic caps and lids be thrown?', 'general waste bin', '[{"id":"1","text":"general waste bin"},{"id":"2","text":"the general waste bin"}]'),
('efd7bc6b-87bb-4ae6-a26a-5df7597ebcfe', '337b8153-fd76-4f52-ad29-57dfd892e169', 12,
 'What type of waste has a limit of two per vehicle?', 'large televisions', '[{"id":"1","text":"televisions"},{"id":"2","text":"large televisions"}]'),
('4b3dad50-4b78-4a11-a89c-98644f3c3d5d', '337b8153-fd76-4f52-ad29-57dfd892e169', 13,
 'Who is available to help people lift heavy furniture out of their vehicles?', 'site volunteers', '[{"id":"1","text":"site volunteers"},{"id":"2","text":"volunteers"},{"id":"3","text":"our site volunteers"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Employee Guide to Remote Work (Q14–27)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('36a4fe91-6ab4-4544-8e63-456fb8c2d3d5', '357fc4ff-d461-49ba-b4ba-35d2fedb4efe', 2,
 'Pinnacle Corp: Employee Guide to Remote Work Ergonomics and Well-being',
 '(A) While working from home offers flexibility, setting up a proper workstation is essential for your long-term health. Avoid working from soft surfaces like sofas or beds, which provide zero back support. Your desk should be at a height where your elbows rest at a 90-degree angle when typing. The top of your computer monitor must be directly at eye level to prevent neck strain. Natural light is preferable, so position your desk near a window, but ensure the screen does not reflect direct sunlight, which causes severe glare and eye fatigue.

(B) Pinnacle Corp is committed to ensuring you have the right tools. All remote staff will be shipped a standard technology package containing a laptop, a noise-cancelling headset, and an external mouse. If your role requires graphic design or heavy data analysis, you may request a secondary monitor through the IT portal. Please be aware that this equipment remains the property of Pinnacle Corp and must be returned if your employment contract is terminated.

(C) Working remotely does not mean working around the clock. We operate on "Core Hours," meaning all staff must be online and available for team meetings between 10:00 AM and 2:00 PM, regardless of their local time zone. Outside of these four hours, you are free to structure the rest of your workday however you see fit, provided you complete your standard 40-hour workweek.

(D) The lack of a daily commute means many remote workers end up sitting for dangerously long periods. We strongly recommend following the 20-20-20 rule to reduce eye strain: every 20 minutes, look at something 20 feet away for at least 20 seconds. Furthermore, use your phone’s alarm to remind yourself to stand up, stretch, or walk around the house for five minutes every hour. Physical movement is crucial for maintaining both focus and circulation.

(E) When your home becomes your office, data security becomes a shared responsibility. Staff must never use public Wi-Fi networks in cafes or airports to access company servers without activating the company’s Virtual Private Network (VPN) software. Additionally, ensure that your home router is protected by a strong, unique password. Do not leave confidential physical documents lying around where visitors or family members could accidentally read them.

(F) Pinnacle Corp provides a monthly stipend of $50 to help cover the costs of home internet and electricity. This amount is automatically added to your paycheck at the end of each month and is tax-free. If you need to purchase basic office supplies, such as printer ink or notepads, you must buy them yourself and submit the receipts to the HR department via the expense software for reimbursement within two weeks.');

-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('5326c254-725b-4f3a-82d7-e5a36702d335', '36a4fe91-6ab4-4544-8e63-456fb8c2d3d5', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. Staying safe from cyber threats at home", "ii. Claiming money back for office purchases", "iii. Creating a physically healthy workspace", "iv. Understanding the company meeting schedule", "v. Company-provided technology and hardware", "vi. The dangers of working from public spaces", "vii. Managing time and expected availability", "viii. Techniques to avoid physical and visual fatigue"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('e8ce8d7d-732d-4182-8a78-b8bd6b327c80', '5326c254-725b-4f3a-82d7-e5a36702d335', 14, 'Paragraph A', 'iii'),
('6a25810f-e2f5-475c-abbc-8df2dac3acce', '5326c254-725b-4f3a-82d7-e5a36702d335', 15, 'Paragraph B', 'v'),
('958bb72c-3d57-4fa3-a50b-a6402e003ff3', '5326c254-725b-4f3a-82d7-e5a36702d335', 16, 'Paragraph C', 'vii'),
('f8cca5d5-ab8b-4eb0-b980-81332f054647', '5326c254-725b-4f3a-82d7-e5a36702d335', 17, 'Paragraph D', 'viii'),
('21ff0aed-3c80-4eb4-aead-1e7b43f1e380', '5326c254-725b-4f3a-82d7-e5a36702d335', 18, 'Paragraph E', 'i'),
('05154812-d653-4833-b333-5380d80b0b1c', '5326c254-725b-4f3a-82d7-e5a36702d335', 19, 'Paragraph F', 'ii');

-- ── Group 5: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('a2aadea6-4a60-479a-a333-ffaf36e1bc29', '36a4fe91-6ab4-4544-8e63-456fb8c2d3d5', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('bbffd014-7557-4153-9de8-3a28117c044c', 'a2aadea6-4a60-479a-a333-ffaf36e1bc29', 20,
 'A mention of an automatic, tax-free payment given to employees.', 'F',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('0556dfc0-f81f-45fc-b4aa-312a5f56ff70', 'a2aadea6-4a60-479a-a333-ffaf36e1bc29', 21,
 'Advice on avoiding problems caused by bright sunlight on screens.', 'A',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('e92b2dc0-bcad-40a8-bce7-80d71351b131', 'a2aadea6-4a60-479a-a333-ffaf36e1bc29', 22,
 'The procedure for requesting an extra computer screen.', 'B',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('818e1b1c-447a-46df-a2e4-278cd023241e', 'a2aadea6-4a60-479a-a333-ffaf36e1bc29', 23,
 'A specific daily timeframe when employees must be contactable.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');

-- ── Group 6: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('0e7a6a82-9021-4392-9a05-af3794926971', '36a4fe91-6ab4-4544-8e63-456fb8c2d3d5', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('0e58e621-0d76-4ed9-835b-2cdf10ccdbcc', '0e7a6a82-9021-4392-9a05-af3794926971', 24,
 'According to Paragraph A, how should a computer monitor be positioned?',
 'B',
 '[{"id":"A","text":"A. Slightly lower than eye level to relax the neck.","isCorrect":false},{"id":"B","text":"B. Directly at eye level to prevent neck strain.","isCorrect":true},{"id":"C","text":"C. At a 90-degree angle to the natural light.","isCorrect":false},{"id":"D","text":"D. On a soft surface to reduce vibrations.","isCorrect":false}]'),
('10e271fe-4f66-4573-b324-145084814b9c', '0e7a6a82-9021-4392-9a05-af3794926971', 25,
 'What does the company advise employees to do every hour?',
 'D',
 '[{"id":"A","text":"A. Drink a glass of water to stay hydrated.","isCorrect":false},{"id":"B","text":"B. Look at an object 20 feet away for 20 seconds.","isCorrect":false},{"id":"C","text":"C. Check their emails to ensure they are available.","isCorrect":false},{"id":"D","text":"D. Stand up or walk around for five minutes.","isCorrect":true}]'),
('b463525b-9c68-4506-b4bf-4078d8b94ab6', '0e7a6a82-9021-4392-9a05-af3794926971', 26,
 'When working from a cafe, an employee must:',
 'A',
 '[{"id":"A","text":"A. Turn on the company’s Virtual Private Network (VPN).","isCorrect":true},{"id":"B","text":"B. Ask the cafe manager for a secure Wi-Fi password.","isCorrect":false},{"id":"C","text":"C. Avoid taking physical company documents with them.","isCorrect":false},{"id":"D","text":"D. Work only during the Core Hours of 10:00 AM to 2:00 PM.","isCorrect":false}]'),
('520adfba-8b60-4a77-bffa-d1b44d8f34b4', '0e7a6a82-9021-4392-9a05-af3794926971', 27,
 'How do employees get money back for buying printer ink?',
 'C',
 '[{"id":"A","text":"A. It is automatically added to their $50 monthly stipend.","isCorrect":false},{"id":"B","text":"B. They must ask the IT portal to ship it to them directly.","isCorrect":false},{"id":"C","text":"C. They submit a receipt through the company’s expense software.","isCorrect":true},{"id":"D","text":"D. They take the receipt to the HR department in person.","isCorrect":false}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: The Resurgence of Traditional Bookbinding (Q28–40)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('89d8a572-3059-4a8f-b19a-44327ffc428f', '357fc4ff-d461-49ba-b4ba-35d2fedb4efe', 3,
 'The Resurgence of Traditional Bookbinding in the Digital Age',
 '(A) In an era dominated by electronic readers, smartphones, and mass-produced paperbacks, it might seem counterintuitive that a centuries-old craft is experiencing a significant revival. Yet, traditional hand-bookbinding—the meticulous process of creating a book using paper, thread, glue, and leather without heavy machinery—is making a remarkable comeback. Across major cities worldwide, independent binderies are opening their doors, and workshops teaching the craft are fully booked months in advance. To understand this trend, one must look beyond the mere functionality of reading and explore the human desire for tactile experiences in an increasingly digital world.

(B) For most of human history, a book was a rare and highly valued object. Before the invention of the printing press in the 15th century, manuscripts were copied by hand and bound in heavy wooden boards covered in leather, often decorated with gold or jewels. Even after mass printing became common, bookbinding remained a specialized profession. It wasn’t until the Industrial Revolution in the 19th century that books were manufactured cheaply and quickly using automated machines. This democratization of knowledge was undeniably a positive societal shift, but it reduced the physical book to a cheap, disposable commodity. 

(C) Today, the modern revival of bookbinding is driven by a reaction against this disposability. As people spend their workdays staring at glowing screens, handling virtual files that have no physical weight or texture, there is a growing psychological need to engage with the physical world. A hand-bound book offers a sensory experience that an e-reader simply cannot replicate. The smell of the paper, the texture of the linen thread, and the sound of thick pages turning provide a grounding contrast to the fleeting nature of digital media. Artisans argue that a hand-bound book is not just a container for text; it is an art object in its own right.

(D) The learning curve for traditional bookbinding is steep. Beginners must master basic skills such as folding paper accurately into "signatures" (small bundles of pages), sewing them together along the spine, and cutting book board for the covers. More advanced binders work with expensive materials like goat leather and gold leaf, utilizing specialized tools made from bone or brass that have barely changed in design for 400 years. Interestingly, the internet—the very technology blamed for the decline of printed books—has been crucial to the craft’s revival. Online video tutorials and social media platforms allow master binders to share their techniques with a global audience, creating a vibrant digital community of physical makers.

(E) This renewed interest has also sparked a niche economic market. While nobody buys a hand-bound book simply to read the latest bestselling thriller, there is a strong demand for bespoke items. Consumers are willing to pay hundreds of dollars for custom photo albums, beautifully bound guest books for weddings, or restored editions of beloved family heirlooms. Independent writers and poets are also collaborating with binders to release limited-edition physical copies of their work, recognizing that the unique packaging significantly increases the perceived value of the writing.

(F) Ultimately, the survival of traditional bookbinding suggests that technology does not simply replace old mediums; it forces them to adapt and find new purposes. Just as the invention of photography did not destroy painting but rather pushed it away from realism and toward impressionism, the e-reader has freed the physical book from the burden of being a cheap information delivery system. It allows the book to return to its roots as a beautiful, enduring object crafted with human hands.');

-- ── Group 7: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('dbe9e805-2988-4d96-88ad-355d9e5af689', '89d8a572-3059-4a8f-b19a-44327ffc428f', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('a2be0745-ea20-482d-8feb-54a944a936b3', 'dbe9e805-2988-4d96-88ad-355d9e5af689', 28,
 'The rising popularity of hand-bookbinding is surprising given the dominance of modern digital devices.', 'YES', '["YES","Yes","yes"]'),
('6da49d8f-1571-4b6f-af69-6dec19d09c2b', 'dbe9e805-2988-4d96-88ad-355d9e5af689', 29,
 'The Industrial Revolution led to books becoming more expensive for the average person to buy.', 'NO', '["NO","No","no"]'),
('688ffa2f-f6a2-49d5-ac8f-4a6cbec6c7a9', 'dbe9e805-2988-4d96-88ad-355d9e5af689', 30,
 'Advanced bookbinders often have to invent new tools to work with modern materials.', 'NO', '["NO","No","no"]'),
('992b4e20-4eb2-4d02-8d4d-467135d3fb9f', 'dbe9e805-2988-4d96-88ad-355d9e5af689', 31,
 'Most people who take bookbinding workshops are hoping to start their own full-time business.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]');

-- ── Group 8: MATCHING SENTENCE ENDINGS (Q32–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('74c2b18e-04db-4e3a-b997-9e0cbf469e2a', '89d8a572-3059-4a8f-b19a-44327ffc428f', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('2da6ab89-7486-442b-9a6d-661e269989ab', '74c2b18e-04db-4e3a-b997-9e0cbf469e2a', 32,
 'People who work with digital files all day',
 'C',
 '[{"id":"A","text":"has actually helped the traditional craft to grow and spread globally.","isCorrect":false},{"id":"B","text":"because they contain the latest popular fiction stories.","isCorrect":false},{"id":"C","text":"often seek out physical objects that provide a sensory experience.","isCorrect":true},{"id":"D","text":"was considered a very cheap and disposable commodity.","isCorrect":false},{"id":"E","text":"has stopped being a practical way to deliver everyday information.","isCorrect":false},{"id":"F","text":"because they appreciate the craftsmanship and high-quality materials.","isCorrect":false}]'),
('2c1c8e95-9bc7-4f7a-990f-934d95050a0d', '74c2b18e-04db-4e3a-b997-9e0cbf469e2a', 33,
 'The internet, which changed how people read,',
 'A',
 '[{"id":"A","text":"has actually helped the traditional craft to grow and spread globally.","isCorrect":true},{"id":"B","text":"because they contain the latest popular fiction stories.","isCorrect":false},{"id":"C","text":"often seek out physical objects that provide a sensory experience.","isCorrect":false},{"id":"D","text":"was considered a very cheap and disposable commodity.","isCorrect":false},{"id":"E","text":"has stopped being a practical way to deliver everyday information.","isCorrect":false},{"id":"F","text":"because they appreciate the craftsmanship and high-quality materials.","isCorrect":false}]'),
('c944ed9d-0f38-470e-9a9a-e1129e89dfd5', '74c2b18e-04db-4e3a-b997-9e0cbf469e2a', 34,
 'Customers are willing to pay high prices for hand-bound books',
 'F',
 '[{"id":"A","text":"has actually helped the traditional craft to grow and spread globally.","isCorrect":false},{"id":"B","text":"because they contain the latest popular fiction stories.","isCorrect":false},{"id":"C","text":"often seek out physical objects that provide a sensory experience.","isCorrect":false},{"id":"D","text":"was considered a very cheap and disposable commodity.","isCorrect":false},{"id":"E","text":"has stopped being a practical way to deliver everyday information.","isCorrect":false},{"id":"F","text":"because they appreciate the craftsmanship and high-quality materials.","isCorrect":true}]'),
('275a7aa8-ff8d-4864-a0e2-4e6cbe86d04f', '74c2b18e-04db-4e3a-b997-9e0cbf469e2a', 35,
 'The writer argues that the printed book',
 'E',
 '[{"id":"A","text":"has actually helped the traditional craft to grow and spread globally.","isCorrect":false},{"id":"B","text":"because they contain the latest popular fiction stories.","isCorrect":false},{"id":"C","text":"often seek out physical objects that provide a sensory experience.","isCorrect":false},{"id":"D","text":"was considered a very cheap and disposable commodity.","isCorrect":false},{"id":"E","text":"has stopped being a practical way to deliver everyday information.","isCorrect":true},{"id":"F","text":"because they appreciate the craftsmanship and high-quality materials.","isCorrect":false}]');

-- ── Group 9: SUMMARY COMPLETION with Word Bank (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('f5f7c9fe-018c-46d9-b8bf-2cef50c8dbb0', '89d8a572-3059-4a8f-b19a-44327ffc428f', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["disposable", "rare", "tactile", "digital", "communities", "cheap", "valuable", "adapted"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('fbb0d6bc-169b-4da1-927c-d904ac020d90', 'f5f7c9fe-018c-46d9-b8bf-2cef50c8dbb0', 36,
 'Historically, books were very {{gap_f5f7c9fe-018c-46d9-b8bf-2cef50c8dbb0_0}} and expensive objects before mass manufacturing changed society. The modern revival of bookmaking is partly because people want a physical, {{gap_f5f7c9fe-018c-46d9-b8bf-2cef50c8dbb0_1}} experience that they cannot get from electronic screens. Surprisingly, {{gap_f5f7c9fe-018c-46d9-b8bf-2cef50c8dbb0_2}} platforms have been highly beneficial, allowing experts to share skills online and build global networks. Furthermore, there is a specific market for custom books, showing that physical writing can still be highly {{gap_f5f7c9fe-018c-46d9-b8bf-2cef50c8dbb0_3}}. Ultimately, the physical book has {{gap_f5f7c9fe-018c-46d9-b8bf-2cef50c8dbb0_4}} to the modern world rather than disappearing entirely.',
 'rare'),
('e227fa89-ea41-431a-9ef6-0a3f4626cc31', 'f5f7c9fe-018c-46d9-b8bf-2cef50c8dbb0', 37,
 '', 'tactile'),
('b62fdef0-2a01-4b60-b276-3fafd64fabe7', 'f5f7c9fe-018c-46d9-b8bf-2cef50c8dbb0', 38,
 '', 'digital'),
('be783e9f-4aa7-43ac-b8d5-9c46ee3838b0', 'f5f7c9fe-018c-46d9-b8bf-2cef50c8dbb0', 39,
 '', 'valuable'),
('d888fb9d-d84a-4b98-8151-b3e8ef414f63', 'f5f7c9fe-018c-46d9-b8bf-2cef50c8dbb0', 40,
 '', 'adapted');

-- ============================================================
-- NOTE: Please execute `UPDATE reading_tests SET created_by = '<your-uid>'` 
-- if required by your application's Row Level Security policies.
-- ============================================================
