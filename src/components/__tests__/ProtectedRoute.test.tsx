import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";
import { MemoryRouter } from "react-router-dom";

// Mock useAuth
const mockUseAuth = vi.fn();
vi.mock("@/contexts/AuthContext", () => ({
  useAuth: () => mockUseAuth(),
}));

import { ProtectedRoute } from "../ProtectedRoute";

const renderWithRouter = (ui: React.ReactElement) =>
  render(<MemoryRouter>{ui}</MemoryRouter>);

describe("ProtectedRoute", () => {
  it("shows loading spinner while auth is loading", () => {
    mockUseAuth.mockReturnValue({ isAuthenticated: false, isLoading: true });
    renderWithRouter(<ProtectedRoute><div>Protected</div></ProtectedRoute>);
    expect(screen.queryByText("Protected")).not.toBeInTheDocument();
  });

  it("redirects to /login when unauthenticated", () => {
    mockUseAuth.mockReturnValue({ isAuthenticated: false, isLoading: false });
    renderWithRouter(<ProtectedRoute><div>Protected</div></ProtectedRoute>);
    expect(screen.queryByText("Protected")).not.toBeInTheDocument();
  });

  it("renders children when authenticated", () => {
    mockUseAuth.mockReturnValue({ isAuthenticated: true, isLoading: false });
    renderWithRouter(<ProtectedRoute><div>Protected</div></ProtectedRoute>);
    expect(screen.getByText("Protected")).toBeInTheDocument();
  });
});
