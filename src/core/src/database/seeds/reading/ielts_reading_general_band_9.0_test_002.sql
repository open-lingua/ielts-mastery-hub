-- ============================================================
-- IELTS Practice Platform – Extended Seed Data
-- Target: Reading Module (General Training, Band 9 Difficulty)
-- Action: APPEND (No TRUNCATE)
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST ENTRY (General Training - Band 9)                   ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('cead83ca-3cd3-473e-aec8-f59d7b1633d9', '2c22003f-9ace-42f3-ac41-5505e87dedc7',
 'IELTS General Training Reading: Zoning Ordinances, Autonomous Logistics & Algorithmic Epistemology (Band 9)', 'General Training', '9', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: Municipal Zoning and Commercial Land-Use (Q1–13)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('7f0ad61b-7c24-4ff2-a853-ee18545807cc', 'cead83ca-3cd3-473e-aec8-f59d7b1633d9', 1,
 'City of Veridian: Municipal Zoning and Commercial Land-Use Ordinance',
 'Compliance and Overview
The City of Veridian mandates stringent adherence to the updated Municipal Zoning and Commercial Land-Use Ordinance (effective January 1st). This framework is designed to preserve the aesthetic homogeny of historical districts, mitigate environmental degradation, and compartmentalize industrial noise pollution. Failure to comply with these statutory requirements may result in severe punitive actions, ranging from substantial financial levies to the outright revocation of municipal operating licenses.

Zoning Classifications and Operational Caveats
All commercial entities operating within city limits are categorized into one of three primary zoning designations, each with bespoke operational parameters:
- C1 (Boutique Retail): Restricted exclusively to retail operations generating minimal foot traffic and noise. Establishments in C1 zones are strictly prohibited from operating between the hours of 20:00 and 06:00. Deliveries must be completed using vehicles with a gross weight not exceeding 3.5 tonnes.
- C2 (High-Density Commercial): Designated for high-volume retail, dining, and entertainment venues. While operating hours are unrestricted, these entities must submit an annual environmental impact dossier detailing waste management protocols and energy consumption metrics. 
- M1 (Light Manufacturing): Reserved for non-toxic fabrication and warehousing. M1 entities are subject to rigorous acoustic monitoring. Industrial noise pollution must not exceed 85 decibels at the property boundary line at any time; violations incur an immediate cessation of operations until remedial acoustic dampening is installed.

Aesthetic Compliance and Historical Overlays
Properties situated within the defined "Heritage Overlay Sector" (HOS) are subject to superseding architectural regulations, overriding standard C1 or C2 guidelines. Any exterior modifications, including signage, facade painting, or window replacements, require preliminary authorization from the Veridian Heritage Committee. Submissions must include detailed architectural schematics and material samples. Processing times for these applications routinely span 90 to 120 days. 

Dispensations and Penalties
Businesses seeking temporary exemptions from specific zoning restrictions (e.g., extended operating hours for seasonal events) may apply for a Temporary Dispensation Permit. These are valid for a maximum duration of six months and are strictly non-renewable. Continuous disregard for zoning parameters is classified as a "Tier-Three Violation," culminating in the immediate suspension of commercial activities and mandatory remediation at the proprietor’s expense.');

-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('36eb63c4-2f55-4e81-8e87-48df301f740c', '7f0ad61b-7c24-4ff2-a853-ee18545807cc', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the text? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('629bcde2-ace1-4d39-a708-c6ad40eaab19', '36eb63c4-2f55-4e81-8e87-48df301f740c', 1,
 'Businesses classified under C1 zoning are legally permitted to operate 24 hours a day.', 'FALSE', '["FALSE","False","false"]'),
('2a23350b-5f48-41ce-ba75-5ca0daad5163', '36eb63c4-2f55-4e81-8e87-48df301f740c', 2,
 'The Veridian Heritage Committee requires an independent architect to verify all facade alterations.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('83159348-deb8-4d85-bb05-a2879bccc789', '36eb63c4-2f55-4e81-8e87-48df301f740c', 3,
 'Regulations outlined in the Heritage Overlay Sector take precedence over standard commercial zoning laws.', 'TRUE', '["TRUE","True","true"]'),
('ebf4a83c-550b-42d6-9626-e603afd735b4', '36eb63c4-2f55-4e81-8e87-48df301f740c', 4,
 'A Temporary Dispensation Permit can be extended for an additional six months if requested in advance.', 'FALSE', '["FALSE","False","false"]');

-- ── Group 2: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('fafd0d51-bd4a-456d-9e2f-10053fbc07d8', '7f0ad61b-7c24-4ff2-a853-ee18545807cc', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN THREE WORDS AND/OR A NUMBER from the text for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('f4074cdc-7699-4ebc-bfef-47139b8780c9', 'fafd0d51-bd4a-456d-9e2f-10053fbc07d8', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"Zoning Category","answer":""},{"id":"h2","gapText":"Primary Function","answer":""},{"id":"h3","gapText":"Specific Mandate / Restriction","answer":""}]'),
('9a083f72-7b53-4f28-b75c-b22d62590348', 'fafd0d51-bd4a-456d-9e2f-10053fbc07d8', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"C1","answer":""},{"id":"c2","gapText":"{{gap}} retail","answer":"Boutique"},{"id":"c3","gapText":"Deliveries limited to vehicles under 3.5 tonnes","answer":""}]'),
('8abf84d2-a3be-436e-9a97-6a1c7ef4e8d7', 'fafd0d51-bd4a-456d-9e2f-10053fbc07d8', 7,
 'Row 3', '',
 '[{"id":"c4","gapText":"C2","answer":""},{"id":"c5","gapText":"High-volume venues","answer":""},{"id":"c6","gapText":"Must submit an annual {{gap}}","answer":"environmental impact dossier"}]'),
('89f8b86d-1a97-43de-a753-768d6019e6b2', 'fafd0d51-bd4a-456d-9e2f-10053fbc07d8', 8,
 'Row 4', '',
 '[{"id":"c7","gapText":"M1","answer":""},{"id":"c8","gapText":"Non-toxic fabrication","answer":""},{"id":"c9","gapText":"Noise strictly limited to {{gap}} at the boundary","answer":"85 decibels"}]'),
('c57e129d-0b62-4225-b5e1-333e661504cd', 'fafd0d51-bd4a-456d-9e2f-10053fbc07d8', 9,
 'Row 5', '',
 '[{"id":"c10","gapText":"HOS","answer":""},{"id":"c11","gapText":"Historical preservation","answer":""},{"id":"c12","gapText":"Applications require schematics and {{gap}}","answer":"material samples"}]');

-- ── Group 3: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('cb9b7a4c-2e42-4135-a9df-e736cc2e8927', '7f0ad61b-7c24-4ff2-a853-ee18545807cc', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS from the text for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('98a062ee-a00b-4987-bf31-0e43d05a8f32', 'cb9b7a4c-2e42-4135-a9df-e736cc2e8927', 10,
 'What is the ultimate punishment for failing to adhere to the city’s statutory requirements?', 'revocation', '[{"id":"1","text":"revocation"},{"id":"2","text":"outright revocation"},{"id":"3","text":"operating licenses revocation"}]'),
('69f78f43-65a5-47a8-93dc-d1bbd66f6582', 'cb9b7a4c-2e42-4135-a9df-e736cc2e8927', 11,
 'What must M1 entities install if they breach acoustic regulations?', 'acoustic dampening', '[{"id":"1","text":"acoustic dampening"},{"id":"2","text":"remedial acoustic dampening"}]'),
('49c12185-c96c-4ad8-b6a0-f3e05787793c', 'cb9b7a4c-2e42-4135-a9df-e736cc2e8927', 12,
 'Who grants permission for exterior modifications in historical sectors?', 'Heritage Committee', '[{"id":"1","text":"Heritage Committee"},{"id":"2","text":"Veridian Heritage Committee"}]'),
('56eaeddb-7579-4b07-92da-6962b4f152af', 'cb9b7a4c-2e42-4135-a9df-e736cc2e8927', 13,
 'What is the classification given to a business that persistently ignores zoning laws?', 'Tier-Three Violation', '[{"id":"1","text":"Tier-Three Violation"},{"id":"2","text":"a Tier-Three Violation"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Decentralized Autonomous Supply Chains (Q14–27)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('ef260ea1-9f3a-424f-8302-8457309e76d8', 'cead83ca-3cd3-473e-aec8-f59d7b1633d9', 2,
 'Meridian Logistics: Implementation of Decentralized Autonomous Supply Chains',
 '(A) The traditional architecture of global logistics, characterized by centralized oversight and labyrinthine paper trails, is rapidly facing obsolescence. Meridian Logistics is pioneering the transition toward a Decentralized Autonomous Supply Chain (DASC). This paradigm shift fundamentally displaces centralized human coordination in favor of distributed algorithmic governance. By leveraging advanced cryptographic networks, DASC eliminates the latency and profound inefficiencies inherent in legacy systems, pivoting the enterprise toward a frictionless, autonomous operational model.

(B) The operational nucleus of DASC is blockchain technology. Historically, tracking a physical asset across international borders involved relying on a fragmented web of distinct corporate databases, each vulnerable to manipulation, transcription errors, or system failure. Blockchain circumvents this vulnerability by establishing an immutable, distributed ledger. Every scan, transfer of custody, or border crossing is cryptographically sealed into a block that cannot be retroactively altered. This ensures a flawless, transparent provenance of goods, crucial for high-value assets and pharmaceuticals where origin verification is legally mandated.

(C) This immutable tracking is substantially augmented by the integration of sophisticated Internet of Things (IoT) sensors, particularly critical within cold-chain logistics. Sensitive freight, such as biological therapeutics or perishable agricultural yields, demands rigorous temperature homeostasis. In the DASC framework, embedded micro-sensors continuously transmit ambient telemetry—temperature, humidity, and barometric pressure—directly to the ledger. Should an environmental threshold be breached, the system unilaterally flags the consignment as compromised in real-time, instantly notifying the recipient and halting onward transit to prevent the distribution of spoiled goods.

(D) Perhaps the most disruptive facet of DASC is the implementation of "smart contracts" to automate dispute mediation and financial remediation. In a conventional supply chain, a breached cold-chain container would instigate a protracted, manual claims process involving multiple insurance adjusters and legal representatives. Conversely, a smart contract is self-executing software intrinsically linked to the IoT sensor data. If the sensor records a temperature deviation beyond the stipulated parameters, the smart contract automatically executes the penalty clause, instantly transferring financial compensation from the logistics provider’s escrow account to the client, entirely devoid of human intervention.

(E) The displacement of manual tracking necessitates a radical metamorphosis of the workforce. Meridian Logistics acknowledges that the automation of administrative routing and conflict resolution renders traditional logistics coordination redundant. Consequently, the organization is instituting aggressive upskilling initiatives. The objective is to transition the workforce from manual data entry operators into systemic auditors and algorithmic exception handlers. Employees are being trained to manage the peripheral anomalies that the DASC struggles to contextualize, such as physical infrastructure damage or localized geopolitical disruptions.

(F) Despite its formidable operational advantages, DASC encounters significant friction regarding international jurisprudence and cross-border data sovereignty. Because a distributed ledger inherently duplicates data across servers globally, it frequently contravenes localized data localization laws which mandate that specific commercial data must reside exclusively on servers within the host nation’s borders. Reconciling the borderless architecture of decentralized technology with the deeply entrenched, geographically bound frameworks of international trade law remains Meridian’s most formidable exogenous challenge.');

-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('b69f2497-9605-4ea8-ade3-e807c8bf87ed', 'ef260ea1-9f3a-424f-8302-8457309e76d8', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. The obsolescence of centralized models", "ii. Maintaining integrity in temperature-sensitive transit", "iii. Navigating international legal frameworks and localization", "iv. Generating new employment opportunities in logistics", "v. Automating conflict mediation and financial penalties", "vi. Ensuring an immutable ledger of origin", "vii. The financial cost of upgrading to DASC networks", "viii. The evolution of employee responsibilities"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('49875d99-667c-47a3-877c-f6ffdc613bae', 'b69f2497-9605-4ea8-ade3-e807c8bf87ed', 14, 'Paragraph A', 'i'),
('df13f677-0a9b-4c42-910b-2eba997371ee', 'b69f2497-9605-4ea8-ade3-e807c8bf87ed', 15, 'Paragraph B', 'vi'),
('7f921b1a-b4f1-4456-bf1a-724bcca101aa', 'b69f2497-9605-4ea8-ade3-e807c8bf87ed', 16, 'Paragraph C', 'ii'),
('0507f027-f426-4e3f-8a7e-72d0e04d66d9', 'b69f2497-9605-4ea8-ade3-e807c8bf87ed', 17, 'Paragraph D', 'v'),
('9f5482d3-bbe7-4501-b9df-7a6a29c9ed8b', 'b69f2497-9605-4ea8-ade3-e807c8bf87ed', 18, 'Paragraph E', 'viii'),
('4209678f-d594-4c91-acb1-ee5300776e99', 'b69f2497-9605-4ea8-ade3-e807c8bf87ed', 19, 'Paragraph F', 'iii');

-- ── Group 5: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('1761c675-89c8-49e2-9481-32b5f4bdd4f0', 'ef260ea1-9f3a-424f-8302-8457309e76d8', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('a22780e0-5377-48da-be82-3d3a19e12368', '1761c675-89c8-49e2-9481-32b5f4bdd4f0', 20,
 'A reference to the specific hardware used to monitor environmental conditions in transit.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('ffe21c23-6fff-48a3-93b2-dd7c6ae6a75e', '1761c675-89c8-49e2-9481-32b5f4bdd4f0', 21,
 'An explanation of how contracts can be executed without any human authorization.', 'D',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('555b753d-6828-43c9-b436-040ebc0facaa', '1761c675-89c8-49e2-9481-32b5f4bdd4f0', 22,
 'The inherent conflict between global digital ledgers and national data storage requirements.', 'F',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('3694fcbe-4910-4b35-8c57-ac730d83b1bd', '1761c675-89c8-49e2-9481-32b5f4bdd4f0', 23,
 'How the company intends to retrain its staff to handle complex logistical anomalies.', 'E',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');

-- ── Group 6: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('4c21ecb5-ee9a-4651-8cbd-6f190e14ece2', 'ef260ea1-9f3a-424f-8302-8457309e76d8', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('6c6f2758-8943-4593-8ff8-2ac42ced352c', '4c21ecb5-ee9a-4651-8cbd-6f190e14ece2', 24,
 'According to Paragraph B, what is the principal vulnerability of traditional asset tracking?',
 'A',
 '[{"id":"A","text":"A. Reliance on fragmented corporate databases prone to manipulation and errors.","isCorrect":true},{"id":"B","text":"B. The excessive costs associated with employing manual data entry clerks.","isCorrect":false},{"id":"C","text":"C. The inability of government regulators to access international shipping manifests.","isCorrect":false},{"id":"D","text":"D. Cryptographic failures causing entire ledgers to be retroactively altered.","isCorrect":false}]'),
('fe14f6d4-75d5-4593-95fd-1e28819dd446', '4c21ecb5-ee9a-4651-8cbd-6f190e14ece2', 25,
 'In Paragraph C, what immediate action does the system take if a temperature threshold is breached?',
 'C',
 '[{"id":"A","text":"A. It lowers the temperature of the container to preserve the cargo.","isCorrect":false},{"id":"B","text":"B. It automatically triggers a legal investigation by the host nation.","isCorrect":false},{"id":"C","text":"C. It flags the cargo as compromised and stops it from continuing its journey.","isCorrect":true},{"id":"D","text":"D. It alerts the driver to manually update the blockchain ledger.","isCorrect":false}]'),
('65afc5f6-a25d-4e56-b0d4-56219f112286', '4c21ecb5-ee9a-4651-8cbd-6f190e14ece2', 26,
 'The primary advantage of "smart contracts" in DASC (Paragraph D) is that they:',
 'D',
 '[{"id":"A","text":"A. Provide legal protection against fraudulent insurance adjusters.","isCorrect":false},{"id":"B","text":"B. Ensure the physical integrity of biological therapeutics during transit.","isCorrect":false},{"id":"C","text":"C. Require multiple human approvals to ensure financial accuracy.","isCorrect":false},{"id":"D","text":"D. Automate financial compensation without the need for human intervention.","isCorrect":true}]'),
('92a27afe-d749-427c-b9ef-72665652c452', '4c21ecb5-ee9a-4651-8cbd-6f190e14ece2', 27,
 'What is the main challenge mentioned in Paragraph F regarding data sovereignty?',
 'B',
 '[{"id":"A","text":"A. Cybercriminals frequently target international servers to steal commercial data.","isCorrect":false},{"id":"B","text":"B. The decentralized nature of blockchain conflicts with local data storage laws.","isCorrect":true},{"id":"C","text":"C. Governments refuse to recognize smart contracts as legally binding agreements.","isCorrect":false},{"id":"D","text":"D. Different nations use incompatible forms of cryptography to secure borders.","isCorrect":false}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: The Epistemology of AI in Diagnostics (Q28–40)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('a2c853bd-bad0-49b6-95fb-83d3ef35324f', 'cead83ca-3cd3-473e-aec8-f59d7b1633d9', 3,
 'The Epistemology of Artificial Intelligence in Medical Diagnostics',
 '(A) The integration of Deep Learning (DL) architectures into medical diagnostics represents a profound epistemological paradigm shift. Historically, clinical knowledge was rooted in human heuristic reasoning—a physician aggregating patient history, observable symptoms, and biological markers to deduce a pathology. This cognitive process is inherently interpretable; a doctor can articulate the sequential logic that led to a specific diagnosis. However, the advent of AI, particularly Convolutional Neural Networks (CNNs) utilized in radiology and oncology, transitions clinical deduction from a realm of interpretable human intuition to algorithmic determinism, fundamentally altering what it means to "know" a patient’s condition.

(B) The primary philosophical friction arises from the "black box" nature of advanced deep learning models. While a CNN can identify early-stage malignant neoplasms on an MRI with an accuracy rate statistically superior to a panel of expert oncologists, the algorithm cannot explicitly elucidate its reasoning. The neural network recognizes hyper-dimensional geometric patterns and pixel gradients that are entirely imperceptible to the human eye. Consequently, the physician is presented with a binary output—malignant or benign—devoid of the underlying pathophysiological rationale. This opacity forces the medical community into an uncomfortable reliance on probabilistic output rather than mechanistic understanding.

(C) This absence of interpretability introduces a profound dilemma regarding diagnostic certainty and trust. If an AI system flags a seemingly healthy patient’s lung scan as anomalous, but the attending pulmonologist cannot visually corroborate the finding, whose judgment should prevail? Rejecting the algorithm’s output risks ignoring a potentially life-saving early detection. Conversely, blindly accepting an uninterpretable algorithmic conclusion essentially reduces the highly trained physician to a mere administrative conduit, transferring the locus of medical authority from human expertise to a proprietary algorithm.

(D) To mitigate this epistemological crisis, prominent biomedical ethicists advocate for the implementation of "centaur" diagnostic models—a symbiotic framework prioritizing human-AI collaboration over pure algorithmic autonomy. In a centaur model, the AI functions not as a definitive oracle, but as a highly sophisticated diagnostic augment. The system is engineered with "Explainable AI" (XAI) overlays, which attempt to reverse-engineer the algorithm’s decision by highlighting the specific anatomical regions of the scan that heavily influenced the output. This visual telemetry provides the physician with actionable context, allowing them to synthesize the algorithmic insight with their holistic clinical assessment.

(E) Despite these technological compromises, the widespread adoption of diagnostic AI is severely bottlenecked by malpractice jurisprudence. The legal frameworks governing medical liability are predicated on human agency and negligence. If a purely algorithmic misdiagnosis results in patient mortality, the allocation of liability is remarkably ambiguous. Is the culpable party the attending physician who deferred to the machine, the hospital administration that procured the software, or the corporate developers who trained the algorithm on flawed datasets? Until legislative bodies establish a clear precedent for algorithmic malpractice, medical institutions remain highly risk-averse, utilizing AI strictly in a secondary, advisory capacity.

(F) Ultimately, the integration of artificial intelligence forces a systemic reevaluation of clinical epistemology. The medical community must reconcile itself to the reality that absolute mechanistic transparency may no longer be a prerequisite for diagnostic accuracy. Just as early medicine had to accept the efficacy of certain pharmaceuticals before fully understanding their molecular mechanisms, modern medicine is challenged to accept the validity of hyper-dimensional algorithmic insights. The future of diagnostics relies not on demystifying the black box entirely, but on constructing robust frameworks of collaborative validation, where human intuition and machine precision operate in an inextricably linked diagnostic synthesis.');

-- ── Group 7: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('13481f4b-ca27-43ff-935e-0f8dad2e1230', 'a2c853bd-bad0-49b6-95fb-83d3ef35324f', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('f650a69c-fa8b-40e4-8ee6-e2909f04696e', '13481f4b-ca27-43ff-935e-0f8dad2e1230', 28,
 'Historically, medical diagnoses were formulated through a process that doctors could easily explain and justify.', 'YES', '["YES","Yes","yes"]'),
('b8285d11-f9a8-4d2a-bc16-888bde6dabfb', '13481f4b-ca27-43ff-935e-0f8dad2e1230', 29,
 'Deep learning algorithms designed for radiology can clearly articulate the physiological reasons behind their diagnostic outputs.', 'NO', '["NO","No","no"]'),
('1b7cf256-4a56-4254-972a-f05cec76d169', '13481f4b-ca27-43ff-935e-0f8dad2e1230', 30,
 'Patients generally exhibit a higher degree of trust in algorithmic diagnoses than in human physicians.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('f3bc4c0d-2844-4b8e-bbc8-b9e306c37232', '13481f4b-ca27-43ff-935e-0f8dad2e1230', 31,
 'Current malpractice laws are perfectly suited to handle cases involving errors made by artificial intelligence.', 'NO', '["NO","No","no"]');

-- ── Group 8: MATCHING SENTENCE ENDINGS (Q32–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('d2d0033d-3082-44ea-a69b-b96f283dbbb9', 'a2c853bd-bad0-49b6-95fb-83d3ef35324f', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('dca97384-f34b-453a-b3c6-950c3f6227ab', 'd2d0033d-3082-44ea-a69b-b96f283dbbb9', 32,
 'The fundamental "black box" issue in medical AI refers to its inability',
 'C',
 '[{"id":"A","text":"to identify microscopic geometric patterns that human doctors frequently miss.","isCorrect":false},{"id":"B","text":"a collaborative relationship between human practitioners and algorithmic intelligence.","isCorrect":false},{"id":"C","text":"to reveal the specific internal logic or processes used to arrive at a conclusion.","isCorrect":true},{"id":"D","text":"remains a significant barrier preventing hospitals from fully relying on AI.","isCorrect":false},{"id":"E","text":"to reconsider the traditional definitions of diagnostic certainty and clinical knowledge.","isCorrect":false},{"id":"F","text":"will automatically assume full legal liability in the event of patient mortality.","isCorrect":false}]'),
('b3333413-93ec-4665-b88e-d0a3750cf7a3', 'd2d0033d-3082-44ea-a69b-b96f283dbbb9', 33,
 'The implementation of a "centaur" diagnostic model strongly promotes',
 'B',
 '[{"id":"A","text":"to identify microscopic geometric patterns that human doctors frequently miss.","isCorrect":false},{"id":"B","text":"a collaborative relationship between human practitioners and algorithmic intelligence.","isCorrect":true},{"id":"C","text":"to reveal the specific internal logic or processes used to arrive at a conclusion.","isCorrect":false},{"id":"D","text":"remains a significant barrier preventing hospitals from fully relying on AI.","isCorrect":false},{"id":"E","text":"to reconsider the traditional definitions of diagnostic certainty and clinical knowledge.","isCorrect":false},{"id":"F","text":"will automatically assume full legal liability in the event of patient mortality.","isCorrect":false}]'),
('214c3fd1-bab8-4244-a521-fbf9220a7b15', 'd2d0033d-3082-44ea-a69b-b96f283dbbb9', 34,
 'The ambiguity surrounding legal responsibility in cases of algorithmic error',
 'D',
 '[{"id":"A","text":"to identify microscopic geometric patterns that human doctors frequently miss.","isCorrect":false},{"id":"B","text":"a collaborative relationship between human practitioners and algorithmic intelligence.","isCorrect":false},{"id":"C","text":"to reveal the specific internal logic or processes used to arrive at a conclusion.","isCorrect":false},{"id":"D","text":"remains a significant barrier preventing hospitals from fully relying on AI.","isCorrect":true},{"id":"E","text":"to reconsider the traditional definitions of diagnostic certainty and clinical knowledge.","isCorrect":false},{"id":"F","text":"will automatically assume full legal liability in the event of patient mortality.","isCorrect":false}]'),
('ed95df7e-573d-428a-af1f-56bce2510def', 'd2d0033d-3082-44ea-a69b-b96f283dbbb9', 35,
 'The integration of sophisticated neural networks forces the medical community',
 'E',
 '[{"id":"A","text":"to identify microscopic geometric patterns that human doctors frequently miss.","isCorrect":false},{"id":"B","text":"a collaborative relationship between human practitioners and algorithmic intelligence.","isCorrect":false},{"id":"C","text":"to reveal the specific internal logic or processes used to arrive at a conclusion.","isCorrect":false},{"id":"D","text":"remains a significant barrier preventing hospitals from fully relying on AI.","isCorrect":false},{"id":"E","text":"to reconsider the traditional traditional definitions of diagnostic certainty and clinical knowledge.","isCorrect":true},{"id":"F","text":"will automatically assume full legal liability in the event of patient mortality.","isCorrect":false}]');

-- ── Group 9: SUMMARY COMPLETION with Word Bank (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('c1aa0019-25f6-4f34-9bbc-be7e4d6ae9e4', 'a2c853bd-bad0-49b6-95fb-83d3ef35324f', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["opacity", "certainty", "liability", "transparency", "automation", "collaborative", "knowledge", "efficiency"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('5d2ad65f-f853-497d-bbf6-a9ac3937e2e5', 'c1aa0019-25f6-4f34-9bbc-be7e4d6ae9e4', 36,
 'The use of Artificial Intelligence in medical diagnostics represents a profound shift. A significant challenge is the inherent {{gap_c1aa0019-25f6-4f34-9bbc-be7e4d6ae9e4_0}} of deep learning models, which generate highly accurate outputs without explaining their reasoning. This creates a philosophical dilemma regarding diagnostic {{gap_c1aa0019-25f6-4f34-9bbc-be7e4d6ae9e4_1}} when human physicians cannot visually verify the machine’s findings. To resolve this, experts recommend {{gap_c1aa0019-25f6-4f34-9bbc-be7e4d6ae9e4_2}} models, allowing doctors and algorithms to work in synthesis. However, legal issues regarding {{gap_c1aa0019-25f6-4f34-9bbc-be7e4d6ae9e4_3}} in cases of misdiagnosis continue to prevent hospitals from fully relying on the technology. Ultimately, the medical profession must adapt its understanding of clinical {{gap_c1aa0019-25f6-4f34-9bbc-be7e4d6ae9e4_4}} to accept tools that function beyond human interpretation.',
 'opacity'),
('496433ac-127f-427b-a34b-95847ba70d60', 'c1aa0019-25f6-4f34-9bbc-be7e4d6ae9e4', 37,
 '', 'certainty'),
('334a6f14-d68e-44f1-863f-e1799b74b5a5', 'c1aa0019-25f6-4f34-9bbc-be7e4d6ae9e4', 38,
 '', 'collaborative'),
('f28ac667-574c-4898-8a76-80666f619cc7', 'c1aa0019-25f6-4f34-9bbc-be7e4d6ae9e4', 39,
 '', 'liability'),
('b3f72a0f-d162-4ec5-af93-17a96d717747', 'c1aa0019-25f6-4f34-9bbc-be7e4d6ae9e4', 40,
 '', 'knowledge');

-- ============================================================
-- NOTE: Please execute `UPDATE reading_tests SET created_by = '<your-uid>'` 
-- if required by your application's Row Level Security policies.
-- ============================================================
