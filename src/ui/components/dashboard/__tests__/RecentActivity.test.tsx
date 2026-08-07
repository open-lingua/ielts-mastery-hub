import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";
import { MemoryRouter } from "react-router-dom";

vi.mock("@/contexts/AuthContext", () => ({
  useAuth: () => ({ user: null }),
}));

vi.mock("@/services/dashboardService", () => ({
  fetchRecentActivity: vi.fn().mockResolvedValue([]),
}));

import RecentActivity from "../RecentActivity";

describe("RecentActivity", () => {
  it("shows empty state when no user", async () => {
    render(
      <MemoryRouter>
        <RecentActivity />
      </MemoryRouter>
    );
    expect(await screen.findByText("No recent activity yet.")).toBeInTheDocument();
  });

  it("shows guidance text in empty state", async () => {
    render(
      <MemoryRouter>
        <RecentActivity />
      </MemoryRouter>
    );
    expect(
      await screen.findByText(/Start a practice test/)
    ).toBeInTheDocument();
  });
});
