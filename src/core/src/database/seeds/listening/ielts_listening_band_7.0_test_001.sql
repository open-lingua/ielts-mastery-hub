-- ============================================================
-- IELTS Practice Platform – Seed Data
-- Target: Listening Module (Band 7 Difficulty)
-- Description: Upper-intermediate listening test featuring standard 
-- paraphrasing, clear everyday and academic contexts, and 
-- moderate distractor complexity suitable for a Band 7 target.
-- ============================================================

-- ████████████████████████████████████████████████████████████
-- ██  LISTENING TEST RECORD                                 ██
-- ████████████████████████████████████████████████████████████

INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status) VALUES
('8911bdd0-6f04-47df-b4bf-96ec798aaaae', '99fb3b71-df46-4806-91f2-cf65abe0479b',
 'IELTS General & Academic Listening: Community Hub, Gardens, E-Waste & Bicycles (Band 7)', '7', '40 mins', 'published');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 1: Transactional Dialogue (Room Booking)        ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('374e0b0c-4046-40fd-97a9-90c59df3e4d0', '8911bdd0-6f04-47df-b4bf-96ec798aaaae', 1,
 'Community Centre Room Booking',
 'Receptionist: Good morning, Highfield Community Centre, Rachel speaking. How can I help you today?
Caller: Hi there, Rachel. I’m calling to see if it’s possible to book a room at the centre for a new club I’m starting. 
Receptionist: We certainly do have rooms available for hire. What kind of club is it?
Caller: It’s a local photography club. We want to meet once a week to discuss techniques and plan weekend outings. I’m hoping to call it the Focus Club.
Receptionist: The Focus Club. That sounds brilliant. Now, what day of the week were you hoping to hold these meetings?
Caller: Well, initially we thought about Wednesdays, but a lot of our potential members work late on that day. So we’ve decided that Thursday evenings would be best, probably starting around 7:00 PM.
Receptionist: Let me just check the system for Thursdays. Okay, we have two rooms available on Thursday evenings. There’s the Elm Room, which is quite small and holds about 15 people, and then there’s the Oak Room, which is larger and holds up to 40.
Caller: We’re expecting around 25 to 30 people, so we’d definitely need the Oak Room. 
Receptionist: The Oak Room it is. Now, let’s discuss the cost. Because you are a local community group, you qualify for our discounted rate. The standard commercial rate is £85 per evening, but for you, it will be £65. 
Caller: £65? That’s very reasonable. Does that price include the use of any equipment? 
Receptionist: It includes chairs, tables, and a whiteboard. If you need a laptop, you have to bring your own, but we can provide a projector for an extra £5 per session if you need to display your photos.
Caller: Oh, yes, a projector is essential for a photography group. Please add that to the booking. 
Receptionist: Not a problem. I’ll make a note of that. Now, just a few administrative details. Because your meeting starts at 7:00 PM, the main reception desk will actually be closed. You’ll need to pick up the key from the security office at the back of the building. 
Caller: The security office. Got it. And what about parking? Our members will mostly be driving.
Receptionist: We have a private car park, but it is strictly regulated to stop shoppers from using it. I will email you a printable parking permit. Tell all your members to display it on their dashboard, or they might get a fine.
Caller: A parking permit. I’ll make sure to email that out to everyone before the first meeting. One more question: are we allowed to bring our own refreshments?
Receptionist: Yes, you can bring hot drinks and snacks. However, our policy is that only cold snacks like biscuits or sandwiches are allowed in the carpeted rooms. No hot food, please, as it leaves a smell.
Caller: Just biscuits and tea, that’s absolutely fine. We won’t be cooking meals!
Receptionist: Excellent. And please remember that it’s the club’s responsibility to tidy up. You must ensure all the tables are wiped down before you lock up and leave. We provide cleaning sprays in the cupboard.
Caller: Wipe down the tables. Yes, we will make sure the room is spotless. 
Receptionist: Perfect. Now, I just need your full name and contact details to set up the account.
Caller: My name is Steven Marshall. That’s M-A-R-S-H-A-L-L.
Receptionist: Thank you, Steven. If you can just give me your email address, I’ll send over the contract and the parking permits right away.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('ec7d41d0-19d7-47d5-a2a6-ca7e6fc8cd80', '374e0b0c-4046-40fd-97a9-90c59df3e4d0', 1,
 'sentence-completion', 'Complete the booking form below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('a882a130-de1e-48a8-9b17-ef90db8906f2', 'ec7d41d0-19d7-47d5-a2a6-ca7e6fc8cd80', 1,
 'Name of the club: The ________ Club', 'Focus', '["Focus","focus","FOCUS"]'),
('4b76f7c6-1b4b-40bb-8c2f-4b547500be5c', 'ec7d41d0-19d7-47d5-a2a6-ca7e6fc8cd80', 2,
 'Day of the weekly meeting: ________', 'Thursday', '["Thursday","Thursdays","thursday"]'),
('5640e445-d35b-48bf-87c5-02bd02dbae3a', 'ec7d41d0-19d7-47d5-a2a6-ca7e6fc8cd80', 3,
 'Room booked: The ________ Room', 'Oak', '["Oak","oak","OAK"]'),
('12f90bdf-1a83-4d10-89cb-40c74ecf8450', 'ec7d41d0-19d7-47d5-a2a6-ca7e6fc8cd80', 4,
 'Agreed cost per evening: £________', '65', '["65","sixty-five","65 pounds"]'),
('c47136f1-913a-4ce6-b32b-185636f34371', 'ec7d41d0-19d7-47d5-a2a6-ca7e6fc8cd80', 5,
 'Extra equipment requested: A ________', 'projector', '["projector","Projector"]'),
('88bddeb7-308a-478c-89b4-a7cbb7ea65a1', 'ec7d41d0-19d7-47d5-a2a6-ca7e6fc8cd80', 6,
 'Collect the room key from the ________ office.', 'security', '["security","Security"]'),
('fd7aadfb-cd68-4aa9-b01a-201667f2e25b', 'ec7d41d0-19d7-47d5-a2a6-ca7e6fc8cd80', 7,
 'Members must display a parking ________ in their cars.', 'permit', '["permit","Permit"]'),
('4bbc9d49-5830-460b-93cb-be92968b7c1b', 'ec7d41d0-19d7-47d5-a2a6-ca7e6fc8cd80', 8,
 'Food rule: Only cold snacks like ________ are allowed.', 'biscuits', '["biscuits","sandwiches","biscuits or sandwiches"]'),
('e72d5107-9e27-4a49-a1a5-aad51d47cc4f', 'ec7d41d0-19d7-47d5-a2a6-ca7e6fc8cd80', 9,
 'Cleaning rule: Must wipe down the ________ before leaving.', 'tables', '["tables","Tables"]'),
('0ac633f3-dc43-47e6-889e-8bcc1a88667f', 'ec7d41d0-19d7-47d5-a2a6-ca7e6fc8cd80', 10,
 'Contact person''s surname: ________', 'Marshall', '["Marshall","marshall","MARSHALL"]');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 2: Monologue (Facility Tour)                    ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('5fa2b9dc-9a5e-4cbc-a7ef-420050e6ee21', '8911bdd0-6f04-47df-b4bf-96ec798aaaae', 2,
 'City Botanical Gardens Tour',
 'Guide: Hello, everyone, and welcome to the City Botanical Gardens. I’m Sarah, and I’ll be giving you a brief orientation before you head off to explore the grounds on your own. 

First of all, I want to mention a few recent changes. If you’ve visited us in previous years, you’ll remember our famous outdoor rose collection. While that is still beautiful, our biggest addition this spring is the new tropical Glasshouse. We’ve finally finished construction, and it houses over 500 species of rainforest plants. It’s incredibly warm inside, so be prepared to take your jackets off! 

Running a massive garden like this isn’t cheap. We do receive a small subsidy from the city council, and ticket sales help a lot, but the vast majority of our funding actually comes from sponsorships by local businesses. They’ve been incredibly generous in helping us maintain the pathways and sponsor new plant collections.

Now, we want everyone to enjoy their visit, but we do have a few strict rules to protect the plants. You are more than welcome to bring a picnic and sit on the lawns, and taking photographs is highly encouraged. However, we have a strict rule that bicycles are not permitted anywhere past the main gates. We’ve had too many accidents with people riding too fast along the footpaths, so you’ll need to leave them at the racks outside.

If you have children with you today, we have some special activities. Over at the education centre, instead of just drawing pictures of flowers, the kids can actually participate in a hands-on workshop. Today, they are planting sunflower seeds in little pots which they can take home and watch grow. It’s always very popular.

Before I explain the map, I’d like to remind you about our membership program. If you buy a souvenir today, you pay full price, and meals at the cafe are standard price too. However, if you sign up for an annual membership, you get a 20% discount on all gardening workshops held throughout the year, which is a fantastic deal for amateur gardeners.

Right, let’s look at your maps to help you get your bearings. We are currently standing at the Main Entrance at the bottom of your map. 

If you walk straight ahead from the entrance along the central path, the first large circular area you come to on your left is the Rose Garden. It is in full bloom right now and smells wonderful.

Keep walking straight along the central path, and right at the very end, directly facing you, is the Cafe. It has a lovely outdoor seating area where you can relax.

Now, if you want to buy souvenirs, the Gift Shop is very easy to find. From the Main Entrance, just take the first path on the right. The Gift Shop is the building immediately on your left along that side path. 

For those wanting a bit of adventure, I highly recommend the Canopy Tree Walk. To get there, go back to the central path, walk past the Rose Garden, and you’ll see a path branching off to the right. Take that path, and the Tree Walk is at the very end, elevated up in the branches.

Finally, if you’re looking for a quiet spot, you should visit the Lily Pond. From the Main Entrance, take the path that goes off to the far left. Follow it as it curves around, and nestled in the top left corner of the gardens is the Pond. It’s very peaceful there. Enjoy your visit, everyone!');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('afccdb8b-ed5f-4582-b87d-e08dd9dd4961', '5fa2b9dc-9a5e-4cbc-a7ef-420050e6ee21', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('c4c273ce-eade-4d09-ae83-0f88dc8f51ca', 'afccdb8b-ed5f-4582-b87d-e08dd9dd4961', 11,
 'What is the biggest new addition to the gardens this spring?',
 '["A. An outdoor rose collection", "B. A tropical glasshouse", "C. A butterfly enclosure"]', 'B'),
('187ed989-76f0-4572-b390-6b3553006e94', 'afccdb8b-ed5f-4582-b87d-e08dd9dd4961', 12,
 'Where does the majority of the garden’s funding come from?',
 '["A. The city council", "B. Visitor ticket sales", "C. Local businesses"]', 'C'),
('ab07fddc-88c0-44a1-927d-8e16bfee7d08', 'afccdb8b-ed5f-4582-b87d-e08dd9dd4961', 13,
 'Which activity is strictly forbidden in the gardens?',
 '["A. Having a picnic on the lawns", "B. Riding bicycles on the paths", "C. Taking photographs of the flowers"]', 'B'),
('dd55c7a1-cf42-483c-80f5-54dbced07bb9', 'afccdb8b-ed5f-4582-b87d-e08dd9dd4961', 14,
 'What special activity is available for children today?',
 '["A. Drawing pictures of plants", "B. Planting seeds in pots", "C. Feeding the birds"]', 'B'),
('baf514b6-3be7-4b22-83c4-788710fc376e', 'afccdb8b-ed5f-4582-b87d-e08dd9dd4961', 15,
 'Annual members receive a discount on',
 '["A. Gardening workshops", "B. Meals at the cafe", "C. Souvenirs in the gift shop"]', 'A');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('d75a966f-8800-490c-9eed-789af0f215ef', '5fa2b9dc-9a5e-4cbc-a7ef-420050e6ee21', 2,
 'multiple-choice', 'Look at the map of the Botanical Gardens. Match the locations (16-20) to the correct letter (A-H).', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('f86e5652-1555-4cda-a95b-bde296f783cc', 'd75a966f-8800-490c-9eed-789af0f215ef', 16,
 'Rose Garden', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'C'),
('a052ae9e-8589-4fb8-a7d5-5873d56ec395', 'd75a966f-8800-490c-9eed-789af0f215ef', 17,
 'Cafe', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'F'),
('90674f69-617b-4856-aa0a-e95109ebc145', 'd75a966f-8800-490c-9eed-789af0f215ef', 18,
 'Gift Shop', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'D'),
('daf25a6a-235d-42e1-b25b-644b4e5a5bed', 'd75a966f-8800-490c-9eed-789af0f215ef', 19,
 'Tree Walk', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'H'),
('19232878-7e9a-4dd4-8b26-108c3d83e278', 'd75a966f-8800-490c-9eed-789af0f215ef', 20,
 'Lily Pond', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'A');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 3: Academic Dialogue (E-Waste Assignment)       ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('32dd14f9-f69d-4e84-afc9-98db8ba66042', '8911bdd0-6f04-47df-b4bf-96ec798aaaae', 3,
 'Electronic Waste Project Discussion',
 'Tutor: Come in, Mark and Emma. Take a seat. How is your research project on electronic waste progressing?
Emma: Hi, Dr. Jones. It’s going well, but the topic is massive. We started by looking at the sheer volume of e-waste generated globally. I knew laptops and televisions were a problem, but what really surprised me in the reading was the volume of discarded mobile phones. Millions are thrown away every month because they are so difficult to repair.
Mark: Yes, the scale is incredible. But our biggest challenge hasn’t been understanding the problem. The hardest part of the project so far has been finding up-to-date statistics. A lot of the academic papers rely on data from five or six years ago, which is useless given how fast technology changes.
Tutor: That is a common issue in environmental studies. My main advice to you at this stage is to avoid trying to cover the whole world. You need to narrow your focus. Pick three specific countries and compare their recycling infrastructure, otherwise your presentation will be too vague.
Emma: That makes sense. We’ll focus our comparison on Japan, Germany, and the United States. 
Tutor: Good. Now, when researching current recycling methods, what did you identify as the main bottleneck preventing higher recycling rates?
Mark: Well, people often blame consumer laziness, but the reality is economic. The main problem with current recycling is the high cost of extracting precious metals from circuit boards. It often costs more to safely extract the gold and copper than the materials are actually worth on the market.
Tutor: Precisely. The economic incentive just isn’t there yet. So, looking at your timeline, what is your next step for this week?
Emma: We’ve finished the literature review. Our next step is to write a questionnaire. We want to survey students on campus to find out how often they upgrade their devices and what they do with their old ones. After that, we’ll analyze the results and create our slides.
Tutor: Excellent plan. Let’s briefly review the case studies you’ve selected to illustrate different approaches to e-waste management. You mentioned you looked at several countries. What stood out about Japan?
Emma: Japan has a very strong legal framework. They implemented a system where the manufacturers are legally responsible for the disposal of the products they make. So, companies actually design products to be easier to dismantle.
Tutor: A great example of "Extended Producer Responsibility." And what did you find interesting about Germany?
Mark: Germany’s approach is very consumer-focused. They have mandated that all large supermarkets and electronic stores must provide free drop-off bins for small electronic waste, making it incredibly convenient for everyday people to recycle.
Tutor: Very effective. Did you look into any developing nations? What about India?
Emma: Yes, India is fascinating. Unlike the highly formalized systems in Europe, India relies heavily on a vast "informal sector." Thousands of unregulated scrap workers collect and dismantle electronics by hand. It’s highly efficient in terms of collection, but it poses severe health risks to the workers.
Tutor: A very important distinction to make in your report. And the USA?
Mark: The USA is unique because it lacks a unified national law for e-waste. Instead, everything is managed at the state level. So, a state like California has very strict recycling laws, while other states have almost none. It creates a very fragmented system.
Tutor: Good analysis. Finally, did you read the recent paper on Sweden?
Emma: We did. Sweden is pioneering a new public awareness strategy. They have integrated e-waste education directly into the primary school curriculum. They believe that teaching children about material sustainability early on will fundamentally change consumer habits in the next generation.
Tutor: A fantastic set of case studies. If you integrate those clearly into your presentation, you should do very well.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('5558efda-24e8-4197-a022-ac66b3d50af8', '32dd14f9-f69d-4e84-afc9-98db8ba66042', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('319b257f-841a-4227-9a29-a554b1de93f6', '5558efda-24e8-4197-a022-ac66b3d50af8', 21,
 'What surprised Emma most when researching e-waste?',
 '["A. The chemicals found in televisions", "B. The huge volume of discarded mobile phones", "C. The short lifespan of modern laptops"]', 'B'),
('01083c90-96ce-402a-966c-3a9c666c592d', '5558efda-24e8-4197-a022-ac66b3d50af8', 22,
 'What has been the hardest part of the project for the students so far?',
 '["A. Understanding complex technical jargon", "B. Agreeing on a specific topic", "C. Finding recent statistical data"]', 'C'),
('9e624dda-5734-45ed-ae97-3d9364f1ffe5', '5558efda-24e8-4197-a022-ac66b3d50af8', 23,
 'What is the tutor’s main piece of advice for their presentation?',
 '["A. They need to narrow their focus", "B. They should include more visual aids", "C. They must interview local recycling experts"]', 'A'),
('fe5a4e39-cd12-4e47-9d96-58b948273fcb', '5558efda-24e8-4197-a022-ac66b3d50af8', 24,
 'According to Mark, what is the main problem with current recycling methods?',
 '["A. The high cost of extracting precious metals", "B. A lack of public awareness", "C. Inefficient collection trucks"]', 'A'),
('533750ea-7bb1-476c-9455-a7ed169af196', '5558efda-24e8-4197-a022-ac66b3d50af8', 25,
 'What is the students’ next step for this week?',
 '["A. To analyze their survey results", "B. To write a questionnaire", "C. To design their presentation slides"]', 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('dd29d995-3633-4106-b2e6-041f93b03756', '32dd14f9-f69d-4e84-afc9-98db8ba66042', 2,
 'multiple-choice', 'What approach to e-waste is associated with each of the following countries? Match the countries (26-30) to the correct approach (A-F).', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('ba697fb0-df6a-4068-b92d-d37eb30d4bb8', 'dd29d995-3633-4106-b2e6-041f93b03756', 26,
 'Japan', '["A. Relies on an unregulated informal sector", "B. Teaches recycling in primary schools", "C. Requires manufacturers to take responsibility", "D. Has fragmented, state-level laws", "E. Mandates free drop-off bins in stores", "F. Exports all waste to neighboring countries"]', 'C'),
('f24eefdc-9261-424f-b16d-913843916a52', 'dd29d995-3633-4106-b2e6-041f93b03756', 27,
 'Germany', '["A. Relies on an unregulated informal sector", "B. Teaches recycling in primary schools", "C. Requires manufacturers to take responsibility", "D. Has fragmented, state-level laws", "E. Mandates free drop-off bins in stores", "F. Exports all waste to neighboring countries"]', 'E'),
('b5089c71-baf0-46f4-88d2-ae854f098386', 'dd29d995-3633-4106-b2e6-041f93b03756', 28,
 'India', '["A. Relies on an unregulated informal sector", "B. Teaches recycling in primary schools", "C. Requires manufacturers to take responsibility", "D. Has fragmented, state-level laws", "E. Mandates free drop-off bins in stores", "F. Exports all waste to neighboring countries"]', 'A'),
('b7e7935b-f8ec-48b4-8fca-b3eea11fa433', 'dd29d995-3633-4106-b2e6-041f93b03756', 29,
 'USA', '["A. Relies on an unregulated informal sector", "B. Teaches recycling in primary schools", "C. Requires manufacturers to take responsibility", "D. Has fragmented, state-level laws", "E. Mandates free drop-off bins in stores", "F. Exports all waste to neighboring countries"]', 'D'),
('bccbafdf-7e45-4a7a-8dfc-cfa3e18f9f3f', 'dd29d995-3633-4106-b2e6-041f93b03756', 30,
 'Sweden', '["A. Relies on an unregulated informal sector", "B. Teaches recycling in primary schools", "C. Requires manufacturers to take responsibility", "D. Has fragmented, state-level laws", "E. Mandates free drop-off bins in stores", "F. Exports all waste to neighboring countries"]', 'B');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 4: Academic Monologue (History of Bicycles)     ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('232af6ea-e2ca-4d14-abc6-2a48889edf92', '8911bdd0-6f04-47df-b4bf-96ec798aaaae', 4,
 'Lecture: The History and Impact of the Bicycle',
 'Professor: Welcome back to our course on the History of Everyday Technology. Today, we are going to look at an invention that fundamentally changed human mobility: the bicycle. 

The earliest iteration of the bicycle appeared in early 19th-century Europe. It was called a "Dandy Horse." Unlike modern bikes, it had no pedals. The rider simply sat on a seat and pushed their feet against the ground to glide forward. Interestingly, the frame of this early machine was made entirely of wood, making it quite heavy and susceptible to rotting if left out in the rain.

It wasn’t until the 1860s that inventors in France attached rotary cranks and pedals to the front wheel, creating what became known as the "Boneshaker." As the name suggests, it was an incredibly uncomfortable ride. This was largely because the wheels were made of stiff metal, transferring every bump and pothole directly into the rider’s spine. 

To achieve greater speeds, inventors then created the famous "Penny-Farthing" in the 1870s, characterized by its massive front wheel and tiny rear wheel. Because the pedals were directly attached to the front wheel, a larger wheel meant you travelled further with each pedal stroke. However, they were notoriously dangerous to ride. The turning point came in the 1880s with the invention of the "Safety Bicycle." This model featured two wheels of equal size. More importantly, it introduced a hollow pneumatic tire made of rubber, which finally provided a smooth, shock-absorbing ride. Furthermore, the safety bicycle utilized a chain to drive the rear wheel, allowing the rider to sit lower to the ground, significantly reducing the risk of fatal head injuries.

Now, beyond the mechanical evolution, the social impact of the bicycle was profound. In the late 19th century, the bicycle became a powerful symbol of independence, particularly for women. For the first time, young women could travel independently between towns without needing a horse and carriage or a male chaperone. This newfound mobility also sparked a revolution in fashion. Traditional heavy, restrictive Victorian dresses were dangerous around bicycle spokes, leading to the popularization of more practical, divided clothing, such as bloomers.

The bicycle also had a massive impact on urban infrastructure. Before automobiles dominated the landscape, it was actually cycling organizations that aggressively lobbied governments to improve road conditions. They campaigned successfully for the introduction of smooth paving on main roads, which had previously been deeply rutted dirt tracks.

As we moved into the 20th century, the rise of the affordable motorcar temporarily pushed the bicycle into the background in many Western countries. Cities were rapidly redesigned around the automobile, which led to a dangerous increase in urban traffic. Bicycles were increasingly viewed merely as children’s toys rather than serious transportation.

However, in recent decades, we have seen a dramatic renaissance. Facing gridlocked cities and pollution, urban planners are once again prioritizing the bicycle. In cities like Copenhagen and Amsterdam, extensive networks of dedicated cycle lanes have been built. Today, the promotion of cycling is not just about reducing carbon emissions; medical professionals heavily advocate for cycling as a primary tool to combat modern sedentary lifestyles and improve cardiovascular health. The humble bicycle, it seems, remains one of our most vital technologies.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('f82bf570-46f7-43a4-8d3e-bd668e067de1', '232af6ea-e2ca-4d14-abc6-2a48889edf92', 1,
 'sentence-completion', 'Complete the notes below. Write NO MORE THAN ONE WORD for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('0af9cd0b-49c9-442d-a373-308161b2f98d', 'f82bf570-46f7-43a4-8d3e-bd668e067de1', 31,
 'The frame of the earliest "Dandy Horse" was constructed from ________.', 'wood', '["wood","Wood"]'),
('bbfd0b2f-ef33-4500-b4be-07a2eab2b39d', 'f82bf570-46f7-43a4-8d3e-bd668e067de1', 32,
 'In the 1860s, the addition of ________ to the front wheel created the "Boneshaker".', 'pedals', '["pedals","Pedals"]'),
('afb1c158-c4ba-464c-9a6c-3bfdb51099f7', 'f82bf570-46f7-43a4-8d3e-bd668e067de1', 33,
 'The Boneshaker was uncomfortable because its wheels were made of ________.', 'metal', '["metal","Metal"]'),
('c98be2b8-713e-4742-9758-105a419070af', 'f82bf570-46f7-43a4-8d3e-bd668e067de1', 34,
 'The "Safety Bicycle" offered a smoother ride thanks to tires made of ________.', 'rubber', '["rubber","Rubber"]'),
('0e25dac2-a688-4bfc-b432-cb2ee129c6d4', 'f82bf570-46f7-43a4-8d3e-bd668e067de1', 35,
 'It also introduced a rear-drive ________, making it much safer to ride.', 'chain', '["chain","Chain"]'),
('196a0f39-e31c-469f-b9e1-4c0c8da620d8', 'f82bf570-46f7-43a4-8d3e-bd668e067de1', 36,
 'Bicycles became a powerful symbol of independence for ________ in the late 19th century.', 'women', '["women","Women"]'),
('0d46d42d-4a97-4c99-84d6-005ff226ef6d', 'f82bf570-46f7-43a4-8d3e-bd668e067de1', 37,
 'This new mobility led to the popularization of more practical ________.', 'clothing', '["clothing","Clothing"]'),
('d2bfe3d1-13cb-4bc3-90ee-21a84212e571', 'f82bf570-46f7-43a4-8d3e-bd668e067de1', 38,
 'Cycling organizations successfully campaigned for the introduction of smooth ________ on roads.', 'paving', '["paving","Paving"]'),
('ef2c67be-eb15-4c2c-9acc-58d7c1c2ea91', 'f82bf570-46f7-43a4-8d3e-bd668e067de1', 39,
 'In the 20th century, cities designed for cars suffered from an increase in urban ________.', 'traffic', '["traffic","Traffic"]'),
('9845c2ac-07ae-4b15-a92b-7559eadae781', 'f82bf570-46f7-43a4-8d3e-bd668e067de1', 40,
 'Today, bicycles are promoted by medical professionals to improve cardiovascular ________.', 'health', '["health","Health"]');
