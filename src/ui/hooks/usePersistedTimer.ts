import { useEffect, useMemo, useRef, useState } from "react";

export interface UsePersistedTimerOptions {
  /** Total allowed time in seconds */
  totalSeconds: number;
  /** ISO timestamp of when the test was started (from DB) */
  startedAt: string | null;
  /** Called when timer reaches 0 */
  onTimeUp: () => void;
  /** Whether the test is finished */
  isFinished?: boolean;
}

export interface UsePersistedTimerReturn {
  /** Seconds remaining */
  remainingSeconds: number;
  /** Whether time has already expired on mount */
  expiredOnLoad: boolean;
}

/**
 * Calculates remaining time from a server-persisted `started_at` timestamp.
 * Survives page refreshes — the countdown is anchored to the DB timestamp.
 */
export function usePersistedTimer({
  totalSeconds,
  startedAt,
  onTimeUp,
  isFinished = false,
}: UsePersistedTimerOptions): UsePersistedTimerReturn {
  const calcRemaining = () => {
    if (!startedAt) return totalSeconds;
    const elapsed = Math.floor((Date.now() - new Date(startedAt).getTime()) / 1000);
    return Math.max(0, totalSeconds - elapsed);
  };

  const initialRemaining = useMemo(calcRemaining, [startedAt, totalSeconds]);
  const [remainingSeconds, setRemainingSeconds] = useState(initialRemaining);
  const expiredOnLoad = useMemo(() => !!startedAt && initialRemaining <= 0, [startedAt, initialRemaining]);
  const firedRef = useRef(false);

  // Tick every second
  useEffect(() => {
    if (isFinished || !startedAt || remainingSeconds <= 0) return;
    const interval = setInterval(() => {
      const r = calcRemaining();
      setRemainingSeconds(r);
      if (r <= 0 && !firedRef.current) {
        firedRef.current = true;
        onTimeUp();
      }
    }, 1000);
    return () => clearInterval(interval);
  }, [startedAt, isFinished, onTimeUp, remainingSeconds, calcRemaining]);

  // Fire immediately if expired on load
  useEffect(() => {
    if (expiredOnLoad && !firedRef.current && !isFinished) {
      firedRef.current = true;
      onTimeUp();
    }
  }, [expiredOnLoad, isFinished, onTimeUp]);

  // Reset ref when startedAt changes (retry)
  useEffect(() => {
    firedRef.current = false;
    setRemainingSeconds(calcRemaining());
  }, [calcRemaining]);

  return { remainingSeconds, expiredOnLoad };
}
