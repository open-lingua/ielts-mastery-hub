import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";

vi.mock("@/contexts/ThemeContext", () => ({
  useTheme: () => ({ theme: "light", toggleTheme: vi.fn() }),
}));

import { AuthDecorativePanel } from "../AuthDecorativePanel";

describe("AuthDecorativePanel", () => {
  it("renders the brand name", () => {
    render(<AuthDecorativePanel />);
    expect(screen.getByText("IELTS")).toBeInTheDocument();
    expect(screen.getByText("Mastery Hub")).toBeInTheDocument();
  });

  it("renders the Mandela quote", () => {
    render(<AuthDecorativePanel />);
    expect(
      screen.getByText(/Education is the most powerful weapon/)
    ).toBeInTheDocument();
  });

  it("renders stats cards", () => {
    render(<AuthDecorativePanel />);
    expect(screen.getByText("50K+")).toBeInTheDocument();
    expect(screen.getByText("7.5")).toBeInTheDocument();
    expect(screen.getByText("120+")).toBeInTheDocument();
  });

  it("renders the tagline", () => {
    render(<AuthDecorativePanel />);
    expect(screen.getByText("Your journey to Band 9 starts here")).toBeInTheDocument();
  });
});
