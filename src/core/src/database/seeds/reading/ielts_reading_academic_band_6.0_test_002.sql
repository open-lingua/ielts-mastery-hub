-- ============================================================
-- IELTS Practice Platform – Extended Seed Data
-- Target: Reading Module (Academic, Band 6 Difficulty)
-- Action: APPEND (No TRUNCATE)
-- ============================================================

-- ████████████████████████████████████████████████████████████████
-- ██  TEST ENTRY (Academic - Band 6)                           ██
-- ████████████████████████████████████████████████████████████████

INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) VALUES
('f3014d03-8aef-4743-b4c5-03310b51e609', '67cc9890-d003-44ba-9270-cf831a620ea7',
 'IELTS Academic Reading: Agriculture, Biology & Psychology (Band 6)', 'Academic', '6', '60 mins', 'published');

-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 1: The Surprising History of the Tomato (Q1–13)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('6b167078-243c-4676-b871-31389ce1c751', 'f3014d03-8aef-4743-b4c5-03310b51e609', 1,
 'The Surprising History of the Tomato',
 '(A) Today, the tomato is a staple of diets worldwide, heavily featured in Italian pastas, Indian curries, and American fast food. However, this universally loved ingredient was once viewed with intense suspicion. Originating in the Andes region of South America, the wild ancestor of the tomato was a small, green, berry-like fruit. The Aztecs of Mexico were the first to domesticate it, cultivating a larger, redder version that they called "tomatl," which translates to "plump thing with a navel." When Spanish conquistadors arrived in the Americas in the early 16th century, they were introduced to this novel food and subsequently brought seeds back to Europe.

(B) Upon its arrival in Europe, the tomato faced a significant image problem. Botanists quickly identified it as a member of the nightshade family, a group of plants known to contain highly toxic species, such as belladonna and mandrake. This botanical association led to widespread fear. In northern Europe, particularly in Britain, the tomato was widely believed to be poisonous. Wealthy aristocrats who ate tomatoes from pewter plates often fell ill or died. They blamed the fruit, not realizing that the high acidity of the tomato was leaching toxic lead from their expensive pewter dinnerware. Consequently, for over two centuries, tomatoes were grown in Britain and its colonies purely as ornamental garden plants, admired for their bright red fruit but never eaten.

(C) It was in the Mediterranean region that the tomato finally found acceptance. The poorer populations of Spain and Italy, who ate from wooden trenchers rather than pewter plates, did not experience lead poisoning. They found the tomato to be a cheap, easy-to-grow, and flavorful addition to their diets. By the 17th century, it was a common ingredient in southern European peasant dishes. The Italian word for tomato, "pomodoro" (golden apple), suggests that the first varieties widely grown there were yellow rather than red. 

(D) The tomato''s transition into North American cuisine was slow. Despite being native to the Americas, it was introduced to the British colonies via Europe, carrying its toxic reputation with it. Legend has it that in 1820, a man named Robert Gibbon Johnson stood on the steps of a courthouse in Salem, New Jersey, and consumed a basket of tomatoes in front of a horrified crowd to prove they were safe. Whether true or not, by the mid-19th century, the tomato''s reputation had improved significantly. The invention of canning in the late 1800s transformed the tomato into a commercially viable crop, allowing it to be preserved and transported long distances, cementing its place in the modern global diet.');

-- ── Group 1: TRUE/FALSE/NOT GIVEN (Q1–4) ──────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('5aace3c6-9109-44ee-808a-e1473ae59728', '6b167078-243c-4676-b871-31389ce1c751', 1,
 'true-false-not-given', 'Do the following statements agree with the information given in the passage? Write TRUE, FALSE, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('9d9e9b6b-29ce-46c4-8fe8-95181f6b661d', '5aace3c6-9109-44ee-808a-e1473ae59728', 1,
 'The Aztecs were the first people to cultivate a red version of the tomato.', 'TRUE', '["TRUE","True","true"]'),
('60e7293c-0dc9-4421-8d5b-2d37d883986f', '5aace3c6-9109-44ee-808a-e1473ae59728', 2,
 'British aristocrats were poisoned by toxins naturally present in the tomato fruit.', 'FALSE', '["FALSE","False","false"]'),
('51eb3159-0b35-47bc-88ab-04903b2602a4', '5aace3c6-9109-44ee-808a-e1473ae59728', 3,
 'The first tomatoes eaten in Italy were mostly red in color.', 'FALSE', '["FALSE","False","false"]'),
('265d7e20-db13-493e-bce4-6e2398e064d9', '5aace3c6-9109-44ee-808a-e1473ae59728', 4,
 'Robert Gibbon Johnson was a wealthy aristocrat from Salem, New Jersey.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]');

-- ── Group 2: TABLE COMPLETION (Q5–9) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('59ec9519-0fbd-4592-9216-08d73043df7c', '6b167078-243c-4676-b871-31389ce1c751', 2,
 'table-completion', 'Complete the table below. Choose NO MORE THAN TWO WORDS from the passage for each answer.', true, '2');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, completion_gaps) VALUES
('37e2af5e-33f7-4823-bfca-7046d33d0bfa', '59ec9519-0fbd-4592-9216-08d73043df7c', 5,
 'Row 1', '',
 '[{"id":"h1","gapText":"Location / Era","answer":""},{"id":"h2","gapText":"Events / Uses","answer":""}]'),
('5899d12b-188d-40bf-af58-30f328f9e943', '59ec9519-0fbd-4592-9216-08d73043df7c', 6,
 'Row 2', '',
 '[{"id":"c1","gapText":"South America (Pre-16th century)","answer":""},{"id":"c2","gapText":"The wild ancestor was a green fruit. Aztecs grew a {{gap}} version.","answer":"larger"}]'),
('ace87427-39ef-4e71-a184-f8c697313f1b', '59ec9519-0fbd-4592-9216-08d73043df7c', 7,
 'Row 3', '',
 '[{"id":"c3","gapText":"Britain (16th-18th centuries)","answer":""},{"id":"c4","gapText":"Considered poisonous. Grown strictly as {{gap}}.","answer":"ornamental"}]'),
('a336c85c-eb42-45a6-accd-be24b8945663', '59ec9519-0fbd-4592-9216-08d73043df7c', 8,
 'Row 4', '',
 '[{"id":"c5","gapText":"Mediterranean (17th century)","answer":""},{"id":"c6","gapText":"Became a common ingredient in {{gap}} dishes.","answer":"peasant"}]'),
('e42bc4d3-0ef1-4e15-b700-a229bb3be130', '59ec9519-0fbd-4592-9216-08d73043df7c', 9,
 'Row 5', '',
 '[{"id":"c7","gapText":"North America (Late 1800s)","answer":""},{"id":"c8","gapText":"The invention of {{gap}} made it a commercial crop.","answer":"canning"}]');

-- ── Group 3: SHORT ANSWER (Q10–13) ─────────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit) VALUES
('d511dca4-f03c-476d-8a06-1de951913073', '6b167078-243c-4676-b871-31389ce1c751', 3,
 'short-answer', 'Answer the questions below. Choose NO MORE THAN THREE WORDS from the passage for each answer.', true, '3');

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('a6aca2e5-c83d-4230-bfd8-75a0030797d2', 'd511dca4-f03c-476d-8a06-1de951913073', 10,
 'Who were the first people to bring tomato seeds to Europe?', 'Spanish conquistadors', '[{"id":"1","text":"Spanish conquistadors"},{"id":"2","text":"conquistadors"}]'),
('503b466e-92dd-445d-93c6-f27b3a785f29', 'd511dca4-f03c-476d-8a06-1de951913073', 11,
 'To which botanical family does the tomato belong?', 'nightshade family', '[{"id":"1","text":"nightshade family"},{"id":"2","text":"nightshade"}]'),
('6284537e-1c9e-47ea-ac62-4dc7b048834c', 'd511dca4-f03c-476d-8a06-1de951913073', 12,
 'What material were the dinner plates of wealthy British aristocrats made of?', 'pewter', '[{"id":"1","text":"pewter"}]'),
('06608d23-3913-43b1-b392-123b1bf3a801', 'd511dca4-f03c-476d-8a06-1de951913073', 13,
 'According to legend, what did Robert Gibbon Johnson consume to prove tomatoes were safe?', 'a basket', '[{"id":"1","text":"a basket"},{"id":"2","text":"basket of tomatoes"}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 2: The Migration of the Monarch Butterfly (Q14–27)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('d1390e9d-1f03-4060-989f-3aa93186312b', 'f3014d03-8aef-4743-b4c5-03310b51e609', 2,
 'The Migration of the Monarch Butterfly',
 '(A) The migration of the monarch butterfly is one of the most remarkable natural phenomena on Earth. Unlike most insects, which spend the winter as larvae or pupae in a dormant state, the adult monarch cannot survive freezing temperatures. To escape the harsh winters of North America, millions of monarchs fly up to 3,000 miles to reach warmer climates. Their primary wintering grounds are located in the mountains of central Mexico, where they cluster tightly together on oyamel fir trees to conserve heat.

(B) What makes this journey truly extraordinary is that the butterflies making the trip south have never been there before. The monarch''s life cycle is tied to the milkweed plant, the only food source for its caterpillars. As spring arrives, the monarchs leave Mexico and head north into the United States, laying eggs on milkweed plants along the way. The adults die shortly after, and it is their offspring that continue the journey north. It takes three to four generations of butterflies to reach the northernmost parts of their range in the United States and Canada. 

(C) It is the final generation of the year, born in late summer, that performs the spectacular migration south. This "super generation" is biologically different from the previous ones. Due to changing day length and cooler temperatures, these butterflies do not develop reproductive organs immediately. Instead, they enter a state called reproductive diapause, which allows them to live up to eight months—vastly longer than the two-to-six-week lifespan of normal summer monarchs. They use this extended time and energy to fly all the way back to the specific mountain forests in Mexico that their great-great-grandparents departed from months earlier.

(D) The navigation methods of the monarch remain a subject of intense scientific study. Researchers have discovered that monarchs use a "time-compensated sun compass." They monitor the position of the sun in the sky, and by combining this with an internal biological clock located in their antennae, they can maintain a consistent southerly heading even as the sun moves from east to west throughout the day. Additionally, there is evidence that monarchs possess magnetic compounds in their bodies that allow them to sense the Earth’s magnetic field, aiding their navigation on cloudy days.

(E) Despite their incredible navigational skills, monarch populations have seen a severe decline over the past two decades. A major factor is the loss of milkweed in their breeding grounds. The widespread use of agricultural herbicides has eradicated milkweed from many farms and roadsides across the American Midwest. Without milkweed, the monarchs cannot reproduce. Furthermore, illegal logging in Mexico threatens the specific fir forests they rely on for winter survival.

(F) Conservation efforts are now underway across North America. Many gardening groups and wildlife organizations are encouraging individuals to plant native milkweed species in their yards and community spaces. While these small-scale efforts cannot replace the vast tracts of lost agricultural habitat, they create vital "waystations" for the butterflies. Ensuring the survival of the monarch butterfly requires international cooperation to protect both their breeding grounds in the north and their wintering habitats in the south.');

-- ── Group 4: MATCHING HEADINGS (Q14–19) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, has_word_bank, word_bank) VALUES
('9bc99056-d995-4fc4-a6ca-9ae4ea2e2851', 'd1390e9d-1f03-4060-989f-3aa93186312b', 1,
 'matching-headings', 'The reading passage has six paragraphs, A–F. Choose the correct heading for each paragraph from the list of headings below.', true,
 true, '["i. The unique physical traits of the final generation", "ii. Finding the way without a map", "iii. The reliance on a single plant species", "iv. Human threats to the butterfly''s survival", "v. The necessity of escaping the cold", "vi. Small steps toward saving the species", "vii. How predators affect the migration", "viii. A multi-generational journey north"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('53219249-eab5-40b0-b6de-57ed91f0d169', '9bc99056-d995-4fc4-a6ca-9ae4ea2e2851', 14, 'Paragraph A', 'v'),
('82eae28d-0201-4b47-a004-a910f17de11a', '9bc99056-d995-4fc4-a6ca-9ae4ea2e2851', 15, 'Paragraph B', 'viii'),
('3f21c8dd-583c-491e-a87a-5e90e3df8634', '9bc99056-d995-4fc4-a6ca-9ae4ea2e2851', 16, 'Paragraph C', 'i'),
('9b9cc6d3-63e5-4862-b90c-dded4bff2e68', '9bc99056-d995-4fc4-a6ca-9ae4ea2e2851', 17, 'Paragraph D', 'ii'),
('a2debfd0-123a-4fd0-bfab-2c24ea49789e', '9bc99056-d995-4fc4-a6ca-9ae4ea2e2851', 18, 'Paragraph E', 'iv'),
('8695d389-065d-4867-941c-2ea7877292f5', '9bc99056-d995-4fc4-a6ca-9ae4ea2e2851', 19, 'Paragraph F', 'vi');

-- ── Group 5: MATCHING INFORMATION (Q20–23) ────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('95558c23-aa62-4615-95b1-b843dfd60570', 'd1390e9d-1f03-4060-989f-3aa93186312b', 2,
 'matching-information', 'Which paragraph contains the following information? Write the correct letter, A–F.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, matching_pairs) VALUES
('37bd3ab7-7278-4198-9ed4-5688581d2af8', '95558c23-aa62-4615-95b1-b843dfd60570', 20,
 'A description of a biological tool used to track time and direction.', 'D',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('b26ca6dc-29c0-4d04-8ad5-0a5cd88e3a2b', '95558c23-aa62-4615-95b1-b843dfd60570', 21,
 'The specific type of tree that the butterflies use for winter protection.', 'A',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('18c09ed5-b8aa-401d-9551-f46ab6fb9b2e', '95558c23-aa62-4615-95b1-b843dfd60570', 22,
 'The reason why the late-summer generation lives significantly longer.', 'C',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]'),
('edb69af8-c8f8-49dc-ae56-289425ec6acc', '95558c23-aa62-4615-95b1-b843dfd60570', 23,
 'An explanation of how agricultural chemicals are harming the species.', 'E',
 '[{"id":"1","left":"","right":"A"},{"id":"2","left":"","right":"B"},{"id":"3","left":"","right":"C"},{"id":"4","left":"","right":"D"},{"id":"5","left":"","right":"E"},{"id":"6","left":"","right":"F"}]');

-- ── Group 6: MULTIPLE CHOICE (Q24–27) ─────────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('ce16693b-9512-4aa5-84f6-c9c70346dd29', 'd1390e9d-1f03-4060-989f-3aa93186312b', 3,
 'multiple-choice', 'Choose the correct letter, A, B, C or D.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('2ea96d9d-b343-429e-a39f-de8c268884c5', 'ce16693b-9512-4aa5-84f6-c9c70346dd29', 24,
 'Unlike normal summer monarchs, the "super generation" of monarchs:',
 'B',
 '[{"id":"A","text":"A. Feeds on a variety of plants other than milkweed.","isCorrect":false},{"id":"B","text":"B. Delays the development of reproductive organs.","isCorrect":true},{"id":"C","text":"C. Relies heavily on wind currents to travel south.","isCorrect":false},{"id":"D","text":"D. Lives for two to six weeks.","isCorrect":false}]'),
('a4e7968b-2089-46cf-bb53-f25917c6da97', 'ce16693b-9512-4aa5-84f6-c9c70346dd29', 25,
 'The butterflies that arrive in Canada in the summer are:',
 'C',
 '[{"id":"A","text":"A. The exact same individuals that left Mexico in the spring.","isCorrect":false},{"id":"B","text":"B. The second generation born during the journey.","isCorrect":false},{"id":"C","text":"C. Several generations removed from those that left Mexico.","isCorrect":true},{"id":"D","text":"D. Unable to lay eggs due to reproductive diapause.","isCorrect":false}]'),
('02699feb-9d78-4f82-828d-afed2de1233e', 'ce16693b-9512-4aa5-84f6-c9c70346dd29', 26,
 'When the sky is cloudy, how do monarch butterflies manage to navigate?',
 'A',
 '[{"id":"A","text":"A. They utilize magnetic compounds within their bodies.","isCorrect":true},{"id":"B","text":"B. They rely solely on the position of the sun.","isCorrect":false},{"id":"C","text":"C. They follow the geographical layout of mountains.","isCorrect":false},{"id":"D","text":"D. They stop flying and rest until the sun reappears.","isCorrect":false}]'),
('4cdd79e4-e3e4-4d4c-94dc-43e4c2439aa7', 'ce16693b-9512-4aa5-84f6-c9c70346dd29', 27,
 'What is the writer suggesting in the final paragraph?',
 'B',
 '[{"id":"A","text":"A. Planting milkweed in gardens will completely solve the crisis.","isCorrect":false},{"id":"B","text":"B. Saving the monarch requires both local actions and broader cross-border efforts.","isCorrect":true},{"id":"C","text":"C. Deforestation in Mexico is a larger problem than herbicide use in the US.","isCorrect":false},{"id":"D","text":"D. Most wildlife organizations are focusing their efforts on the wrong plants.","isCorrect":false}]');


-- ══════════════════════════════════════════════════════════════
-- ██  PASSAGE 3: The Psychology of Collecting (Q28–40)
-- ══════════════════════════════════════════════════════════════

INSERT INTO reading_passages (id, test_id, passage_number, title, content) VALUES
('23bcad82-6c9a-440e-a266-42d288d9b165', 'f3014d03-8aef-4743-b4c5-03310b51e609', 3,
 'The Psychology of Collecting',
 '(A) Collecting is a surprisingly common human activity. From childhood rock collections to multi-million-dollar art acquisitions, the desire to gather and organize objects seems almost universal. It is estimated that nearly one-third of adults maintain a collection of some kind. But what drives this behavior? Psychologists and sociologists have long debated the motivations behind collecting, finding that it is rarely a simple pursuit. Instead, it is a complex activity that fulfills deep-seated psychological needs, ranging from a desire for control and order to a search for identity and social connection.

(B) One of the earliest psychological theories regarding collecting was proposed by Sigmund Freud. He suggested that collecting was a manifestation of the "anal stage" of development, relating it to an inherent desire to retain and control. While modern psychology has largely moved away from Freudian interpretations, the idea that collecting is about exerting control remains prominent. In a chaotic and unpredictable world, a collection offers a small, manageable domain where the collector has absolute authority. They decide what belongs, how it is categorized, and how it is displayed. This act of creating order can provide significant comfort and reduce feelings of anxiety.

(C) Another significant motivation is the relationship between collecting and personal identity. Objects often serve as physical extensions of the self. A collection of rare books may communicate intellectualism, while a collection of vintage sports memorabilia may reflect a deep-rooted passion for athletics. Over time, collectors often merge their identity with their collection. The objects become a timeline of the collector''s life, representing memories, travels, and personal milestones. Sociologist Jean Baudrillard argued that people collect objects to build a unique personal narrative, distinguishing themselves from the masses in a society dominated by mass-produced goods.

(D) The thrill of the hunt is also a powerful driver. The human brain is wired to seek out rewards, and finding a rare or missing piece for a collection triggers a release of dopamine, the brain''s pleasure chemical. This "hunter-gatherer" instinct makes the process of searching out items—scouring flea markets, browsing online auctions, or negotiating with dealers—just as rewarding as actually owning them. Many collectors admit that the excitement fades somewhat once a collection is "complete," which often prompts them to start a brand new collection entirely.

(E) Collecting also possesses a strong social dimension. While the act of arranging items may be solitary, collectors frequently seek out communities of like-minded individuals. Conventions, online forums, and collector clubs provide a space where individuals can share their specialized knowledge, trade items, and gain social status. Within these subcultures, prestige is often determined not by wealth, but by the rarity of one''s collection and the depth of one''s expertise. This shared passion fosters strong bonds and a sense of belonging that can be difficult to find elsewhere.

(F) However, collecting can sometimes cross the line into problematic behavior. When the compulsion to acquire objects overwhelms a person’s finances, living space, or relationships, it may be classified as hoarding disorder. Unlike collectors, who typically display their items proudly and keep them organized, individuals with hoarding disorder often accumulate items haphazardly and feel intense distress at the thought of discarding anything, regardless of its objective value. Understanding the boundary between a healthy, enriching hobby and a debilitating disorder continues to be an important area of study for clinical psychologists.');

-- ── Group 7: YES/NO/NOT GIVEN (Q28–31) ───────────────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('1490a8ae-4cfb-463b-aa0f-e54cc8e6563d', '23bcad82-6c9a-440e-a266-42d288d9b165', 1,
 'yes-no-not-given', 'Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, accepted_answers) VALUES
('020751cc-87db-4417-a6a4-6d852cb872d6', '1490a8ae-4cfb-463b-aa0f-e54cc8e6563d', 28,
 'Modern psychologists generally agree with Freud’s specific theories about why people collect objects.', 'NO', '["NO","No","no"]'),
('cbd8744b-cf1c-41c0-b12a-db8729ec1976', '1490a8ae-4cfb-463b-aa0f-e54cc8e6563d', 29,
 'Organizing a collection can help alleviate feelings of anxiety.', 'YES', '["YES","Yes","yes"]'),
('514dc1a3-9bd2-42d4-8dc8-a438df41c11d', '1490a8ae-4cfb-463b-aa0f-e54cc8e6563d', 30,
 'Collectors usually stop buying items completely once they have finished their first collection.', 'NO', '["NO","No","no"]'),
('b104db25-3e72-4f38-b6b8-c682ddcb9a43', '1490a8ae-4cfb-463b-aa0f-e54cc8e6563d', 31,
 'Hoarding disorder is more common in older adults than in younger people.', 'NOT GIVEN', '["NOT GIVEN","Not Given","not given"]');

-- ── Group 8: MATCHING SENTENCE ENDINGS (Q32–35) ─────────
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order) VALUES
('006710d2-6829-47fd-bfc9-ad75892f1f96', '23bcad82-6c9a-440e-a266-42d288d9b165', 2,
 'matching-sentence-endings', 'Complete each sentence with the correct ending, A–F, from the box below.', true);

INSERT INTO reading_questions (id, group_id, question_order, text, answer, options) VALUES
('2eb8b98d-cb53-4ed8-9250-9b12119fce7c', '006710d2-6829-47fd-bfc9-ad75892f1f96', 32,
 'According to Jean Baudrillard, people use their collections to',
 'E',
 '[{"id":"A","text":"increase their overall financial wealth over time.","isCorrect":false},{"id":"B","text":"create a messy environment that causes distress.","isCorrect":false},{"id":"C","text":"feel a sense of authority in a chaotic world.","isCorrect":false},{"id":"D","text":"experience a release of dopamine in the brain.","isCorrect":false},{"id":"E","text":"develop a unique personal identity separate from the crowd.","isCorrect":true},{"id":"F","text":"gain respect based on knowledge and item rarity.","isCorrect":false}]'),
('804316eb-f922-4c44-a0fe-0c90b7642d88', '006710d2-6829-47fd-bfc9-ad75892f1f96', 33,
 'The psychological desire to establish order allows a collector to',
 'C',
 '[{"id":"A","text":"increase their overall financial wealth over time.","isCorrect":false},{"id":"B","text":"create a messy environment that causes distress.","isCorrect":false},{"id":"C","text":"feel a sense of authority in a chaotic world.","isCorrect":true},{"id":"D","text":"experience a release of dopamine in the brain.","isCorrect":false},{"id":"E","text":"develop a unique personal identity separate from the crowd.","isCorrect":false},{"id":"F","text":"gain respect based on knowledge and item rarity.","isCorrect":false}]'),
('027ac33e-c637-4f90-89ef-a19aad65f773', '006710d2-6829-47fd-bfc9-ad75892f1f96', 34,
 'The process of searching for and discovering a rare item causes the collector to',
 'D',
 '[{"id":"A","text":"increase their overall financial wealth over time.","isCorrect":false},{"id":"B","text":"create a messy environment that causes distress.","isCorrect":false},{"id":"C","text":"feel a sense of authority in a chaotic world.","isCorrect":false},{"id":"D","text":"experience a release of dopamine in the brain.","isCorrect":true},{"id":"E","text":"develop a unique personal identity separate from the crowd.","isCorrect":false},{"id":"F","text":"gain respect based on knowledge and item rarity.","isCorrect":false}]'),
('cfbd1437-9d2b-4776-b117-6700388ce560', '006710d2-6829-47fd-bfc9-ad75892f1f96', 35,
 'Within specific collector communities and clubs, individuals are able to',
 'F',
 '[{"id":"A","text":"increase their overall financial wealth over time.","isCorrect":false},{"id":"B","text":"create a messy environment that causes distress.","isCorrect":false},{"id":"C","text":"feel a sense of authority in a chaotic world.","isCorrect":false},{"id":"D","text":"experience a release of dopamine in the brain.","isCorrect":false},{"id":"E","text":"develop a unique personal identity separate from the crowd.","isCorrect":false},{"id":"F","text":"gain respect based on knowledge and item rarity.","isCorrect":true}]');

-- ── Group 9: SUMMARY COMPLETION with Word Bank (Q36–40) ──
INSERT INTO reading_question_groups (id, passage_id, group_order, question_type, instructions, sequential_order, word_limit, has_word_bank, word_bank) VALUES
('c06d6631-5c50-4f06-ad73-7ba15f128d8c', '23bcad82-6c9a-440e-a266-42d288d9b165', 3,
 'summary-completion', 'Complete the summary below. Choose ONE WORD from the box for each answer.', true, '1',
 true, '["finances", "control", "narrative", "status", "disorder", "anxiety", "display", "hunt", "discard"]');

INSERT INTO reading_questions (id, group_id, question_order, text, answer) VALUES
('6e8ac04c-fa06-4867-9b5f-de213e2a0edb', 'c06d6631-5c50-4f06-ad73-7ba15f128d8c', 36,
 'Collecting fulfills various psychological needs. For some, it provides a sense of {{gap_c06d6631-5c50-4f06-ad73-7ba15f128d8c_0}} over a specific area of life. For others, objects act as an extension of the self, helping to build a personal {{gap_c06d6631-5c50-4f06-ad73-7ba15f128d8c_1}}. Furthermore, the excitement of the {{gap_c06d6631-5c50-4f06-ad73-7ba15f128d8c_2}} is a highly motivating factor due to brain chemistry. However, when collecting becomes an obsession that negatively affects a person''s relationships or {{gap_c06d6631-5c50-4f06-ad73-7ba15f128d8c_3}}, it may be deemed a hoarding disorder. Unlike a standard collector, a hoarder feels immense distress at the idea of having to {{gap_c06d6631-5c50-4f06-ad73-7ba15f128d8c_4}} any of their accumulated items.',
 'control'),
('1c35f9df-265f-4846-abba-a007ea2cb2e6', 'c06d6631-5c50-4f06-ad73-7ba15f128d8c', 37,
 '', 'narrative'),
('be8fff00-5db4-4ce4-b44b-0a00e6abe844', 'c06d6631-5c50-4f06-ad73-7ba15f128d8c', 38,
 '', 'hunt'),
('d465fefa-c1c8-4b4c-9f9e-6f772ae89001', 'c06d6631-5c50-4f06-ad73-7ba15f128d8c', 39,
 '', 'finances'),
('1dc3bcd3-ed0c-4883-a844-413fdef59276', 'c06d6631-5c50-4f06-ad73-7ba15f128d8c', 40,
 '', 'discard');

-- ============================================================
-- NOTE: Please execute `UPDATE reading_tests SET created_by = '<your-uid>'` 
-- if required by your application's Row Level Security policies.
-- ============================================================