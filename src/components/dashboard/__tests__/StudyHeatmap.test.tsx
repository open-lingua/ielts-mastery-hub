import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";

vi.mock("@/contexts/AuthContext", () => ({
  useAuth: () => ({ user: null }),
}));

vi.mock("@/integrations/supabase/client", () => ({
  supabase: {
    from: () => ({
      select: () => ({
        eq: () => ({
          order: () => Promise.resolve({ data: [] }),
          gte: () => ({
            lte: () => Promise.resolve({ data: [] }),
          }),
        }),
      }),
    }),
  },
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
