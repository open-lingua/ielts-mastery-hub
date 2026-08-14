import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";
import { mockListeningMCQQuestion, mockListeningQuestion } from "@/test/mockTestData";
import QuestionCard from "../QuestionCard";

describe("QuestionCard", () => {
  it("renders fill-type question text", () => {
    render(
      <QuestionCard
        question={mockListeningQuestion}
        index={1}
        answer=""
        onAnswer={vi.fn()}
        submitted={false}
        reviewMode={false}
      />
    );
    expect(screen.getByText(/student's surname/)).toBeInTheDocument();
  });

  it("renders input for fill-type question", () => {
    render(
      <QuestionCard
        question={mockListeningQuestion}
        index={1}
        answer=""
        onAnswer={vi.fn()}
        submitted={false}
        reviewMode={false}
      />
    );
    expect(screen.getByPlaceholderText("Type your answer...")).toBeInTheDocument();
  });

  it("calls onAnswer when typing in fill question", async () => {
    const onAnswer = vi.fn();
    const user = userEvent.setup();
    render(
      <QuestionCard
        question={mockListeningQuestion}
        index={1}
        answer=""
        onAnswer={onAnswer}
        submitted={false}
        reviewMode={false}
      />
    );
    await user.type(screen.getByPlaceholderText("Type your answer..."), "B");
    expect(onAnswer).toHaveBeenCalled();
  });

  it("renders MCQ options", () => {
    render(
      <QuestionCard
        question={mockListeningMCQQuestion}
        index={1}
        answer=""
        onAnswer={vi.fn()}
        submitted={false}
        reviewMode={false}
      />
    );
    expect(screen.getByText("Online access")).toBeInTheDocument();
    expect(screen.getByText("Interlibrary loan")).toBeInTheDocument();
    expect(screen.getByText("Printing credit")).toBeInTheDocument();
  });

  it("calls onAnswer when clicking MCQ option", async () => {
    const onAnswer = vi.fn();
    const user = userEvent.setup();
    render(
      <QuestionCard
        question={mockListeningMCQQuestion}
        index={1}
        answer=""
        onAnswer={onAnswer}
        submitted={false}
        reviewMode={false}
      />
    );
    await user.click(screen.getByText("Interlibrary loan"));
    expect(onAnswer).toHaveBeenCalledWith("Interlibrary loan");
  });

  it("disables input when submitted", () => {
    render(
      <QuestionCard
        question={mockListeningQuestion}
        index={1}
        answer="Blackwell"
        onAnswer={vi.fn()}
        submitted={true}
        reviewMode={false}
      />
    );
    expect(screen.getByPlaceholderText("Type your answer...")).toBeDisabled();
  });

  it("shows correct feedback in review mode", () => {
    render(
      <QuestionCard
        question={mockListeningQuestion}
        index={1}
        answer="Blackwell"
        onAnswer={vi.fn()}
        submitted={true}
        reviewMode={true}
      />
    );
    expect(screen.getByText("✓ Correct")).toBeInTheDocument();
  });

  it("shows incorrect feedback in review mode", () => {
    render(
      <QuestionCard
        question={mockListeningQuestion}
        index={1}
        answer="Wrong"
        onAnswer={vi.fn()}
        submitted={true}
        reviewMode={true}
      />
    );
    expect(screen.getByText(/Correct answer: Blackwell/)).toBeInTheDocument();
  });

  it("shows word limit hint", () => {
    render(
      <QuestionCard
        question={mockListeningQuestion}
        index={1}
        answer=""
        onAnswer={vi.fn()}
        submitted={false}
        reviewMode={false}
      />
    );
    expect(screen.getByText(/no more than 2 words/)).toBeInTheDocument();
  });
});
