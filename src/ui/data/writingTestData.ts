export interface WritingTask {
  id: number;
  title: string;
  minWords: number;
  suggestedTime: string;
  prompt: string;
  context: string;
  imageUrl?: string;
  initialValue: string;
}

export interface WritingTest {
  id: string;
  type: "Academic" | "General";
  totalTime: number;
  tasks: [WritingTask, WritingTask];
}

export const academicWritingTest: WritingTest = {
  id: "W-Academic-101",
  type: "Academic",
  totalTime: 3600,
  tasks: [
    {
      id: 1,
      title: "Writing Task 1",
      minWords: 150,
      suggestedTime: "20 mins",
      prompt:
        "The chart below shows the percentage of the population living in urban areas in four different countries between 1980 and 2020.\n\nSummarise the information by selecting and reporting the main features, and make comparisons where relevant.",
      context: "Write at least 150 words. You should spend about 20 minutes on this task.",
      imageUrl: "/placeholder.svg",
      initialValue: "",
    },
    {
      id: 2,
      title: "Writing Task 2",
      minWords: 250,
      suggestedTime: "40 mins",
      prompt:
        "Some people believe that the increasing use of computers and mobile phones for communication has had a negative effect on young people's reading and writing skills.\n\nTo what extent do you agree or disagree?",
      context:
        "Give reasons for your answer and include any relevant examples from your own knowledge or experience. Write at least 250 words.",
      initialValue: "",
    },
  ],
};

export const generalWritingTest: WritingTest = {
  id: "W-General-101",
  type: "General",
  totalTime: 3600,
  tasks: [
    {
      id: 1,
      title: "Writing Task 1",
      minWords: 150,
      suggestedTime: "20 mins",
      prompt:
        "You have a problem with the apartment you are renting. Write a letter to your landlord.\n\nIn your letter:\n• describe the problem\n• explain how it is affecting you\n• suggest what should be done about it",
      context:
        "Write at least 150 words. You do NOT need to write any addresses. Begin your letter as follows: Dear Sir or Madam,",
      initialValue: "",
    },
    {
      id: 2,
      title: "Writing Task 2",
      minWords: 250,
      suggestedTime: "40 mins",
      prompt:
        "Individuals can do nothing to improve the environment; only governments and large companies can make a difference.\n\nTo what extent do you agree or disagree with this opinion?",
      context:
        "Give reasons for your answer and include any relevant examples from your own knowledge or experience. Write at least 250 words.",
      initialValue: "",
    },
  ],
};
