import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { MemoryRouter } from "react-router-dom";
import { describe, expect, it, vi } from "vitest";
import { TooltipProvider } from "@/components/ui/tooltip";

vi.mock("@/contexts/ThemeContext", () => ({
  useTheme: () => ({ theme: "light", toggleTheme: vi.fn() }),
}));

import { AdminLayout } from "../AdminLayout";

const renderWithRouter = (path = "/admin") =>
  render(
    <MemoryRouter initialEntries={[path]}>
      <TooltipProvider>
        <AdminLayout>
          <div data-testid="child-content">Admin Content</div>
        </AdminLayout>
      </TooltipProvider>
    </MemoryRouter>
  );

describe("AdminLayout", () => {
  it("renders child content", () => {
    renderWithRouter();
    expect(screen.getByTestId("child-content")).toBeInTheDocument();
  });

  it("renders sidebar navigation items", () => {
    renderWithRouter();
    expect(screen.getByText("Dashboard")).toBeInTheDocument();
    expect(screen.getByText("Content Library")).toBeInTheDocument();
    expect(screen.getByText("Create New")).toBeInTheDocument();
    expect(screen.getByText("Import Dataset")).toBeInTheDocument();
  });

  it("renders the brand label", () => {
    renderWithRouter();
    expect(screen.getByText("Admin Portal")).toBeInTheDocument();
  });

  it("renders Back to App link", () => {
    renderWithRouter();
    expect(screen.getByText("Back to App")).toBeInTheDocument();
  });

  it("highlights active nav item", () => {
    renderWithRouter("/admin/content");
    const contentLink = screen.getByText("Content Library").closest("a");
    expect(contentLink?.className).toContain("violet");
  });

  it("toggles sidebar collapse", async () => {
    const user = userEvent.setup();
    renderWithRouter();
    const toggle = screen.getByLabelText("Toggle Sidebar");
    await user.click(toggle);
    // After collapse, "Admin Portal" brand text should be hidden
    expect(screen.queryByText("Admin Portal")).not.toBeInTheDocument();
  });
});
