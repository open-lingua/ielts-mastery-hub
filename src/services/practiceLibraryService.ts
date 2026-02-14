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
  // Fetch all published tests and user sessions in parallel
  const [readingRes, writingRes, listeningRes, sessionsRes] = await Promise.all([
    supabase.from("reading_tests").select("id, title, difficulty, duration").eq("status", "published"),
    supabase.from("writing_tests").select("id, title").eq("status", "published"),
    supabase.from("listening_tests").select("id, title, difficulty, duration").eq("status", "published"),
    supabase.from("user_test_sessions").select("*").eq("user_id", userId),
  ]);

  const sessions = sessionsRes.data ?? [];
  const sessionMap = new Map(sessions.map((s) => [`${s.test_type}_${s.test_id}`, s]));

  const merge = (tests: RawTest[], module: TestModule): PracticeTestCard[] =>
    tests.map((t) => {
      const session = sessionMap.get(`${module}_${t.id}`);
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
}

export async function startTestSession(
  userId: string,
  testId: string,
  testType: TestModule
): Promise<TestSessionInfo> {
  const now = new Date().toISOString();
  const { data, error } = await supabase
    .from("user_test_sessions")
    .upsert(
      {
        user_id: userId,
        test_id: testId,
        test_type: testType,
        status: "in_progress",
        progress_percent: 0,
        started_at: now,
        last_active_at: now,
      },
      { onConflict: "user_id,test_id,test_type" }
    )
    .select("id, started_at, status, progress_percent, score_band")
    .single();

  if (error) throw error;
  return data as TestSessionInfo;
}

export async function fetchExistingSession(
  userId: string,
  testId: string,
  testType: TestModule
): Promise<TestSessionInfo | null> {
  const { data, error } = await supabase
    .from("user_test_sessions")
    .select("id, started_at, status, progress_percent, score_band")
    .eq("user_id", userId)
    .eq("test_id", testId)
    .eq("test_type", testType)
    .maybeSingle();

  if (error) throw error;
  return data as TestSessionInfo | null;
}
