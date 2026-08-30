-- ============================================================
-- IELTS Practice Platform – Seed Data
-- Target: Listening Module (Band 6 Difficulty)
-- Description: Intermediate listening test featuring standard 
-- paraphrasing, clear everyday and academic contexts, and 
-- moderate distractor complexity suitable for a Band 6 target.
-- ============================================================

-- ████████████████████████████████████████████████████████████
-- ██  LISTENING TEST RECORD                                 ██
-- ████████████████████████████████████████████████████████████

INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status) VALUES
('e0883408-c0b6-4a25-9a6b-d0390a03cfe8', '4c55ecc0-18dc-42f3-bb77-b099169a0574',
 'IELTS General & Academic Listening: Driving School, Library, School Diets & Cocoa History (Band 6)', '6', '40 mins', 'published');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 1: Transactional Dialogue (Booking Lessons)     ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('8046f08b-9a01-4f3b-aa04-5b700cfb789e', 'e0883408-c0b6-4a25-9a6b-d0390a03cfe8', 1,
 'Driving School Booking',
 'Receptionist: Good morning, Safe Start Driving School. How can I help you today?
Caller: Hello there. I’m calling because I’d like to book some driving lessons for my son. He just turned seventeen and got his provisional licence.
Receptionist: That’s wonderful. We have a few different instructors available. Before we get to that, can I take his full name, please?
Caller: Yes, it’s Daniel Faraday. 
Receptionist: Could you spell the surname for me?
Caller: Sure, it’s F-A-R-A-D-A-Y.
Receptionist: Thank you. And what is your home address? We need that because our instructors pick the students up directly from their house.
Caller: We live at 42 Pine Avenue, in the Greenfield area.
Receptionist: 42 Pine Avenue, Greenfield. Got it. Now, has Daniel had any driving experience before? Some parents take their children to empty car parks to practice the basics.
Caller: No, none at all. He is a complete beginner. He’s never even sat in the driver’s seat.
Receptionist: That’s absolutely fine. Our instructors are very used to teaching complete beginners. Now, the next thing we need to decide is the type of car. We offer lessons in both manual and automatic cars. Which one would he prefer?
Caller: I think learning in an automatic is much easier these days, so we’ll go with that. 
Receptionist: Automatic it is. Now, let’s talk about scheduling. When is he available to take his lessons?
Caller: He is still in college during the week, so weekends are best. Usually, Saturday mornings are ideal, perhaps around 10:00 AM?
Receptionist: Let me check the system... I’m afraid our automatic instructor is fully booked on Saturday mornings. We do have a slot available on Saturday afternoon at 3:00 PM, or we have Sunday morning at 9:00 AM. 
Caller: Saturday afternoon at 3:00 PM sounds perfect. He usually plays football on Sundays, so we’ll take the Saturday afternoon slot.
Receptionist: Great. Now, for the pricing. A single hour-long lesson is £30. However, most beginners buy our starter package, which gives you ten lessons for £250. It saves you quite a bit of money.
Caller: Oh, that is a good discount. We’ll definitely take the ten-lesson package for £250. Does that include the cost of the practical driving test at the end?
Receptionist: No, the practical test fee is separate and has to be paid directly to the government testing centre. But our package does include a free textbook to help him study for his theory test.
Caller: A free textbook? That’s very helpful, thank you. What about payment? Do I need to pay for the whole package now over the phone?
Receptionist: You can pay a deposit of £50 now to secure the booking, and then you just pay the balance to the instructor on the first lesson. But you need to make sure you pay the balance in cash, as our instructors don’t carry card machines in their cars.
Caller: I’ll pay the £50 deposit by card now, and I’ll make sure he has the cash for the first lesson. Are there any other rules or things he needs to bring?
Receptionist: The most important thing is that he must have his provisional licence with him on every single lesson. If he forgets it, the instructor cannot legally let him drive, and you will still be charged for the lesson.
Caller: I will make sure he keeps it in his wallet at all times. Also, should he wear any specific shoes? 
Receptionist: Just comfortable, flat shoes. No heavy boots or sandals. Finally, if you ever need to cancel a lesson, you must give us 48 hours’ notice. Otherwise, there is a cancellation fee. 
Caller: 48 hours’ notice, understood. Can I just give you my card details now for the deposit?
Receptionist: Yes, of course, go ahead when you’re ready.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('f887631a-1364-4db7-b7d8-69ae2d894027', '8046f08b-9a01-4f3b-aa04-5b700cfb789e', 1,
 'sentence-completion', 'Complete the booking form below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('8cc3ed17-8037-46a4-ae9a-f3a209dd2cbb', 'f887631a-1364-4db7-b7d8-69ae2d894027', 1,
 'Student Name: Daniel ________', 'Faraday', '["Faraday","faraday","FARADAY"]'),
('d7669e3c-ed51-4e6e-ae7e-9c655baef145', 'f887631a-1364-4db7-b7d8-69ae2d894027', 2,
 'Address: 42 Pine Avenue, ________', 'Greenfield', '["Greenfield","greenfield"]'),
('9d347535-a91a-4000-afb1-8cfd56ad9af8', 'f887631a-1364-4db7-b7d8-69ae2d894027', 3,
 'Previous driving experience: ________', 'none', '["none","None","zero"]'),
('c5876749-319a-401f-b618-4b7c5196582d', 'f887631a-1364-4db7-b7d8-69ae2d894027', 4,
 'Type of car requested: ________', 'automatic', '["automatic","Automatic"]'),
('ad37cd29-0823-47b2-9541-353cf230c341', 'f887631a-1364-4db7-b7d8-69ae2d894027', 5,
 'Agreed day and time: Saturday at ________', '3:00 PM', '["3:00 PM","3 PM","3:00 pm","3pm"]'),
('f1d61bec-d5c9-4443-85de-1783bdecaf99', 'f887631a-1364-4db7-b7d8-69ae2d894027', 6,
 'Cost of the 10-lesson package: £________', '250', '["250","two hundred and fifty"]'),
('ce226fae-51b9-4e68-9d87-1b3c59a96583', 'f887631a-1364-4db7-b7d8-69ae2d894027', 7,
 'The package includes a free ________ for studying.', 'textbook', '["textbook","Textbook","book"]'),
('ba7a0e3a-4091-4249-8723-f08a0f8d2020', 'f887631a-1364-4db7-b7d8-69ae2d894027', 8,
 'The balance must be paid to the instructor in ________.', 'cash', '["cash","Cash"]'),
('4436cadf-c00b-4b1c-a46b-5b8a86cecfd1', 'f887631a-1364-4db7-b7d8-69ae2d894027', 9,
 'The student must bring their provisional ________ to every lesson.', 'licence', '["licence","license","Licence"]'),
('7c1bcd4c-fef1-4fcd-883e-93fd5179a373', 'f887631a-1364-4db7-b7d8-69ae2d894027', 10,
 'A cancellation fee applies if less than ________ notice is given.', '48 hours', '["48 hours","forty-eight hours"]');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 2: Monologue (Facility Tour)                    ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('a3e330f1-00a2-43a6-b57f-a25d85d0d14c', 'e0883408-c0b6-4a25-9a6b-d0390a03cfe8', 2,
 'City Library Refurbishment Tour',
 'Librarian: Good morning, everyone, and welcome to the grand reopening of the Central City Library! I’m Helen, the head librarian. We’ve been closed for six months for a major refurbishment, and I’m so excited to show you all the new facilities we have to offer today.

Before we start the physical tour, I want to go over a few updates regarding our library services. Firstly, our opening hours have changed. We used to close at 5:00 PM on weekdays, but due to high demand from students and people finishing work, we will now remain open until 8:00 PM from Monday to Friday. On weekends, however, the hours remain the same: 9:00 AM to 4:00 PM. 

Also, we have updated our borrowing limits. Previously, members could only borrow a maximum of six books at a time. I’m happy to announce that we have increased this limit. Adult members can now take out up to ten books for a period of three weeks. Please note that DVDs and magazines are still restricted to three items per person. 

We’ve also tried to make the library more environmentally friendly. We no longer use plastic membership cards. Instead, you can download our new library app on your smartphone, which contains a digital barcode you can scan at the checkout machines. For those who don’t use smartphones, we can issue a recycled paper card, but the app is definitely the quickest way to borrow books. 

Now, let’s have a look at the new layout of the building. Please take a copy of the map I’m handing out. We are currently standing at the Main Entrance, which is at the bottom of your map, facing the reception desk. 

If you walk past the reception desk and go straight down the main central corridor, the first area you will see on your left is the Café. It’s a lovely new addition where you can grab a coffee and a sandwich. You are allowed to read library books in the café, but please be careful not to spill anything on them!

Just past the Café, also on the left side of the corridor, is the Children’s Section. We’ve painted the walls bright colours and added plenty of comfortable beanbags. It’s right next to the café, which is very convenient for parents.

Now, if you go back to the reception desk and take the corridor that goes off to the right, you will find our new Computer Lab. It is the first room on your right. We have twenty brand-new desktop computers that are free for members to use. 

If you continue walking past the Computer Lab along that right-hand corridor, it leads directly to the Silent Reading Room at the very end. This is a strictly quiet zone—no talking and no mobile phones are allowed in here. 

Finally, we have two new Meeting Rooms for group study. To find them, walk straight down the central corridor from the reception desk, go all the way to the end of the building, and the Meeting Rooms are directly in front of you. You need to book these rooms online at least a day in advance, as they are very popular with university students.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('f9985f96-7d1b-424a-a1b3-d64dcff3da16', 'a3e330f1-00a2-43a6-b57f-a25d85d0d14c', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('89715353-9308-44c4-a02f-38096d67c17f', 'f9985f96-7d1b-424a-a1b3-d64dcff3da16', 11,
 'What time does the library now close on weekdays?',
 '["A. 4:00 PM", "B. 5:00 PM", "C. 8:00 PM"]', 'C'),
('5edce504-62bc-4a68-ba05-8697f293748f', 'f9985f96-7d1b-424a-a1b3-d64dcff3da16', 12,
 'How many books can adult members now borrow at one time?',
 '["A. Three", "B. Six", "C. Ten"]', 'C'),
('7770d877-2e4f-496d-886f-817ce1fedbfd', 'f9985f96-7d1b-424a-a1b3-d64dcff3da16', 13,
 'What is the restriction on borrowing DVDs?',
 '["A. A maximum of three items", "B. They can only be borrowed for one week", "C. Only adults can borrow them"]', 'A'),
('127d2558-128d-4b71-a6bc-7f5d20f78ca8', 'f9985f96-7d1b-424a-a1b3-d64dcff3da16', 14,
 'How has the library made its membership cards more environmentally friendly?',
 '["A. They are made from recycled plastic", "B. Members can use a digital app instead", "C. The cards are now sent by email"]', 'B'),
('5f5d22de-24ec-4da2-a15c-4fb4b53fd2c6', 'f9985f96-7d1b-424a-a1b3-d64dcff3da16', 15,
 'What must you do to use the Meeting Rooms?',
 '["A. Pay a small fee at the reception desk", "B. Show your digital membership barcode", "C. Book them online in advance"]', 'C');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('d80ca053-18b5-4db1-bc28-69ad3480122b', 'a3e330f1-00a2-43a6-b57f-a25d85d0d14c', 2,
 'multiple-choice', 'Look at the map of the library. Match the rooms (16-20) to the correct location (A-G).', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('72928101-0525-4f51-91ee-a026d96750be', 'd80ca053-18b5-4db1-bc28-69ad3480122b', 16,
 'Café', '["A", "B", "C", "D", "E", "F", "G"]', 'A'),
('5063f881-eca5-4b3e-a0c2-1b35be690156', 'd80ca053-18b5-4db1-bc28-69ad3480122b', 17,
 'Children’s Section', '["A", "B", "C", "D", "E", "F", "G"]', 'B'),
('23a24ad5-3130-402a-b5b9-a71c3de7e8e8', 'd80ca053-18b5-4db1-bc28-69ad3480122b', 18,
 'Computer Lab', '["A", "B", "C", "D", "E", "F", "G"]', 'D'),
('04ef55c6-74c2-4ea5-9d1e-5b7fdc7024a2', 'd80ca053-18b5-4db1-bc28-69ad3480122b', 19,
 'Silent Reading Room', '["A", "B", "C", "D", "E", "F", "G"]', 'E'),
('ecae42f1-69a4-463f-af7b-468a9332624b', 'd80ca053-18b5-4db1-bc28-69ad3480122b', 20,
 'Meeting Rooms', '["A", "B", "C", "D", "E", "F", "G"]', 'C');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 3: Academic Dialogue (Group Project)            ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('81684cce-625e-480b-8f1e-a698f1a87d38', 'e0883408-c0b6-4a25-9a6b-d0390a03cfe8', 3,
 'Healthy Eating in Schools Project',
 'Mark: Hi Sarah, thanks for meeting me in the library. We really need to finalize the structure for our presentation on healthy eating in schools.
Sarah: Hi Mark, no problem. I’ve been looking through all the data we collected from the local primary schools, and honestly, the results are quite interesting. I thought the biggest problem was going to be the vending machines selling chocolate and crisps.
Mark: Me too! But our survey showed that almost all the schools have already removed them. For me, the most surprising thing was how many children skip breakfast entirely before coming to school. It was nearly 30% of the students we surveyed. 
Sarah: Exactly. It makes it very hard for them to concentrate in morning classes. I think we should make that the main focus of our introduction.
Mark: Good idea. Now, our tutor said we need to discuss the main challenge schools face when trying to improve school lunches. What did the school catering managers say?
Sarah: The general assumption is that children simply refuse to eat vegetables. But when I interviewed the catering managers, they said the main challenge was actually the budget. They only have about £1.50 per child per day to spend on ingredients. It’s almost impossible to provide fresh, high-quality meals on that budget. 
Mark: That is definitely a critical point. We should include a slide showing the cost breakdown. Next, we need to compare two specific schools that have tried different approaches. We chose Oakwood Academy and Riverdale Primary, right?
Sarah: Yes. Oakwood Academy tried a completely new approach. Instead of just changing the menu, they started a school garden. The students actually grow their own vegetables and then the kitchen cooks them. 
Mark: And what was the result? 
Sarah: It worked brilliantly! The teachers reported that the children are much more willing to try healthy food if they have grown it themselves. It completely changed their attitude towards vegetables.
Mark: That’s a great success story. But Riverdale Primary had a different strategy. They decided to ban all packed lunches brought from home. They argued that parents were packing too many sugary snacks and unhealthy sandwiches. 
Sarah: Did it improve the students’ diets?
Mark: Well, yes and no. The meals provided by the school were definitely healthier, but a lot of parents complained about the lack of choice. Some parents even threatened to move their children to a different school. So, it was very controversial.
Sarah: Okay, so we have one positive case study and one controversial one. That gives us a really good balance for the presentation. Now, let’s divide up the remaining tasks before Friday. Who is going to write the final conclusion?
Mark: I don’t mind doing that. I’ve got some good ideas for summarizing the main points. 
Sarah: Okay, Mark, you write the conclusion. What about creating the slides? We need to make them look professional.
Mark: I’m not very good with design software. Would you mind doing the slides?
Sarah: Sure, I enjoy doing that. I’ll make sure the layout is clear and easy to read. But we also need to create a handout for the class with our main references on it.
Mark: Why don’t we do the handout together? We both need to make sure all the books and articles we read are formatted correctly. 
Sarah: That’s fair. We’ll meet on Thursday afternoon to finish the handout together. What about practicing the presentation? 
Mark: We should definitely practice it out loud to check our timing. The tutor is very strict about not going over the ten-minute limit.
Sarah: Let’s practice it together on Thursday after we finish the handout. Finally, one of us needs to email the completed slides to the tutor before Friday morning. 
Mark: I’ll do that. I’ll send it off on Thursday evening once you’ve finished the design. 
Sarah: Perfect. I think we have a solid plan!');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('dcb5a256-0255-433c-9768-4c963290127d', '81684cce-625e-480b-8f1e-a698f1a87d38', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('6a0c87cf-68fa-427d-9fbf-86e10db69451', 'dcb5a256-0255-433c-9768-4c963290127d', 21,
 'What surprised the students most about their survey results?',
 '["A. The high number of vending machines in schools", "B. The amount of sugar in school meals", "C. The large percentage of children who skip breakfast"]', 'C'),
('9279d316-7448-46cc-8125-221ea72540fb', 'dcb5a256-0255-433c-9768-4c963290127d', 22,
 'According to catering managers, what is the main challenge in providing healthy school lunches?',
 '["A. Children refusing to eat vegetables", "B. A very restricted financial budget", "C. A lack of trained cooking staff"]', 'B'),
('734383d9-79a5-47b4-9d4d-c719646c19cc', 'dcb5a256-0255-433c-9768-4c963290127d', 23,
 'What was the successful strategy used by Oakwood Academy?',
 '["A. Creating a school garden for students", "B. Offering rewards for eating healthy food", "C. Changing the lunch menu every week"]', 'A'),
('d9d405c4-9df7-4a0d-8c2e-78c235a6ae71', 'dcb5a256-0255-433c-9768-4c963290127d', 24,
 'What policy did Riverdale Primary introduce?',
 '["A. Banning vending machines", "B. Banning packed lunches brought from home", "C. Forcing parents to pay more for meals"]', 'B'),
('e2bbdb3b-86cb-45a2-9826-c6eac53be781', 'dcb5a256-0255-433c-9768-4c963290127d', 25,
 'Why did parents complain about Riverdale Primary’s new policy?',
 '["A. The school meals were too expensive", "B. There was a lack of choice for their children", "C. The food did not taste very good"]', 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('502d7bb2-98ee-4873-90c0-ade854603087', '81684cce-625e-480b-8f1e-a698f1a87d38', 2,
 'multiple-choice', 'Who will complete the following tasks? Match the tasks (26-30) to the person (A, B, or C).', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('be7f69f2-2777-4ee2-ba02-4dc6f2fd3b3d', '502d7bb2-98ee-4873-90c0-ade854603087', 26,
 'Write the conclusion', '["A. Mark", "B. Sarah", "C. Both Mark and Sarah"]', 'A'),
('032426dd-279e-4d39-94d9-7ad644e064f1', '502d7bb2-98ee-4873-90c0-ade854603087', 27,
 'Create the slides', '["A. Mark", "B. Sarah", "C. Both Mark and Sarah"]', 'B'),
('6fbb7b7e-0b22-40c6-b6bd-7a3568a37660', '502d7bb2-98ee-4873-90c0-ade854603087', 28,
 'Make the handout', '["A. Mark", "B. Sarah", "C. Both Mark and Sarah"]', 'C'),
('e29e2bf4-50dd-4973-93be-6a92de7df53c', '502d7bb2-98ee-4873-90c0-ade854603087', 29,
 'Practice the timing of the presentation', '["A. Mark", "B. Sarah", "C. Both Mark and Sarah"]', 'C'),
('25ae89f8-f4d0-40ce-9938-c3ce538d8166', '502d7bb2-98ee-4873-90c0-ade854603087', 30,
 'Email the slides to the tutor', '["A. Mark", "B. Sarah", "C. Both Mark and Sarah"]', 'A');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 4: Academic Monologue (History Lecture)         ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('1b8e6382-8954-44cb-9b3b-a253310ec30d', 'e0883408-c0b6-4a25-9a6b-d0390a03cfe8', 4,
 'Lecture: The History of Chocolate',
 'Professor: Good morning, everyone. Today, we are going to explore the history of a food that almost everyone loves: chocolate. But as you will see, chocolate hasn’t always been the sweet, solid candy bar that we know today. Its history spans thousands of years and crosses multiple continents.

The story of chocolate begins in Mesoamerica, which is modern-day Mexico and Central America. The ancient Mayan and Aztec civilizations were the first to discover the secrets of the cacao tree. However, they did not eat chocolate; they drank it. They took the cacao beans, roasted them, and ground them into a paste. They mixed this paste with water, cornmeal, and chili peppers to create a bitter, spicy drink. It was highly valued and was often consumed during religious ceremonies. In fact, cacao beans were considered so valuable that the Aztecs actually used them as a form of currency, just like coins. 

Chocolate remained a regional secret until the early 1500s when Spanish explorers arrived in the Americas. When they returned to Europe, they brought the cacao beans with them. At first, the bitter drink was not very popular in Spain. But then, someone had the brilliant idea of removing the chili peppers and adding sugar and vanilla instead. This new, sweet version of the drink became a massive hit. It quickly became a status symbol, enjoyed exclusively by royalty and the very wealthy across Europe because sugar was incredibly expensive at the time. 

For hundreds of years, chocolate remained a drink for the rich. The major turning point came in the 19th century during the Industrial Revolution. In 1828, a Dutch chemist named Coenraad Johannes van Houten invented a machine called a cocoa press. This machine could squeeze the fatty cocoa butter out of the roasted beans, leaving behind a fine powder. We now know this as cocoa powder. This powder could be easily mixed with milk or water, making chocolate much cheaper to produce and easier to consume. 

But the biggest breakthrough happened in 1847 in England. A company named J.S. Fry & Sons discovered a way to mix cocoa powder, sugar, and melted cocoa butter together to create a paste that could be poured into a mould. When it cooled, it became the world’s first solid chocolate bar. Shortly after that, in 1875, a Swiss chocolatier named Daniel Peter had the idea of adding powdered milk to the mixture, creating the very first milk chocolate, which was smoother and sweeter than anything made before. 

The invention of the solid chocolate bar transformed the industry. Chocolate was no longer just a luxury drink for the rich; it was a cheap, portable snack that ordinary working people could afford. Factories were built across Europe and North America, producing millions of chocolate bars. 

Today, chocolate is a multi-billion dollar global industry. However, it still relies on the same basic ingredient: the cacao bean. Growing cacao is very difficult. The trees only grow in a narrow band around the equator, in places like West Africa and South America. They require a hot, humid climate and are very sensitive to changes in weather. 

Furthermore, the modern chocolate industry faces significant ethical challenges. A large percentage of the world’s cocoa is grown on small family farms in West Africa. Unfortunately, many of these farmers live in poverty. Because the global price of cocoa fluctuates wildly, farmers often struggle to make a living. This has led to serious issues with unfair labour practices, and in some areas, the use of child labour to harvest the beans. 

In recent years, there has been a growing movement towards "Fair Trade" chocolate. This certification ensures that farmers are paid a guaranteed minimum price for their cocoa beans, protecting them from market crashes. It also requires strict environmental standards and completely bans child labour. So, the next time you buy a chocolate bar, it is worth looking for the Fair Trade logo on the wrapper.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('dbea11b3-3fa0-4bcd-8ab1-24dba648ae95', '1b8e6382-8954-44cb-9b3b-a253310ec30d', 1,
 'sentence-completion', 'Complete the notes below. Write NO MORE THAN ONE WORD for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('bd281399-8a0d-48da-af4f-656d80a3900d', 'dbea11b3-3fa0-4bcd-8ab1-24dba648ae95', 31,
 'The ancient Mayans and Aztecs consumed chocolate as a spicy ________.', 'drink', '["drink","Drink"]'),
('47669e6a-73d7-4e60-92d6-2bdb2986980c', 'dbea11b3-3fa0-4bcd-8ab1-24dba648ae95', 32,
 'Cacao beans were so valuable that they were used as ________.', 'currency', '["currency","Currency","coins"]'),
('9ca874ae-6cd8-443f-bf8e-2d3ee400092b', 'dbea11b3-3fa0-4bcd-8ab1-24dba648ae95', 33,
 'In Europe, chocolate became popular after ________ was added to it.', 'sugar', '["sugar","Sugar"]'),
('3abf8ee7-143a-46c6-b5f6-d1c156c14c14', 'dbea11b3-3fa0-4bcd-8ab1-24dba648ae95', 34,
 'In 1828, the invention of a special ________ made chocolate cheaper to produce.', 'machine', '["machine","press","Machine"]'),
('2704960d-44eb-44cd-a1c4-27c1986c8653', 'dbea11b3-3fa0-4bcd-8ab1-24dba648ae95', 35,
 'The first solid chocolate bar was created in ________ in 1847.', 'England', '["England","england"]'),
('9ffbc0f9-e78e-4457-8bf9-bac75f646797', 'dbea11b3-3fa0-4bcd-8ab1-24dba648ae95', 36,
 'Milk chocolate was invented by a ________ chocolatier named Daniel Peter.', 'Swiss', '["Swiss","swiss"]'),
('f928508e-dc37-42db-b387-1e9cedcee4c3', 'dbea11b3-3fa0-4bcd-8ab1-24dba648ae95', 37,
 'Cacao trees only grow in a hot, humid ________ near the equator.', 'climate', '["climate","Climate"]'),
('ecee5c92-a952-4d5f-83b5-6a8a8e7084c5', 'dbea11b3-3fa0-4bcd-8ab1-24dba648ae95', 38,
 'Many cocoa farmers struggle financially because the global ________ changes often.', 'price', '["price","Price"]'),
('d3f62a7b-57c5-4d94-b20c-702e65ef0c4d', 'dbea11b3-3fa0-4bcd-8ab1-24dba648ae95', 39,
 'Some areas have serious issues with the use of ________ labour on farms.', 'child', '["child","Child"]'),
('4819f2b2-21ff-4d94-88ba-020bd43d84d5', 'dbea11b3-3fa0-4bcd-8ab1-24dba648ae95', 40,
 '"Fair Trade" certification guarantees farmers a minimum price and bans ________ practices.', 'unfair', '["unfair","child"]');
