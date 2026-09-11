-- ============================================================
-- IELTS Practice Platform – Seed Data
-- Target: Listening Module (Band 9 Difficulty)
-- Description: Expert-level listening test featuring intricate 
-- paraphrasing, dense academic/technical language in everyday contexts, 
-- rapid native speech patterns, and complex distractors.
-- ============================================================

-- ████████████████████████████████████████████████████████████
-- ██  LISTENING TEST RECORD                                 ██
-- ████████████████████████████████████████████████████████████

INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status) VALUES
('ffea467a-d3eb-4ece-9fe2-479d63fd005c', 'b787c0fc-39be-4e3e-87d7-519eb0b01170',
 'IELTS Expert Listening: High-Altitude Logistics & Urban Agriculture (Band 9)', '9', '40 mins', 'published');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 1: Transactional Dialogue (Expedition Booking)  ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('3c54888d-48c2-473d-b7cd-147070d55009', 'ffea467a-d3eb-4ece-9fe2-479d63fd005c', 1,
 'High-Altitude Mountaineering Expedition Booking',
 'Agent: Good morning, Apex Ascents Expeditions, Sylvia speaking. How may I direct your inquiry this morning?
Client: Good morning, Sylvia. My name is Dr. Aris Thorne. I am looking to finalize a booking for a bespoke acclimatization and summit package in the Karakoram range. My previous outfitter went into administration unexpectedly, leaving me in a rather precarious logistical position.
Agent: I’m so sorry to hear about that disruption, Dr. Thorne. We can certainly step in to assist. Just to ensure I populate the correct client profile, could you spell your surname for the record?
Client: Yes, it is Thorne. T-H-O-R-N-E.
Agent: Thank you. And for which specific peak are you requiring logistical support?
Client: We are targeting Broad Peak. We initially considered K2, but given the shifting meteorological anomalies this season, Broad Peak offers a marginally more stable ascent window.
Agent: Broad Peak, understood. A formidable objective nonetheless. Regarding your timeline, when is your expedition window scheduled to commence?
Client: Our advanced base camp must be fully operational by the 14th of July. Therefore, we require the advance porter team to mobilize from Skardu no later than the 28th of June.
Agent: Let me just input those parameters. Mobilization by the 28th of June. Yes, we have elite porter contingents available. Now, concerning your base camp infrastructure, will you require our standard geodesic dome tents, or do you need something more heavily reinforced?
Client: The standard domes will not suffice. We are conducting meteorological research, so we require the reinforced dual-layer canvas structures. They must be capable of withstanding sustained katabatic winds.
Agent: Dual-layer canvas structures. Noted. These are significantly heavier, which necessitates a larger porter team. Now, regarding your oxygen requirements. How many cylinders are you anticipating per climber above camp three?
Client: We are running a semi-alpine style ascent, so we want to minimize reliance on supplemental oxygen. However, for emergency contingencies, we need an allocation of five titanium cylinders per climber. We specifically need the titanium ones, not the older steel variants, to keep the weight absolutely minimal.
Agent: Five titanium cylinders per climber. I’ll ensure the procurement team sources those exact models. Moving on to communications, our premium packages include satellite uplinks. Will you require a dedicated broadband terminal, or just standard VHF radio handsets?
Client: A dedicated broadband terminal is mandatory. We are transmitting large packets of atmospheric data back to our university daily. VHF radios are fine for inter-camp comms, but the broadband terminal is critical for the scientific payload.
Agent: I will add the broadband terminal to the manifest. Now, regarding medical provisions. We supply a comprehensive trauma kit, but do you require a dedicated high-altitude physician at base camp, or are your personnel already qualified?
Client: My co-leader is a certified wilderness paramedic, so we do not need a dedicated physician. However, we do require a portable hyperbaric chamber. If someone develops acute mountain sickness, we need the capability to simulate lower altitudes immediately.
Agent: A portable hyperbaric chamber. A very prudent addition. I will reserve one from our medical cache. Let us discuss the dietary logistics. We typically provide dehydrated rations for the high camps. Do you have any specific dietary restrictions within your team?
Client: Yes, one of our lead climbers has a severe allergy to legumes. You must ensure that absolutely no peanuts or lentils are present in any of the dehydrated meal pouches. Cross-contamination would be catastrophic at that altitude.
Agent: I have highlighted the legume allergy in red on your profile. Our catering team is meticulous with cross-contamination protocols. Before I finalize the preliminary itinerary, we need to address the mandatory insurance requirements. Have you already secured comprehensive evacuation coverage?
Client: I have a standard policy through the Alpine Club, but I am uncertain if it covers helicopter extraction above 6,000 meters.
Agent: I strongly advise upgrading that. The standard Alpine Club policy typically caps helicopter rescues at 5,500 meters. For Broad Peak, you absolutely require the Apex Premier coverage tier, which guarantees extraction up to 7,000 meters, weather permitting.
Client: Ah, I wasn''t aware of that altitude ceiling. Yes, please append the Apex Premier coverage to our package. Better to have the redundancy than face a catastrophic logistical failure.
Agent: Exactly. Added. Now, concerning your transit from Skardu to the trailhead at Askole. We can arrange a standard convoy of 4x4 vehicles, or, if you are pressed for time and carrying sensitive calibration equipment, we can charter a military-grade transport truck with specialized suspension.
Client: The road to Askole is notoriously treacherous. Given the fragility of our atmospheric sensors, we cannot risk severe vibrations. We will opt for the military-grade transport truck, regardless of the additional cost.
Agent: A wise decision. The standard 4x4s tend to struggle with the river crossings early in the season anyway. Lastly, I need to know the total estimated weight of your scientific payload so we can calculate the exact number of yaks required for the trek up the Baltoro Glacier.
Client: The instrumentation, batteries, and solar arrays total approximately 240 kilograms. We have managed to shave off about 30 kilograms by switching to lighter lithium power banks, but 240 is our absolute baseline.
Agent: 240 kilograms of scientific payload. That will require an additional six yaks, solely dedicated to your research equipment. I will update the logistical manifest immediately. 
Client: Excellent. Thank you for your thoroughness, Sylvia. I shall await your preliminary invoice.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('f4e94d5f-3761-4cae-9fd9-94a76a116b5c', '3c54888d-48c2-473d-b7cd-147070d55009', 1,
 'sentence-completion', 'Complete the booking form below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('4aacdf56-f1f1-4b3a-a6cf-1b080564ee5e', 'f4e94d5f-3761-4cae-9fd9-94a76a116b5c', 1,
 'Client Surname: ________', 'Thorne', '["Thorne","thorne","THORNE"]'),
('89c0ebb8-f0af-4851-939c-0c85a1251f9c', 'f4e94d5f-3761-4cae-9fd9-94a76a116b5c', 2,
 'Target mountain peak: ________', 'Broad Peak', '["Broad Peak","broad peak","BROAD PEAK"]'),
('80342e9c-c261-4607-a057-8726277a8ca9', 'f4e94d5f-3761-4cae-9fd9-94a76a116b5c', 3,
 'Porter mobilization deadline: ________', '28th June', '["28th June","28 June","June 28","June 28th"]'),
('24629c82-c696-467e-9455-372fe47baf52', 'f4e94d5f-3761-4cae-9fd9-94a76a116b5c', 4,
 'Base camp tent requirement: ________ canvas structures', 'dual-layer', '["dual-layer","dual layer","Dual-layer"]'),
('8eef5116-e976-4cc5-9403-16802a7a2e31', 'f4e94d5f-3761-4cae-9fd9-94a76a116b5c', 5,
 'Oxygen cylinders requested per climber: 5 ________ cylinders', 'titanium', '["titanium","Titanium"]'),
('95576fab-e78b-4e0c-a2c2-7902b747df64', 'f4e94d5f-3761-4cae-9fd9-94a76a116b5c', 6,
 'Mandatory communications equipment: A ________', 'broadband terminal', '["broadband terminal","Broadband terminal","Broadband Terminal"]'),
('9f8f7dd2-e078-4436-b801-28f6ad3fa4c8', 'f4e94d5f-3761-4cae-9fd9-94a76a116b5c', 7,
 'Medical equipment needed: A portable ________', 'hyperbaric chamber', '["hyperbaric chamber","Hyperbaric chamber","Hyperbaric Chamber"]'),
('6b7b3823-a547-45f4-a327-9cfd6d800a36', 'f4e94d5f-3761-4cae-9fd9-94a76a116b5c', 8,
 'Strict dietary restriction: No ________', 'legumes', '["legumes","Legumes"]'),
('9b4f00fd-3bb1-4e97-a6e1-d0d4a2e9066b', 'f4e94d5f-3761-4cae-9fd9-94a76a116b5c', 9,
 'Insurance upgrade required: ________ coverage', 'Apex Premier', '["Apex Premier","apex premier","Apex premier"]'),
('aab516a4-d2f8-42a2-8ebb-facc1aa2adac', 'f4e94d5f-3761-4cae-9fd9-94a76a116b5c', 10,
 'Weight of scientific payload: ________ kilograms', '240', '["240"]');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 2: Monologue (Urban Agriculture Facility Tour)  ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('46330733-dcde-494e-a59d-3878a421f992', 'ffea467a-d3eb-4ece-9fe2-479d63fd005c', 2,
 'Aetheris Urban Agriculture Cooperative Induction',
 'Director: Good morning, and welcome to the Aetheris Urban Agriculture Cooperative. I am Elias, the Chief Agronomist, and I’ll be guiding your induction today. Before you deploy into the active cultivation zones, it is imperative that we cover the operational philosophy and the strict bio-security protocols of this facility.

Aetheris was conceptualized a decade ago, not merely as a commercial venture, but as a blueprint for crisis-resilient urban sustenance. Traditional agriculture is increasingly vulnerable to erratic climate patterns and soil degradation. Initially, our founders experimented with rooftop soil-based models, but the structural load limits of urban buildings proved an insurmountable bottleneck. The architecture simply couldn''t safely bear the weight of saturated soil on a commercial scale. We quickly transitioned to the high-density aeroponic systems you see today, which use 95% less water than conventional farming and completely eliminate the need for arable land.

Financing such a radical paradigm shift was challenging. Venture capital firms were hesitant due to the massive initial capital expenditure required for the automated systems. Fortunately, we bypassed traditional funding routes and secured a massive municipal innovation grant, which allowed us to construct this multi-tiered facility without compromising our environmental ethos.

Now, regarding bio-security. You are about to enter a Class 2 agricultural cleanroom. The greatest threat to our crops isn''t pests in the traditional sense, but microscopic fungal spores brought in from the outside world. Therefore, before entering the airlock, everyone must don a full-body Tyvek clean-suit. We used to require disposable plastic boot covers, but they proved ineffective against heavy contamination. Consequently, you will now step through a specialized ultraviolet sterilization bath for your footwear before entering. 

Let me elaborate a bit more on our lighting technology before we move on. In the early days of vertical farming, the sheer energy consumption of artificial lighting negated the environmental benefits. However, Aetheris utilizes proprietary dynamic-spectrum LEDs. These lights don''t just blast plants with continuous energy; they actually simulate the natural progression of dawn, midday sun, and dusk, tailoring the light spectrum to the specific growth phase of each plant species. Please note, while the LED spectrums inside are highly optimized for photosynthesis, they can cause mild disorientation and eye strain. Consequently, wearing the provided polarized safety goggles is absolutely mandatory at all times on the cultivation floor.

Furthermore, the heat generated by these LED arrays is captured by our advanced HVAC system and repurposed to regulate the temperature of the municipal swimming pool located in the community centre next door. It is a fully closed-loop thermal ecosystem.

Let us review the facility layout. Please refer to the schematic on your digital tablets. We are currently gathered in the Briefing Atrium, located at the southern tip of the map. 

As we move north through the primary airlock, you will find yourself in the Central Corridor. Immediately to your right, you’ll see a large glass-walled enclosure. This is the Nutrient Mixing Matrix. It’s the beating heart of the facility where our automated systems blend precise ratios of nitrogen, phosphorus, and trace minerals into the aeroponic mist. 

Continuing down the Central Corridor, if you take the first left, you will enter a distinctly cooler, darker space. This is the Mycology Cell, dedicated to cultivating high-protein edible fungi. The temperature here is kept deliberately low to simulate subterranean conditions, so do not be alarmed by the sudden chill.

Moving back to the Central Corridor and proceeding further north, you will encounter a large intersection. If you take the path branching off to the upper right, it leads to the Pollination Sector. Unlike the rest of the facility which is sterile, this area houses our captive bumblebee colonies. They are essential for pollinating our fruiting crops like tomatoes and peppers. 

Returning to the intersection, if you continue straight ahead, right to the very end of the main corridor, you will arrive at the Harvesting Hub. This is where the mature crops are mechanically gathered, inspected for quality control, and immediately vacuum-sealed to preserve maximum nutritional density. 

Finally, from that same intersection, if you take the path branching off to the upper left, you’ll find a tightly secured room. This is the Germination Vault. It is strictly off-limits to visitors today, as it houses our proprietary heritage seed banks and the delicate seedling propagation trays, which are highly sensitive to even minor temperature fluctuations caused by human body heat.

Okay, let''s proceed to the Tyvek donning station. Please ensure your personal belongings are secured in the lockers provided.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('75c1dcf0-6708-43ec-ad68-8ddacb534c13', '46330733-dcde-494e-a59d-3878a421f992', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('903e37d4-6771-4e8e-b033-d925b1566cdf', '75c1dcf0-6708-43ec-ad68-8ddacb534c13', 11,
 'Why did the founders abandon rooftop soil-based farming models?',
 '["A. Erratic climate patterns frequently destroyed the crops.", "B. The buildings could not safely support the heavy weight.", "C. Municipal zoning regulations prohibited the practice."]', 'B'),
('5721fc5a-5bb3-40b8-86bc-13827cc3a1ad', '75c1dcf0-6708-43ec-ad68-8ddacb534c13', 12,
 'How was the construction of the Aetheris facility primarily funded?',
 '["A. Through specialized venture capital firms.", "B. By partnering with legacy agricultural companies.", "C. Via a substantial municipal innovation grant."]', 'C'),
('011dbe21-e1c1-4003-9f10-cb83a93f1931', '75c1dcf0-6708-43ec-ad68-8ddacb534c13', 13,
 'What new bio-security measure has been introduced to replace the old footwear protocol?',
 '["A. Disposable Tyvek boot covers.", "B. An ultraviolet sterilization bath.", "C. A pressurized chemical decontamination spray."]', 'B'),
('d856c678-2421-4aeb-afe0-488e02b0e98d', '75c1dcf0-6708-43ec-ad68-8ddacb534c13', 14,
 'What mandatory safety equipment must all visitors wear on the cultivation floor?',
 '["A. Polarized safety goggles.", "B. Heavy-duty protective gloves.", "C. Advanced respiratory masks."]', 'A'),
('0ce79402-bfc8-436a-b0bb-b328b1aaf342', '75c1dcf0-6708-43ec-ad68-8ddacb534c13', 15,
 'What happens to the excess heat produced by the facility''s LED arrays?',
 '["A. It is vented directly into the outside atmosphere.", "B. It is utilized to warm a nearby public facility.", "C. It is converted to power the harvesting machinery."]', 'B');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('5659b055-b933-4a9d-971d-73c6022968e5', '46330733-dcde-494e-a59d-3878a421f992', 2,
 'matching', 'Match each facility zone to its correct location on the cultivation floor. Choose the correct letter, A-G for questions (16-20).', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES

('0875b7a5-5d82-4bbf-bed0-899bddd166b2', '5659b055-b933-4a9d-971d-73c6022968e5', 16,
 'Mycology Cell', 
 '["A. Immediately to the right of the Central Corridor", "B. First left off the Central Corridor", "C. Upper right path from the northern intersection", "D. Straight ahead at the very end of the main corridor", "E. Upper left path from the northern intersection", "F. Next to the primary airlock in the Briefing Atrium", "G. Outside the facility near the community centre"]', 
 'B'),
('faca4b9d-0e58-422b-bb2e-4da543b9268c', '5659b055-b933-4a9d-971d-73c6022968e5', 17,
 'Nutrient Mixing Matrix', 
 '["A. Immediately to the right of the Central Corridor", "B. First left off the Central Corridor", "C. Upper right path from the northern intersection", "D. Straight ahead at the very end of the main corridor", "E. Upper left path from the northern intersection", "F. Next to the primary airlock in the Briefing Atrium", "G. Outside the facility near the community centre"]', 
 'A'),
('2a5b1938-3a04-4c44-aafd-98c212746883', '5659b055-b933-4a9d-971d-73c6022968e5', 18,
 'Harvesting Hub', 
 '["A. Immediately to the right of the Central Corridor", "B. First left off the Central Corridor", "C. Upper right path from the northern intersection", "D. Straight ahead at the very end of the main corridor", "E. Upper left path from the northern intersection", "F. Next to the primary airlock in the Briefing Atrium", "G. Outside the facility near the community centre"]', 
 'D'),
('c09198e1-be3f-453a-ac9f-539d5abcc352', '5659b055-b933-4a9d-971d-73c6022968e5', 19,
 'Pollination Sector', 
 '["A. Immediately to the right of the Central Corridor", "B. First left off the Central Corridor", "C. Upper right path from the northern intersection", "D. Straight ahead at the very end of the main corridor", "E. Upper left path from the northern intersection", "F. Next to the primary airlock in the Briefing Atrium", "G. Outside the facility near the community centre"]', 
 'C'),
('11cef828-99ee-4e7c-8581-3df9964bf137', '5659b055-b933-4a9d-971d-73c6022968e5', 20,
 'Germination Vault', 
 '["A. Immediately to the right of the Central Corridor", "B. First left off the Central Corridor", "C. Upper right path from the northern intersection", "D. Straight ahead at the very end of the main corridor", "E. Upper left path from the northern intersection", "F. Next to the primary airlock in the Briefing Atrium", "G. Outside the facility near the community centre"]', 
 'E');

-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 3: Academic Dialogue (Marine Geoengineering)    ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('9fa69a68-f392-4c91-9be3-eabc4ec48934', 'ffea467a-d3eb-4ece-9fe2-479d63fd005c', 3,
 'Marine Geoengineering Proposal Review',
 'Prof. Vance: Come in, Chloe, Sam. Have a seat. Let’s get straight into your draft proposal on Marine Geoengineering, specifically your focus on Ocean Alkalinity Enhancement, or OAE.
Chloe: Thanks, Professor Vance. We felt it was a more viable and controllable carbon sequestration strategy than the solar radiation management topics we debated in the seminar last week.
Prof. Vance: It certainly carries less immediate atmospheric risk. But why did you pivot away from ocean iron fertilization? Your initial abstract leaned heavily in that direction, and it’s arguably much cheaper.
Sam: Well, as we dug deeply into the biogeochemical literature, the cascading side effects of iron fertilization became impossible to ignore. While it does trigger massive phytoplankton growth as intended, the subsequent decomposition of those blooms severely depletes oceanic oxygen, ultimately creating sprawling hypoxic dead zones. OAE avoids that ecological trap entirely by simply accelerating the natural weathering process of silicate rocks.
Prof. Vance: A sound justification. However, your methodology section severely glosses over the logistical constraints of OAE. You suggest using crushed olivine rock because it’s highly reactive, but you fail to account for the energy deficit.
Chloe: Are you referring to the carbon footprint of the extraction process?
Prof. Vance: Exactly that. To sequester a single gigaton of CO2, you need to mine, transport, crush, and mill roughly three gigatons of olivine. The fossil fuels burned during the mechanical crushing process alone could negate up to thirty percent of the carbon you intend to sequester. You absolutely must address this paradox in your life-cycle assessment.
Sam: That’s a fair criticism. We could expand the methodology to propose coupling the coastal milling facilities directly with offshore wind arrays to mitigate those processing emissions.
Prof. Vance: Please do. Now, looking at your literature review... it is comprehensive, but it leans disproportionately on computational modeling. You have almost entirely neglected the empirical data from the recent mesocosm experiments conducted in the North Sea. The Norwegian team actually isolated a cubic decameter of seawater and tracked the calcifying organisms for eight consecutive months.
Chloe: We rigorously reviewed that study, but we ultimately chose to exclude it because their baseline pH metrics were heavily skewed by anomalous coastal upwelling during the trial period. We felt the computational models from the Max Planck Institute provided a much more stable baseline for a global projection.
Prof. Vance: That is a highly defensible methodological choice, Chloe, but you must explicitly state that rationale in the text of your paper. If you silently omit the Norwegian study, the peer reviewers will simply assume you missed it during your literature search. You need to control the academic narrative. State clearly why the empirical data was excluded due to those upwelling anomalies to preempt their criticism.
Sam: Understood. We’ll draft an exclusionary justification paragraph. I am actually much more concerned about the regulatory section of our proposal. As it stands, international maritime law, specifically the London Protocol and the UN Convention on the Law of the Sea, strictly prohibit the dumping of industrial waste into the ocean. We are struggling to define whether powdered olivine constitutes "waste" or "environmental remediation."
Prof. Vance: That legal ambiguity is the absolute crux of the geopolitical debate, Sam. The legislation was drafted in the 1970s and 1980s; it lacks any framework for climate intervention technologies. That geopolitical vacuum is currently a larger barrier to entry than any of the biochemical engineering challenges. Now, let’s refine your citations. You’ve compiled a vast array of researchers, but you need to critically attribute specific paradigm shifts to the correct authors. Let’s review a few key figures. What was Dr. Sato''s primary contribution to the field?
Chloe: Sato conducted the very first coastal dispersal trials. Her team made the rather counter-intuitive discovery that immediately following the olivine dispersal, there is actually a temporary localized drop in pH—a sudden spike in acidity—before the dissolution stabilizes and the alkalinity finally rises.
Prof. Vance: Precisely, she identified the "acidification lag." And what about Henderson’s critique?
Sam: Henderson moved the focus away from the pelagic surface waters and modeled the long-term ecological impact on benthic organisms. He warned that un-dissolved silicate particles sinking to the deep sea floor could physically smother fragile, slow-growing coral ecosystems.
Prof. Vance: Correct. It’s vital to mention benthic impacts. Next, evaluate the foundational work by Sterling.
Chloe: Sterling’s paper was the one that first quantified the logistical nightmare we discussed earlier. He rigorously audited the carbon emissions associated with the rock milling process, proving mathematically that without full renewable energy integration, OAE is economically and environmentally bankrupt.
Prof. Vance: A harsh but entirely accurate assessment. Now, let’s look at O’Reilly’s logistical proposal.
Sam: O’Reilly offered a highly pragmatic solution to the physical distribution problem. Rather than building a dedicated, expensive fleet of dispersal vessels, he suggested retrofitting existing commercial shipping fleets to slowly release the alkaline slurry along established trans-oceanic trade routes.
Prof. Vance: Yes, the "commercial integration" distribution model. Highly influential work. Finally, what did you make of the socio-economic analysis conducted by Dubois?
Chloe: Dubois stepped completely away from the biochemistry and analyzed the human element. She argued that the artificial alteration of local seawater chemistry could unpredictably shift pelagic fish migration patterns, which would ultimately devastate the economies of coastal fishing communities.
Prof. Vance: Excellent. Your theoretical mapping is robust. To achieve a top grade, synthesize these perspectives rather than just listing them chronologically. I want to see a revised draft on my desk by Thursday morning.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('a0fd52c5-b39d-4fed-90d6-7a0bbc4b730e', '9fa69a68-f392-4c91-9be3-eabc4ec48934', 1,
 'multiple-choice', 'Choose the correct letter, A, B or C.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('94568120-2d86-4488-b251-cd8d19426ed0', 'a0fd52c5-b39d-4fed-90d6-7a0bbc4b730e', 21,
 'Why did the students decide against proposing ocean iron fertilization?',
 '["A. It is significantly more expensive than other methods.", "B. It creates hypoxic dead zones during decomposition.", "C. It fails to trigger sufficient phytoplankton growth."]', 'B'),
('bbbae8a2-f78b-4886-9d18-09e3c7c184ab', 'a0fd52c5-b39d-4fed-90d6-7a0bbc4b730e', 22,
 'What criticism does Professor Vance have regarding their olivine methodology?',
 '["A. They ignored the massive carbon footprint of processing the rock.", "B. They selected a mineral that is not reactive enough in seawater.", "C. They underestimated the total volume of rock required."]', 'A'),
('39c59f6c-b606-4eac-8250-9724796f6a62', 'a0fd52c5-b39d-4fed-90d6-7a0bbc4b730e', 23,
 'Why did the students exclude the empirical data from the North Sea mesocosm study?',
 '["A. The study only tracked organisms for a short duration.", "B. The baseline data was compromised by anomalous coastal upwelling.", "C. The computational models proved the empirical data was fabricated."]', 'B'),
('787afd7c-9b1f-44d5-9d24-2ff68732372a', 'a0fd52c5-b39d-4fed-90d6-7a0bbc4b730e', 24,
 'What does the professor advise the students to do regarding the excluded study?',
 '["A. Incorporate the empirical data into their final models.", "B. Explicitly state their rationale for omitting it to preempt criticism.", "C. Contact the Norwegian team to request the raw data files."]', 'B'),
('4abb78a8-042d-47d9-808c-112ff08cff53', 'a0fd52c5-b39d-4fed-90d6-7a0bbc4b730e', 25,
 'According to Sam, what is the primary geopolitical hurdle for Ocean Alkalinity Enhancement?',
 '["A. Securing funding from skeptical international governments.", "B. Overcoming protests from coastal fishing communities.", "C. Existing maritime law lacks a framework for climate intervention."]', 'C');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('fede132e-7e43-482b-b12e-a1da5eb759ee', '9fa69a68-f392-4c91-9be3-eabc4ec48934', 2,
 'matching', 'Match the following research findings/critiques to the correct researcher (A-E).', true);

INSERT INTO listening_questions (id, group_id, question_order, text, options, answer) VALUES
('bbedf7d6-9bf0-4d7b-927f-1611505100b6', 'fede132e-7e43-482b-b12e-a1da5eb759ee', 26,
 'Quantified the severe carbon emissions associated with the rock milling process.',
 '["A. Sato", "B. Henderson", "C. Sterling", "D. O’Reilly", "E. Dubois"]', 'C'),
('7cf34402-8ca2-4176-8899-5c59152f0490', 'fede132e-7e43-482b-b12e-a1da5eb759ee', 27,
 'Modeled the potential smothering of deep-sea floor ecosystems by un-dissolved particles.',
 '["A. Sato", "B. Henderson", "C. Sterling", "D. O’Reilly", "E. Dubois"]', 'B'),
('f498ade7-acee-441f-8258-a603f03cb8d7', 'fede132e-7e43-482b-b12e-a1da5eb759ee', 28,
 'Argued that altering ocean chemistry could devastate coastal fishing economies.',
 '["A. Sato", "B. Henderson", "C. Sterling", "D. O’Reilly", "E. Dubois"]', 'E'),
('2da5054d-d69c-4f4d-a3d8-75cb8c8bd1b1', 'fede132e-7e43-482b-b12e-a1da5eb759ee', 29,
 'Discovered a temporary spike in localized acidity immediately following dispersal.',
 '["A. Sato", "B. Henderson", "C. Sterling", "D. O’Reilly", "E. Dubois"]', 'A'),
('8229959f-ace5-4ba2-840e-45dfe63f619a', 'fede132e-7e43-482b-b12e-a1da5eb759ee', 30,
 'Suggested utilizing established trans-oceanic commercial shipping for distribution.',
 '["A. Sato", "B. Henderson", "C. Sterling", "D. O’Reilly", "E. Dubois"]', 'D');


-- ══════════════════════════════════════════════════════════════
-- ██  SECTION 4: Academic Monologue (LiDAR Archaeology)       ██
-- ══════════════════════════════════════════════════════════════

INSERT INTO listening_sections (id, test_id, section_number, title, transcript) VALUES
('9fe14147-c798-4cd3-97f2-013f6b347aa8', 'ffea467a-d3eb-4ece-9fe2-479d63fd005c', 4,
 'Lecture: LiDAR and Amazonian Urbanism',
 'Professor: Welcome back to Advanced Spatial Archaeology. Today, we are entirely dismantling one of the most entrenched geographical myths of the 20th century: the conception of the pre-Columbian Amazon basin as a pristine, sparsely populated wilderness, inherently incapable of supporting complex, large-scale urban societies. For decades, the prevailing anthropological consensus—heavily influenced by the environmental determinism theories of Betty Meggers—argued that the highly acidic, nutrient-poor soils of the Amazon, scientifically known as oxisols, simply could not sustain the intensive agriculture necessary to feed dense urban populations. She famously categorized the rainforest as a "counterfeit paradise."

This long-standing paradigm has been completely overturned in the last fifteen years. And remarkably, this revolution was not led by archaeologists wielding traditional trowels, but by remote sensing technologies, specifically LiDAR, which stands for Light Detection and Ranging.

Before we delve into the recent discoveries, let’s briefly examine why traditional archaeological methodology failed so spectacularly in the Amazon. In regions like Mesoamerica or the Mediterranean, ancient civilizations constructed their monumental architecture using stone, which endures for millennia. In stark contrast, the indigenous populations of the Amazon basin built their vast urban centers using earth and biodegradable materials—specifically, massive earthen mounds, defensive palisades, and wooden civic structures. 

Once these thriving settlements were abruptly abandoned—following the devastating demographic collapse caused by introduced European diseases in the 16th century—the relentless tropical rainforest rapidly reclaimed the land. Pathogens like smallpox and influenza, to which the indigenous populations had absolutely no immunological resistance, traveled up the trade routes faster than the conquistadors themselves, decimating up to 90 percent of the population before direct contact was even made. Within a century, these vast cities were completely swallowed by an impenetrable canopy, rendering them practically invisible to both ground surveys and standard aerial photography.

Enter LiDAR. By mounting a highly specialized laser scanner onto an aircraft or drone, researchers can fire hundreds of thousands of laser pulses per second straight down at the forest canopy. While the vast majority of these light pulses bounce harmlessly off the dense upper leaves, a tiny fraction—often less than one percent—manages to slip through the microscopic gaps in the vegetation and strike the forest floor. By measuring the exact microsecond it takes for these few successful pulses to bounce back to the airborne sensor, supercomputers can digitally strip away the vegetation entirely, revealing a hyper-accurate, high-resolution 3D topographical map of the bare earth beneath. These scans are often accurate to within five centimeters.

The results have been nothing short of revolutionary. When the first large-scale LiDAR surveys were conducted over the Llanos de Moxos region in the Bolivian Amazon, the digital deforesting process revealed a staggering landscape of highly modified terrain. We didn''t just find isolated, scattered villages; we uncovered a vast, interconnected network of monumental urban centers dating back as far as 500 CE.

The sheer scale of the geometric earthworks is breathtaking. The LiDAR imagery revealed massive stepped platforms—some towering over 20 meters high and covering an area equivalent to 30 football fields—which almost certainly served as civic-ceremonial centers. But perhaps the most striking discovery wasn''t the monuments themselves, but the sophisticated civic infrastructure connecting them. The scans illuminated hundreds of kilometers of perfectly straight, raised causeways, explicitly designed to facilitate uninterrupted travel and trade during the region’s intense seasonal floods. 

Furthermore, to ingeniously address the issue of the nutrient-poor soil, these civilizations engaged in landscape-scale hydrological engineering. The topographical maps show intricate, sprawling grids of canals and raised agricultural fields. By elevating the planting surfaces above the floodline, they protected the delicate roots of their crops from waterlogging, while the surrounding canals captured nutrient-rich sediment and housed robust aquaculture systems, actively farming fish and turtles. This dual-system provided both complex carbohydrates and high-quality protein without destroying the forest canopy. 

They also chemically engineered the soil itself, creating "Terra Preta" or Amazonian dark earth—a highly fertile, anthropogenic soil deliberately enriched with charcoal, organic compost, and crushed ceramic shards. Astoundingly, this soil remains highly productive even today, centuries after it was created.

We are currently witnessing a massive paradigm shift in historical ecology. We must now radically reconceptualize the Amazon basin not as a pristine wilderness, but as a heavily managed, domesticated landscape—a highly "constructed nature" that once sustainably supported millions of people. This revelation not only rewrites human history but also offers crucial lessons for modern sustainability. These ancient urbanites managed to intensively exploit a highly fragile ecosystem for centuries without destroying its fundamental biodiversity—a feat our modern industrial agricultural systems are currently failing to replicate. Next week, we will analyze the machine learning algorithms used to automatically detect these geometric earthworks within the massive LiDAR datasets.');

INSERT INTO listening_question_groups (id, section_id, group_order, question_type, instructions, sequential_order) VALUES
('c0c91c47-29ff-4878-a43f-4228283ee5a8', '9fe14147-c798-4cd3-97f2-013f6b347aa8', 1,
 'sentence-completion', 'Complete the notes below. Write NO MORE THAN TWO WORDS for each answer.', true);

INSERT INTO listening_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('daf31261-99d8-47a9-a233-6eabb8eaa567', 'c0c91c47-29ff-4878-a43f-4228283ee5a8', 31,
 'Anthropologists previously believed the Amazon’s highly acidic ________ prevented large-scale urbanism.', 'soils', '["soils","Oxisols","oxisols","nutrient-poor soils"]'),
('c1bc67f1-d5d5-48e2-842a-e26a87d21e3c', 'c0c91c47-29ff-4878-a43f-4228283ee5a8', 32,
 'Unlike in Mesoamerica, ancient Amazonian cities were built using biodegradable materials rather than ________.', 'stone', '["stone","Stone"]'),
('43491378-15a0-4966-8607-32b1bd203845', 'c0c91c47-29ff-4878-a43f-4228283ee5a8', 33,
 'Introduced European ________ decimated the indigenous population before direct contact was even made.', 'diseases', '["diseases","Diseases","pathogens","Pathogens"]'),
('de300d5e-8f76-4226-a653-2a2bb1d06069', 'c0c91c47-29ff-4878-a43f-4228283ee5a8', 34,
 'LiDAR technology works by firing hundreds of thousands of laser ________ at the canopy.', 'pulses', '["pulses","Pulses","laser pulses"]'),
('e1aed1b6-084a-46b8-9bf0-3ac0865f8ada', 'c0c91c47-29ff-4878-a43f-4228283ee5a8', 35,
 'Computers filter the data to reveal a high-resolution 3D map of the ________ beneath the forest.', 'bare earth', '["bare earth","earth","Bare earth"]'),
('ae231982-0ec2-4cf4-97b8-26eeb770c298', 'c0c91c47-29ff-4878-a43f-4228283ee5a8', 36,
 'The LiDAR scans in Bolivia uncovered massive stepped platforms used as ________ centers.', 'civic-ceremonial', '["civic-ceremonial","civic ceremonial","Civic-ceremonial"]'),
('a6857168-7300-4d93-ad7a-39834b349f70', 'c0c91c47-29ff-4878-a43f-4228283ee5a8', 37,
 'Hundreds of kilometers of raised ________ connected the settlements during seasonal floods.', 'causeways', '["causeways","Causeways","raised causeways"]'),
('8ce29454-dfe7-49f3-bd4b-95262f618964', 'c0c91c47-29ff-4878-a43f-4228283ee5a8', 38,
 'Canals were used to capture sediment and to support ________, providing high-quality protein.', 'aquaculture', '["aquaculture","aquaculture systems","Aquaculture"]'),
('305728d5-6ba2-4580-b29c-71f7fd7e7786', 'c0c91c47-29ff-4878-a43f-4228283ee5a8', 39,
 'Indigenous populations engineered a highly fertile, anthropogenic soil known as ________.', 'Terra Preta', '["Terra Preta","terra preta","Amazonian dark earth"]'),
('01b69aca-a6e4-49ea-9175-1ac8a8603462', 'c0c91c47-29ff-4878-a43f-4228283ee5a8', 40,
 'The lecturer argues that the ancient Amazon should be viewed as a heavily managed, ________ landscape rather than a pristine wilderness.', 'domesticated', '["domesticated","Domesticated"]');
