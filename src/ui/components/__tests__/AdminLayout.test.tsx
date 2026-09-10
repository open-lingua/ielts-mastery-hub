import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { MemoryRouter } from "react-router-dom";
import { beforeEach, describe, expect, it, vi } from "vitest";
import { TooltipProvider } from "@/components/ui/tooltip";
import { checkForUpdate, openReleaseUrl } from "@/lib/tauri";

vi.mock("@/contexts/ThemeContext", () => ({
  useTheme: () => ({ theme: "light", toggleTheme: vi.fn() }),
}));

vi.mock("@/lib/tauri", () => ({
  checkForUpdate: vi.fn(),
  openReleaseUrl: vi.fn(),
}));

import { AdminLayout } from "../AdminLayout";

const mockCheckForUpdate = vi.mocked(checkForUpdate);
const mockOpenReleaseUrl = vi.mocked(openReleaseUrl);

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
  beforeEach(() => {
    vi.clearAllMocks();
    mockOpenReleaseUrl.mockResolvedValue(undefined);
    mockCheckForUpdate.mockResolvedValue({
      latestVersion: __APP_VERSION__,
      releaseUrl: "https://example.com/releases/current",
    });
  });

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

  it("renders the app version from package.json", () => {
    renderWithRouter();
    expect(screen.getByText(`v${__APP_VERSION__}`)).toBeInTheDocument();
  });

  it("does not show the update badge when already on the latest version", async () => {
    renderWithRouter();
    await waitFor(() => expect(mockCheckForUpdate).toHaveBeenCalled());
    expect(screen.queryByRole("button", { name: /update available/i })).not.toBeInTheDocument();
  });

  it("shows the update available badge and opens the release URL when clicked", async () => {
    mockCheckForUpdate.mockResolvedValue({
      latestVersion: "999.0.0",
      releaseUrl: "https://example.com/releases/999.0.0",
    });
    const user = userEvent.setup();
    renderWithRouter();

    const updateButton = await screen.findByRole("button", { name: /update available/i });
    await user.click(updateButton);
    expect(mockOpenReleaseUrl).toHaveBeenCalledWith("https://example.com/releases/999.0.0");
  });

  it("does not show the update badge when the update check fails", async () => {
    mockCheckForUpdate.mockRejectedValue(new Error("network error"));
    vi.spyOn(console, "debug").mockImplementation(() => {});
    renderWithRouter();

    await waitFor(() => expect(mockCheckForUpdate).toHaveBeenCalled());
    expect(screen.queryByRole("button", { name: /update available/i })).not.toBeInTheDocument();
  });
});
