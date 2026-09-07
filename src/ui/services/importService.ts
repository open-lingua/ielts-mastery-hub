import { getAnonId } from "@/lib/anonId";
import {
  importListeningTest,
  importReadingTest,
  importWritingTest,
  uploadWritingAsset,
  validateImport,
  type ImportAudioFile,
  type ImportKind,
  type ImportPreview,
} from "@/lib/tauri";

export type { ImportKind, ImportPreview };

export interface ParsedImportFile {
  json: unknown;
  raw: string;
}

export async function parseImportFile(file: File): Promise<ParsedImportFile> {
  const raw = await file.text();
  try {
    return { json: JSON.parse(raw), raw };
  } catch (e) {
    const reason = e instanceof Error ? e.message : String(e);
    throw new Error(`The selected file is not valid JSON: ${reason}.`);
  }
}

const REQUIRED_LISTENING_SECTIONS = [1, 2, 3, 4];

export function validateListeningAudioSlots(audioFiles: ImportAudioFile[]): string | null {
  if (audioFiles.length !== 4) {
    return `Expected exactly 4 audio files (one per section); received ${audioFiles.length}.`;
  }
  const assigned = new Set(audioFiles.map((a) => a.sectionNumber));
  for (const section of REQUIRED_LISTENING_SECTIONS) {
    if (!assigned.has(section)) {
      return `No audio file was assigned to Section ${section}.`;
    }
  }
  return null;
}

export async function validate(
  kind: ImportKind,
  json: unknown,
  audioFiles: ImportAudioFile[] = []
): Promise<ImportPreview> {
  const userId = getAnonId();
  const audioMeta = audioFiles.map((a) => ({
    section_number: a.sectionNumber,
    file_name: a.file.name,
    size: a.file.size,
  }));
  try {
    const result = await validateImport(userId, kind, json, audioMeta);
    return result;
  } catch (e) {
    console.error("[importService] validate: failed", { kind }, e);
    throw e;
  }
}

export async function runImport(
  kind: ImportKind,
  json: unknown,
  audioFiles: ImportAudioFile[] = []
): Promise<string> {
  const userId = getAnonId();
  try {
    let testId: string;
    if (kind === "reading") testId = await importReadingTest(userId, json);
    else if (kind === "writing") testId = await importWritingTest(userId, json);
    else testId = await importListeningTest(userId, json, audioFiles);
    return testId;
  } catch (e) {
    console.error("[importService] runImport: failed", { kind }, e);
    throw e;
  }
}

// Uploads a Task 1 image asset and returns a copy of the parsed writing JSON with
// `image_url` set on the task tagged `task_type: "task1"` (falling back to the first task
// when no task is explicitly tagged as task1).
export async function resolveWritingTaskImage(json: unknown, imageFile: File): Promise<unknown> {
  if (typeof json !== "object" || json === null || !Array.isArray((json as { tasks?: unknown }).tasks)) {
    throw new Error("The writing JSON must include a `tasks` array to attach a Task 1 image.");
  }
  const source = json as { tasks: Array<Record<string, unknown>> };
  if (source.tasks.length === 0) {
    throw new Error("The writing JSON has no tasks to attach a Task 1 image to.");
  }

  const taskId = crypto.randomUUID();
  const imageUrl = await uploadWritingAsset(taskId, imageFile);

  const tasks = source.tasks.map((t) => ({ ...t }));
  const task1Index = tasks.findIndex((t) => t.task_type === "task1");
  const targetIndex = task1Index !== -1 ? task1Index : 0;
  tasks[targetIndex] = { ...tasks[targetIndex], id: taskId, image_url: imageUrl };

  return { ...source, tasks };
}
