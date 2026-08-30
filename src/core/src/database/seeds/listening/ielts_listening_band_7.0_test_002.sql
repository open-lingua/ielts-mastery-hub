-- ============================================================
-- IELTS Practice Platform – Seed Data
-- Target: Listening Module (Band 7 Difficulty)
-- Description: Upper-intermediate listening test featuring moderate 
-- paraphrasing, natural speech patterns, and academic contexts.
-- ============================================================

-- ████████████████████████████████████████████████████████████
-- ██  LISTENING TEST RECORD                                 ██
-- ████████████████████████████████████████████████████████████

INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status) VALUES
('816abe3a-146f-49f2-bd6b-47404de59a65', '6f533c9e-8894-4a62-ab5c-f384efab49fd',
 'IELTS Listening Practice: Community Workshops, Library Tour & Sleep Biology (Band 7)', '7', '40 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 1: Transactional Dialogue (Workshop Booking)    ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('7a587ee6-f01e-4bf4-bc68-0ac986c8480d', '816abe3a-146f-49f2-bd6b-47404de59a65', 1,
 'Community Gardening Workshop Registration',
 'Clerk: Good morning, Westford Community Centre. How can I help you?
Caller: Hi there. I’m calling because I saw a flyer about some gardening workshops happening this spring, and I’d like to register.
Clerk: Certainly! We have a few different gardening courses running this term. Are you interested in the vegetable growing course or the floral design one?
Caller: Actually, it was the urban balcony gardening workshop. I live in a flat and want to make the most of my small outdoor space.
Clerk: Ah, yes. The "Balcony Blooms" workshop. That’s been very popular this year. It runs for four weeks. Let me just check if we still have places... Yes, we have two spots left. 
Caller: Fantastic, I’ll take one of those. 
Clerk: Great. I’ll need to take down a few details to get you registered. Could I have your full name, please?
Caller: Yes, it’s Arthur Pendelton. 
Clerk: Is that P-E-N-D-L-E-T-O-N?
Caller: No, it’s P-E-N-D-E-L-T-O-N. 
Clerk: Got it, thank you. And what is your address, Arthur?
Caller: I’m at Flat 4, 28 Rivermead Road. 
Clerk: Rivermead Road. And the postcode?
Caller: It’s WE4 8TQ. 
Clerk: Thank you. Now, could I get a contact number for you? A mobile is best in case a tutor needs to cancel at the last minute.
Caller: Sure. My mobile number is 07700 900 415. 
Clerk: 07700 900 415. Perfect. Now, the workshop starts on the 15th of April. 
Caller: Oh, wait. The flyer I saw said it started on the 12th.
Clerk: The vegetable course starts on the 12th, but the balcony gardening one begins on Wednesday the 15th of April, from 6:30 PM to 8:00 PM. 
Caller: Okay, Wednesday the 15th. That works for me. 
Clerk: Now, for the fees. The full cost of the four-week course is £45. That includes all your soil and plant pots, but you will need to bring your own gloves. 
Caller: £45. That’s very reasonable. Does that include seeds as well?
Clerk: Yes, a basic starter pack of seeds is included. But as I mentioned, we don’t supply the gloves for hygiene reasons, so please remember to bring a pair. 
Caller: I’ll make a note of that. How do I go about paying?
Clerk: You can pay over the phone right now with a credit card, or you can pay in cash when you arrive for the first session. However, we do require a £15 deposit upfront to secure your place. 
Caller: I can just pay the whole £45 by card right now if that’s easier.
Clerk: That would be brilliant. Before we do that, we have a quick health and safety questionnaire. Do you have any allergies we should be aware of? Sometimes we use different types of fertilizers.
Caller: I don’t have any issues with fertilizers, but I am actually allergic to wasps. If I get stung, I need my medication.
Clerk: I’ll note down "wasps" on your medical form. The tutors always carry a first aid kit, but make sure you bring any personal medication. 
Caller: I always do.
Clerk: Excellent. One final thing, we are offering a 10% discount on the course fee if you are a registered student or a senior citizen. Do either of those apply to you?
Caller: Yes, I’m currently a part-time university student. 
Clerk: Oh, wonderful! In that case, I will apply the student discount. I just need to see your student card when you come in for the first class. 
Caller: Will do. Thanks so much for your help.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('4c1b4c6d-7e74-4097-98a3-1897a4acafb5', '7a587ee6-f01e-4bf4-bc68-0ac986c8480d', 1,
 'sentence-completion', 'Complete the form below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d5fc9676-8fdc-4dc2-9dfa-fbb1902037eb', '4c1b4c6d-7e74-4097-98a3-1897a4acafb5', 1,
 'Name of workshop: ________ Blooms', 'Balcony', '["Balcony", "balcony"]'),
('98c15bc4-ab2c-47b5-a7e4-efc70ed16092', '4c1b4c6d-7e74-4097-98a3-1897a4acafb5', 2,
 'Customer Name: Arthur ________', 'Pendelton', '["Pendelton", "pendelton"]'),
('e5c504e1-35ae-4299-b986-db705ea49984', '4c1b4c6d-7e74-4097-98a3-1897a4acafb5', 3,
 'Address: Flat 4, 28 ________ Road', 'Rivermead', '["Rivermead", "rivermead"]'),
('81c306ed-c4cb-4873-bd75-353f87ecdb6a', '4c1b4c6d-7e74-4097-98a3-1897a4acafb5', 4,
 'Mobile Number: 07700 ________', '900 415', '["900 415", "900415"]'),
('4c492f12-88a2-49af-b4c7-0e47a7a65e65', '4c1b4c6d-7e74-4097-98a3-1897a4acafb5', 5,
 'Start Date: ________ April', '15th', '["15th", "15", "15th of"]'),
('7f0f25ee-1e93-475c-ab92-f7e7831efe56', '4c1b4c6d-7e74-4097-98a3-1897a4acafb5', 6,
 'Included in cost: soil, plant pots, and ________', 'seeds', '["seeds", "starter pack of seeds"]'),
('755442b3-d255-46d7-921b-8ce14486c084', '4c1b4c6d-7e74-4097-98a3-1897a4acafb5', 7,
 'Customer must bring their own ________', 'gloves', '["gloves", "a pair of gloves"]'),
('b213dc5c-5b13-40d7-83d6-c2822f6d4135', '4c1b4c6d-7e74-4097-98a3-1897a4acafb5', 8,
 'Minimum amount needed to secure place: £________', '15', '["15", "fifteen"]'),
('bb0d0522-a668-4470-90a3-c66ecaf69901', '4c1b4c6d-7e74-4097-98a3-1897a4acafb5', 9,
 'Allergies: Allergic to ________', 'wasps', '["wasps"]'),
('fa568d91-1b7f-4153-9c22-a050501368e6', '4c1b4c6d-7e74-4097-98a3-1897a4acafb5', 10,
 'Type of discount applied: ________ discount', 'student', '["student", "university student"]');

-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 2: Everyday Monologue (Library Tour)            ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('2de116dd-fae7-4178-987f-6258cd892e87', '816abe3a-146f-49f2-bd6b-47404de59a65', 2,
 'Central Library Orientation',
 'Librarian: Good morning, everyone, and welcome to the newly renovated Westford Central Library. My name is Margaret, and I’m the head librarian here. It’s wonderful to see so many new faces. I know that since the reopening, a few of you have had questions about how the new membership system works and where everything is located, so I’m going to give you a brief orientation.

First, regarding your library cards. In the past, your card only allowed you to borrow physical books. With the new system, your card now grants you free access to our digital archive, which includes e-books, audiobooks, and international magazines. You do need to set up a PIN online to use this feature, which only takes a minute. Also, we’ve completely done away with late fees. That’s right, if you bring a book back a few days late, there’s no financial penalty anymore. However, if a book is overdue by more than thirty days, your account will be temporarily frozen until it is returned. 

Another major update is our opening hours. We used to be closed on Sundays, but owing to community feedback, we are now open seven days a week. On weekdays, our doors are open from 9 AM to 8 PM. On weekends, however, we have slightly reduced hours, operating from 10 AM to 4 PM. 

Now, let’s take a look at the layout of the ground floor. I know it looks quite different from before! We are currently standing in the Main Foyer, just inside the entrance. 

If you look straight ahead, you will see a large circular desk right in the middle of the room. That is the Help Desk, where our staff can assist you with any research queries. 

Behind the Help Desk, right at the back wall of the library, there is a large rectangular room with glass walls. That is the Quiet Study Area. We ask that absolutely no talking takes place in there, as it’s designed for focused work.

Now, if you go back to the entrance where we are standing, and walk towards your right, you’ll see a corridor. The first room you come to on the left side of that corridor is the Children’s Section. It’s painted bright yellow, so you really can’t miss it. 

Just past the Children’s Section, at the very end of that same corridor, is the Multimedia Room. This is where you can access the public computers and our collection of DVDs. 

Finally, if you need a break, we have a lovely new cafe. From the main entrance, turn to your left. Walk past the staircase, and the cafe is tucked into the corner at the far left of the building. It’s a great spot to read a magazine with a cup of coffee. 

Alright, if you’ll follow me, we will head upstairs to look at the fiction collections...');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('63504546-3db1-4cae-afab-f44f49e359f9', '2de116dd-fae7-4178-987f-6258cd892e87', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('10b07914-be27-494d-be2c-9134118a6417', '63504546-3db1-4cae-afab-f44f49e359f9', 11,
 'What new feature does the library card provide?',
 '["A. Access to local museum exhibitions", "B. Free access to the digital archive", "C. Unlimited printing and photocopying"]', 'B'),
('d4dab76d-0de1-4b86-b98e-8ea667aa80b1', '63504546-3db1-4cae-afab-f44f49e359f9', 12,
 'What must members do to use the digital features?',
 '["A. Pay a small annual fee", "B. Speak to a librarian in person", "C. Set up a PIN online"]', 'C'),
('8544dfeb-1d8a-441f-b592-cda2b5afea21', '63504546-3db1-4cae-afab-f44f49e359f9', 13,
 'What is the new policy on late returns?',
 '["A. Late fees have increased slightly", "B. There are no financial penalties for late returns", "C. A fee is only charged after thirty days"]', 'B'),
('9d390f5a-a514-49ff-a43b-858f6452321f', '63504546-3db1-4cae-afab-f44f49e359f9', 14,
 'What happens if a book is overdue by more than thirty days?',
 '["A. The member must replace the book", "B. The account is temporarily frozen", "C. A warning letter is sent to the member’s home"]', 'B'),
('d616963e-5b9a-4c82-a55f-9c593032c073', '63504546-3db1-4cae-afab-f44f49e359f9', 15,
 'What time does the library close on Sundays?',
 '["A. 4:00 PM", "B. 5:00 PM", "C. 8:00 PM"]', 'A');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('4c08141e-af5a-4053-a1ad-11a13f10f9a7', '2de116dd-fae7-4178-987f-6258cd892e87', 2,
 'matching', 'Label the map below. Write the correct letter, A-H, next to Questions 16-20.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('0712699c-456a-4fb5-9a3b-ec99e4a80cbb', '4c08141e-af5a-4053-a1ad-11a13f10f9a7', 16,
 'Help Desk', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'D'),
('b68f18a3-cae2-4cca-8020-7d60f0effd59', '4c08141e-af5a-4053-a1ad-11a13f10f9a7', 17,
 'Quiet Study Area', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'C'),
('6d808a5c-c029-4888-a9a5-99951c65af1d', '4c08141e-af5a-4053-a1ad-11a13f10f9a7', 18,
 'Children’s Section', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'G'),
('f6f1c61f-cb92-49db-aee2-bb238163f694', '4c08141e-af5a-4053-a1ad-11a13f10f9a7', 19,
 'Multimedia Room', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'F'),
('1ea484a7-5fcd-4e55-b9ec-7b17abcf4930', '4c08141e-af5a-4053-a1ad-11a13f10f9a7', 20,
 'Library Cafe', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'A');

-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 3: Academic Dialogue (Urban Heat Islands)       ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('cce5efd6-38c0-4d01-a1fc-38c83ab31f20', '816abe3a-146f-49f2-bd6b-47404de59a65', 3,
 'Urban Heat Islands Presentation Planning',
 'Sarah: Hi Mark, thanks for meeting me at the library. We really need to get our presentation on Urban Heat Islands sorted out. 
Mark: Hi Sarah. I agree. The deadline is next Tuesday, and we still haven’t finalized the structure. Have you had a chance to read the journal articles Professor Hughes recommended?
Sarah: Yes, I read the core texts over the weekend. I think our introduction should clearly define what an Urban Heat Island, or UHI, actually is. We should emphasize that cities can be up to five degrees Celsius warmer than the surrounding rural areas.
Mark: Good point. But I think instead of just throwing statistics at the audience right away, we should start with a real-world example. It makes the concept much easier to grasp. We could use the data from the 2003 European heatwave as our hook.
Sarah: Actually, that’s a great idea. It shows the severe consequences of the phenomenon. Then we can transition into the main causes of UHIs. 
Mark: Right. So, what did you identify as the primary cause? I was focusing on the lack of vegetation. Trees provide shade and cooling through evapotranspiration. When you pave over a forest, you lose all that natural cooling.
Sarah: That is certainly a major factor. But the literature suggests that the single biggest contributor is the thermal mass of building materials. Concrete and asphalt absorb a massive amount of solar radiation during the day, and then slowly release it at night. This is why cities don’t cool down when the sun sets.
Mark: I see. So we’ll prioritize building materials as the primary cause, followed by the lack of vegetation. What about anthropogenic heat? You know, the heat generated directly by human activities, like car engines and air conditioning units.
Sarah: It’s relevant, but most studies show it only accounts for a fraction of the temperature difference compared to the built environment. Let’s mention it briefly, but keep the focus on materials and vegetation. 
Mark: Agreed. Now, for the second half of our presentation, we need to cover mitigation strategies—how cities are trying to fix this problem. We have to divide these strategies between us. Who wants to present what?
Sarah: I can handle the section on green roofs. There’s a lot of interesting data from Chicago showing how planting gardens on flat commercial rooftops significantly reduces building temperatures and cuts cooling costs. 
Mark: Perfect. I’ll take the section on "cool pavements". I read a fascinating study on how cities in California are painting their roads white or light grey. By increasing the albedo—the reflectivity—of the road, it absorbs far less heat.
Sarah: Sounds good. We should also cover urban water features. Things like decorative fountains and artificial lakes. I found a paper arguing that the cooling effect of water features is actually quite localized. It only really cools the immediate surrounding area, maybe a few dozen meters. 
Mark: That’s interesting. Let me cover that one. I can link it back to the evaporative cooling concept we mentioned earlier.
Sarah: Okay, so you’ll do cool pavements and water features, and I’ll do green roofs. What about tree canopy restoration programs? 
Mark: Why don’t you take that one as well? Since it relates directly to the loss of vegetation we discuss in the causes section, it’ll flow nicely if you present it.
Sarah: Okay, I’ll add tree canopy restoration to my list. Finally, we need a strong conclusion. I think we should end by discussing how zoning laws and urban planning policies need to change. 
Mark: Exactly. It’s not enough to just paint a few roofs white; it requires a systemic change in how we design cities from the ground up. I’ll draft the conclusion tonight and send it to you for review.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('437d3618-f1eb-4294-8347-a99bc1704249', 'cce5efd6-38c0-4d01-a1fc-38c83ab31f20', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('0fd3c9eb-cace-4b04-b812-aabd88ce6a32', '437d3618-f1eb-4294-8347-a99bc1704249', 21,
 'How do the students decide to start their presentation?',
 '["A. By providing statistics on temperature differences", "B. By using a historical example of a heatwave", "C. By explaining the biological process of evapotranspiration"]', 'B'),
('6c707a0c-5e39-484d-b893-78ed1379f525', '437d3618-f1eb-4294-8347-a99bc1704249', 22,
 'According to Sarah, what is the most significant cause of Urban Heat Islands?',
 '["A. The lack of trees and parks", "B. Heat produced by vehicles and air conditioners", "C. Heat absorbed by concrete and asphalt"]', 'C'),
('8989ad6e-bd1e-4931-8cb1-12c1ac17570c', '437d3618-f1eb-4294-8347-a99bc1704249', 23,
 'Why is anthropogenic heat considered a minor factor?',
 '["A. It is only produced during the daytime", "B. It contributes less to the temperature difference than materials do", "C. It is impossible to accurately measure in large cities"]', 'B'),
('204a67d4-b212-4c38-9c7a-2587ea14ff94', '437d3618-f1eb-4294-8347-a99bc1704249', 24,
 'What is the main benefit of green roofs in Chicago?',
 '["A. They lower both building temperatures and energy bills", "B. They create new habitats for urban wildlife", "C. They absorb rainwater and prevent flooding"]', 'A'),
('b1260906-31e0-48b1-b15d-b1ec6c2eb14e', '437d3618-f1eb-4294-8347-a99bc1704249', 25,
 'What did a research paper say about urban water features?',
 '["A. They are too expensive to maintain", "B. Their cooling effect is limited to a small area", "C. They evaporate too quickly during the summer"]', 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('74503717-0361-4bf0-b6a1-ddc91c421c65', 'cce5efd6-38c0-4d01-a1fc-38c83ab31f20', 2,
 'matching', 'Who will present each mitigation strategy? Choose A for Sarah, B for Mark, or C for Both.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('0f4ddb5b-d817-434d-94f4-b77c4a3b686b', '74503717-0361-4bf0-b6a1-ddc91c421c65', 26,
 'Green roofs', '["A. Sarah", "B. Mark", "C. Both"]', 'A'),
('dd5af04d-f2a2-4246-9124-00dec6ff51b2', '74503717-0361-4bf0-b6a1-ddc91c421c65', 27,
 'Cool pavements', '["A. Sarah", "B. Mark", "C. Both"]', 'B'),
('0288eff0-076f-4057-86a8-915186a3363e', '74503717-0361-4bf0-b6a1-ddc91c421c65', 28,
 'Urban water features', '["A. Sarah", "B. Mark", "C. Both"]', 'B'),
('5cca7e5b-56b6-49fa-befa-558421ffafc7', '74503717-0361-4bf of-b6a1-ddc91c421c65', 29,
 'Tree canopy restoration', '["A. Sarah", "B. Mark", "C. Both"]', 'A'),
('0c5abe2f-e61b-4283-b781-1a4359678549', '74503717-0361-4bf0-b6a1-ddc91c421c65', 30,
 'Conclusion regarding zoning laws', '["A. Sarah", "B. Mark", "C. Both"]', 'B');

-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 4: Academic Monologue (Biology of Sleep)        ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('ef199820-93a0-416a-9acf-1598e16f5bed', '816abe3a-146f-49f2-bd6b-47404de59a65', 4,
 'The Biology of Sleep and Circadian Rhythms',
 'Lecturer: Good morning. Today, we are going to explore the biology of sleep, a fundamental physiological process that scientists are only just beginning to fully understand. Historically, sleep was viewed as a passive state—a time when the brain simply switched off to rest. However, modern neuroscience has revealed that sleep is incredibly active and essential for our survival.

Let’s begin by looking at the internal mechanism that dictates our sleep patterns: the circadian rhythm. This is essentially a 24-hour internal clock running in the background of your brain. It cycles between sleepiness and alertness at regular intervals. This rhythm is primarily controlled by a tiny region in the hypothalamus called the suprachiasmatic nucleus, or SCN. 

The SCN is highly sensitive to external cues, the most important of which is light. When natural daylight hits the retina of your eye, a signal is sent directly to the SCN. The SCN then suppresses the production of melatonin, which is the hormone responsible for making us feel drowsy. Conversely, as darkness falls, the SCN signals the pineal gland to release melatonin into the bloodstream, preparing the body for rest. This is why exposure to the blue light emitted by smartphones and laptops before bed can severely disrupt your sleep; it tricks your brain into thinking it is still daytime.

Now, let’s examine the architecture of sleep itself. Sleep is not a uniform state; it is divided into a cycle of different stages, primarily categorized into REM—which stands for Rapid Eye Movement—and Non-REM sleep. 

When you first drift off, you enter Non-REM sleep, which progresses through three distinct stages. Stage one is a light sleep where you can be easily awakened. Stage two features a drop in body temperature and heart rate. But it is stage three, known as deep sleep or slow-wave sleep, that is the most critical for physical restoration. During this deep sleep, the body repairs tissues, builds bone and muscle, and strengthens the immune system. 

After moving through these stages, you enter REM sleep. This usually occurs about ninety minutes after falling asleep. During REM, your brain activity spikes to levels similar to when you are awake. This is the stage where the vast majority of our dreaming occurs. Interestingly, during REM sleep, your body enters a state of temporary paralysis. This is actually a protective evolutionary mechanism; it prevents you from physically acting out your dreams and potentially injuring yourself. 

Aside from physical repair, what is the primary function of sleep? Recent research points heavily toward memory consolidation. Throughout the day, your brain takes in a massive amount of information. During sleep, particularly during REM and deep sleep, the brain actively sorts through this data. It discards irrelevant background noise and transfers important information from short-term memory into long-term storage. 

Furthermore, poor sleep has drastic consequences for cognitive function. Chronic sleep deprivation has been linked to a severe reduction in executive function—meaning it impairs your ability to make decisions, solve problems, and control your emotions. In the long term, studies have shown a strong correlation between chronic sleep deficiency and an increased risk of neurological disorders such as Alzheimer’s disease. This is because, during deep sleep, the brain’s glymphatic system flushes out toxic proteins that build up between neurons during waking hours. Without sufficient sleep, these toxins accumulate.

Therefore, sleep should not be viewed as a luxury or a sign of laziness, but rather as a non-negotiable biological necessity for both physical and mental well-being.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('56676cd1-d37f-40ff-82bd-1ba921f6896d', 'ef199820-93a0-416a-9acf-1598e16f5bed', 1,
 'sentence-completion', 'Complete the notes below. Write NO MORE THAN TWO WORDS for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('02840a86-5f88-4450-8d8c-a77c8835f1bc', '56676cd1-d37f-40ff-82bd-1ba921f6896d', 31,
 'The circadian rhythm is controlled by a brain region known as the ________.', 'SCN', '["SCN", "suprachiasmatic nucleus", "hypothalamus"]'),
('57910cfd-cbf8-4fb1-ad89-0ba4f3a8d731', '56676cd1-d37f-40ff-82bd-1ba921f6896d', 32,
 'The most important external cue affecting our internal clock is ________.', 'light', '["light", "natural daylight", "daylight"]'),
('0411c804-85ed-4cf3-9ba0-94ad10a96754', '56676cd1-d37f-40ff-82bd-1ba921f6896d', 33,
 'The hormone that induces drowsiness is called ________.', 'melatonin', '["melatonin", "Melatonin"]'),
('ce5dab38-a049-4a48-bd32-00594f035fa3', '56676cd1-d37f-40ff-82bd-1ba921f6896d', 34,
 'Stage three of Non-REM sleep is vital because it strengthens the ________.', 'immune system', '["immune system"]'),
('748d91d8-4e97-4e6f-ad2f-30a98f607572', '56676cd1-d37f-40ff-82bd-1ba921f6896d', 35,
 'REM sleep typically begins around ________ minutes after falling asleep.', 'ninety', '["ninety", "90"]'),
('177b6319-335e-4f6d-a7d1-ec253f9e4e1f', '56676cd1-d37f-40ff-82bd-1ba921f6896d', 36,
 'During REM sleep, a state of temporary ________ prevents people from acting out dreams.', 'paralysis', '["paralysis"]'),
('6c806819-41c6-4eda-a22f-73f41eec76ed', '56676cd1-d37f-40ff-82bd-1ba921f6896d', 37,
 'A primary function of sleep is memory consolidation, moving data into long-term ________.', 'storage', '["storage", "memory"]'),
('81891201-951d-4d34-9649-1ed3f9d10ec9', '56676cd1-d37f-40ff-82bd-1ba921f6896d', 38,
 'A lack of sleep severely reduces cognitive abilities, particularly ________.', 'executive function', '["executive function"]'),
('51626aaa-e02c-4570-94ac-aab75e3ef58b', '56676cd1-d37f-40ff-82bd-1ba921f6896d', 39,
 'Chronic sleep deprivation increases the risk of Alzheimer’s and other neurological ________.', 'disorders', '["disorders", "disease"]'),
('eda5f48e-ba6d-4adf-a8ad-8844c15d20aa', '56676cd1-d37f-40ff-82bd-1ba921f6896d', 40,
 'During deep sleep, the brain clears out toxic ________ that accumulate during the day.', 'proteins', '["proteins"]');