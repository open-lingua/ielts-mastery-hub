import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import type React from "react";
import { describe, expect, it, vi } from "vitest";
import { TooltipProvider } from "@/components/ui/tooltip";
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

const renderOverlay = (ui: React.ReactElement) => render(<TooltipProvider>{ui}</TooltipProvider>);

describe("TestStartOverlay", () => {
  it("renders overlay with title when not started", () => {
    renderOverlay(
      <TestStartOverlay {...defaultProps}>
        <div>Test Content</div>
      </TestStartOverlay>
    );
    expect(screen.getByText("IELTS Academic Reading - Test 1")).toBeInTheDocument();
  });

  it("renders metadata badges", () => {
    renderOverlay(
      <TestStartOverlay {...defaultProps}>
        <div>X</div>
      </TestStartOverlay>
    );
    expect(screen.getByText("3 Passages")).toBeInTheDocument();
    expect(screen.getByText("40 Questions")).toBeInTheDocument();
    expect(screen.getByText("60 Minutes")).toBeInTheDocument();
  });

  it("renders default instructions for reading", () => {
    renderOverlay(
      <TestStartOverlay {...defaultProps}>
        <div>X</div>
      </TestStartOverlay>
    );
    expect(screen.getByText(/60 minutes to complete/)).toBeInTheDocument();
  });

  it("renders Start Now button", () => {
    renderOverlay(
      <TestStartOverlay {...defaultProps}>
        <div>X</div>
      </TestStartOverlay>
    );
    expect(screen.getByText("Start Now")).toBeInTheDocument();
  });

  it("calls onStart when button clicked", async () => {
    const onStart = vi.fn();
    const user = userEvent.setup();
    renderOverlay(
      <TestStartOverlay {...defaultProps} onStart={onStart}>
        <div>X</div>
      </TestStartOverlay>
    );
    await user.click(screen.getByText("Start Now"));
    expect(onStart).toHaveBeenCalledTimes(1);
  });

  it("hides overlay when isStarted is true", () => {
    renderOverlay(
      <TestStartOverlay {...defaultProps} isStarted={true}>
        <div>Test Content</div>
      </TestStartOverlay>
    );
    expect(screen.queryByText("Start Now")).not.toBeInTheDocument();
    expect(screen.getByText("Test Content")).toBeInTheDocument();
  });

  it("blurs children when not started", () => {
    const { container } = renderOverlay(
      <TestStartOverlay {...defaultProps}>
        <div>X</div>
      </TestStartOverlay>
    );
    const blurredDiv = container.querySelector(".blur-lg");
    expect(blurredDiv).not.toBeNull();
  });

  it("renders custom instructions when provided", () => {
    renderOverlay(
      <TestStartOverlay {...defaultProps} instructions={["Custom rule 1", "Custom rule 2"]}>
        <div>X</div>
      </TestStartOverlay>
    );
    expect(screen.getByText("Custom rule 1")).toBeInTheDocument();
    expect(screen.getByText("Custom rule 2")).toBeInTheDocument();
  });

  describe("locked state", () => {
    it("disables the Start button and shows the lock banner when locked", () => {
      renderOverlay(
        <TestStartOverlay
          {...defaultProps}
          locked
          lockTitle="AI configuration required"
          lockMessage="Set up an active AI configuration first."
        >
          <div>X</div>
        </TestStartOverlay>
      );
      expect(screen.getByText("Start Now").closest("button")).toBeDisabled();
      expect(screen.getByText("AI configuration required")).toBeInTheDocument();
      expect(screen.getByText("Set up an active AI configuration first.")).toBeInTheDocument();
    });

    it("does not show the lock banner when unlocked", () => {
      renderOverlay(
        <TestStartOverlay {...defaultProps}>
          <div>X</div>
        </TestStartOverlay>
      );
      expect(screen.getByText("Start Now").closest("button")).not.toBeDisabled();
      expect(screen.queryByText("Action required")).not.toBeInTheDocument();
    });

    it("does not call onStart when the disabled Start button is clicked", async () => {
      const onStart = vi.fn();
      const user = userEvent.setup();
      renderOverlay(
        <TestStartOverlay {...defaultProps} onStart={onStart} locked>
          <div>X</div>
        </TestStartOverlay>
      );
      await user.click(screen.getByText("Start Now"));
      expect(onStart).not.toHaveBeenCalled();
    });

    it("calls onLockAction when the banner action button is clicked", async () => {
      const onLockAction = vi.fn();
      const user = userEvent.setup();
      renderOverlay(
        <TestStartOverlay
          {...defaultProps}
          locked
          lockActionLabel="Go to AI Configurations"
          onLockAction={onLockAction}
        >
          <div>X</div>
        </TestStartOverlay>
      );
      await user.click(screen.getByText("Go to AI Configurations"));
      expect(onLockAction).toHaveBeenCalledTimes(1);
    });
  });

  it("renders preStartContent between instructions and the Start button", () => {
    renderOverlay(
      <TestStartOverlay {...defaultProps} preStartContent={<div>Take this test without AI scoring</div>}>
        <div>X</div>
      </TestStartOverlay>
    );
    expect(screen.getByText("Take this test without AI scoring")).toBeInTheDocument();
  });
});
