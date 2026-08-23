-- ============================================================
-- IELTS Practice Platform – Extended Seed Data
-- Target: Reading Module (Academic, Band 8 Difficulty)
-- Action: APPEND (No TRUNCATE)
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST ENTRY (Academic - Band 8)                           ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('e1418ebd-7de6-49b9-a3aa-cf9f9cc4e6b2', '9d77c05f-b2e2-45fa-8042-33df3df21462',
 'IELTS Academic Reading: Linguistics, Astrobiology & Epistemology (Band 8)', 'Academic', '8', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: The Rosetta Stone and the Decipherment of Egyptian Hieroglyphs (Q1–13)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('f4bc8a8b-3c45-4138-9971-f8a797baad18', 'e1418ebd-7de6-49b9-a3aa-cf9f9cc4e6b2', 1,
 'The Rosetta Stone and the Decipherment of Egyptian Hieroglyphs',
 '(A) For over a millennium, the complex writing system of ancient Egypt—hieroglyphs—was a profound enigma. Following the decline of the Egyptian empire and the spread of Christianity, the knowledge required to read this intricate pictorial script was entirely lost by the 5th century AD. Scholars during the Renaissance and the Enlightenment made sporadic, often fantastical, attempts to decode the inscriptions found on obelisks and temple walls, frequently assuming the symbols were purely esoteric or mystical ideograms rather than a functional phonetic language.

(B) The turning point in Egyptology occurred in 1799 during Napoleon Bonaparte’s military campaign in Egypt. French soldiers reconstructing a fort near the town of Rashid (Rosetta) in the Nile Delta unearthed a massive granodiorite stele. Now universally known as the Rosetta Stone, this artifact was inscribed with a decree issued at Memphis in 196 BC on behalf of King Ptolemy V. Crucially, the decree was recorded in three distinct scripts: Ancient Egyptian hieroglyphs at the top, Demotic (the everyday script of the Egyptian populace) in the middle, and Ancient Greek at the base. Because Ancient Greek was well understood by European scholars, the stone provided an invaluable bilingual key.

(C) Following the British defeat of the French in Egypt in 1801, the Rosetta Stone was transported to London under the terms of the Capitulation of Alexandria, eventually taking residence in the British Museum. The race to decipher the script commenced almost immediately. The English polymath Thomas Young made the first significant breakthrough. Young correctly deduced that the cartouches—oval loops containing a series of hieroglyphs—housed the phonetic spellings of royal names, specifically that of Ptolemy. He successfully matched the Demotic text to the Greek, proving that Demotic was a functional alphabet, but he struggled to apply this phonetic principle to the hieroglyphs as a whole, still clinging partially to the belief that they were largely symbolic.

(D) The definitive decipherment was ultimately achieved by the brilliant French philologist Jean-François Champollion. Building upon Young’s initial phonetic discoveries, Champollion possessed a distinct advantage: a profound mastery of Coptic, the direct linguistic descendant of ancient Egyptian. By systematically comparing the hieroglyphs on the Rosetta Stone with those on other newly discovered monuments, Champollion demonstrated in 1822 that the hieroglyphic writing system was an amalgamation of phonetic, ideographic, and determinative signs. He proved that the script was not merely a collection of mystical symbols, but a robust, expressive spoken language.

(E) Champollion’s publication, the "Lettre à M. Dacier," outlined his methodology and successfully translated the names of various foreign pharaohs. He subsequently expanded this into a comprehensive grammar and dictionary of ancient Egyptian, effectively founding the modern discipline of Egyptology. The Rosetta Stone, therefore, served as the indispensable catalyst that allowed humanity to finally hear the voices of an ancient civilization that had been silent for over fourteen centuries.');

-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('1870ba61-cb14-4c72-bcee-7d0a98e39d3e', 'f4bc8a8b-3c45-4138-9971-f8a797baad18', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the passage? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('18a9fe2b-0d53-46fd-aaf8-96335299d5fa', '1870ba61-cb14-4c72-bcee-7d0a98e39d3e', 1,
 'Renaissance scholars successfully translated a small number of hieroglyphs using mystical ideograms.', 'FALSE', '["FALSE","False","false"]'),
('17bdb193-628f-4c2b-95f7-644a4b8f5ff3', '1870ba61-cb14-4c72-bcee-7d0a98e39d3e', 2,
 'The Rosetta Stone was discovered accidentally by soldiers undertaking a construction project.', 'TRUE', '["TRUE","True","true"]'),
('f706c520-97b4-4164-9f3d-933710422494', '1870ba61-cb14-4c72-bcee-7d0a98e39d3e', 3,
 'Thomas Young and Jean-François Champollion frequently corresponded via letters to share their findings.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('8e1d1103-96ab-4c5e-a28f-7cf34499ef4e', '1870ba61-cb14-4c72-bcee-7d0a98e39d3e', 4,
 'Champollion''s knowledge of the Coptic language was instrumental to his final decipherment of the hieroglyphs.', 'TRUE', '["TRUE","True","true"]');

-- ── Group 2: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('38cb7c04-77f6-46d7-9247-f6e72cfcc171', 'f4bc8a8b-3c45-4138-9971-f8a797baad18', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('fc8c0284-bef2-4aef-8e65-48a8767f7a84', '38cb7c04-77f6-46d7-9247-f6e72cfcc171', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"Scholar / Entity","answer":""},{"id":"h2","gapText":"Contribution / Event","answer":""}]'),
('ec47a0ef-6658-4e31-b162-3ed45659a84f', '38cb7c04-77f6-46d7-9247-f6e72cfcc171', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"French soldiers (1799)","answer":""},{"id":"c2","gapText":"Discovered a massive {{gap}} stele near Rashid.","answer":"granodiorite"}]'),
('c4681e02-ca8d-4e6c-9139-efc6d86d8d74', '38cb7c04-77f6-46d7-9247-f6e72cfcc171', 7,
 'Row 3', '',
 '[{"id":"c3","gapText":"British military (1801)","answer":""},{"id":"c4","gapText":"Acquired the stone under the {{gap}} of Alexandria.","answer":"Capitulation"}]'),
('627826bf-991b-4f3a-a6b4-29899c12bc29', '38cb7c04-77f6-46d7-9247-f6e72cfcc171', 8,
 'Row 4', '',
 '[{"id":"c5","gapText":"Thomas Young","answer":""},{"id":"c6","gapText":"Deduced that oval loops known as {{gap}} contained royal names.","answer":"cartouches"}]'),
('f538db7d-a4ac-4021-967e-9fa50d117d8f', '38cb7c04-77f6-46d7-9247-f6e72cfcc171', 9,
 'Row 5', '',
 '[{"id":"c7","gapText":"Jean-François Champollion","answer":""},{"id":"c8","gapText":"Published a letter proving hieroglyphs were a spoken language, founding the discipline of {{gap}}.","answer":"Egyptology"}]');

-- ── Group 3: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('62b94b61-d9a2-4c74-94cd-95e3d6b22654', 'f4bc8a8b-3c45-4138-9971-f8a797baad18', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS from the passage for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('a62c2932-8271-4f35-808f-6dd4886852f3', '62b94b61-d9a2-4c74-94cd-95e3d6b22654', 10,
 'By which century had the knowledge of reading Egyptian hieroglyphs been completely lost?', '5th century AD', '[{"id":"1","text":"5th century AD"},{"id":"2","text":"the 5th century"}]'),
('9da65276-4856-4fd6-82c2-93478ef5f099', '62b94b61-d9a2-4c74-94cd-95e3d6b22654', 11,
 'On whose behalf was the decree inscribed on the Rosetta Stone issued?', 'King Ptolemy V', '[{"id":"1","text":"King Ptolemy V"},{"id":"2","text":"Ptolemy V"}]'),
('b0a38d86-9dbb-4cbc-8167-239f0702e769', '62b94b61-d9a2-4c74-94cd-95e3d6b22654', 12,
 'Which script was located in the middle section of the Rosetta Stone?', 'Demotic', '[{"id":"1","text":"Demotic"}]'),
('ac4d48ff-ab5c-4975-959a-fa102b9ebad2', '62b94b61-d9a2-4c74-94cd-95e3d6b22654', 13,
 'What term did Champollion use in 1822 to describe signs that specify the category of a word?', 'determinative signs', '[{"id":"1","text":"determinative signs"},{"id":"2","text":"determinative"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: Astrobiology: The Search for Extremophiles (Q14–27)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('85f99dca-2729-44aa-b879-1e3d673375f5', 'e1418ebd-7de6-49b9-a3aa-cf9f9cc4e6b2', 2,
 'Astrobiology: The Search for Extremophiles',
 '(A) For the majority of human history, biological dogma dictated that life could only exist within a very narrow spectrum of environmental parameters. It was assumed that life required moderate temperatures, abundant oxygen, a neutral pH, and ample sunlight. Consequently, astrobiologists—scientists who study the potential for life in the universe—focused their search exclusively on Earth-like exoplanets located within the "Goldilocks zone." However, discoveries made over the past four decades have radically dismantled this anthropocentric view, revealing that the biosphere of our own planet extends far beyond what was previously deemed habitable.

(B) The paradigm shift began in 1977 with the discovery of hydrothermal vents along the Galápagos Rift in the Pacific Ocean. Here, deep in the aphotic zone where no sunlight penetrates, scientists observed thriving ecosystems. The foundation of this food web was not photosynthetic plants, but chemosynthetic bacteria. These microorganisms extract energy directly from the toxic hydrogen sulfide venting from the Earth''s crust at temperatures exceeding 400°C. This revelation proved that sunlight is not a strict prerequisite for complex biological communities, forcing scientists to entirely re-evaluate the prerequisites for life.

(C) Following the discovery of hydrothermal vents, biologists began to identify other "extremophiles"—organisms that thrive in physically or geochemically extreme conditions. In the dry, freezing expanse of the McMurdo Dry Valleys in Antarctica, cryptoendolithic fungi have been found living inside the porous structures of sandstone rocks. Similarly, in the highly acidic, heavy-metal-laden waters of the Rio Tinto in Spain, extremophile bacteria flourish, metabolizing iron and sulfur. Perhaps the most resilient of all known organisms is the tardigrade, a microscopic metazoan capable of entering a state of suspended animation known as cryptobiosis. In this state, tardigrades can survive extreme radiation, absolute zero temperatures, and the vacuum of outer space.

(D) The existence of terrestrial extremophiles has profound implications for astrobiology. It broadens the scope of potential habitats within our own solar system. Mars, for instance, is currently a desolate, irradiated desert, but geological evidence suggests it once harbored liquid water and a thicker atmosphere. Astrobiologists postulate that if life ever originated on Mars, extremophile microbes might have retreated deep underground, surviving today in subterranean aquifers, much like the chemolithotrophic bacteria found miles beneath the Earth''s crust.

(E) Even more promising are the icy moons of the outer solar system, specifically Jupiter’s moon Europa and Saturn’s moon Enceladus. Both moons are covered by thick crusts of ice, but planetary scientists possess strong evidence that vast, liquid water oceans exist beneath their frozen surfaces, kept warm by tidal flexing generated by the gravitational pull of their host planets. Furthermore, the Cassini spacecraft detected plumes of water vapor and organic molecules erupting from fissures in Enceladus''s ice crust. If hydrothermal vents exist on the ocean floors of these moons, they could potentially support chemosynthetic ecosystems remarkably similar to those discovered along the Galápagos Rift.

(F) While the discovery of extraterrestrial life remains elusive, the study of Earth’s extremophiles provides the necessary biological templates for what to seek. The prevailing hypothesis among contemporary astrobiologists is that if we do encounter life beyond Earth, it will not be little green men, but resilient, microscopic extremophiles. By pushing the boundaries of where life can survive on our home planet, we are fundamentally redefining our search parameters for life among the stars.');

-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('807903d8-db45-428b-9cfa-247630c4a5e0', '85f99dca-2729-44aa-b879-1e3d673375f5', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. A re-evaluation of potential Martian habitats", "ii. The role of sunlight in aquatic ecosystems", "iii. A groundbreaking oceanic discovery that shifted biological paradigms", "iv. A catalog of Earth''s most resilient organisms", "v. The future trajectory of extraterrestrial exploration", "vi. Liquid oceans hidden beneath frozen crusts", "vii. The historical constraints placed on the definition of habitability", "viii. Why tardigrades are the focus of Mars missions"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('f3a59629-f922-4e11-9592-487f6004fe98', '807903d8-db45-428b-9cfa-247630c4a5e0', 14, 'Paragraph A', 'vii'),
('1ed0f562-eceb-4c61-920d-6ea44ee1ea86', '807903d8-db45-428b-9cfa-247630c4a5e0', 15, 'Paragraph B', 'iii'),
('12ad07ab-0b9c-483a-8912-3ed5b2f54f92', '807903d8-db45-428b-9cfa-247630c4a5e0', 16, 'Paragraph C', 'iv'),
('926baaed-bbba-41fa-8f69-95c940e52225', '807903d8-db45-428b-9cfa-247630c4a5e0', 17, 'Paragraph D', 'i'),
('3064b922-1090-479f-a2ec-273bc061b074', '807903d8-db45-428b-9cfa-247630c4a5e0', 18, 'Paragraph E', 'vi'),
('3276febb-f198-48e2-b896-24fbae0fcb98', '807903d8-db45-428b-9cfa-247630c4a5e0', 19, 'Paragraph F', 'v');

-- ── Group 5: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('b1b6a2f2-1024-47ad-8f0f-e0be932b7dbb', '85f99dca-2729-44aa-b879-1e3d673375f5', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('b5e7436b-210e-4b83-9a27-5b9a84bbe2c0', 'b1b6a2f2-1024-47ad-8f0f-e0be932b7dbb', 20,
 'A description of how certain microorganisms convert toxic chemicals into energy.', 'B',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('74e33ab2-08a9-4522-8e17-d56bf5b6d29b', 'b1b6a2f2-1024-47ad-8f0f-e0be932b7dbb', 21,
 'An explanation of the physical forces that maintain liquid water far from the sun.', 'E',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('ace5aee5-dd28-4965-9a28-6fb73f3a0bd9', 'b1b6a2f2-1024-47ad-8f0f-e0be932b7dbb', 22,
 'A hypothesis concerning where biological remnants might currently reside on a neighboring planet.', 'D',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('63fa7e57-4541-4dea-a29b-081f80176ae9', 'b1b6a2f2-1024-47ad-8f0f-e0be932b7dbb', 23,
 'Mention of a microscopic animal capable of surviving exposure to the void of space.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');

-- ── Group 6: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('07a536e7-192c-4fc6-9ddd-8058d4ce31c3', '85f99dca-2729-44aa-b879-1e3d673375f5', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('1bdce614-acf2-4dc5-865d-481c3dc0ecd1', '07a536e7-192c-4fc6-9ddd-8058d4ce31c3', 24,
 'According to the first paragraph, what did early astrobiologists assume was necessary for life?',
 'C',
 '[{"id":"A","text":"A. The presence of chemosynthetic bacteria.","isCorrect":false},{"id":"B","text":"B. Environments with highly acidic water.","isCorrect":false},{"id":"C","text":"C. Moderate parameters including neutral pH and sunlight.","isCorrect":true},{"id":"D","text":"D. Proximity to a gas giant like Jupiter or Saturn.","isCorrect":false}]'),
('09e4875b-e6fe-4857-b9bc-4dd6adf2fff1', '07a536e7-192c-4fc6-9ddd-8058d4ce31c3', 25,
 'The significance of the discovery at the Galápagos Rift was that it:',
 'A',
 '[{"id":"A","text":"A. Demonstrated that complex life could thrive completely independent of solar energy.","isCorrect":true},{"id":"B","text":"B. Proved that hydrogen sulfide is necessary for all deep-sea organisms.","isCorrect":false},{"id":"C","text":"C. Highlighted the vulnerability of deep-sea ecosystems to human interference.","isCorrect":false},{"id":"D","text":"D. Suggested that ocean temperatures were much higher than previously recorded.","isCorrect":false}]'),
('29a0b50f-a539-4bb1-8705-6f7606dfb588', '07a536e7-192c-4fc6-9ddd-8058d4ce31c3', 26,
 'What does the passage state regarding the icy moons Europa and Enceladus?',
 'D',
 '[{"id":"A","text":"A. They are currently the only places in the solar system proven to harbor life.","isCorrect":false},{"id":"B","text":"B. Their surface temperatures are maintained by their proximity to the sun.","isCorrect":false},{"id":"C","text":"C. Scientists have directly observed aquatic life swimming in their subsurface oceans.","isCorrect":false},{"id":"D","text":"D. The gravitational forces of their host planets likely generate internal heat.","isCorrect":true}]'),
('0894d796-e803-4a92-88f0-0118d3676213', '07a536e7-192c-4fc6-9ddd-8058d4ce31c3', 27,
 'What is the writer’s main conclusion in the final paragraph?',
 'B',
 '[{"id":"A","text":"A. Astrobiologists should abandon the search for life on Mars and focus on icy moons.","isCorrect":false},{"id":"B","text":"B. Studying terrestrial extremophiles provides a predictive framework for alien life.","isCorrect":true},{"id":"C","text":"C. It is highly probable that complex, intelligent life forms exist on exoplanets.","isCorrect":false},{"id":"D","text":"D. Discovering extraterrestrial extremophiles will inevitably occur within our lifetime.","isCorrect":false}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: The Illusion of Epistemic Certainty (Q28–40)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('b075ec3a-ef72-4647-9c71-27783f84c432', 'e1418ebd-7de6-49b9-a3aa-cf9f9cc4e6b2', 3,
 'The Illusion of Epistemic Certainty',
 '(A) The foundational quest of epistemology—the branch of philosophy concerned with the nature and limits of human knowledge—is to identify what we can know with absolute certainty. Historically, thinkers have sought an indubitable bedrock upon which to construct the edifice of human understanding. René Descartes famously engaged in "methodological skepticism," systematically doubting all his beliefs until he arrived at the solitary, seemingly irrefutable proposition: "I think, therefore I am." However, modern cognitive science and psychology have increasingly undermined the Cartesian ideal of a rational, objective mind, suggesting instead that human cognition is inherently flawed, biased, and susceptible to profound illusions of certainty.

(B) The human brain is not a passive recording device that flawlessly captures objective reality; rather, it is an active prediction engine. To manage the overwhelming deluge of sensory information it receives every second, the brain relies on heuristics—mental shortcuts that allow for rapid decision-making. While evolutionarily advantageous for survival in a hostile environment, these heuristics frequently lead to systemic cognitive biases. The "confirmation bias," for instance, compels individuals to disproportionately seek out, interpret, and remember information that aligns with their pre-existing beliefs, while simultaneously dismissing or rationalizing away contradictory evidence. Consequently, a subjective feeling of absolute certainty is often less a reflection of objective truth and more a measure of neurological comfort.

(C) This epistemic vulnerability is further compounded by the Dunning-Kruger effect, a cognitive bias wherein individuals with low ability, expertise, or experience regarding a certain type of task or area of knowledge tend to overestimate their ability or knowledge. The tragic irony of this psychological phenomenon is that the very skills required to accurately evaluate one’s competence are identical to the skills required to be competent in the first place. Therefore, those lacking knowledge lack the exact cognitive tools necessary to recognize their own ignorance. Conversely, genuine experts often suffer from the opposite affliction, underestimating their relative competence because they assume tasks that are easy for them are equally easy for others.

(D) The illusion of epistemic certainty has profound socio-political implications, particularly in the modern digital ecosystem. The architecture of social media algorithms is meticulously designed to maximize user engagement, a goal achieved by creating personalized "filter bubbles." These echo chambers insulate users from dissenting perspectives, feeding them a continuous loop of ideologically congruent content. By structurally reinforcing confirmation bias on a global scale, these platforms manufacture an artificial consensus, leading individuals to believe that their highly subjective worldview is an undeniable, universally accepted reality. When encountering individuals from outside their epistemic bubble, the resulting cognitive dissonance frequently manifests as hostility rather than curiosity.

(E) Overcoming this pervasive illusion requires a radical shift in how we conceptualize intelligence and knowledge. Rather than viewing certainty as the ultimate intellectual achievement, we must cultivate "intellectual humility." This involves recognizing the fallibility of our own cognitive processes, actively seeking out disconfirming evidence, and remaining open to revising our beliefs in light of new data. The philosopher Karl Popper argued that the hallmark of a robust scientific theory is not that it can be proven true, but that it is "falsifiable"—that there exists a conceivable observation that could prove it false. 

(F) By applying Popper’s principle of falsifiability to our personal beliefs, we can transition from a dogmatic defense of our pre-existing worldviews to a dynamic, ongoing process of intellectual refinement. Acknowledging that our epistemic certainty is largely an illusion is not a concession to nihilism; rather, it is the fundamental prerequisite for genuine intellectual growth and the pursuit of a more accurate, albeit inevitably imperfect, understanding of the world.');

-- ── Group 7: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('fea6a61c-9ec2-4a7b-a6c7-702732d3d5d4', 'b075ec3a-ef72-4647-9c71-27783f84c432', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('411ddd0b-2730-48a5-a6e6-3c7dc8d2d0e7', 'fea6a61c-9ec2-4a7b-a6c7-702732d3d5d4', 28,
 'Modern cognitive science largely supports Descartes'' belief in a purely rational and objective human mind.', 'NO', '["NO","No","no"]'),
('23b21b65-d8a2-425b-9340-eca5292eb31e', 'fea6a61c-9ec2-4a7b-a6c7-702732d3d5d4', 29,
 'Mental heuristics evolved because they provided early humans with a significant survival advantage.', 'YES', '["YES","Yes","yes"]'),
('5f67dc92-d1f1-4ac4-8b1f-dda672ff47e4', 'fea6a61c-9ec2-4a7b-a6c7-702732d3d5d4', 30,
 'Individuals who display the Dunning-Kruger effect are generally less successful in their professional careers.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]'),
('ffed8022-cf77-426c-aa89-fca61206d354', 'fea6a61c-9ec2-4a7b-a6c7-702732d3d5d4', 31,
 'Social media algorithms actively challenge users by regularly presenting them with conflicting viewpoints.', 'NO', '["NO","No","no"]');

-- ── Group 8: MATCHING SENTENCE ENDINGS (Q32–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('87563f0a-66a0-46fd-9287-17c8114d5504', 'b075ec3a-ef72-4647-9c71-27783f84c432', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('5362c083-061e-4811-a585-f32991c71a5d', '87563f0a-66a0-46fd-9287-17c8114d5504', 32,
 'Because the human brain functions as an active prediction engine, it',
 'C',
 '[{"id":"A","text":"often lacks the precise cognitive abilities to recognize its own ignorance.","isCorrect":false},{"id":"B","text":"insulates individuals within artificial echo chambers to maximize engagement.","isCorrect":false},{"id":"C","text":"utilizes shortcuts that systematically distort the objective evaluation of data.","isCorrect":true},{"id":"D","text":"argued that the value of a theory lies in its potential to be proven incorrect.","isCorrect":false},{"id":"E","text":"requires acknowledging that absolute epistemic certainty is impossible.","isCorrect":false},{"id":"F","text":"frequently underestimates its competence due to a false assumption of universal ease.","isCorrect":false}]'),
('129e1047-50a4-4eb4-bab4-398bd2e7de01', '87563f0a-66a0-46fd-9287-17c8114d5504', 33,
 'According to the dynamics of the Dunning-Kruger effect, a person with highly limited expertise',
 'A',
 '[{"id":"A","text":"often lacks the precise cognitive abilities to recognize its own ignorance.","isCorrect":true},{"id":"B","text":"insulates individuals within artificial echo chambers to maximize engagement.","isCorrect":false},{"id":"C","text":"utilizes shortcuts that systematically distort the objective evaluation of data.","isCorrect":false},{"id":"D","text":"argued that the value of a theory lies in its potential to be proven incorrect.","isCorrect":false},{"id":"E","text":"requires acknowledging that absolute epistemic certainty is impossible.","isCorrect":false},{"id":"F","text":"frequently underestimates its competence due to a false assumption of universal ease.","isCorrect":false}]'),
('90399cd4-4ad3-4301-80de-70bef8b218fd', '87563f0a-66a0-46fd-9287-17c8114d5504', 34,
 'The digital architecture of modern social networking platforms',
 'B',
 '[{"id":"A","text":"often lacks the precise cognitive abilities to recognize its own ignorance.","isCorrect":false},{"id":"B","text":"insulates individuals within artificial echo chambers to maximize engagement.","isCorrect":true},{"id":"C","text":"utilizes shortcuts that systematically distort the objective evaluation of data.","isCorrect":false},{"id":"D","text":"argued that the value of a theory lies in its potential to be proven incorrect.","isCorrect":false},{"id":"E","text":"requires acknowledging that absolute epistemic certainty is impossible.","isCorrect":false},{"id":"F","text":"frequently underestimates its competence due to a false assumption of universal ease.","isCorrect":false}]'),
('cac44b77-db5d-4635-94ea-f36ff094262a', '87563f0a-66a0-46fd-9287-17c8114d5504', 35,
 'The prominent philosopher Karl Popper',
 'D',
 '[{"id":"A","text":"often lacks the precise cognitive abilities to recognize its own ignorance.","isCorrect":false},{"id":"B","text":"insulates individuals within artificial echo chambers to maximize engagement.","isCorrect":false},{"id":"C","text":"utilizes shortcuts that systematically distort the objective evaluation of data.","isCorrect":false},{"id":"D","text":"argued that the value of a theory lies in its potential to be proven incorrect.","isCorrect":true},{"id":"E","text":"requires acknowledging that absolute epistemic certainty is impossible.","isCorrect":false},{"id":"F","text":"frequently underestimates its competence due to a false assumption of universal ease.","isCorrect":false}]');

-- ── Group 9: SUMMARY COMPLETION with Word Bank (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('7fd68470-7afe-48cd-9a1a-2a6e15b24cdb', 'b075ec3a-ef72-4647-9c71-27783f84c432', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["dissonance", "humility", "consensus", "algorithms", "vulnerability", "bias", "falsifiable", "nihilism"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('6d008df6-c723-442c-bf62-43f6949d6890', '7fd68470-7afe-48cd-9a1a-2a6e15b24cdb', 36,
 'The writer argues that the subjective feeling of being absolutely right is largely an illusion generated by neurological shortcuts. In the modern era, this inherent cognitive {{gap_7fd68470-7afe-48cd-9a1a-2a6e15b24cdb_0}} is deeply exacerbated by social media. These platforms use advanced {{gap_7fd68470-7afe-48cd-9a1a-2a6e15b24cdb_1}} to trap users in environments that constantly validate their pre-existing beliefs, manufacturing a false sense of global {{gap_7fd68470-7afe-48cd-9a1a-2a6e15b24cdb_2}}. To combat this, individuals must actively cultivate intellectual {{gap_7fd68470-7afe-48cd-9a1a-2a6e15b24cdb_3}}, recognizing that true intellectual growth relies on treating our personal beliefs as theories that must remain inherently {{gap_7fd68470-7afe-48cd-9a1a-2a6e15b24cdb_4}}.',
 'vulnerability'),
('df92bf50-b4c2-450d-b8f9-eef22b807b38', '7fd68470-7afe-48cd-9a1a-2a6e15b24cdb', 37,
 '', 'algorithms'),
('c94680d7-9647-4389-bc5e-300cdc7c4660', '7fd68470-7afe-48cd-9a1a-2a6e15b24cdb', 38,
 '', 'consensus'),
('7520690c-70b6-476f-8fc4-ac70651550bb', '7fd68470-7afe-48cd-9a1a-2a6e15b24cdb', 39,
 '', 'humility'),
('4551d45c-3956-46fc-b215-8c5bd2ef7e77', '7fd68470-7afe-48cd-9a1a-2a6e15b24cdb', 40,
 '', 'falsifiable');

-- ============================================================
-- NOTE: Please execute `UPDATE reading_tests SET created_by = '<your-uid>'` 
-- if required by your application's Row Level Security policies.
-- ============================================================