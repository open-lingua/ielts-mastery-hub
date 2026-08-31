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
('ed22087f-0fe9-43b4-94a1-88f11cdd338c', '6f533c9e-8894-4a62-ab5c-f384efab49fd',
 'IELTS Advanced Listening: Freight Logistics, Desalination Plant & Space Economics (Band 8)', '8', '40 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 1: Transactional Dialogue (Freight Booking)     ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('ec7919db-514d-4260-bd56-270a25002c70', 'ed22087f-0fe9-43b4-94a1-88f11cdd338c', 1,
 'International Freight Booking',
 'Agent: Good afternoon, Apex Global Logistics. You are speaking with Marcus. How can I assist you with your shipping needs today?
Client: Hello, Marcus. I need to arrange an expedited international shipment for some highly sensitive medical equipment. We have used your standard freight service in the past, but this is a rather urgent dispatch to a new client facility overseas.
Agent: I can certainly help you arrange an expedited dispatch. First, could I get your company name and account number, just so I can pull up your existing profile on our system?
Client: Yes, of course. The company name is Bio-Metrics Limited. That’s spelled B-I-O hyphen M-E-T-R-I-C-S. 
Agent: Thank you. And the account number?
Client: It’s an alphanumeric code: A-R-T 5-5-9-2.
Agent: Let me just type that in... A-R-T 5-5-9-2. Yes, I have your profile right here. The primary contact is listed as Helen Cho. Is that you?
Client: No, Helen moved to our European branch last month. I am the new logistics coordinator. My name is David Aris. That’s A-R-I-S. 
Agent: I will update the contact details now, David. Now, where exactly is this expedited shipment heading? You mentioned an overseas facility.
Client: Yes, it needs to be flown to Japan. Specifically, to a medical research institute located in Kyoto. 
Agent: Kyoto, Japan. Understood. Now, I need some specific details about the cargo itself to determine the appropriate handling protocols. What exactly is the item being shipped?
Client: It is a diagnostic scanner used for neurological imaging. It is incredibly delicate and sensitive to environmental changes.
Agent: A diagnostic scanner. I will flag that as fragile. You mentioned it is sensitive to environmental changes. Does it require a climate-controlled container during transit?
Client: It does. It cannot be exposed to extreme heat. The maximum temperature it can endure during transit is 15 degrees Celsius. If it gets any warmer than that, the internal calibration gets completely ruined. 
Agent: Noted. Maximum temperature: 15 degrees Celsius. We will use a refrigerated unit for that. Now, what are the exact dimensions and weight of the crate?
Client: The crate is rectangular. It is exactly 1.2 metres wide, and the height is 0.8 metres. The depth is 1 metre flat. 
Agent: So that’s 1.2 metres wide by 0.8 metres high. And the total gross weight?
Client: With the protective packaging, it comes to exactly 145 kilograms. 
Agent: Thank you. Given the value and fragility of the scanner, which level of insurance coverage would you like to select? We offer Basic, Standard, and Comprehensive cover.
Client: Because of the high replacement cost, our company policy mandates that we take out Comprehensive cover for anything over 100 kilograms. 
Agent: Comprehensive cover selected. Now, regarding the collection timeline, when will the crate be ready for our drivers to pick up?
Client: Today is the 21st. We need two more days to finalize the shock-absorbent packaging, so it will be ready for collection first thing in the morning on the 24th of November.
Agent: The 24th of November. I’ll schedule a morning slot. Just a logistical note for the driver—our records show your facility is on a busy main road. Where exactly should the truck park for loading?
Client: Please instruct the driver to avoid the main entrance on the East side. They need to turn down the alleyway and park at the South entrance. We have a dedicated loading bay there with a forklift ready to assist.
Agent: South entrance. Perfect. Finally, because this is an international shipment of medical technology, there is one crucial document we need before the truck leaves your site. The driver cannot take the cargo unless you provide a physically signed customs declaration. 
Client: A signed customs declaration. I already have the digital forms filled out, so I’ll print them and have our director sign them today. 
Agent: Excellent. I will process this quote and email you the final tracking itinerary within the hour. Is there anything else you need, David?
Client: No, Marcus, that covers everything. Thank you for the efficient service.
Agent: My pleasure. Have a great day.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('4cc12958-6b64-4baa-bddc-95a78378d9d8', 'ec7919db-514d-4260-bd56-270a25002c70', 1,
 'sentence-completion', 'Complete the booking form below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('81535762-aedf-43bc-995a-c1b2067e1c50', '4cc12958-6b64-4baa-bddc-95a78378d9d8', 1,
 'Company Name: Bio-Metrics ________', 'Limited', '["Limited","limited","LIMITED"]'),
('ebbbe77f-a708-4852-866f-5d60deb402bd', '4cc12958-6b64-4baa-bddc-95a78378d9d8', 2,
 'Account Number: ART ________', '5592', '["5592"]'),
('43509e90-5a2e-4e60-b41e-8d80ab28bcf9', '4cc12958-6b64-4baa-bddc-95a78378d9d8', 3,
 'Destination city: ________', 'Kyoto', '["Kyoto","kyoto"]'),
('7270ed94-2330-477c-b2ee-675054d07c30', '4cc12958-6b64-4baa-bddc-95a78378d9d8', 4,
 'Item being shipped: A diagnostic ________', 'scanner', '["scanner","Scanner"]'),
('7973e9b9-3cb9-4264-a7a9-a2e6800e77da', '4cc12958-6b64-4baa-bddc-95a78378d9d8', 5,
 'Maximum temperature during transit: ________ degrees', '15', '["15","fifteen","Fifteen"]'),
('e822fa5a-fe97-419b-a0ed-a19ceb84093d', '4cc12958-6b64-4baa-bddc-95a78378d9d8', 6,
 'Dimension of crate: 1.2 metres wide by ________ metres high', '0.8', '["0.8",".8","zero point eight"]'),
('6103b961-06bd-4b41-a7ef-7839f0cde8d9', '4cc12958-6b64-4baa-bddc-95a78378d9d8', 7,
 'Type of insurance selected: ________ cover', 'Comprehensive', '["Comprehensive","comprehensive"]'),
('647d8063-6ead-437b-afae-258add2b0951', '4cc12958-6b64-4baa-bddc-95a78378d9d8', 8,
 'Collection date: ________', '24th November', '["24 November","November 24","24th of November"]'),
('213352fe-161c-4855-964b-fa5916fd0356', '4cc12958-6b64-4baa-bddc-95a78378d9d8', 9,
 'Driver needs to park at the ________ entrance', 'South', '["South","south"]'),
('8955115f-b0e9-40f6-8211-d05a40af17ad', '4cc12958-6b64-4baa-bddc-95a78378d9d8', 10,
 'Customer must provide a signed ________', 'customs declaration', '["customs declaration","Customs declaration","Customs Declaration"]');

-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 2: Monologue (Desalination Plant Tour)          ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('937625c4-ded2-43a8-b81e-638275d2b527', 'ed22087f-0fe9-43b4-94a1-88f11cdd338c', 2,
 'Desalination Facility Orientation',
 'Guide: Good morning, ladies and gentlemen, and welcome to the Seaview Desalination and Water Treatment Facility. My name is Dr. Aris Thorne, and I am the lead operations manager here. I will be guiding you through one of the most advanced reverse-osmosis plants in the country. 

Before we commence our physical tour, I want to give you a brief overview of the plant’s recent history and our operational protocols. You might be aware that the plant underwent a massive fifty-million-dollar upgrade two years ago. While many locals assumed this was to expand our total water output capacity to meet population growth, the actual primary objective was to increase overall energy efficiency. Desalination is notoriously power-hungry, and our new turbines have successfully cut our electricity consumption by twenty percent. 

We rely heavily on consistency, but nature occasionally intervenes. Last summer, we experienced a brief shutdown. Some reports in the media falsely claimed we had a chemical leak, but in reality, an unexpected algae bloom in the bay completely clogged our primary intake filters, forcing us to halt operations for forty-eight hours to clear the biomass. We have since installed ultrasonic deterrents to prevent a recurrence.

A common misconception among the public is that the water coming out of our reverse-osmosis membranes is instantly ready to drink. The truth is quite the opposite. The filtration process is so aggressively thorough that it strips away absolutely everything—leaving pure, distilled H2O. This water is actually quite acidic and tasteless. Therefore, it requires extensive remineralization—where we artificially add calcium and magnesium back into the water—before it meets municipal health standards. 

Now, for your own safety today, you are required to wear high-visibility vests at all times, which you have already been given. However, when we enter the chemical testing areas, it is mandatory that everyone wears safety goggles. We will provide these at the door of that specific sector. Hard hats are not required on this specific route, but please wear the goggles when instructed.

To give you a sense of our scale, this single facility supplies just under a third of the entire region’s fresh water. While there are talks of building a second plant to push that figure over fifty percent, for now, we operate at a steady thirty percent. 

Please direct your attention to the laminated maps on your clipboards. We are currently standing in the Visitor Centre, located at the very bottom of the map by the main road. 

Let’s trace our route. When we leave the Visitor Centre, we will walk straight up the central path. The very first building you will encounter on your left is the Primary Intake Pumps. This is where millions of gallons of raw seawater are sucked into the facility daily. 

If you continue up the central path, you will come to a T-junction. If you look to the building occupying the top-right corner of this junction, that is the Coagulation Basins. Here, chemicals are added to make large particles clump together so they can be removed. 

Taking a left at the T-junction, the path takes a sharp curve towards the coast. At the very end of this curved path, situated closest to the ocean, is our massive Reverse Osmosis Hall. This is the true heart of the plant, housing thousands of membrane cylinders. 

Now, heading back to the T-junction, if you walk straight ahead past the junction, you will see a pair of tall, cylindrical structures directly on your left. These are the Remineralization Silos, where the essential minerals are reintroduced into the purified water. 

Finally, right opposite the silos, on the right side of the path, is a heavily fortified, windowless building. That is the Main Control Room. From there, our engineers monitor pressure levels across the entire grid. We won’t go inside, but you will see it through the observation glass.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('f26eb9fc-5297-4260-885f-f5f83a8ed4f2', '937625c4-ded2-43a8-b81e-638275d2b527', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('79f48de3-3699-4bcb-b818-b6470e7844ad', 'f26eb9fc-5297-4260-885f-f5f83a8ed4f2', 11,
 'Why was the desalination plant upgraded recently?',
 '["A. To expand total water output for a growing population", "B. To increase overall energy efficiency", "C. To improve the taste of the purified water"]', 'B'),
('c327bfef-7f8c-4c61-a59b-f709ed788dd2', 'f26eb9fc-5297-4260-885f-f5f83a8ed4f2', 12,
 'What caused the plant to shut down briefly last summer?',
 '["A. An unexpected algae bloom", "B. A dangerous chemical leak", "C. A failure in the main power grid"]', 'A'),
('fd7e6e46-f4b2-48a1-9a53-8e4fb15d3586', 'f26eb9fc-5297-4260-885f-f5f83a8ed4f2', 13,
 'What does the guide emphasize about the water immediately after reverse osmosis?',
 '["A. It is ready for public consumption", "B. It is distilled and requires remineralization", "C. It contains high levels of beneficial minerals"]', 'B'),
('f2301bdf-a9c1-423a-acc4-14409a967667', 'f26eb9fc-5297-4260-885f-f5f83a8ed4f2', 14,
 'What safety equipment must visitors wear in the chemical testing areas?',
 '["A. High-visibility vests", "B. Hard hats", "C. Safety goggles"]', 'C'),
('2180ae66-1a56-4ce0-baa6-161b9fe8adae', 'f26eb9fc-5297-4260-885f-f5f83a8ed4f2', 15,
 'How much of the region''s fresh water does the facility currently supply?',
 '["A. Exactly fifty percent", "B. Just under a third", "C. Less than twenty percent"]', 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('277ce3ba-e09e-463a-9454-7f4d414cb8f5', '937625c4-ded2-43a8-b81e-638275d2b527', 2,
 'matching', 'Label the map below. Write the correct letter, A-H, next to Questions 16-20.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('009caca2-56e4-4ccb-9ba6-377ce6ab5646', '277ce3ba-e09e-463a-9454-7f4d414cb8f5', 16,
 'Primary Intake Pumps', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'C'),
('16bc258c-31ea-44e9-8d40-7fa1c846367a', '277ce3ba-e09e-463a-9454-7f4d414cb8f5', 17,
 'Coagulation Basins', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'F'),
('8842d10d-7d8a-4095-9231-e88b51cb6f77', '277ce3ba-e09e-463a-9454-7f4d414cb8f5', 18,
 'Reverse Osmosis Hall', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'A'),
('9601db0e-ea77-4a45-80ad-05b5a8c96cc4', '277ce3ba-e09e-463a-9454-7f4d414cb8f5', 19,
 'Remineralization Silos', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'D'),
('9f95797c-1bc4-4bd2-a3d5-0ed9f952f8a0', '277ce3ba-e09e-463a-9454-7f4d414cb8f5', 20,
 'Main Control Room', '["A", "B", "C", "D", "E", "F", "G", "H"]', 'E');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 3: Academic Dialogue (Behavioral Economics)     ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('6ed6df3a-8db8-481a-bc56-b14d3990476a', 'ed22087f-0fe9-43b4-94a1-88f11cdd338c', 3,
 'Behavioral Economics: Nudge Theory and Choice Architecture',
 'Tutor: Come in, Eleanor, Julian. Take a seat. Let’s look at the progress of your joint assignment on behavioral economics. You’ve chosen to focus heavily on "Nudge Theory" and choice architecture.
Eleanor: Yes, Dr. Vance. When I first read about the concept, I assumed it was a form of psychological manipulation. But I was actually quite surprised to find that its core principle is preserving freedom of choice. It alters behavior predictably, but without forbidding any options or changing economic incentives. 
Julian: That’s the theory, anyway. I’m a bit more sceptical. We’ve been reviewing some of the classic case studies, like the organ donation opt-out systems used in parts of Europe. 
Tutor: A seminal study. What was your critique of it, Julian? Did you find the data on increased registration rates unconvincing?
Julian: The data is mathematically sound—opt-out systems clearly yield higher registration than opt-in systems. My issue is that the researchers entirely ignored deeply ingrained cultural factors regarding medical ethics in those specific countries. You can’t just attribute the success solely to the default option without acknowledging the societal context.
Tutor: An excellent point of critical analysis. Make sure you highlight that methodological flaw in your essay. Now, what about the cafeteria food placement studies? That’s the classic example of choice architecture: putting fruit at eye level to encourage healthy eating.
Eleanor: We both looked at that. I argued that it is a brilliant, low-cost public health strategy. 
Julian: And I argued that it treats adults like children incapable of making rational dietary decisions. 
Tutor: Despite your ideological differences, what did the empirical data lead you to agree upon?
Eleanor: Well, looking at longitudinal studies, we had to agree that while it is highly effective in the short term, the effect fades after about six months. People simply revert to their underlying preferences once the novelty of the new layout wears off. 
Tutor: Precisely. Behavioral interventions often struggle with long-term adherence. Given the vast scope of Nudge Theory, you need to narrow your research focus. Have you considered looking at digital choice architecture? Specifically, how user interfaces guide consumers online.
Julian: We hadn’t thought of that, but it’s incredibly relevant. E-commerce platforms use defaults and visual hierarchy constantly. We can pivot to analyzing software interfaces.
Eleanor: Actually, speaking of software, Julian, how did you get on with the default-options software modelling tool I sent you? 
Julian: Honestly, it was a frustrating experience. The interface itself was fine, but I struggled to isolate the variables. When you change a default setting, so many secondary behaviors alter simultaneously that tracking a clear cause-and-effect relationship became nearly impossible. 
Eleanor: I can run the statistical regressions for you if that helps. 
Julian: That would be great, thanks. 
Tutor: Good teamwork. Now, a crucial part of your literature review will be contrasting the views of key academics in the field. Let’s quickly run through some prominent figures. Richard Thaler is arguably the father of this field. 
Eleanor: Yes, Thaler’s primary argument is that humans are fundamentally irrational actors who rely heavily on cognitive heuristics, which justifies the need for gentle nudges.
Tutor: Spot on. And his frequent collaborator, Cass Sunstein? 
Julian: Sunstein takes a more political angle. He introduced the concept of "libertarian paternalism," arguing that institutions have a moral duty to steer citizens toward better choices as long as the freedom to opt-out remains cheap and easy. 
Tutor: Correct. You must also include Daniel Kahneman.
Eleanor: Kahneman’s dual-process theory—System 1 and System 2 thinking—underpins the psychological mechanics of why nudges work. He showed that nudges target our fast, intuitive, and lazy System 1 brain.
Tutor: Excellent. Now, not everyone is an advocate. What about Dan Ariely?
Julian: Ariely is interesting. He acknowledges that nudges work, but he focuses heavily on the dark side—what he calls "sludges." He emphasizes how corporations weaponize choice architecture to exploit consumers, like making subscriptions incredibly difficult to cancel.
Tutor: A vital counter-perspective. Lastly, what did you make of the philosopher Sarah Conly?
Eleanor: Conly rejects the soft approach entirely. She argues that if a behavior is genuinely harmful, like smoking, nudging is insufficient. She believes in coercive paternalism—outright banning harmful choices rather than just making them slightly less convenient. 
Tutor: It seems you both have a very firm grasp on the literature. Focus on structuring these arguments coherently, and your draft will be very strong.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('b3fadb8c-b04b-4597-897f-6f7fb80c7a10', '6ed6df3a-8db8-481a-bc56-b14d3990476a', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('b18facd8-19e3-4d49-a4b8-734dcf806657', 'b3fadb8c-b04b-4597-897f-6f7fb80c7a10', 21,
 'Why was Eleanor initially surprised by Nudge Theory?',
 '["A. It relies on severe economic penalties", "B. It preserves freedom of choice", "C. It is a form of psychological manipulation"]', 'B'),
('f9ea4cc2-bd94-4bdd-87d5-b7984f9714b8', 'b3fadb8c-b04b-4597-897f-6f7fb80c7a10', 22,
 'Julian criticizes the organ donation study because...',
 '["A. The registration data was mathematically flawed", "B. Opt-in systems actually proved more effective", "C. Cultural factors were completely ignored"]', 'C'),
('5ff26f22-3e29-4212-a411-d5ff9b2d10ca', 'b3fadb8c-b04b-4597-897f-6f7fb80c7a10', 23,
 'What do Eleanor and Julian agree on regarding the cafeteria food placement strategy?',
 '["A. It treats adults like children", "B. It is highly effective in the short term", "C. It successfully alters long-term dietary habits"]', 'B'),
('e1e243ce-fc74-4e4c-b16f-290c206dc65e', 'b3fadb8c-b04b-4597-897f-6f7fb80c7a10', 24,
 'What does the tutor suggest they narrow their research focus to?',
 '["A. Digital choice architecture", "B. Public health interventions", "C. Financial decision making"]', 'A'),
('37ffe65b-8c47-4327-abaf-955d2e9ab094', 'b3fadb8c-b04b-4597-897f-6f7fb80c7a10', 25,
 'What problem did Julian experience with the modelling software?',
 '["A. The user interface was confusing", "B. He struggled to isolate the variables", "C. The statistical regressions failed to load"]', 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('3b7ee68d-800b-41aa-ad4a-969db08e3980', '6ed6df3a-8db8-481a-bc56-b14d3990476a', 2,
 'matching', 'Match the following researchers to their primary views or theories. Choose the correct letter, A-F.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('c1081e09-c103-41c8-88b8-a0896f3d08dd', '3b7ee68d-800b-41aa-ad4a-969db08e3980', 26,
 'Richard Thaler', 
 '["A. Corporations weaponize choice architecture to exploit consumers.", "B. Nudges target our fast, intuitive System 1 brain.", "C. Institutions have a moral duty to steer choices via libertarian paternalism.", "D. Harmful choices should be outright banned, not just nudged.", "E. Humans are fundamentally irrational and rely on heuristics.", "F. Choice architecture is a violation of basic human rights."]', 'E'),
('1a1ec1fb-d72b-45c6-bc47-ca1c7c4d6216', '3b7ee68d-800b-41aa-ad4a-969db08e3980', 27,
 'Cass Sunstein', 
 '["A. Corporations weaponize choice architecture to exploit consumers.", "B. Nudges target our fast, intuitive System 1 brain.", "C. Institutions have a moral duty to steer choices via libertarian paternalism.", "D. Harmful choices should be outright banned, not just nudged.", "E. Humans are fundamentally irrational and rely on heuristics.", "F. Choice architecture is a violation of basic human rights."]', 'C'),
('89027595-d0ad-4e23-95f7-1997019bd59f', '3b7ee68d-800b-41aa-ad4a-969db08e3980', 28,
 'Daniel Kahneman', 
 '["A. Corporations weaponize choice architecture to exploit consumers.", "B. Nudges target our fast, intuitive System 1 brain.", "C. Institutions have a moral duty to steer choices via libertarian paternalism.", "D. Harmful choices should be outright banned, not just nudged.", "E. Humans are fundamentally irrational and rely on heuristics.", "F. Choice architecture is a violation of basic human rights."]', 'B'),
('c494490f-bb7e-454d-91a2-7bef48f5baad', '3b7ee68d-800b-41aa-ad4a-969db08e3980', 29,
 'Dan Ariely', 
 '["A. Corporations weaponize choice architecture to exploit consumers.", "B. Nudges target our fast, intuitive System 1 brain.", "C. Institutions have a moral duty to steer choices via libertarian paternalism.", "D. Harmful choices should be outright banned, not just nudged.", "E. Humans are fundamentally irrational and rely on heuristics.", "F. Choice architecture is a violation of basic human rights."]', 'A'),
('6e0ea3a1-c598-489c-93a9-02ebca62aa37', '3b7ee68d-800b-41aa-ad4a-969db08e3980', 30,
 'Sarah Conly', 
 '["A. Corporations weaponize choice architecture to exploit consumers.", "B. Nudges target our fast, intuitive System 1 brain.", "C. Institutions have a moral duty to steer choices via libertarian paternalism.", "D. Harmful choices should be outright banned, not just nudged.", "E. Humans are fundamentally irrational and rely on heuristics.", "F. Choice architecture is a violation of basic human rights."]', 'D');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 4: Academic Monologue (Space Economics)         ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('848d9e4a-c5a0-4d5f-845d-68056070be4a', 'ed22087f-0fe9-43b4-94a1-88f11cdd338c', 4,
 'Asteroid Mining and Orbital Economics',
 'Lecturer: Good morning. As we transition into the latter half of our module on Resource Economics, today’s lecture will pivot away from terrestrial extraction and look toward an emerging, albeit highly speculative, sector: Asteroid Mining. The prospect of harvesting resources from near-Earth objects was once the exclusive domain of science fiction, but recent advancements in autonomous robotics and propulsion systems have thrust this concept into the realm of economic feasibility.

To understand the economic potential, we must first look at what these celestial bodies contain. Asteroids are not all created equal; they are primarily categorized by their composition. The three main types are C-type, S-type, and M-type. While C-type asteroids are abundant in carbon and water, the financial sector is intensely focused on the M-type, or metallic, asteroids. These bodies are rich in iron and nickel, but more crucially, they contain staggering concentrations of platinum group metals. A single, mid-sized M-type asteroid could theoretically yield more platinum than has been mined in the entire history of humanity. 

However, the barriers to entry are astronomical, both literally and figuratively. The most significant financial hurdle is not the mining technology itself, but the sheer cost of escaping Earth’s gravity well. Launching heavy extraction equipment into orbit requires immense amounts of rocket fuel, making the initial capital expenditure prohibitively expensive for most private enterprises. 

To circumvent this, aerospace engineers propose a paradigm shift: in-situ resource utilization. This means utilizing the resources found in space to further space exploration. The most critical application of this is manufacturing propellant off-world. Remember those C-type asteroids I mentioned? The water ice they contain can be harvested, melted, and subjected to electrolysis. This process splits the water into hydrogen and oxygen—the exact two components required for high-efficiency rocket fuel. By establishing orbital refueling depots, spacecraft wouldn’t need to launch with all their return fuel, drastically reducing the payload weight and cost.

Beyond the engineering challenges, we must consider the labyrinth of international space law. The foundational legal framework is the 1967 Outer Space Treaty. This treaty explicitly states that space is the "province of all mankind" and strictly prevents nations from claiming sovereignty over the Moon or any other celestial bodies. However, a major legal grey area exists: while you cannot own the asteroid itself, can a private company own the materials extracted from it? In 2015, the United States passed legislation granting its citizens the right to own and sell asteroid resources, a move that sparked intense debate at the United Nations regarding the equitable distribution of space wealth.

Let us consider the profound macroeconomic implications if this industry succeeds. Bringing millions of tonnes of precious metals back to Earth would trigger a massive supply shock. According to basic supply and demand principles, a sudden influx of rare metals could cause a catastrophic crash in the global market, decimating the economies of nations that currently rely heavily on terrestrial mining exports. 

Yet, from an environmental perspective, this could be a monumental victory for our planet. Current terrestrial mining operations cause severe environmental degradation, ranging from toxic runoff contaminating watersheds to widespread deforestation and habitat destruction. If we can master the logistics of orbital logistics, the long-term vision is the complete relocation of heavy, polluting industries off-world. Earth could eventually be zoned primarily for residential, agricultural, and light commercial use, while the heavy, resource-intensive manufacturing occurs in the sterile vacuum of space. 

In conclusion, while the foundational technologies are rapidly maturing, true commercial viability remains elusive. Most conservative economic models estimate that profitable asteroid mining is at least a decade away, requiring sustained investment and unprecedented international cooperation.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c431fcb7-b132-4660-accd-397a581f0a4a', '848d9e4a-c5a0-4d5f-845d-68056070be4a', 1,
 'sentence-completion', 'Complete the notes below. Write NO MORE THAN ONE WORD for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('2d1af743-d716-49b9-b1f9-06d110736426', 'c431fcb7-b132-4660-accd-397a581f0a4a', 31,
 'Asteroids are primarily categorized by their ________.', 'composition', '["composition","Composition"]'),
('3f8bf362-9ba9-478a-ba9d-cb10d2a51fe7', 'c431fcb7-b132-4660-accd-397a581f0a4a', 32,
 'Type-M asteroids are highly sought after for their ________ group metals.', 'platinum', '["platinum","Platinum"]'),
('1c6c858f-b7cf-486c-b4cf-669ea4067500', 'c431fcb7-b132-4660-accd-397a581f0a4a', 33,
 'A major financial hurdle is the cost of escaping Earth’s ________ well.', 'gravity', '["gravity","Gravity"]'),
('adf3f0de-b52f-4616-ae23-33cf155a9e61', 'c431fcb7-b132-4660-accd-397a581f0a4a', 34,
 'To combat costs, engineers propose manufacturing ________ in space.', 'propellant', '["propellant","fuel","Propellant"]'),
('1fde9c64-aa40-466e-bb9c-90208c6d88c4', 'c431fcb7-b132-4660-accd-397a581f0a4a', 35,
 'Water found on asteroids can be electrolyzed into hydrogen and ________.', 'oxygen', '["oxygen","Oxygen"]'),
('a56cae89-0202-4565-a6ec-3c9faae5bd1e', 'c431fcb7-b132-4660-accd-397a581f0a4a', 36,
 'The 1967 Outer Space Treaty prevents nations from claiming ________ over celestial bodies.', 'sovereignty', '["sovereignty","Sovereignty"]'),
('2f68030a-01ce-44e5-bb22-a14f6e5d2ff6', 'c431fcb7-b132-4660-accd-397a581f0a4a', 37,
 'A sudden influx of rare metals could cause a crash in the global ________.', 'market', '["market","Market"]'),
('1daefd5d-0329-4c35-ae00-f94d6990c6bf', 'c431fcb7-b132-4660-accd-397a581f0a4a', 38,
 'Current terrestrial mining causes severe environmental ________.', 'degradation', '["degradation","Degradation"]'),
('07254056-799c-4475-9dd0-7fb896b3017e', 'c431fcb7-b132-4660-accd-397a581f0a4a', 39,
 'Extracting resources off-world could eventually lead to the ________ of heavy industry.', 'relocation', '["relocation","Relocation"]'),
('c246c5ad-76e8-41da-be58-de888ec9d78d', 'c431fcb7-b132-4660-accd-397a581f0a4a', 40,
 'True commercial viability is estimated to be at least a ________ away.', 'decade', '["decade","Decade"]');
