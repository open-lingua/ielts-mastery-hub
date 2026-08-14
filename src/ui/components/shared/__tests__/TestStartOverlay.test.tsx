import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";
import TestStartOverlay from "../TestStartOverlay";

const defaultProps = {
  isStarted: false,
  onStart: vi.fn(),
  title: "IELTS Academic Reading - Test 1",
  module: "reading" as const,
  sections: "3 Passages",
  questions: "40 Questions",
  durationMinutes: 60,
};

describe("TestStartOverlay", () => {
  it("renders overlay with title when not started", () => {
    render(
      <TestStartOverlay {...defaultProps}>
        <div>Test Content</div>
      </TestStartOverlay>
    );
    expect(screen.getByText("IELTS Academic Reading - Test 1")).toBeInTheDocument();
  });

  it("renders metadata badges", () => {
    render(
      <TestStartOverlay {...defaultProps}>
        <div>X</div>
      </TestStartOverlay>
    );
    expect(screen.getByText("3 Passages")).toBeInTheDocument();
    expect(screen.getByText("40 Questions")).toBeInTheDocument();
    expect(screen.getByText("60 Minutes")).toBeInTheDocument();
  });

  it("renders default instructions for reading", () => {
    render(
      <TestStartOverlay {...defaultProps}>
        <div>X</div>
      </TestStartOverlay>
    );
    expect(screen.getByText(/60 minutes to complete/)).toBeInTheDocument();
  });

  it("renders Start Now button", () => {
    render(
      <TestStartOverlay {...defaultProps}>
        <div>X</div>
      </TestStartOverlay>
    );
    expect(screen.getByText("Start Now")).toBeInTheDocument();
  });

  it("calls onStart when button clicked", async () => {
    const onStart = vi.fn();
    const user = userEvent.setup();
    render(
      <TestStartOverlay {...defaultProps} onStart={onStart}>
        <div>X</div>
      </TestStartOverlay>
    );
    await user.click(screen.getByText("Start Now"));
    expect(onStart).toHaveBeenCalledTimes(1);
  });

  it("hides overlay when isStarted is true", () => {
    render(
      <TestStartOverlay {...defaultProps} isStarted={true}>
        <div>Test Content</div>
      </TestStartOverlay>
    );
    expect(screen.queryByText("Start Now")).not.toBeInTheDocument();
    expect(screen.getByText("Test Content")).toBeInTheDocument();
  });

  it("blurs children when not started", () => {
    const { container } = render(
      <TestStartOverlay {...defaultProps}>
        <div>X</div>
      </TestStartOverlay>
    );
    const blurredDiv = container.querySelector(".blur-lg");
    expect(blurredDiv).not.toBeNull();
  });

  it("renders custom instructions when provided", () => {
    render(
      <TestStartOverlay {...defaultProps} instructions={["Custom rule 1", "Custom rule 2"]}>
        <div>X</div>
      </TestStartOverlay>
    );
    expect(screen.getByText("Custom rule 1")).toBeInTheDocument();
    expect(screen.getByText("Custom rule 2")).toBeInTheDocument();
  });
});
