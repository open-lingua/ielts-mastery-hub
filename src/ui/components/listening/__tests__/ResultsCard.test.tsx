import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";
import { mockListeningTest } from "@/test/mockTestData";
import ResultsCard from "../ResultsCard";

const allCorrect: Record<string, string> = {};
mockListeningTest.sections.forEach((s) =>
  s.questions.forEach((q) => {
    allCorrect[q.id] = q.answer;
  })
);

describe("ResultsCard", () => {
  it("renders estimated band score", () => {
    render(
      <ResultsCard
        test={mockListeningTest}
        answers={allCorrect}
        reviewMode={false}
        onToggleReview={vi.fn()}
        onRetry={vi.fn()}
      />
    );
    expect(screen.getByText("Estimated Band Score")).toBeInTheDocument();
  });

  it("renders total correct count", () => {
    render(
      <ResultsCard
        test={mockListeningTest}
        answers={allCorrect}
        reviewMode={false}
        onToggleReview={vi.fn()}
        onRetry={vi.fn()}
      />
    );
    const totalQuestions = mockListeningTest.sections.reduce((a, s) => a + s.questions.length, 0);
    expect(screen.getByText(`${totalQuestions}/${totalQuestions}`)).toBeInTheDocument();
  });

  it("renders section breakdown", () => {
    render(
      <ResultsCard
        test={mockListeningTest}
        answers={{}}
        reviewMode={false}
        onToggleReview={vi.fn()}
        onRetry={vi.fn()}
      />
    );
    expect(screen.getByText("S1")).toBeInTheDocument();
    expect(screen.getByText("S2")).toBeInTheDocument();
  });

  it("shows Review Answers button", () => {
    render(
      <ResultsCard
        test={mockListeningTest}
        answers={{}}
        reviewMode={false}
        onToggleReview={vi.fn()}
        onRetry={vi.fn()}
      />
    );
    expect(screen.getByText("Review Answers")).toBeInTheDocument();
  });

  it("shows Hide Answers button in review mode", () => {
    render(
      <ResultsCard test={mockListeningTest} answers={{}} reviewMode={true} onToggleReview={vi.fn()} onRetry={vi.fn()} />
    );
    expect(screen.getByText("Hide Answers")).toBeInTheDocument();
  });

  it("calls onRetry when Try Again is clicked", async () => {
    const onRetry = vi.fn();
    const user = userEvent.setup();
    render(
      <ResultsCard
        test={mockListeningTest}
        answers={{}}
        reviewMode={false}
        onToggleReview={vi.fn()}
        onRetry={onRetry}
      />
    );
    await user.click(screen.getByText("Try Again"));
    expect(onRetry).toHaveBeenCalled();
  });

  it("renders back to library button when callback provided", () => {
    render(
      <ResultsCard
        test={mockListeningTest}
        answers={{}}
        reviewMode={false}
        onToggleReview={vi.fn()}
        onRetry={vi.fn()}
        onBackToLibrary={vi.fn()}
      />
    );
    expect(screen.getByText("← Return to Practice Library")).toBeInTheDocument();
  });
});
