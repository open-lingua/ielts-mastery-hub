import { convertFileSrc, invoke } from "@tauri-apps/api/core";
import type { PaginatedResponse } from "@/types/pagination";

// ── Shared response types (snake_case — no serde rename_all on Rust structs) ──

export interface UserTestSession {
  id: string;
  user_id: string;
  test_id: string;
  test_type: string;
  status: string;
  progress_percent: number;
  score_band: number | null;
  attempt_number: number;
  answers: string | null; // JSON string
  feedback_data: string | null; // JSON string
  started_at: string;
  completed_at: string | null;
  last_active_at: string;
  created_at: string;
}

export interface ReadingTest {
  id: string;
  created_by: string;
  title: string;
  test_type: string;
  difficulty: string;
  duration: string;
  status: string;
  created_at: string;
  updated_at: string;
}

export interface ReadingPassage {
  id: string;
  test_id: string;
  passage_number: number;
  title: string;
  content: string;
  notes: string | null;
  created_at: string;
}

export interface ReadingQuestionGroup {
  id: string;
  passage_id: string;
  group_order: number;
  question_type: string;
  instructions: string;
  word_limit: string | null;
  has_word_bank: boolean;
  word_bank: string | null; // JSON string
  sequential_order: boolean;
  multiple_selection: boolean;
  select_count: number;
  created_at: string;
}

export interface ReadingQuestion {
  id: string;
  group_id: string;
  question_order: number;
  text: string;
  answer: string | null;
  options: string | null; // JSON string
  matching_pairs: string | null; // JSON string
  completion_gaps: string | null; // JSON string
  accepted_answers: string | null; // JSON string
  created_at: string;
}

export interface WritingTest {
  id: string;
  created_by: string;
  title: string;
  status: string;
  created_at: string;
  updated_at: string;
}

export interface WritingTask {
  id: string;
  test_id: string;
  task_number: number;
  task_type: string;
  title: string;
  difficulty: string;
  suggested_time: string;
  prompt: string;
  min_words: number;
  max_words: string | null;
  image_url: string | null;
  include_model_answer: boolean;
  model_answer: string | null;
  figure_description: string | null;
  created_at: string;
}

export interface ListeningTest {
  id: string;
  created_by: string;
  title: string;
  difficulty: string;
  duration: string;
  status: string;
  created_at: string;
  updated_at: string;
}

export interface ListeningSection {
  id: string;
  test_id: string;
  section_number: number;
  title: string;
  transcript: string | null;
  audio_url: string | null;
  created_at: string;
}

export interface ListeningQuestionGroup {
  id: string;
  section_id: string;
  group_order: number;
  question_type: string;
  instructions: string;
  word_limit: string | null;
  has_word_bank: boolean;
  word_bank: string | null; // JSON string
  sequential_order: boolean;
  multiple_selection: boolean;
  select_count: number;
  created_at: string;
}

export interface ListeningQuestion {
  id: string;
  group_id: string;
  question_order: number;
  text: string;
  answer: string | null;
  options: string | null; // JSON string
  matching_pairs: string | null; // JSON string
  completion_gaps: string | null; // JSON string
  accepted_answers: string | null; // JSON string
  timestamp: string | null;
  created_at: string;
}

export interface Profile {
  id: string;
  full_name: string | null;
  avatar_url: string | null;
  plan_type: string;
  email: string | null;
  is_banned: boolean;
  ban_reason: string | null;
  banned_until: string | null;
  updated_at: string;
}

export interface GradingResult {
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

// ── user_test_sessions ─────────────────────────────────────────────────────

export async function listUserTestSessions(userId: string): Promise<UserTestSession[]> {
  return invoke<UserTestSession[]>("list_user_test_sessions", { userId });
}

export async function getUserTestSession(id: string, userId: string): Promise<UserTestSession | null> {
  return invoke<UserTestSession | null>("get_user_test_sessions", { id, userId });
}

export async function createUserTestSession(
  userId: string,
  input: { test_id: string; test_type: string; attempt_number?: number }
): Promise<string> {
  return invoke<string>("create_user_test_sessions", { userId, input });
}

export async function updateUserTestSession(
  id: string,
  userId: string,
  input: {
    status?: string;
    progress_percent?: number;
    score_band?: number | null;
    answers?: string | null;
    feedback_data?: string | null;
    completed_at?: string | null;
    last_active_at?: string | null;
  }
): Promise<void> {
  return invoke<void>("update_user_test_sessions", { id, userId, input });
}

export async function deleteUserTestSession(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_user_test_sessions", { id, userId });
}

// ── practice_library ─────────────────────────────────────────────────────────

export interface PracticeTestCardDto {
  id: string;
  title: string;
  module: string;
  difficulty: string;
  duration: string;
  status: string;
  progress_percent: number;
  score_band: number | null;
  last_active_at: string | null;
  session_id: string | null;
  created_at: string;
}

export async function listPracticeTests(
  userId: string,
  module: string | undefined,
  page: number,
  pageSize: number
): Promise<PaginatedResponse<PracticeTestCardDto>> {
  return invoke<PaginatedResponse<PracticeTestCardDto>>("list_practice_tests", {
    userId,
    module,
    page,
    pageSize,
  });
}

// ── reading_tests ──────────────────────────────────────────────────────────

export async function listReadingTests(userId: string): Promise<ReadingTest[]> {
  return invoke<ReadingTest[]>("list_reading_tests", { userId });
}

export async function getReadingTest(id: string, userId: string): Promise<ReadingTest | null> {
  return invoke<ReadingTest | null>("get_reading_tests", { id, userId });
}

export async function createReadingTest(
  userId: string,
  input: {
    title?: string;
    test_type?: string;
    difficulty?: string;
    duration?: string;
    status?: string;
  }
): Promise<string> {
  return invoke<string>("create_reading_tests", { userId, input });
}

export async function updateReadingTest(
  id: string,
  userId: string,
  input: {
    title?: string;
    test_type?: string;
    difficulty?: string;
    duration?: string;
    status?: string;
  }
): Promise<void> {
  return invoke<void>("update_reading_tests", { id, userId, input });
}

export async function deleteReadingTest(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_reading_tests", { id, userId });
}

// ── reading_passages ───────────────────────────────────────────────────────

export async function listReadingPassages(userId: string): Promise<ReadingPassage[]> {
  return invoke<ReadingPassage[]>("list_reading_passages", { userId });
}

export async function createReadingPassage(
  userId: string,
  input: {
    test_id: string;
    passage_number?: number;
    title?: string;
    content?: string;
    notes?: string;
  }
): Promise<string> {
  return invoke<string>("create_reading_passages", { userId, input });
}

export async function deleteReadingPassage(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_reading_passages", { id, userId });
}

// ── reading_question_groups ────────────────────────────────────────────────

export async function listReadingQuestionGroups(userId: string): Promise<ReadingQuestionGroup[]> {
  return invoke<ReadingQuestionGroup[]>("list_reading_question_groups", { userId });
}

export async function createReadingQuestionGroup(
  userId: string,
  input: {
    passage_id: string;
    group_order?: number;
    question_type?: string;
    instructions?: string;
    word_limit?: string;
    has_word_bank?: boolean;
    word_bank?: string;
    sequential_order?: boolean;
    multiple_selection?: boolean;
    select_count?: number;
  }
): Promise<string> {
  return invoke<string>("create_reading_question_groups", { userId, input });
}

export async function deleteReadingQuestionGroup(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_reading_question_groups", { id, userId });
}

// ── reading_questions ──────────────────────────────────────────────────────

export async function listReadingQuestions(userId: string): Promise<ReadingQuestion[]> {
  return invoke<ReadingQuestion[]>("list_reading_questions", { userId });
}

export async function createReadingQuestion(
  userId: string,
  input: {
    group_id: string;
    question_order?: number;
    text?: string;
    answer?: string;
    options?: string;
    matching_pairs?: string;
    completion_gaps?: string;
    accepted_answers?: string;
  }
): Promise<string> {
  return invoke<string>("create_reading_questions", { userId, input });
}

export async function deleteReadingQuestion(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_reading_questions", { id, userId });
}

// ── writing_tests ──────────────────────────────────────────────────────────

export async function listWritingTests(userId: string): Promise<WritingTest[]> {
  return invoke<WritingTest[]>("list_writing_tests", { userId });
}

export async function getWritingTest(id: string, userId: string): Promise<WritingTest | null> {
  return invoke<WritingTest | null>("get_writing_tests", { id, userId });
}

export async function createWritingTest(userId: string, input: { title?: string; status?: string }): Promise<string> {
  return invoke<string>("create_writing_tests", { userId, input });
}

export async function updateWritingTest(
  id: string,
  userId: string,
  input: { title?: string; status?: string }
): Promise<void> {
  return invoke<void>("update_writing_tests", { id, userId, input });
}

export async function deleteWritingTest(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_writing_tests", { id, userId });
}

// ── writing_tasks ──────────────────────────────────────────────────────────

export async function listWritingTasks(userId: string): Promise<WritingTask[]> {
  return invoke<WritingTask[]>("list_writing_tasks", { userId });
}

export async function createWritingTask(
  userId: string,
  input: {
    test_id: string;
    task_number?: number;
    task_type?: string;
    title?: string;
    difficulty?: string;
    suggested_time?: string;
    prompt?: string;
    min_words?: number;
    max_words?: string;
    image_url?: string;
    include_model_answer?: boolean;
    model_answer?: string;
    figure_description?: string;
  }
): Promise<string> {
  return invoke<string>("create_writing_tasks", { userId, input });
}

export async function deleteWritingTask(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_writing_tasks", { id, userId });
}

// ── listening_tests ────────────────────────────────────────────────────────

export async function listListeningTests(userId: string): Promise<ListeningTest[]> {
  return invoke<ListeningTest[]>("list_listening_tests", { userId });
}

export async function getListeningTest(id: string, userId: string): Promise<ListeningTest | null> {
  return invoke<ListeningTest | null>("get_listening_tests", { id, userId });
}

export async function createListeningTest(
  userId: string,
  input: { title?: string; difficulty?: string; duration?: string; status?: string }
): Promise<string> {
  return invoke<string>("create_listening_tests", { userId, input });
}

export async function updateListeningTest(
  id: string,
  userId: string,
  input: { title?: string; difficulty?: string; duration?: string; status?: string }
): Promise<void> {
  return invoke<void>("update_listening_tests", { id, userId, input });
}

export async function deleteListeningTest(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_listening_tests", { id, userId });
}

// ── listening_sections ─────────────────────────────────────────────────────

export async function listListeningSections(userId: string): Promise<ListeningSection[]> {
  return invoke<ListeningSection[]>("list_listening_sections", { userId });
}

export async function createListeningSection(
  userId: string,
  input: {
    test_id: string;
    section_number?: number;
    title?: string;
    transcript?: string;
    audio_url?: string;
  }
): Promise<string> {
  return invoke<string>("create_listening_sections", { userId, input });
}

export async function deleteListeningSection(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_listening_sections", { id, userId });
}

// ── listening_question_groups ──────────────────────────────────────────────

export async function listListeningQuestionGroups(userId: string): Promise<ListeningQuestionGroup[]> {
  return invoke<ListeningQuestionGroup[]>("list_listening_question_groups", { userId });
}

export async function createListeningQuestionGroup(
  userId: string,
  input: {
    section_id: string;
    group_order?: number;
    question_type?: string;
    instructions?: string;
    word_limit?: string;
    has_word_bank?: boolean;
    word_bank?: string;
    sequential_order?: boolean;
    multiple_selection?: boolean;
    select_count?: number;
  }
): Promise<string> {
  return invoke<string>("create_listening_question_groups", { userId, input });
}

export async function deleteListeningQuestionGroup(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_listening_question_groups", { id, userId });
}

// ── listening_questions ────────────────────────────────────────────────────

export async function listListeningQuestions(userId: string): Promise<ListeningQuestion[]> {
  return invoke<ListeningQuestion[]>("list_listening_questions", { userId });
}

export async function createListeningQuestion(
  userId: string,
  input: {
    group_id: string;
    question_order?: number;
    text?: string;
    answer?: string;
    options?: string;
    matching_pairs?: string;
    completion_gaps?: string;
    accepted_answers?: string;
    timestamp?: string;
  }
): Promise<string> {
  return invoke<string>("create_listening_questions", { userId, input });
}

export async function deleteListeningQuestion(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_listening_questions", { id, userId });
}

// ── profiles ───────────────────────────────────────────────────────────────

export async function listProfiles(): Promise<Profile[]> {
  return invoke<Profile[]>("list_profiles");
}

export async function getProfile(id: string): Promise<Profile | null> {
  return invoke<Profile | null>("get_profiles", { id });
}

// ── storage ────────────────────────────────────────────────────────────────

export async function uploadWritingAsset(userId: string, file: File): Promise<string> {
  const bytes = Array.from(new Uint8Array(await file.arrayBuffer()));
  const path = await invoke<string>("upload_writing_asset", {
    userId,
    fileName: file.name,
    fileData: bytes,
  });
  return convertFileSrc(path);
}

export async function uploadListeningAudio(userId: string, file: File): Promise<string> {
  const bytes = Array.from(new Uint8Array(await file.arrayBuffer()));
  const path = await invoke<string>("upload_listening_audio", {
    userId,
    fileName: file.name,
    fileData: bytes,
  });
  return convertFileSrc(path);
}

// ── import ─────────────────────────────────────────────────────────────────

export type ImportKind = "reading" | "writing" | "listening";

export interface ImportPreview {
  title: string;
  status: string;
  kind: string;
  passage_or_section_or_task_count: number;
  group_count: number;
  question_count: number;
  duplicate_of: string | null;
}

export interface ImportAudioMeta {
  section_number: number;
  file_name: string;
  size: number;
}

export interface ImportAudioFile {
  sectionNumber: number;
  file: File;
}

// A stored audio_url may be a raw filesystem path (new imports) or an
// already-converted asset:// URL (existing uploads) — convert only the former.
export function toPlayableUrl(url?: string | null): string {
  if (!url) return "";
  const isFsPath = url.startsWith("/") || /^[A-Za-z]:\\/.test(url);
  return isFsPath ? convertFileSrc(url) : url;
}

export async function validateImport(
  userId: string,
  kind: ImportKind,
  json: unknown,
  audioMeta: ImportAudioMeta[] = []
): Promise<ImportPreview> {
  try {
    const result = await invoke<ImportPreview>("validate_import", {
      userId,
      kind,
      jsonData: json,
      audioMeta,
    });
    return result;
  } catch (e) {
    console.error("[tauri] validate_import: failed", { kind }, e);
    throw e;
  }
}

export async function importReadingTest(userId: string, json: unknown): Promise<string> {
  try {
    const result = await invoke<string>("import_reading_test", { userId, jsonData: json });
    return result;
  } catch (e) {
    console.error("[tauri] import_reading_test: failed", e);
    throw e;
  }
}

export async function importWritingTest(userId: string, json: unknown): Promise<string> {
  try {
    const result = await invoke<string>("import_writing_test", { userId, jsonData: json });
    return result;
  } catch (e) {
    console.error("[tauri] import_writing_test: failed", e);
    throw e;
  }
}

export async function importListeningTest(
  userId: string,
  json: unknown,
  audioFiles: ImportAudioFile[]
): Promise<string> {
  const audio_files = await Promise.all(
    audioFiles.map(async ({ sectionNumber, file }) => ({
      section_number: sectionNumber,
      file_name: file.name,
      file_data: Array.from(new Uint8Array(await file.arrayBuffer())),
    }))
  );
  try {
    const result = await invoke<string>("import_listening_test", {
      userId,
      jsonData: json,
      audioFiles: audio_files,
    });
    return result;
  } catch (e) {
    console.error("[tauri] import_listening_test: failed", e);
    throw e;
  }
}

// ── export ─────────────────────────────────────────────────────────────────

export interface ExportResult {
  filePath: string;
  fileName: string;
  warnings: string[];
}

export async function exportTestToZip(
  userId: string,
  kind: ImportKind,
  id: string
): Promise<ExportResult | null> {
  return invoke<ExportResult | null>("export_test_to_zip", { userId, kind, id });
}

// ── grade_writing ──────────────────────────────────────────────────────────

export async function gradeWriting(input: {
  user_id: string;
  task_type: "task1" | "task2";
  prompt: string;
  user_response: string;
  session_id?: string;
  ai_api_key: string;
  ai_gateway_url: string;
}): Promise<GradingResult> {
  return invoke<GradingResult>("grade_writing", { input });
}
