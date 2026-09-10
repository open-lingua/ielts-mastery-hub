import { getAnonId } from "@/lib/anonId";
import { type GradingResult, gradeWriting, updateUserTestSession } from "@/lib/tauri";

export type { GradingResult as WritingGradingResult };

export async function evaluateWriting(
  taskType: "task1" | "task2",
  promptText: string,
  userResponse: string
): Promise<GradingResult> {
  const userId = getAnonId();

  return gradeWriting({
    user_id: userId,
    task_type: taskType,
    prompt: promptText,
    user_response: userResponse,
  });
}

export async function gradeWritingTest(
  tasks: Array<{ taskType: "task1" | "task2"; prompt: string; userResponse: string }>
): Promise<{
  task1: GradingResult;
  task2: GradingResult;
  overallBand: number;
}> {
  const [result1, result2] = await Promise.all(tasks.map((t) => evaluateWriting(t.taskType, t.prompt, t.userResponse)));

  // Task 2 carries more weight (2/3) in official IELTS
  const overallBand = Math.round(((result1.overallBand * 1 + result2.overallBand * 2) / 3) * 2) / 2;

  return { task1: result1, task2: result2, overallBand };
}

export async function persistFeedback(
  sessionId: string,
  overallBand: number,
  feedbackData: Record<string, unknown>
): Promise<void> {
  const userId = getAnonId();
  await updateUserTestSession(sessionId, userId, {
    score_band: overallBand,
    feedback_data: JSON.stringify(feedbackData),
  });
}
