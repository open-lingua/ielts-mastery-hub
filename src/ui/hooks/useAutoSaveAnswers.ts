import { useCallback, useEffect, useRef } from "react";
import { getAnonId } from "@/lib/anonId";
import { updateUserTestSession } from "@/lib/tauri";

interface UseAutoSaveOptions {
  sessionId: string | null;
  answers: Record<string, unknown>;
  userId?: string;
  debounceMs?: number;
  enabled?: boolean;
}

export function useAutoSaveAnswers({
  sessionId,
  answers,
  userId: userIdProp,
  debounceMs = 2000,
  enabled = true,
}: UseAutoSaveOptions) {
  const timerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const latestAnswers = useRef(answers);
  const isSaving = useRef(false);

  latestAnswers.current = answers;

  const saveNow = useCallback(async () => {
    if (!sessionId || isSaving.current) return;
    isSaving.current = true;
    const userId = userIdProp || getAnonId();
    try {
      await updateUserTestSession(sessionId, userId, {
        answers: JSON.stringify(latestAnswers.current),
        last_active_at: new Date().toISOString(),
      });
    } catch (err) {
      console.error("[auto-save] Failed to save answers:", err);
    } finally {
      isSaving.current = false;
    }
  }, [sessionId, userIdProp]);

  useEffect(() => {
    if (!enabled || !sessionId) return;
    if (Object.keys(answers).length === 0) return;

    if (timerRef.current) clearTimeout(timerRef.current);
    timerRef.current = setTimeout(saveNow, debounceMs);

    return () => {
      if (timerRef.current) clearTimeout(timerRef.current);
    };
  }, [answers, enabled, sessionId, debounceMs, saveNow]);

  useEffect(() => {
    return () => {
      if (sessionId && Object.keys(latestAnswers.current).length > 0) {
        const userId = userIdProp || getAnonId();
        updateUserTestSession(sessionId, userId, {
          answers: JSON.stringify(latestAnswers.current),
          last_active_at: new Date().toISOString(),
        }).catch(() => {});
      }
    };
  }, [sessionId, userIdProp]);

  return { saveNow };
}
