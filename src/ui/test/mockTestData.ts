/**
 * Shared mock data for unit tests across the entire IELTS platform.
 */

// ─── Auth Mocks ─────────────────────────────────────

export const mockStudentUser = {
  id: "user-student-001",
  email: "student@test.com",
  user_metadata: { full_name: "Jane Doe" },
};

export const mockAdminUser = {
  id: "user-admin-001",
  email: "admin@test.com",
  user_metadata: { full_name: "Admin Smith" },
};

export const mockProfile = {
  full_name: "Jane Doe",
  avatar_url: null,
  plan_type: "free",
};

export const mockAdminProfile = {
  full_name: "Admin Smith",
  avatar_url: null,
  plan_type: "premium",
};

// ─── Dashboard Mocks ────────────────────────────────

export const mockBandScoreData = [
  { date: "Jan 5", reading: 6.0 },
  { date: "Jan 12", reading: 6.5, listening: 7.0 },
  { date: "Jan 20", reading: 7.0, listening: 7.0, writing: 6.0 },
  { date: "Feb 1", reading: 7.5, listening: 7.5, writing: 6.5 },
];

export const mockRecentActivities = [
  {
    id: "sess-001",
    test_type: "reading",
    test_id: "test-r-001",
    status: "completed",
    score_band: 7.0,
    progress_percent: 100,
    started_at: new Date(Date.now() - 86400000).toISOString(),
    completed_at: new Date(Date.now() - 82800000).toISOString(),
    last_active_at: new Date(Date.now() - 82800000).toISOString(),
    attempt_number: 1,
  },
  {
    id: "sess-002",
    test_type: "listening",
    test_id: "test-l-001",
    status: "in_progress",
    score_band: null,
    progress_percent: 45,
    started_at: new Date(Date.now() - 3600000).toISOString(),
    completed_at: null,
    last_active_at: new Date(Date.now() - 1800000).toISOString(),
    attempt_number: 2,
  },
  {
    id: "sess-003",
    test_type: "writing",
    test_id: "test-w-001",
    status: "completed",
    score_band: 6.5,
    progress_percent: 100,
    started_at: new Date(Date.now() - 172800000).toISOString(),
    completed_at: new Date(Date.now() - 169200000).toISOString(),
    last_active_at: new Date(Date.now() - 169200000).toISOString(),
    attempt_number: 1,
  },
];

// ─── Heatmap Mock ───────────────────────────────────

export const mockHeatmapDays = {
  "2025-01-05": 2,
  "2025-01-06": 1,
  "2025-01-07": 4,
  "2025-01-10": 1,
  "2025-01-15": 3,
};

// ─── Listening Exam Mocks ───────────────────────────

export const mockListeningQuestion = {
  id: "q1",
  type: "fill" as const,
  text: "The student's surname is ___",
  answer: "Blackwell",
  wordLimit: 2,
};

export const mockListeningMCQQuestion = {
  id: "q2",
  type: "mcq" as const,
  text: "Which service does the student choose?",
  answer: "Interlibrary loan",
  options: ["Online access", "Interlibrary loan", "Printing credit"],
};

export const mockListeningSection = {
  id: 1,
  title: "Section 1: Library Registration",
  subtitle: "A conversation between a student and a library assistant",
  context: "Social",
  instructions: "Complete the notes below.",
  questions: [mockListeningQuestion, mockListeningMCQQuestion],
};

export const mockListeningTest = {
  id: "L-001",
  title: "Mock Listening Test",
  totalTime: 1800,
  sections: [
    mockListeningSection,
    { ...mockListeningSection, id: 2, title: "Section 2", questions: [mockListeningMCQQuestion] },
    { ...mockListeningSection, id: 3, title: "Section 3", questions: [mockListeningQuestion] },
    { ...mockListeningSection, id: 4, title: "Section 4", questions: [mockListeningQuestion] },
  ],
};
