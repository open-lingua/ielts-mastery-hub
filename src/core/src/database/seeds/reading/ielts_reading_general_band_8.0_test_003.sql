-- ============================================================
-- IELTS Practice Platform – Extended Seed Data
-- Target: Reading Module (General Training, Band 8 Difficulty)
-- Action: APPEND (No TRUNCATE)
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST ENTRY (General Training - Band 8)                   ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('e281de20-efd7-4d6a-b55a-9dca2f9f916d', '37c208b0-f818-47e1-a95a-fb6d9a15a1f0',
 'IELTS General Training Reading: Telecommuting Policies, Urban Micro-Mobility & Bioluminescence (Band 8)', 'General Training', '8', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: Sentinel Tech Remote Work Guidelines (Q1–13)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('231752a3-9c36-4a53-b583-29f4c599a69e', 'e281de20-efd7-4d6a-b55a-9dca2f9f916d', 1,
 'Sentinel Tech: Comprehensive Telecommuting and Cyber Security Protocol',
 '(A) Eligibility and Equipment
Telecommuting is an earned privilege at Sentinel Tech, designed to foster work-life equilibrium. Employees become eligible to submit a remote-work petition only after successfully completing a probationary period of six months. Approved staff will be provisioned with a standardized corporate hardware bundle, comprising a high-fidelity monitor, a pre-configured encrypted laptop, and a biometric peripheral mouse. Sentinel Tech will not reimburse employees for unauthorized supplementary hardware purchases, nor for standard household utility bills, such as electricity or broadband, unless mandated by specific regional labor ordinances.

(B) Core Hours and Responsibilities
Despite the flexibility inherent in telecommuting, all remote personnel are contractually obliged to be virtually present and accessible via the company’s internal messaging matrix during "Core Synchronous Hours" (10:00 AM to 3:00 PM, Pacific Standard Time). Outside these parameters, employees possess the autonomy to structure their remaining daily hours at their discretion, provided all project milestones and weekly deliverables are demonstrably met. Unjustified failure to respond to direct supervisory communications during Core Synchronous Hours on three separate occasions within a single fiscal quarter will precipitate an immediate suspension of telecommuting privileges.

(C) Endpoint Security and Network Protocol
Security is paramount. Remote workers must exclusively utilize the Sentinel Tech Virtual Private Network (VPN) when accessing corporate intranet portals or handling proprietary client data. The utilization of public, unsecured Wi-Fi networks (such as those in commercial coffee shops or airport transit lounges) for any corporate activity is strictly prohibited, as it exposes the company to unacceptable cryptographic vulnerabilities. Furthermore, any external storage devices, such as USB flash drives, will be automatically reformatted and scrubbed by the laptop’s root security protocol upon insertion.

(D) Ergonomics and Liability
Sentinel Tech expects all remote employees to designate a dedicated workspace within their primary residence that adheres to basic occupational health standards. An annual ergonomic assessment will be conducted virtually by our Human Resources department. Should an employee sustain a physical injury during mandated working hours within their designated home office, they may be eligible for standard worker’s compensation. However, this liability cover is nullified if the injury occurs while performing tasks unrelated to their employment or in an undesignated area of the property, such as a garden or garage.');

-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('91830d70-c26d-4ab3-b903-6a4cbd623895', '231752a3-9c36-4a53-b583-29f4c599a69e', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the text? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('5f6baac2-2f6e-4169-82e9-8afc78938a04', '91830d70-c26d-4ab3-b903-6a4cbd623895', 1,
 'Employees must pass a six-month trial period before they can apply to work remotely.', 'TRUE', '["TRUE","True","true"]'),
('7456ce7b-9f66-44a8-906f-960ff6e48d86', '91830d70-c26d-4ab3-b903-6a4cbd623895', 2,
 'Sentinel Tech will pay for a portion of the employee’s monthly internet bill in all jurisdictions.', 'FALSE', '["FALSE","False","false"]'),
('2a73c593-695c-4b23-b1d6-deb844adcd0e', '91830d70-c26d-4ab3-b903-6a4cbd623895', 3,
 'Employees can choose to work during the evening as long as they are online between 10:00 AM and 3:00 PM PST.', 'TRUE', '["TRUE","True","true"]'),
('804002d5-d212-4a2a-978d-c7a304667b6c', '91830d70-c26d-4ab3-b903-6a4cbd623895', 4,
 'The company provides specialized ergonomic chairs as part of the hardware bundle.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]');

-- ── Group 2: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('f76790b0-c8cd-4d03-b151-ea950e2cee66', '231752a3-9c36-4a53-b583-29f4c599a69e', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN THREE WORDS from the text for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('34392733-3a55-4d70-ad2b-499d6d81caf8', 'f76790b0-c8cd-4d03-b151-ea950e2cee66', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"Topic","answer":""},{"id":"h2","gapText":"Policy Details","answer":""}]'),
('75bab69c-9978-42db-81fe-3f0c5f81a647', 'f76790b0-c8cd-4d03-b151-ea950e2cee66', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"Network Security","answer":""},{"id":"c2","gapText":"Working on unsecured public Wi-Fi is {{gap}} due to risks.","answer":"strictly prohibited"}]'),
('16021dcf-c47c-48bc-aeb7-f95999a527e8', 'f76790b0-c8cd-4d03-b151-ea950e2cee66', 7,
 'Row 3', '',
 '[{"id":"c3","gapText":"Hardware Usage","answer":""},{"id":"c4","gapText":"Any USB flash drives plugged in will be {{gap}}.","answer":"automatically reformatted"}]'),
('e3221001-bbd1-4bad-aba2-f5ae9db9519b', 'f76790b0-c8cd-4d03-b151-ea950e2cee66', 8,
 'Row 4', '',
 '[{"id":"c5","gapText":"Work Environment","answer":""},{"id":"c6","gapText":"Staff must have a {{gap}} meeting health standards.","answer":"designated workspace"}]'),
('93638343-688a-49a4-a8ac-0d5a77bcb5b4', 'f76790b0-c8cd-4d03-b151-ea950e2cee66', 9,
 'Row 5', '',
 '[{"id":"c7","gapText":"Legal Protection","answer":""},{"id":"c8","gapText":"Injury protection is void if working in an {{gap}}.","answer":"undesignated area"}]');

-- ── Group 3: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('832b712e-2fa2-42ca-bbb5-0eb1a9c673f5', '231752a3-9c36-4a53-b583-29f4c599a69e', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS from the text for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('7cedce6f-bd60-41f2-848e-3f6ddb41d650', '832b712e-2fa2-42ca-bbb5-0eb1a9c673f5', 10,
 'What type of mouse is provided to remote employees by Sentinel Tech?', 'biometric peripheral mouse', '[{"id":"1","text":"biometric peripheral mouse"},{"id":"2","text":"biometric peripheral"}]'),
('18603969-951c-4ef1-8d0c-5d6259093033', '832b712e-2fa2-42ca-bbb5-0eb1a9c673f5', 11,
 'What consequence faces an employee who ignores direct messages three times during core hours?', 'immediate suspension', '[{"id":"1","text":"immediate suspension"},{"id":"2","text":"suspension"},{"id":"3","text":"suspension of privileges"}]'),
('8959b5c9-5583-4d93-8da5-349ac220e8cb', '832b712e-2fa2-42ca-bbb5-0eb1a9c673f5', 12,
 'What specific tool must staff use to access proprietary client data?', 'Virtual Private Network', '[{"id":"1","text":"Virtual Private Network"},{"id":"2","text":"VPN"},{"id":"3","text":"Sentinel Tech VPN"}]'),
('e016b2d7-cef8-4fbc-a5df-62c4e66658ee', '832b712e-2fa2-42ca-bbb5-0eb1a9c673f5', 13,
 'How often will HR assess the physical setup of an employee’s home office?', 'annual', '[{"id":"1","text":"annual"},{"id":"2","text":"annually"},{"id":"3","text":"an annual assessment"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Urban Micro-Mobility Solutions (Q14–27)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('0af79b5d-08dc-4cce-90a1-17ea7ee41d7d', 'e281de20-efd7-4d6a-b55a-9dca2f9f916d', 2,
 'The Evolution and Regulation of Urban Micro-Mobility',
 '(A) Over the last decade, metropolitan landscapes worldwide have undergone a transportation revolution. Micro-mobility—a term generally encompassing lightweight, low-speed vehicles such as electric scooters (e-scooters), electric skateboards, and docked or dockless bicycles—has surged in popularity. This paradigm shift is largely driven by a combination of technological advancements in lithium-ion battery density, the ubiquity of smartphone applications used to unlock these devices, and a growing public consciousness regarding the carbon footprint of traditional combustion-engine automobiles. For many commuters, micro-mobility offers the perfect antidote to the "last-mile problem"—the frustrating final leg of a journey between a public transit hub and a final destination.

(B) The rapid proliferation of dockless e-scooter fleets, however, caught many city planners off guard. When companies first aggressively launched their products in major North American and European cities, they often operated in a legal gray area, deploying thousands of scooters on sidewalks overnight without prior municipal consent. This "ask for forgiveness, not permission" strategy resulted in chaotic urban scenes. Pedestrians found sidewalks obstructed by haphazardly discarded scooters, while emergency rooms reported a sharp uptick in head injuries and fractures associated with novice riders navigating heavy traffic without helmets.

(C) In response to the ensuing public outcry, municipal governments began formulating stringent regulatory frameworks. Cities like Paris and San Francisco implemented strict capping systems, drastically limiting the total number of scooters permitted on the streets and requiring operating companies to bid for highly competitive licenses. Furthermore, many jurisdictions introduced "geofencing" mandates. Geofencing utilizes GPS technology to automatically decelerate or completely disable a scooter when it enters a prohibited zone, such as a crowded pedestrian plaza, a public park, or a university campus, thereby forcibly curbing rider misbehavior.

(D) Despite these regulatory hurdles, the economic logic of micro-mobility remains robust. Operating companies have evolved their business models, shifting away from aggressive expansion toward prioritizing unit economics—meaning the profitability of each individual scooter. Early iterations of e-scooters were essentially consumer-grade toys that broke down after just 30 days of harsh urban use, rendering them massive financial liabilities. Modern fleets, conversely, feature commercial-grade, ruggedized vehicles with modular components, solid tires, and swappable batteries, extending their lifespan to over two years and dramatically lowering maintenance overhead.

(E) Environmentalists offer a nuanced perspective on the micro-mobility boom. While an e-scooter is undeniably greener than a gas-guzzling car, its overall environmental impact must account for the entire lifecycle of the product. Early studies revealed that the hidden emissions generated by the manufacturing of the aluminum frames, coupled with the nightly deployment of gas-powered vans used by independent contractors to collect and recharge the batteries, largely negated the environmental benefits. However, as companies transition to on-site swappable batteries serviced by cargo bikes, the true carbon footprint of the industry is finally beginning to align with its eco-friendly marketing claims.

(F) Looking ahead, the integration of micro-mobility into the broader urban transit ecosystem seems inevitable. The most progressive cities are no longer just regulating these vehicles; they are actively redesigning their infrastructure to accommodate them. This includes the conversion of car lanes into widened, protected micro-mobility thoroughfares and the installation of universal charging docks at major train stations. The goal is a cohesive, multi-modal transit network where citizens can seamlessly transfer from a train to an e-bike, leaving the personal automobile in the driveway.');

-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('1b89c5cb-03f0-45d9-ac03-7492496b9112', '0af79b5d-08dc-4cce-90a1-17ea7ee41d7d', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. The hardware upgrades improving financial viability", "ii. Assessing the true ecological cost", "iii. Using technology to enforce spatial boundaries", "iv. The initial chaotic introduction into cities", "v. Factors driving the initial adoption of small vehicles", "vi. Rebuilding city streets for a multi-modal future", "vii. Why pedestrians dislike e-scooters", "viii. The financial collapse of early scooter startups"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('14011c18-ba50-4e92-b6ed-168dc7b3f477', '1b89c5cb-03f0-45d9-ac03-7492496b9112', 14, 'Paragraph A', 'v'),
('a316b87b-c590-45a4-bf68-d53b0aece286', '1b89c5cb-03f0-45d9-ac03-7492496b9112', 15, 'Paragraph B', 'iv'),
('66ae5963-9053-4394-bc6b-1bbe3db8dfad', '1b89c5cb-03f0-45d9-ac03-7492496b9112', 16, 'Paragraph C', 'iii'),
('92b7d91c-855d-4849-adeb-8986c408f0cf', '1b89c5cb-03f0-45d9-ac03-7492496b9112', 17, 'Paragraph D', 'i'),
('203ec994-2c2c-4a92-be1c-0d793e82dc78', '1b89c5cb-03f0-45d9-ac03-7492496b9112', 18, 'Paragraph E', 'ii'),
('503d0b42-f451-4823-a192-7326a3752662', '1b89c5cb-03f0-45d9-ac03-7492496b9112', 19, 'Paragraph F', 'vi');

-- ── Group 5: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('cf41fb90-7fca-479c-b771-70934955aa96', '0af79b5d-08dc-4cce-90a1-17ea7ee41d7d', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('efa6b6eb-c3af-4aae-9145-1996d845863c', 'cf41fb90-7fca-479c-b771-70934955aa96', 20,
 'A description of how GPS software restricts where devices can be used.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('64c6ce2e-e476-4527-b7be-1073724b59e4', 'cf41fb90-7fca-479c-b771-70934955aa96', 21,
 'Reference to the hidden pollution caused by maintaining the vehicles overnight.', 'E',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('6e7376ca-e2a8-46ec-84a7-2e4d2573eadd', 'cf41fb90-7fca-479c-b771-70934955aa96', 22,
 'The physical danger posed to inexperienced riders in traffic.', 'B',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('f5cf2667-f52f-4fcf-9fcb-0b3d4de84fd9', 'cf41fb90-7fca-479c-b771-70934955aa96', 23,
 'A specific term used to describe the difficulty of finishing a commute.', 'A',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');

-- ── Group 6: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('0240f431-41df-4a22-8865-e2f66450a81a', '0af79b5d-08dc-4cce-90a1-17ea7ee41d7d', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('9ed22a86-6586-41eb-9167-bdf508e8a998', '0240f431-41df-4a22-8865-e2f66450a81a', 24,
 'According to Paragraph C, how did cities like Paris attempt to control e-scooters?',
 'B',
 '[{"id":"A","text":"A. By banning them entirely from the city center.","isCorrect":false},{"id":"B","text":"B. By restricting the total number allowed and making companies bid for licenses.","isCorrect":true},{"id":"C","text":"C. By requiring all riders to pass a formal driving test.","isCorrect":false},{"id":"D","text":"D. By creating geofencing zones that force scooters to speed up.","isCorrect":false}]'),
('79d99f97-4ea8-4001-9265-dce53500e086', '0240f431-41df-4a22-8865-e2f66450a81a', 25,
 'Paragraph D suggests that early iterations of e-scooters were unprofitable because:',
 'D',
 '[{"id":"A","text":"A. People preferred to use dockless bicycles instead.","isCorrect":false},{"id":"B","text":"B. They were frequently stolen by independent contractors.","isCorrect":false},{"id":"C","text":"C. The batteries were too heavy for commuters to carry.","isCorrect":false},{"id":"D","text":"D. They lacked durability and broke down quickly under harsh use.","isCorrect":true}]'),
('79dd3fb7-1008-4385-941f-cd5ab805f6a7', '0240f431-41df-4a22-8865-e2f66450a81a', 26,
 'How are companies currently improving the environmental impact of e-scooters, as noted in Paragraph E?',
 'C',
 '[{"id":"A","text":"A. By manufacturing frames out of recycled plastic rather than aluminum.","isCorrect":false},{"id":"B","text":"B. By encouraging users to charge the scooters in their own homes.","isCorrect":false},{"id":"C","text":"C. By using cargo bikes to swap batteries on-site instead of using gas vans.","isCorrect":true},{"id":"D","text":"D. By reducing the overall speed limit of the vehicles.","isCorrect":false}]'),
('f0306627-f8a8-4346-be6a-44c24a580d50', '0240f431-41df-4a22-8865-e2f66450a81a', 27,
 'What is the writer’s main prediction in Paragraph F?',
 'A',
 '[{"id":"A","text":"A. Cities will physically adapt their layouts to support small electric vehicles.","isCorrect":true},{"id":"B","text":"B. Personal cars will eventually be banned from all metropolitan areas.","isCorrect":false},{"id":"C","text":"C. Micro-mobility will fail due to a lack of charging infrastructure.","isCorrect":false},{"id":"D","text":"D. Only train stations will permit the use of e-bikes in the future.","isCorrect":false}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: Bioluminescence (Q28–40)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('a3b30d30-a04a-4a45-8f36-6cb30388be23', 'e281de20-efd7-4d6a-b55a-9dca2f9f916d', 3,
 'Bioluminescence: The Cold Light of the Deep',
 '(A) In the abyssal zones of the world’s oceans, where the sun’s rays cannot penetrate, darkness is absolute. Yet, this aphotic realm is not devoid of light. It is illuminated by bioluminescence, a mesmerizing biological phenomenon where living organisms produce and emit light. Unlike the thermal light generated by a fire or an incandescent bulb, which wastes much of its energy as heat, bioluminescence is often referred to as "cold light." The chemical reaction that generates this glow is extraordinarily efficient, with nearly 100% of the energy yielded translating directly into visible light, ensuring the delicate tissues of the organisms remain unharmed.

(B) The biochemistry of bioluminescence relies on two primary molecular components: luciferin, a light-emitting pigment, and luciferase, an enzyme that acts as a catalyst. When luciferin is oxidized in the presence of luciferase, it transitions into an unstable, excited state. As it rapidly decays back to its ground state, it releases energy in the form of a photon—a particle of light. The specific color of the light—most commonly blue or green in marine environments—is dictated by the exact molecular structure of the luciferin, which varies slightly among different species. Blue light is particularly advantageous in the ocean, as its shorter wavelength allows it to travel further through water than red or yellow light.

(C) The evolutionary rationale behind bioluminescence is as diverse as the creatures that possess it. For many deep-sea predators, light is a weapon of deception. The anglerfish, perhaps the most infamous abyssal predator, utilizes a bioluminescent lure dangling from a modified dorsal fin. This glowing beacon mimics the erratic movements of small prey, drawing curious victims directly into the anglerfish’s cavernous, tooth-filled maw. Conversely, some species use light as a defense mechanism. The deep-sea squid (Octopoteuthis deletron), when threatened, does not eject black ink like its shallow-water cousins, as it would be invisible in the dark. Instead, it expels a viscous cloud of glowing bioluminescent mucus, temporarily blinding and confusing the predator while the squid makes its escape.

(D) Another critical function of bioluminescence is intraspecific communication, particularly regarding reproduction. In the vast, featureless expanse of the deep ocean, finding a mate is a statistically improbable task. Certain species of lanternfish possess intricate patterns of light-emitting organs, known as photophores, along their flanks. These patterns act as a unique visual signature, allowing individuals not only to identify members of their own species but also to determine the sex and reproductive readiness of a potential partner. The synchronized flashing of these photophores constitutes a silent, luminous dialect essential for the survival of the species.

(E) Perhaps the most counterintuitive use of bioluminescence is camouflage. In the "twilight zone" of the ocean, roughly 200 to 1,000 meters deep, faint sunlight filters down from the surface. Predators lurking below look upward, hoping to spot the silhouettes of prey silhouetted against the dim light above. To combat this, many organisms, such as the hatchetfish, employ a technique called counterillumination. They possess photophores on their ventral (bottom) surface that emit a soft blue light precisely matching the intensity and wavelength of the down-welling sunlight. This optical illusion effectively erases their silhouette, rendering them virtually invisible to predators below.

(F) The implications of bioluminescence extend far beyond marine biology; they have profoundly impacted modern medical and genetic research. By isolating the gene responsible for producing Green Fluorescent Protein (GFP)—a bioluminescent substance originally discovered in the crystal jellyfish—scientists have created a revolutionary biological marker. When the GFP gene is spliced into the DNA of other organisms, it acts as a luminous tag. Under ultraviolet light, specific cells, such as growing tumors or developing neurons, will glow green. This allows researchers to track cellular processes and the progression of diseases in living organisms in real-time, an achievement that earned the scientists involved the Nobel Prize in Chemistry in 2008.');

-- ── Group 7: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('89be03b2-1c73-4921-93eb-8902bc9faf00', 'a3b30d30-a04a-4a45-8f36-6cb30388be23', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('720428b1-c807-4681-baff-05a14dc644e1', '89be03b2-1c73-4921-93eb-8902bc9faf00', 28,
 'Bioluminescent light generates significantly more heat than an incandescent light bulb.', 'NO', '["NO","No","no"]'),
('7f7970f2-075b-434b-b078-0975c9a53c4c', '89be03b2-1c73-4921-93eb-8902bc9faf00', 29,
 'The color of the light emitted by an organism is determined by the specific type of luciferin it possesses.', 'YES', '["YES","Yes","yes"]'),
('0fb8ce8b-3003-46bc-b1a2-24bec902c1a1', '89be03b2-1c73-4921-93eb-8902bc9faf00', 30,
 'Deep-sea squid are the only animals capable of ejecting glowing mucus to escape predators.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('84288dbb-dc79-49da-9b7a-7ec13ac7a58f', '89be03b2-1c73-4921-93eb-8902bc9faf00', 31,
 'Counterillumination is a strategy used by some deep-sea fish to make their shadows completely invisible from above.', 'NO', '["NO","No","no"]');

-- ── Group 8: MATCHING SENTENCE ENDINGS (Q32–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('5d0f7068-3877-4106-a77d-3d5c87cb2185', 'a3b30d30-a04a-4a45-8f36-6cb30388be23', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('c5fc5d89-ff32-4ad8-b214-fe69310da2ba', '5d0f7068-3877-4106-a77d-3d5c87cb2185', 32,
 'Blue light is advantageous for deep-sea creatures because it',
 'D',
 '[{"id":"A","text":"is invisible to most predators swimming below them.","isCorrect":false},{"id":"B","text":"allows researchers to safely study human genetic diseases.","isCorrect":false},{"id":"C","text":"helps them locate food by mimicking the movements of prey.","isCorrect":false},{"id":"D","text":"penetrates further through ocean water than other colors of light.","isCorrect":true},{"id":"E","text":"enables them to blend in seamlessly with the ocean floor.","isCorrect":false},{"id":"F","text":"helps individuals identify the gender of potential mates.","isCorrect":false}]'),
('49c3be29-6f6a-4000-ae8d-c80b14b4874a', '5d0f7068-3877-4106-a77d-3d5c87cb2185', 33,
 'The anglerfish relies on bioluminescence primarily because it',
 'C',
 '[{"id":"A","text":"is invisible to most predators swimming below them.","isCorrect":false},{"id":"B","text":"allows researchers to safely study human genetic diseases.","isCorrect":false},{"id":"C","text":"helps them locate food by mimicking the movements of prey.","isCorrect":true},{"id":"D","text":"penetrates further through ocean water than other colors of light.","isCorrect":false},{"id":"E","text":"enables them to blend in seamlessly with the ocean floor.","isCorrect":false},{"id":"F","text":"helps individuals identify the gender of potential mates.","isCorrect":false}]'),
('7673fe31-d11e-4e8e-90ac-a1bfac210894', '5d0f7068-3877-4106-a77d-3d5c87cb2185', 34,
 'The unique patterns of photophores on lanternfish are crucial because it',
 'F',
 '[{"id":"A","text":"is invisible to most predators swimming below them.","isCorrect":false},{"id":"B","text":"allows researchers to safely study human genetic diseases.","isCorrect":false},{"id":"C","text":"helps them locate food by mimicking the movements of prey.","isCorrect":false},{"id":"D","text":"penetrates further through ocean water than other colors of light.","isCorrect":false},{"id":"E","text":"enables them to blend in seamlessly with the ocean floor.","isCorrect":false},{"id":"F","text":"helps individuals identify the gender of potential mates.","isCorrect":true}]'),
('42079d1a-8dd7-4a7d-b6af-2c94e020a40c', '5d0f7068-3877-4106-a77d-3d5c87cb2185', 35,
 'The discovery of Green Fluorescent Protein (GFP) was a scientific breakthrough because it',
 'B',
 '[{"id":"A","text":"is invisible to most predators swimming below them.","isCorrect":false},{"id":"B","text":"allows researchers to safely study human genetic diseases.","isCorrect":true},{"id":"C","text":"helps them locate food by mimicking the movements of prey.","isCorrect":false},{"id":"D","text":"penetrates further through ocean water than other colors of light.","isCorrect":false},{"id":"E","text":"enables them to blend in seamlessly with the ocean floor.","isCorrect":false},{"id":"F","text":"helps individuals identify the gender of potential mates.","isCorrect":false}]');

-- ── Group 9: SUMMARY COMPLETION with Word Bank (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('e53dea7c-56d5-41da-af60-ffdaebe69bd1', 'a3b30d30-a04a-4a45-8f36-6cb30388be23', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["catalyst", "silhouette", "illusion", "camouflage", "communication", "deception", "sunlight", "mucus"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('9c7ad282-7799-424b-92c1-b18c853080d9', 'e53dea7c-56d5-41da-af60-ffdaebe69bd1', 36,
 'Bioluminescence is an energy-efficient chemical process requiring luciferin and a {{gap_e53dea7c-56d5-41da-af60-ffdaebe69bd1_0}} known as luciferase. In the deep ocean, animals utilize this ability for various survival strategies. Some employ it for {{gap_e53dea7c-56d5-41da-af60-ffdaebe69bd1_1}}, tricking smaller prey into approaching. Others use it defensively, such as deep-sea squid that release glowing {{gap_e53dea7c-56d5-41da-af60-ffdaebe69bd1_2}} to distract attackers. Interestingly, light can also be used to hide. Animals in the twilight zone use counterillumination as a form of {{gap_e53dea7c-56d5-41da-af60-ffdaebe69bd1_3}}, emitting light from their undersides to match the faint {{gap_e53dea7c-56d5-41da-af60-ffdaebe69bd1_4}} from above, thus erasing their outline from predators below.',
 'catalyst'),
('12d3b208-952d-4e94-97c9-1a6f18dad887', 'e53dea7c-56d5-41da-af60-ffdaebe69bd1', 37,
 '', 'deception'),
('5c7c0965-5fe3-40bb-ae27-7dfa70275e24', 'e53dea7c-56d5-41da-af60-ffdaebe69bd1', 38,
 '', 'mucus'),
('4ad67051-bf30-4bee-85b9-7a320f975f7e', 'e53dea7c-56d5-41da-af60-ffdaebe69bd1', 39,
 '', 'camouflage'),
('fbd86874-6eac-4dfe-b2b7-55ca7943bc53', 'e53dea7c-56d5-41da-af60-ffdaebe69bd1', 40,
 '', 'sunlight');

-- ============================================================
-- NOTE: Please execute `UPDATE reading_tests SET created_by = '<your-uid>'` 
-- if required by your application's Row Level Security policies.
-- ============================================================
