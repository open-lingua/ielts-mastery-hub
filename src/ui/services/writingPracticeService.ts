import { getWritingTest, listWritingTasks } from "@/lib/tauri";

export interface WritingTaskPayload {
  id: string;
  taskType: "task1" | "task2";
  title: string;
  difficulty: string;
  suggestedTime: string;
  prompt: string;
  minWords: number;
  maxWords: string;
  imageUrl: string;
  includeModelAnswer: boolean;
  modelAnswer: string;
}

export interface WritingTestPayload {
  id: string;
  title: string;
  tasks: [WritingTaskPayload, WritingTaskPayload] | WritingTaskPayload[];
}

export interface WritingAnswers {
  task1: string;
  task2: string;
  task1WordCount: number;
  task2WordCount: number;
}

export async function submitWritingTest(
  sessionId: string,
  answers: WritingAnswers
): Promise<void> {
  const { completeSession } = await import("./practiceLibraryService");
  await completeSession(sessionId, null, {
    task1: answers.task1,
    task2: answers.task2,
    task1WordCount: answers.task1WordCount,
    task2WordCount: answers.task2WordCount,
  });
}

export async function fetchWritingTestForPractice(testId: string): Promise<WritingTestPayload> {
  const { getAnonId } = await import("@/lib/anonId");
  const userId = getAnonId();

  const test = await getWritingTest(testId, userId);
  if (!test) throw new Error("Writing test not found");

  const allTasks = await listWritingTasks(userId);
  const tasks = allTasks
    .filter((t) => t.test_id === testId)
    .sort((a, b) => a.task_number - b.task_number);

  return {
    id: test.id,
    title: test.title,
    tasks: tasks.map((t) => ({
      id: t.id,
      taskType: t.task_type as "task1" | "task2",
      title: t.title,
      difficulty: t.difficulty,
      suggestedTime: t.suggested_time,
      prompt: t.prompt,
      minWords: t.min_words,
      maxWords: t.max_words || "",
      imageUrl: t.image_url || "",
      includeModelAnswer: t.include_model_answer,
      modelAnswer: t.model_answer || "",
    })),
  };
}
