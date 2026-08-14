import { act, render, screen } from "@testing-library/react";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

// Mock the toast hook
vi.mock("@/hooks/use-toast", () => ({
  toast: vi.fn(),
}));

import UnifiedTimer from "../UnifiedTimer";

describe("UnifiedTimer", () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });
  afterEach(() => {
    vi.useRealTimers();
  });

  it("renders formatted time (MM:SS)", () => {
    render(<UnifiedTimer totalSeconds={3600} onTimeUp={vi.fn()} />);
    expect(screen.getByText("60:00")).toBeInTheDocument();
  });

  it("counts down every second", () => {
    render(<UnifiedTimer totalSeconds={120} onTimeUp={vi.fn()} />);
    expect(screen.getByText("02:00")).toBeInTheDocument();
    act(() => vi.advanceTimersByTime(1000));
    expect(screen.getByText("01:59")).toBeInTheDocument();
  });

  it("calls onTimeUp when reaching 0", () => {
    const onTimeUp = vi.fn();
    render(<UnifiedTimer totalSeconds={2} onTimeUp={onTimeUp} />);
    act(() => vi.advanceTimersByTime(2000));
    expect(onTimeUp).toHaveBeenCalledTimes(1);
  });

  it("pauses when isPaused is true", () => {
    render(<UnifiedTimer totalSeconds={60} onTimeUp={vi.fn()} isPaused />);
    act(() => vi.advanceTimersByTime(5000));
    expect(screen.getByText("01:00")).toBeInTheDocument();
  });

  it("returns null when testFinished is true", () => {
    const { container } = render(<UnifiedTimer totalSeconds={60} onTimeUp={vi.fn()} testFinished />);
    expect(container.innerHTML).toBe("");
  });

  it("applies warning color under 5 minutes", () => {
    render(<UnifiedTimer totalSeconds={299} onTimeUp={vi.fn()} />);
    // 299 seconds = warning zone (< 300, > 60)
    const timerText = screen.getByText("04:59");
    expect(timerText.className).toContain("text-warning");
  });

  it("applies urgent/destructive color under 1 minute", () => {
    render(<UnifiedTimer totalSeconds={59} onTimeUp={vi.fn()} />);
    const timerText = screen.getByText("00:59");
    expect(timerText.className).toContain("text-destructive");
  });

  it("renders progress bar by default", () => {
    const { container } = render(<UnifiedTimer totalSeconds={60} onTimeUp={vi.fn()} />);
    // Progress component renders with role="progressbar"
    expect(container.querySelector('[role="progressbar"]')).not.toBeNull();
  });

  it("hides progress bar when showProgressBar is false", () => {
    const { container } = render(<UnifiedTimer totalSeconds={60} onTimeUp={vi.fn()} showProgressBar={false} />);
    expect(container.querySelector('[role="progressbar"]')).toBeNull();
  });
});
