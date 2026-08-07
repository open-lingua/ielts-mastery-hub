import { useEffect, useRef, useCallback } from "react";
import { supabase } from "@/integrations/supabase/client";

interface UseAutoSaveOptions {
  sessionId: string | null;
  answers: Record<string, unknown>;
  /** Debounce interval in ms (default: 2000) */
  debounceMs?: number;
  /** Whether saving is enabled (disabled when test is finished) */
  enabled?: boolean;
}

/**
 * Auto-saves answers to user_test_sessions.answers with debouncing.
 * Also updates last_active_at on each save.
 */
export function useAutoSaveAnswers({
  sessionId,
  answers,
  debounceMs = 2000,
  enabled = true,
}: UseAutoSaveOptions) {
  const timerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const latestAnswers = useRef(answers);
  const isSaving = useRef(false);

  // Keep ref in sync
  latestAnswers.current = answers;

  const saveNow = useCallback(async () => {
    if (!sessionId || isSaving.current) return;
    isSaving.current = true;
    try {
      await supabase
        .from("user_test_sessions")
        .update({
          answers: latestAnswers.current as any,
          last_active_at: new Date().toISOString(),
        })
        .eq("id", sessionId);
    } catch (err) {
      console.error("[auto-save] Failed to save answers:", err);
    } finally {
      isSaving.current = false;
    }
  }, [sessionId]);

  // Debounced effect triggered by answer changes
  useEffect(() => {
    if (!enabled || !sessionId) return;

    // Don't save empty answers
    const hasContent = Object.keys(answers).length > 0;
    if (!hasContent) return;

    if (timerRef.current) clearTimeout(timerRef.current);
    timerRef.current = setTimeout(saveNow, debounceMs);

    return () => {
      if (timerRef.current) clearTimeout(timerRef.current);
    };
  }, [answers, enabled, sessionId, debounceMs, saveNow]);

  // Flush on unmount (e.g. navigation away)
  useEffect(() => {
    return () => {
      if (sessionId && Object.keys(latestAnswers.current).length > 0) {
        // Fire-and-forget save on unmount
        supabase
          .from("user_test_sessions")
          .update({
            answers: latestAnswers.current as any,
            last_active_at: new Date().toISOString(),
          })
          .eq("id", sessionId)
          .then(() => {});
      }
    };
  }, [sessionId]);

  return { saveNow };
}
