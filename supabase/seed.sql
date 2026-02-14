-- ============================================================
-- IELTS Practice Platform – Seed Data
-- Run: supabase db reset   (applies migrations then this seed)
-- ============================================================
-- NOTE: `created_by` uses a placeholder UUID. After seeding,
-- update it to a real user''s auth.uid() so RLS allows access:
--   UPDATE reading_tests  SET created_by = '<your-uid>';
--   UPDATE listening_tests SET created_by = '<your-uid>';
--   UPDATE writing_tests  SET created_by = '<your-uid>';
-- ============================================================

-- Clean slate (cascade deletes children)
TRUNCATE TABLE writing_tasks, writing_tests CASCADE;
TRUNCATE TABLE listening_questions, listening_question_groups, listening_sections, listening_tests CASCADE;
TRUNCATE TABLE reading_questions, reading_question_groups, reading_passages, reading_tests CASCADE;

-- Placeholder author (replace after seeding)
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM auth.users WHERE id = '00000000-0000-0000-0000-000000000001') THEN
  -- We can''t insert into auth.users; the UUIDs below will need updating.
  NULL;
END IF; END $$;


-- ████████████████████████████████████████████████████████████
-- ██  1. READING TEST                                      ██
-- ████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('a1000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001',
 'IELTS Academic Reading Practice Test 1', 'Academic', '7', '60 mins', 'published');

-- ── Passage 1: The History of the Tortoise ──────────────────
INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 1,
 'The History of the Tortoise',
 'If you go back far enough, everything lived in the sea. At various points in evolutionary history, enterprising individuals within many different animal groups moved out onto the land, sometimes even to the most parched deserts, taking their own private sea water with them in blood and cellular fluids. In addition to the reptiles, birds, mammals, and insects which we see all around us, other groups that have representatives on land include scorpions, snails, crustaceans such as woodlice and land crabs, millipedes and centipedes, spiders, and various worms. And we mustn''t forget the plants, without which none of the land animals could survive.

Moving from water to land involved a major redesign of every aspect of life, including breathing and reproduction. Nevertheless, a good number of diverse groups of animals did manage the transition, and some of them did it surprisingly early. The first fish to crawl out of the water did so more than 350 million years ago, but tortoises have been plodding around on land for more than 200 million years.

The earliest known turtles date from the late Triassic Period, roughly 220 million years ago. These ancient creatures already possessed the characteristic shell, though some primitive species had teeth rather than the horny beak found in modern turtles. The shell of a tortoise is actually formed from modified ribs and vertebrae that have become fused together and covered with keratinous plates called scutes. This remarkable adaptation provides exceptional protection from predators but limits the animal''s flexibility and speed.

Tortoises are found on every continent except Antarctica. The largest living species is the Galapagos giant tortoise, which can weigh more than 400 kilograms and live for over 100 years. Charles Darwin famously studied the variations in shell shape among tortoises from different Galapagos islands during his voyage on HMS Beagle, observations which contributed to his theory of evolution by natural selection.

Giant tortoises once lived on many other islands and even on some continental mainlands. Fossils of enormous tortoises have been found in North America, Europe, Africa, and Asia. Most of these populations went extinct during the Pleistocene epoch, roughly coinciding with the arrival of human hunters. The vulnerability of tortoises stems partly from their slow reproductive rate and partly from their inability to flee from predators, making them easy targets for early human populations seeking food.

Conservation efforts for tortoises today focus on habitat preservation, captive breeding programs, and combating the illegal pet trade. Several species, including the ploughshare tortoise of Madagascar and the radiated tortoise, remain critically endangered despite decades of conservation work. International agreements such as CITES regulate the trade in tortoise species, but enforcement remains challenging in many regions.');

-- Question Group: TRUE/FALSE/NOT GIVEN
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001', 1,
 'true-false', 'Do the following statements agree with the information given in the passage? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000001', 1,
 'Tortoises first appeared on land before fish did.', 'FALSE', '["false","False","FALSE"]'::jsonb),
('d1000000-0000-0000-0000-000000000002', 'c1000000-0000-0000-0000-000000000001', 2,
 'The shell of a tortoise is made from modified bones.', 'TRUE', '["true","True","TRUE"]'::jsonb),
('d1000000-0000-0000-0000-000000000003', 'c1000000-0000-0000-0000-000000000001', 3,
 'Darwin visited the Galapagos Islands more than once.', 'NOT GIVEN', '["not given","Not Given","NOT GIVEN"]'::jsonb),
('d1000000-0000-0000-0000-000000000004', 'c1000000-0000-0000-0000-000000000001', 4,
 'Giant tortoises went extinct in the Pleistocene partly because of human activity.', 'TRUE', '["true","True","TRUE"]'::jsonb);


-- ── Passage 2: Space Exploration ────────────────────────────
INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000001', 2,
 'The New Era of Space Exploration',
 'The landscape of space exploration has shifted dramatically since the turn of the millennium. Where once only government agencies such as NASA, Roscosmos, and the European Space Agency had the resources and expertise to launch missions beyond Earth''s atmosphere, the twenty-first century has witnessed the rise of private companies that are fundamentally reshaping humanity''s relationship with outer space.

SpaceX, founded by Elon Musk in 2002, demonstrated the viability of reusable rocket technology with the successful landing of a Falcon 9 booster in December 2015. This achievement was significant not merely as a technical milestone but as an economic one: by recovering and refurbishing first-stage boosters, SpaceX reduced the cost of reaching low Earth orbit by an estimated factor of ten. Blue Origin, established by Amazon founder Jeff Bezos, has pursued a similar philosophy of reusability with its New Shepard suborbital vehicle.

The commercial space sector has expanded beyond launch services. Companies such as Planet Labs operate constellations of small satellites that image the entire Earth daily, providing data used in agriculture, urban planning, disaster response, and environmental monitoring. OneWeb and SpaceX''s Starlink project aim to provide global broadband internet coverage through networks of thousands of low-orbit satellites, a development that could connect billions of people in remote regions who currently lack reliable internet access.

International cooperation remains a cornerstone of major space endeavours. The International Space Station, a collaborative project involving fifteen nations, has been continuously occupied since November 2000. It serves as a laboratory for research in microgravity, biology, physics, and astronomy, and as a testbed for technologies needed for longer missions to the Moon and Mars.

NASA''s Artemis programme aims to return humans to the lunar surface for the first time since Apollo 17 in 1972. Unlike the Apollo missions, Artemis envisions a sustained presence on the Moon, with a planned orbital outpost called Gateway serving as a staging point for surface expeditions and, eventually, missions to Mars. China has also outlined ambitious lunar plans, including robotic sample-return missions and proposals for a research station near the Moon''s south pole.

The ethical and regulatory dimensions of space activity are receiving increasing attention. The 1967 Outer Space Treaty established that outer space is the province of all humankind and cannot be claimed by any nation, but the treaty predates the era of commercial mining and space tourism. New frameworks are being discussed at the United Nations to address issues such as space debris mitigation, the governance of off-Earth resource extraction, and the protection of celestial environments from contamination.');

-- Question Group: Multiple Choice
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002', 1,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, options, answer) VALUES
('d1000000-0000-0000-0000-000000000005', 'c1000000-0000-0000-0000-000000000002', 5,
 'According to the passage, SpaceX''s reusable rocket technology was primarily significant because it',
 '["A. proved that private companies could compete with NASA", "B. reduced the financial cost of space launches substantially", "C. allowed satellites to be launched more quickly", "D. enabled missions to Mars for the first time"]'::jsonb,
 'B'),
('d1000000-0000-0000-0000-000000000006', 'c1000000-0000-0000-0000-000000000002', 6,
 'What is the main purpose of the International Space Station as described in the passage?',
 '["A. To serve as a launch platform for deep-space missions", "B. To demonstrate international political cooperation", "C. To function as a research facility and technology testbed", "D. To monitor weather patterns on Earth"]'::jsonb,
 'C'),
('d1000000-0000-0000-0000-000000000007', 'c1000000-0000-0000-0000-000000000002', 7,
 'The passage suggests that the 1967 Outer Space Treaty is',
 '["A. no longer legally binding", "B. insufficient for addressing modern commercial space activities", "C. opposed by most private space companies", "D. being replaced by a new international agreement"]'::jsonb,
 'B');


-- ── Passage 3: Psychological Behaviour ──────────────────────
INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000001', 3,
 'The Psychology of Decision-Making Under Uncertainty',
 'Human beings are not the perfectly rational agents that classical economic theory once assumed. Research in behavioural psychology and behavioural economics over the past five decades has revealed systematic patterns in the way people make judgments and decisions, particularly when outcomes are uncertain. These patterns, known as cognitive biases, can lead individuals, organisations, and even governments to make choices that deviate significantly from what would be considered optimal.

The pioneering work of Daniel Kahneman and Amos Tversky in the 1970s laid the foundation for this field. Their Prospect Theory, published in 1979, demonstrated that people evaluate potential losses and gains asymmetrically. Specifically, the pain of losing a given amount is psychologically about twice as powerful as the pleasure of gaining the same amount — a phenomenon known as loss aversion. This finding has profound implications for fields ranging from financial investment to public health policy.

Another influential concept from Kahneman and Tversky''s research is the availability heuristic: people tend to judge the probability of an event based on how easily examples come to mind. After extensive media coverage of aeroplane crashes, for instance, many people overestimate the risk of flying relative to driving, even though statistics consistently show that air travel is far safer per kilometre travelled. The availability heuristic explains why vivid, emotionally charged events disproportionately influence risk perception.

Anchoring is yet another well-documented bias. When people are asked to estimate an unknown quantity, their estimates are heavily influenced by any number they have recently encountered, even if that number is completely arbitrary. In one classic experiment, participants who were first asked whether Mahatma Gandhi died before or after the age of 140 subsequently gave higher estimates of his actual age at death than participants who were asked about the age of 9. The initial number served as an "anchor" that pulled subsequent estimates in its direction.

The framing effect demonstrates that the way information is presented can dramatically alter decisions. When a medical treatment is described as having a "90 percent survival rate," people are far more likely to choose it than when the same treatment is described as having a "10 percent mortality rate," even though the two descriptions are logically equivalent. This insight has led to the development of "nudge" strategies in public policy, where choices are structured to guide people toward beneficial outcomes without restricting their freedom.

Confirmation bias, the tendency to seek out and interpret information in ways that confirm pre-existing beliefs, is perhaps the most pervasive of all cognitive biases. Research has shown that people actively avoid information that contradicts their views and give disproportionate weight to evidence that supports them. In the age of social media, where algorithms curate content based on user preferences, confirmation bias has become a significant concern for democratic discourse and informed decision-making.');

-- Question Group: Sentence Completion
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('c1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003', 1,
 'sentence-completion', 'Complete the sentences below. Choose NO MORE THAN THREE WORDS from the passage for each answer.', true, 'no more than three words');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d1000000-0000-0000-0000-000000000008', 'c1000000-0000-0000-0000-000000000003', 8,
 'The systematic patterns in human judgment are called ________.', 'cognitive biases', '["cognitive biases","Cognitive biases","Cognitive Biases"]'::jsonb),
('d1000000-0000-0000-0000-000000000009', 'c1000000-0000-0000-0000-000000000003', 9,
 'Loss aversion means people feel the impact of losses roughly ________ as strongly as equivalent gains.', 'twice', '["twice","Twice","twice as"]'::jsonb),
('d1000000-0000-0000-0000-000000000010', 'c1000000-0000-0000-0000-000000000003', 10,
 'The tendency to favour information supporting existing beliefs is known as ________.', 'confirmation bias', '["confirmation bias","Confirmation bias","Confirmation Bias"]'::jsonb),
('d1000000-0000-0000-0000-000000000011', 'c1000000-0000-0000-0000-000000000003', 11,
 'In public policy, choice structures that guide people toward good outcomes are called ________ strategies.', 'nudge', '["nudge","Nudge","\"nudge\""]'::jsonb);


-- ████████████████████████████████████████████████████████████
-- ██  2. LISTENING TEST                                    ██
-- ████████████████████████████████████████████████████████████

INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status) VALUES
('a2000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001',
 'IELTS Listening Practice Test 1', '7', '40 mins', 'published');

-- ── Section 1: Hotel Booking ────────────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('b2000000-0000-0000-0000-000000000001', 'a2000000-0000-0000-0000-000000000001', 1,
 'Hotel Booking Enquiry',
 'Receptionist: Good morning, Riverside Hotel. How can I help you?
Caller: Hello, I''d like to book a room for next weekend, please.
Receptionist: Certainly. Could I take your name?
Caller: Yes, it''s Margaret Thornton. That''s T-H-O-R-N-T-O-N.
Receptionist: Thank you, Ms Thornton. And what dates were you looking at?
Caller: I''d like to check in on Friday the 14th of March and check out on Monday the 17th. So that''s three nights.
Receptionist: Let me check availability... Yes, we have rooms available. Would you prefer a standard room or a deluxe suite?
Caller: What''s the price difference?
Receptionist: A standard room is 85 pounds per night and the deluxe suite is 140 pounds per night. Both include breakfast.
Caller: I''ll go with the standard room, please.
Receptionist: Excellent. And could I have a contact telephone number?
Caller: Yes, it''s 07742 539 168.
Receptionist: Thank you. Will you be requiring parking?
Caller: Yes, please. Is there a charge?
Receptionist: Parking is complimentary for all guests. I''ll note that down. Is there anything else?
Caller: Actually, could you arrange an airport transfer for me? I''m arriving at Heathrow at 2.30 pm.
Receptionist: Of course. The transfer service costs 45 pounds each way. Shall I book a return as well?
Caller: Just the one way for now, thanks.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2000000-0000-0000-0000-000000000001', 'b2000000-0000-0000-0000-000000000001', 1,
 'sentence-completion', 'Complete the booking form below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d2000000-0000-0000-0000-000000000001', 'c2000000-0000-0000-0000-000000000001', 1,
 'Guest name: Margaret ________', 'Thornton', '["Thornton","thornton","THORNTON"]'::jsonb),
('d2000000-0000-0000-0000-000000000002', 'c2000000-0000-0000-0000-000000000001', 2,
 'Check-in date: ________ March', '14th', '["14th","14","14th of"]'::jsonb),
('d2000000-0000-0000-0000-000000000003', 'c2000000-0000-0000-0000-000000000001', 3,
 'Number of nights: ________', '3', '["3","three","Three"]'::jsonb),
('d2000000-0000-0000-0000-000000000004', 'c2000000-0000-0000-0000-000000000001', 4,
 'Room type: ________', 'standard', '["standard","Standard","standard room"]'::jsonb),
('d2000000-0000-0000-0000-000000000005', 'c2000000-0000-0000-0000-000000000001', 5,
 'Price per night: ________ pounds', '85', '["85","£85","85 pounds"]'::jsonb),
('d2000000-0000-0000-0000-000000000006', 'c2000000-0000-0000-0000-000000000001', 6,
 'Phone number: ________', '07742 539 168', '["07742 539 168","07742539168"]'::jsonb),
('d2000000-0000-0000-0000-000000000007', 'c2000000-0000-0000-0000-000000000001', 7,
 'Airport transfer from: ________', 'Heathrow', '["Heathrow","heathrow","HEATHROW"]'::jsonb),
('d2000000-0000-0000-0000-000000000008', 'c2000000-0000-0000-0000-000000000001', 8,
 'Arrival time: ________', '2.30 pm', '["2.30 pm","2:30 pm","2.30","14:30"]'::jsonb),
('d2000000-0000-0000-0000-000000000009', 'c2000000-0000-0000-0000-000000000001', 9,
 'Transfer cost (one way): ________ pounds', '45', '["45","£45","45 pounds"]'::jsonb),
('d2000000-0000-0000-0000-000000000010', 'c2000000-0000-0000-0000-000000000001', 10,
 'Parking: ________', 'complimentary', '["complimentary","free","Complimentary","Free"]'::jsonb);

-- ── Section 2: Museum Tour ──────────────────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('b2000000-0000-0000-0000-000000000002', 'a2000000-0000-0000-0000-000000000001', 2,
 'City Museum Guided Tour',
 'Guide: Welcome to the City Museum. My name is Sarah, and I''ll be taking you on today''s tour. Before we begin, let me give you a brief overview of the museum''s layout and history.

The museum was originally built in 1856 as a private residence for the industrialist William Harding. It was converted into a public museum in 1923, and since then it has undergone several major renovations, the most recent of which was completed in 2019. The museum now houses over 15,000 artefacts across three floors.

On the ground floor, where we are now, you''ll find the Natural History gallery to your left and the Ancient Civilisations gallery to your right. The Natural History gallery features an impressive collection of fossils, including a nearly complete skeleton of an Ichthyosaurus discovered in Dorset in 1987.

If you proceed upstairs to the first floor, you''ll find the Art and Culture wing. This includes rotating exhibitions — the current one showcases contemporary photography from South-East Asia and runs until the end of April. Adjacent to this is the permanent Textiles collection, which contains over 2,000 items dating from the 16th century.

The second floor is dedicated to Science and Technology. The highlight there is the interactive Engineering Lab, which is particularly popular with younger visitors. There''s also a planetarium that runs shows every hour from 10 am to 4 pm. Tickets for the planetarium are 5 pounds for adults and 3 pounds for children.

The museum café is located on the ground floor near the east exit, and the gift shop is just beside the main entrance. Photography is permitted throughout the museum, but please do not use flash in the Art and Culture wing, as it may damage the exhibits.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2000000-0000-0000-0000-000000000002', 'b2000000-0000-0000-0000-000000000002', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('d2000000-0000-0000-0000-000000000011', 'c2000000-0000-0000-0000-000000000002', 11,
 'The museum building was originally used as',
 '["A. a government office", "B. a private home", "C. a school"]'::jsonb, 'B'),
('d2000000-0000-0000-0000-000000000012', 'c2000000-0000-0000-0000-000000000002', 12,
 'How many artefacts does the museum currently contain?',
 '["A. over 5,000", "B. over 10,000", "C. over 15,000"]'::jsonb, 'C'),
('d2000000-0000-0000-0000-000000000013', 'c2000000-0000-0000-0000-000000000002', 13,
 'The current rotating exhibition features',
 '["A. paintings from Europe", "B. photography from South-East Asia", "C. sculptures from Africa"]'::jsonb, 'B'),
('d2000000-0000-0000-0000-000000000014', 'c2000000-0000-0000-0000-000000000002', 14,
 'The planetarium ticket for an adult costs',
 '["A. 3 pounds", "B. 4 pounds", "C. 5 pounds"]'::jsonb, 'C'),
('d2000000-0000-0000-0000-000000000015', 'c2000000-0000-0000-0000-000000000002', 15,
 'Flash photography is not allowed in',
 '["A. the Natural History gallery", "B. the Art and Culture wing", "C. the Science and Technology floor"]'::jsonb, 'B');

-- ── Section 3: Student-Tutor Discussion ─────────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('b2000000-0000-0000-0000-000000000003', 'a2000000-0000-0000-0000-000000000001', 3,
 'Research Project Discussion',
 'Tutor: So, James, how is your research project on renewable energy coming along?
James: Well, Dr Chen, I''ve finished the literature review and I''ve started collecting data, but I''m having some difficulties with the methodology.
Tutor: What kind of difficulties?
James: I originally planned to use a quantitative approach — distributing surveys to 200 households about their energy consumption. But the response rate has been really low. I''ve only received 43 responses so far.
Tutor: That is quite low. Have you considered supplementing it with qualitative data? You could conduct interviews with a smaller sample.
James: Actually, my partner Mei suggested the same thing. She thinks we should interview about 15 to 20 households in depth.
Tutor: That sounds reasonable. I''d suggest focusing on households that have already installed solar panels, as they can provide richer insights into the decision-making process.
James: That''s a great idea. The other issue I''m facing is the statistical analysis. I''m not confident with regression modelling.
Tutor: I''d recommend attending the statistics workshop that the department runs every Thursday. Dr Patel leads it and she''s excellent at explaining complex methods.
James: I''ll sign up for that. When is the final submission deadline?
Tutor: The report is due on the 28th of November. That gives you about six weeks. I''d suggest having a complete first draft ready by the 14th so we can review it together.
James: That sounds manageable. Should I include the raw survey data in the appendix?
Tutor: Yes, include the survey data and the interview transcripts. Also make sure you address the ethical considerations, since you''re working with human participants.
James: Right, I''ve already submitted the ethics approval form. It was approved last week.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2000000-0000-0000-0000-000000000003', 'b2000000-0000-0000-0000-000000000003', 1,
 'sentence-completion', 'Complete the notes below. Write NO MORE THAN THREE WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d2000000-0000-0000-0000-000000000016', 'c2000000-0000-0000-0000-000000000003', 16,
 'Research topic: ________ energy', 'renewable', '["renewable","Renewable"]'::jsonb),
('d2000000-0000-0000-0000-000000000017', 'c2000000-0000-0000-0000-000000000003', 17,
 'Number of survey responses received so far: ________', '43', '["43","forty-three"]'::jsonb),
('d2000000-0000-0000-0000-000000000018', 'c2000000-0000-0000-0000-000000000003', 18,
 'Mei suggests interviewing ________ households in depth.', '15 to 20', '["15 to 20","15-20","fifteen to twenty"]'::jsonb),
('d2000000-0000-0000-0000-000000000019', 'c2000000-0000-0000-0000-000000000003', 19,
 'Focus interviews on households that have installed ________.', 'solar panels', '["solar panels","Solar panels"]'::jsonb),
('d2000000-0000-0000-0000-000000000020', 'c2000000-0000-0000-0000-000000000003', 20,
 'James is not confident with ________ modelling.', 'regression', '["regression","Regression"]'::jsonb),
('d2000000-0000-0000-0000-000000000021', 'c2000000-0000-0000-0000-000000000003', 21,
 'Statistics workshop leader: Dr ________', 'Patel', '["Patel","patel","PATEL"]'::jsonb),
('d2000000-0000-0000-0000-000000000022', 'c2000000-0000-0000-0000-000000000003', 22,
 'Report submission deadline: ________ November', '28th', '["28th","28","28th of"]'::jsonb),
('d2000000-0000-0000-0000-000000000023', 'c2000000-0000-0000-0000-000000000003', 23,
 'First draft should be ready by the ________ of November.', '14th', '["14th","14"]'::jsonb),
('d2000000-0000-0000-0000-000000000024', 'c2000000-0000-0000-0000-000000000003', 24,
 'James has already received approval for the ________ form.', 'ethics', '["ethics","ethics approval","Ethics"]'::jsonb),
('d2000000-0000-0000-0000-000000000025', 'c2000000-0000-0000-0000-000000000003', 25,
 'Appendix should include survey data and interview ________.', 'transcripts', '["transcripts","Transcripts"]'::jsonb);

-- ── Section 4: University Lecture on Biology ────────────────
INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('b2000000-0000-0000-0000-000000000004', 'a2000000-0000-0000-0000-000000000001', 4,
 'Lecture: Coral Reef Ecosystems',
 'Professor: Good afternoon, everyone. Today we''re going to look at coral reef ecosystems, often referred to as the rainforests of the sea. This is a fitting analogy because, like tropical rainforests, coral reefs support an extraordinarily high level of biodiversity despite occupying a relatively small area. In fact, coral reefs cover less than one percent of the ocean floor, yet they are home to approximately 25 percent of all marine species.

Corals themselves are colonial animals belonging to the phylum Cnidaria, the same group that includes jellyfish and sea anemones. Each individual coral animal, or polyp, is typically only a few millimetres in diameter, but colonies can grow to enormous sizes over hundreds of years. The calcium carbonate skeletons secreted by polyps accumulate over time to form the reef structure.

One of the most important relationships in coral reef ecology is the symbiosis between corals and microscopic algae called zooxanthellae. These algae live within the coral tissue and provide up to 90 percent of the coral''s energy needs through photosynthesis. In return, the coral provides the algae with a protected environment and the compounds necessary for photosynthesis.

When corals are stressed — typically by elevated water temperatures — they expel their zooxanthellae, causing them to turn white in a process known as coral bleaching. If the stress is prolonged, the coral will die. The Great Barrier Reef has experienced several mass bleaching events in recent years, with the events of 2016 and 2017 being particularly severe, affecting approximately two-thirds of the reef.

Climate change is the primary long-term threat to coral reefs, but they also face localised pressures such as overfishing, coastal development, and pollution from agricultural runoff. Research published in 2023 estimated that the world has already lost approximately 14 percent of its coral reefs since 2009, a rate of decline that, if unchecked, could lead to the functional extinction of most reef systems by 2050.

Conservation strategies include the establishment of marine protected areas, the development of heat-resistant coral varieties through selective breeding and genetic modification, and large-scale reef restoration projects that involve transplanting laboratory-grown coral fragments onto degraded reefs.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2000000-0000-0000-0000-000000000004', 'b2000000-0000-0000-0000-000000000004', 1,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('d2000000-0000-0000-0000-000000000026', 'c2000000-0000-0000-0000-000000000004', 26,
 'What percentage of the ocean floor do coral reefs cover?',
 '["A. less than 1%", "B. about 5%", "C. approximately 10%", "D. around 25%"]'::jsonb, 'A'),
('d2000000-0000-0000-0000-000000000027', 'c2000000-0000-0000-0000-000000000004', 27,
 'Zooxanthellae provide corals with',
 '["A. calcium carbonate", "B. protection from predators", "C. energy through photosynthesis", "D. reproductive cells"]'::jsonb, 'C'),
('d2000000-0000-0000-0000-000000000028', 'c2000000-0000-0000-0000-000000000004', 28,
 'Coral bleaching is caused by',
 '["A. predation by fish", "B. lack of sunlight", "C. elevated water temperatures", "D. chemical pollution"]'::jsonb, 'C'),
('d2000000-0000-0000-0000-000000000029', 'c2000000-0000-0000-0000-000000000004', 29,
 'The mass bleaching events of 2016 and 2017 affected approximately what proportion of the Great Barrier Reef?',
 '["A. one quarter", "B. one third", "C. one half", "D. two thirds"]'::jsonb, 'D'),
('d2000000-0000-0000-0000-000000000030', 'c2000000-0000-0000-0000-000000000004', 30,
 'Since 2009, the world has lost roughly what percentage of its coral reefs?',
 '["A. 5%", "B. 14%", "C. 25%", "D. 50%"]'::jsonb, 'B');

-- Additional questions to reach ~40 for the listening test
INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c2000000-0000-0000-0000-000000000005', 'b2000000-0000-0000-0000-000000000004', 2,
 'sentence-completion', 'Complete the sentences below. Write NO MORE THAN TWO WORDS for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('d2000000-0000-0000-0000-000000000031', 'c2000000-0000-0000-0000-000000000005', 31,
 'Coral reefs are often called the ________ of the sea.', 'rainforests', '["rainforests","Rainforests"]'::jsonb),
('d2000000-0000-0000-0000-000000000032', 'c2000000-0000-0000-0000-000000000005', 32,
 'Individual coral animals are called ________.', 'polyps', '["polyps","Polyps","polyp"]'::jsonb),
('d2000000-0000-0000-0000-000000000033', 'c2000000-0000-0000-0000-000000000005', 33,
 'Coral skeletons are made of ________.', 'calcium carbonate', '["calcium carbonate","Calcium carbonate"]'::jsonb),
('d2000000-0000-0000-0000-000000000034', 'c2000000-0000-0000-0000-000000000005', 34,
 'At current rates, most reef systems could reach functional extinction by ________.', '2050', '["2050"]'::jsonb),
('d2000000-0000-0000-0000-000000000035', 'c2000000-0000-0000-0000-000000000005', 35,
 'Heat-resistant corals are being developed through selective breeding and ________.', 'genetic modification', '["genetic modification","Genetic modification"]'::jsonb),
('d2000000-0000-0000-0000-000000000036', 'c2000000-0000-0000-0000-000000000005', 36,
 'Reef restoration involves transplanting ________ coral fragments.', 'laboratory-grown', '["laboratory-grown","lab-grown","laboratory grown"]'::jsonb),
('d2000000-0000-0000-0000-000000000037', 'c2000000-0000-0000-0000-000000000005', 37,
 'Corals belong to the phylum ________.', 'Cnidaria', '["Cnidaria","cnidaria"]'::jsonb),
('d2000000-0000-0000-0000-000000000038', 'c2000000-0000-0000-0000-000000000005', 38,
 'A localised threat to reefs is pollution from ________ runoff.', 'agricultural', '["agricultural","Agricultural"]'::jsonb),
('d2000000-0000-0000-0000-000000000039', 'c2000000-0000-0000-0000-000000000005', 39,
 'Marine ________ areas are one conservation strategy.', 'protected', '["protected","Protected"]'::jsonb),
('d2000000-0000-0000-0000-000000000040', 'c2000000-0000-0000-0000-000000000005', 40,
 'Reefs support about ________ percent of all marine species.', '25', '["25","twenty-five"]'::jsonb);


-- ████████████████████████████████████████████████████████████
-- ██  3. WRITING TEST                                      ██
-- ████████████████████████████████████████████████████████████

INSERT INTO writing_tests (id, created_by, title, status) VALUES
('a3000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001',
 'IELTS Academic Writing Practice Test 1', 'published');

INSERT INTO writing_tasks (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, min_words, max_words, image_url) VALUES
('d3000000-0000-0000-0000-000000000001', 'a3000000-0000-0000-0000-000000000001', 1,
 'task1', 'Writing Task 1', '7', '20 mins',
 'The chart below shows the percentage of households in owned and rented accommodation in England and Wales between 1918 and 2011.

Summarise the information by selecting and reporting the main features, and make comparisons where relevant.',
 150, '', ''),
('d3000000-0000-0000-0000-000000000002', 'a3000000-0000-0000-0000-000000000001', 2,
 'task2', 'Writing Task 2', '7', '40 mins',
 'Some people think that the best way to reduce crime is to give longer prison sentences. Others, however, believe there are better alternative ways of reducing crime.

Discuss both views and give your own opinion.',
 250, '', '');


-- ════════════════════════════════════════════════════════════
-- Done! Remember to update `created_by` to your auth user id.
-- ════════════════════════════════════════════════════════════
