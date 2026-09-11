import { beforeEach, describe, expect, it, vi } from "vitest";
import type { UserTestSession } from "@/lib/tauri";

vi.mock("@/lib/tauri", () => ({
  createUserTestSession: vi.fn(),
  deleteUserTestSession: vi.fn(),
  getListeningTest: vi.fn(),
  getReadingTest: vi.fn(),
  getWritingTest: vi.fn(),
  listPracticeTests: vi.fn(),
  listUserTestSessions: vi.fn(),
  updateUserTestSession: vi.fn(),
}));

import { deleteUserTestSession, listUserTestSessions, updateUserTestSession } from "@/lib/tauri";
import { EXPIRE_AFTER_HOURS, abortSession, fetchActiveSession, isSessionExpired } from "@/services/practiceLibraryService";

const mockDeleteUserTestSession = vi.mocked(deleteUserTestSession);
const mockUpdateUserTestSession = vi.mocked(updateUserTestSession);
const mockListUserTestSessions = vi.mocked(listUserTestSessions);

const baseSession: UserTestSession = {
  id: "session-1",
  user_id: "user-1",
  test_id: "test-1",
  test_type: "reading",
  status: "in_progress",
  progress_percent: 10,
  score_band: null,
  attempt_number: 1,
  answers: null,
  feedback_data: null,
  started_at: new Date().toISOString(),
  completed_at: null,
  last_active_at: new Date().toISOString(),
  created_at: new Date().toISOString(),
};

describe("abortSession", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("resolves without calling update when delete succeeds", async () => {
    mockDeleteUserTestSession.mockResolvedValue(undefined);

    await expect(abortSession("session-1", "user-1")).resolves.toBeUndefined();

    expect(mockDeleteUserTestSession).toHaveBeenCalledWith("session-1", "user-1");
    expect(mockUpdateUserTestSession).not.toHaveBeenCalled();
  });

  it("falls back to marking the session 'aborted' when delete fails", async () => {
    mockDeleteUserTestSession.mockRejectedValue(new Error("delete failed"));
    mockUpdateUserTestSession.mockResolvedValue(undefined);

    await expect(abortSession("session-1", "user-1")).resolves.toBeUndefined();

    expect(mockUpdateUserTestSession).toHaveBeenCalledWith(
      "session-1",
      "user-1",
      expect.objectContaining({ status: "aborted" })
    );
  });

  it("rejects when both delete and the fallback update fail", async () => {
    mockDeleteUserTestSession.mockRejectedValue(new Error("delete failed"));
    mockUpdateUserTestSession.mockRejectedValue(new Error("update failed"));

    await expect(abortSession("session-1", "user-1")).rejects.toThrow("update failed");
  });
});

describe("isSessionExpired", () => {
  it("returns false for a recently active session", () => {
    expect(isSessionExpired(new Date().toISOString())).toBe(false);
  });

  it("returns true when last_active_at is older than the expiry window", () => {
    const staleDate = new Date(Date.now() - (EXPIRE_AFTER_HOURS + 1) * 60 * 60 * 1000).toISOString();
    expect(isSessionExpired(staleDate)).toBe(true);
  });
});

describe("fetchActiveSession", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("returns the in_progress session when it is recently active", async () => {
    mockListUserTestSessions.mockResolvedValue([baseSession]);

    const active = await fetchActiveSession("user-1");

    expect(active?.id).toBe("session-1");
  });

  it("returns null for an abandoned in_progress session whose last_active_at is stale", async () => {
    const staleSession: UserTestSession = {
      ...baseSession,
      last_active_at: new Date(Date.now() - (EXPIRE_AFTER_HOURS + 1) * 60 * 60 * 1000).toISOString(),
    };
    mockListUserTestSessions.mockResolvedValue([staleSession]);

    const active = await fetchActiveSession("user-1");

    expect(active).toBeNull();
  });

  it("returns null when there are no sessions", async () => {
    mockListUserTestSessions.mockResolvedValue([]);

    const active = await fetchActiveSession("user-1");

    expect(active).toBeNull();
  });
});
