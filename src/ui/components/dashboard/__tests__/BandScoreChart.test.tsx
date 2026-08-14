import { render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";

vi.mock("@/contexts/AuthContext", () => ({
  useAuth: () => ({ user: null }),
}));

vi.mock("@/integrations/supabase/client", () => ({
  supabase: {
    from: () => ({
      select: () => ({
        eq: () => ({
          eq: () => ({
            not: () => ({
              not: () => ({
                order: () => Promise.resolve({ data: [] }),
              }),
            }),
          }),
        }),
      }),
    }),
  },
}));

import BandScoreChart from "../BandScoreChart";

describe("BandScoreChart", () => {
  it("renders the title", async () => {
    render(<BandScoreChart />);
    expect(screen.getByText("Band Score Progress")).toBeInTheDocument();
  });

  it("shows empty state when no user", async () => {
    render(<BandScoreChart />);
    // Wait for loading to finish
    expect(await screen.findByText("No scores yet.")).toBeInTheDocument();
  });

  it("shows instruction text in empty state", async () => {
    render(<BandScoreChart />);
    expect(await screen.findByText(/Complete a test to see your band score progress/)).toBeInTheDocument();
  });
});
