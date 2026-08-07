import { supabase } from "@/integrations/supabase/client";

export interface WritingGradingResult {
  overallBand: number;
  criteria: {
    taskAchievement: number;
    coherenceCohesion: number;
    lexicalResource: number;
    grammaticalRange: number;
  };
  feedback: {
    strengths: string[];
    weaknesses: string[];
    improvements: string;
  };
}

export async function evaluateWriting(
  taskType: "task1" | "task2",
  promptText: string,
  userResponse: string
): Promise<WritingGradingResult> {
  const { data: sessionData } = await supabase.auth.getSession();
  const token = sessionData?.session?.access_token;

  if (!token) throw new Error("Not authenticated");

  const res = await supabase.functions.invoke("grade-writing", {
    body: { taskType, prompt: promptText, userResponse },
  });

  if (res.error) {
    throw new Error(res.error.message || "AI grading failed");
  }

  return res.data as WritingGradingResult;
}

/**
 * Grade both tasks and return combined results.
 */
export async function gradeWritingTest(
  tasks: Array<{ taskType: "task1" | "task2"; prompt: string; userResponse: string }>
): Promise<{
  task1: WritingGradingResult;
  task2: WritingGradingResult;
  overallBand: number;
}> {
  const [result1, result2] = await Promise.all(
    tasks.map((t) => evaluateWriting(t.taskType, t.prompt, t.userResponse))
  );

  // Task 2 carries more weight (2/3) in official IELTS
  const overallBand =
    Math.round(((result1.overallBand * 1 + result2.overallBand * 2) / 3) * 2) / 2;

  return { task1: result1, task2: result2, overallBand };
}

/**
 * Persist AI feedback to the session record.
 */
export async function persistFeedback(
  sessionId: string,
  overallBand: number,
  feedbackData: Record<string, unknown>
): Promise<void> {
  const { error } = await supabase
    .from("user_test_sessions")
    .update({
      score_band: overallBand,
      feedback_data: feedbackData as any,
    })
    .eq("id", sessionId);

  if (error) throw error;
}
