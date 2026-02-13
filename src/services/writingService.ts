import { supabase } from "@/integrations/supabase/client";

interface WritingTaskData {
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

/**
 * Upload an image to the writing-assets storage bucket.
 */
export async function uploadWritingAsset(
  userId: string,
  file: File
): Promise<string> {
  const ext = file.name.split(".").pop() || "png";
  const filePath = `${userId}/${Date.now()}-${crypto.randomUUID()}.${ext}`;

  const { error } = await supabase.storage
    .from("writing-assets")
    .upload(filePath, file, { upsert: false });

  if (error) {
    throw new Error(`Image upload failed: ${error.message}`);
  }

  const { data: urlData } = supabase.storage
    .from("writing-assets")
    .getPublicUrl(filePath);

  return urlData.publicUrl;
}

/** Resolve image URLs for tasks (upload File objects). */
async function resolveTasks(userId: string, tasks: WritingTaskData[]) {
  const resolved: Array<WritingTaskData & { resolvedImageUrl: string }> = [];
  for (const task of tasks) {
    let resolvedImageUrl = task.imageUrl || "";
    if (task.imageFile) {
      resolvedImageUrl = await uploadWritingAsset(userId, task.imageFile);
    }
    resolved.push({ ...task, resolvedImageUrl });
  }
  return resolved;
}

/** Build task insert rows from resolved tasks. */
function buildTaskRows(testId: string, resolvedTasks: Array<WritingTaskData & { resolvedImageUrl: string }>) {
  return resolvedTasks.map((t, idx) => ({
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
  }));
}

/**
 * Save a new Writing Test with its tasks.
 */
export async function saveWritingTest(
  params: SaveWritingTestParams
): Promise<{ testId: string }> {
  const { userId, title, status, tasks } = params;

  const resolvedTasks = await resolveTasks(userId, tasks);

  const { data: testData, error: testError } = await supabase
    .from("writing_tests")
    .insert({ created_by: userId, title, status })
    .select("id")
    .single();

  if (testError || !testData) {
    throw new Error(testError?.message || "Failed to create writing test");
  }

  const testId = testData.id;

  const { error: taskError } = await supabase
    .from("writing_tasks")
    .insert(buildTaskRows(testId, resolvedTasks));

  if (taskError) {
    await supabase.from("writing_tests").delete().eq("id", testId);
    throw new Error(taskError.message || "Failed to create writing tasks");
  }

  return { testId };
}

/**
 * Update an existing Writing Test and sync its tasks.
 */
export async function updateWritingTest(
  params: UpdateWritingTestParams
): Promise<void> {
  const { testId, title, status, tasks } = params;

  // Get the owner for image upload path
  const { data: existing } = await supabase
    .from("writing_tests")
    .select("created_by")
    .eq("id", testId)
    .single();

  const userId = existing?.created_by || "";

  const resolvedTasks = await resolveTasks(userId, tasks);

  // Update parent
  const { error: updateError } = await supabase
    .from("writing_tests")
    .update({ title, status, updated_at: new Date().toISOString() })
    .eq("id", testId);

  if (updateError) {
    throw new Error(updateError.message || "Failed to update writing test");
  }

  // Delete old tasks, re-insert
  await supabase.from("writing_tasks").delete().eq("test_id", testId);

  const { error: taskError } = await supabase
    .from("writing_tasks")
    .insert(buildTaskRows(testId, resolvedTasks));

  if (taskError) {
    throw new Error(taskError.message || "Failed to update writing tasks");
  }
}

/**
 * Fetch a complete writing test with its tasks for edit mode.
 */
export async function fetchWritingTest(testId: string) {
  const { data: test, error: testError } = await supabase
    .from("writing_tests")
    .select("*")
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
    status: test.status,
    tasks: (tasks || []).map((t) => ({
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
