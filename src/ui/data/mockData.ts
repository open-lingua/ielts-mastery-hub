export const mockUser = {
  name: "Sarah Chen",
  email: "sarah@example.com",
  isPremium: false,
  streak: 3,
  avatar: "",
  recentScores: [
    { date: "Jan 5", score: 5.5 },
    { date: "Jan 12", score: 6.0 },
    { date: "Jan 19", score: 6.0 },
    { date: "Jan 26", score: 6.5 },
    { date: "Feb 2", score: 6.5 },
    { date: "Feb 9", score: 7.0 },
  ],
  recentActivity: [
    { id: 1, type: "Writing", title: "Technology in Education", score: 6.5, date: "Feb 9, 2026" },
    { id: 2, type: "Reading", title: "Climate Change Passage", score: 7.0, date: "Feb 8, 2026" },
    { id: 3, type: "Listening", title: "University Lecture", score: 6.5, date: "Feb 7, 2026" },
  ],
};

export const ieltsModules = [
  {
    title: "Listening",
    description: "40 minutes, 4 sections, 40 questions. Tests your ability to understand spoken English in academic and everyday contexts.",
    icon: "Headphones",
    duration: "40 min",
  },
  {
    title: "Reading",
    description: "60 minutes, 3 passages, 40 questions. Assesses reading skills including skimming, scanning, and detailed comprehension.",
    icon: "BookOpen",
    duration: "60 min",
  },
  {
    title: "Writing",
    description: "60 minutes, 2 tasks. Task 1: describe visual data (150+ words). Task 2: write an essay (250+ words).",
    icon: "PenTool",
    duration: "60 min",
  },
  {
    title: "Speaking",
    description: "11–14 minutes, 3 parts. A face-to-face interview assessing fluency, vocabulary, grammar, and pronunciation.",
    icon: "Mic",
    duration: "14 min",
  },
];

export const writingTasks = [
  {
    id: 1,
    type: "Task 2" as const,
    category: "Academic",
    title: "Technology in Education",
    question:
      "Some people believe that the increasing use of computers and mobile phones for communication has had a negative effect on young people's reading and writing skills.\n\nTo what extent do you agree or disagree?",
    context: "Give reasons for your answer and include any relevant examples from your own knowledge or experience.",
    minWords: 250,
    timeMinutes: 40,
  },
  {
    id: 2,
    type: "Task 2" as const,
    category: "Academic",
    title: "Environmental Responsibility",
    question:
      "Individuals can do nothing to improve the environment; only governments and large companies can make a difference.\n\nTo what extent do you agree or disagree with this opinion?",
    context: "Give reasons for your answer and include any relevant examples from your own knowledge or experience.",
    minWords: 250,
    timeMinutes: 40,
  },
  {
    id: 3,
    type: "Task 1" as const,
    category: "Academic",
    title: "Urban Population Growth",
    question:
      "The chart below shows the percentage of the population living in urban areas in four different countries between 1980 and 2020.",
    context: "Summarise the information by selecting and reporting the main features, and make comparisons where relevant.",
    minWords: 150,
    timeMinutes: 20,
  },
  {
    id: 4,
    type: "Task 1" as const,
    category: "General",
    title: "Letter to Landlord",
    question:
      "You have a problem with the apartment you are renting. Write a letter to your landlord. In your letter:\n\n• describe the problem\n• explain how it is affecting you\n• suggest what should be done about it",
    context: "Write at least 150 words. You do NOT need to write any addresses. Begin your letter as follows: Dear Sir or Madam,",
    minWords: 150,
    timeMinutes: 20,
  },
];

export const readingPassage = {
  title: "The Impact of Climate Change on Global Agriculture",
  text: `Climate change is increasingly recognized as one of the most significant threats to global food security. As temperatures rise, precipitation patterns shift, and extreme weather events become more frequent, agricultural systems worldwide are being forced to adapt to new conditions.

Research conducted over the past two decades has demonstrated that rising temperatures can have both positive and negative effects on crop yields, depending on the region and the crop in question. In temperate regions, moderate warming has been associated with longer growing seasons and, in some cases, increased productivity for certain crops. However, in tropical and subtropical regions, where temperatures are already near the upper limits for many crop species, even small increases can lead to significant yield reductions.

Water availability is another critical factor affected by climate change. Changes in rainfall patterns and the melting of glaciers are altering water supplies in many agricultural regions. Some areas are experiencing increased drought frequency, while others face greater risks of flooding. Both extremes pose challenges for crop production and livestock management.

The Intergovernmental Panel on Climate Change (IPCC) has projected that global food production could decline by up to 25 percent by the end of this century if current trends continue. This projection takes into account not only the direct effects of temperature and precipitation changes but also the indirect impacts of increased pest pressure, soil degradation, and the loss of pollinators.

Adaptation strategies are being developed and implemented around the world. These include the development of drought-resistant crop varieties, improvements in irrigation efficiency, changes in planting schedules, and the adoption of conservation agriculture practices. However, the effectiveness of these measures will depend on the rate and magnitude of climate change, as well as the availability of resources to support adaptation efforts.

In addition to adaptation, mitigation efforts aimed at reducing greenhouse gas emissions from agricultural activities are also important. Agriculture is responsible for approximately 10-12 percent of global greenhouse gas emissions, primarily through livestock production, rice cultivation, and the use of synthetic fertilizers. Reducing these emissions while maintaining food production levels presents a significant challenge for policymakers and farmers alike.`,
  questions: [
    {
      id: 1,
      type: "tf" as const,
      text: "Rising temperatures always lead to decreased crop yields.",
      answer: "false",
    },
    {
      id: 2,
      type: "tf" as const,
      text: "The IPCC projects food production could decline by up to 25% by century's end.",
      answer: "true",
    },
    {
      id: 3,
      type: "tf" as const,
      text: "Agriculture accounts for approximately 30% of global greenhouse gas emissions.",
      answer: "false",
    },
    {
      id: 4,
      type: "mcq" as const,
      text: "What effect has moderate warming had in temperate regions?",
      options: [
        "Decreased growing seasons",
        "Longer growing seasons and increased productivity",
        "No significant change",
        "Complete crop failure",
      ],
      answer: "Longer growing seasons and increased productivity",
    },
    {
      id: 5,
      type: "mcq" as const,
      text: "Which of the following is NOT mentioned as an adaptation strategy?",
      options: [
        "Drought-resistant crop varieties",
        "Improved irrigation efficiency",
        "Genetic modification of livestock",
        "Conservation agriculture practices",
      ],
      answer: "Genetic modification of livestock",
    },
  ],
};

export const listeningQuestions = [
  {
    id: 1,
    section: "Section 1",
    title: "Student Accommodation Inquiry",
    questions: [
      { id: 1, text: "The student is looking for accommodation near the ___.", answer: "university campus", type: "fill" as const },
      { id: 2, text: "The maximum budget per month is ___.", answer: "£800", type: "fill" as const },
      {
        id: 3,
        text: "Which facility is most important to the student?",
        options: ["Gym", "Library", "Laundry room", "Parking"],
        answer: "Laundry room",
        type: "mcq" as const,
      },
    ],
  },
  {
    id: 2,
    section: "Section 2",
    title: "University Orientation Talk",
    questions: [
      {
        id: 4,
        text: "The library is open until ___ on weekdays.",
        answer: "10 PM",
        type: "fill" as const,
      },
      {
        id: 5,
        text: "Students can borrow up to ___ books at a time.",
        answer: "8",
        type: "fill" as const,
      },
    ],
  },
];

export const ieltsInfo = [
  "IELTS is accepted by over 11,000 organisations worldwide.",
  "The test uses a 9-band scoring system for each module.",
  "Academic IELTS is for university admissions; General Training is for work and immigration.",
  "Each band score represents a different level of English proficiency.",
  "Band 7 is considered 'good user' — can handle complex language well.",
  "The Speaking test is a face-to-face interview with an examiner.",
];
