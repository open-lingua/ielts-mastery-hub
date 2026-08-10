import { invoke } from "@tauri-apps/api/core";

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

export interface UserRole {
  id: string;
  user_id: string;
  role: string;
  created_at: string;
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
  return invoke<UserTestSession[]>("list_user_test_sessions", { user_id: userId });
}

export async function getUserTestSession(id: string, userId: string): Promise<UserTestSession | null> {
  return invoke<UserTestSession | null>("get_user_test_sessions", { id, user_id: userId });
}

export async function createUserTestSession(
  userId: string,
  input: { test_id: string; test_type: string; attempt_number?: number }
): Promise<string> {
  return invoke<string>("create_user_test_sessions", { user_id: userId, input });
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
  return invoke<void>("update_user_test_sessions", { id, user_id: userId, input });
}

export async function deleteUserTestSession(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_user_test_sessions", { id, user_id: userId });
}

// ── reading_tests ──────────────────────────────────────────────────────────

export async function listReadingTests(userId: string): Promise<ReadingTest[]> {
  return invoke<ReadingTest[]>("list_reading_tests", { user_id: userId });
}

export async function getReadingTest(id: string, userId: string): Promise<ReadingTest | null> {
  return invoke<ReadingTest | null>("get_reading_tests", { id, user_id: userId });
}

export async function createReadingTest(
  userId: string,
  input: { title?: string; test_type?: string; difficulty?: string; duration?: string; status?: string }
): Promise<string> {
  return invoke<string>("create_reading_tests", { user_id: userId, input });
}

export async function updateReadingTest(
  id: string,
  userId: string,
  input: { title?: string; test_type?: string; difficulty?: string; duration?: string; status?: string }
): Promise<void> {
  return invoke<void>("update_reading_tests", { id, user_id: userId, input });
}

export async function deleteReadingTest(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_reading_tests", { id, user_id: userId });
}

// ── reading_passages ───────────────────────────────────────────────────────

export async function listReadingPassages(userId: string): Promise<ReadingPassage[]> {
  return invoke<ReadingPassage[]>("list_reading_passages", { user_id: userId });
}

export async function createReadingPassage(
  userId: string,
  input: { test_id: string; passage_number?: number; title?: string; content?: string; notes?: string }
): Promise<string> {
  return invoke<string>("create_reading_passages", { user_id: userId, input });
}

export async function deleteReadingPassage(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_reading_passages", { id, user_id: userId });
}

// ── reading_question_groups ────────────────────────────────────────────────

export async function listReadingQuestionGroups(userId: string): Promise<ReadingQuestionGroup[]> {
  return invoke<ReadingQuestionGroup[]>("list_reading_question_groups", { user_id: userId });
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
  return invoke<string>("create_reading_question_groups", { user_id: userId, input });
}

export async function deleteReadingQuestionGroup(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_reading_question_groups", { id, user_id: userId });
}

// ── reading_questions ──────────────────────────────────────────────────────

export async function listReadingQuestions(userId: string): Promise<ReadingQuestion[]> {
  return invoke<ReadingQuestion[]>("list_reading_questions", { user_id: userId });
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
  return invoke<string>("create_reading_questions", { user_id: userId, input });
}

export async function deleteReadingQuestion(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_reading_questions", { id, user_id: userId });
}

// ── writing_tests ──────────────────────────────────────────────────────────

export async function listWritingTests(userId: string): Promise<WritingTest[]> {
  return invoke<WritingTest[]>("list_writing_tests", { user_id: userId });
}

export async function getWritingTest(id: string, userId: string): Promise<WritingTest | null> {
  return invoke<WritingTest | null>("get_writing_tests", { id, user_id: userId });
}

export async function createWritingTest(
  userId: string,
  input: { title?: string; status?: string }
): Promise<string> {
  return invoke<string>("create_writing_tests", { user_id: userId, input });
}

export async function updateWritingTest(
  id: string,
  userId: string,
  input: { title?: string; status?: string }
): Promise<void> {
  return invoke<void>("update_writing_tests", { id, user_id: userId, input });
}

export async function deleteWritingTest(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_writing_tests", { id, user_id: userId });
}

// ── writing_tasks ──────────────────────────────────────────────────────────

export async function listWritingTasks(userId: string): Promise<WritingTask[]> {
  return invoke<WritingTask[]>("list_writing_tasks", { user_id: userId });
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
  }
): Promise<string> {
  return invoke<string>("create_writing_tasks", { user_id: userId, input });
}

export async function deleteWritingTask(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_writing_tasks", { id, user_id: userId });
}

// ── listening_tests ────────────────────────────────────────────────────────

export async function listListeningTests(userId: string): Promise<ListeningTest[]> {
  return invoke<ListeningTest[]>("list_listening_tests", { user_id: userId });
}

export async function getListeningTest(id: string, userId: string): Promise<ListeningTest | null> {
  return invoke<ListeningTest | null>("get_listening_tests", { id, user_id: userId });
}

export async function createListeningTest(
  userId: string,
  input: { title?: string; difficulty?: string; duration?: string; status?: string }
): Promise<string> {
  return invoke<string>("create_listening_tests", { user_id: userId, input });
}

export async function updateListeningTest(
  id: string,
  userId: string,
  input: { title?: string; difficulty?: string; duration?: string; status?: string }
): Promise<void> {
  return invoke<void>("update_listening_tests", { id, user_id: userId, input });
}

export async function deleteListeningTest(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_listening_tests", { id, user_id: userId });
}

// ── listening_sections ─────────────────────────────────────────────────────

export async function listListeningSections(userId: string): Promise<ListeningSection[]> {
  return invoke<ListeningSection[]>("list_listening_sections", { user_id: userId });
}

export async function createListeningSection(
  userId: string,
  input: { test_id: string; section_number?: number; title?: string; transcript?: string; audio_url?: string }
): Promise<string> {
  return invoke<string>("create_listening_sections", { user_id: userId, input });
}

export async function deleteListeningSection(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_listening_sections", { id, user_id: userId });
}

// ── listening_question_groups ──────────────────────────────────────────────

export async function listListeningQuestionGroups(userId: string): Promise<ListeningQuestionGroup[]> {
  return invoke<ListeningQuestionGroup[]>("list_listening_question_groups", { user_id: userId });
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
  return invoke<string>("create_listening_question_groups", { user_id: userId, input });
}

export async function deleteListeningQuestionGroup(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_listening_question_groups", { id, user_id: userId });
}

// ── listening_questions ────────────────────────────────────────────────────

export async function listListeningQuestions(userId: string): Promise<ListeningQuestion[]> {
  return invoke<ListeningQuestion[]>("list_listening_questions", { user_id: userId });
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
  return invoke<string>("create_listening_questions", { user_id: userId, input });
}

export async function deleteListeningQuestion(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_listening_questions", { id, user_id: userId });
}

// ── profiles ───────────────────────────────────────────────────────────────

export async function listProfiles(): Promise<Profile[]> {
  return invoke<Profile[]>("list_profiles");
}

export async function getProfile(id: string): Promise<Profile | null> {
  return invoke<Profile | null>("get_profiles", { id });
}

export async function updateProfile(
  id: string,
  input: {
    full_name?: string | null;
    avatar_url?: string | null;
    plan_type?: string | null;
    email?: string | null;
    is_banned?: boolean | null;
    ban_reason?: string | null;
    banned_until?: string | null;
  }
): Promise<void> {
  return invoke<void>("update_profiles", { id, input });
}

export async function deleteProfile(id: string): Promise<void> {
  return invoke<void>("delete_profiles", { id });
}

// ── user_roles ─────────────────────────────────────────────────────────────

export async function listUserRoles(userId: string): Promise<UserRole[]> {
  return invoke<UserRole[]>("list_user_roles", { user_id: userId });
}

export async function createUserRole(input: { user_id: string; role: string }): Promise<string> {
  return invoke<string>("create_user_roles", { input });
}

export async function deleteUserRole(id: string, userId: string): Promise<void> {
  return invoke<void>("delete_user_roles", { id, user_id: userId });
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
