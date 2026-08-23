import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { MemoryRouter } from "react-router-dom";
import { describe, expect, it, vi } from "vitest";

vi.mock("@/contexts/ThemeContext", () => ({
  useTheme: () => ({ theme: "light", toggleTheme: vi.fn() }),
}));

import { DashboardLayout } from "../DashboardLayout";

const renderWithRouter = (path = "/dashboard") =>
  render(
    <MemoryRouter initialEntries={[path]}>
      <DashboardLayout>
        <div data-testid="child-content">Dashboard Content</div>
      </DashboardLayout>
    </MemoryRouter>
  );

describe("DashboardLayout", () => {
  it("renders child content", () => {
    renderWithRouter();
    expect(screen.getByTestId("child-content")).toBeInTheDocument();
  });

  it("renders sidebar navigation items", () => {
    renderWithRouter();
    expect(screen.getByText("Dashboard")).toBeInTheDocument();
    expect(screen.getByText("Test Library")).toBeInTheDocument();
    expect(screen.getByText("Admin Portal")).toBeInTheDocument();
  });

  it("renders the app version from package.json", () => {
    renderWithRouter();
    expect(screen.getByText(`v${__APP_VERSION__}`)).toBeInTheDocument();
  });

  it("shows the update available badge and triggers onUpdate when clicked", async () => {
    const user = userEvent.setup();
    const consoleSpy = vi.spyOn(console, "log").mockImplementation(() => {});
    renderWithRouter();

    const updateButton = screen.getByRole("button", { name: /update available/i });
    expect(updateButton).toBeInTheDocument();

    await user.click(updateButton);
    expect(consoleSpy).toHaveBeenCalled();

    consoleSpy.mockRestore();
  });
});
