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
('4bb75c40-5aae-420d-9853-0a4834d679c5', '87cb2f31-5991-48d1-98ca-4b23bedffb40',
 'IELTS General & Academic Listening: City Tours, Sports Center, Retail Project & Urban Wildlife (Band 6)', '6', '40 mins', 'published');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 1: Transactional Dialogue (Tour Booking)        ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('a54866df-2afa-4f5b-a0eb-d43cd3945c4b', '4bb75c40-5aae-420d-9853-0a4834d679c5', 1,
 'City Walking Tour Booking',
 'Agent: Good morning, City Walks Tourist Office. How can I help you today?
Customer: Hello. I’m looking to book a guided walking tour of the city for myself and my family. We are visiting for a few days and want to see the main sights.
Agent: Wonderful. We offer a few different tours. There is the Historic City Centre tour, the Ghost Tour in the evening, and our very popular Riverside tour, which focuses on the bridges and the old docks.
Customer: The ghost tour sounds fun, but we have young children, so it might be a bit scary for them. I think the Riverside tour would be the best option for us. 
Agent: Excellent choice. The Riverside tour is very scenic. What date were you hoping to take the tour?
Customer: We’d like to go this coming Saturday. Let me just check my calendar... that’s the 14th of August.
Agent: Let me check availability for the 14th. Yes, we have plenty of spaces left. How many people will be in your group?
Customer: There will be four of us in total. Two adults and two children. 
Agent: Okay. The standard price for an adult is £15, and for children under twelve, it is £10. Are your children under twelve?
Customer: Actually, my son is ten, but my daughter is fifteen. 
Agent: Ah, in that case, your daughter doesn’t qualify for the child ticket. However, if she is in full-time education, she can get a student ticket, which is £12. 
Customer: Yes, she is in high school, so she has her student card. We will take one student ticket, one child ticket, and two adult tickets then.
Agent: Perfect. Now, the tour starts at 10:00 AM from the main square. But please make sure you don’t go to the old meeting point near the town hall. We have recently changed our starting location to the statue in front of the castle. 
Customer: The statue in front of the castle. I know exactly where that is. How long does the tour usually take?
Agent: It usually takes about an hour and fifteen minutes. So, you can expect to finish by 11:15. 
Customer: 11:15. That’s perfect. It gives us plenty of time before lunch. Are there any specific things we should bring?
Agent: The most important thing is to wear comfortable shoes. We will be walking over some old cobblestone streets, and they can be quite uneven. 
Customer: Comfortable shoes, absolutely. We’ve brought our walking boots. 
Agent: Great. Also, looking at the weather forecast for Saturday, there is a strong chance of rain in the morning. I highly recommend you bring umbrellas or waterproof jackets.
Customer: Good to know. We’ll definitely pack our raincoats. Oh, one more thing. Does the tour finish near any good restaurants? 
Agent: Yes, the tour concludes near the harbour. There are many fantastic seafood restaurants there, so it’s the perfect spot to stop and have lunch. 
Customer: Wonderful, we will plan to have lunch there. Now, how do I go about paying for the tickets?
Agent: I can make the reservation for you now. I just need a contact number for the booking.
Customer: Sure, my mobile number is 07745 322 199.
Agent: 07745 322 199. Thank you. And for the payment, you don’t need to pay in advance. You can pay the tour guide directly on the day. However, they do not carry a card reader, so you must bring cash. 
Customer: We have to pay in cash. Okay, I will make sure we go to an ATM before we meet the guide. 
Agent: That’s everything booked for you. Enjoy your tour on Saturday!
Customer: Thank you very much for your help.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('4af8b564-b32f-4a8c-9d12-984fc60492a7', 'a54866df-2afa-4f5b-a0eb-d43cd3945c4b', 1,
 'sentence-completion', 'Complete the booking form below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('be3dda8c-bcfb-48b2-b562-c59788516a02', '4af8b564-b32f-4a8c-9d12-984fc60492a7', 1,
 'Chosen tour: The ________ tour', 'Riverside', '["Riverside","riverside"]'),
('919bd60c-2430-4e1a-8e14-c63093ab51ff', '4af8b564-b32f-4a8c-9d12-984fc60492a7', 2,
 'Date of the tour: ________ August', '14th', '["14th","14"]'),
('5866b523-2500-473d-97f9-73357fa910fa', '4af8b564-b32f-4a8c-9d12-984fc60492a7', 3,
 'The 15-year-old daughter will use a ________ ticket.', 'student', '["student","Student"]'),
('6f647a8e-882b-4e21-b224-eae48b149a5a', '4af8b564-b32f-4a8c-9d12-984fc60492a7', 4,
 'Meeting point: At the statue in front of the ________.', 'castle', '["castle","Castle"]'),
('3a513020-7132-4c28-a7be-9f9c6f40ccd1', '4af8b564-b32f-4a8c-9d12-984fc60492a7', 5,
 'The tour is expected to finish at ________.', '11.15', '["11.15","11:15","11.15 am"]'),
('7d124796-83a2-47e6-a423-b79db9269e2f', '4af8b564-b32f-4a8c-9d12-984fc60492a7', 6,
 'Visitors are advised to wear ________ shoes.', 'comfortable', '["comfortable","Comfortable"]'),
('78375cd2-daf2-4908-a275-f66de630af59', '4af8b564-b32f-4a8c-9d12-984fc60492a7', 7,
 'Because of the weather forecast, they should prepare for ________.', 'rain', '["rain","Rain"]'),
('a8c2e09e-3f5b-440b-aa0b-e3bf37cacdec', '4af8b564-b32f-4a8c-9d12-984fc60492a7', 8,
 'The end of the tour is a good place to have ________.', 'lunch', '["lunch","Lunch"]'),
('8b04ac93-cc48-426c-8cfd-bb45c28d9d9a', '4af8b564-b32f-4a8c-9d12-984fc60492a7', 9,
 'Customer''s contact number: ________', '07745 322 199', '["07745 322 199","07745322199"]'),
('09394624-0c28-4f5a-9510-a9355d609a60', '4af8b564-b32f-4a8c-9d12-984fc60492a7', 10,
 'Payment must be made in ________ to the guide.', 'cash', '["cash","Cash"]');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 2: Monologue (Facility Tour)                    ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('a61e9f6b-6aa7-4c6c-b240-367fee36a1eb', '4bb75c40-5aae-420d-9853-0a4834d679c5', 2,
 'Community Sports Center Orientation',
 'Manager: Hello, everyone, and welcome to the grand opening of the new Westend Community Sports Center! My name is David, and I’m the facility manager. We are so excited to finally open our doors to the public after nearly two years of construction.

Before we walk around, I want to talk a little about our membership options. We know that affordability is important to the local community. So, while we do offer standard monthly memberships, we have decided to introduce a new "pay-as-you-go" system. This means you don’t have to sign a long contract; you just pay a small fee each time you visit. We think this will be very popular.

Another big focus for us is our class schedule. Many sports centers only offer fitness classes in the evenings. However, after surveying local residents, we realized there is a huge demand from parents and retired people for daytime activities. Therefore, we will be running the majority of our yoga and pilates classes in the mornings, right after school drop-off times. 

We also have a fantastic swimming pool. It’s an Olympic-sized pool, and it is open every day. However, please be aware that on Tuesday and Thursday evenings from 6:00 PM to 8:00 PM, the pool is closed to the public because it is reserved for the local competitive swimming club’s training sessions. At all other times, it is fully available for everyone.

Now, let’s get you oriented with the layout of the building. Please look at the maps I handed out. We are currently standing at the Main Entrance, at the bottom of the map. 

If you walk straight ahead from the entrance, down the main corridor, the first room you will see on your left is the Café. It’s a great place to relax after a workout, and they serve healthy snacks and smoothies.

Just past the Café, also on the left-hand side of the corridor, is the Dance Studio. This room has large mirrors on the walls and a special wooden floor, making it perfect for our aerobics and zumba classes. 

Now, if you go back to the Main Entrance and take the corridor that goes off to the right, you’ll find the changing rooms. The very first door on your right is the Men’s Changing Room. Immediately next to it, the second door on the right, is the Women’s Changing Room. Both have secure lockers that require a one-pound coin to use. 

If you continue all the way to the very end of that right-hand corridor, it leads directly into the main Sports Hall. This is a massive space where we host basketball, badminton, and indoor football matches. 

Finally, we have our fully equipped Gym. To get to the Gym, walk straight down the main central corridor from the entrance, go all the way to the end, and it is the large room directly facing you. It has all the latest running machines and free weights. Please remember to bring a towel when you use this room.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('b9fb71cc-038d-4e69-8d24-3fbdb30449c9', 'a61e9f6b-6aa7-4c6c-b240-367fee36a1eb', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('2079756e-4f66-445a-a3a4-0281724f9d33', 'b9fb71cc-038d-4e69-8d24-3fbdb30449c9', 11,
 'What new payment option has the sports center introduced?',
 '["A. An annual discount", "B. A pay-as-you-go system", "C. A family membership package"]', 'B'),
('76aa169e-c979-4a9e-a8f1-13c4c489a94e', 'b9fb71cc-038d-4e69-8d24-3fbdb30449c9', 12,
 'When will the majority of the yoga and pilates classes take place?',
 '["A. In the mornings", "B. In the afternoons", "C. In the evenings"]', 'A'),
('328fd79c-1362-410b-84e1-602a03170dde', 'b9fb71cc-038d-4e69-8d24-3fbdb30449c9', 13,
 'Why did they choose to schedule classes at this time?',
 '["A. Because the teachers requested it", "B. Because they surveyed local residents", "C. Because the rooms are cheaper to heat"]', 'B'),
('2cd66d63-e652-4f6a-8efa-1afa3d632b73', 'b9fb71cc-038d-4e69-8d24-3fbdb30449c9', 14,
 'When is the swimming pool closed to the public?',
 '["A. Tuesday and Thursday mornings", "B. Monday and Wednesday evenings", "C. Tuesday and Thursday evenings"]', 'C'),
('70230884-6ac0-4c25-b366-c96553453a09', 'b9fb71cc-038d-4e69-8d24-3fbdb30449c9', 15,
 'What do you need in order to use the lockers?',
 '["A. A padlock", "B. A one-pound coin", "C. A membership card"]', 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('71ae13f7-f486-4305-a93d-af053d66213e', 'a61e9f6b-6aa7-4c6c-b240-367fee36a1eb', 2,
 'multiple-choice', 'Look at the map of the sports center. Match the rooms (16-20) to the correct location (A-G).', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('ca706881-ad31-44e4-9020-4215c071b126', '71ae13f7-f486-4305-a93d-af053d66213e', 16,
 'Café', '["A", "B", "C", "D", "E", "F", "G"]', 'A'),
('55d758c5-d5c8-4478-ad42-cb2cbcced9e0', '71ae13f7-f486-4305-a93d-af053d66213e', 17,
 'Dance Studio', '["A", "B", "C", "D", "E", "F", "G"]', 'C'),
('a37b9572-3696-439f-b7a0-42814a4cb7f6', '71ae13f7-f486-4305-a93d-af053d66213e', 18,
 'Women’s Changing Room', '["A", "B", "C", "D", "E", "F", "G"]', 'E'),
('8f32f426-76eb-4a4a-942f-28fa45752ec4', '71ae13f7-f486-4305-a93d-af053d66213e', 19,
 'Sports Hall', '["A", "B", "C", "D", "E", "F", "G"]', 'G'),
('c9488d85-7b39-4dd4-9b22-b553f190c865', '71ae13f7-f486-4305-a93d-af053d66213e', 20,
 'Gym', '["A", "B", "C", "D", "E", "F", "G"]', 'F');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 3: Academic Dialogue (Business Project)         ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('ee6f0027-94ab-4b48-9535-884af1df24f0', '4bb75c40-5aae-420d-9853-0a4834d679c5', 3,
 'Local Retail Business Assignment',
 'Tutor: Come in. It’s Mark and Sarah, isn’t it? Have a seat. Let’s talk about your business studies project. You’ve chosen to look at the challenges facing local retail businesses, correct?
Sarah: Yes, that’s right. We want to understand why so many small, independent shops on the high street are closing down. We initially thought it was just because of large supermarkets, but our research shows it’s more complicated than that.
Mark: Exactly. The biggest factor we found in our surveys isn’t actually the supermarkets. It is the rapid growth of online shopping. People simply find it more convenient to order things from their phones and have them delivered the next day.
Tutor: I agree, online shopping is a massive factor. Did you look into the financial side of running a physical shop?
Sarah: We did. Rent for commercial properties in the city centre has increased by 15% in the last two years alone. But the shop owners we interviewed said their main financial struggle was actually paying the local council taxes, which are very high for businesses regardless of how much profit they make.
Tutor: That’s a very good point to include in your report. It shows you’ve done primary research. So, how are you planning to structure your final presentation? 
Mark: Well, we’ve finished writing the introduction and the methodology. The next thing we need to do is create some graphs to display our survey data clearly. After that, we will write our conclusion.
Tutor: Making graphs is a great next step. Visuals always help in a business presentation. Now, let’s review the specific types of businesses you researched. You looked at a few different shops. What did you find out about the local bakery?
Sarah: The bakery is actually doing very well. They realized they couldn’t compete with supermarket prices, so they changed their strategy. They started offering specialized products, like gluten-free bread and custom birthday cakes, which you can’t easily get in a supermarket. 
Tutor: Very clever. That’s a great example of finding a niche market. And what about the independent bookshop?
Mark: The bookshop was struggling, but they survived by hosting events. They regularly invite authors for book signings and have weekly reading groups for children. It turns the shop into a community hub rather than just a place to buy things.
Tutor: Excellent. Customer experience is vital. Did you look at the clothing boutique?
Sarah: Yes, the clothing boutique had a different approach. To combat online shopping, they heavily improved their customer service. They offer free personal styling sessions and alterations, which gives people a reason to visit the physical store to get expert advice.
Tutor: That’s a great strategy. What did you find out about the hardware store?
Mark: The hardware store is unfortunately closing down next month. They simply couldn’t compete with the massive out-of-town DIY warehouses that have huge car parks. People buying heavy tools or wood need to park close by, and the city centre doesn’t allow that.
Tutor: A very practical problem. Finally, what did you observe about the local florist?
Sarah: The florist is surviving by partnering with other businesses. They provide fresh flowers weekly to the local hotels and restaurants. This guarantees them a steady, reliable income, rather than just waiting for individual customers to walk in off the street.
Tutor: Fantastic. You have some really strong examples here. If you organize these case studies clearly in your presentation, you will definitely get a high grade.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('65b471b4-219f-4563-a923-b181bc113445', 'ee6f0027-94ab-4b48-9535-884af1df24f0', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('c39fbee0-25df-4a8e-845e-14af6e8928af', '65b471b4-219f-4563-a923-b181bc113445', 21,
 'What did Mark say is the biggest factor affecting local shops?',
 '["A. High parking fees", "B. Large supermarkets", "C. The growth of online shopping"]', 'C'),
('7c99ef4f-9025-4a71-a503-e76b67430bba', '65b471b4-219f-4563-a923-b181bc113445', 22,
 'According to shop owners, what is their main financial struggle?',
 '["A. Increasing rent prices", "B. High local council taxes", "C. The cost of electricity"]', 'B'),
('e9b84de4-54c8-485d-8c16-d363557701ea', '65b471b4-219f-4563-a923-b181bc113445', 23,
 'What is the students’ next step in their project?',
 '["A. Writing the conclusion", "B. Creating graphs", "C. Interviewing more shop owners"]', 'B'),
('3776bb72-4186-47bd-a9bb-c4f3b34808c3', '65b471b4-219f-4563-a923-b181bc113445', 24,
 'Why did the tutor praise the students?',
 '["A. Because they used advanced mathematics", "B. Because they finished the project early", "C. Because they did their own primary research"]', 'C'),
('26c87cbf-e991-4ad8-aa7c-be90f2ca1cc4', '65b471b4-219f-4563-a923-b181bc113445', 25,
 'The tutor believes that to get a high grade, they must:',
 '["A. Organize their examples clearly", "B. Speak slowly and confidently", "C. Use more business vocabulary"]', 'A');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('d4250f80-91dc-4be1-917e-131cfda40f12', 'ee6f0027-94ab-4b48-9535-884af1df24f0', 2,
 'multiple-choice', 'What strategy is each of the following businesses using to survive? Match the businesses (26-30) to the correct strategy (A-F).', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('00ba7a66-3aa0-4541-b54e-01b78d8abe3a', 'd4250f80-91dc-4be1-917e-131cfda40f12', 26,
 'The Bakery', '["A. Hosting community events", "B. Providing expert customer service", "C. Moving to a location with better parking", "D. Offering specialized products", "E. Selling their business to a larger chain", "F. Partnering with other local businesses"]', 'D'),
('70e3ef5e-ac1b-458d-8040-e02aba3101d7', 'd4250f80-91dc-4be1-917e-131cfda40f12', 27,
 'The Bookshop', '["A. Hosting community events", "B. Providing expert customer service", "C. Moving to a location with better parking", "D. Offering specialized products", "E. Selling their business to a larger chain", "F. Partnering with other local businesses"]', 'A'),
('db7229df-8f93-4064-ad32-256f27621c29', 'd4250f80-91dc-4be1-917e-131cfda40f12', 28,
 'The Clothing Boutique', '["A. Hosting community events", "B. Providing expert customer service", "C. Moving to a location with better parking", "D. Offering specialized products", "E. Selling their business to a larger chain", "F. Partnering with other local businesses"]', 'B'),
('247eabf5-fc70-4e23-990e-8513755ea2f7', 'd4250f80-91dc-4be1-917e-131cfda40f12', 29,
 'The Hardware Store', '["A. Hosting community events", "B. Providing expert customer service", "C. Moving to a location with better parking", "D. Offering specialized products", "E. Closing down due to lack of parking", "F. Partnering with other local businesses"]', 'E'),
('23fe1055-247d-475e-a860-152728295271', 'd4250f80-91dc-4be1-917e-131cfda40f12', 30,
 'The Florist', '["A. Hosting community events", "B. Providing expert customer service", "C. Moving to a location with better parking", "D. Offering specialized products", "E. Closing down due to lack of parking", "F. Partnering with other local businesses"]', 'F');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 4: Academic Monologue (Urban Wildlife)          ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('9c57a731-408a-4c66-bc64-dad8bdc3195a', '4bb75c40-5aae-420d-9853-0a4834d679c5', 4,
 'Lecture: The Adaptation of Urban Foxes',
 'Professor: Good morning, class. Today, in our module on animal behaviour, we are going to look at urban wildlife. Specifically, we will focus on one of the most successful urban mammals in the world: the red fox. 

Originally, foxes lived entirely in forests and rural areas. However, starting in the 1930s, cities began to expand rapidly, destroying the foxes'' natural habitats. But instead of dying out or moving away, many foxes adapted to life in the city. The primary reason they stayed was the abundance of food. Cities provide a constant, year-round supply of easy meals, meaning foxes no longer had to hunt difficult prey in the wild.

Adapting to the city required significant behavioural changes. In the countryside, foxes are often active during the day. However, in the city, the high levels of human activity and traffic noise forced them to become strictly nocturnal. They sleep during the day, hidden away under sheds or in bushes, and only come out at night when the streets are quiet. 

Interestingly, there are also physical differences between urban foxes and their rural cousins. Studies have shown that urban foxes are generally smaller in size. This is likely because they don’t need as much muscle mass to chase down fast prey. Additionally, their snouts have become slightly shorter over generations, adapting to a diet that consists more of scavenged human food rather than hunting live animals. 

This change in diet has had both positive and negative effects. Because food is so plentiful, urban foxes often live in higher densities than rural foxes. However, eating processed human food means they are more susceptible to disease. Dental problems are particularly common because of the high sugar content in discarded human snacks.

So, where do these urban foxes live? They are incredibly adaptable when it comes to finding a home. While they occasionally dig dens in parks or cemeteries, the vast majority of urban foxes actually make their homes in residential gardens. They prefer areas with overgrown bushes or raised wooden decking, as these provide safe, dry places to raise their cubs away from the rain. 

Their relationship with humans is complicated. Some people enjoy seeing foxes and actively feed them. However, for many others, they are considered a nuisance. A common complaint is that foxes dig up flowerbeds or leave a strong smell. There is also a widespread fear that foxes will attack domestic pets. While a fox might occasionally take a small rabbit or a guinea pig, they are generally very fearful of cats and dogs and will avoid them whenever possible. 

The most significant problem caused by urban foxes is the mess they make with rubbish. Foxes are excellent climbers and have learned how to open various types of bins to get to the garbage inside. This often results in trash being scattered across the streets, causing sanitation issues for local councils.

Despite these issues, attempting to remove foxes from cities is largely ineffective. If a fox is removed from a territory, another one will simply move into the empty space within a few days. Therefore, wildlife experts argue that the best approach is not elimination, but education. Teaching the public how to properly secure their bins and discouraging them from feeding the foxes directly is the most effective way to manage the urban fox population and ensure humans and wildlife can coexist peacefully.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('260d74c8-c7bc-45d2-a162-0b7830d83e43', '9c57a731-408a-4c66-bc64-dad8bdc3195a', 1,
 'sentence-completion', 'Complete the notes below. Write NO MORE THAN ONE WORD for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('e11c7174-99d9-4cdb-88a0-b2b2ed8fd99b', '260d74c8-c7bc-45d2-a162-0b7830d83e43', 31,
 'Foxes moved to cities primarily because of the easy availability of ________.', 'food', '["food","Food"]'),
('ca16c20f-a2b6-4da4-b848-e97b64adab79', '260d74c8-c7bc-45d2-a162-0b7830d83e43', 32,
 'Foxes became nocturnal to avoid human activity and traffic ________.', 'noise', '["noise","Noise"]'),
('23628d69-374b-44b8-9b85-5cc736d7db8c', '260d74c8-c7bc-45d2-a162-0b7830d83e43', 33,
 'Compared to rural foxes, urban foxes are generally ________ in size.', 'smaller', '["smaller","Smaller"]'),
('b27e5394-4880-44bb-8d80-00646b254676', '260d74c8-c7bc-45d2-a162-0b7830d83e43', 34,
 'Their shorter snouts are a physical adaptation to a new ________.', 'diet', '["diet","Diet"]'),
('cc1ad1cf-5a3f-45ad-a6dc-1027154e0614', '260d74c8-c7bc-45d2-a162-0b7830d83e43', 35,
 'Eating human food makes urban foxes more prone to ________.', 'disease', '["disease","Disease"]'),
('502574bf-fcc5-409a-8dee-df2edb3e9d21', '260d74c8-c7bc-45d2-a162-0b7830d83e43', 36,
 'Most urban foxes choose to build their dens in residential ________.', 'gardens', '["gardens","Gardens"]'),
('b456c1fb-bbb6-4795-a275-0a4f8f484ba6', '260d74c8-c7bc-45d2-a162-0b7830d83e43', 37,
 'Many people have an unfounded fear that foxes will attack their ________.', 'pets', '["pets","Pets"]'),
('35f5a9ad-9df1-42d1-b68c-2714c3fd8061', '260d74c8-c7bc-45d2-a162-0b7830d83e43', 38,
 'The biggest nuisance caused by foxes is the spreading of ________.', 'garbage', '["garbage","rubbish","trash"]'),
('78fc07ce-8a11-4e50-8288-9e02792f8deb', '260d74c8-c7bc-45d2-a162-0b7830d83e43', 39,
 'Foxes usually show ________ towards dogs and cats and avoid them.', 'fear', '["fear","Fear"]'),
('da3affde-c6dc-4a70-ba3c-8dccab26a795', '260d74c8-c7bc-45d2-a162-0b7830d83e43', 40,
 'Experts believe the best way to manage foxes is through public ________.', 'education', '["education","Education"]');
