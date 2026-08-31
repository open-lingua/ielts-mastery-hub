-- ============================================================
-- IELTS Practice Platform – Seed Data
-- Target: Listening Module (Band 9 Difficulty)
-- Description: Expert-level listening test featuring heavy 
-- paraphrasing, rapid and nuanced speech patterns, and highly 
-- technical/academic vocabulary to challenge top-tier candidates.
-- ============================================================

-- ████████████████████████████████████████████████████████████
-- ██  LISTENING TEST RECORD                                 ██
-- ████████████████████████████████████████████████████████████

INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status) VALUES
('6e807799-9003-40ad-b4be-c40e06c71709', '6f533c9e-8894-4a62-ab5c-f384efab49fd',
 'IELTS Expert Listening: Architectural Consultation, Geothermal Plant & Quantum Cryptography (Band 9)', '9', '40 mins', 'published');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 1: Transactional Dialogue (Architectural Booking)██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('f589ae87-667a-4a81-ae39-ff440b23f848', '6e807799-9003-40ad-b4be-c40e06c71709', 1,
 'Architectural Feasibility Consultation',
 'Agent: Good morning, Vanguard Architectural Associates. You are speaking with Eleanor. How may I direct your inquiry today?
Caller: Hello, Eleanor. My name is Julian Sterling. I am calling to commission a preliminary feasibility study for a commercial property my firm recently acquired. We are looking to do a comprehensive retrofit.
Agent: I can certainly assist you with setting up an initial consultation with one of our senior partners, Mr. Sterling. Firstly, to ensure we assign the correct specialist, could you classify the type of property? Is it a modern commercial build or an industrial facility?
Caller: It’s actually a late 19th-century industrial site. Specifically, a heritage warehouse situated in the docklands district. Initially, we toyed with the idea of a complete demolition to maximize the footprint, but the municipal preservation orders prohibit altering the exterior facade. 
Agent: A heritage warehouse. Excellent. That will require our historic conservation team. Now, what is the primary objective of this retrofit? Are you converting it into residential lofts or retail space?
Caller: Neither, actually. It is going to serve as our new corporate headquarters. Our main priority—and the biggest challenge given the brickwork—is achieving vastly improved insulation. We want the building to be entirely carbon-neutral, which means overhauling the thermal efficiency completely.
Agent: Carbon-neutral headquarters with improved insulation. We have extensive experience with eco-retrofits. Are there any existing structural compromises we should be aware of before conducting the survey?
Caller: Yes, the surveyor’s preliminary report flagged a significant issue. The roof trusses are surprisingly sound, but there is noticeable subsidence in the foundation. It will require extensive underpinning before any cosmetic work can begin.
Agent: Subsidence in the foundation. I’ll make a prominent note of that; our structural engineers will need to prioritize that in their load-bearing calculations. Now, regarding your timeline, do you have a rigid deadline for the submission of the architectural plans?
Caller: We do. We are applying for a specialized green energy grant from the government. The application window is incredibly strict; all technical schematics and planning permissions must be submitted before the 28th of October. If we miss that, we lose out on substantial funding. 
Agent: Understood. Plans required before the 28th of October. That gives us a tight, but manageable, three-month window. And in terms of financial scope, what is the absolute budget cap for the entire renovation project? 
Caller: We originally projected around ten million pounds. However, accounting for the underpinning and the bespoke environmental systems, the board has authorized a hard ceiling of 12.5 million pounds. We cannot exceed that figure under any circumstances.
Agent: 12.5 million pounds. Thank you. Given the complexities of a heritage site by the water, a standard structural evaluation won’t suffice. We will need to commission a detailed topographical assessment of the surrounding terrain to check for water table fluctuations. 
Caller: A topographical assessment. That makes sense. Please go ahead and arrange that.
Agent: I will. Could I please have a direct email address to send the initial contracts and non-disclosure agreements to?
Caller: Certainly. It’s my direct line. j.sterling@sterling.com. That’s J dot S-T-E-R-L-I-N-G. 
Agent: Excellent. Now, for the initial on-site consultation with our lead conservation architect, there is a standard pre-consultation fee. It is usually £600, but since this is a commercial heritage project, the subsidized rate is £450.
Caller: £450 is perfectly fine. Can I settle that via invoice?
Agent: Yes, our accounts department will attach the invoice to your contract. Finally, we need to schedule the introductory meeting here at our offices. Would next Tuesday at 10 AM in the Lancaster Room suit you?
Caller: The Lancaster Room at 10 AM. Yes, I have that penciled in. 
Agent: Wonderful. When you attend, please ensure you bring a physical copy of the deed. We cannot formally commence any legal planning without verifying property ownership.
Caller: A copy of the deed. I will have my legal team pull it from the archives. Thank you, Eleanor.
Agent: We look forward to meeting you, Mr. Sterling.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('9f1d827c-124f-4d5a-bbca-82ad99de3c25', 'f589ae87-667a-4a81-ae39-ff440b23f848', 1,
 'sentence-completion', 'Complete the form below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('f7678070-c5ae-4492-b5b4-89264ff6adcf', '9f1d827c-124f-4d5a-bbca-82ad99de3c25', 1,
 'Property type: Heritage ________', 'warehouse', '["warehouse","Warehouse"]'),
('867ec2a8-d1c7-427a-8817-47d054badf1b', '9f1d827c-124f-4d5a-bbca-82ad99de3c25', 2,
 'Primary objective: Improved ________', 'insulation', '["insulation","Insulation"]'),
('f63ae5de-7e75-4010-918a-8fc954b5ed8c', '9f1d827c-124f-4d5a-bbca-82ad99de3c25', 3,
 'Existing structural issue: Subsidence in the ________', 'foundation', '["foundation","Foundation"]'),
('52f32d22-69bb-48c9-b27d-9d8b10c69f3d', '9f1d827c-124f-4d5a-bbca-82ad99de3c25', 4,
 'Timeline: Must submit plans before ________', '28th October', '["28th October","28 October","October 28","October 28th"]'),
('b42b9a83-ff1f-4f63-8aa9-a0af760a8dd5', '9f1d827c-124f-4d5a-bbca-82ad99de3c25', 5,
 'Budget cap: £________ million', '12.5', '["12.5","12.50"]'),
('50d19e4c-6177-49cc-85f2-b17b08a1c2ce', '9f1d827c-124f-4d5a-bbca-82ad99de3c25', 6,
 'Required survey: Detailed ________ assessment', 'topographical', '["topographical","Topographical"]'),
('d30c6a99-b50d-43fc-981b-63eb4a776138', '9f1d827c-124f-4d5a-bbca-82ad99de3c25', 7,
 'Contact email: ________@sterling.com', 'j.sterling', '["j.sterling","J.sterling","J.Sterling"]'),
('a575cb56-76a7-4d50-ade0-bb0cb751512d', '9f1d827c-124f-4d5a-bbca-82ad99de3c25', 8,
 'Pre-consultation fee: £________', '450', '["450"]'),
('21559e39-fe77-46c6-849a-8d5a3daf2ec5', '9f1d827c-124f-4d5a-bbca-82ad99de3c25', 9,
 'Meeting location: The ________ Room', 'Lancaster', '["Lancaster","lancaster"]'),
('aef4bd7b-2833-46ab-8f94-275ae65e86c9', '9f1d827c-124f-4d5a-bbca-82ad99de3c25', 10,
 'Client must bring: A copy of the ________', 'deed', '["deed","Deed"]');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 2: Everyday Monologue (Geothermal Plant Tour)   ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('a72d4a56-f551-4526-9b51-26afb6a9eda0', '6e807799-9003-40ad-b4be-c40e06c71709', 2,
 'Enhanced Geothermal System Facility Tour',
 'Guide: Welcome, visiting engineering delegates, to the Obsidian Ridge Geothermal Plant. I’m Dr. Aris Thorne, the chief geophysicist here. Today, I’ll be walking you through one of the most advanced Enhanced Geothermal Systems, or EGS, currently operating globally. 

Now, many of you are familiar with conventional geothermal power, which relies on naturally occurring hydrothermal reservoirs. You just drill down and tap the trapped steam. However, we chose to implement an EGS facility here not because of a lack of financial capital or technological ambition, but strictly due to the geological limitations of the terrain. The bedrock beneath us is immensely hot but entirely impermeable—there is no natural water flow. Therefore, we have to artificially fracture the rock and inject our own fluids to harvest the thermal energy.

When this project was initially proposed, it faced substantial pushback from the surrounding municipality. While some environmental groups expressed mild concern over the visual impact of the cooling towers on the landscape, the overwhelming grievance from local residents was the fear of induced seismicity. Because our process involves high-pressure hydraulic stimulation deep underground, the public was terrified we would trigger minor earthquakes. We had to spend three years installing a dense seismic monitoring network to prove our operations remain well below the threshold of human perception.

One of the greatest triumphs of this plant is our resource management. In older plants, the geothermal brine—the superheated, mineral-rich water brought to the surface—was often discharged into evaporation ponds, leading to heavy metal contamination. Here, however, we utilize a strictly closed-loop system. After the heat is extracted to spin the turbines, 100% of the cooled brine is re-injected deep into the earth to maintain reservoir pressure. Absolutely nothing is vented into the local watershed.

Interestingly, this closed-loop brine circulation led to a highly lucrative, unexpected benefit. While analyzing the chemical composition of the returning fluids, our chemists realized the subterranean brine was unusually saturated with dissolved minerals. We quickly retrofitted the plant, and we are now successfully executing the extraction of rare earth elements, specifically lithium, which is in massive demand for battery manufacturing. It’s transformed the economic viability of the entire operation.

Before we move into the facility, a vital note on health and safety. You’ve all been issued hard hats and high-visibility vests. However, the ambient noise in the turbine hall routinely exceeds 105 decibels. Consequently, the use of mandatory hearing protection is enforced at all times within that specific sector. Anyone found removing their ear defenders will be immediately escorted off the premises. 

Please refer to the schematic map on your tablets. We are currently gathered at the Visitor Briefing Centre, located in the lower left corner of the site.

From the Visitor Centre, walk straight along the main paved thoroughfare. The first structure you’ll see on your right is a massive, reinforced concrete pad. This is the Injection Well, where cold water is pumped three kilometers down into the artificial fractures.

If you continue up the main thoroughfare, you will reach a central roundabout. Just beyond the roundabout, slightly to the left, is a tall, cylindrical tower with steam occasionally venting from safety valves. This is the Steam Separator. It depressurizes the superheated fluid coming up from the production well, flashing it into pure steam to drive the turbines.

Directly opposite the Steam Separator, on the right side of the roundabout, is a wide, flat building with multiple external pipes. This is the Brine Crystallizer, which manages the silica levels in the water to prevent our pipes from scaling up and clogging.

Now, take the path leading right from the roundabout. At the very end of this path, securely fenced off due to the high-voltage equipment, sits the Substation. This is where the mechanical energy is converted to electrical energy and fed directly into the national grid. 

Finally, returning to the roundabout, take the path leading left. Tucked behind the Steam Separator, you will find a newly constructed, modular building. This is the Lithium Extraction Unit, our newest addition, where the rare earth elements are chemically filtered from the cooled brine before re-injection.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('9da733db-dcff-456d-bd42-c37bf4b946fd', 'a72d4a56-f551-4526-9b51-26afb6a9eda0', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('4fd0c3e5-baee-40cc-803f-c4b6855c6bbe', '9da733db-dcff-456d-bd42-c37bf4b946fd', 11,
 'Why did the facility choose to implement an Enhanced Geothermal System (EGS)?',
 '["A. To secure additional financial capital from investors", "B. Due to the geological limitations of impermeable bedrock", "C. To showcase their technological ambition to competitors"]', 'B'),
('88ce01ab-f5bb-4552-a2a9-fded46c71cf4', '9da733db-dcff-456d-bd42-c37bf4b946fd', 12,
 'What was the primary concern of the local residents regarding the plant?',
 '["A. The visual pollution of the cooling towers", "B. Contamination of the local water supply", "C. The risk of induced seismicity"]', 'C'),
('651867ac-6298-4440-96db-daa07aea6825', '9da733db-dcff-456d-bd42-c37bf4b946fd', 13,
 'How does the plant manage the extracted geothermal brine?',
 '["A. It is entirely re-injected in a closed-loop system", "B. It is discharged safely into evaporation ponds", "C. It is vented as harmless steam into the atmosphere"]', 'A'),
('22c99ed8-70e5-4e40-9bbf-3e127eb438ac', '9da733db-dcff-456d-bd42-c37bf4b946fd', 14,
 'What unexpected economic benefit was discovered during operations?',
 '["A. High demand for surplus heat from local agriculture", "B. The extraction of rare earth elements like lithium", "C. The ability to sell purified drinking water"]', 'B'),
('f424cbd1-e0a7-4810-9792-3ff4e563ffd6', '9da733db-dcff-456d-bd42-c37bf4b946fd', 15,
 'What strict safety protocol applies specifically to the turbine hall?',
 '["A. High-visibility vests must be worn", "B. Hard hats are required at all times", "C. Mandatory hearing protection must be used"]', 'C');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('7b5044d9-4f06-424a-a306-3c72609f42c3', 'a72d4a56-f551-4526-9b51-26afb6a9eda0', 2,
 'matching', 'Label the map below. Write the correct letter, A-H, next to Questions 16-20.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('9188c11e-02ab-4257-9ce3-37cdea664438', '7b5044d9-4f06-424a-a306-3c72609f42c3', 16,
 'Injection Well', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'D'),
('764500c2-3da9-461a-a0bf-50392675d325', '7b5044d9-4f06-424a-a306-3c72609f42c3', 17,
 'Steam Separator', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'A'),
('1e643ab2-2d75-448d-8f50-d05f6c95a3be', '7b5044d9-4f06-424a-a306-3c72609f42c3', 18,
 'Brine Crystallizer', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'G'),
('2ae39399-c3e1-4e5d-8c86-e698fec9b556', '7b5044d9-4f06-424a-a306-3c72609f42c3', 19,
 'Substation', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'C'),
('c5a61600-afff-40cd-881e-810d0b95012f', '7b5044d9-4f06-424a-a306-3c72609f42c3', 20,
 'Lithium Extraction Unit', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'F');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 3: Academic Dialogue (Synthetic Biology)        ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('7a2a538a-9a95-432a-9063-d09ff5bb41fe', '6e807799-9003-40ad-b4be-c40e06c71709', 3,
 'Governance and Ethics of Synthetic Biology',
 'Tutor: Good afternoon, Maya, Liam. Let’s review the progress on your joint dissertation regarding the governance of synthetic biology. Maya, you seemed quite frustrated in your last email regarding the current regulatory landscape.
Maya: Frustrated is an understatement, Dr. Vance. Initially, I thought the primary barrier to safe synthetic biology was technological capability. But after diving into the legal frameworks, it’s clear that current regulations are dangerously fragmented across jurisdictions. What is strictly prohibited in the EU might be entirely unregulated in parts of Southeast Asia, creating massive loopholes for rogue actors.
Liam: I ran into a different wall entirely. When I began the literature review on the ethical implications, I found that the vast majority of peer-reviewed papers focused purely on the technical aspects of gene editing—crispr efficiencies, off-target mutations—rather than the societal or ethical ramifications. Finding robust philosophical critiques was surprisingly difficult. 
Tutor: That’s a classic manifestation of science outpacing philosophy. Now, a core part of your thesis addresses open-source genetic databases—where scientists publish synthetic DNA sequences freely online. What is your joint consensus on this?
Maya: It’s a double-edged sword. On one hand, democratizing access undeniably accelerates innovation. Startups can iterate on existing genetic codes to develop new biofuels or drought-resistant crops exponentially faster. 
Liam: But we absolutely agree that this open-access model poses severe biosecurity risks. If the genetic sequence for a highly virulent synthetic pathogen is publicly available, it lowers the barrier to entry for bioterrorism to terrifying levels. The dual-use dilemma is incredibly stark here.
Tutor: A very nuanced stance. To strengthen your argument, your methodology needs refinement. You can’t just rely on theoretical ethical frameworks. I strongly suggest you incorporate a comparative analysis of international treaties, specifically looking at how treaties governing nuclear proliferation might be adapted for synthetic biological agents. 
Maya: That’s a brilliant pivot. We can look at the Biological Weapons Convention of 1972 and identify its modern inadequacies. 
Liam: Speaking of inadequacies, we need to decide the exact scope of our research. Synthetic biology is vast. Are we including the bio-hacking community? You know, the Do-It-Yourself community labs where amateurs edit bacterial DNA in their garages?
Maya: I think we should exclude the DIY community labs entirely. While they are a fascinating sociological phenomenon, their actual capability to engineer complex, dangerous pathogens is currently minimal due to resource constraints. We need to focus strictly on state-sponsored and corporate laboratories where the real existential risks reside.
Tutor: I agree with that exclusion; keep the scope tight. Now, you must critically evaluate the leading academics in this space. Let’s run through some prominent theorists. What did you make of Dr. Helen Varma’s work?
Maya: Varma is very pragmatic. Because predicting the behavior of synthetic organisms in the wild is impossible, she proposes strict liability frameworks. Essentially, if a corporation engineers an organism that causes ecological damage, they are held absolutely legally and financially responsible, regardless of intent.
Tutor: Correct. And how does Professor K. Chen approach it?
Liam: Chen is the ultimate free-market optimist. He vehemently opposes heavy-handed government intervention, arguing that economic incentives naturally regulate synthetic risks. He believes insurance markets will refuse to underwrite genuinely dangerous experiments, effectively self-policing the industry.
Tutor: An interesting, if controversial, view. What about Dr. Simon Vance?
Maya: Vance is highly critical of top-down governmental regulation, viewing it as slow and scientifically illiterate. Instead, he advocates for decentralized, community-led oversight, where local scientific boards and citizen scientists audit bio-labs in their own municipalities.
Tutor: Excellent summary. And Dr. Alicia Moreno?
Liam: Moreno represents the most cautious extreme. She argues that because the risks of synthetic biology are potentially existential, we cannot afford trial and error. She emphasizes the urgent need for preemptive international moratoriums on specific types of research, like synthetic gene drives, until global consensus is reached.
Tutor: Finally, let’s look at Julian Thorne’s sociological perspective.
Maya: Thorne takes a step back from the science. He argues that the actual risks are secondary; he believes public perception is the primary barrier to adoption. If the public views synthetic biology as unnatural or terrifying, political pressure will crush the industry before it even matures, regardless of its safety profile. 
Tutor: Your grasp of the conflicting viewpoints is incredibly strong. If you structure the literature review to highlight these tensions, you will achieve a very high mark.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('9e1a1ebb-36c1-42e7-962a-4ddf80a95943', '7a2a538a-9a95-432a-9063-d09ff5bb41fe', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('ef0feded-ccf2-40d2-bb0f-0b9c72167845', '9e1a1ebb-36c1-42e7-962a-4ddf80a95943', 21,
 'Maya feels that current synthetic biology regulations are...',
 '["A. Overly restrictive on corporate innovation", "B. Driven by public panic rather than science", "C. Dangerously fragmented across jurisdictions"]', 'C'),
('5253b7d0-09b9-4690-9046-4feee79acab9', '9e1a1ebb-36c1-42e7-962a-4ddf80a95943', 22,
 'Liam initially struggled with his literature review because...',
 '["A. Most papers focused purely on technical aspects rather than ethics", "B. The terminology used in older papers was outdated", "C. He could not access secure government databases"]', 'A'),
('0f840424-185b-475f-bd2f-4c05e255a9b5', '9e1a1ebb-36c1-42e7-962a-4ddf80a95943', 23,
 'What do both students agree about open-source genetic databases?',
 '["A. They are essential for preventing corporate monopolies", "B. They accelerate innovation but pose severe biosecurity risks", "C. They should be restricted solely to university researchers"]', 'B'),
('8e1ed1e7-8cdd-4316-8991-e712fb5d9e0c', '9e1a1ebb-36c1-42e7-962a-4ddf80a95943', 24,
 'The tutor suggests that their methodology should...',
 '["A. Focus on conducting original laboratory experiments", "B. Interview scientists currently working in bio-labs", "C. Incorporate comparative analysis of international treaties"]', 'C'),
('7c774b3b-76e0-4fc6-bbbf-3a4093818436', '9e1a1ebb-36c1-42e7-962a-4ddf80a95943', 25,
 'What aspect of "bio-hacking" will they exclude from their study?',
 '["A. Do-It-Yourself community labs", "B. Corporate espionage operations", "C. State-sponsored military research"]', 'A');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('6095d9e7-72fd-4b9a-8158-79e7ada6b7e1', '7a2a538a-9a95-432a-9063-d09ff5bb41fe', 2,
 'matching', 'Match the following researchers to their primary theoretical viewpoints. Choose the correct letter, A-F.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('891f08e1-27db-4a0d-8f89-54a4259fa0f5', '6095d9e7-72fd-4b9a-8158-79e7ada6b7e1', 26,
 'Dr. Helen Varma', 
 '["A. Argues that economic incentives naturally regulate synthetic risks.", "B. Believes public perception is the primary barrier to adoption.", "C. Suggests that open-source DNA should be heavily encrypted.", "D. Advocates for decentralized, community-led oversight.", "E. Proposes strict liability frameworks for engineered organisms.", "F. Emphasizes the need for preemptive international moratoriums."]', 'E'),
('63a27d00-0c2e-4f40-90fd-74c0d2712609', '6095d9e7-72fd-4b9a-8158-79e7ada6b7e1', 27,
 'Professor K. Chen', 
 '["A. Argues that economic incentives naturally regulate synthetic risks.", "B. Believes public perception is the primary barrier to adoption.", "C. Suggests that open-source DNA should be heavily encrypted.", "D. Advocates for decentralized, community-led oversight.", "E. Proposes strict liability frameworks for engineered organisms.", "F. Emphasizes the need for preemptive international moratoriums."]', 'A'),
('fb1bff95-0285-44d5-ba15-1c54d04340a8', '6095d9e7-72fd-4b9a-8158-79e7ada6b7e1', 28,
 'Dr. Simon Vance', 
 '["A. Argues that economic incentives naturally regulate synthetic risks.", "B. Believes public perception is the primary barrier to adoption.", "C. Suggests that open-source DNA should be heavily encrypted.", "D. Advocates for decentralized, community-led oversight.", "E. Proposes strict liability frameworks for engineered organisms.", "F. Emphasizes the need for preemptive international moratoriums."]', 'D'),
('966a396a-82e1-40da-a4d8-7346827e3961', '6095d9e7-72fd-4b9a-8158-79e7ada6b7e1', 29,
 'Dr. Alicia Moreno', 
 '["A. Argues that economic incentives naturally regulate synthetic risks.", "B. Believes public perception is the primary barrier to adoption.", "C. Suggests that open-source DNA should be heavily encrypted.", "D. Advocates for decentralized, community-led oversight.", "E. Proposes strict liability frameworks for engineered organisms.", "F. Emphasizes the need for preemptive international moratoriums."]', 'F'),
('52625e59-f768-4808-835a-20ef2a8872c2', '6095d9e7-72fd-4b9a-8158-79e7ada6b7e1', 30,
 'Julian Thorne', 
 '["A. Argues that economic incentives naturally regulate synthetic risks.", "B. Believes public perception is the primary barrier to adoption.", "C. Suggests that open-source DNA should be heavily encrypted.", "D. Advocates for decentralized, community-led oversight.", "E. Proposes strict liability frameworks for engineered organisms.", "F. Emphasizes the need for preemptive international moratoriums."]', 'B');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 4: Academic Monologue (Quantum Cryptography)    ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('0230b768-d1ac-480e-81de-b86d15403379', '6e807799-9003-40ad-b4be-c40e06c71709', 4,
 'Quantum Key Distribution and Post-Quantum Security',
 'Professor: Welcome back to our advanced module on Information Security. Today, we are peering over the horizon of current technological capabilities to discuss the imminent threat to global data security, and the physics-based solution racing to prevent it: Quantum Key Distribution, or QKD.

To appreciate the necessity of QKD, we must first understand the fragility of our current digital infrastructure. Modern encryption—the protocols securing everything from your WhatsApp messages to global banking networks—relies heavily on public-key cryptography, such as RSA. The security of these algorithms is entirely predicated on computational complexity. Specifically, they rely on the premise that classical computers cannot factorize massive prime numbers within a practical timeframe. It would take a supercomputer thousands of years to crack a standard 2048-bit encryption key. 

However, this foundational security is teetering on the edge of obsolescence due to the rapid advancement of quantum computing. A fully functional, large-scale quantum computer could utilize Shor’s algorithm to factorize these massive primes exponentially faster. What takes a classical computer millennia could take a quantum computer mere hours. When that threshold is crossed—an event cryptographers ominously refer to as "Q-Day"—all traditional encryption becomes fundamentally useless. 

Enter Quantum Key Distribution. Unlike classical cryptography, which relies on mathematical difficulty, QKD secures data using the immutable laws of quantum mechanics. The core concept leverages a phenomenon known as quantum superposition. In a typical QKD setup, two parties—conventionally named Alice and Bob—generate a shared, secret cryptographic key by transmitting individual photons of light over a fiber-optic cable. 

Because these photons are in a state of quantum superposition, they possess multiple possible polarization states simultaneously until they are measured. This brings us to the Heisenberg Uncertainty Principle, which dictates that the very act of measuring a quantum system inextricably alters it. Therefore, if a malicious third party—let’s call her Eve—attempts to intercept and read the photon stream, her observation causes the quantum waveform to collapse, permanently altering the fundamental state of the photons. Alice and Bob will immediately detect this elevated error rate, realize the channel is compromised, and discard the key. It is theoretically unhackable.

The most widely implemented method for achieving this is the BB84 protocol, developed in 1984. It uses four distinct polarization states to encode binary data, ensuring that any eavesdropping introduces a statistically predictable margin of error that legitimate users can monitor.

Despite its mathematical elegance, implementing QKD in the real world presents colossal engineering challenges. The most pressing limitation is signal attenuation. As photons travel through standard silica fiber-optic cables, they are gradually absorbed or scattered. Currently, the maximum reliable distance for fiber-based QKD is roughly 100 to 150 kilometers. To bridge global distances without compromising the quantum state, researchers are desperately trying to engineer reliable quantum repeaters. These devices would utilize quantum entanglement to effectively teleport the quantum state down the line, bypassing the attenuation problem, but they remain largely in the experimental phase.

Furthermore, while the theoretical physics of QKD is flawless, the practical implementations often contain flaws. Hackers don’t try to break the laws of physics; they target the physical hardware. For instance, the highly sensitive avalanche photodiode detectors used to register the incoming photons can be temporarily blinded by a bright, targeted laser pulse, allowing an attacker to manipulate the detector’s output without triggering the quantum alarm. 

To circumvent the fiber-optic distance limitations, the frontier of QKD has moved into orbit. In 2017, the Chinese satellite Micius successfully established a quantum-secured video conference between Beijing and Vienna. By utilizing the vacuum of space where photon scattering is negligible, satellite-based QKD recently achieved a verified transmission distance of over a thousand kilometers, shattering terrestrial records. 

Ultimately, the global integration of these technologies—combining secure fiber networks in cities with satellite links across oceans—aims to construct a fundamentally impenetrable quantum internet, ensuring data privacy in the post-quantum era.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('600ff4e7-0026-4c1a-8a96-da8716afb3bf', '0230b768-d1ac-480e-81de-b86d15403379', 1,
 'sentence-completion', 'Complete the notes below. Write NO MORE THAN ONE WORD for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('f15f6e70-3720-4730-b32b-0ae6c3680393', '600ff4e7-0026-4c1a-8a96-da8716afb3bf', 31,
 'Traditional cryptography relies on computational ________.', 'complexity', '["complexity","Complexity"]'),
('89ffe073-b44f-440f-a453-9de5ed6221aa', '600ff4e7-0026-4c1a-8a96-da8716afb3bf', 32,
 'Quantum computers threaten current encryption using Shor’s ________.', 'algorithm', '["algorithm","Algorithm"]'),
('e33cfa95-2dcd-4599-b9b4-5c41848f6e1b', '600ff4e7-0026-4c1a-8a96-da8716afb3bf', 33,
 'QKD utilizes the principles of quantum mechanics, specifically ________.', 'superposition', '["superposition","Superposition"]'),
('97ade8d9-0a90-452c-9e01-d23d573e0507', '600ff4e7-0026-4c1a-8a96-da8716afb3bf', 34,
 'Any attempt to intercept the key alters its fundamental ________.', 'state', '["state","State"]'),
('9f69ed50-298c-4958-9e4e-cb1559ca1237', '600ff4e7-0026-4c1a-8a96-da8716afb3bf', 35,
 'The most common protocol used in QKD is known as ________.', 'BB84', '["BB84","bb84"]'),
('885e0c42-0490-4e6b-b751-26ee8bcc740f', '600ff4e7-0026-4c1a-8a96-da8716afb3bf', 36,
 'A major technical limitation of QKD is signal ________ over long distances.', 'attenuation', '["attenuation","Attenuation"]'),
('cb972ce1-f1a8-4cb3-b694-471d0189b998', '600ff4e7-0026-4c1a-8a96-da8716afb3bf', 37,
 'To solve this, researchers are developing quantum ________.', 'repeaters', '["repeaters","Repeaters"]'),
('d0d7d5fc-f121-4602-a122-cef55e18c0d0', '600ff4e7-0026-4c1a-8a96-da8716afb3bf', 38,
 'Another vulnerability lies in the physical ________ used for photon detection.', 'hardware', '["hardware","Hardware"]'),
('df0d0ca9-609b-42c2-aa0b-d6d5f790d18e', '600ff4e7-0026-4c1a-8a96-da8716afb3bf', 39,
 'Satellite-based QKD recently achieved a transmission distance of over a ________ kilometers.', 'thousand', '["thousand","Thousand","1000"]'),
('c70a22d4-dfd4-4fcf-9d77-b87a9b782fa4', '600ff4e7-0026-4c1a-8a96-da8716afb3bf', 40,
 'The ultimate goal is a globally secure quantum ________.', 'internet', '["internet","Internet"]');
