import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";
import { MemoryRouter } from "react-router-dom";

vi.mock("@/contexts/ThemeContext", () => ({
  useTheme: () => ({ theme: "light", toggleTheme: vi.fn() }),
}));

vi.mock("@/contexts/AuthContext", () => ({
  useAuth: () => ({
    user: { id: "u1", email: "test@test.com" },
    profile: { full_name: "Test User", avatar_url: null, plan_type: "free" },
    isAuthenticated: true,
    isLoading: false,
    signOut: vi.fn(),
  }),
}));

vi.mock("@/hooks/useUserRole", () => ({
  useUserRole: () => ({ role: "student", isAdmin: false, isLoading: false }),
}));

import { DashboardLayout } from "../DashboardLayout";

describe("DashboardLayout", () => {
  it("renders children", () => {
    render(
      <MemoryRouter>
        <DashboardLayout>
          <div>Child Content</div>
        </DashboardLayout>
      </MemoryRouter>
    );
    expect(screen.getByText("Child Content")).toBeInTheDocument();
  });

  it("renders sidebar navigation", () => {
    render(
      <MemoryRouter>
        <DashboardLayout>
          <div>X</div>
        </DashboardLayout>
      </MemoryRouter>
    );
    expect(screen.getByText("Test Library")).toBeInTheDocument();
    expect(screen.getByText("Writing")).toBeInTheDocument();
    expect(screen.getByText("Reading")).toBeInTheDocument();
    expect(screen.getByText("Listening")).toBeInTheDocument();
  });

  it("shows user initials when authenticated", () => {
    render(
      <MemoryRouter>
        <DashboardLayout>
          <div>X</div>
        </DashboardLayout>
      </MemoryRouter>
    );
    expect(screen.getByText("TU")).toBeInTheDocument();
  });

  it("hides Admin Portal for non-admin users", () => {
    render(
      <MemoryRouter>
        <DashboardLayout>
          <div>X</div>
        </DashboardLayout>
      </MemoryRouter>
    );
    expect(screen.queryByText("Admin Portal")).not.toBeInTheDocument();
  });

  it("renders premium CTA", () => {
    render(
      <MemoryRouter>
        <DashboardLayout>
          <div>X</div>
        </DashboardLayout>
      </MemoryRouter>
    );
    expect(screen.getByText("Go Premium ✨")).toBeInTheDocument();
  });
});
