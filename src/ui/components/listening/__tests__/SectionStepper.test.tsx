import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";
import { TooltipProvider } from "@/components/ui/tooltip";
import SectionStepper from "../SectionStepper";

const wrap = (ui: React.ReactElement) => render(<TooltipProvider>{ui}</TooltipProvider>);

describe("SectionStepper", () => {
  const defaultProps = {
    totalSections: 4,
    activeSection: 0,
    completedSections: [false, false, false, false],
    unlockedSections: [true, false, false, false],
    onSectionClick: vi.fn(),
  };

  it("renders correct number of section buttons", () => {
    wrap(<SectionStepper {...defaultProps} />);
    const buttons = screen.getAllByRole("button");
    expect(buttons).toHaveLength(4);
  });

  it("disables locked sections", () => {
    wrap(<SectionStepper {...defaultProps} />);
    const buttons = screen.getAllByRole("button");
    expect(buttons[1]).toBeDisabled();
    expect(buttons[2]).toBeDisabled();
    expect(buttons[3]).toBeDisabled();
  });

  it("does not disable unlocked sections", () => {
    wrap(<SectionStepper {...defaultProps} />);
    expect(screen.getAllByRole("button")[0]).not.toBeDisabled();
  });

  it("calls onSectionClick for unlocked sections", async () => {
    const onClick = vi.fn();
    const user = userEvent.setup();
    wrap(<SectionStepper {...defaultProps} unlockedSections={[true, true, false, false]} onSectionClick={onClick} />);
    await user.click(screen.getAllByRole("button")[1]);
    expect(onClick).toHaveBeenCalledWith(1);
  });

  it("does not call onSectionClick for locked sections", async () => {
    const onClick = vi.fn();
    const user = userEvent.setup();
    wrap(<SectionStepper {...defaultProps} onSectionClick={onClick} />);
    await user.click(screen.getAllByRole("button")[2]);
    expect(onClick).not.toHaveBeenCalled();
  });

  it("renders connectors between sections", () => {
    const { container } = wrap(<SectionStepper {...defaultProps} />);
    const connectors = container.querySelectorAll(".h-0\\.5");
    expect(connectors).toHaveLength(3);
  });
});
