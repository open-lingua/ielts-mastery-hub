import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { MemoryRouter } from "react-router-dom";
import { beforeEach, describe, expect, it, vi } from "vitest";
import { TooltipProvider } from "@/components/ui/tooltip";
import { checkForUpdate, openReleaseUrl } from "@/lib/tauri";
import { fetchAiConfigurations, saveAiConfiguration, activateAiConfiguration, removeAiConfiguration } from "@/services/aiConfigurationService";

vi.mock("@/contexts/ThemeContext", () => ({
  useTheme: () => ({ theme: "light", toggleTheme: vi.fn() }),
}));

vi.mock("@/lib/tauri", () => ({
  checkForUpdate: vi.fn(),
  openReleaseUrl: vi.fn(),
}));

vi.mock("@/services/aiConfigurationService", () => ({
  fetchAiConfigurations: vi.fn(),
  saveAiConfiguration: vi.fn(),
  activateAiConfiguration: vi.fn(),
  removeAiConfiguration: vi.fn(),
}));

import AiConfigurations from "../AiConfigurations";

const mockCheckForUpdate = vi.mocked(checkForUpdate);
const mockOpenReleaseUrl = vi.mocked(openReleaseUrl);
const mockFetchAiConfigurations = vi.mocked(fetchAiConfigurations);
const mockSaveAiConfiguration = vi.mocked(saveAiConfiguration);
const mockActivateAiConfiguration = vi.mocked(activateAiConfiguration);
const mockRemoveAiConfiguration = vi.mocked(removeAiConfiguration);

const renderPage = () =>
  render(
    <MemoryRouter initialEntries={["/admin/ai-configurations"]}>
      <TooltipProvider>
        <AiConfigurations />
      </TooltipProvider>
    </MemoryRouter>
  );

describe("AiConfigurations", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockOpenReleaseUrl.mockResolvedValue(undefined);
    mockCheckForUpdate.mockResolvedValue({
      latestVersion: __APP_VERSION__,
      releaseUrl: "https://example.com/releases/current",
    });
    mockFetchAiConfigurations.mockResolvedValue({
      configuredMap: { claude: true, gemini: true },
      activeProviderId: "claude",
    });
    mockSaveAiConfiguration.mockResolvedValue({ configured: true, isActive: true });
    mockActivateAiConfiguration.mockResolvedValue({ isActive: true });
    mockRemoveAiConfiguration.mockResolvedValue(undefined);
  });

  it("shows a loading state while configurations are being fetched", () => {
    let resolveFetch: (value: Awaited<ReturnType<typeof fetchAiConfigurations>>) => void = () => {};
    mockFetchAiConfigurations.mockReturnValue(
      new Promise((resolve) => {
        resolveFetch = resolve;
      })
    );

    renderPage();

    expect(screen.queryByText("Gemini")).not.toBeInTheDocument();

    // Avoid an unhandled-promise dangling warning after the test completes.
    resolveFetch({ configuredMap: {}, activeProviderId: null });
  });

  it("shows an error when loading configurations fails", async () => {
    mockFetchAiConfigurations.mockRejectedValue(new Error("network unreachable"));

    renderPage();

    expect(await screen.findByText(/failed to load ai configurations/i)).toBeInTheDocument();
    expect(screen.getByText(/network unreachable/i)).toBeInTheDocument();
  });

  it("renders all providers in the rail", async () => {
    renderPage();
    expect(await screen.findByText("Gemini")).toBeInTheDocument();
    expect(screen.getByText("ChatGPT")).toBeInTheDocument();
    expect(screen.getAllByText("Claude").length).toBeGreaterThan(0);
    expect(screen.getByText("Local Model")).toBeInTheDocument();
    expect(screen.getByText("General")).toBeInTheDocument();
  });

  it("selects Claude by default and shows it as active", async () => {
    renderPage();
    const activeBadges = await screen.findAllByText("ACTIVE");
    expect(activeBadges.length).toBeGreaterThan(0);
    expect(screen.getByRole("heading", { name: "Claude" })).toBeInTheDocument();
  });

  it("switches the detail panel when selecting another provider", async () => {
    const user = userEvent.setup();
    renderPage();

    await user.click(await screen.findByText("Gemini"));
    expect(screen.getByRole("heading", { name: "Gemini" })).toBeInTheDocument();
    expect(screen.getByText("Generate from Google AI Studio.")).toBeInTheDocument();
  });

  it("disables save until required fields are filled", async () => {
    const user = userEvent.setup();
    renderPage();

    await user.click(await screen.findByText("Gemini"));
    const saveButton = screen.getByRole("button", { name: /save configuration/i });
    expect(saveButton).toBeDisabled();

    await user.type(screen.getByLabelText("API Key"), "AIzaSyTestKey");
    expect(saveButton).not.toBeDisabled();
  });

  it("saves the configuration and marks the provider as configured and active", async () => {
    const user = userEvent.setup();
    renderPage();

    await user.click(await screen.findByText("Gemini"));
    await user.type(screen.getByLabelText("API Key"), "AIzaSyTestKey");
    await user.click(screen.getByRole("button", { name: /save configuration/i }));

    expect(await screen.findByRole("button", { name: /saved/i })).toBeInTheDocument();
    expect(screen.getByText("Gemini is now the active model.")).toBeInTheDocument();
    expect(mockSaveAiConfiguration).toHaveBeenCalledWith("gemini", { apiKey: "AIzaSyTestKey" });
  });

  it("shows an error and leaves the provider unsaved when saving fails", async () => {
    const user = userEvent.setup();
    mockSaveAiConfiguration.mockRejectedValue(new Error("invalid API key"));
    renderPage();

    await user.click(await screen.findByText("Gemini"));
    await user.type(screen.getByLabelText("API Key"), "AIzaSyTestKey");
    await user.click(screen.getByRole("button", { name: /save configuration/i }));

    expect(await screen.findByText(/failed to save configuration/i)).toBeInTheDocument();
    expect(screen.getByText(/invalid api key/i)).toBeInTheDocument();
    expect(screen.getByRole("button", { name: /save configuration/i })).toBeInTheDocument();
    await waitFor(() => {
      expect(screen.queryByRole("button", { name: /saved/i })).not.toBeInTheDocument();
    });
  });

  it("resets the draft fields for the selected provider", async () => {
    const user = userEvent.setup();
    renderPage();

    await user.click(await screen.findByText("Gemini"));
    const input = screen.getByLabelText("API Key") as HTMLInputElement;
    await user.type(input, "some-secret-value");
    expect(input.value).toBe("some-secret-value");

    await user.click(screen.getByRole("button", { name: /reset/i }));
    expect(input.value).toBe("");
  });

  it("toggles password visibility for secret fields", async () => {
    const user = userEvent.setup();
    renderPage();

    await user.click(await screen.findByText("Gemini"));
    const input = screen.getByLabelText("API Key") as HTMLInputElement;
    expect(input.type).toBe("password");

    await user.click(screen.getByRole("button", { name: /show value/i }));
    expect(input.type).toBe("text");

    await user.click(screen.getByRole("button", { name: /hide value/i }));
    expect(input.type).toBe("password");
  });

  it("shows a required/optional badge per field", async () => {
    const user = userEvent.setup();
    renderPage();

    await user.click(await screen.findByText("General"));
    expect(screen.getAllByText("REQUIRED").length).toBe(2);
    expect(screen.getAllByText("OPTIONAL").length).toBe(2);
  });

  it("hides the set-as-active button for the active provider and shows it for a configured inactive one", async () => {
    const user = userEvent.setup();
    renderPage();

    await screen.findByRole("heading", { name: "Claude" });
    expect(screen.queryByRole("button", { name: /set as active/i })).not.toBeInTheDocument();

    await user.click(screen.getByText("Gemini"));
    expect(await screen.findByRole("button", { name: /set as active/i })).toBeInTheDocument();
  });

  it("activates a configured provider and marks it as the active one", async () => {
    const user = userEvent.setup();
    renderPage();

    await user.click(await screen.findByText("Gemini"));
    await user.click(await screen.findByRole("button", { name: /set as active/i }));

    expect(mockActivateAiConfiguration).toHaveBeenCalledWith("gemini");
    expect(await screen.findAllByText("ACTIVE")).not.toHaveLength(0);
    await waitFor(() => {
      expect(screen.queryByRole("button", { name: /set as active/i })).not.toBeInTheDocument();
    });
  });

  it("shows an error when activation fails", async () => {
    const user = userEvent.setup();
    mockActivateAiConfiguration.mockRejectedValue(new Error("provider not configured"));
    renderPage();

    await user.click(await screen.findByText("Gemini"));
    await user.click(await screen.findByRole("button", { name: /set as active/i }));

    expect(await screen.findByText(/failed to activate configuration/i)).toBeInTheDocument();
    expect(screen.getByText(/provider not configured/i)).toBeInTheDocument();
  });

  it("opens a delete confirmation dialog and cancels without deleting", async () => {
    const user = userEvent.setup();
    renderPage();

    await screen.findByRole("heading", { name: "Claude" });
    await user.click(screen.getByRole("button", { name: "Delete Claude configuration" }));

    expect(await screen.findByText('Delete "Claude" configuration?')).toBeInTheDocument();
    await user.click(screen.getByRole("button", { name: /cancel/i }));

    await waitFor(() => {
      expect(screen.queryByText('Delete "Claude" configuration?')).not.toBeInTheDocument();
    });
    expect(mockRemoveAiConfiguration).not.toHaveBeenCalled();
  });

  it("deletes the configuration on confirm and updates the provider's state", async () => {
    const user = userEvent.setup();
    renderPage();

    await screen.findByRole("heading", { name: "Claude" });
    await user.click(screen.getByRole("button", { name: "Delete Claude configuration" }));
    await screen.findByText('Delete "Claude" configuration?');
    await user.click(screen.getByRole("button", { name: "Delete" }));

    expect(mockRemoveAiConfiguration).toHaveBeenCalledWith("claude");
    await waitFor(() => {
      expect(screen.queryByText('Delete "Claude" configuration?')).not.toBeInTheDocument();
    });
    await waitFor(() => {
      expect(screen.queryByRole("button", { name: "Delete Claude configuration" })).not.toBeInTheDocument();
    });
    expect(screen.queryAllByText("ACTIVE")).toHaveLength(0);
  });

  it("closes the dialog and leaves the provider unchanged when delete fails", async () => {
    const user = userEvent.setup();
    mockRemoveAiConfiguration.mockRejectedValue(new Error("could not delete"));
    renderPage();

    await screen.findByRole("heading", { name: "Claude" });
    await user.click(screen.getByRole("button", { name: "Delete Claude configuration" }));
    await screen.findByText('Delete "Claude" configuration?');
    await user.click(screen.getByRole("button", { name: "Delete" }));

    await waitFor(() => {
      expect(screen.queryByText('Delete "Claude" configuration?')).not.toBeInTheDocument();
    });
    // The provider stays configured since the delete call failed.
    expect(screen.getByRole("button", { name: "Delete Claude configuration" })).toBeInTheDocument();
  });
});
