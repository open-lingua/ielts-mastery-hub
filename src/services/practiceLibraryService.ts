import { supabase } from "@/integrations/supabase/client";

export type TestModule = "reading" | "writing" | "listening";
export type SessionStatus = "not_started" | "in_progress" | "completed";

export interface PracticeTestCard {
  id: string;
  title: string;
  module: TestModule;
  difficulty: string;
  duration: string;
  status: SessionStatus;
  progress_percent: number;
  score_band: number | null;
  last_active_at: string | null;
  session_id: string | null;
}

interface RawTest {
  id: string;
  title: string;
  difficulty: string;
  duration: string;
}

export async function fetchLibraryData(userId: string): Promise<PracticeTestCard[]> {
  const [readingRes, writingRes, listeningRes, sessionsRes] = await Promise.all([
    supabase.from("reading_tests").select("id, title, difficulty, duration").eq("status", "published"),
    supabase.from("writing_tests").select("id, title").eq("status", "published"),
    supabase.from("listening_tests").select("id, title, difficulty, duration").eq("status", "published"),
    supabase.from("user_test_sessions").select("*").eq("user_id", userId),
  ]);

  const sessions = sessionsRes.data ?? [];

  // Group sessions by test_type + test_id and pick the latest attempt
  const latestSessionMap = new Map<string, (typeof sessions)[0]>();
  for (const s of sessions) {
    const key = `${s.test_type}_${s.test_id}`;
    const existing = latestSessionMap.get(key);
    if (!existing || (s.attempt_number ?? 1) > (existing.attempt_number ?? 1)) {
      latestSessionMap.set(key, s);
    }
  }

  const merge = (tests: RawTest[], module: TestModule): PracticeTestCard[] =>
    tests.map((t) => {
      const session = latestSessionMap.get(`${module}_${t.id}`);
      return {
        id: t.id,
        title: t.title,
        module,
        difficulty: t.difficulty,
        duration: t.duration,
        status: (session?.status as SessionStatus) ?? "not_started",
        progress_percent: session?.progress_percent ?? 0,
        score_band: session?.score_band ? Number(session.score_band) : null,
        last_active_at: session?.last_active_at ?? null,
        session_id: session?.id ?? null,
      };
    });

  const reading = merge(
    (readingRes.data ?? []) as RawTest[],
    "reading"
  );
  const writing = merge(
    ((writingRes.data ?? []) as { id: string; title: string }[]).map((w) => ({
      ...w,
      difficulty: "7",
      duration: "60 mins",
    })),
    "writing"
  );
  const listening = merge(
    (listeningRes.data ?? []) as RawTest[],
    "listening"
  );

  return [...reading, ...writing, ...listening];
}

export interface TestSessionInfo {
  id: string;
  started_at: string;
  status: string;
  progress_percent: number;
  score_band: number | null;
  attempt_number: number;
}

/**
 * Start a NEW test session (new attempt). No upsert — always inserts.
 */
export async function startTestSession(
  userId: string,
  testId: string,
  testType: TestModule
): Promise<TestSessionInfo> {
  // Determine next attempt number
  const { data: prev } = await supabase
    .from("user_test_sessions")
    .select("attempt_number")
    .eq("user_id", userId)
    .eq("test_id", testId)
    .eq("test_type", testType)
    .order("attempt_number", { ascending: false })
    .limit(1)
    .maybeSingle();

  const nextAttempt = (prev?.attempt_number ?? 0) + 1;
  const now = new Date().toISOString();

  const { data, error } = await supabase
    .from("user_test_sessions")
    .insert({
      user_id: userId,
      test_id: testId,
      test_type: testType,
      status: "in_progress",
      progress_percent: 0,
      started_at: now,
      last_active_at: now,
      attempt_number: nextAttempt,
    })
    .select("id, started_at, status, progress_percent, score_band, attempt_number")
    .single();

  if (error) throw error;
  return data as TestSessionInfo;
}

/**
 * Fetch the most recent session for a given user + test + type.
 * Returns the latest attempt regardless of status.
 */
export async function fetchExistingSession(
  userId: string,
  testId: string,
  testType: TestModule
): Promise<TestSessionInfo | null> {
  const { data, error } = await supabase
    .from("user_test_sessions")
    .select("id, started_at, status, progress_percent, score_band, attempt_number")
    .eq("user_id", userId)
    .eq("test_id", testId)
    .eq("test_type", testType)
    .order("attempt_number", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (error) throw error;
  return data as TestSessionInfo | null;
}

export interface ActiveSessionInfo {
  id: string;
  test_id: string;
  test_type: TestModule;
  started_at: string;
  status: string;
}

/**
 * Fetch any in-progress session for the user, regardless of test.
 * Returns null if no active session exists.
 */
export async function fetchActiveSession(
  userId: string
): Promise<ActiveSessionInfo | null> {
  const { data, error } = await supabase
    .from("user_test_sessions")
    .select("id, test_id, test_type, started_at, status")
    .eq("user_id", userId)
    .eq("status", "in_progress")
    .order("started_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (error) throw error;
  return data as ActiveSessionInfo | null;
}

/**
 * Look up the test title for an active session by querying the appropriate table.
 */
export async function fetchTestTitle(
  testId: string,
  testType: TestModule
): Promise<string> {
  const table =
    testType === "reading"
      ? "reading_tests"
      : testType === "writing"
      ? "writing_tests"
      : "listening_tests";

  const { data } = await supabase
    .from(table)
    .select("title")
    .eq("id", testId)
    .maybeSingle();

  return data?.title || `${testType.charAt(0).toUpperCase() + testType.slice(1)} Test`;
}

/**
 * Complete a session by its ID (used by submit functions).
 */
export async function completeSession(
  sessionId: string,
  scoreBand: number | null,
  answers?: Record<string, unknown> | null
): Promise<void> {
  const payload: Record<string, unknown> = {
    status: "completed",
    progress_percent: 100,
    score_band: scoreBand,
    completed_at: new Date().toISOString(),
    last_active_at: new Date().toISOString(),
  };
  if (answers !== undefined && answers !== null) {
    payload.answers = answers;
  }
  const { error } = await supabase
    .from("user_test_sessions")
    .update(payload)
    .eq("id", sessionId);

  if (error) throw error;
}
