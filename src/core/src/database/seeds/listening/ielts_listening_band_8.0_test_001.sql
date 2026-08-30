-- ============================================================
-- IELTS Practice Platform – Seed Data
-- Target: Listening Module (Band 8 Difficulty)
-- Description: Advanced listening test featuring complex 
-- paraphrasing, rapid speech patterns, and technical vocabulary.
-- ============================================================

-- ████████████████████████████████████████████████████████████
-- ██  LISTENING TEST RECORD                                 ██
-- ████████████████████████████████████████████████████████████

INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status) VALUES
('a732b9e7-75b7-4267-ad19-9604bc699dcf', '6f533c9e-8894-4a62-ab5c-f384efab49fd',
 'IELTS Advanced Listening: Aviation Expo, Historic Docks & Oceanography (Band 8)', '8', '40 mins', 'published');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 1: Transactional Dialogue (Exhibition Booking)  ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('598d8eaf-2a95-48d2-9bcd-c1383143fce8', 'a732b9e7-75b7-4267-ad19-9604bc699dcf', 1,
 'Aviation Expo Stall Booking',
 'Representative: Good morning, National Aviation Expo booking office. This is Clara speaking. How may I assist you today?
Caller: Hello, Clara. Yes, I''m calling to inquire about reserving a commercial stall for this year''s upcoming expo in November. We had a booth two years ago, but we missed last year''s event.
Representative: Welcome back then! I can certainly help you sort that out. First, could I take the name of your company to check if your details are still in our database?
Caller: Yes, it''s Horizon Aeronautics. We specialize in lightweight drone components.
Representative: Let me just pull that up... Horizon... Ah, yes. I see you were previously listed under ''Horizon Engineering''. Should I update the registered name?
Caller: Please do. It''s Horizon Aeronautics now. 
Representative: Updated. And I''ll need to confirm the name of the primary contact person. Is it still a Mr. Jeremy Vance?
Caller: No, Jeremy retired in the spring. I am the new head of marketing. My name is Simon Harwood. That''s H-A-R-W-O-O-D.
Representative: Thank you, Mr. Harwood. Now, regarding the dates, the main public expo runs from the 14th to the 16th of November. However, exhibitors are required to arrive earlier for the mandatory safety briefing. That takes place on the 12th.
Caller: The 12th of November. Understood. We usually need a full day to assemble our display anyway. What are the current rates for standard indoor stalls?
Representative: Our standard 3x3 metre indoor plot is £850. But since you are dealing with drone technologies, you might prefer a plot in the new Innovation Pavilion, which features higher ceilings. Those are £1,050.
Caller: Higher ceilings would actually be quite beneficial for our demonstrations. We''ll take the plot in the Innovation Pavilion.
Representative: Excellent choice. That''s £1,050. Does that price include the standard electrical hookup? 
Representative: It covers standard lighting and a basic power socket, yes. If you require three-phase power for heavy machinery, there is a surcharge, but most drone setups don''t need it. We also include a basic furniture package.
Caller: What does the basic furniture package consist of?
Representative: You get one display table and two folding chairs. Many exhibitors choose to upgrade, but that''s the baseline.
Caller: We''ll stick to the baseline, but we do have a specific requirement. Because our components are highly sensitive to dust, we need a daily cleaning service for our stall. Is that something the venue provides?
Representative: We don''t offer it automatically, but we can contract our overnight maintenance crew to do a specialized vacuuming of your area for an extra £40 per day. I''ll add that ''cleaning'' requirement to your file.
Caller: Brilliant. Now, concerning accommodation, last time we stayed at the hotel attached to the conference centre, but the noise from the nearby motorway was unbearable. Do you have a list of recommended local alternatives?
Representative: We do. We have partnered with several guesthouses in the adjacent village. The most popular among regular exhibitors is the Riverside Inn. It''s very quiet and only a ten-minute shuttle ride away.
Caller: The Riverside Inn. I''ll make a note of that and contact them directly. One last thing—we are planning to host a small prize giveaway at our booth on the final afternoon. We''re raffling off a consumer drone. Are there any restrictions on that?
Representative: Promotions are perfectly fine, but venue policy dictates that any form of public lottery or raffle requires you to obtain a specific permit from the local council beforehand. We just need to see a copy of it.
Caller: A permit from the council. Got it. I''ll get our legal team to file for that immediately. 
Representative: Perfect. I will email over the preliminary contract now. You can finalize the payment via bank transfer once you''ve reviewed the terms.
Caller: Thank you, Clara. Very helpful.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('994610b6-8714-435e-b884-cb4b3d237b02', '598d8eaf-2a95-48d2-9bcd-c1383143fce8', 1,
 'sentence-completion', 'Complete the booking form below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('a69388c8-d92e-4f58-bc77-5257849eec05', '994610b6-8714-435e-b884-cb4b3d237b02', 1,
 'Company Name: Horizon ________', 'Aeronautics', '["Aeronautics","aeronautics","AERONAUTICS"]'),
('4a6b9453-9cb9-462e-b83d-07c00b004c07', '994610b6-8714-435e-b884-cb4b3d237b02', 2,
 'Primary contact name: Simon ________', 'Harwood', '["Harwood","harwood","HARWOOD"]'),
('e61a2f48-0ce5-4f38-bb01-bf853b8d4793', '994610b6-8714-435e-b884-cb4b3d237b02', 3,
 'Exhibitors must attend a safety briefing on the ________', '12th November', '["12th November","12 November","November 12","12th"]'),
('63003559-1d5d-4363-9b29-7ed43aa81911', '994610b6-8714-435e-b884-cb4b3d237b02', 4,
 'Chosen location: The Innovation ________', 'Pavilion', '["Pavilion","pavilion","PAVILION"]'),
('76bd5e86-3056-4719-86cf-15d532648cc9', '994610b6-8714-435e-b884-cb4b3d237b02', 5,
 'Agreed cost of the plot: £________', '1050', '["1050","1,050"]'),
('b266acd3-0c27-496b-947a-f23e3bc550c0', '994610b6-8714-435e-b884-cb4b3d237b02', 6,
 'Standard furniture includes two ________', 'chairs', '["chairs","folding chairs"]'),
('e8b11d12-f10a-4b2c-aa5d-e4d3c2732828', '994610b6-8714-435e-b884-cb4b3d237b02', 7,
 'Extra service requested: Daily ________', 'cleaning', '["cleaning","vacuuming"]'),
('39e8390e-f285-481e-ac4b-325f0eb219e3', '994610b6-8714-435e-b884-cb4b3d237b02', 8,
 'Recommended accommodation: The Riverside ________', 'Inn', '["Inn","inn"]'),
('9945493c-fbb5-49f3-927e-8bebe2d0187d', '994610b6-8714-435e-b884-cb4b3d237b02', 9,
 'The company plans to give away a ________ at their booth.', 'drone', '["drone","consumer drone"]'),
('a62517d5-cd45-46be-9e80-4f70652f182c', '994610b6-8714-435e-b884-cb4b3d237b02', 10,
 'They must obtain a special ________ from the local council.', 'permit', '["permit","Permit"]');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 2: Monologue (Historic Dockyard Tour)           ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('3a003e4e-801d-4851-b391-2dc2ed3d1af0', 'a732b9e7-75b7-4267-ad19-9604bc699dcf', 2,
 'Historic Dockyard Volunteer Orientation',
 'Manager: Hello everyone, and welcome to your first day as volunteer guides here at the Blackwater Historic Dockyard. We are incredibly grateful to have you on board. Before we go outside, I want to briefly go over the recent changes to our site, as some of the information you may have read in the older guidebooks is no longer accurate.

First of all, you are all aware that the dockyard relies heavily on ticketing revenue. However, after last year’s unusually harsh winter caused structural damage to several 18th-century warehouses, we actually received an emergency heritage grant from the national government, which means we’ve finally been able to secure the site financially for the next decade without relying solely on private donations. 

As guides, you will be interacting with a lot of international tourists. One of our strictest new policies concerns the handling of the historical artifacts. Visitors love to touch the old ropes and naval tools, and frankly, in the past, we turned a blind eye to it. However, the oils from human skin are causing accelerated degradation. Therefore, you must firmly, but politely, insist that visitors keep their hands off the exhibits at all times. Taking photographs, even with a flash, is now fully permitted, so feel free to encourage that instead.

Now, let''s look at the site map. We are currently standing at the Main Ticket Office, which is the large square building at the very bottom of your map, near the South Gate. If you walk straight ahead from the Ticket Office, along the central cobbled path, the first large brick building on your left is the Ropery. This is where cordage was made for the navy, and it''s the longest brick building in Europe.

Continuing up the central path, you will come to a crossroads. On the upper right-hand corner of this intersection sits the Admiral’s House. This was fully restored last month, and it is a prime example of Georgian architecture. 

If you take a left at the crossroads, the path curves gently towards the waterfront. Right at the end of this path, jutting out over the water, is the Dry Dock. This is currently empty, but next year it will house a restored frigate. 

Now, going back to the crossroads, if you go straight ahead, you’ll see two smaller buildings side-by-side. The one on the left, with the circular roof, is the old Gunpowder Magazine. It’s built with remarkably thick walls for obvious reasons. 

Finally, if you want a break, our new Volunteer Canteen is situated out of the way. To get there, turn right at the main crossroads, walk past the Admiral’s House, and you’ll find the Canteen tucked away behind the trees at the far eastern edge of the site, away from the tourist bustle. It’s a great place to relax between your shifts.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c3470145-f86c-4723-b11b-b41baf84fc25', '3a003e4e-801d-4851-b391-2dc2ed3d1af0', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('5b78a3f7-cd22-4899-8c97-bda212bea48b', 'c3470145-f86c-4723-b11b-b41baf84fc25', 11,
 'How did the dockyard recently secure its financial future for the next decade?',
 '["A. By increasing ticket prices", "B. By receiving a national government grant", "C. Through a surge in private donations"]', 'B'),
('b8797e8b-5bc1-40aa-b895-ed5de6f392e7', 'c3470145-f86c-4723-b11b-b41baf84fc25', 12,
 'What caused the recent structural damage to the warehouses?',
 '["A. Severe winter weather", "B. Flooding from the river", "C. Poorly executed restoration work"]', 'A'),
('1c175525-3090-46ab-8e03-4df162b1cf30', 'c3470145-f86c-4723-b11b-b41baf84fc25', 13,
 'What new strict policy must the volunteer guides enforce?',
 '["A. No flash photography", "B. No touching the historical artifacts", "C. No eating near the exhibits"]', 'B'),
('ab1bbd7e-c710-456b-b78b-1bb15d59a5ad', 'c3470145-f86c-4723-b11b-b41baf84fc25', 14,
 'Why is touching the artifacts now forbidden?',
 '["A. It poses a safety hazard to visitors", "B. Some items are incredibly fragile and break easily", "C. Oils from human skin cause the items to degrade"]', 'C'),
('33ec7cf8-0da6-4e02-88af-42884432c1fd', 'c3470145-f86c-4723-b11b-b41baf84fc25', 15,
 'What is now fully permitted for visitors?',
 '["A. Handling replicas", "B. Taking photographs", "C. Entering the staff canteen"]', 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('4b800b88-cb90-4aeb-9677-12bd8f1af33a', '3a003e4e-801d-4851-b391-2dc2ed3d1af0', 2,
 'multiple-choice', 'Look at the map of the dockyard. Match the buildings (16-20) to the correct location (A-H).', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('5e40c105-3e8b-49af-911e-c15668919b75', '4b800b88-cb90-4aeb-9677-12bd8f1af33a', 16,
 'The Ropery', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'C'),
('7fe3f97f-6511-452e-893c-878faecd64d4', '4b800b88-cb90-4aeb-9677-12bd8f1af33a', 17,
 'Admiral''s House', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'F'),
('5f584567-2b72-4743-baec-c99a623cffb3', '4b800b88-cb90-4aeb-9677-12bd8f1af33a', 18,
 'Dry Dock', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'A'),
('f5e29b78-a158-45dd-bbd7-7b54b7bcfd9b', '4b800b88-cb90-4aeb-9677-12bd8f1af33a', 19,
 'Gunpowder Magazine', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'D'),
('918c963c-3b09-4b27-810a-431b8d0c8250', '4b800b88-cb90-4aeb-9677-12bd8f1af33a', 20,
 'Volunteer Canteen', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'H');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 3: Academic Dialogue (Neurolinguistics)         ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('a9e5fd60-f525-4b86-95c1-706a4673a882', 'a732b9e7-75b7-4267-ad19-9604bc699dcf', 3,
 'Bilingualism and Cognitive Development',
 'Professor: Welcome, Alice and Tom. So, you are looking to narrow down the focus for your joint dissertation on bilingualism. How has the literature review been progressing?
Alice: It’s been overwhelming, honestly. We started by looking at the traditional view from the 1960s, which assumed that teaching a child two languages simultaneously would confuse them and delay cognitive development. 
Tom: Exactly. And while we found plenty of modern studies refuting that, the sheer volume of conflicting neuroimaging data on executive function made it really hard to decide on a specific angle for our methodology.
Professor: A very common trap. The neuroimaging literature is vast. Did you manage to identify a specific cognitive advantage you want to test?
Alice: Yes, we decided to pivot away from memory tests. We were originally going to look at working memory, but the control groups in those studies are notoriously hard to standardize. Instead, we want to focus on cognitive inhibition—the ability of the brain to ignore irrelevant stimuli and focus on a specific task.
Tom: The prevailing theory is that because bilinguals constantly suppress one language while using the other, this mental "workout" strengthens their overall inhibitory control. We want to test if this advantage is visible in young adults, not just children or the elderly.
Professor: An excellent choice. But remember, assessing cognitive inhibition requires very precise testing methods. Have you considered which psychometric tool you will use?
Alice: We debated between the Stroop Test and the Simon Task. The Stroop Test involves reading colour words printed in conflicting ink colours, but it relies heavily on reading speed, which could skew the results for second-language learners.
Tom: That''s why we settled on the Flanker Task. It uses directional arrows instead of words, so it completely removes language proficiency as a confounding variable. Participants just indicate the direction of the central arrow while ignoring the flanking ones. 
Professor: The Flanker Task is a robust choice. Now, regarding the existing literature, you''ll need to critically evaluate key researchers in this field. Let''s run through some prominent names you should feature in your review. What did you make of Ellen Bialystok''s work?
Alice: Bialystok is foundational. Her primary contribution was proving that bilingualism actually delays the onset of dementia symptoms in the elderly by an average of four to five years. She termed this "cognitive reserve."
Professor: Spot on. And what about Arturo Hernandez?
Tom: Hernandez took a different approach. He didn''t look at age, but rather the physical structure of the brain. He found that early bilinguals actually show an increased density of grey matter in the parietal cortex compared to monolinguals.
Professor: Very good. You should also look at the research by Ping Li.
Alice: Yes, Li focused on adult learners. His findings suggested that learning a second language later in life creates vast new neural networks, highlighting the adult brain’s incredible neuroplasticity.
Professor: And how about the somewhat controversial work of Kenneth Paap?
Tom: Paap is the sceptic of the group. His meta-analyses argue that the so-called "bilingual advantage" in executive function is largely a myth, driven by publication bias where only positive results get printed.
Professor: Indeed, it’s vital to include opposing views. Finally, what did you glean from Judith Kroll’s studies?
Alice: Kroll revolutionized how we understand language processing. She proposed the "parallel activation" theory, demonstrating that even when a bilingual person is speaking only one language, both languages remain subconsciously active and competing in the brain.
Professor: Excellent summary. It seems you have a very solid grasp of the theoretical landscape. Your next step is to finalize your participant recruitment criteria.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('8f849861-14f7-40a5-9c87-af1241838f52', 'a9e5fd60-f525-4b86-95c1-706a4673a882', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('d0944aa7-3efb-4418-850b-dd12b47e466f', '8f849861-14f7-40a5-9c87-af1241838f52', 21,
 'Why did the students struggle with their literature review?',
 '["A. They couldn''t find enough modern studies", "B. The neuroimaging data was contradictory and overwhelming", "C. The 1960s theories were difficult to understand"]', 'B'),
('93cfc131-c8cd-4d08-b2f6-d4ba0f83633a', '8f849861-14f7-40a5-9c87-af1241838f52', 22,
 'Why did Alice and Tom decide against studying working memory?',
 '["A. The required equipment was too expensive", "B. It is too difficult to standardize the control groups", "C. The brain''s executive function is too complex to isolate"]', 'B'),
('082bb03f-d549-4f97-acb9-555da9db74f2', '8f849861-14f7-40a5-9c87-af1241838f52', 23,
 'What is the specific focus of the students'' planned methodology?',
 '["A. How children learn multiple languages", "B. The delay of cognitive decline in the elderly", "C. Cognitive inhibition in young adults"]', 'C'),
('3f19e321-cb8a-4aa1-bb17-11862adecf34', '8f849861-14f7-40a5-9c87-af1241838f52', 24,
 'Why did the students reject the Stroop Test?',
 '["A. It relies on the participants'' reading speed", "B. It is only suitable for young children", "C. It involves recognizing directional arrows"]', 'A'),
('e39faeae-0d55-4704-97cc-4b0610ee7225', '8f849861-14f7-40a5-9c87-af1241838f52', 25,
 'What advantage does the Flanker Task offer for their research?',
 '["A. It tests reading comprehension and reaction time", "B. It removes language proficiency as a variable", "C. It can be conducted without visual stimuli"]', 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('8996d4d0-db62-4d78-9f4d-8c28b60fb193', 'a9e5fd60-f525-4b86-95c1-706a4673a882', 2,
 'multiple-choice', 'Match the following research findings/theories to the correct researcher. Choose the correct letter, A-F.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('82d58fa1-4063-4b23-bf64-cd3a91806c8c', '8996d4d0-db62-4d78-9f4d-8c28b60fb193', 26,
 'Bilingualism delays the onset of dementia symptoms', 
 '["A. Kenneth Paap", "B. Ellen Bialystok", "C. Ping Li", "D. Arturo Hernandez", "E. Judith Kroll", "F. Noam Chomsky"]', 'B'),
('999c66c4-d668-49c7-b4c3-f56404555dad', '8996d4d0-db62-4d78-9f4d-8c28b60fb193', 27,
 'Early bilinguals possess denser grey matter in the parietal cortex', 
 '["A. Kenneth Paap", "B. Ellen Bialystok", "C. Ping Li", "D. Arturo Hernandez", "E. Judith Kroll", "F. Noam Chomsky"]', 'D'),
('01763fc7-7c3f-4270-aef7-85a6e0751959', '8996d4d0-db62-4d78-9f4d-8c28b60fb193', 28,
 'Adult language learning creates new neural networks, showing neuroplasticity', 
 '["A. Kenneth Paap", "B. Ellen Bialystok", "C. Ping Li", "D. Arturo Hernandez", "E. Judith Kroll", "F. Noam Chomsky"]', 'C'),
('1d0bde5c-834a-4f08-b127-911cb65c5bbe', '8996d4d0-db62-4d78-9f4d-8c28b60fb193', 29,
 'The bilingual cognitive advantage is likely a myth driven by publication bias', 
 '["A. Kenneth Paap", "B. Ellen Bialystok", "C. Ping Li", "D. Arturo Hernandez", "E. Judith Kroll", "F. Noam Chomsky"]', 'A'),
('84f92c38-c470-466f-9286-adcf8b2427c3', '8996d4d0-db62-4d78-9f4d-8c28b60fb193', 30,
 'Both languages remain subconsciously active and compete simultaneously', 
 '["A. Kenneth Paap", "B. Ellen Bialystok", "C. Ping Li", "D. Arturo Hernandez", "E. Judith Kroll", "F. Noam Chomsky"]', 'E');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 4: Academic Monologue (Marine Geology)          ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('5995a6bb-b204-4921-8f67-3ddda10e29e7', 'a732b9e7-75b7-4267-ad19-9604bc699dcf', 4,
 'Methane Clathrates: The Ice That Burns',
 'Professor: Welcome to our final lecture on Marine Geology. Today, we turn our attention to one of the most fascinating and potentially perilous substances on Earth: oceanic methane hydrates, commonly known as methane clathrates. 

To the naked eye, a methane clathrate looks exactly like ordinary water ice. However, if you hold a match to it, it will catch fire. This happens because clathrates are essentially cages of frozen water molecules that trap highly compressed methane gas inside. They form naturally in very specific environments where two critical conditions are met: intense pressure and freezing temperatures. Consequently, vast deposits are found primarily in two locations: deep beneath the Arctic permafrost, and buried in the sediment along the outer margins of the continental shelves, deep beneath the ocean floor.

The sheer volume of carbon trapped in these hydrates is staggering. Conservative estimates suggest that the global deposits of methane clathrates contain more energy than all known reserves of fossil fuels—coal, oil, and natural gas—combined. This has predictably triggered massive interest from the energy sector. Several nations, notably Japan and China, have already conducted successful offshore drilling tests to extract this gas. However, commercializing this resource presents colossal engineering hurdles. The clathrate structures are highly unstable; any slight change in pressure or temperature during extraction can cause the "ice" to melt instantaneously, releasing the gas uncontrollably. 

But it is the environmental implications, rather than the engineering challenges, that keep geologists and climate scientists awake at night. Methane is a potent greenhouse gas—roughly twenty-five times more effective at trapping atmospheric heat than carbon dioxide over a century. The primary fear is a phenomenon known as the "clathrate gun hypothesis."

This hypothesis suggests a terrifying feedback loop. As anthropogenic global warming causes the oceans to heat up, the thermal energy slowly penetrates the seafloor sediment. If the deep-ocean temperature rises sufficiently, it could trigger a mass destabilization of these clathrate reserves. A sudden release of billions of tonnes of methane gas bubbling up through the water column into the atmosphere would drastically accelerate global warming, which would in turn melt even more clathrates. 

We actually have historical precedent for this. By examining geological records, specifically the isotopic signatures in deep-sea sediment cores, scientists have linked sudden, massive methane releases to ancient climate catastrophes. The most notable is the Paleocene-Eocene Thermal Maximum, which occurred roughly 56 million years ago. During this event, global temperatures spiked by five to eight degrees Celsius, causing widespread extinction of marine life due to severe ocean acidification. 

However, we must differentiate between catastrophic worst-case scenarios and current observational data. While we are currently observing methane plumes rising from the Arctic seabed, recent studies suggest that much of this gas doesn’t actually reach the atmosphere. Instead, as the bubbles rise through the water column, they are consumed by methanotrophic bacteria. These microbes essentially eat the methane, metabolizing it and converting it into carbon dioxide. While carbon dioxide is still a greenhouse gas, it is far less potent than methane, mitigating the immediate warming shock. 

Despite this microbial buffer, the long-term risk remains a critical concern. If the rate of methane release exceeds the biological capacity of these bacteria to consume it, the atmosphere will suffer the direct consequences. Therefore, mapping the exact locations and stability of these clathrate deposits using advanced sonar and seismic profiling has become a top priority for international oceanographic institutes.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('bce0cd9c-4ccd-476b-8c49-1a385704a887', '5995a6bb-b204-4921-8f67-3ddda10e29e7', 1,
 'sentence-completion', 'Complete the notes below. Write NO MORE THAN ONE WORD for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('e1791182-c19b-4dfe-a472-7fe8758fb0ee', 'bce0cd9c-4ccd-476b-8c49-1a385704a887', 31,
 'Methane clathrates require intense pressure and freezing ________ to form naturally.', 'temperatures', '["temperatures","temperature","Temperatures"]'),
('1e135ec6-9f87-4ba3-a319-8390a29465c0', 'bce0cd9c-4ccd-476b-8c49-1a385704a887', 32,
 'Vast deposits are located beneath Arctic ________ and on continental shelves.', 'permafrost', '["permafrost","Permafrost"]'),
('734ae1c1-d8b5-4dc6-9bbb-f43414625587', 'bce0cd9c-4ccd-476b-8c49-1a385704a887', 33,
 'Clathrates contain more ________ than all other known fossil fuel reserves combined.', 'energy', '["energy","Energy"]'),
('52f91490-18f3-45bc-8fb7-1aeaf168d5e6', 'bce0cd9c-4ccd-476b-8c49-1a385704a887', 34,
 'Extracting the gas is difficult because the clathrate structures are highly ________.', 'unstable', '["unstable","Unstable"]'),
('21f6737a-055a-49a5-8c44-4f0d42c8648a', 'bce0cd9c-4ccd-476b-8c49-1a385704a887', 35,
 'As a greenhouse gas, methane is far more potent at trapping ________ than carbon dioxide.', 'heat', '["heat","Heat"]'),
('cc82f33a-34a3-42cc-98b3-ec7624583e5e', 'bce0cd9c-4ccd-476b-8c49-1a385704a887', 36,
 'The hypothesis of a catastrophic feedback loop is called the clathrate ________ hypothesis.', 'gun', '["gun","Gun"]'),
('03377644-1dea-4c1e-9438-f3aa73b3039a', 'bce0cd9c-4ccd-476b-8c49-1a385704a887', 37,
 'Historically, rapid methane release caused marine extinctions due to ocean ________.', 'acidification', '["acidification","Acidification"]'),
('0818e684-7fd7-4c2c-a356-216d251e025c', 'bce0cd9c-4ccd-476b-8c49-1a385704a887', 38,
 'Currently, rising methane bubbles are often eaten by specialized marine ________.', 'bacteria', '["bacteria","microbes","Bacteria","Microbes"]'),
('a3d27663-bd1d-47ed-abb1-b75ce29b4db1', 'bce0cd9c-4ccd-476b-8c49-1a385704a887', 39,
 'These organisms metabolize the methane and convert it into carbon ________.', 'dioxide', '["dioxide","Dioxide"]'),
('fdec23aa-e46c-4a73-9ec8-f35d697ebbe7', 'bce0cd9c-4ccd-476b-8c49-1a385704a887', 40,
 'Researchers are currently mapping these deposits using advanced seismic and ________ profiling.', 'sonar', '["sonar","Sonar"]');