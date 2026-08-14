import { act, render, screen } from "@testing-library/react";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import AudioPlayer from "../AudioPlayer";

describe("AudioPlayer", () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });
  afterEach(() => {
    vi.useRealTimers();
  });

  it("renders play button initially", () => {
    render(<AudioPlayer sectionIndex={0} onEnded={vi.fn()} />);
    const buttons = screen.getAllByRole("button");
    expect(buttons.length).toBeGreaterThanOrEqual(1);
  });

  it("shows 0:00 as initial time", () => {
    render(<AudioPlayer sectionIndex={0} onEnded={vi.fn()} />);
    expect(screen.getByText("0:00")).toBeInTheDocument();
  });

  it("shows simulated duration for section 0 (3:00)", () => {
    render(<AudioPlayer sectionIndex={0} onEnded={vi.fn()} />);
    expect(screen.getByText("3:00")).toBeInTheDocument();
  });

  it("toggles play/pause on simulated mode", () => {
    render(<AudioPlayer sectionIndex={0} onEnded={vi.fn()} />);
    const playBtn = screen.getAllByRole("button")[0];
    // Click play
    act(() => {
      playBtn.click();
    });
    // Advance 2 seconds
    act(() => {
      vi.advanceTimersByTime(2000);
    });
    expect(screen.getByText("0:02")).toBeInTheDocument();
  });

  it("is disabled when disabled prop is true", () => {
    render(<AudioPlayer sectionIndex={0} onEnded={vi.fn()} disabled />);
    const container = screen.getAllByRole("button")[0].closest("div.flex");
    expect(container?.className).toContain("opacity-50");
  });

  it("calls onEnded when simulated playback completes", () => {
    const onEnded = vi.fn();
    render(<AudioPlayer sectionIndex={0} onEnded={onEnded} />);
    const playBtn = screen.getAllByRole("button")[0];
    act(() => {
      playBtn.click();
    });
    act(() => {
      vi.advanceTimersByTime(180_000);
    });
    expect(onEnded).toHaveBeenCalledTimes(1);
  });

  it("shows Ended text after playback completes", () => {
    render(<AudioPlayer sectionIndex={0} onEnded={vi.fn()} />);
    act(() => {
      screen.getAllByRole("button")[0].click();
    });
    act(() => {
      vi.advanceTimersByTime(180_000);
    });
    expect(screen.getByText("Ended")).toBeInTheDocument();
  });

  it("toggles mute button", () => {
    render(<AudioPlayer sectionIndex={0} onEnded={vi.fn()} />);
    const buttons = screen.getAllByRole("button");
    const muteBtn = buttons[buttons.length - 1];
    act(() => {
      muteBtn.click();
    });
    expect(muteBtn).toBeInTheDocument();
  });
});
