import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { MemoryRouter, Route, Routes } from "react-router-dom";
import { beforeEach, describe, expect, it, vi } from "vitest";
import { TooltipProvider } from "@/components/ui/tooltip";
import { gradeWritingTest, persistFeedback } from "@/services/aiGradingService";
import { fetchAiConfigurations } from "@/services/aiConfigurationService";
import { fetchActiveSession, fetchExistingSession, startTestSession } from "@/services/practiceLibraryService";
import { fetchWritingTestForPractice, submitWritingTest } from "@/services/writingPracticeService";

vi.mock("@/services/aiConfigurationService", () => ({
  fetchAiConfigurations: vi.fn(),
}));

vi.mock("@/services/writingPracticeService", () => ({
  fetchWritingTestForPractice: vi.fn(),
  submitWritingTest: vi.fn(),
}));

vi.mock("@/services/practiceLibraryService", () => ({
  fetchActiveSession: vi.fn(),
  fetchExistingSession: vi.fn(),
  startTestSession: vi.fn(),
}));

vi.mock("@/services/aiGradingService", () => ({
  gradeWritingTest: vi.fn(),
  persistFeedback: vi.fn(),
}));

vi.mock("@/lib/tauri", async () => {
  const actual = await vi.importActual<object>("@/lib/tauri");
  return {
    ...actual,
    deleteUserTestSession: vi.fn().mockResolvedValue(undefined),
    updateUserTestSession: vi.fn().mockResolvedValue(undefined),
  };
});

import WritingSimulator from "../WritingSimulator";

const mockFetchAiConfigurations = vi.mocked(fetchAiConfigurations);
const mockFetchWritingTestForPractice = vi.mocked(fetchWritingTestForPractice);
const mockFetchActiveSession = vi.mocked(fetchActiveSession);
const mockFetchExistingSession = vi.mocked(fetchExistingSession);
const mockStartTestSession = vi.mocked(startTestSession);
const mockSubmitWritingTest = vi.mocked(submitWritingTest);
const mockGradeWritingTest = vi.mocked(gradeWritingTest);
const mockPersistFeedback = vi.mocked(persistFeedback);

const mockTestData = {
  id: "test-1",
  title: "IELTS Writing - Test 1",
  tasks: [
    {
      id: "task-1",
      taskType: "task1" as const,
      title: "Task 1",
      difficulty: "Medium",
      suggestedTime: "20 minutes",
      prompt: "Describe the chart.",
      minWords: 150,
      maxWords: "N/A",
      imageUrl: "",
      includeModelAnswer: false,
      modelAnswer: "",
    },
    {
      id: "task-2",
      taskType: "task2" as const,
      title: "Task 2",
      difficulty: "Medium",
      suggestedTime: "40 minutes",
      prompt: "Write an essay.",
      minWords: 250,
      maxWords: "N/A",
      imageUrl: "",
      includeModelAnswer: false,
      modelAnswer: "",
    },
  ],
};

const renderPage = () =>
  render(
    <MemoryRouter initialEntries={["/writing?id=test-1"]}>
      <TooltipProvider>
        <Routes>
          <Route path="/writing" element={<WritingSimulator />} />
        </Routes>
      </TooltipProvider>
    </MemoryRouter>
  );

describe("WritingSimulator — AI configuration gate", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockFetchWritingTestForPractice.mockResolvedValue(mockTestData);
    mockFetchExistingSession.mockResolvedValue(null);
    mockFetchActiveSession.mockResolvedValue(null);
  });

  it("locks the Start button when there is no active AI configuration", async () => {
    mockFetchAiConfigurations.mockResolvedValue({ configuredMap: {}, activeProviderId: null });
    renderPage();

    await waitFor(() => expect(screen.getByText("Start Now").closest("button")).toBeDisabled());
    expect(screen.getByText("AI configuration required")).toBeInTheDocument();
    expect(screen.getByText("Go to AI Configurations")).toBeInTheDocument();
  });

  it("enables the Start button when an AI configuration is active", async () => {
    mockFetchAiConfigurations.mockResolvedValue({ configuredMap: { claude: true }, activeProviderId: "claude" });
    renderPage();

    await waitFor(() => expect(screen.getByText("Start Now").closest("button")).not.toBeDisabled());
    expect(screen.queryByText("AI configuration required")).not.toBeInTheDocument();
  });

  it("enables the Start button when 'unscored' is checked, even without an active AI configuration", async () => {
    mockFetchAiConfigurations.mockResolvedValue({ configuredMap: {}, activeProviderId: null });
    const user = userEvent.setup();
    renderPage();

    await waitFor(() => expect(screen.getByText("Start Now").closest("button")).toBeDisabled());

    await user.click(screen.getByLabelText("Take this test without AI scoring"));

    await waitFor(() => expect(screen.getByText("Start Now").closest("button")).not.toBeDisabled());
    expect(screen.queryByText("AI configuration required")).not.toBeInTheDocument();
  });

  it("skips AI grading and shows the unscored fallback when 'unscored' is checked at submission", async () => {
    mockFetchAiConfigurations.mockResolvedValue({ configuredMap: {}, activeProviderId: null });
    mockStartTestSession.mockResolvedValue({
      id: "session-1",
      started_at: new Date().toISOString(),
      status: "in_progress",
      progress_percent: 0,
      score_band: null,
      attempt_number: 1,
    });
    mockSubmitWritingTest.mockResolvedValue(undefined);
    const user = userEvent.setup();
    renderPage();

    await waitFor(() => expect(screen.getByLabelText("Take this test without AI scoring")).toBeInTheDocument());
    await user.click(screen.getByLabelText("Take this test without AI scoring"));
    await waitFor(() => expect(screen.getByText("Start Now").closest("button")).not.toBeDisabled());
    await user.click(screen.getByText("Start Now"));

    await waitFor(() => expect(screen.getByPlaceholderText("Begin your response here...")).toBeInTheDocument());
    await user.type(screen.getByPlaceholderText("Begin your response here..."), "Task 1 response.");
    await user.click(screen.getByText("Go to Task 2 →"));
    await waitFor(() => expect(screen.getByPlaceholderText("Start typing your essay here...")).toBeInTheDocument());
    await user.type(screen.getByPlaceholderText("Start typing your essay here..."), "Task 2 response.");

    await user.click(screen.getByText("Submit Test"));

    await waitFor(() => expect(mockSubmitWritingTest).toHaveBeenCalledTimes(1));
    expect(mockGradeWritingTest).not.toHaveBeenCalled();
    expect(mockPersistFeedback).not.toHaveBeenCalled();
    expect(screen.getByText(/You chose to skip AI scoring/)).toBeInTheDocument();
  });
});
