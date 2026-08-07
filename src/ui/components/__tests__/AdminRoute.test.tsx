import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";
import { MemoryRouter } from "react-router-dom";

const mockUseAuth = vi.fn();
const mockUseUserRole = vi.fn();

vi.mock("@/contexts/AuthContext", () => ({
  useAuth: () => mockUseAuth(),
}));
vi.mock("@/hooks/useUserRole", () => ({
  useUserRole: () => mockUseUserRole(),
}));

import { AdminRoute } from "../AdminRoute";

const renderWithRouter = (ui: React.ReactElement) =>
  render(<MemoryRouter>{ui}</MemoryRouter>);

describe("AdminRoute", () => {
  it("shows spinner while loading auth", () => {
    mockUseAuth.mockReturnValue({ isAuthenticated: false, isLoading: true });
    mockUseUserRole.mockReturnValue({ isAdmin: false, isLoading: false });
    renderWithRouter(<AdminRoute><div>Admin</div></AdminRoute>);
    expect(screen.queryByText("Admin")).not.toBeInTheDocument();
  });

  it("shows spinner while loading role", () => {
    mockUseAuth.mockReturnValue({ isAuthenticated: true, isLoading: false });
    mockUseUserRole.mockReturnValue({ isAdmin: false, isLoading: true });
    renderWithRouter(<AdminRoute><div>Admin</div></AdminRoute>);
    expect(screen.queryByText("Admin")).not.toBeInTheDocument();
  });

  it("redirects unauthenticated users to /login", () => {
    mockUseAuth.mockReturnValue({ isAuthenticated: false, isLoading: false });
    mockUseUserRole.mockReturnValue({ isAdmin: false, isLoading: false });
    renderWithRouter(<AdminRoute><div>Admin</div></AdminRoute>);
    expect(screen.queryByText("Admin")).not.toBeInTheDocument();
  });

  it("redirects non-admin users to /dashboard", () => {
    mockUseAuth.mockReturnValue({ isAuthenticated: true, isLoading: false });
    mockUseUserRole.mockReturnValue({ isAdmin: false, isLoading: false });
    renderWithRouter(<AdminRoute><div>Admin</div></AdminRoute>);
    expect(screen.queryByText("Admin")).not.toBeInTheDocument();
  });

  it("renders children for authenticated admin", () => {
    mockUseAuth.mockReturnValue({ isAuthenticated: true, isLoading: false });
    mockUseUserRole.mockReturnValue({ isAdmin: true, isLoading: false });
    renderWithRouter(<AdminRoute><div>Admin</div></AdminRoute>);
    expect(screen.getByText("Admin")).toBeInTheDocument();
  });
});
