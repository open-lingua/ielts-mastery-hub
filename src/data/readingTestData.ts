// Comprehensive IELTS Reading Test with all 13 question types

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
  answers: Record<string, string>; // paragraph -> heading numeral
}

export interface MatchingInformationQuestion {
  id: string;
  type: "MATCHING_INFORMATION";
  statements: { label: string; text: string }[];
  paragraphs: string[];
  answers: Record<string, string>; // label -> paragraph
}

export interface MatchingFeaturesQuestion {
  id: string;
  type: "MATCHING_FEATURES";
  features: { label: string; text: string }[];
  entities: string[];
  answers: Record<string, string>; // label -> entity
}

export interface MatchingSentenceEndingsQuestion {
  id: string;
  type: "MATCHING_SENTENCE_ENDINGS";
  stems: { label: string; text: string }[];
  endings: { label: string; text: string }[];
  answers: Record<string, string>; // stem label -> ending label
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
  summaryText: string; // uses {{gapN}} markers
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

export interface ReadingTest {
  title: string;
  passage: string;
  paragraphLabels?: string[];
  sections: {
    title: string;
    instructions: string;
    questionRange: string;
    data: QuestionSection;
  }[];
}

export const comprehensiveReadingTest: ReadingTest = {
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
      instructions: "Do the following statements agree with the information given in the Reading Passage? Write TRUE, FALSE, or NOT GIVEN.",
      questionRange: "1-3",
      data: {
        id: "tfng_1",
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
        id: "mc_1",
        type: "MULTIPLE_CHOICE",
        text: "",
        options: [],
        answer: "",
      } as MCQuestion,
    },
    {
      title: "Questions 6–8",
      instructions: "Do the following statements agree with the claims of the writer? Write YES, NO, or NOT GIVEN.",
      questionRange: "6-8",
      data: {
        id: "ynng_1",
        type: "YES_NO_NOT_GIVEN",
        text: "",
        answer: "YES",
      } as YNNGQuestion,
    },
    {
      title: "Questions 9–12",
      instructions: "The reading passage has six paragraphs, A–F. Which paragraph contains the following information?",
      questionRange: "9-12",
      data: {
        id: "match_info_1",
        type: "MATCHING_INFORMATION",
        statements: [
          { label: "9", text: "A reference to the proportion of emissions caused by farming" },
          { label: "10", text: "An explanation of how water sources are changing" },
          { label: "11", text: "Examples of crops that benefit from warmer conditions" },
          { label: "12", text: "A prediction about future food output" },
        ],
        paragraphs: ["A", "B", "C", "D", "E", "F"],
        answers: { "9": "F", "10": "C", "11": "B", "12": "D" },
      } as MatchingInformationQuestion,
    },
    {
      title: "Questions 13–16",
      instructions: "Choose the correct heading for each paragraph from the list of headings below.",
      questionRange: "13-16",
      data: {
        id: "match_head_1",
        type: "MATCHING_HEADINGS",
        paragraphs: ["A", "B", "D", "F"],
        headings: [
          "i. The dual nature of temperature effects",
          "ii. Global efforts to cut farm emissions",
          "iii. The scope of the agricultural crisis",
          "iv. Water-related challenges",
          "v. Scientific predictions for the future",
          "vi. New crop varieties",
        ],
        answers: { "A": "iii", "B": "i", "D": "v", "F": "ii" },
      } as MatchingHeadingsQuestion,
    },
    {
      title: "Questions 17–19",
      instructions: "Look at the following statements and the list of researchers below. Match each statement with the correct researcher, A–C.",
      questionRange: "17-19",
      data: {
        id: "match_feat_1",
        type: "MATCHING_FEATURES",
        features: [
          { label: "17", text: "Has developed new types of grain that can survive dry conditions" },
          { label: "18", text: "Has described the research findings as urgently important" },
          { label: "19", text: "Has researched methods based on indigenous agricultural knowledge" },
        ],
        entities: ["A. Dr. Maria Santos", "B. Professor James Liu", "C. Dr. Amara Osei"],
        answers: { "17": "B. Professor James Liu", "18": "A. Dr. Maria Santos", "19": "C. Dr. Amara Osei" },
      } as MatchingFeaturesQuestion,
    },
    {
      title: "Questions 20–22",
      instructions: "Complete each sentence with the correct ending, A–F, from the box below.",
      questionRange: "20-22",
      data: {
        id: "match_sent_1",
        type: "MATCHING_SENTENCE_ENDINGS",
        stems: [
          { label: "20", text: "In tropical regions, small temperature increases" },
          { label: "21", text: "Changes in glacier melt patterns" },
          { label: "22", text: "Conservation agriculture practices" },
        ],
        endings: [
          { label: "A", text: "are altering water availability for farming." },
          { label: "B", text: "can cause major reductions in crop output." },
          { label: "C", text: "have been adopted as part of adaptation strategies." },
          { label: "D", text: "are primarily caused by livestock farming." },
          { label: "E", text: "have increased food production globally." },
          { label: "F", text: "benefit temperate region agriculture." },
        ],
        answers: { "20": "B", "21": "A", "22": "C" },
      } as MatchingSentenceEndingsQuestion,
    },
    {
      title: "Questions 23–25",
      instructions: "Complete the sentences below. Choose NO MORE THAN TWO WORDS from the passage for each answer.",
      questionRange: "23-25",
      data: {
        id: "sent_comp_1",
        type: "SENTENCE_COMPLETION",
        wordLimit: 2,
        sentences: [
          { label: "23", text: "In temperate regions, moderate warming has led to longer {{gap}}.", gap: "gap23", answer: "growing seasons" },
          { label: "24", text: "Some regions are facing a higher risk of {{gap}} due to changing rainfall.", gap: "gap24", answer: "flooding" },
          { label: "25", text: "Agriculture accounts for about 10-12 percent of global {{gap}}.", gap: "gap25", answer: "greenhouse gas" },
        ],
      } as SentenceCompletionQuestion,
    },
    {
      title: "Questions 26–29",
      instructions: "Complete the summary below. Choose NO MORE THAN TWO WORDS from the passage or from the box below for each answer.",
      questionRange: "26-29",
      data: {
        id: "sum_comp_1",
        type: "SUMMARY_COMPLETION",
        wordLimit: 2,
        useWordBank: true,
        wordBank: ["food security", "crop yields", "pest pressure", "soil degradation", "extreme weather", "pollinators", "synthetic fertilizers", "planting schedules"],
        summaryText: "Climate change poses a major threat to global {{gap1}}. The IPCC warns that indirect effects such as increased {{gap2}}, {{gap3}}, and loss of {{gap4}} will compound the direct impacts of temperature changes.",
        gaps: [
          { id: "gap1", answer: "food security" },
          { id: "gap2", answer: "pest pressure" },
          { id: "gap3", answer: "soil degradation" },
          { id: "gap4", answer: "pollinators" },
        ],
      } as SummaryCompletionQuestion,
    },
    {
      title: "Questions 30–32",
      instructions: "Complete the notes below. Choose NO MORE THAN THREE WORDS from the passage for each answer.",
      questionRange: "30-32",
      data: {
        id: "note_comp_1",
        type: "NOTE_COMPLETION",
        wordLimit: 3,
        notes: [
          { label: "30", text: "Main emission sources: livestock, rice cultivation, and {{gap}}", gap: "gap30", answer: "synthetic fertilizers" },
          { label: "31", text: "Challenge: reduce emissions while maintaining {{gap}}", gap: "gap31", answer: "food production levels" },
          { label: "32", text: "Adaptation effectiveness depends on rate and {{gap}} of change", gap: "gap32", answer: "magnitude" },
        ],
      } as NoteCompletionQuestion,
    },
    {
      title: "Questions 33–35",
      instructions: "Complete the table below. Choose NO MORE THAN TWO WORDS from the passage for each answer.",
      questionRange: "33-35",
      data: {
        id: "table_comp_1",
        type: "TABLE_COMPLETION",
        wordLimit: 2,
        headers: ["Region Type", "Temperature Effect", "Outcome"],
        rows: [
          { cells: ["Temperate", "Moderate warming", { gap: "gap33", answer: "increased productivity" }] },
          { cells: ["Tropical", { gap: "gap34", answer: "small increases" }, "Yield reductions"] },
          { cells: [{ gap: "gap35", answer: "subtropical" }, "Near upper limits", "Significant decline"] },
        ],
      } as TableCompletionQuestion,
    },
    {
      title: "Questions 36–38",
      instructions: "Complete the flow chart below. Choose NO MORE THAN TWO WORDS from the passage for each answer.",
      questionRange: "36-38",
      data: {
        id: "flow_comp_1",
        type: "FLOWCHART_COMPLETION",
        wordLimit: 2,
        steps: [
          { text: "Climate change causes temperatures to rise" },
          { text: "{{gap}} patterns shift", gap: "gap36", answer: "precipitation" },
          { text: "{{gap}} events become more frequent", gap: "gap37", answer: "extreme weather" },
          { text: "Agricultural systems forced to {{gap}}", gap: "gap38", answer: "adapt" },
        ],
      } as FlowchartCompletionQuestion,
    },
    {
      title: "Questions 39–40",
      instructions: "Answer the questions below. Choose NO MORE THAN THREE WORDS from the passage for each answer.",
      questionRange: "39-40",
      data: {
        id: "short_1",
        type: "SHORT_ANSWER",
        wordLimit: 3,
        questions: [
          { label: "39", text: "What technology has helped reduce the impact of water changes on farming?", answer: "irrigation technology", acceptedAnswers: ["irrigation technology", "irrigation"] },
          { label: "40", text: "What type of agriculture practices are being adopted as an adaptation strategy?", answer: "conservation agriculture", acceptedAnswers: ["conservation agriculture", "conservation agriculture practices"] },
        ],
      } as ShortAnswerQuestion,
    },
  ],
};

// Flatten to get individual TFNG questions
export const tfngQuestions = [
  { id: "q1", label: "1", text: "Rising temperatures always lead to decreased crop yields.", answer: "FALSE" as const },
  { id: "q2", label: "2", text: "The IPCC projects food production could decline by up to 25% by century's end.", answer: "TRUE" as const },
  { id: "q3", label: "3", text: "Organic farming has been proven more effective than conventional methods in combating climate change.", answer: "NOT GIVEN" as const },
];

export const mcQuestions = [
  {
    id: "q4", label: "4",
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
    id: "q5", label: "5",
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
  { id: "q6", label: "6", text: "The author believes adaptation strategies alone will be sufficient to address the crisis.", answer: "NO" as const },
  { id: "q7", label: "7", text: "Reducing agricultural emissions is important alongside adaptation efforts.", answer: "YES" as const },
  { id: "q8", label: "8", text: "The author suggests that developing countries will be more affected than developed nations.", answer: "NOT GIVEN" as const },
];
