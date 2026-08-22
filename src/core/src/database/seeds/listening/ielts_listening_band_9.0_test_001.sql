-- ============================================================
-- IELTS Practice Platform – Seed Data
-- Target: Listening Module (Band 9 Difficulty)
-- Description: Expert-level listening test featuring dense 
-- academic vocabulary, rapid corrections, and subtle implications.
-- ============================================================

-- ████████████████████████████████████████████████████████████
-- ██  LISTENING TEST RECORD                                 ██
-- ████████████████████████████████████████████████████████████

INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status) VALUES
('509db6b9-9e71-4062-80cc-327868f72866', 'fe38ed89-f1fe-4b88-9609-8736be47f61e',
 'IELTS Expert Listening: Logistics, Oceanography, Behavioral Economics & Paleoclimatology (Band 9)', '9', '40 mins', 'published');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 1: Transactional Dialogue (Event Logistics)     ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('0beb69f1-4787-471e-8914-473958f4f516', '509db6b9-9e71-4062-80cc-327868f72866', 1,
 'Charity Gala Logistics Booking',
 'Agent: Good afternoon, Zenith Event Solutions. How may I assist you?
Client: Hello, I''m calling to finalize the logistics for our upcoming charity gala. My name is Julian Harcroft.
Agent: Ah, yes, Mr. Harcroft. I have your preliminary file here. Let''s confirm the venue. You initially inquired about the Botanical Gardens, correct?
Client: We did, but the capacity was too restrictive. We''ve officially secured the Maritime Museum instead. The acoustics are far superior for the orchestral performance.
Agent: Excellent choice. Now, regarding the date. The file says Saturday the 12th of November.
Client: That was the original plan, but a scheduling conflict with our keynote speaker meant we had to push it to the 15th.
Agent: Tuesday the 15th of November. Duly noted. Have you got a final headcount for the catering? We had an estimate of 150.
Client: We sent out 150 invitations. Exactly 120 RSVP''d in the affirmative, but two had to drop out yesterday due to illness, leaving us with a solid 118 confirmed attendees.
Agent: 118 it is. Now, for the menu. Our standard package is popular, but given this is a high-profile gala, would you prefer the premium option?
Client: Actually, we reviewed the menus and decided to skip both of those and go with your bespoke Platinum package. The wine pairings sold us on it.
Agent: Fantastic. Are there any severe dietary restrictions we must absolutely isolate?
Client: Yes. We have several vegetarians, but the kitchen must be exceptionally careful regarding one guest with celiac disease. We cannot risk any cross-contamination with gluten whatsoever.
Agent: We will ensure the prep areas are strictly isolated. Regarding the venue facilities, our quote covers the tables, linens, and standard waitstaff. I should also mention that unlike many of our competitors, our fee includes dedicated security for the evening.
Client: That''s a huge relief. One less thing to worry about. We will, however, be bringing our own lighting rig, as your in-house system doesn''t quite suit the dramatic ambiance we''re aiming for.
Agent: That''s perfectly fine. We just need your technician to liaise with our site manager beforehand. Who should they contact?
Client: That would be our production head, Alastair. That''s A-L-A-S-T-A-I-R.
Agent: Got it. And what is the best mobile number for Alastair?
Client: He can be reached directly on 07789 544 321.
Agent: 07789 544 321. Splendid. The last thing I require from you to lock everything in is a detailed itinerary of the evening''s speeches and performances, ideally by this Friday.
Client: I''ll email that over to you tomorrow morning.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('4c1132cf-6a3a-4c17-b027-8ec370297f3c', '0beb69f1-4787-471e-8914-473958f4f516', 1,
 'sentence-completion', 'Complete the booking form below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('579a7f52-ff12-4e2e-bea8-063b47c8e2c1', '4c1132cf-6a3a-4c17-b027-8ec370297f3c', 1,
 'Confirmed Venue: The ________', 'Maritime Museum', '["Maritime Museum","maritime museum","Maritime museum"]'),
('0c451d1d-0310-4dd4-b960-05e9d0bde6eb', '4c1132cf-6a3a-4c17-b027-8ec370297f3c', 2,
 'Final Date: ________ November', '15th', '["15th","15","15th of"]'),
('20331179-0925-4f11-a212-f61c7fa0e198', '4c1132cf-6a3a-4c17-b027-8ec370297f3c', 3,
 'Total confirmed attendees: ________', '118', '["118","one hundred and eighteen"]'),
('c22481d6-3fd6-41bd-9a53-400ec1c2be78', '4c1132cf-6a3a-4c17-b027-8ec370297f3c', 4,
 'Catering Package selected: ________', 'Platinum', '["Platinum","platinum","Platinum package"]'),
('a4612d34-c7a8-4a29-8903-7d267b6d8dfd', '4c1132cf-6a3a-4c17-b027-8ec370297f3c', 5,
 'Strict dietary isolation required for: ________ disease', 'celiac', '["celiac","Celiac","coeliac"]'),
('3eeee934-c074-4bb7-be91-16aac501ce74', '4c1132cf-6a3a-4c17-b027-8ec370297f3c', 6,
 'Included at no extra charge: Dedicated ________', 'security', '["security","Security"]'),
('5f4130a9-72e7-4fd1-a913-865f9b7f2bd7', '4c1132cf-6a3a-4c17-b027-8ec370297f3c', 7,
 'Client will provide their own ________', 'lighting rig', '["lighting rig","lighting","Lighting rig"]'),
('b862175f-b457-4a83-abc5-7d5d4f0cef4f', '4c1132cf-6a3a-4c17-b027-8ec370297f3c', 8,
 'Production contact name: ________', 'Alastair', '["Alastair","alastair"]'),
('e513a741-7c58-404b-b7bd-1111e28f23f4', '4c1132cf-6a3a-4c17-b027-8ec370297f3c', 9,
 'Contact mobile number: ________', '07789 544 321', '["07789 544 321","07789544321"]'),
('3587fab5-093e-4693-bf73-4376664896de', '4c1132cf-6a3a-4c17-b027-8ec370297f3c', 10,
 'Must be submitted by Friday: An evening ________', 'itinerary', '["itinerary","Itinerary"]');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 2: Monologue (Deep Sea Research Facility)       ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('836db6a0-3bc0-49a6-aa85-da18f76ae504', '509db6b9-9e71-4062-80cc-327868f72866', 2,
 'Abyssal Zone Research Facility Orientation',
 'Guide: Welcome, everyone, to the Abyssal Zone Research Facility. Before I show you the layout, a brief overview. We established this center to study extremophiles—organisms thriving in impossible conditions. Initially, funding was our biggest hurdle, constantly delaying construction. However, it was actually the rapid rate of coastal erosion that forced us to completely abandon our original site and move two miles inland to this current location.

Our primary mandate here isn''t just biological cataloging. While we do extensive genetic sequencing, our core objective is to harness these organisms'' unique enzymes for biomedical applications, specifically in synthesizing new antibiotics. Now, as visitors, you have access to most surface areas, but I must stress one non-negotiable regulation. While you can take photos in the main halls, any use of flash photography is strictly prohibited near the transparent incubation tanks, as the sudden light can fatally shock the deep-sea specimens.

Let''s look at your maps. We are currently standing at the Main Entrance, facing north. Immediately to your left, you''ll see a large circular building. That''s the Submersible Maintenance Bay, where our deep-sea drones are repaired. If you proceed straight ahead down the central corridor, you''ll pass the Staff Cafeteria on your right. Just beyond the cafeteria, before the corridor terminates, there''s a heavy reinforced door on your right leading to the Isotope Laboratory.

At the very end of the central corridor, it forms a T-junction. If you turn left, the pathway leads you straight into the Data Processing Hub—a heavily air-conditioned room full of supercomputers. Conversely, if you take a right at the T-junction, you''ll see a long, narrow building running parallel to the corridor you just walked down. This is the Pressure Testing Chamber. Finally, tucked away in the very top right corner of the facility map, entirely isolated from the main complex by a buffer zone to prevent cross-contamination, is the Bio-Secure Vault.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('9cfe374f-4524-46b1-b76e-72c91fd4dd88', '836db6a0-3bc0-49a6-aa85-da18f76ae504', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('1c7aff66-2055-4d51-bd5b-3352159cbf2c', '9cfe374f-4524-46b1-b76e-72c91fd4dd88', 11,
 'What ultimately caused the facility to be relocated inland?',
 '["A. Severe budgetary constraints", "B. A lack of specialized construction equipment", "C. The retreating coastline"]', 'C'),
('b34342c4-6241-4f03-bf18-5191aaa618af', '9cfe374f-4524-46b1-b76e-72c91fd4dd88', 12,
 'The core objective of the facility''s research is to',
 '["A. catalog new biological species", "B. develop new biomedical treatments", "C. sequence the genomes of deep-sea fish"]', 'B'),
('d86c7c03-113f-40d6-94e2-0d998d45c3ec', '9cfe374f-4524-46b1-b76e-72c91fd4dd88', 13,
 'What strict rule applies to visitors near the incubation tanks?',
 '["A. They must wear protective clothing", "B. They must not use flash photography", "C. They must remain completely silent"]', 'B'),
('9097ca6c-03a8-4dc2-811a-b9b0ae2b89b9', '9cfe374f-4524-46b1-b76e-72c91fd4dd88', 14,
 'The Data Processing Hub is notable for being',
 '["A. heavily air-conditioned", "B. completely soundproof", "C. powered by solar energy"]', 'A'),
('beb5b74b-f15f-4e71-a22b-979a6cf802ac', '9cfe374f-4524-46b1-b76e-72c91fd4dd88', 15,
 'Why is the Bio-Secure Vault isolated from the main complex?',
 '["A. To protect it from extreme weather", "B. To prevent the risk of contamination", "C. To secure highly classified documents"]', 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('6d27db16-b1d6-4725-8caa-7acee661138c', '836db6a0-3bc0-49a6-aa85-da18f76ae504', 2,
 'multiple-choice', 'Look at the map of the Research Facility. Match the buildings (16-20) to the correct location (A-G).', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('65fa96da-859c-4352-8938-647490f66fd3', '6d27db16-b1d6-4725-8caa-7acee661138c', 16,
 'Submersible Maintenance Bay', '["A", "B", "C", "D", "E", "F", "G"]', 'A'),
('e11c8623-78cf-4307-abf1-bce6c34c4536', '6d27db16-b1d6-4725-8caa-7acee661138c', 17,
 'Isotope Laboratory', '["A", "B", "C", "D", "E", "F", "G"]', 'C'),
('cc795108-4439-4009-b27f-00da52d9d049', '6d27db16-b1d6-4725-8caa-7acee661138c', 18,
 'Data Processing Hub', '["A", "B", "C", "D", "E", "F", "G"]', 'D'),
('d5df3d27-e372-4260-a987-9190b6483458', '6d27db16-b1d6-4725-8caa-7acee661138c', 19,
 'Pressure Testing Chamber', '["A", "B", "C", "D", "E", "F", "G"]', 'E'),
('e189b2f6-731f-4468-925e-b42fd0409091', '6d27db16-b1d6-4725-8caa-7acee661138c', 20,
 'Bio-Secure Vault', '["A", "B", "C", "D", "E", "F", "G"]', 'F');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 3: Academic Dialogue (Behavioral Economics)     ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('51c1447d-1370-4bda-a9aa-5e956a81678c', '509db6b9-9e71-4062-80cc-327868f72866', 3,
 'Behavioral Economics Presentation Planning',
 'Tutor: Let''s discuss your progress on the Behavioral Economics presentation. Sarah, Tom, how''s the case study on ''Nudge Theory'' shaping up?
Sarah: It''s coming together, Professor Aris. We initially struggled with narrowing down the scope, but ultimately, harmonizing the sheer volume of statistical data from the different government trials proved to be our biggest obstacle. The metrics were so inconsistent across different departments.
Tom: Exactly. Once we standardized the data, some fascinating trends emerged. For instance, in the organ donation trial, I assumed the financial incentives would yield the highest registration rates. Surprisingly, it was the ''opt-out'' default mechanism that caused registrations to skyrocket, far outpacing the monetary rewards.
Tutor: A classic illustration of the status quo bias. Now, looking at your structural outline, your theoretical framework is robust. However, your section detailing the history of classical economics is unnecessarily verbose. I strongly recommend pruning that down significantly so you can devote more time to the ethical implications of nudging.
Sarah: We can certainly condense the history section. Speaking of ethics, Tom and I disagree on the long-term viability of algorithmic nudging in social media. I believe algorithm transparency regulations will eventually cripple its effectiveness.
Tom: I respectfully disagree. I think the corporate financial incentives are so overwhelmingly powerful that tech companies will always find loopholes to keep monetizing user attention, regardless of legislation.
Tutor: An interesting debate. For the presentation itself, what will be your central argument?
Sarah: Rather than focusing on the economic efficiencies or the psychological manipulation aspect, our core thesis will argue that without rigorous democratic oversight, nudge theory fundamentally undermines individual autonomy.

Tutor: Excellent. Now let''s map the specific behavioral biases to your real-world examples.
Tom: Right. For the ''Anchoring Effect'', we are using the charity donation page layout, where suggesting high initial default amounts disproportionately skews the final contributions upwards.
Sarah: For ''Loss Aversion'', we''re highlighting the retail sector''s use of limited-time discount countdown timers. People hate missing out on a perceived bargain more than they value the actual savings.
Tom: The ''Confirmation Bias'' example is political echo chambers on social media, showing how algorithms feed users news that only solidifies their pre-existing beliefs.
Sarah: We matched the ''Decoy Effect'' to the magazine subscription pricing model, where an absurdly priced print-only option makes the print-plus-digital bundle look like a steal.
Tom: And finally, the ''Halo Effect''. We''re using the case study of a tech CEO''s charismatic public persona artificially inflating the company''s stock valuation, despite consecutively poor quarterly earnings.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('25625ee9-39fe-4cb0-91e2-6d972a8b4174', '51c1447d-1370-4bda-a9aa-5e956a81678c', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('0b3da90e-d0be-4041-9060-c5ea000f70cf', '25625ee9-39fe-4cb0-91e2-6d972a8b4174', 21,
 'Sarah and Tom agree that the most challenging aspect of their research was',
 '["A. narrowing down the project scope", "B. standardizing inconsistent statistical data", "C. securing access to government documents"]', 'B'),
('eeb4150b-2291-4e75-b129-2c1ea7aa51ef', '25625ee9-39fe-4cb0-91e2-6d972a8b4174', 22,
 'In the organ donation trial, Tom was surprised to discover that',
 '["A. financial incentives were largely ineffective", "B. younger demographics resisted registration", "C. the default opt-out mechanism was the most successful"]', 'C'),
('cfea2452-a497-428b-9182-ed39803be6ca', '25625ee9-39fe-4cb0-91e2-6d972a8b4174', 23,
 'What does Professor Aris advise the students to change in their presentation structure?',
 '["A. Expand the theoretical framework", "B. Reduce the historical context of classical economics", "C. Introduce more varied case studies"]', 'B'),
('a7cbddbe-fb43-416e-b7b3-e0e079eeff0a', '25625ee9-39fe-4cb0-91e2-6d972a8b4174', 24,
 'Regarding algorithmic nudging on social media, Tom believes that',
 '["A. transparency regulations will eventually succeed", "B. tech companies will evade legislative restrictions due to profit motives", "C. users will naturally develop resistance to psychological manipulation"]', 'B'),
('c3c67c1b-efdb-4d26-8678-c87064368f55', '25625ee9-39fe-4cb0-91e2-6d972a8b4174', 25,
 'The central thesis of the students'' presentation is that Nudge Theory',
 '["A. is a highly effective tool for economic efficiency", "B. relies too heavily on psychological manipulation", "C. threatens individual autonomy without democratic oversight"]', 'C');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('efcda95a-be9c-4a82-93a2-47d4eef2dab4', '51c1447d-1370-4bda-a9aa-5e956a81678c', 2,
 'multiple-choice', 'Which real-world example do the students match to each behavioral bias? Choose the correct letter, A-F.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('1efad00c-e295-4881-a37b-888a099c0f7b', 'efcda95a-be9c-4a82-93a2-47d4eef2dab4', 26,
 'Charity donation page layouts', '["A. Anchoring Effect", "B. Loss Aversion", "C. Confirmation Bias", "D. Decoy Effect", "E. Halo Effect", "F. Status Quo Bias"]', 'A'),
('00b6669b-866c-4244-bafa-dd228d470ee7', 'efcda95a-be9c-4a82-93a2-47d4eef2dab4', 27,
 'Retail discount countdown timers', '["A. Anchoring Effect", "B. Loss Aversion", "C. Confirmation Bias", "D. Decoy Effect", "E. Halo Effect", "F. Status Quo Bias"]', 'B'),
('d7b359d3-421a-4daa-ade1-f2c217e2f33c', 'efcda95a-be9c-4a82-93a2-47d4eef2dab4', 28,
 'Political echo chambers on social media', '["A. Anchoring Effect", "B. Loss Aversion", "C. Confirmation Bias", "D. Decoy Effect", "E. Halo Effect", "F. Status Quo Bias"]', 'C'),
('4910061e-e2ec-4840-9af1-0010e43eef22', 'efcda95a-be9c-4a82-93a2-47d4eef2dab4', 29,
 'Magazine subscription pricing models', '["A. Anchoring Effect", "B. Loss Aversion", "C. Confirmation Bias", "D. Decoy Effect", "E. Halo Effect", "F. Status Quo Bias"]', 'D'),
('3b529485-5a46-4824-adc5-646de91484fa', 'efcda95a-be9c-4a82-93a2-47d4eef2dab4', 30,
 'A tech CEO''s charismatic public persona', '["A. Anchoring Effect", "B. Loss Aversion", "C. Confirmation Bias", "D. Decoy Effect", "E. Halo Effect", "F. Status Quo Bias"]', 'E');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 4: Academic Monologue (Paleoclimatology)        ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('30f47c15-f5fb-4a10-b077-fe41850d18a8', '509db6b9-9e71-4062-80cc-327868f72866', 4,
 'Lecture: Ice Core Analysis and Paleoclimatology',
 'Lecturer: Today we focus on Paleoclimatology, specifically the extraction and analysis of ice cores. These massive cylinders of ice, drilled from the polar ice sheets, act as temporal archives, providing unparalleled insights into Earth''s atmospheric history.

How do these archives form? In polar regions, snow rarely melts. Year after year, snow accumulates, and the sheer weight of subsequent layers compresses the underlying snow into a dense material called firn, which eventually becomes solid ice. Crucially, during this compaction process, tiny bubbles of air are permanently trapped within the ice matrix. These bubbles are literal, pristine samples of the ancient atmosphere.

By analysing the chemical composition of these trapped gases, particularly the ratio of oxygen isotopes, researchers can reconstruct past global temperatures. Specifically, a lower concentration of the heavier oxygen-18 isotope in the ice indicates a colder global climate. Conversely, high concentrations signify warmer, interglacial periods. Furthermore, the concentration of greenhouse gases, primarily carbon dioxide and methane, correlates perfectly with these temperature fluctuations, offering irrefutable evidence of their role in climate forcing.

However, ice cores tell us more than just temperature and gas levels. The ice also traps atmospheric particulates. The presence of dense layers of volcanic ash, or tephra, allows scientists to pinpoint massive historical eruptions. These tephra layers are invaluable because they serve as synchronous markers, allowing researchers to precisely align timelines across different ice cores extracted from opposite ends of the globe.

We also find traces of cosmic dust and variations in beryllium-10 isotopes. Because beryllium-10 is produced by cosmic rays bombarding the atmosphere, its abundance in the ice record allows us to track the historical intensity of solar activity and fluctuations in the Earth''s magnetic field.

Furthermore, the detection of sudden spikes in atmospheric sea salt and terrestrial dust concentrations is highly indicative of intensified global wind patterns, which typically occur during glacial maximums when increased aridity leads to widespread desertification.

Despite their immense value, ice core retrieval is fraught with challenges. Drilling thousands of meters into a moving glacier requires complex engineering. The cores must be maintained at strict sub-zero temperatures during transit to prevent any structural degradation or contamination. Moreover, at the deepest levels, extreme pressure can cause the ice to undergo brittle failure, fracturing the core and potentially destroying thousands of years of compressed climatic data. Finally, interpreting the data requires sophisticated modeling, as the age of the trapped gas is always significantly younger than the surrounding ice, a phenomenon known as the gas-age ice-age difference.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('1bc1e7e5-0c1d-41eb-88f8-9f405eaf7a54', '30f47c15-f5fb-4a10-b077-fe41850d18a8', 1,
 'sentence-completion', 'Complete the notes below. Write NO MORE THAN TWO WORDS for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('38a57fc4-98f5-4b15-9db5-cb0ed43b46ce', '1bc1e7e5-0c1d-41eb-88f8-9f405eaf7a54', 31,
 'Before becoming solid ice, compressed snow transforms into a material known as ________.', 'firn', '["firn","Firn"]'),
('18ba98bf-ea03-48dc-94fd-75874ed5a6cc', '1bc1e7e5-0c1d-41eb-88f8-9f405eaf7a54', 32,
 'Pristine samples of ancient air are preserved inside permanently trapped ________.', 'bubbles', '["bubbles","air bubbles","Bubbles"]'),
('fb1a947e-1105-4356-85bd-fb86e5dac17c', '1bc1e7e5-0c1d-41eb-88f8-9f405eaf7a54', 33,
 'To reconstruct historical global temperatures, scientists primarily analyze the ratio of ________.', 'oxygen isotopes', '["oxygen isotopes","Oxygen isotopes"]'),
('ec8a01b4-f712-433f-baeb-bac703c394ff', '1bc1e7e5-0c1d-41eb-88f8-9f405eaf7a54', 34,
 'A lower concentration of oxygen-18 indicates that the climate was ________.', 'colder', '["colder","Colder"]'),
('9d7e82af-a02c-4c59-bfc5-8941fce989f3', '1bc1e7e5-0c1d-41eb-88f8-9f405eaf7a54', 35,
 'Layers of volcanic ash act as highly useful ________ for aligning different core samples.', 'synchronous markers', '["synchronous markers","markers","Synchronous markers"]'),
('d022e388-be50-42fb-9c29-3be7260e6961', '1bc1e7e5-0c1d-41eb-88f8-9f405eaf7a54', 36,
 'Levels of beryllium-10 help track historical changes in the Earth''s ________.', 'magnetic field', '["magnetic field","Magnetic field"]'),
('b0aa193e-1db2-45a5-b9a2-c172766efb31', '1bc1e7e5-0c1d-41eb-88f8-9f405eaf7a54', 37,
 'Increases in terrestrial dust and sea salt indicate a period of intensified ________.', 'wind patterns', '["wind patterns","Wind patterns","global wind"]'),
('ddc87d35-f664-4f2d-86b5-a98f4b8f2367', '1bc1e7e5-0c1d-41eb-88f8-9f405eaf7a54', 38,
 'During transit, cores are kept at strict sub-zero temperatures to avoid structural ________.', 'degradation', '["degradation","Degradation"]'),
('4429bc67-1356-4d47-a6b9-f4a661e41ab2', '1bc1e7e5-0c1d-41eb-88f8-9f405eaf7a54', 39,
 'Deep ice under extreme pressure is susceptible to ________, which ruins data.', 'brittle failure', '["brittle failure","Brittle failure","fracturing"]'),
('08627b2a-9b4c-40a5-9383-6e9cbafa4744', '1bc1e7e5-0c1d-41eb-88f8-9f405eaf7a54', 40,
 'Because gas is younger than the surrounding ice, data interpretation requires sophisticated ________.', 'modeling', '["modeling","modelling","Modeling","Modelling"]');
 