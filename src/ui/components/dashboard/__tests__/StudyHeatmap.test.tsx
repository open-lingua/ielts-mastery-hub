import { render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";

vi.mock("@/contexts/AuthContext", () => ({
  useAuth: () => ({ user: null }),
}));

import StudyHeatmap from "../StudyHeatmap";

describe("StudyHeatmap", () => {
  it("renders the title", () => {
    render(<StudyHeatmap />);
    expect(screen.getByText("Consistency Tracker")).toBeInTheDocument();
  });

  it("renders the legend", async () => {
    render(<StudyHeatmap />);
    expect(await screen.findByText("Less")).toBeInTheDocument();
    expect(screen.getByText("More")).toBeInTheDocument();
  });

  it("renders stats footer", async () => {
    render(<StudyHeatmap />);
    expect(await screen.findByText(/Total:/)).toBeInTheDocument();
    expect(screen.getByText(/Longest Streak:/)).toBeInTheDocument();
  });

  it("renders year selector", () => {
    render(<StudyHeatmap />);
    const currentYear = new Date().getFullYear();
    expect(screen.getByText(String(currentYear))).toBeInTheDocument();
  });
});
