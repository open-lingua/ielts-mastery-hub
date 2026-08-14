import { useEffect, useRef, useState } from "react";

export interface UseTestTimerOptions {
  initialSeconds: number;
  onTimeUp: () => void;
  isPaused?: boolean;
  isFinished?: boolean;
}

export interface UseTestTimerReturn {
  timeLeft: number;
  formattedTime: string;
  progressPercent: number;
  isWarning: boolean;
  isUrgent: boolean;
  timerColor: string;
}

export function useTestTimer({
  initialSeconds,
  onTimeUp,
  isPaused = false,
  isFinished = false,
}: UseTestTimerOptions): UseTestTimerReturn {
  const [timeLeft, setTimeLeft] = useState(initialSeconds);
  const submitted = useRef(false);

  useEffect(() => {
    if (isPaused || isFinished || timeLeft <= 0) return;
    const interval = setInterval(() => setTimeLeft((t) => t - 1), 1000);
    return () => clearInterval(interval);
  }, [isPaused, isFinished, timeLeft]);

  useEffect(() => {
    if (isFinished) return;
    if (timeLeft <= 0 && !submitted.current) {
      submitted.current = true;
      onTimeUp();
    }
  }, [timeLeft, isFinished, onTimeUp]);

  // Reset when initialSeconds changes (e.g. retry)
  useEffect(() => {
    setTimeLeft(initialSeconds);
    submitted.current = false;
  }, [initialSeconds]);

  const minutes = Math.floor(timeLeft / 60);
  const seconds = timeLeft % 60;
  const formattedTime = `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`;
  const progressPercent = (timeLeft / initialSeconds) * 100;
  const isUrgent = timeLeft <= 60;
  const isWarning = timeLeft <= 300 && !isUrgent;

  const timerColor = isUrgent ? "text-destructive" : isWarning ? "text-warning" : "text-foreground";

  return { timeLeft, formattedTime, progressPercent, isWarning, isUrgent, timerColor };
}
