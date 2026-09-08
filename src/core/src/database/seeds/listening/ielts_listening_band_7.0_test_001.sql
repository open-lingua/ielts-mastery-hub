-- ============================================================
-- IELTS Practice Platform – Seed Data
-- Target: Listening Module (Band 7 Difficulty)
-- Description: Upper-intermediate listening test featuring 
-- everyday contexts with moderate distractors and varied accents.
-- ============================================================

-- ████████████████████████████████████████████████████████████
-- ██  LISTENING TEST RECORD                                 ██
-- ████████████████████████████████████████████████████████████

INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status) VALUES
('485887b9-f68a-4749-99c7-4bfee3430957', '73078a6e-6640-41be-a953-5ad4c046ebda',
 'IELTS Upper-Intermediate Listening: College Enrollment & Rec Center Tour (Band 7)', '7', '40 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 1: Transactional Dialogue (College Enrollment)  ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('69b753e3-0e48-4e5d-9ac0-68386ba4c357', '485887b9-f68a-4749-99c7-4bfee3430957', 1,
 'Community College Course Enrollment',
 'Agent: Good afternoon, Westcombe Community College continuing education department. This is Mark speaking. How can I help you today?
Caller: Hello, Mark. My name is Rachel. I''m calling because I''d like to enroll in one of your evening courses for the upcoming autumn semester. I was looking at the catalog online and I''m interested in the photography programs.
Agent: Great, Rachel. We have several photography courses running this autumn. Are you a beginner, or do you have some prior experience? We have an introductory course, and then a more intermediate one focused on digital editing.
Caller: I’ve been taking photos as a hobby for a few years, so I think the beginner one might be too basic. I''m specifically looking at the course titled ''Advanced Digital Landscapes''.
Agent: Ah, yes. ''Advanced Digital Landscapes''. Let me just bring up the registration system on my computer. Bear with me a moment. Okay, yes, that course is still open for enrollment. It''s an eight-week program. It runs on Tuesday and Thursday evenings.
Caller: Oh, wait. The website said it was on Wednesdays. Has that changed?
Agent: Ah, let me double-check. I apologize, you are correct. The beginner course is Tuesday and Thursday. The ''Advanced Digital Landscapes'' is a longer single session on Wednesday evenings, from 6:30 PM to 9:00 PM.
Caller: Perfect, Wednesdays work much better for my schedule. Who is the instructor for that class?
Agent: The instructor is a professional photographer named Jonathan Steeves.
Caller: Could you spell his surname for me, please?
Agent: Certainly. It''s S-T-E-E-V-E-S. He’s won several regional awards for his nature photography.
Caller: Excellent. And what are the prerequisites? I have a DSLR camera, but it''s a few years old.
Agent: That shouldn''t be a problem as long as it has manual settings. The main prerequisite is that you need to have a basic understanding of photo editing software. The college provides the software in our Mac labs, but we won''t be covering the absolute basics of how to use it.
Caller: That''s fine. I use standard editing software all the time at home. What is the total cost of the course?
Agent: The tuition fee is two hundred and forty-five pounds. However, there is also a mandatory studio fee for the printing materials we provide, which is an additional thirty pounds. So, the total is two hundred and seventy-five pounds.
Caller: Okay, two hundred and seventy-five. Do I have to pay that all at once?
Agent: No, you can secure your place with a twenty percent deposit today, and the balance is due two weeks before the course begins.
Caller: Great. Let''s go ahead and get me registered.
Agent: Wonderful. I''ll just need to take down some of your personal details. You said your first name is Rachel. What is your surname?
Caller: It''s Hargreaves. H-A-R-G-R-E-A-V-E-S.
Agent: Thank you. And your date of birth?
Caller: It''s the 14th of September, 1992.
Agent: Excellent. Now, I need a current residential address to send your student card and campus map.
Caller: I live at 42 Willow Court, in the Riverside district.
Agent: 42 Willow Court... and what is the postcode for that area?
Caller: It is W-C-8 4-P-L.
Agent: Let me read that back. W-C-8 4-P-L. Got it. And a contact telephone number?
Caller: My mobile number is 0-7-7-0-0 9-0-0 4-1-2.
Agent: Perfect. Now, regarding parking. Since it''s an evening class, the main staff car park is available for students after 5:00 PM. Would you like to purchase a parking permit? It''s heavily discounted for evening students.
Caller: Yes, please. I''ll be driving straight from work. How much is the permit?
Agent: It''s fifteen pounds for the entire eight-week term. I''ll add that to your registration file. When you come in for your first class, you can pick up the physical parking pass from the security office at the main gate.
Caller: The security office, got it. One last question. Is there a textbook required for this course?
Agent: There isn''t a mandatory textbook you need to buy. However, Jonathan highly recommends a book called ''The Light in the Landscape'' for supplementary reading. But all essential reading materials will be provided as digital handouts.
Caller: ''The Light in the Landscape''. I might look for a second-hand copy.
Agent: Good idea. One more thing regarding equipment. Jonathan requires all students to bring a sturdy tripod to every session. A lot of the evening work involves long exposures, so a handheld camera won''t be sufficient.
Caller: Oh, I have a small travel tripod. Will that work?
Agent: He specifically advises against lightweight travel tripods because they can vibrate in the wind. You don''t need a professional studio one, but it needs to be made of aluminum or carbon fiber, something with a bit of weight to it.
Caller: Okay, I’ll look into upgrading my tripod before the term starts. Does the class involve any outdoor shoots?
Agent: Yes, I''m glad you asked. On the fourth week of the course, the Wednesday session is replaced by a Saturday morning field trip. You will be going to Blackwood Forest to practice dawn photography. The college provides a mini-bus from the campus, leaving at 5:00 AM sharp.
Caller: 5:00 AM! That is early, but Blackwood Forest is beautiful in the morning. Is there an extra charge for the transport?
Agent: No, the mini-bus transport is included in your course fees. Just remember to bring warm clothing and waterproof boots, as the forest can be quite muddy in October.
Caller: Sounds like quite an adventure. Now, we just need to process my deposit. I will use my Visa credit card.
Agent: Okay, I will send a secure payment link to your email address right now. Once that is processed, your enrollment is confirmed. Can I have your email?
Caller: Yes, it is r.hargreaves at mail.com.
Agent: Excellent. You should receive that shortly. We look forward to seeing you in September, Rachel.
Caller: Thank you for your help, Mark. Bye.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('ad8e35a0-b6f5-4851-bcca-796f138b8ec0', '69b753e3-0e48-4e5d-9ac0-68386ba4c357', 1,
 'form-completion', 'Complete the enrollment form below. Write ONE WORD AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('37375d44-1790-42d1-887f-6cd91d05993f', 'ad8e35a0-b6f5-4851-bcca-796f138b8ec0', 1,
 'Course Name: Advanced Digital ________', 'Landscapes', '["Landscapes","landscapes"]'),
('892e60a5-afea-4f47-9fb6-cde4c0e46ca1', 'ad8e35a0-b6f5-4851-bcca-796f138b8ec0', 2,
 'Instructor''s surname: ________', 'Steeves', '["Steeves","steeves","STEEVES"]'),
('bd8980f3-0681-404e-bbeb-cda188e27fa5', 'ad8e35a0-b6f5-4851-bcca-796f138b8ec0', 3,
 'Total course cost: £________', '275', '["275","two hundred and seventy-five"]'),
('081f8ab0-bc37-4355-9730-103718ce8e05', 'ad8e35a0-b6f5-4851-bcca-796f138b8ec0', 4,
 'Student Surname: ________', 'Hargreaves', '["Hargreaves","hargreaves","HARGREAVES"]'),
('49ca1e01-80b7-45f8-a49a-ba0eecddc9d3', 'ad8e35a0-b6f5-4851-bcca-796f138b8ec0', 5,
 'Postcode: ________', 'WC8 4PL', '["WC8 4PL","wc8 4pl","WC84PL"]'),
('00942a16-0f8c-4a9e-9d34-f90f917d61c9', 'ad8e35a0-b6f5-4851-bcca-796f138b8ec0', 6,
 'Pick up parking pass from the security ________', 'office', '["office","Office"]'),
('9d2ed689-98d5-4c05-9d73-a64a8b281cfa', 'ad8e35a0-b6f5-4851-bcca-796f138b8ec0', 7,
 'Recommended book: The ________ in the Landscape', 'Light', '["Light","light"]'),
('0bc38951-a4d0-4dc7-a509-2fdbedbc6dc5', 'ad8e35a0-b6f5-4851-bcca-796f138b8ec0', 8,
 'Required equipment: a sturdy ________', 'tripod', '["tripod","Tripod"]'),
('376572d2-1da2-45b8-8ce3-0a0cf8a8a654', 'ad8e35a0-b6f5-4851-bcca-796f138b8ec0', 9,
 'Field trip location: ________ Forest', 'Blackwood', '["Blackwood","blackwood"]'),
('c5c5aa65-13af-4636-825b-de9dd3ed51b9', 'ad8e35a0-b6f5-4851-bcca-796f138b8ec0', 10,
 'Field trip transport: a ________ will be provided', 'mini-bus', '["mini-bus","minibus","Mini-bus"]');

-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 2: Monologue (Recreation Center Tour)           ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('cf6fef41-c800-4a92-a5c3-7919dcff1516', '485887b9-f68a-4749-99c7-4bfee3430957', 2,
 'Westside Community Recreation Center Tour',
 'Manager: Welcome, everyone, to the official open day of the brand-new Westside Community Recreation Center. My name is David, and I’m the facility manager here. We are thrilled to finally open our doors after nearly three years of planning and construction. Before we start our physical tour of the building, I’d like to give you a brief overview of what we offer and how you can make the most of this fantastic new community asset.
 
When the city council first proposed this project, the main objective wasn''t just to build another gym. The goal was to create a holistic wellness hub that caters to all age groups and abilities. While many private health clubs focus solely on intense fitness and weightlifting, our primary focus has been on accessibility and family-oriented activities. We want this center to be a place where a teenager can play basketball, a parent can take a yoga class, and a grandparent can participate in water aerobics, all under one roof.

Now, regarding membership. We’ve designed our pricing structure to be as flexible as possible. You can buy a day pass, a monthly rolling contract, or an annual membership. However, if you are a resident of the Westside district, you are eligible for a community discount. To claim this, you don''t just need a driver''s license; you must bring in a recent utility bill—something like a water or electricity bill—dated within the last three months, along with a photo ID. This ensures the subsidized rates go directly to local taxpayers.

Let me tell you about some of the unique features of the center. We are particularly proud of our indoor aquatic facility. Unlike traditional swimming pools that use heavy chlorine, our pools utilize a state-of-the-art saltwater purification system. This is much gentler on the skin and eyes, which is especially beneficial for young children and those with sensitive skin. Furthermore, the main pool features a movable floor. This means we can adjust the water depth from a standard two meters for competitive swimming down to just half a meter for toddler splash sessions.

Another major highlight is the community garden situated on the roof. This isn’t just for decoration; it’s a fully functioning urban farm managed by local volunteers. The produce grown there—tomatoes, herbs, and leafy greens—is actually used in the ground-floor cafe. Any surplus is donated to the local food bank. If you''re interested in volunteering up there, there’s a sign-up sheet at the main reception desk.

Now, let''s look at the floor plan so you know your way around. Please refer to the map on the back of your welcome brochure. Right now, we are standing in the Main Entrance Hall, located at the bottom of your map.

If you walk straight ahead from the entrance hall, you’ll enter the Central Atrium, which is the heart of the building. Immediately to the left of the Atrium is a large space labeled with a dumbbell icon. That is the Free Weights and Cardio Gym. It’s equipped with the latest treadmills and resistance machines, and it’s strictly for members aged sixteen and over.

Directly across from the Gym, on the right side of the Atrium, you will see a curved, glass-fronted room. This is the Mind and Body Studio. We deliberately placed it on the east side of the building so it catches the morning sunlight. This is where we host our yoga, pilates, and meditation classes. We ask that you remove your shoes before entering this space.

If we continue straight past the Central Atrium, moving towards the back of the building, you will find the Aquatic Center. It takes up the entire rear section of the ground floor. As I mentioned, this houses both the main lap pool and the smaller therapy pool.

Now, let’s go back to the Central Atrium. If you take the corridor branching off to the left, just past the Gym, the first door on your right is the Childcare Facility. For a small hourly fee, parents can leave their children here with our certified staff while they exercise. It has a fantastic indoor playground and a quiet nap area.

Finally, if you take the corridor branching off to the right of the Central Atrium, past the Mind and Body Studio, you''ll walk down a short hallway. At the very end of this right-hand corridor is the Multipurpose Sports Hall. This is a massive space with sprung wooden floors, and it can be divided into three smaller courts for badminton, basketball, or five-a-side football.

Alright, that covers the layout. Please gather your belongings, and we will begin the walking tour, starting with the Cardio Gym.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('5d5e60ea-162a-4f06-a318-2d034076c9da', 'cf6fef41-c800-4a92-a5c3-7919dcff1516', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('a2c7b1cb-e163-4f62-9320-45504acc212f', '5d5e60ea-162a-4f06-a318-2d034076c9da', 11,
 'What was the main goal when proposing the new recreation center?',
 '["A. To compete directly with private health clubs", "B. To focus on intense fitness and weight training", "C. To create an accessible, family-oriented space"]', 'C'),
('12df3f94-eb3d-4cee-91dd-4518c231a9ad', '5d5e60ea-162a-4f06-a318-2d034076c9da', 12,
 'To claim the community discount, local residents must provide:',
 '["A. A driver''s license only", "B. A recent utility bill and photo ID", "C. A local tax document"]', 'B'),
('540fc0cb-adee-4857-a703-ffa20ba02d0b', '5d5e60ea-162a-4f06-a318-2d034076c9da', 13,
 'The main swimming pool is unique because:',
 '["A. It utilizes high levels of chlorine to stay clean", "B. The depth of the water can be physically adjusted", "C. It is strictly reserved for competitive swimming"]', 'B'),
('90898b8e-c13e-4de3-9dea-0d25ba757dfb', '5d5e60ea-162a-4f06-a318-2d034076c9da', 14,
 'Where does the produce grown in the rooftop garden primarily go?',
 '["A. It is sold to local community supermarkets", "B. It is used in the center''s cafe and donated to a food bank", "C. It is given exclusively to the volunteers who grow it"]', 'B'),
('8a54452e-0eef-475f-9d94-984221bfdf25', '5d5e60ea-162a-4f06-a318-2d034076c9da', 15,
 'How can someone register to volunteer for the community garden?',
 '["A. By speaking directly to the facility manager", "B. By adding their name to a sign-up sheet at the reception", "C. By registering on the community center''s website"]', 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c8f22ef5-4498-47f6-9551-c01e09c7ef39', 'cf6fef41-c800-4a92-a5c3-7919dcff1516', 2,
 'matching', 'Label the map below. Write the correct letter, A-H, next to Questions 16-20.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('fa52b659-7c44-4a8c-b93f-c2a454a11e37', 'c8f22ef5-4498-47f6-9551-c01e09c7ef39', 16,
 'Free Weights and Cardio Gym', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'B'),
('266ce980-27e7-405c-9787-52b9a1b601cc', 'c8f22ef5-4498-47f6-9551-c01e09c7ef39', 17,
 'Mind and Body Studio', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'E'),
('0a79af62-7584-4c57-ae3f-29bc11fc3563', 'c8f22ef5-4498-47f6-9551-c01e09c7ef39', 18,
 'Aquatic Center', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'C'),
('b2e5d59c-6ee4-4aac-967b-900ae66b3208', 'c8f22ef5-4498-47f6-9551-c01e09c7ef39', 19,
 'Childcare Facility', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'A'),
('e4cdb7fb-f1d3-4587-8b70-5ac6e300c30b', 'c8f22ef5-4498-47f6-9551-c01e09c7ef39', 20,
 'Multipurpose Sports Hall', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'D');

-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 3: Academic Dialogue (Urban Planning Project)   ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('8c50510d-b748-4f37-8cef-ab6fec771186', '485887b9-f68a-4749-99c7-4bfee3430957', 3,
 'Urban Green Spaces Project Meeting',
 'Tutor: Come in, Leo and Maya. Take a seat. I''ve been looking over your initial proposal for the urban planning assignment, and I think you have a very solid foundation. Focusing on urban green spaces and their psychological impacts is certainly relevant right now.
Maya: Thank you, Dr. Aris. We were a bit worried the topic might be too broad, considering how much literature is out there regarding city planning.
Tutor: It is a vast field, which is exactly why I want to discuss narrowing your scope today. Let''s look at your methodology first. You mentioned wanting to conduct surveys, but you haven''t specified your target demographic.
Leo: Right. Initially, we thought about just surveying university students because they are easily accessible on campus. But then we realized that might skew the data, since students often use green spaces differently than, say, families with young children or elderly residents.
Tutor: That’s a very astute observation, Leo. A student sample would definitely introduce age and lifestyle bias. So, what is your revised plan?
Maya: We decided to focus specifically on office workers in the central business district. We want to measure how accessing a nearby park during their lunch hour affects their self-reported stress levels for the rest of the afternoon.
Tutor: Excellent. That is much more specific and highly measurable. Now, regarding the literature review, you’ve included a lot of classic studies, like Kaplan’s Attention Restoration Theory. But I noticed a distinct lack of recent studies focusing on post-pandemic urban behavior.
Leo: We did struggle to find peer-reviewed articles published in the last two years that specifically addressed lunch-hour habits. Most recent studies seem to focus on people relocating to the suburbs.
Tutor: That’s true, but you need to look at journals specializing in occupational health, not just urban planning. I suggest looking into the Journal of Environmental Psychology. There was a fascinating paper published just last month by a researcher named Henderson that directly addresses micro-breaks in urban environments.
Maya: Journal of Environmental Psychology... Henderson. I''m writing that down. Thank you, we will definitely look that up.
Tutor: Now, let''s talk about your data collection methods. You''re planning to use a digital questionnaire. How are you distributing this to the office workers?
Leo: We were planning to stand near the entrances of three major parks in the business district and hand out flyers with a QR code. The code links directly to our online survey. We figured this would be faster than asking people to fill out paper forms on the spot.
Tutor: The QR code is an efficient approach, but you must consider the response rate. People often take a flyer and simply throw it away without scanning it. You need an incentive. Have you budgeted for any kind of small reward?
Maya: Yes, we actually pooled our department printing allowance and managed to secure a small grant from the student union. We are offering a voucher for a free coffee at a local cafe to the first one hundred respondents who complete the survey.
Tutor: Perfect. A tangible incentive like a coffee voucher will significantly boost your participation numbers. Okay, let''s move on to the actual design of the survey. You have twenty questions currently. That is far too long for a lunch-break survey. People will abandon it halfway through.
Leo: We were worried about that. We wanted to gather as much demographic data as possible, but we can probably cut some of those out. Which sections do you think are redundant?
Tutor: Well, looking at questions five through ten, you ask very detailed questions about their commute to work. While interesting, it doesn''t directly serve your core hypothesis about lunch-hour green space usage. I would eliminate those entirely.
Maya: That makes sense. If we cut those five questions, it brings the total down to fifteen, which should take less than three minutes to complete.
Tutor: Exactly. Keep it brief. Now, regarding the parks themselves, you mentioned selecting three specific locations. Let''s review them to ensure they offer good comparative data. Your first choice is Centennial Park.
Leo: Yes. It’s the largest park in the district, very traditional, with lots of large trees, grassy areas, and a duck pond. We figured it represents the classic nature escape.
Tutor: Good. And your second choice is the new Highline Walkway?
Maya: Exactly. It''s very different from Centennial. It''s elevated, heavily paved, with mostly structural planting and modern art installations. It gets a lot of foot traffic, but it’s a very different aesthetic experience.
Tutor: A strong contrast. And the third location?
Leo: We chose the Victoria Square Gardens. It''s quite small, completely surrounded by high-rise buildings, and consists mostly of formal flower beds and benches. It’s a very structured, enclosed space.
Tutor: Those three locations offer excellent variance in design and atmosphere. Now, I want you both to think carefully about how you will analyze the emotional descriptors people use in their open-ended survey responses. You can''t just count the word ''relaxed''.
Maya: Right, we were looking into using a sentiment analysis software. The university has a license for a program called LexiStat. Have you used it before?
Tutor: Yes, LexiStat is quite robust. It will categorize the open-ended responses into positive, negative, and neutral emotional states based on a pre-programmed dictionary. But remember, the software isn''t perfect with sarcasm or local idioms, so you will still need to manually review the data set to ensure accuracy.
Leo: So we should probably allocate an extra week just for data cleaning before we start writing the final report.
Tutor: I highly recommend that. When is your proposed deadline for finishing data collection?
Maya: We are aiming to finish the surveys by the end of October, which gives us all of November for analysis and writing.
Tutor: Sounds like a very solid timeline. Just make sure you submit your ethics approval form by this Friday. You cannot begin collecting data until the committee signs off on your survey design.
Leo: We have it mostly filled out. We just need your signature as our supervisor.
Tutor: Bring a printed copy to my office hours on Thursday morning, and I''ll sign it then. Excellent work so far, both of you.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('bf4e7fd9-8058-44bd-904c-1be8101e5d69', '8c50510d-b748-4f37-8cef-ab6fec771186', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('f38022b8-2bd7-4961-8a01-13ecb2eeb955', 'bf4e7fd9-8058-44bd-904c-1be8101e5d69', 21,
 'Why did the students decide NOT to use a sample of university students for their survey?',
 '["A. Students are too difficult to locate on campus.", "B. A student sample would create an age and lifestyle bias.", "C. Students do not typically visit urban green spaces."]', 'B'),
('251bb42f-2671-417f-a0ae-745a5fb90915', 'bf4e7fd9-8058-44bd-904c-1be8101e5d69', 22,
 'What area of research did the tutor say was missing from their literature review?',
 '["A. Classic studies on attention restoration", "B. Research published before the pandemic", "C. Recent studies specializing in occupational health"]', 'C'),
('ad6b9a65-896c-413c-a079-d284d82a4441', 'bf4e7fd9-8058-44bd-904c-1be8101e5d69', 23,
 'What incentive are the students offering to boost survey participation?',
 '["A. A free coffee voucher", "B. A small cash payment", "C. University printing credits"]', 'A'),
('a6e28907-3603-4159-8c12-3c773597a81d', 'bf4e7fd9-8058-44bd-904c-1be8101e5d69', 24,
 'Why did the tutor suggest removing five questions from the survey draft?',
 '["A. They were too personal for a public survey.", "B. They focused on commuting rather than the core hypothesis.", "C. They would take more than ten minutes to answer."]', 'B'),
('f8b25738-1b6e-417c-9e7f-24300d72e952', 'bf4e7fd9-8058-44bd-904c-1be8101e5d69', 25,
 'What potential problem did the tutor highlight regarding the LexiStat software?',
 '["A. The university license has expired.", "B. It struggles to accurately analyze sarcasm and local idioms.", "C. It cannot process more than one hundred responses at a time."]', 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('900d2107-d0a0-4fdf-8739-822ed4c2d308', '8c50510d-b748-4f37-8cef-ab6fec771186', 2,
 'matching', 'What characteristic applies to each of the following project elements? Choose FIVE answers from the box and write the correct letter, A-F, next to Questions 26-30.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('5807d0e3-c251-4741-aaab-c014d9195213', '900d2107-d0a0-4fdf-8739-822ed4c2d308', 26,
 'Centennial Park', '["A. Elevated with structural planting", "B. Requires a signature before Friday", "C. Enclosed entirely by high-rise buildings", "D. Largest traditional nature space", "E. Analyzes emotional descriptors", "F. Needs to be completed by October"]', 'D'),
('55c0cab4-4283-490d-b50d-c972786a5f84', '900d2107-d0a0-4fdf-8739-822ed4c2d308', 27,
 'Highline Walkway', '["A. Elevated with structural planting", "B. Requires a signature before Friday", "C. Enclosed entirely by high-rise buildings", "D. Largest traditional nature space", "E. Analyzes emotional descriptors", "F. Needs to be completed by October"]', 'A'),
('1ed00558-766c-419e-a36e-e755a1a42f6c', '900d2107-d0a0-4fdf-8739-822ed4c2d308', 28,
 'Victoria Square Gardens', '["A. Elevated with structural planting", "B. Requires a signature before Friday", "C. Enclosed entirely by high-rise buildings", "D. Largest traditional nature space", "E. Analyzes emotional descriptors", "F. Needs to be completed by October"]', 'C'),
('389e01ae-d9f3-42f3-9c68-42229ada68b2', '900d2107-d0a0-4fdf-8739-822ed4c2d308', 29,
 'LexiStat Software', '["A. Elevated with structural planting", "B. Requires a signature before Friday", "C. Enclosed entirely by high-rise buildings", "D. Largest traditional nature space", "E. Analyzes emotional descriptors", "F. Needs to be completed by October"]', 'E'),
('b93c860e-f256-45d9-9cd2-e03dec617c9b', '900d2107-d0a0-4fdf-8739-822ed4c2d308', 30,
 'Ethics Approval Form', '["A. Elevated with structural planting", "B. Requires a signature before Friday", "C. Enclosed entirely by high-rise buildings", "D. Largest traditional nature space", "E. Analyzes emotional descriptors", "F. Needs to be completed by October"]', 'B');

-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 4: Academic Monologue (Engineering History)     ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('4d0ab6e7-62af-4a20-af87-430881d19e3f', '485887b9-f68a-4749-99c7-4bfee3430957', 4,
 'The Transatlantic Telegraph Cable',
 'Professor: Good morning, everyone. Welcome to the third lecture in our series on pivotal moments in global communications. Today, we are going to look back at the 19th century and discuss a monumental feat of engineering: the first successful transatlantic telegraph cable.

When we send a text message across the world today, we expect an instantaneous reply. But in the 1850s, communication between North America and Europe was entirely dependent on ships. A message sent from London to New York took approximately ten days to arrive, assuming the weather was favorable. This severe delay hampered international trade, diplomacy, and the simple exchange of news. The idea of laying a wire across the ocean floor seemed like science fiction to most, but a man named Cyrus West Field, an American paper merchant with no prior experience in telegraphy, saw the immense financial potential.

Field formed the Atlantic Telegraph Company in 1856. The engineering challenges they faced were unprecedented. First, they had to design a cable that could survive the immense pressure of the deep ocean, resist the corrosive saltwater, and transmit an electrical signal over two thousand miles without it degrading entirely. The core of the cable consisted of seven copper wires, which were chosen for their excellent conductivity. To insulate these wires from the seawater, they used a relatively new substance called gutta-percha. Gutta-percha is a natural latex derived from the sap of trees found in Southeast Asia. It was a crucial material because, unlike rubber, it actually becomes harder and more durable when submerged in cold water. This insulated core was then wrapped in hemp yarn and finally armored with an outer layer of thick iron wires for physical protection against rocks and marine life.

The first attempt to lay the cable took place in 1857. Two ships, one British and one American, started from Ireland and began sailing west. However, the mission was a disaster. The cable snapped just a few hundred miles off the coast, and the end was lost to the ocean floor. They tried again in the spring of 1858, and this time, the ships met in the middle of the Atlantic, spliced the two halves of the cable together, and sailed in opposite directions. Again, the cable broke multiple times, forcing them to abandon the attempt and return to port.

The financial backers were furious, and the public and press began to mock the project as an impossible dream. But Field was remarkably persistent. In July 1858, they made a third attempt. This time, incredibly, the operation was a success. On August 16, 1858, the first official message was sent between Queen Victoria and US President James Buchanan. The public reaction was ecstatic. There were parades, fireworks, and church bells ringing across both continents.

However, the celebration was incredibly short-lived. The signal quality from the very beginning was terribly weak. It took over sixteen hours just to transmit the Queen’s 98-word congratulatory message. To try and speed up the transmission, the company’s chief electrician, a man named Whitehouse, made a fatal error. He believed that applying massive amounts of high voltage to the line would force the signal through faster. Instead, the intense electrical current literally fried the gutta-percha insulation. Just three weeks after it was completed, the cable failed completely and went dead.

The failure was a massive blow, and the American Civil War soon delayed any further attempts for several years. It wasn''t until 1865 that a new expedition was launched. This time, they had significantly improved the cable design, making it twice as heavy and much more resilient. They also utilized a single, massive ship to lay the entire length of the cable—the Great Eastern, which was the largest ship in the world at the time. Although the 1865 cable snapped near the end of the journey, they returned in 1866, successfully laid a brand-new line, and even managed to grapple and repair the lost 1865 cable. Suddenly, there were two functioning cables connecting the continents.

The impact of this continuous connection was profound. Information that previously took weeks to travel now arrived in minutes. It completely revolutionized global financial markets, as stock prices and commodity values could be synchronized between London and New York. It also transformed journalism, allowing newspapers to report on international events the very next day. The transatlantic cable laid the foundational infrastructure for the interconnected, globalized world we live in today. Next week, we will look at how this underwater network expanded into the telephone era.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('60fdd9c1-229c-451d-81c6-4661e943d56e', '4d0ab6e7-62af-4a20-af87-430881d19e3f', 1,
 'note-completion', 'Complete the notes below. Write ONE WORD ONLY for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('e0ee480a-3832-49a6-8588-e299c529f062', '60fdd9c1-229c-451d-81c6-4661e943d56e', 31,
 'In the 1850s, international communication was entirely dependent on ________.', 'ships', '["ships","Ships"]'),
('19e92874-2b9b-4709-81aa-cdc55ee6b819', '60fdd9c1-229c-451d-81c6-4661e943d56e', 32,
 'Cyrus West Field was a successful ________ merchant before investing in telegraphy.', 'paper', '["paper","Paper"]'),
('198777d1-a3b8-49cf-ab71-bbf936af7f77', '60fdd9c1-229c-451d-81c6-4661e943d56e', 33,
 'The cable''s core consisted of seven wires made of ________.', 'copper', '["copper","Copper"]'),
('5c07be35-eb38-4db9-8f26-c3f1aa80def2', '60fdd9c1-229c-451d-81c6-4661e943d56e', 34,
 'A natural latex known as ________ was used because it hardens in cold water.', 'gutta-percha', '["gutta-percha","gutta percha","Gutta-percha"]'),
('4fde45d9-39a6-4607-9471-7fe25ae9ed75', '60fdd9c1-229c-451d-81c6-4661e943d56e', 35,
 'The first official message was exchanged between the US President and Queen ________.', 'Victoria', '["Victoria","victoria"]'),
('cc1083c2-997a-4f64-a423-8e5c4fc205f8', '60fdd9c1-229c-451d-81c6-4661e943d56e', 36,
 'The cable was destroyed after a chief electrician applied massive amounts of high ________.', 'voltage', '["voltage","Voltage"]'),
('68254d0b-2bd8-4d08-b62c-2ec692b064fa', '60fdd9c1-229c-451d-81c6-4661e943d56e', 37,
 'Further cable-laying attempts were delayed by the American Civil ________.', 'War', '["War","war"]'),
('085c7564-36ff-47e5-881d-eaacf0eff648', '60fdd9c1-229c-451d-81c6-4661e943d56e', 38,
 'In 1865, a single ship named the Great ________ was used to lay the cable.', 'Eastern', '["Eastern","eastern"]'),
('53173b41-8e92-4c4d-90b2-54994cff375c', '60fdd9c1-229c-451d-81c6-4661e943d56e', 39,
 'The reliable telegraph connection revolutionized global financial ________.', 'markets', '["markets","Markets"]'),
('a6e989c4-cd13-4c1e-99f8-46fe6dffc27a', '60fdd9c1-229c-451d-81c6-4661e943d56e', 40,
 'Journalism transformed because international events could be reported the next ________.', 'day', '["day","Day"]');
