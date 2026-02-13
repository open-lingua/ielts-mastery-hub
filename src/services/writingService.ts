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

/**
 * Upload an image to the writing-assets storage bucket.
 * Files are stored under `{userId}/{timestamp}-{filename}`.
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

/**
 * Save a complete Writing Test with its tasks.
 */
export async function saveWritingTest(
  params: SaveWritingTestParams
): Promise<{ testId: string }> {
  const { userId, title, status, tasks } = params;

  // 1. Upload images for any task1 that has a file
  const resolvedTasks: Array<WritingTaskData & { resolvedImageUrl: string }> = [];
  for (const task of tasks) {
    let resolvedImageUrl = task.imageUrl || "";
    if (task.imageFile) {
      resolvedImageUrl = await uploadWritingAsset(userId, task.imageFile);
    }
    resolvedTasks.push({ ...task, resolvedImageUrl });
  }

  // 2. Insert the test
  const { data: testData, error: testError } = await supabase
    .from("writing_tests")
    .insert({
      created_by: userId,
      title,
      status,
    })
    .select("id")
    .single();

  if (testError || !testData) {
    throw new Error(testError?.message || "Failed to create writing test");
  }

  const testId = testData.id;

  // 3. Insert tasks
  const taskInserts = resolvedTasks.map((t, idx) => ({
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

  const { error: taskError } = await supabase
    .from("writing_tasks")
    .insert(taskInserts);

  if (taskError) {
    // Cleanup on failure
    await supabase.from("writing_tests").delete().eq("id", testId);
    throw new Error(taskError.message || "Failed to create writing tasks");
  }

  return { testId };
}
