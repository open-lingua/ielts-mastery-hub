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
('272c646a-6c20-48c1-91ac-3cc9a84b5465', 'f5713ad5-fa7b-4f00-85cb-6dcf52512d23',
 'IELTS Advanced Listening: Corporate Retreat & Sustainable Library (Band 8)', '8', '40 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 1: Transactional Dialogue (Corporate Retreat)   ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('f423bb72-f6dd-4fa0-9eba-37c6b3ce8bd8', '272c646a-6c20-48c1-91ac-3cc9a84b5465', 1,
 'Corporate Retreat Booking',
 'Agent: Good morning, you have reached the events and reservations team at the Silverwood Alpine Resort. My name is Thomas. How can I assist you with your booking today?
Client: Good morning, Thomas. My name is Sarah Jenkins. I am the event coordinator for a tech firm called Nexus Dynamics. I am looking to book a corporate retreat for our executive team for this upcoming winter season. I know it is a bit late to be booking for December, but we had a last-minute cancellation at our previous venue.
Agent: I understand completely, Sarah. December is indeed our peak season, but we do have a few select dates still available. To start, could you spell your company name for me so I can create a new profile in our system?
Client: Certainly. It is Nexus Dynamics. N-E-X-U-S, and then Dynamics.
Agent: Thank you, Sarah. And what are the exact dates you are looking at for this retreat?
Client: We are aiming to arrive on the 12th of December and depart on the 16th of December.
Agent: Let me check our availability calendar... The 12th through the 16th. Yes, we can accommodate that. Now, how many attendees are we expecting for this retreat?
Client: It will be a relatively intimate group. Exactly twenty-five executives, plus three support staff. So, twenty-eight people in total. However, the executives will each require their own individual room. The support staff can share.
Agent: Not a problem. We can reserve twenty-five of our premium Alpine suites for the executives. Now, regarding the event spaces, will you need a main conference room for the duration of your stay?
Client: Yes, we need a primary meeting room. It must have high-speed broadband and a modern projector. But more importantly, it needs to have a panoramic view. Our CEO is very particular about having natural light and a view of the mountains.
Agent: I would highly recommend the Cedar Room, then. It features floor-to-ceiling windows looking directly out over the southern valley. It also has an integrated state-of-the-art audiovisual system. Will you require any breakout rooms for smaller group sessions?
Client: Yes, please. Two smaller breakout rooms would be perfect. We plan to do intensive strategy sessions in the afternoons.
Agent: Done. Now, let us discuss catering. Do you want us to provide all three meals, or will your team be dining off-site?
Client: We want a full-board package, so all meals included. However, we have some strict dietary requirements. Two of our executives have a severe allergy to shellfish. It is crucial that the kitchen is aware of this to avoid any cross-contamination.
Agent: I am making a very clear note of that right now. No shellfish. Our culinary team is highly experienced in managing severe allergies. Now, for the recreational aspect of the retreat. We offer several team-building activities. We have guided snowshoeing, introductory ice climbing, and a wilderness survival workshop.
Client: The wilderness survival workshop sounds a bit too intense for this group. Let’s go with the guided snowshoeing. It’s active but accessible for everyone. Can we schedule that for the afternoon of the 14th?
Agent: Guided snowshoeing on the 14th. Booked. We also have a world-class spa facility. Would you like to pre-book any group treatments or offer open access to your team?
Client: Open access would be fantastic. They will definitely appreciate the sauna and hydrotherapy pools after the strategy sessions.
Agent: Excellent. Just a quick logistical question regarding transportation. How will your team be arriving at the resort? We are located about two hours from the nearest international airport.
Client: We are flying into Geneva Airport. We will need a private coach transfer from the arrivals terminal directly to the resort. We cannot rely on public trains with all the presentation equipment we are bringing.
Agent: I can arrange a luxury coach transfer for you. It will meet your team directly outside Terminal 2. Now, regarding the deposit to secure the booking. We require a forty percent upfront payment.
Client: Forty percent. That is fine. Can I pay that via a corporate wire transfer?
Agent: A wire transfer is perfect. I will include our bank details in the preliminary invoice. Speaking of the invoice, I need an email address to send this to.
Client: You can send it directly to my finance department. The email is billing, that’s B-I-L-L-I-N-G, at nexusdynamics.com.
Agent: Perfect. I will send that over within the next thirty minutes. Before we wrap up, we should discuss our cancellation policy, especially for high-season bookings. Standard policy dictates that any cancellations made within thirty days of the arrival date will result in a forfeiture of the deposit.
Client: I understand. Our schedule is locked in, so I am not too worried about cancelling. However, I am a bit concerned about our equipment. We are shipping a prototype server ahead of our arrival. Can your receiving department securely store it for us?
Agent: Absolutely. We have a climate-controlled storage room specifically for guest parcels and valuable equipment. Just ensure the shipping label clearly states "Nexus Dynamics Retreat - Hold for Arrival". Do you need us to arrange any special insurance for it while it is on our premises?
Client: No, our corporate insurance covers the server globally. But please make sure the storage room is locked at all times. It contains highly sensitive proprietary software.
Agent: Rest assured, the storage room is access-controlled and monitored by security cameras twenty-four hours a day. Only the senior management team has the keycard. Is there anything else, perhaps regarding the evening entertainment?
Client: Oh, actually, yes. Instead of a standard dinner on the second night, could we arrange a wine-tasting event? It would be a nice icebreaker for the executives.
Agent: We have a fantastic sommelier who can host a regional wine tasting in our subterranean cellar. It usually takes about ninety minutes and includes artisanal cheese pairings.
Client: That sounds perfect. Please add the wine tasting to the itinerary for the evening of the 13th. Thank you for all your help today, Thomas.
Agent: You are very welcome, Sarah. We look forward to hosting Nexus Dynamics.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('aadaf50a-1001-4722-b961-faac6e3ddaea', 'f423bb72-f6dd-4fa0-9eba-37c6b3ce8bd8', 1,
 'sentence-completion', 'Complete the booking form below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('5b212f81-c3a6-494c-9e3e-050a503aef79', 'aadaf50a-1001-4722-b961-faac6e3ddaea', 1,
 'Company Name: Nexus ________', 'Dynamics', '["Dynamics","dynamics","DYNAMICS"]'),
('3d507cd7-c011-4287-a858-608d108aa082', 'aadaf50a-1001-4722-b961-faac6e3ddaea', 2,
 'Retreat dates: 12th to ________ December', '16th', '["16th","16","sixteenth","16th of December"]'),
('2686620e-1200-4552-b3ec-c1ec802df75f', 'aadaf50a-1001-4722-b961-faac6e3ddaea', 3,
 'Total number of attendees: ________', '28', '["28","twenty-eight","twenty eight"]'),
('e7ee62db-b945-47c6-996f-8f686fdb0a29', 'aadaf50a-1001-4722-b961-faac6e3ddaea', 4,
 'Primary meeting room must have a ________', 'panoramic view', '["panoramic view","Panoramic view"]'),
('845cf405-b2ff-4d3e-b687-6f5ba129f7db', 'aadaf50a-1001-4722-b961-faac6e3ddaea', 5,
 'Severe dietary allergy to avoid: ________', 'shellfish', '["shellfish","Shellfish"]'),
('69a4720a-e4e7-4b1f-bc51-e02583e041ad', 'aadaf50a-1001-4722-b961-faac6e3ddaea', 6,
 'Selected recreational activity: guided ________', 'snowshoeing', '["snowshoeing","Snowshoeing"]'),
('fea4ad2e-0755-46df-acc4-db031ace8680', 'aadaf50a-1001-4722-b961-faac6e3ddaea', 7,
 'Transportation from airport: private ________', 'coach', '["coach","Coach","coach transfer","private coach"]'),
('bd1dd385-c0ec-41b9-961a-9c92c54865b5', 'aadaf50a-1001-4722-b961-faac6e3ddaea', 8,
 'Send invoice to the ________ department', 'finance', '["finance","Finance"]'),
('04037ae9-32a4-4d6e-99ec-f02cb59c4f6d', 'aadaf50a-1001-4722-b961-faac6e3ddaea', 9,
 'Standard cancellation policy: forfeit deposit within ________ days', '30', '["30","thirty","Thirty"]'),
('f5f2caac-bb68-4d4c-8fba-1d7cb1c5280d', 'aadaf50a-1001-4722-b961-faac6e3ddaea', 10,
 'Resort must securely store a prototype ________ before arrival', 'server', '["server","Server","prototype server"]');

-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 2: Monologue (Sustainable Library Tour)         ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('0ffa5277-c135-4674-accb-b4f2584219ef', '272c646a-6c20-48c1-91ac-3cc9a84b5465', 2,
 'Oakbridge Community Library Orientation',
 'Director: Good morning, everyone, and welcome to the grand reopening of the Oakbridge Community Library and Cultural Hub. I am Margaret, the library director, and I am absolutely thrilled to show you the results of our extensive two-year renovation project.

Before we begin the walking tour, I want to share a little background on why this renovation was so desperately needed. Our original building, constructed in the 1970s, was charming but entirely unsuited for the digital age. Furthermore, it was incredibly energy inefficient. While many residents assumed our primary goal was simply to add more bookshelves to accommodate our growing collection, the actual driving force behind the funding was the urgent need to modernize our technological infrastructure. We have completely overhauled our digital access points, increasing public computer terminals by sixty percent and installing gigabit Wi-Fi throughout the entire campus.

One of the most exciting aspects of this renovation is our commitment to sustainability. We didn''t just update the technology; we completely redesigned the building''s environmental footprint. The roof is now entirely covered in solar panels, which supply nearly forty percent of our daily electricity needs. Even more impressively, we installed a rainwater harvesting system. This system collects runoff from the roof, filters it, and uses it exclusively to flush the toilets and irrigate the community garden outside. This reduces our reliance on the municipal water supply by thousands of gallons a month.

We were also incredibly fortunate to receive a substantial grant from the National Arts Council. This grant was specifically ring-fenced for expanding our local history archives, allowing us to digitize thousands of fragile photographs and documents that were previously inaccessible to the public.

During the closure, we operated a temporary mobile library, which was quite an adventure. The most common feedback we received during that period was how much the community missed our quiet study areas. We listened. The new layout has been specifically acoustically engineered. We have installed specialized sound-dampening panels in the ceiling and thick carpeting in the reading rooms to ensure that the quiet zones remain genuinely peaceful, even when the rest of the building is bustling.

Now, I must cover a few brief safety and operational guidelines before we move on. You will notice that we have completely eliminated physical library cards. Everything is now managed via a smartphone application. If you do not have a smartphone, do not worry; our front desk can issue a biometric scan linked to your account. Also, for today''s tour, we ask that you please refrain from bringing any food or beverages beyond the lobby area. We have pristine new furnishings, and we want to keep them that way. Finally, in the event of a fire alarm, please do not use the elevators. The emergency exits are clearly illuminated with green LED strips along the baseboards.

Alright, let us get oriented with the new floor plan. Please take a look at the maps provided in your welcome brochures. We are currently standing in the Main Foyer, which is located at the bottom center of your map, right next to the automatic entrance doors.

As we move straight ahead from the Foyer, we enter the Central Atrium. Immediately to your left, you will see a large, curved glass wall. That is the new Digital Media Lab. It is equipped with 3D printers, graphic design tablets, and video editing suites. It is a fantastic resource for local creatives.

If you look directly across the Central Atrium, on your right-hand side, there is a dedicated space with brightly colored seating and lower shelving. That is the Children’s Interactive Zone. We have soundproofed this area completely, so the kids can enjoy storytime and interactive learning without disturbing the rest of the library.

Now, if we walk straight through the Central Atrium to the very back of the building, the space opens up into a large, well-lit hall with panoramic windows facing the park. This is the Heritage Reading Room. We have kept the original oak tables from the 1970s building, but we’ve added modern, ergonomic chairs and individual reading lamps.

Let''s head back to the center and take the corridor that branches off to the left of the Central Atrium. Halfway down this corridor, on the right side, you will find a small, enclosed room. This is the Podcast Studio. It is completely soundproofed and features professional-grade microphones and mixing equipment. It can be booked in two-hour slots by anyone in the community.

Finally, if you take the corridor that branches off to the right of the Central Atrium, you will pass the restrooms. At the very end of that right-hand corridor is the Community Workshop Space. It has a durable, easy-to-clean floor and modular tables, making it perfect for arts and crafts sessions, community meetings, or small lectures.

We are so proud of this new facility, and we cannot wait for you to explore it. Let’s head over to the Digital Media Lab first.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('79cbda3a-68c0-4eed-a3c8-6d824d7764b4', '0ffa5277-c135-4674-accb-b4f2584219ef', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('2be32940-3967-4b02-9199-0821081b99af', '79cbda3a-68c0-4eed-a3c8-6d824d7764b4', 11,
 'What was the primary driving force behind the funding for the library renovation?',
 '["A. To add more bookshelves for a growing collection", "B. To modernize the technological infrastructure", "C. To improve the acoustic engineering of the building"]', 'B'),
('08ecbd53-3569-4152-b16d-5fe903691c8a', '79cbda3a-68c0-4eed-a3c8-6d824d7764b4', 12,
 'Which sustainable feature supplies nearly forty percent of the library''s electricity?',
 '["A. Wind turbines", "B. Solar panels", "C. Geothermal heating"]', 'B'),
('1308799f-b78a-4f78-845d-a80e6ed25891', '79cbda3a-68c0-4eed-a3c8-6d824d7764b4', 13,
 'How is the water from the rainwater harvesting system utilized?',
 '["A. For public drinking fountains", "B. For flushing toilets and irrigation", "C. For cooling the server rooms"]', 'B'),
('795c5bad-cb08-4516-b584-0920bd8f5f59', '79cbda3a-68c0-4eed-a3c8-6d824d7764b4', 14,
 'How are patrons'' library accounts managed in the newly renovated building?',
 '["A. Through physical plastic library cards", "B. Via a smartphone application or biometric scan", "C. Using traditional paper registration forms"]', 'B'),
('b3c213b3-877f-4529-897e-3fa788457ed3', '79cbda3a-68c0-4eed-a3c8-6d824d7764b4', 15,
 'In the event of a fire alarm, what visual cue should visitors follow?',
 '["A. The ceiling sprinkler systems", "B. Green LED strips along the baseboards", "C. Red emergency exit signs above doors"]', 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('b5be7be8-08d5-491c-a9c5-1f96bab20f25', '0ffa5277-c135-4674-accb-b4f2584219ef', 2,
 'matching', 'Label the map below. Write the correct letter, A-H, next to Questions 16-20.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('8521c574-1c11-4e17-99d8-2eb7b898dd7c', 'b5be7be8-08d5-491c-a9c5-1f96bab20f25', 16,
 'Digital Media Lab', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'C'),
('2f52961d-35a8-4369-a151-cfb1cb4bf691', 'b5be7be8-08d5-491c-a9c5-1f96bab20f25', 17,
 'Children''s Interactive Zone', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'E'),
('136f6aa3-10ef-4fa3-93d4-05871a49e497', 'b5be7be8-08d5-491c-a9c5-1f96bab20f25', 18,
 'Heritage Reading Room', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'A'),
('3cf28eb7-ac71-40a1-9fa7-25d0c18b7e3c', 'b5be7be8-08d5-491c-a9c5-1f96bab20f25', 19,
 'Podcast Studio', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'D'),
('22b9c702-fbc3-47fe-a4c4-996cf84be53b', 'b5be7be8-08d5-491c-a9c5-1f96bab20f25', 20,
 'Community Workshop Space', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'B');

-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 3: Academic Dialogue (Urban Heat Islands)       ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('3f9433af-a4be-4779-824a-bdc80f2bb9e3', '272c646a-6c20-48c1-91ac-3cc9a84b5465', 3,
 'Urban Heat Island Mitigation Strategies',
 'Tutor: Come in, Leo, Maya. Grab a seat. Let’s review your draft on urban heat island mitigation strategies. I see you’ve chosen to focus specifically on retrofitting existing green infrastructure.
Maya: Yes, Dr. Aris. Originally, we were going to look at new developments and how they integrate sustainability from the ground up, but we realized retrofitting existing urban environments is a far more pressing issue. Given that the vast majority of the projected 2050 urban population will be living in cities that are already built, focusing on new builds seemed somewhat redundant.
Leo: We started by analyzing the traditional municipal approach of simply planting more street trees. While the historical data consistently shows a marginal reduction in surface temperatures, it’s severely limited by underground utility constraints and poor soil volume in modern cities. You just can''t plant a large canopy tree on a pavement that is tightly packed with fiber-optic cables, gas lines, and high-pressure water mains. The roots simply have nowhere to go.
Tutor: That’s a very practical, often overlooked limitation to highlight. Urban planning isn''t just about what happens above ground. So, what alternative did you propose in your core thesis?
Maya: We pivoted to examining the integration of ''green roofs'' and vertical ''living walls''. We found that extensive green roofs—the ones with very shallow soil layers that only support hardy plants like mosses and succulents—are far more economically viable for retrofitting. This is compared to intensive green roofs, which feature deep soil and large plants, but require major, expensive structural reinforcement of the host building to safely bear the load.
Tutor: Excellent distinction between extensive and intensive systems. However, in your methodology section, I noticed you relied almost entirely on simulation models from the University of Melbourne. Did you consider the empirical data from the recent longitudinal trial conducted in Singapore?
Leo: We did review the Singapore study quite thoroughly, but we intentionally decided to exclude it. Their climate is equatorial, meaning they deal with consistent, oppressive year-round humidity and heat. Our predictive model is specifically tailored for temperate cities experiencing acute, short-term summer heatwaves, like London or Chicago. We concluded that injecting the Singapore data would have skewed our baseline variables completely, rendering the final projections inaccurate.
Tutor: That is a highly defensible methodological choice, Leo. But as I always say, you must explicitly state that rationale in the text of your paper. If you don''t tell the reader why you purposefully excluded such a major, widely-cited study, the peer reviewers will just assume you missed it entirely during your literature review. You must control the narrative.
Maya: We will definitely add a dedicated paragraph clarifying our exclusionary criteria. Now, moving on to the economic analysis section, this is where we really struggled. We found it incredibly difficult to quantify the financial return on investment for living walls. The initial installation and ongoing maintenance costs are high, and the direct energy savings for the building are relatively modest.
Tutor: It is notoriously tricky to quantify. This is where you need to look beyond the direct energy savings of individual buildings and examine the macroeconomic benefits. Have you considered the consequential reduction in municipal healthcare costs? Severe heatwaves cause significant, predictable spikes in hospital admissions for cardiovascular and respiratory issues. Green infrastructure reduces ambient city temperatures, thereby lowering those hospital admission rates and saving the public health sector millions.
Leo: That’s a brilliant angle. We hadn''t thought about externalized public health savings. We can easily incorporate those public health metrics into the final cost-benefit analysis.
Tutor: Good. Now, let’s look at your literature review. You’ve compiled an impressive array of researchers, but you need to accurately match them to their specific theoretical contributions or critiques. Let''s run through a few key figures to ensure you have the attributions correct. What was Professor O''Rourke''s main argument?
Maya: O''Rourke focused on the concept of ''eco-gentrification''. She controversially argued that installing high-end green infrastructure in low-income neighborhoods often increases local property values so dramatically that it prices out and displaces the very residents the environmental improvements were originally meant to help.
Tutor: Precisely. A vital socio-economic critique of green policies. And what about Dr. Henshall?
Leo: Henshall took a more pessimistic, structural engineering perspective. He warned about the hidden, long-term maintenance costs. He pointed out that living walls often fail within five to seven years because the integrated drip-irrigation systems inevitably leak, which can cause severe structural water damage to the host building’s facade if not caught early.
Tutor: Yes, the long-term viability and maintenance issue. Now, contrast that with the more optimistic work of Dr. Carmichael.
Maya: Carmichael is a staunch advocate for what she calls ''bio-solar'' roofs. She provided empirical evidence showing that pairing solar panels with a green roof actually increases the overall efficiency of the photovoltaic cells. The plants undergo transpiration, which cools the ambient air, preventing the solar panels from overheating and losing their operational efficiency during peak summer radiation.
Tutor: Correct. It''s a fantastic synergistic approach that solves two problems at once. What did you make of the policy critique published by Dr. Al-Fayed?
Leo: Al-Fayed was highly critical of the current regulatory framework in Europe. He stated that municipal governments rely far too heavily on offering tax incentives to private developers to build green spaces. He argues this results in fragmented, isolated green patches that look good on paper, rather than a cohesive, connected, city-wide ecological corridor which is what is actually needed for urban biodiversity.
Tutor: A very astute observation on the failures of neoliberal urban policy. Finally, let''s discuss Dr. Sterling''s contribution to the field.
Maya: Sterling shifted the academic focus away from temperature reduction entirely and looked at stormwater management. He quantified how extensive green roofs act as massive, biological sponges during heavy rainfall events. By retaining the water, they significantly reduce the sudden strain on aging municipal sewer systems, thereby preventing catastrophic urban flash floods.
Tutor: Perfect. Your grasp of the academic landscape is very strong. Just synthesize these perspectives coherently, and make sure you address that public health economic angle. I look forward to reading the final draft next week.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('4ff37bb5-ed27-4211-8cdc-d8c862ba79f8', '3f9433af-a4be-4779-824a-bdc80f2bb9e3', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('4b40141f-63e0-4326-bc53-20b540fe52db', '4ff37bb5-ed27-4211-8cdc-d8c862ba79f8', 21,
 'Why did the students decide to focus on retrofitting existing green infrastructure?',
 '["A. Because new developments are too technologically complex to analyze.", "B. Because the majority of the future urban population will live in already-built cities.", "C. Because municipal funding is exclusively allocated to older neighborhoods."]', 'B'),
('1b6cb5ba-6a41-4e8d-b3a7-75acdfcd8641', '4ff37bb5-ed27-4211-8cdc-d8c862ba79f8', 22,
 'According to Leo, what is the primary limitation of planting more street trees in modern cities?',
 '["A. The high cost of specialized soil and fertilizers.", "B. The lack of available underground space due to utilities.", "C. The amount of maintenance required during the autumn months."]', 'B'),
('78bb73ca-5d62-4bb0-97b9-b6ebedf48816', '4ff37bb5-ed27-4211-8cdc-d8c862ba79f8', 23,
 'Why did the students intentionally exclude the empirical data from the Singapore study?',
 '["A. The study focused on intensive rather than extensive green roofs.", "B. The data was published too recently to be independently verified.", "C. The equatorial climate would have skewed their baseline variables for temperate cities."]', 'C'),
('e20e7664-67bd-4ad3-962b-48751eac2ccb', '4ff37bb5-ed27-4211-8cdc-d8c862ba79f8', 24,
 'What does the tutor advise the students to do regarding the excluded study?',
 '["A. Explicitly state their rationale for excluding it in the text of the paper.", "B. Incorporate a small portion of the data into their appendix.", "C. Contact the Singapore researchers to request temperate climate data."]', 'A'),
('fcfb582d-79e5-4e6c-bce4-02b8d6eb15a2', '4ff37bb5-ed27-4211-8cdc-d8c862ba79f8', 25,
 'How does the tutor suggest the students justify the high cost of living walls in their economic analysis?',
 '["A. By emphasizing the significant increase in residential property taxes.", "B. By calculating the externalized savings in municipal healthcare costs.", "C. By focusing on the long-term reduction in a building''s heating bills."]', 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('1d5e70b8-c8dd-497f-85a0-dd4117e05266', '3f9433af-a4be-4779-824a-bdc80f2bb9e3', 2,
 'matching', 'Match the following academic critiques or theories to the correct researcher. Choose the correct letter, A-E.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('91499ec9-d352-4e0b-a306-73ca81e919ca', '1d5e70b8-c8dd-497f-85a0-dd4117e05266', 26,
 'Criticized the reliance on tax incentives for creating fragmented rather than cohesive green spaces.',
 '["A. Professor O''Rourke", "B. Dr. Henshall", "C. Dr. Carmichael", "D. Dr. Al-Fayed", "E. Dr. Sterling"]', 'D'),
('33c6bc66-e5f4-498a-84b6-f61b2c1bd710', '1d5e70b8-c8dd-497f-85a0-dd4117e05266', 27,
 'Demonstrated that extensive green roofs can prevent catastrophic urban flash floods.',
 '["A. Professor O''Rourke", "B. Dr. Henshall", "C. Dr. Carmichael", "D. Dr. Al-Fayed", "E. Dr. Sterling"]', 'E'),
('73ffba4e-a582-4bb9-850b-2e47dad321ee', '1d5e70b8-c8dd-497f-85a0-dd4117e05266', 28,
 'Highlighted the risk of long-term structural water damage caused by leaking irrigation systems.',
 '["A. Professor O''Rourke", "B. Dr. Henshall", "C. Dr. Carmichael", "D. Dr. Al-Fayed", "E. Dr. Sterling"]', 'B'),
('3bec44dd-aeac-4041-813b-21b2ced15887', '1d5e70b8-c8dd-497f-85a0-dd4117e05266', 29,
 'Argued that environmental improvements can lead to the displacement of low-income residents.',
 '["A. Professor O''Rourke", "B. Dr. Henshall", "C. Dr. Carmichael", "D. Dr. Al-Fayed", "E. Dr. Sterling"]', 'A'),
('28ef047d-3bc6-4080-99e6-46b340c31dbe', '1d5e70b8-c8dd-497f-85a0-dd4117e05266', 30,
 'Showed that vegetation can cool ambient air and prevent photovoltaic cells from losing efficiency.',
 '["A. Professor O''Rourke", "B. Dr. Henshall", "C. Dr. Carmichael", "D. Dr. Al-Fayed", "E. Dr. Sterling"]', 'C');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 4: Academic Monologue (Self-Healing Concrete)   ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('849fb747-83aa-404b-95af-9df9cd74c9de', '272c646a-6c20-48c1-91ac-3cc9a84b5465', 4,
 'The Development and Application of Bio-Concrete',
 'Lecturer: Welcome back to Advanced Construction Materials. Today, we are going to explore one of the most fascinating, interdisciplinary breakthroughs in modern civil engineering: the development of self-healing concrete, which is technically referred to in the literature as bio-concrete.

To truly understand the absolute necessity of this innovation, we must first acknowledge the fundamental, inescapable flaw of traditional concrete. While it is undeniably the most widely used construction material on the planet due to its immense compressive strength—meaning it can effortlessly support massive amounts of vertical weight—it is notoriously weak in tension. This inherent brittleness dictates that concrete will, without exception, eventually crack. In fact, small micro-cracks are a standard, accepted feature of all concrete structures from the moment they finish curing. 

Initially, a microscopic surface crack might not seem like a pressing structural threat. However, these tiny fissures act as direct pathways for rainwater, and more dangerously, winter de-icing salts, to penetrate deep into the porous material. When this corrosive moisture finally reaches the internal steel rebar—the metallic skeleton that actually gives the structure its necessary tensile strength—the steel inevitably begins to rust and expand. This aggressive expansion causes the surrounding concrete to spall and break away, eventually leading to catastrophic structural failure if left untreated. Currently, the global construction industry spends billions of dollars annually on manual maintenance, applying temporary chemical sealants just to fight this slow, inevitable decay.

Enter self-healing concrete. This revolutionary material was pioneered not just by structural engineers, but through a unique collaboration with microbiologists at Delft University in the Netherlands. They asked a beautifully simple question: could we fundamentally re-engineer a building material to act much like human skin, rendering it capable of autonomously repairing its own wounds? 

The solution they ultimately discovered was entirely biological. They decided to embed specific strains of live bacteria directly into the liquid concrete mixture. But they couldn''t use just any common bacteria. The highly alkaline environment of wet concrete is extremely toxic, possessing a pH level akin to industrial bleach, and the chemical curing process itself generates intense, sustained heat. Therefore, the researchers had to select extremophile bacteria from the Bacillus genus—specifically, rare strains typically found surviving near highly alkaline, active volcanoes. 

These remarkable bacteria have an evolutionary adaptation: the ability to form highly resilient spores. You can think of a spore as a microscopic, impenetrable seed. These robust spores can lie completely dormant inside the dry concrete matrix for up to two hundred years, surviving perfectly well without any food or oxygen.

So, how does the autonomous healing mechanism actually trigger? Along with the dormant bacterial spores, the engineers must also mix in a specific food source, which in this case is a chemical compound called calcium lactate. To prevent premature consumption, both the bacteria and their food are safely encapsulated in tiny, biodegradable capsules made of a specialized plastic. 

When a stress crack inevitably forms in the concrete structure, ambient rainwater seeps into the newly formed fissure and physically dissolves the plastic capsules. This sudden influx of moisture simultaneously wakes up the dormant bacteria and releases the calcium lactate into their immediate environment. The revived bacteria aggressively begin to consume the calcium lactate. As they rapidly metabolize this food source, they excrete a hardened byproduct: calcium carbonate, which is essentially pure limestone. 

This excreted limestone gradually builds up along the edges of the fissure, bridging the physical gap and completely sealing the crack from the inside out in a matter of three to four weeks. Once the crack is fully sealed and the external water supply is cut off, the bacteria intuitively recognize the change in their environment. They simply form protective spores once again and return to their dormant state, silently waiting for the next crack to appear. 

The industrial applications for this technology are truly staggering. Its most immediate value lies in subterranean and highly hazardous environments where manual maintenance is either physically impossible or prohibitively expensive. Imagine the structural benefits for underground wastewater tunnels, deep-sea oil drilling platforms, or the massive containment vessels of nuclear power plants. Utilizing bio-concrete in these inaccessible structures would dramatically increase both their operational lifespan and their safety margins.

However, widespread commercial adoption of bio-concrete currently faces two major industry hurdles. The first, unsurprisingly, is cost. The specialized laboratory preparation of the extremophile bacteria and the calcium lactate makes bio-concrete roughly twice as expensive to produce as traditional concrete. While the long-term savings on structural maintenance would easily offset this initial capital expenditure within a decade, the global construction industry is notoriously conservative and remains heavily focused on minimizing upfront material costs. 

The second major hurdle is standardized regulatory testing. Because this is fundamentally a living, biological material, its healing performance can fluctuate wildly based on ambient temperature and regional humidity. Before bio-concrete can be officially written into international building codes and safely used to construct high-rise skyscrapers, regulatory engineers need decades of longitudinal data to definitively prove its reliability under diverse, extreme weather conditions. 

Despite these significant challenges, the successful integration of microbiology into civil engineering represents a profound paradigm shift. We are finally moving away from relying on inert, lifeless building materials and entering a new era of smart, responsive infrastructure that actively maintains itself. In tomorrow''s practical seminar, we will look at the specific chemical equations behind the calcium lactate metabolism.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('9b47703b-232d-4ea0-83fe-584284fa600d', '849fb747-83aa-404b-95af-9df9cd74c9de', 1,
 'sentence-completion', 'Complete the notes below. Write NO MORE THAN TWO WORDS for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('12a0cbce-8756-40ad-af8b-92073d62af5f', '9b47703b-232d-4ea0-83fe-584284fa600d', 31,
 'Traditional concrete is highly susceptible to cracking due to its weakness in ________.', 'tension', '["tension","Tension"]'),
('58b4c409-a9cd-4f78-8309-91c2f9303006', '9b47703b-232d-4ea0-83fe-584284fa600d', 32,
 'Micro-cracks allow moisture and ________ to reach the internal steel rebar, causing it to rust.', 'de-icing salts', '["de-icing salts","deicing salts","salts"]'),
('55738064-3458-41a1-82a9-f387deb302ea', '9b47703b-232d-4ea0-83fe-584284fa600d', 33,
 'The extremophile bacteria selected for bio-concrete are typically found near active ________.', 'volcanoes', '["volcanoes","Volcanoes"]'),
('b1b2a407-043e-4bd3-8a19-aa6fde145f2a', '9b47703b-232d-4ea0-83fe-584284fa600d', 34,
 'The bacteria are able to survive inside the dry concrete for up to 200 years by forming highly resilient ________.', 'spores', '["spores","Spores"]'),
('4dbe6904-64a3-4a98-b087-b6158b7d0ce9', '9b47703b-232d-4ea0-83fe-584284fa600d', 35,
 'The bacteria''s food source is safely encased in capsules made of specialized ________.', 'plastic', '["plastic","biodegradable plastic","Plastic"]'),
('86b502a4-6271-4870-a6eb-22f0b5acca4c', '9b47703b-232d-4ea0-83fe-584284fa600d', 36,
 'When water enters a crack, the bacteria wake up, consume the food, and excrete pure ________ to seal the gap.', 'limestone', '["limestone","Limestone","calcium carbonate"]'),
('1c76fc68-0444-4875-88fa-59d889b2be01', '9b47703b-232d-4ea0-83fe-584284fa600d', 37,
 'The technology is particularly valuable for subterranean and ________ environments where manual repair is impossible.', 'hazardous', '["hazardous","Hazardous"]'),
('0a4ebb59-dfd8-44fa-a0e6-54f6d6f16ed9', '9b47703b-232d-4ea0-83fe-584284fa600d', 38,
 'Widespread commercial use is currently limited because the material is twice as ________ as standard concrete.', 'expensive', '["expensive","Expensive"]'),
('9d471db3-b262-452a-bd6b-35746110ddcd', '9b47703b-232d-4ea0-83fe-584284fa600d', 39,
 'The global construction industry is conservative and focuses heavily on minimizing upfront ________.', 'costs', '["costs","Costs","material costs"]'),
('a6d90fb6-25d4-4077-b801-771ccf9e810b', '9b47703b-232d-4ea0-83fe-584284fa600d', 40,
 'Regulatory engineers are concerned that the healing performance of the material can fluctuate wildly depending on regional ________.', 'humidity', '["humidity","Humidity"]');
