import { supabase } from "@/integrations/supabase/client";

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

/**
 * Persist a completed writing test session to user_test_sessions.
 * Writing is subjectively graded, so score_band is null (pending review).
 */
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

/**
 * Fetch a published writing test with its tasks for the student practice engine.
 */
export async function fetchWritingTestForPractice(
  testId: string
): Promise<WritingTestPayload> {
  const { data: test, error: testError } = await supabase
    .from("writing_tests")
    .select("id, title, status")
    .eq("id", testId)
    .single();

  if (testError || !test) {
    throw new Error(testError?.message || "Writing test not found");
  }

  const { data: tasks, error: tasksError } = await supabase
    .from("writing_tasks")
    .select("*")
    .eq("test_id", testId)
    .order("task_number");

  if (tasksError) {
    throw new Error(tasksError.message || "Failed to load writing tasks");
  }

  return {
    id: test.id,
    title: test.title,
    tasks: (tasks || []).map((t) => ({
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
