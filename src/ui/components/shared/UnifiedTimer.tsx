import { AnimatePresence, motion } from "framer-motion";
import { AlertTriangle, EyeOff, Timer } from "lucide-react";
import type React from "react";
import { useEffect, useRef, useState } from "react";
import { Progress } from "@/components/ui/progress";
import { toast } from "@/hooks/use-toast";
import { useTestTimer } from "@/hooks/useTestTimer";
import { cn } from "@/lib/utils";

interface UnifiedTimerProps {
  /** Total test duration in seconds */
  totalSeconds: number;
  /** Called when timer reaches 00:00 */
  onTimeUp: () => void;
  /** Pause the timer (Practice Mode only) */
  isPaused?: boolean;
  /** Hide when test is finished */
  testFinished?: boolean;
  /** Show the top progress bar */
  showProgressBar?: boolean;
  /** Variant: "inline" renders inside header flow, "floating" renders as fixed pill */
  variant?: "inline" | "floating";
}

const UnifiedTimer: React.FC<UnifiedTimerProps> = ({
  totalSeconds,
  onTimeUp,
  isPaused = false,
  testFinished = false,
  showProgressBar = true,
  variant = "inline",
}) => {
  const { timeLeft, formattedTime, progressPercent, isWarning, isUrgent, timerColor } = useTestTimer({
    initialSeconds: totalSeconds,
    onTimeUp,
    isPaused,
    isFinished: testFinished,
  });

  const [minimized, setMinimized] = useState(false);
  const warned5 = useRef(false);
  const warned1 = useRef(false);

  // Toast warnings
  useEffect(() => {
    if (testFinished) return;
    if (timeLeft <= 300 && timeLeft > 299 && !warned5.current) {
      warned5.current = true;
      toast({
        title: "⏱ 5 minutes remaining",
        description: "Review your answers before time runs out.",
      });
    }
    if (timeLeft <= 60 && timeLeft > 59 && !warned1.current) {
      warned1.current = true;
      toast({
        title: "⚠ 1 minute remaining!",
        description: "Your test will be auto-submitted shortly.",
        variant: "destructive",
      });
    }
  }, [timeLeft, testFinished]);

  // Reset warning refs on retry
  useEffect(() => {
    if (timeLeft === totalSeconds) {
      warned5.current = false;
      warned1.current = false;
    }
  }, [timeLeft, totalSeconds]);

  const progressColor = isUrgent ? "[&>div]:bg-destructive" : isWarning ? "[&>div]:bg-warning" : "[&>div]:bg-primary";

  const pillClasses = cn(
    "flex items-center gap-2 rounded-lg px-3 py-1.5 border backdrop-blur-md transition-colors min-w-[8rem] justify-center",
    isUrgent
      ? "border-destructive/30 bg-destructive/5"
      : isWarning
        ? "border-warning/30 bg-warning/5"
        : "border-border bg-card/80"
  );

  if (testFinished) return null;

  // ── Floating variant (minimized pill in corner) ──
  if (variant === "floating" || minimized) {
    return (
      <>
        {showProgressBar && (
          <Progress value={progressPercent} className={cn("h-1 rounded-none shrink-0", progressColor)} />
        )}
        <motion.button
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ opacity: 1, scale: 1 }}
          onClick={() => {
            if (minimized) setMinimized(false);
          }}
          className={cn("fixed top-20 right-4 z-50 shadow-lg", pillClasses)}
        >
          <motion.div
            animate={isUrgent ? { scale: [1, 1.06, 1] } : {}}
            transition={isUrgent ? { repeat: Infinity, duration: 1.2, ease: "easeInOut" } : {}}
            className="flex items-center gap-2"
          >
            <Timer className={cn("h-3.5 w-3.5", timerColor)} />
            <span className={cn("font-mono text-sm font-bold tabular-nums", timerColor)}>{formattedTime}</span>
          </motion.div>
        </motion.button>
      </>
    );
  }

  // ── Inline variant (inside header bar) ──
  return (
    <div className="shrink-0">
      {showProgressBar && <Progress value={progressPercent} className={cn("h-1 rounded-none", progressColor)} />}
      <div className="flex items-center justify-center gap-3 py-1.5 bg-card/80 backdrop-blur-md border-b border-border px-4">
        <motion.div
          animate={isUrgent ? { scale: [1, 1.04, 1] } : {}}
          transition={isUrgent ? { repeat: Infinity, duration: 1.2, ease: "easeInOut" } : {}}
          className={pillClasses}
        >
          <Timer className={cn("h-4 w-4 shrink-0", timerColor)} />
          <span className={cn("font-mono text-lg font-bold tabular-nums", timerColor)}>{formattedTime}</span>
        </motion.div>
        <button
          type="button"
          onClick={() => setMinimized(true)}
          className="text-muted-foreground hover:text-foreground transition-colors p-1 rounded-md hover:bg-secondary"
          title="Minimize timer"
        >
          <EyeOff className="h-3.5 w-3.5" />
        </button>
      </div>
    </div>
  );
};

/** Shared "Time's Up" overlay modal */
export const TimeUpOverlay: React.FC<{
  show: boolean;
  onDismiss: () => void;
}> = ({ show, onDismiss }) => (
  <AnimatePresence>
    {show && (
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        className="fixed inset-0 z-50 flex items-center justify-center bg-foreground/20 backdrop-blur-sm"
      >
        <motion.div
          initial={{ scale: 0.9, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          exit={{ scale: 0.9, opacity: 0 }}
          className="rounded-2xl border border-border bg-card p-8 shadow-2xl max-w-md text-center space-y-4"
        >
          <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-destructive/10">
            <AlertTriangle className="h-7 w-7 text-destructive" />
          </div>
          <h2 className="text-xl font-bold text-foreground">Time's Up!</h2>
          <p className="text-sm text-muted-foreground">
            Your answers have been automatically submitted. You can now review your results.
          </p>
          <button
            type="button"
            onClick={onDismiss}
            className="w-full rounded-xl bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground hover:bg-primary/90 transition-colors"
          >
            View Results
          </button>
        </motion.div>
      </motion.div>
    )}
  </AnimatePresence>
);

export default UnifiedTimer;
