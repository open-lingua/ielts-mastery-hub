// Comprehensive IELTS Reading Test with all 13 question types across 3 passages

export interface MCQuestion {
  id: string;
  type: "MULTIPLE_CHOICE";
  multiSelect?: boolean;
  selectCount?: number;
  text: string;
  options: string[];
  answer: string | string[];
}

export interface TFNGQuestion {
  id: string;
  type: "TRUE_FALSE_NOT_GIVEN";
  text: string;
  answer: "TRUE" | "FALSE" | "NOT GIVEN";
}

export interface YNNGQuestion {
  id: string;
  type: "YES_NO_NOT_GIVEN";
  text: string;
  answer: "YES" | "NO" | "NOT GIVEN";
}

export interface MatchingHeadingsQuestion {
  id: string;
  type: "MATCHING_HEADINGS";
  paragraphs: string[];
  headings: string[];
  answers: Record<string, string>;
}

export interface MatchingInformationQuestion {
  id: string;
  type: "MATCHING_INFORMATION";
  statements: { label: string; text: string }[];
  paragraphs: string[];
  answers: Record<string, string>;
}

export interface MatchingFeaturesQuestion {
  id: string;
  type: "MATCHING_FEATURES";
  features: { label: string; text: string }[];
  entities: string[];
  answers: Record<string, string>;
}

export interface MatchingSentenceEndingsQuestion {
  id: string;
  type: "MATCHING_SENTENCE_ENDINGS";
  stems: { label: string; text: string }[];
  endings: { label: string; text: string }[];
  answers: Record<string, string>;
}

export interface SentenceCompletionQuestion {
  id: string;
  type: "SENTENCE_COMPLETION";
  wordLimit: number;
  sentences: { label: string; text: string; gap: string; answer: string }[];
}

export interface SummaryCompletionQuestion {
  id: string;
  type: "SUMMARY_COMPLETION";
  wordLimit: number;
  useWordBank: boolean;
  wordBank?: string[];
  summaryText: string;
  gaps: { id: string; answer: string }[];
}

export interface NoteCompletionQuestion {
  id: string;
  type: "NOTE_COMPLETION";
  wordLimit: number;
  notes: { label: string; text: string; gap: string; answer: string }[];
}

export interface TableCompletionQuestion {
  id: string;
  type: "TABLE_COMPLETION";
  wordLimit: number;
  headers: string[];
  rows: { cells: (string | { gap: string; answer: string })[] }[];
}

export interface FlowchartCompletionQuestion {
  id: string;
  type: "FLOWCHART_COMPLETION";
  wordLimit: number;
  steps: { text: string; gap?: string; answer?: string }[];
}

export interface ShortAnswerQuestion {
  id: string;
  type: "SHORT_ANSWER";
  wordLimit: number;
  questions: { label: string; text: string; answer: string; acceptedAnswers?: string[] }[];
}

export type QuestionSection =
  | MCQuestion
  | TFNGQuestion
  | YNNGQuestion
  | MatchingHeadingsQuestion
  | MatchingInformationQuestion
  | MatchingFeaturesQuestion
  | MatchingSentenceEndingsQuestion
  | SentenceCompletionQuestion
  | SummaryCompletionQuestion
  | NoteCompletionQuestion
  | TableCompletionQuestion
  | FlowchartCompletionQuestion
  | ShortAnswerQuestion;

export interface ReadingSection {
  title: string;
  instructions: string;
  questionRange: string;
  data: QuestionSection;
}

export interface ReadingPassage {
  id: number;
  title: string;
  passage: string;
  paragraphLabels?: string[];
  sections: ReadingSection[];
}

export interface ReadingTest {
  title: string;
  passage: string;
  paragraphLabels?: string[];
  sections: ReadingSection[];
}

export interface MultiPassageReadingTest {
  id: string;
  format: "Academic" | "General Training";
  timer: number;
  passages: ReadingPassage[];
}

// ─── Passage 1: Climate & Agriculture (Questions 1–13) ────────

const passage1: ReadingPassage = {
  id: 1,
  title: "The Impact of Climate Change on Global Agriculture",
  passage: `(A) Climate change is increasingly recognized as one of the most significant threats to global food security. As temperatures rise, precipitation patterns shift, and extreme weather events become more frequent, agricultural systems worldwide are being forced to adapt to new conditions. The scale of this challenge is unprecedented in human history.

(B) Research conducted over the past two decades has demonstrated that rising temperatures can have both positive and negative effects on crop yields, depending on the region and the crop in question. In temperate regions, moderate warming has been associated with longer growing seasons and, in some cases, increased productivity for certain crops such as wheat and barley. However, in tropical and subtropical regions, where temperatures are already near the upper limits for many crop species, even small increases can lead to significant yield reductions.

(C) Water availability is another critical factor affected by climate change. Changes in rainfall patterns and the melting of glaciers are altering water supplies in many agricultural regions. Some areas are experiencing increased drought frequency, while others face greater risks of flooding. Both extremes pose challenges for crop production and livestock management, though irrigation technology has helped mitigate some effects.

(D) The Intergovernmental Panel on Climate Change (IPCC) has projected that global food production could decline by up to 25 percent by the end of this century if current trends continue. This projection takes into account not only the direct effects of temperature and precipitation changes but also the indirect impacts of increased pest pressure, soil degradation, and the loss of pollinators. Dr. Maria Santos, a lead IPCC researcher, has called these findings "a wake-up call for global agriculture."

(E) Adaptation strategies are being developed and implemented around the world. These include the development of drought-resistant crop varieties, improvements in irrigation efficiency, changes in planting schedules, and the adoption of conservation agriculture practices. Professor James Liu of Stanford University has pioneered several drought-resistant grain varieties, while Dr. Amara Osei at the University of Ghana has focused on traditional farming methods that enhance soil resilience.

(F) In addition to adaptation, mitigation efforts aimed at reducing greenhouse gas emissions from agricultural activities are also important. Agriculture is responsible for approximately 10-12 percent of global greenhouse gas emissions, primarily through livestock production, rice cultivation, and the use of synthetic fertilizers. Reducing these emissions while maintaining food production levels presents a significant challenge for policymakers and farmers alike.`,
  paragraphLabels: ["A", "B", "C", "D", "E", "F"],
  sections: [
    {
      title: "Questions 1–3",
      instructions:
        "Do the following statements agree with the information given in the Reading Passage? Write TRUE, FALSE, or NOT GIVEN.",
      questionRange: "1-3",
      data: {
        id: "p1_tfng",
        type: "TRUE_FALSE_NOT_GIVEN",
        text: "",
        answer: "TRUE",
      } as TFNGQuestion,
    },
    {
      title: "Questions 4–5",
      instructions: "Choose the correct letter, A, B, C or D.",
      questionRange: "4-5",
      data: {
        id: "p1_mc",
        type: "MULTIPLE_CHOICE",
        text: "",
        options: [],
        answer: "",
      } as MCQuestion,
    },
    {
      title: "Questions 6–8",
      instructions: "The reading passage has six paragraphs, A–F. Which paragraph contains the following information?",
      questionRange: "6-8",
      data: {
        id: "p1_mi",
        type: "MATCHING_INFORMATION",
        statements: [
          { label: "6", text: "A reference to the proportion of emissions caused by farming" },
          { label: "7", text: "An explanation of how water sources are changing" },
          { label: "8", text: "A prediction about future food output" },
        ],
        paragraphs: ["A", "B", "C", "D", "E", "F"],
        answers: { "6": "F", "7": "C", "8": "D" },
      } as MatchingInformationQuestion,
    },
    {
      title: "Questions 9–11",
      instructions: "Complete the sentences below. Choose NO MORE THAN TWO WORDS from the passage for each answer.",
      questionRange: "9-11",
      data: {
        id: "p1_sc",
        type: "SENTENCE_COMPLETION",
        wordLimit: 2,
        sentences: [
          {
            label: "9",
            text: "In temperate regions, moderate warming has led to longer {{gap}}.",
            gap: "p1gap9",
            answer: "growing seasons",
          },
          {
            label: "10",
            text: "Some regions face a higher risk of {{gap}} due to changing rainfall.",
            gap: "p1gap10",
            answer: "flooding",
          },
          {
            label: "11",
            text: "Agriculture accounts for about 10-12 percent of global {{gap}}.",
            gap: "p1gap11",
            answer: "greenhouse gas",
          },
        ],
      } as SentenceCompletionQuestion,
    },
    {
      title: "Questions 12–13",
      instructions: "Answer the questions below. Choose NO MORE THAN THREE WORDS from the passage for each answer.",
      questionRange: "12-13",
      data: {
        id: "p1_sa",
        type: "SHORT_ANSWER",
        wordLimit: 3,
        questions: [
          {
            label: "12",
            text: "What technology has helped reduce the impact of water changes on farming?",
            answer: "irrigation technology",
            acceptedAnswers: ["irrigation technology", "irrigation"],
          },
          {
            label: "13",
            text: "What type of agriculture practices are being adopted as an adaptation strategy?",
            answer: "conservation agriculture",
            acceptedAnswers: ["conservation agriculture", "conservation agriculture practices"],
          },
        ],
      } as ShortAnswerQuestion,
    },
  ],
};

// ─── Passage 2: Ancient Civilizations (Questions 14–27) ────────

const passage2: ReadingPassage = {
  id: 2,
  title: "The Lost Cities of the Ancient Andes",
  passage: `(A) High in the Andes Mountains, at altitudes exceeding 3,000 metres, lie the remnants of some of the most sophisticated civilizations the pre-Columbian Americas ever produced. Long before the Inca Empire rose to dominance in the fifteenth century, a succession of cultures had already mastered the challenges of building complex urban centres in one of the world's most demanding environments. Archaeological discoveries over the past three decades have fundamentally altered our understanding of these early Andean societies.

(B) The Tiwanaku civilization, centred near the shores of Lake Titicaca in modern-day Bolivia, flourished between approximately 500 and 1000 CE. At its peak, the city of Tiwanaku may have housed as many as 40,000 inhabitants, making it one of the largest urban centres in the ancient world. The Tiwanaku people developed an ingenious agricultural system known as "raised fields" or "suka kollus," which involved constructing elevated planting surfaces surrounded by water channels. This system provided natural frost protection through the thermal mass of the water and created a self-fertilizing cycle as aquatic plants decomposed into nutrient-rich sediment.

(C) Further north, the Wari Empire (600–1000 CE) controlled a vast territory stretching along the Peruvian coast and highlands. Unlike Tiwanaku, which was primarily a religious and ceremonial centre, the Wari state was characterized by its administrative efficiency and its network of roads and storage facilities. Dr. Patricia Hernández of the University of Lima has argued that the Wari road system served as the blueprint for the later Inca road network, known as the Qhapaq Ñan, which eventually spanned over 30,000 kilometres.

(D) Perhaps the most enigmatic of all Andean sites is Caral, located in the Supe Valley of Peru. Dating to approximately 2600 BCE, Caral is considered the oldest known city in the Americas and one of the oldest in the world. The site features six large platform mounds, sunken circular plazas, and residential areas. Remarkably, no evidence of warfare — no weapons, no defensive walls, no signs of violent conflict — has been found at Caral. Professor Ruth Shady Solís, who has led excavations at the site since 1994, believes that Caral's society was organized around commerce and religious practice rather than military conquest.

(E) Recent technological advances have revolutionized Andean archaeology. Lidar (Light Detection and Ranging) surveys have revealed previously unknown structures hidden beneath dense vegetation, while DNA analysis of ancient remains has provided new insights into migration patterns and genetic diversity. Isotope analysis of bones and teeth has allowed researchers to reconstruct the diets and mobility patterns of ancient populations with unprecedented precision.

(F) The legacy of these ancient Andean civilizations continues to resonate today. Many of the agricultural techniques developed by the Tiwanaku, including raised-field farming and terrace cultivation, are being revived by modern communities facing the challenges of climate change and food insecurity. The engineering principles behind Inca stonework continue to inspire architects and engineers, while the social organization of pre-Columbian Andean societies offers alternative models for understanding human cooperation and governance.`,
  paragraphLabels: ["A", "B", "C", "D", "E", "F"],
  sections: [
    {
      title: "Questions 14–17",
      instructions: "Choose the correct heading for each paragraph from the list of headings below.",
      questionRange: "14-17",
      data: {
        id: "p2_mh",
        type: "MATCHING_HEADINGS",
        paragraphs: ["B", "C", "D", "E"],
        headings: [
          "i. Advanced farming near a great lake",
          "ii. Modern relevance of ancient practices",
          "iii. A peaceful ancient metropolis",
          "iv. Administrative roads and imperial control",
          "v. New tools for uncovering the past",
          "vi. The mystery of Andean writing systems",
        ],
        answers: { B: "i", C: "iv", D: "iii", E: "v" },
      } as MatchingHeadingsQuestion,
    },
    {
      title: "Questions 18–20",
      instructions:
        "Look at the following statements and the list of researchers below. Match each statement with the correct researcher.",
      questionRange: "18-20",
      data: {
        id: "p2_mf",
        type: "MATCHING_FEATURES",
        features: [
          {
            label: "18",
            text: "Proposed that one civilization's infrastructure influenced a later empire",
          },
          { label: "19", text: "Has directed archaeological work at a site for over 25 years" },
          {
            label: "20",
            text: "Suggests that trade and religion were more important than warfare",
          },
        ],
        entities: ["A. Dr. Patricia Hernández", "B. Professor Ruth Shady Solís"],
        answers: {
          "18": "A. Dr. Patricia Hernández",
          "19": "B. Professor Ruth Shady Solís",
          "20": "B. Professor Ruth Shady Solís",
        },
      } as MatchingFeaturesQuestion,
    },
    {
      title: "Questions 21–23",
      instructions: "Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.",
      questionRange: "21-23",
      data: {
        id: "p2_ynng",
        type: "YES_NO_NOT_GIVEN",
        text: "",
        answer: "YES",
      } as YNNGQuestion,
    },
    {
      title: "Questions 24–27",
      instructions: "Complete the summary below. Choose NO MORE THAN TWO WORDS from the passage for each answer.",
      questionRange: "24-27",
      data: {
        id: "p2_sum",
        type: "SUMMARY_COMPLETION",
        wordLimit: 2,
        useWordBank: true,
        wordBank: [
          "raised fields",
          "frost protection",
          "terrace cultivation",
          "road network",
          "aquatic plants",
          "platform mounds",
          "DNA analysis",
          "isotope analysis",
        ],
        summaryText:
          "The Tiwanaku civilization developed {{gap1}} surrounded by water channels. These channels provided natural {{gap2}} and created a self-fertilizing system as {{gap3}} decomposed. Modern technology such as {{gap4}} has helped trace migration patterns of ancient peoples.",
        gaps: [
          { id: "gap1", answer: "raised fields" },
          { id: "gap2", answer: "frost protection" },
          { id: "gap3", answer: "aquatic plants" },
          { id: "gap4", answer: "DNA analysis" },
        ],
      } as SummaryCompletionQuestion,
    },
  ],
};

// ─── Passage 3: Workplace Motivation (Questions 28–40) ────────

const passage3: ReadingPassage = {
  id: 3,
  title: "The Psychology of Workplace Motivation",
  passage: `(A) Understanding what motivates employees has been a central concern of organizational psychology for over a century. From Frederick Taylor's scientific management approach in the early 1900s, which emphasized financial incentives and task optimization, to the more nuanced theories that dominate contemporary research, the field has undergone a remarkable transformation. Today, researchers broadly agree that human motivation in the workplace is far more complex than early theorists imagined.

(B) Abraham Maslow's hierarchy of needs, first proposed in 1943, suggested that human motivation operates on a pyramid structure, with basic physiological needs at the base and self-actualization at the apex. While influential, Maslow's theory has been criticized for its rigid hierarchical structure, which implies that higher-level needs cannot be pursued until lower-level ones are satisfied. Research has shown that individuals frequently pursue multiple levels of needs simultaneously, and the relative importance of different needs varies significantly across cultures.

(C) Frederick Herzberg's two-factor theory offered a different perspective by distinguishing between "hygiene factors" and "motivators." Hygiene factors — such as salary, working conditions, and job security — do not actively motivate employees but can cause dissatisfaction if inadequate. True motivators, according to Herzberg, include achievement, recognition, the work itself, responsibility, and opportunities for growth. This distinction has had a lasting impact on how organizations design jobs and reward systems.

(D) More recently, Self-Determination Theory (SDT), developed by Edward Deci and Richard Ryan, has emerged as one of the most influential frameworks in motivational psychology. SDT posits that intrinsic motivation — the drive to engage in activities because they are inherently interesting or enjoyable — is sustained by the satisfaction of three basic psychological needs: autonomy (the need to feel in control of one's behaviour), competence (the need to feel effective), and relatedness (the need to feel connected to others). When these needs are met, individuals experience greater well-being and higher quality motivation.

(E) The implications of SDT for workplace management are profound. Research has consistently shown that autonomy-supportive management styles — those that provide choice, acknowledge feelings, and offer meaningful rationales for tasks — lead to higher employee engagement, greater creativity, and lower turnover. Conversely, controlling management styles that rely heavily on external rewards, deadlines, and surveillance tend to undermine intrinsic motivation and can lead to burnout and disengagement.

(F) The rise of remote and hybrid work arrangements has introduced new challenges and opportunities for employee motivation. Studies conducted since 2020 indicate that many workers report higher levels of autonomy and productivity when working remotely, but also experience decreased feelings of relatedness and belonging. Organizations are now experimenting with various strategies to maintain social connection and team cohesion in distributed work environments, including virtual team-building activities, regular check-ins, and redesigned office spaces that prioritize collaboration over individual workstations.

(G) Looking ahead, artificial intelligence and automation are poised to reshape the motivational landscape of work fundamentally. As routine tasks become increasingly automated, the nature of human work will shift toward activities requiring creativity, emotional intelligence, and complex problem-solving — precisely the types of tasks that are most likely to satisfy the need for competence and provide intrinsic satisfaction. However, this transition also raises concerns about job displacement and the psychological impact of uncertainty on worker motivation and well-being.`,
  paragraphLabels: ["A", "B", "C", "D", "E", "F", "G"],
  sections: [
    {
      title: "Questions 28–30",
      instructions: "Choose the correct letter, A, B, C or D.",
      questionRange: "28-30",
      data: {
        id: "p3_mc",
        type: "MULTIPLE_CHOICE",
        text: "",
        options: [],
        answer: "",
      } as MCQuestion,
    },
    {
      title: "Questions 31–33",
      instructions: "Complete each sentence with the correct ending, A–F, from the box below.",
      questionRange: "31-33",
      data: {
        id: "p3_mse",
        type: "MATCHING_SENTENCE_ENDINGS",
        stems: [
          { label: "31", text: "According to Herzberg, hygiene factors" },
          { label: "32", text: "Autonomy-supportive management styles" },
          { label: "33", text: "Remote work arrangements" },
        ],
        endings: [
          { label: "A", text: "lead to higher creativity and lower turnover." },
          { label: "B", text: "can cause dissatisfaction but do not actively motivate." },
          { label: "C", text: "have increased feelings of autonomy for many workers." },
          { label: "D", text: "will eliminate the need for human workers entirely." },
          { label: "E", text: "are based on a rigid pyramid structure." },
          { label: "F", text: "rely on financial incentives alone." },
        ],
        answers: { "31": "B", "32": "A", "33": "C" },
      } as MatchingSentenceEndingsQuestion,
    },
    {
      title: "Questions 34–36",
      instructions: "Complete the notes below. Choose NO MORE THAN TWO WORDS from the passage for each answer.",
      questionRange: "34-36",
      data: {
        id: "p3_nc",
        type: "NOTE_COMPLETION",
        wordLimit: 2,
        notes: [
          {
            label: "34",
            text: "SDT identifies three basic psychological needs: autonomy, competence, and {{gap}}",
            gap: "p3gap34",
            answer: "relatedness",
          },
          {
            label: "35",
            text: "Controlling management relies on external rewards, deadlines, and {{gap}}",
            gap: "p3gap35",
            answer: "surveillance",
          },
          {
            label: "36",
            text: "Organizations are redesigning office spaces to prioritize {{gap}} over individual work",
            gap: "p3gap36",
            answer: "collaboration",
          },
        ],
      } as NoteCompletionQuestion,
    },
    {
      title: "Questions 37–38",
      instructions: "Complete the table below. Choose NO MORE THAN TWO WORDS from the passage for each answer.",
      questionRange: "37-38",
      data: {
        id: "p3_tc",
        type: "TABLE_COMPLETION",
        wordLimit: 2,
        headers: ["Theorist / Theory", "Key Concept", "Criticism or Limitation"],
        rows: [
          {
            cells: ["Maslow", "Hierarchy of needs", { gap: "p3gap37", answer: "rigid hierarchical" }],
          },
          {
            cells: ["Herzberg", { gap: "p3gap38", answer: "two-factor" }, "Oversimplifies motivation"],
          },
        ],
      } as TableCompletionQuestion,
    },
    {
      title: "Questions 39–40",
      instructions: "Complete the flow chart below. Choose NO MORE THAN TWO WORDS from the passage for each answer.",
      questionRange: "39-40",
      data: {
        id: "p3_fc",
        type: "FLOWCHART_COMPLETION",
        wordLimit: 2,
        steps: [
          { text: "Routine tasks become automated" },
          {
            text: "Human work shifts toward {{gap}} and complex problem-solving",
            gap: "p3gap39",
            answer: "creativity",
          },
          {
            text: "Tasks provide greater {{gap}} satisfaction",
            gap: "p3gap40",
            answer: "intrinsic",
          },
        ],
      } as FlowchartCompletionQuestion,
    },
  ],
};

// ─── Exported multi-passage test ──────────────────

export const multiPassageReadingTest: MultiPassageReadingTest = {
  id: "R-Academic-101",
  format: "Academic",
  timer: 3600,
  passages: [passage1, passage2, passage3],
};

// ─── Keep backward compatibility ──────────────────

export const comprehensiveReadingTest: ReadingTest = {
  title: passage1.title,
  passage: passage1.passage,
  paragraphLabels: passage1.paragraphLabels,
  sections: passage1.sections,
};

// Flatten question arrays for backward-compatible renderers
export const tfngQuestions = [
  {
    id: "q1",
    label: "1",
    text: "Rising temperatures always lead to decreased crop yields.",
    answer: "FALSE" as const,
  },
  {
    id: "q2",
    label: "2",
    text: "The IPCC projects food production could decline by up to 25% by century's end.",
    answer: "TRUE" as const,
  },
  {
    id: "q3",
    label: "3",
    text: "Organic farming has been proven more effective than conventional methods in combating climate change.",
    answer: "NOT GIVEN" as const,
  },
];

export const mcQuestions = [
  {
    id: "q4",
    label: "4",
    text: "What effect has moderate warming had in temperate regions?",
    options: [
      "A. Decreased growing seasons",
      "B. Longer growing seasons and increased productivity",
      "C. No significant change",
      "D. Complete crop failure",
    ],
    answer: "B. Longer growing seasons and increased productivity",
  },
  {
    id: "q5",
    label: "5",
    text: "Which of the following is NOT mentioned as an adaptation strategy?",
    options: [
      "A. Drought-resistant crop varieties",
      "B. Improved irrigation efficiency",
      "C. Genetic modification of livestock",
      "D. Conservation agriculture practices",
    ],
    answer: "C. Genetic modification of livestock",
    multiSelect: false,
  },
];

export const ynngQuestions = [
  {
    id: "q6",
    label: "6",
    text: "The author believes adaptation strategies alone will be sufficient to address the crisis.",
    answer: "NO" as const,
  },
  {
    id: "q7",
    label: "7",
    text: "Reducing agricultural emissions is important alongside adaptation efforts.",
    answer: "YES" as const,
  },
  {
    id: "q8",
    label: "8",
    text: "The author suggests that developing countries will be more affected than developed nations.",
    answer: "NOT GIVEN" as const,
  },
];

// Passage 2 standalone questions for renderers
export const p2YnngQuestions = [
  {
    id: "p2q21",
    label: "21",
    text: "The Tiwanaku civilization pre-dated the Inca Empire.",
    answer: "YES" as const,
  },
  {
    id: "p2q22",
    label: "22",
    text: "Caral's society was organized primarily around military power.",
    answer: "NO" as const,
  },
  {
    id: "p2q23",
    label: "23",
    text: "Lidar technology was first developed specifically for archaeological purposes.",
    answer: "NOT GIVEN" as const,
  },
];

// Passage 3 standalone MC questions for renderers
export const p3McQuestions = [
  {
    id: "p3q28",
    label: "28",
    text: "According to the passage, what was Frederick Taylor's main approach to motivation?",
    options: [
      "A. Emotional intelligence training",
      "B. Financial incentives and task optimization",
      "C. Team-building activities",
      "D. Self-actualization programs",
    ],
    answer: "B. Financial incentives and task optimization",
  },
  {
    id: "p3q29",
    label: "29",
    text: "What criticism has been made of Maslow's theory?",
    options: [
      "A. It ignores financial factors entirely",
      "B. It is too rigid and hierarchical in structure",
      "C. It was never tested empirically",
      "D. It only applies to Western cultures",
    ],
    answer: "B. It is too rigid and hierarchical in structure",
  },
  {
    id: "p3q30",
    label: "30",
    text: "According to Self-Determination Theory, intrinsic motivation requires",
    options: [
      "A. high salaries and bonuses",
      "B. strict deadlines and surveillance",
      "C. autonomy, competence, and relatedness",
      "D. physical comfort and job security",
    ],
    answer: "C. autonomy, competence, and relatedness",
  },
];

export function calculateReadingBandScore(correct: number, total: number): number {
  const pct = correct / total;
  if (pct >= 0.975) return 9;
  if (pct >= 0.925) return 8.5;
  if (pct >= 0.85) return 8;
  if (pct >= 0.8) return 7.5;
  if (pct >= 0.725) return 7;
  if (pct >= 0.65) return 6.5;
  if (pct >= 0.575) return 6;
  if (pct >= 0.5) return 5.5;
  if (pct >= 0.4) return 5;
  if (pct >= 0.325) return 4.5;
  if (pct >= 0.25) return 4;
  if (pct >= 0.175) return 3.5;
  if (pct >= 0.1) return 3;
  return 2.5;
}
