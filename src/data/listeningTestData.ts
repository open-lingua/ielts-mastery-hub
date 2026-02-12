export type ListeningQuestionType = "fill" | "mcq" | "matching" | "map_label";

export interface ListeningQuestion {
  id: string;
  type: ListeningQuestionType;
  text: string;
  answer: string;
  options?: string[];
  matchOptions?: { left: string; right: string[] };
  wordLimit?: number;
}

export interface ListeningSection {
  id: number;
  title: string;
  subtitle: string;
  context: string;
  instructions: string;
  questions: ListeningQuestion[];
}

export interface ListeningTest {
  id: string;
  title: string;
  totalTime: number;
  sections: ListeningSection[];
}

export const mockListeningTest: ListeningTest = {
  id: "L-101",
  title: "IELTS Listening Practice Test 1",
  totalTime: 2400,
  sections: [
    {
      id: 1,
      title: "Section 1: Library Registration",
      subtitle: "A conversation between a student and a library assistant",
      context: "Social / Everyday",
      instructions: "Complete the notes below. Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer.",
      questions: [
        { id: "s1q1", type: "fill", text: "Student's surname: ___", answer: "Blackwell", wordLimit: 2 },
        { id: "s1q2", type: "fill", text: "Student ID number: ___", answer: "HS7742", wordLimit: 2 },
        { id: "s1q3", type: "fill", text: "Department: School of ___", answer: "Engineering", wordLimit: 2 },
        { id: "s1q4", type: "fill", text: "Type of accommodation: ___", answer: "shared flat", wordLimit: 2 },
        { id: "s1q5", type: "fill", text: "Maximum loan period for reference books: ___ days", answer: "3", wordLimit: 1 },
        {
          id: "s1q6",
          type: "mcq",
          text: "Which additional service does the student sign up for?",
          options: ["Online journal access", "Interlibrary loan", "Printing credit", "Study room booking"],
          answer: "Interlibrary loan",
        },
        {
          id: "s1q7",
          type: "mcq",
          text: "The library closes at what time on Saturdays?",
          options: ["4 PM", "5 PM", "6 PM", "8 PM"],
          answer: "5 PM",
        },
        { id: "s1q8", type: "fill", text: "The fine for overdue books is ___ per day.", answer: "£0.50", wordLimit: 1 },
        { id: "s1q9", type: "fill", text: "The student's email address is: ___@unimail.ac.uk", answer: "j.blackwell", wordLimit: 2 },
        { id: "s1q10", type: "fill", text: "The library card will be ready by ___.", answer: "Friday", wordLimit: 1 },
      ],
    },
    {
      id: 2,
      title: "Section 2: City Cycling Tour",
      subtitle: "A monologue giving information about a local cycling tour service",
      context: "Social / Monologue",
      instructions: "Choose the correct letter, A, B, or C.",
      questions: [
        {
          id: "s2q1",
          type: "mcq",
          text: "The cycling tours run from",
          options: ["March to September", "April to October", "May to November"],
          answer: "April to October",
        },
        {
          id: "s2q2",
          type: "mcq",
          text: "The maximum group size is",
          options: ["10 people", "12 people", "15 people"],
          answer: "12 people",
        },
        {
          id: "s2q3",
          type: "mcq",
          text: "What is included in the tour price?",
          options: ["Lunch and snacks", "Helmet and water bottle", "A souvenir map"],
          answer: "Helmet and water bottle",
        },
        {
          id: "s2q4",
          type: "mcq",
          text: "The Historical Route passes through",
          options: ["the cathedral quarter", "the financial district", "the harbour area"],
          answer: "the cathedral quarter",
        },
        {
          id: "s2q5",
          type: "mcq",
          text: "Children under 12 must be",
          options: ["accompanied by an adult", "at least 140cm tall", "able to ride without stabilisers"],
          answer: "accompanied by an adult",
        },
        {
          id: "s2q6",
          type: "matching",
          text: "Match each tour type with its main feature:",
          answer: "A-Riverside path,B-Castle grounds,C-Street art murals",
          matchOptions: {
            left: "Nature Tour → ___, Heritage Tour → ___, Urban Tour → ___",
            right: ["Riverside path", "Castle grounds", "Street art murals", "Shopping district"],
          },
        },
        {
          id: "s2q7",
          type: "mcq",
          text: "Bookings can be made by",
          options: ["phone or website only", "email or in person only", "phone, website, or in person"],
          answer: "phone, website, or in person",
        },
        {
          id: "s2q8",
          type: "fill",
          text: "The meeting point for all tours is outside the ___ .",
          answer: "train station",
          wordLimit: 2,
        },
        {
          id: "s2q9",
          type: "fill",
          text: "Tours begin promptly at ___ AM.",
          answer: "9:30",
          wordLimit: 1,
        },
        {
          id: "s2q10",
          type: "mcq",
          text: "What happens if it rains on the day of the tour?",
          options: ["The tour is cancelled", "Customers receive a full refund", "The tour is rescheduled free of charge"],
          answer: "The tour is rescheduled free of charge",
        },
      ],
    },
    {
      id: 3,
      title: "Section 3: Research Project Discussion",
      subtitle: "A discussion between two students and their tutor about a group project",
      context: "Educational / Discussion",
      instructions: "Answer the questions below.",
      questions: [
        {
          id: "s3q1",
          type: "mcq",
          text: "The students' project focuses on",
          options: ["renewable energy in cities", "water conservation methods", "urban food production"],
          answer: "urban food production",
        },
        {
          id: "s3q2",
          type: "mcq",
          text: "What does the tutor criticise about their initial proposal?",
          options: ["It lacked a clear hypothesis", "The scope was too broad", "The methodology was outdated"],
          answer: "The scope was too broad",
        },
        {
          id: "s3q3",
          type: "fill",
          text: "The students will narrow their focus to ___ gardens.",
          answer: "community",
          wordLimit: 1,
        },
        {
          id: "s3q4",
          type: "mcq",
          text: "Sarah suggests collecting data primarily through",
          options: ["online surveys", "face-to-face interviews", "published statistics"],
          answer: "face-to-face interviews",
        },
        {
          id: "s3q5",
          type: "mcq",
          text: "The tutor recommends they also include",
          options: ["photographic evidence", "soil sample analysis", "a comparison with a rural area"],
          answer: "a comparison with a rural area",
        },
        {
          id: "s3q6",
          type: "fill",
          text: "The deadline for the first draft is ___.",
          answer: "15th March",
          wordLimit: 2,
        },
        {
          id: "s3q7",
          type: "matching",
          text: "Match each student with their assigned task:",
          answer: "Sarah-Literature review,Tom-Data collection,Both-Final presentation",
          matchOptions: {
            left: "Sarah → ___, Tom → ___, Both → ___",
            right: ["Literature review", "Data collection", "Final presentation", "Budget planning"],
          },
        },
        {
          id: "s3q8",
          type: "mcq",
          text: "How long should the final report be?",
          options: ["3,000 words", "4,000 words", "5,000 words"],
          answer: "4,000 words",
        },
        {
          id: "s3q9",
          type: "fill",
          text: "The presentation will be held in Room ___.",
          answer: "214B",
          wordLimit: 1,
        },
        {
          id: "s3q10",
          type: "mcq",
          text: "The weighting of the project in their final grade is",
          options: ["20%", "30%", "40%"],
          answer: "30%",
        },
      ],
    },
    {
      id: 4,
      title: "Section 4: The Psychology of Decision-Making",
      subtitle: "An academic lecture on cognitive biases in everyday decisions",
      context: "Academic / Lecture",
      instructions: "Complete the summary below. Write NO MORE THAN TWO WORDS for each answer.",
      questions: [
        { id: "s4q1", type: "fill", text: "The lecture defines cognitive bias as a systematic pattern of ___ from rationality.", answer: "deviation", wordLimit: 2 },
        { id: "s4q2", type: "fill", text: "The 'anchoring effect' causes people to rely too heavily on the first piece of ___ they receive.", answer: "information", wordLimit: 2 },
        {
          id: "s4q3",
          type: "mcq",
          text: "According to the lecturer, the 'availability heuristic' is most influenced by",
          options: ["statistical data", "recent or vivid memories", "expert opinions"],
          answer: "recent or vivid memories",
        },
        { id: "s4q4", type: "fill", text: "Confirmation bias leads people to seek evidence that ___ their existing beliefs.", answer: "supports", wordLimit: 2 },
        { id: "s4q5", type: "fill", text: "The 'sunk cost fallacy' makes people continue investing in a project because of ___ spent.", answer: "resources already", wordLimit: 2 },
        {
          id: "s4q6",
          type: "mcq",
          text: "The lecturer argues that 'framing effects' are most commonly exploited in",
          options: ["academic research", "advertising and marketing", "government legislation"],
          answer: "advertising and marketing",
        },
        { id: "s4q7", type: "fill", text: "Studies show that people make approximately ___ decisions per day.", answer: "35,000", wordLimit: 1 },
        {
          id: "s4q8",
          type: "mcq",
          text: "The recommended strategy for reducing bias in important decisions is",
          options: ["relying on intuition", "using a structured checklist", "consulting a single expert"],
          answer: "using a structured checklist",
        },
        { id: "s4q9", type: "fill", text: "The concept of 'bounded rationality' was introduced by Herbert ___.", answer: "Simon", wordLimit: 1 },
        { id: "s4q10", type: "fill", text: "The lecture concludes that awareness of biases can improve decision ___ significantly.", answer: "quality", wordLimit: 2 },
      ],
    },
  ],
};

export function calculateBandScore(correct: number, total: number): number {
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
