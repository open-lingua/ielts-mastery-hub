import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { MemoryRouter } from "react-router-dom";
import { beforeEach, describe, expect, it, vi } from "vitest";
import { checkForUpdate, openReleaseUrl } from "@/lib/tauri";

vi.mock("@/contexts/ThemeContext", () => ({
  useTheme: () => ({ theme: "light", toggleTheme: vi.fn() }),
}));

vi.mock("@/lib/tauri", () => ({
  checkForUpdate: vi.fn(),
  openReleaseUrl: vi.fn(),
}));

import { DashboardLayout } from "../DashboardLayout";

const mockCheckForUpdate = vi.mocked(checkForUpdate);
const mockOpenReleaseUrl = vi.mocked(openReleaseUrl);

const renderWithRouter = (path = "/dashboard") =>
  render(
    <MemoryRouter initialEntries={[path]}>
      <DashboardLayout>
        <div data-testid="child-content">Dashboard Content</div>
      </DashboardLayout>
    </MemoryRouter>
  );

describe("DashboardLayout", () => {
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
    expect(screen.getByText("Test Library")).toBeInTheDocument();
    expect(screen.getByText("Admin Portal")).toBeInTheDocument();
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
