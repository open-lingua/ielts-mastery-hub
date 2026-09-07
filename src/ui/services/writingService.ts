import { getAnonId } from "@/lib/anonId";
import {
  createWritingTask,
  createWritingTest,
  deleteWritingTask,
  getWritingTest,
  listWritingTasks,
  updateWritingTest as tauriUpdateWritingTest,
  uploadWritingAsset,
} from "@/lib/tauri";

interface WritingTaskData {
  id?: string;
  taskType: "task1" | "task2";
  title: string;
  difficulty: string;
  suggestedTime: string;
  prompt: string;
  minWords: number;
  maxWords: string;
  imageFile?: File | null;
  imageUrl?: string;
  includeModelAnswer?: boolean;
  modelAnswer?: string;
}

interface SaveWritingTestParams {
  userId: string;
  title: string;
  status: "draft" | "published";
  tasks: WritingTaskData[];
}

interface UpdateWritingTestParams {
  testId: string;
  title: string;
  status: "draft" | "published";
  tasks: WritingTaskData[];
}

async function resolveTasks(tasks: WritingTaskData[]) {
  const resolved: Array<WritingTaskData & { id: string; resolvedImageUrl: string }> = [];
  for (const task of tasks) {
    const taskId = task.id || crypto.randomUUID();
    let resolvedImageUrl = task.imageUrl || "";
    if (task.imageFile) {
      resolvedImageUrl = await uploadWritingAsset(taskId, task.imageFile);
    }
    resolved.push({ ...task, id: taskId, resolvedImageUrl });
  }
  return resolved;
}

export async function saveWritingTest(params: SaveWritingTestParams): Promise<{ testId: string }> {
  const { userId, title, status, tasks } = params;
  const resolvedTasks = await resolveTasks(tasks);
  const testId = await createWritingTest(userId, { title, status });
  await Promise.all(
    resolvedTasks.map((t, idx) =>
      createWritingTask(userId, {
        id: t.id,
        test_id: testId,
        task_number: idx + 1,
        task_type: t.taskType,
        title: t.title,
        difficulty: t.difficulty,
        suggested_time: t.suggestedTime,
        prompt: t.prompt,
        min_words: t.minWords,
        max_words: t.maxWords,
        image_url: t.resolvedImageUrl,
        include_model_answer: t.includeModelAnswer || false,
        model_answer: t.modelAnswer || "",
      })
    )
  );
  return { testId };
}

export async function updateWritingTest(params: UpdateWritingTestParams): Promise<void> {
  const { testId, title, status, tasks } = params;
  const userId = getAnonId();
  const resolvedTasks = await resolveTasks(tasks);

  await tauriUpdateWritingTest(testId, userId, { title, status });

  const allTasks = (await listWritingTasks(userId)).filter((t) => t.test_id === testId);
  await Promise.all(allTasks.map((t) => deleteWritingTask(t.id, userId)));

  await Promise.all(
    resolvedTasks.map((t, idx) =>
      createWritingTask(userId, {
        id: t.id,
        test_id: testId,
        task_number: idx + 1,
        task_type: t.taskType,
        title: t.title,
        difficulty: t.difficulty,
        suggested_time: t.suggestedTime,
        prompt: t.prompt,
        min_words: t.minWords,
        max_words: t.maxWords,
        image_url: t.resolvedImageUrl,
        include_model_answer: t.includeModelAnswer || false,
        model_answer: t.modelAnswer || "",
      })
    )
  );
}

export async function fetchWritingTest(testId: string) {
  const userId = getAnonId();
  const [test, allTasks] = await Promise.all([getWritingTest(testId, userId), listWritingTasks(userId)]);
  if (!test) throw new Error("Writing test not found");

  const tasks = allTasks.filter((t) => t.test_id === testId).sort((a, b) => a.task_number - b.task_number);

  return {
    id: test.id,
    title: test.title,
    status: test.status,
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
