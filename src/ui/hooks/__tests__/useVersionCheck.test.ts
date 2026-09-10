import { act, renderHook, waitFor } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";
import { checkForUpdate, openReleaseUrl } from "@/lib/tauri";
import { useVersionCheck } from "../useVersionCheck";

vi.mock("@/lib/tauri", () => ({
  checkForUpdate: vi.fn(),
  openReleaseUrl: vi.fn(),
}));

const mockCheckForUpdate = vi.mocked(checkForUpdate);
const mockOpenReleaseUrl = vi.mocked(openReleaseUrl);

describe("useVersionCheck", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockOpenReleaseUrl.mockResolvedValue(undefined);
  });

  it("reports no update when the latest version equals the current version", async () => {
    mockCheckForUpdate.mockResolvedValue({
      latestVersion: __APP_VERSION__,
      releaseUrl: "https://example.com/releases/current",
    });

    const { result } = renderHook(() => useVersionCheck());

    await waitFor(() => expect(mockCheckForUpdate).toHaveBeenCalled());
    expect(result.current.hasUpdate).toBe(false);
    expect(result.current.latestVersion).toBeNull();
  });

  it("reports an update when the remote version is newer", async () => {
    mockCheckForUpdate.mockResolvedValue({
      latestVersion: "999.0.0",
      releaseUrl: "https://example.com/releases/999.0.0",
    });

    const { result } = renderHook(() => useVersionCheck());

    await waitFor(() => expect(result.current.hasUpdate).toBe(true));
    expect(result.current.latestVersion).toBe("999.0.0");
  });

  it("does not report an update when the remote version is a pre-release of the current one", async () => {
    // e.g. current is "1.2.3", remote is "1.2.3-rc.1" — a pre-release always sorts *before* its
    // final release per semver, so this must not be treated as newer.
    mockCheckForUpdate.mockResolvedValue({
      latestVersion: "1.2.3-rc.1",
      releaseUrl: "https://example.com/releases/1.2.3-rc.1",
    });

    const { result } = renderHook(() => useVersionCheck());

    await waitFor(() => expect(mockCheckForUpdate).toHaveBeenCalled());
    expect(result.current.hasUpdate).toBe(false);
  });

  it("stays up to date (no throw, no update) when the check rejects", async () => {
    const debugSpy = vi.spyOn(console, "debug").mockImplementation(() => {});
    mockCheckForUpdate.mockRejectedValue(new Error("network error"));

    const { result } = renderHook(() => useVersionCheck());

    await waitFor(() => expect(mockCheckForUpdate).toHaveBeenCalled());
    expect(result.current.hasUpdate).toBe(false);
    expect(result.current.latestVersion).toBeNull();
    expect(debugSpy).toHaveBeenCalled();

    debugSpy.mockRestore();
  });

  it("stays up to date when the remote version is malformed", async () => {
    mockCheckForUpdate.mockResolvedValue({
      latestVersion: "not-a-version",
      releaseUrl: "https://example.com/releases/bad",
    });

    const { result } = renderHook(() => useVersionCheck());

    await waitFor(() => expect(mockCheckForUpdate).toHaveBeenCalled());
    expect(result.current.hasUpdate).toBe(false);
    expect(result.current.latestVersion).toBeNull();
  });

  it("calls openReleaseUrl only when onUpdate is explicitly invoked", async () => {
    mockCheckForUpdate.mockResolvedValue({
      latestVersion: "999.0.0",
      releaseUrl: "https://example.com/releases/999.0.0",
    });

    const { result } = renderHook(() => useVersionCheck());

    await waitFor(() => expect(result.current.hasUpdate).toBe(true));
    expect(mockOpenReleaseUrl).not.toHaveBeenCalled();

    act(() => {
      result.current.onUpdate();
    });

    expect(mockOpenReleaseUrl).toHaveBeenCalledWith("https://example.com/releases/999.0.0");
  });
});
