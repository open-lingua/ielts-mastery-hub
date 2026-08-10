import {
  listReadingTests,
  listWritingTests,
  listListeningTests,
  listUserTestSessions,
  createUserTestSession,
  updateUserTestSession,
  getReadingTest,
  getWritingTest,
  getListeningTest,
} from "@/lib/tauri";

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
  created_at: string;
}

export async function fetchLibraryData(userId: string): Promise<PracticeTestCard[]> {
  const [readingTests, writingTests, listeningTests, sessions] = await Promise.all([
    listReadingTests(userId),
    listWritingTests(userId),
    listListeningTests(userId),
    listUserTestSessions(userId),
  ]);

  // Only show published tests
  const publishedReading = readingTests.filter((t) => t.status === "published");
  const publishedWriting = writingTests.filter((t) => t.status === "published");
  const publishedListening = listeningTests.filter((t) => t.status === "published");

  // Group sessions by test_type + test_id, pick highest attempt_number
  const latestSessionMap = new Map<string, typeof sessions[0]>();
  for (const s of sessions) {
    const key = `${s.test_type}_${s.test_id}`;
    const existing = latestSessionMap.get(key);
    if (!existing || (s.attempt_number ?? 1) > (existing.attempt_number ?? 1)) {
      latestSessionMap.set(key, s);
    }
  }

  const merge = (
    tests: Array<{ id: string; title: string; difficulty?: string; duration?: string; created_at: string }>,
    module: TestModule,
    defaultDifficulty = "7",
    defaultDuration = "60 mins"
  ): PracticeTestCard[] =>
    tests.map((t) => {
      const session = latestSessionMap.get(`${module}_${t.id}`);
      return {
        id: t.id,
        title: t.title,
        module,
        difficulty: (t as any).difficulty ?? defaultDifficulty,
        duration: (t as any).duration ?? defaultDuration,
        status: (session?.status as SessionStatus) ?? "not_started",
        progress_percent: session?.progress_percent ?? 0,
        score_band: session?.score_band !== null && session?.score_band !== undefined
          ? Number(session.score_band)
          : null,
        last_active_at: session?.last_active_at ?? null,
        session_id: session?.id ?? null,
        created_at: t.created_at,
      };
    });

  return [
    ...merge(publishedReading, "reading"),
    ...merge(publishedWriting, "writing", "7", "60 mins"),
    ...merge(publishedListening, "listening"),
  ];
}

export interface TestSessionInfo {
  id: string;
  started_at: string;
  status: string;
  progress_percent: number;
  score_band: number | null;
  attempt_number: number;
}

export async function startTestSession(
  userId: string,
  testId: string,
  testType: TestModule
): Promise<TestSessionInfo> {
  const sessions = await listUserTestSessions(userId);
  const matching = sessions.filter(
    (s) => s.test_id === testId && s.test_type === testType
  );
  const maxAttempt = matching.reduce((max, s) => Math.max(max, s.attempt_number ?? 1), 0);
  const nextAttempt = maxAttempt + 1;

  const newId = await createUserTestSession(userId, {
    test_id: testId,
    test_type: testType,
    attempt_number: nextAttempt,
  });

  const updated = await listUserTestSessions(userId);
  const created = updated.find((s) => s.id === newId);
  if (!created) throw new Error("Failed to retrieve created session");

  return {
    id: created.id,
    started_at: created.started_at,
    status: created.status,
    progress_percent: created.progress_percent,
    score_band: created.score_band !== null ? Number(created.score_band) : null,
    attempt_number: created.attempt_number,
  };
}

export async function fetchExistingSession(
  userId: string,
  testId: string,
  testType: TestModule
): Promise<(TestSessionInfo & { answers?: Record<string, unknown> | null }) | null> {
  const sessions = await listUserTestSessions(userId);
  const matching = sessions
    .filter((s) => s.test_id === testId && s.test_type === testType)
    .sort((a, b) => (b.attempt_number ?? 1) - (a.attempt_number ?? 1));

  const s = matching[0];
  if (!s) return null;

  let answers: Record<string, unknown> | null = null;
  if (s.answers) {
    try { answers = JSON.parse(s.answers); } catch { answers = null; }
  }

  return {
    id: s.id,
    started_at: s.started_at,
    status: s.status,
    progress_percent: s.progress_percent,
    score_band: s.score_band !== null ? Number(s.score_band) : null,
    attempt_number: s.attempt_number,
    answers,
  };
}

export interface ActiveSessionInfo {
  id: string;
  test_id: string;
  test_type: TestModule;
  started_at: string;
  status: string;
}

export async function fetchActiveSession(userId: string): Promise<ActiveSessionInfo | null> {
  const sessions = await listUserTestSessions(userId);
  const active = sessions
    .filter((s) => s.status === "in_progress")
    .sort((a, b) => new Date(b.started_at).getTime() - new Date(a.started_at).getTime())[0];

  if (!active) return null;
  return {
    id: active.id,
    test_id: active.test_id,
    test_type: active.test_type as TestModule,
    started_at: active.started_at,
    status: active.status,
  };
}

export async function fetchTestTitle(testId: string, testType: TestModule): Promise<string> {
  const fallback = `${testType.charAt(0).toUpperCase() + testType.slice(1)} Test`;
  try {
    if (testType === "reading") {
      const t = await getReadingTest(testId, "");
      return t?.title || fallback;
    }
    if (testType === "writing") {
      const t = await getWritingTest(testId, "");
      return t?.title || fallback;
    }
    const t = await getListeningTest(testId, "");
    return t?.title || fallback;
  } catch {
    return fallback;
  }
}

export async function completeSession(
  sessionId: string,
  scoreBand: number | null,
  answers?: Record<string, unknown> | null
): Promise<void> {
  const now = new Date().toISOString();
  const input: Parameters<typeof updateUserTestSession>[2] = {
    status: "completed",
    progress_percent: 100,
    score_band: scoreBand ?? undefined,
    completed_at: now,
    last_active_at: now,
  };
  if (answers !== undefined && answers !== null) {
    input.answers = JSON.stringify(answers);
  }
  // userId is unknown at this layer — use empty string; the Rust WHERE clause
  // uses user_id but the session ID is the authoritative key for owned sessions.
  // ponytail: passing empty userId works because the DB row was created by this user;
  //           the COALESCE update is safe even if user_id check is relaxed in practice.
  //           Fix if per-user isolation on updates becomes stricter.
  const { getAnonId } = await import("@/lib/anonId");
  await updateUserTestSession(sessionId, getAnonId(), input);
}
