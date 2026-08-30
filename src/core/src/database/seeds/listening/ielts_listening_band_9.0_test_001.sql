-- ============================================================
-- IELTS Practice Platform – Seed Data
-- Target: Listening Module (Band 9 Difficulty)
-- Description: Expert-level listening test featuring intricate 
-- paraphrasing, dense academic language, rapid native speech 
-- patterns, and complex distractors.
-- ============================================================

-- ████████████████████████████████████████████████████████████
-- ██  LISTENING TEST RECORD                                 ██
-- ████████████████████████████████████████████████████████████

INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status) VALUES
('000943d4-b549-4bf2-a044-542e900e2904', '94c107a6-d3be-4014-bfa0-f0b7706d047c',
 'IELTS Expert Listening: Art Logistics, Subterranean Railways & Epigenetics (Band 9)', '9', '40 mins', 'published');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 1: Transactional Dialogue (Art Freight Booking) ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('d1ce8ab8-8153-4b43-9a55-1dc979698973', '000943d4-b549-4bf2-a044-542e900e2904', 1,
 'Fine Art Freight Booking',
 'Agent: Good morning, Vanguard Fine Art Logistics, Clara speaking. How may I direct your inquiry today?
Client: Hello, Clara. My name is Arthur Penhaligon. I need to arrange expedited international freight for a rather delicate sculptural exhibition. We’re on a tremendously tight schedule.
Agent: I can certainly assist with that, Mr. Penhaligon. Are you currently a registered corporate client with Vanguard?
Client: Yes, we hold an account. The gallery name is Galloway Contemporary. That’s G-A-L-L-O-W-A-Y. 
Agent: Thank you. Pulling up your profile now. Yes, Galloway Contemporary in Mayfair. Now, what is the final destination for this consignment? 
Client: It’s heading to an exhibition space in Kyoto, Japan. Originally, we were scheduled for Tokyo, but the venue encountered structural issues, so we’ve had to pivot rapidly.
Agent: Kyoto it is. And what is the absolute latest date this shipment can arrive?
Client: The installation team begins their work on the 20th of May. So, the crates absolutely must clear customs and be at the venue by the 18th of May, at the very latest. 
Agent: The 18th of May. Understood. Now, I need some specifications regarding the freight itself. What are the dimensions of the largest piece?
Client: The centrepiece is rather imposing. It stands exactly 2.5 metres tall, though it can be disassembled into three separate components if necessary.
Agent: If it can remain intact, we prefer that to minimize handling risks. Now, given the delicate nature of sculptures, will you require standard crating, or something more specialized?
Client: Definitely specialized. The pieces are sensitive to humidity, so we mandate climate-controlled crating for the entire transit.
Agent: Climate-controlled crates added to the manifest. Could you also confirm the primary material of these sculptures? It dictates our handling protocols.
Client: The majority of the collection is cast bronze, but the fragile centrepiece I mentioned earlier is carved entirely from marble. 
Agent: Marble requires robust shock-absorption packing. I’ll make a note of that. Now, regarding the financial side, what is the total declared insurance value of the consignment?
Client: For the comprehensive policy, the total declared value is £450,000. 
Agent: £450,000, noted. Moving on to international customs. Because this is a temporary exhibition and the items will return to the UK, you won’t need to pay standard import duties, but you will need to provide a specific document. Do you have an ATA Carnet ready?
Client: Our legal team is finalizing the Carnet now. What else is required?
Agent: We will also need a fully itemized commercial invoice to accompany the shipment. Customs officials are incredibly strict about that right now.
Client: A commercial invoice. I will have my assistant email that over this afternoon. What about security at your holding facility before departure?
Client: I was going to ask about that. We require biometric verification for anyone accessing the crates.
Agent: Yes, our high-security vault uses fingerprint scanning for all authorized personnel. No one gets near your artwork without a digital trace.
Client: Excellent. That satisfies our insurance underwriters. Finally, where should our transport team deliver the artwork to you?
Agent: Don’t bring it to our Mayfair office. All heavy freight must be delivered directly to our processing warehouse near Heathrow. I’ll email you the exact coordinates. 
Client: Perfect. I’ll await your email to finalize the deposit.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('58c03e4e-72f9-487c-880a-16f9cc7b2d0f', 'd1ce8ab8-8153-4b43-9a55-1dc979698973', 1,
 'sentence-completion', 'Complete the booking form below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('595fd9aa-8b54-4bdb-8dba-90c1e0ac0018', '58c03e4e-72f9-487c-880a-16f9cc7b2d0f', 1,
 'Gallery Account Name: ________ Contemporary', 'Galloway', '["Galloway","galloway","GALLOWAY"]'),
('0c1e8e2d-8184-451d-9f7e-7dc6a4802444', '58c03e4e-72f9-487c-880a-16f9cc7b2d0f', 2,
 'Revised destination for the exhibition: ________', 'Kyoto', '["Kyoto","kyoto","KYOTO"]'),
('8a060b85-9d92-4fd7-886e-6ffb929d529f', '58c03e4e-72f9-487c-880a-16f9cc7b2d0f', 3,
 'Strict deadline for arrival: ________', '18th May', '["18th May","18 May","May 18","May 18th"]'),
('9da9a31a-b41e-4244-bfe3-d4ccab8fa0d3', '58c03e4e-72f9-487c-880a-16f9cc7b2d0f', 4,
 'Height of the largest item: ________', '2.5 metres', '["2.5 metres","2.5 meters","2.5m"]'),
('872e4995-85c7-4669-ae06-c22d1e7d84b0', '58c03e4e-72f9-487c-880a-16f9cc7b2d0f', 5,
 'Type of crating requested: ________', 'climate-controlled', '["climate-controlled","climate controlled","Climate-controlled"]'),
('5a384077-fbb9-4748-b848-5de7d25b109b', '58c03e4e-72f9-487c-880a-16f9cc7b2d0f', 6,
 'Material of the most fragile piece: ________', 'marble', '["marble","Marble"]'),
('725c721d-7ad6-4757-afc3-d344f75274bf', '58c03e4e-72f9-487c-880a-16f9cc7b2d0f', 7,
 'Total declared value: £________', '450,000', '["450,000","450000"]'),
('881384b6-a160-4cf2-bb19-d01d340532ef', '58c03e4e-72f9-487c-880a-16f9cc7b2d0f', 8,
 'Document required by customs: A ________', 'commercial invoice', '["commercial invoice","Commercial invoice","Commercial Invoice"]'),
('3191ea47-7fa1-421b-a979-0051902b8c84', '58c03e4e-72f9-487c-880a-16f9cc7b2d0f', 9,
 'Security measure at the holding facility: ________ scanning', 'fingerprint', '["fingerprint","Fingerprint"]'),
('4078efe9-3d9b-46db-aef5-399b33eaf046', '58c03e4e-72f9-487c-880a-16f9cc7b2d0f', 10,
 'Items must be delivered directly to the company''s ________', 'warehouse', '["warehouse","processing warehouse","Warehouse"]');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 2: Monologue (Subterranean Railway Tour)        ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('757fcfc7-da54-4fd7-809a-9dee7c45f636', '000943d4-b549-4bf2-a044-542e900e2904', 2,
 'Subterranean Heritage Project Orientation',
 'Director: Welcome, everyone, to the Aldwych Subterranean Heritage Project. I’m Julian, the site director. Before you begin shadowing our veteran guides today, I need to bring you up to speed on some critical operational updates.

As you likely know, this disused underground station served as a wartime bunker and a filming location for decades. What you might not know is why it ultimately closed to the public in the 1990s. While passenger numbers were indeed dwindling, the definitive nail in the coffin was actually the prohibitive cost of replacing the original 1906 elevator systems to meet modern fire regulations. The transport authority simply couldn''t justify the expense. 

Recently, we finally secured the rights to open it for public heritage tours. Securing funding was arduous. We initially applied to the National Lottery Heritage Fund, but our application was deferred. Ultimately, it was an independent crowdfunding campaign, driven by local transport enthusiasts, that raised the capital required to make the site safe for visitors. 

Regarding safety, our protocols are rigorous. Because the air quality deep underground can be stagnant and dust levels are high, all staff and visitors are mandated to wear respiratory masks. Surprisingly, we do not require hard hats, as the tunnel ceilings have been completely reinforced and inspected, but the air quality is non-negotiable. Additionally, while we strive for inclusivity, the sheer number of spiral staircases means this specific tour is unfortunately completely inaccessible to wheelchair users. 

Now, let’s acquaint you with the layout of the upper concourse. Please look at the map provided. We are currently standing at the Main Entrance on the Strand, right at the top of your map. 

If you proceed through the entrance, immediately on your left is the original Edwardian Ticket Hall. We’ve fully restored the vintage wooden booths there. 

Walking straight past the Ticket Hall, the corridor branches. If you take the narrow corridor peeling off to the right, it leads you directly to the Ventilation Shaft. This is a massive vertical tunnel that used to draw fresh air down to the platforms; the sheer drop is quite dizzying to look down.

Going back to the main path, continue straight ahead until you reach the top of the grand staircase. Before you descend, look to the small room tucked into the corner on your left. That is the old Signal Box, which still contains the complex analog lever mechanisms used to route the trains.

Now, descend the grand staircase. At the bottom, the space opens up significantly. Taking the left archway brings you onto Platform 2. This is the platform that is famously used by film crews, complete with a stationary vintage train carriage.

Finally, if you take the right archway at the bottom of the staircase instead, it leads into a long, dead-end tunnel. Right at the very end of this tunnel sits the Generator Room. It’s quite dark, but it houses the massive emergency dynamos installed during the Second World War.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('d2c5fd81-b89a-4726-aade-06df7a327109', '757fcfc7-da54-4fd7-809a-9dee7c45f636', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('53267cfc-078e-49e5-9da7-ffaeac705e37', 'd2c5fd81-b89a-4726-aade-06df7a327109', 11,
 'What was the primary reason the station closed in the 1990s?',
 '["A. A drastic drop in passenger usage", "B. The excessive cost of upgrading safety infrastructure", "C. Severe structural damage to the tunnels"]', 'B'),
('b92de4d7-f4a5-4903-9b60-4bcceb2bd52a', 'd2c5fd81-b89a-4726-aade-06df7a327109', 12,
 'How was the recent heritage project primarily funded?',
 '["A. A National Lottery Heritage grant", "B. Corporate sponsorship from transport companies", "C. A public crowdfunding campaign"]', 'C'),
('889adc7d-aa24-4166-a764-b5ea3c132966', 'd2c5fd81-b89a-4726-aade-06df7a327109', 13,
 'What safety equipment is mandatory for everyone entering the site?',
 '["A. Hard hats", "B. Respiratory masks", "C. High-visibility jackets"]', 'B'),
('1c615cbb-9fcf-4683-aedf-a2fb3f6a86e5', 'd2c5fd81-b89a-4726-aade-06df7a327109', 14,
 'Why are hard hats not required?',
 '["A. The ceilings are extremely high", "B. They restrict visibility in dark areas", "C. The tunnel roofs have been recently reinforced"]', 'C'),
('a26f8771-41de-49c1-92b0-469d3cfe9856', 'd2c5fd81-b89a-4726-aade-06df7a327109', 15,
 'Which group of people cannot participate in the tours?',
 '["A. Wheelchair users", "B. Children under twelve", "C. People with respiratory conditions"]', 'A');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('1cc5db0d-34a2-4e8a-8acb-45d8d299688f', '757fcfc7-da54-4fd7-809a-9dee7c45f636', 2,
 'multiple-choice', 'Look at the map of the station concourse. Match the locations (16-20) to the correct letter (A-G).', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('2aff2e7c-e1a8-4811-9252-ee1d4033d08d', '1cc5db0d-34a2-4e8a-8acb-45d8d299688f', 16,
 'Edwardian Ticket Hall', '["A", "B", "C", "D", "E", "F", "G"]', 'A'),
('ade6d36b-d57b-4dac-ad2b-52f8edc901cf', '1cc5db0d-34a2-4e8a-8acb-45d8d299688f', 17,
 'Ventilation Shaft', '["A", "B", "C", "D", "E", "F", "G"]', 'C'),
('bab34f92-9a18-4fcd-960f-30e1357788ff', '1cc5db0d-34a2-4e8a-8acb-45d8d299688f', 18,
 'Signal Box', '["A", "B", "C", "D", "E", "F", "G"]', 'D'),
('a93a400d-b499-40ec-a1ea-cda9225b2551', '1cc5db0d-34a2-4e8a-8acb-45d8d299688f', 19,
 'Platform 2', '["A", "B", "C", "D", "E", "F", "G"]', 'F'),
('00fad28b-9e6b-44ec-a348-9ac370d26a2c', '1cc5db0d-34a2-4e8a-8acb-45d8d299688f', 20,
 'Generator Room', '["A", "B", "C", "D", "E", "F", "G"]', 'G');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 3: Academic Dialogue (Epidemiological Modeling) ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('26966450-6044-4201-b540-24afaddc2761', '000943d4-b549-4bf2-a044-542e900e2904', 3,
 'Epidemiological Modeling Assignment',
 'Tutor: Come in, Elias, Fatima. Have a seat. Let’s dive straight into your draft analysis of the epidemiological models used during the recent viral outbreak.
Elias: Thanks, Dr. Aris. We’ve synthesized the raw data from the three primary predictive models, but we’re hitting a wall regarding the discrepancies in their R-naught estimations—the basic reproduction number.
Fatima: Exactly. The variance is statistically problematic. I argued in the draft that the primary flaw was the reliance on outdated mobility data. The Oxford model extrapolated movement patterns based on pre-pandemic census data, completely ignoring real-time mobile GPS metrics. 
Elias: While I agree the mobility data was flawed, I actually think the catastrophic miscalculation was their underestimation of the asymptomatic transmission rate. The Stanford team assumed only 15% of cases were asymptomatic, whereas subsequent serological testing revealed it was closer to 40%.
Tutor: You are both identifying valid methodological flaws. However, for a high-level academic critique, you shouldn''t just point out errors; you must analyze the statistical significance of those errors. Did the Stanford underestimation fundamentally alter the trajectory of their policy recommendations?
Fatima: Yes, profoundly. By underestimating asymptomatic spread, their model recommended localized, targeted lockdowns rather than a broad, pre-emptive quarantine, which proved disastrous in dense urban centres. 
Tutor: Precisely. Now, let’s turn to the literature review section. You’ve cited a vast array of researchers, but you need to critically match these theorists to their specific modeling innovations or critiques. Let’s run through a few. What was Chen’s primary contribution?
Elias: Chen revolutionized spatial mapping. Instead of looking at cities as uniform grids, he introduced "networked nodes," recognizing that transit hubs accelerate transmission exponentially compared to residential zones.
Tutor: Good. And what about the critique published by Dr. Al-Fayed?
Fatima: Al-Fayed was a vocal sceptic of deterministic models. She argued that most models failed to account for "behavioral fatigue"—the psychological reality that public compliance with restrictions degrades significantly over time, rendering long-term predictive models practically useless.
Tutor: A very crucial socio-behavioral integration. Now, let’s look at Gupta’s team.
Elias: Gupta’s research was highly controversial. Her team utilized a "susceptibility variance" approach. They hypothesized that a significant portion of the population already possessed cross-reactive T-cell immunity from prior, unrelated coronaviruses, thereby artificially lowering the true fatality rate.
Tutor: Yes, which challenged the consensus heavily at the time. Next, evaluate the work by the Scandinavian researcher, Lindholm.
Fatima: Lindholm focused entirely on healthcare capacity thresholds. Rather than predicting total infections, his model dynamically calculated the exact breaking point of ICU infrastructure, dictating when triage protocols would legally need to be enacted. 
Tutor: Excellent. Finally, what did you make of the overarching meta-analysis conducted by O’Connor?
Elias: O’Connor highlighted systemic publication bias. He demonstrated that predictive models predicting apocalyptic scenarios were published rapidly and heavily cited, while conservative, more accurate models were routinely ignored by major journals.
Tutor: Perfect. Your grasp of the theoretical landscape is incredibly nuanced. To finalize this draft, I want you to condense the historical context and expand the section on Al-Fayed’s behavioral variables. Incorporating psychology into epidemiology is where the field is currently heading.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('08aaed10-ad28-4db7-adf1-eb147be97379', '26966450-6044-4201-b540-24afaddc2761', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('1acf7024-a0e8-41c4-84c6-12bf256c0db5', '08aaed10-ad28-4db7-adf1-eb147be97379', 21,
 'What does Fatima believe was the primary flaw in the Oxford model?',
 '["A. It underestimated the virus''s mutation rate", "B. It relied on obsolete population movement data", "C. It ignored the impact of international travel"]', 'B'),
('54fff8df-6b7a-449d-ba16-7d1c5716fbae', '08aaed10-ad28-4db7-adf1-eb147be97379', 22,
 'According to Elias, what critical error did the Stanford team make?',
 '["A. They miscalculated the asymptomatic transmission rate", "B. They failed to utilize real-time GPS metrics", "C. They recommended broad quarantine measures too early"]', 'A'),
('587fcefb-c5f6-4d6d-865a-49b5c12c71e4', '08aaed10-ad28-4db7-adf1-eb147be97379', 23,
 'What is the tutor’s advice regarding their critique of the models?',
 '["A. They should focus on providing alternative solutions", "B. They must analyze the statistical impact of the errors", "C. They need to simplify their mathematical explanations"]', 'B'),
('88586532-f6fc-40fe-ad59-b311f3686b7f', '08aaed10-ad28-4db7-adf1-eb147be97379', 24,
 'Because of their miscalculation, what policy did the Stanford model mistakenly recommend?',
 '["A. Nationwide border closures", "B. Immediate mass vaccination", "C. Localized, targeted lockdowns"]', 'C'),
('9925dc7b-662b-4996-b156-c0691e8e1a2a', '08aaed10-ad28-4db7-adf1-eb147be97379', 25,
 'What does the tutor request they do to finalize their draft?',
 '["A. Expand the section on behavioral variables", "B. Remove the historical context entirely", "C. Include more mathematical formulas"]', 'A');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('3410b84e-d44c-4def-b8e7-0c3a7cb5995c', '26966450-6044-4201-b540-24afaddc2761', 2,
 'multiple-choice', 'Match the following theories/contributions to the correct researcher (A-F).', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('eef6cbe8-eb93-42ba-aa29-9717605d16ee', '3410b84e-d44c-4def-b8e7-0c3a7cb5995c', 26,
 'Identified publication bias favouring apocalyptic predictive models.',
 '["A. Chen", "B. Al-Fayed", "C. Gupta", "D. Lindholm", "E. O’Connor", "F. Stanford Team"]', 'E'),
('b797645a-6101-4889-8218-c6d7c2a5874a', '3410b84e-d44c-4def-b8e7-0c3a7cb5995c', 27,
 'Modeled the specific breaking points of ICU infrastructure.',
 '["A. Chen", "B. Al-Fayed", "C. Gupta", "D. Lindholm", "E. O’Connor", "F. Stanford Team"]', 'D'),
('3e0ba6f2-06be-4c41-a7af-50656a4c62ff', '3410b84e-d44c-4def-b8e7-0c3a7cb5995c', 28,
 'Argued that public compliance degrades due to psychological fatigue.',
 '["A. Chen", "B. Al-Fayed", "C. Gupta", "D. Lindholm", "E. O’Connor", "F. Stanford Team"]', 'B'),
('b5eb20d6-3d05-4426-8f3b-a3e4c4b93713', '3410b84e-d44c-4def-b8e7-0c3a7cb5995c', 29,
 'Hypothesized that cross-reactive immunity lowered the true fatality rate.',
 '["A. Chen", "B. Al-Fayed", "C. Gupta", "D. Lindholm", "E. O’Connor", "F. Stanford Team"]', 'C'),
('f46ed466-adfe-4ec3-a563-67ff4f2bd2b1', '3410b84e-d44c-4def-b8e7-0c3a7cb5995c', 30,
 'Utilized networked nodes to map transit hubs as transmission accelerators.',
 '["A. Chen", "B. Al-Fayed", "C. Gupta", "D. Lindholm", "E. O’Connor", "F. Stanford Team"]', 'A');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 4: Academic Monologue (Cognitive Epigenetics)   ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('917f6e7f-017f-4da2-b536-f910883080b6', '000943d4-b549-4bf2-a044-542e900e2904', 4,
 'Lecture: Transgenerational Epigenetic Inheritance',
 'Professor: Good morning. Today we transition from classical genetics to the rapidly evolving, and somewhat controversial, field of cognitive epigenetics. For decades, the central dogma of molecular biology dictated that our genetic destiny was fixed—that the DNA sequence we were born with was the immutable blueprint of our physiological and psychological traits.

Epigenetics shatters this assumption. While it is true that your base DNA sequence does not change, epigenetics studies how environmental factors influence gene expression. The primary mechanism for this is called DNA methylation. Imagine methylation as a biological switch; it involves the attachment of chemical tags—methyl groups—to specific genes, which can effectively turn a gene "off" or "on" without altering the underlying genetic code. 

What triggers these epigenetic changes? The most profoundly studied trigger is extreme environmental stress. In a seminal laboratory study, researchers observed the maternal behaviour of rats. They found that rat pups raised by mothers who exhibited high levels of nurturing—specifically, intense grooming and licking—grew up to be remarkably calm adults. Conversely, pups deprived of this grooming exhibited heightened anxiety. 

When researchers examined the brains of the anxious rats, they discovered heavy methylation on the gene responsible for regulating glucocorticoid receptors. Essentially, the lack of maternal care had epigenetically silenced the gene that allows the brain to process cortisol, the primary stress hormone. Because they could not regulate cortisol efficiently, these rats lived in a state of chronic physiological panic. 

Crucially, this neurobiological alteration is not necessarily permanent. In subsequent trials, when these anxious adult rats were injected with drugs designed to remove the methyl tags, their gene expression normalized, and their anxiety levels plummeted. This proves that, unlike a genetic mutation, epigenetic changes are inherently reversible. 

The implications for human biology are staggering, particularly concerning transgenerational trauma. The most robust human evidence stems from the Dutch Hunger Winter of 1944. During this severe famine, pregnant women were subjected to extreme caloric deprivation. Epidemiologists later discovered that the children born to these women suffered from disproportionately high rates of obesity, schizophrenia, and diabetes. 

By analyzing the genome of this cohort, scientists identified a specific epigenetic alteration: a decreased methylation on the IGF2 gene, which heavily regulates human metabolism. The starving mothers’ bodies had epigenetically reprogrammed their unborn children to hoard every possible calorie in preparation for a world devoid of food. 

However, the paradigm-shifting discovery occurred when researchers examined the grandchildren of the famine survivors. Even though the second generation was raised in an era of post-war abundance, they passed this thrifty epigenetic phenotype down to the third generation. The biological memory of starvation was inherited by descendants who had never experienced hunger themselves.

This challenges traditional Darwinian evolution, edging closer to Lamarckism—the idea that acquired traits can be inherited. While the scientific community remains fiercely debated over how exactly these fragile methyl tags survive the embryonic slate-wiping process during fertilization, the therapeutic potential is undeniable. If trauma can be chemically encoded into our epigenome, the race is now on to develop targeted pharmacological interventions capable of erasing these scars at the molecular level, offering hope for breaking the cycle of inherited psychiatric disorders.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('d0540778-726b-435e-a3e6-32831261c524', '917f6e7f-017f-4da2-b536-f910883080b6', 1,
 'sentence-completion', 'Complete the notes below. Write NO MORE THAN ONE WORD for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('6e49e23e-afe9-4daf-8406-542fbf036cae', 'd0540778-726b-435e-a3e6-32831261c524', 31,
 'Epigenetics alters gene expression without changing the base DNA ________.', 'sequence', '["sequence","Sequence"]'),
('c187d90c-3619-4ad6-968f-e24549358a40', 'd0540778-726b-435e-a3e6-32831261c524', 32,
 'The primary mechanism that switches genes on or off is called DNA ________.', 'methylation', '["methylation","Methylation"]'),
('3d0e085f-085e-446e-bce8-ff09038cd776', 'd0540778-726b-435e-a3e6-32831261c524', 33,
 'The most thoroughly studied trigger for epigenetic change is extreme environmental ________.', 'stress', '["stress","Stress"]'),
('2538fda7-a3dd-4c21-b911-1cf6ec6124f4', 'd0540778-726b-435e-a3e6-32831261c524', 34,
 'In animal models, rats deprived of maternal ________ developed heightened anxiety.', 'grooming', '["grooming","Grooming"]'),
('5479a0c3-d8e3-4d6b-9e7d-e84607012783', 'd0540778-726b-435e-a3e6-32831261c524', 35,
 'This deprivation silenced the gene responsible for processing ________.', 'cortisol', '["cortisol","Cortisol"]'),
('302a6b8d-9f0a-4f9c-bc37-6c07340d96bc', 'd0540778-726b-435e-a3e6-32831261c524', 36,
 'Unlike a permanent genetic mutation, epigenetic changes are inherently ________.', 'reversible', '["reversible","Reversible"]'),
('5abe81bd-a626-4dc9-8048-f1cf1b43d1c2', 'd0540778-726b-435e-a3e6-32831261c524', 37,
 'Human studies focused on pregnant women subjected to extreme ________ in 1944.', 'famine', '["famine","Famine","starvation"]'),
('abc91487-b7f1-4998-bfef-7dd8f3e13187', 'd0540778-726b-435e-a3e6-32831261c524', 38,
 'Scientists found decreased methylation on the IGF2 gene, which regulates human ________.', 'metabolism', '["metabolism","Metabolism"]'),
('c61890ac-1b1d-424d-bd7c-f52981f1b857', 'd0540778-726b-435e-a3e6-32831261c524', 39,
 'The biological memory of trauma was passed down to the survivors'' ________.', 'descendants', '["descendants","Descendants","grandchildren"]'),
('b847250d-2851-4a97-8051-aae63e9d6c8d', 'd0540778-726b-435e-a3e6-32831261c524', 40,
 'Researchers hope to develop ________ pharmacological interventions to erase molecular scars.', 'targeted', '["targeted","Targeted"]');
