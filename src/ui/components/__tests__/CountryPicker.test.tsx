import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";
import { CountryPicker } from "../CountryPicker";

describe("CountryPicker", () => {
  it("renders placeholder when no value selected", () => {
    render(<CountryPicker value="" onChange={vi.fn()} />);
    expect(screen.getByText("Select your country")).toBeInTheDocument();
  });

  it("renders the combobox trigger", () => {
    render(<CountryPicker value="" onChange={vi.fn()} />);
    expect(screen.getByRole("combobox")).toBeInTheDocument();
  });

  it("applies error styling when hasError is true", () => {
    render(<CountryPicker value="" onChange={vi.fn()} hasError />);
    const trigger = screen.getByRole("combobox");
    expect(trigger.className).toContain("border-destructive");
  });

  it("does not apply error styling when hasError is false", () => {
    render(<CountryPicker value="" onChange={vi.fn()} />);
    const trigger = screen.getByRole("combobox");
    expect(trigger.className).not.toContain("border-destructive");
  });

  it("opens dropdown on click", async () => {
    // Mock ResizeObserver for Radix Popover
    window.ResizeObserver = class {
      observe = vi.fn();
      unobserve = vi.fn();
      disconnect = vi.fn();
    };
    const user = userEvent.setup();
    render(<CountryPicker value="" onChange={vi.fn()} />);
    await user.click(screen.getByRole("combobox"));
    expect(screen.getByPlaceholderText("Search countries...")).toBeInTheDocument();
  });
});
