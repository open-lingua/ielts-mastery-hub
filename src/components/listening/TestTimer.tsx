import React, { useState, useEffect, useCallback, useRef } from "react";
import { Timer, Eye, EyeOff } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { Progress } from "@/components/ui/progress";
import { toast } from "@/hooks/use-toast";
import { cn } from "@/lib/utils";

interface TestTimerProps {
  totalSeconds: number;
  onTimeUp: () => void;
  isPaused?: boolean;
  testFinished?: boolean;
}

const TestTimer: React.FC<TestTimerProps> = ({
  totalSeconds,
  onTimeUp,
  isPaused = false,
  testFinished = false,
}) => {
  const [timeLeft, setTimeLeft] = useState(totalSeconds);
  const [minimized, setMinimized] = useState(false);
  const warned5 = useRef(false);
  const warned1 = useRef(false);
  const submitted = useRef(false);

  // Timer countdown
  useEffect(() => {
    if (isPaused || testFinished || timeLeft <= 0) return;
    const interval = setInterval(() => setTimeLeft((t) => t - 1), 1000);
    return () => clearInterval(interval);
  }, [isPaused, testFinished, timeLeft]);

  // Warnings and auto-submit
  useEffect(() => {
    if (testFinished) return;

    if (timeLeft <= 300 && timeLeft > 299 && !warned5.current) {
      warned5.current = true;
      toast({ title: "⏱ 5 minutes remaining", description: "Review your answers before time runs out." });
    }
    if (timeLeft <= 60 && timeLeft > 59 && !warned1.current) {
      warned1.current = true;
      toast({ title: "⚠ 1 minute remaining!", description: "Your test will be auto-submitted shortly.", variant: "destructive" });
    }
    if (timeLeft <= 0 && !submitted.current) {
      submitted.current = true;
      onTimeUp();
    }
  }, [timeLeft, testFinished, onTimeUp]);

  const minutes = Math.floor(timeLeft / 60);
  const seconds = timeLeft % 60;
  const progressPercent = (timeLeft / totalSeconds) * 100;

  const isUrgent = timeLeft <= 120;
  const isWarning = timeLeft <= 300 && !isUrgent;

  const timerColor = isUrgent
    ? "text-destructive"
    : isWarning
    ? "text-warning"
    : "text-foreground";

  const progressColor = isUrgent
    ? "[&>div]:bg-destructive"
    : isWarning
    ? "[&>div]:bg-warning"
    : "[&>div]:bg-primary";

  if (testFinished) return null;

  return (
    <div className="space-y-0">
      {/* Top progress bar */}
      <Progress value={progressPercent} className={cn("h-1 rounded-none", progressColor)} />

      {/* Timer display */}
      <AnimatePresence mode="wait">
        {minimized ? (
          <motion.button
            key="minimized"
            initial={{ opacity: 0, scale: 0.8 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 0.8 }}
            onClick={() => setMinimized(false)}
            className={cn(
              "fixed top-20 right-4 z-40 flex items-center gap-1.5 rounded-full border border-border bg-card px-3 py-1.5 shadow-lg transition-colors",
              isUrgent && "border-destructive/30 bg-destructive/5"
            )}
          >
            <Timer className={cn("h-3.5 w-3.5", timerColor)} />
            <span className={cn("font-mono text-sm font-bold tabular-nums", timerColor)}>
              {String(minutes).padStart(2, "0")}:{String(seconds).padStart(2, "0")}
            </span>
          </motion.button>
        ) : (
          <motion.div
            key="expanded"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="flex items-center justify-center gap-3 py-1.5 bg-card border-b border-border px-4"
          >
            <motion.div
              animate={isUrgent ? { scale: [1, 1.05, 1] } : {}}
              transition={isUrgent ? { repeat: Infinity, duration: 1.2 } : {}}
              className={cn(
                "flex items-center gap-2 rounded-lg px-3 py-1 border",
                isUrgent
                  ? "border-destructive/30 bg-destructive/5"
                  : isWarning
                  ? "border-warning/30 bg-warning/5"
                  : "border-border bg-secondary/50"
              )}
            >
              <Timer className={cn("h-4 w-4", timerColor)} />
              <span className={cn("font-mono text-lg font-bold tabular-nums", timerColor)}>
                {String(minutes).padStart(2, "0")}:{String(seconds).padStart(2, "0")}
              </span>
            </motion.div>
            <button
              onClick={() => setMinimized(true)}
              className="text-muted-foreground hover:text-foreground transition-colors p-1"
              title="Minimize timer"
            >
              <EyeOff className="h-3.5 w-3.5" />
            </button>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};

export default TestTimer;
