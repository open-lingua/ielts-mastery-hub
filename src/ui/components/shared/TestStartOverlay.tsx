import { AnimatePresence, motion } from "framer-motion";
import { AlertTriangle, BookOpen, FileText, Headphones, Info, Lock, Play, Timer } from "lucide-react";
import type React from "react";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";
import { cn } from "@/lib/utils";

interface TestStartOverlayProps {
  /** Whether the test has started */
  isStarted: boolean;
  /** Called when user clicks Start */
  onStart: () => void;
  /** Test title, e.g. "IELTS Academic Reading - Test 1" */
  title: string;
  /** Module type for icon selection */
  module: "reading" | "writing" | "listening";
  /** e.g. "3 Sections" */
  sections: string;
  /** e.g. "40 Questions" */
  questions: string;
  /** Duration in minutes */
  durationMinutes: number;
  /** Custom instructions */
  instructions?: string[];
  /**
   * When true, the Start button is disabled and a warning banner is shown
   * instead of allowing the test to begin (e.g. missing prerequisite state).
   */
  locked?: boolean;
  /** Banner title shown when `locked` is true. */
  lockTitle?: string;
  /** Banner message shown when `locked` is true, explaining the block. */
  lockMessage?: string;
  /** Label for the banner's action button when `locked` is true. */
  lockActionLabel?: string;
  /** Called when the user clicks the banner's action button. */
  onLockAction?: () => void;
  /** Children (the actual test content) */
  children: React.ReactNode;
}

const moduleIcons = {
  reading: BookOpen,
  writing: FileText,
  listening: Headphones,
};

const defaultInstructions: Record<string, string[]> = {
  reading: [
    "You have 60 minutes to complete all 3 passages.",
    "The timer will start immediately when you click Start.",
    "You cannot pause the test once started.",
    "Your answers will be auto-submitted when time expires.",
  ],
  writing: [
    "You have 60 minutes to complete both tasks.",
    "Task 1 should take about 20 minutes, Task 2 about 40 minutes.",
    "The timer starts immediately — manage your time wisely.",
    "Your essays will be auto-submitted when time expires.",
  ],
  listening: [
    "You have 30 minutes to complete all 4 sections.",
    "Audio plays once per section — listen carefully.",
    "The timer starts immediately when you click Start.",
    "Your answers will be auto-submitted when time expires.",
  ],
};

const TestStartOverlay: React.FC<TestStartOverlayProps> = ({
  isStarted,
  onStart,
  title,
  module,
  sections,
  questions,
  durationMinutes,
  instructions,
  locked = false,
  lockTitle = "Action required",
  lockMessage = "This action is currently unavailable.",
  lockActionLabel = "Resolve",
  onLockAction,
  children,
}) => {
  const Icon = moduleIcons[module];
  const rules = instructions || defaultInstructions[module];

  const startButton = (
    <Button
      onClick={onStart}
      disabled={locked}
      size="lg"
      className="w-full gap-2 rounded-xl py-3 text-base font-semibold shadow-lg shadow-primary/20"
    >
      {locked ? <Lock className="h-5 w-5" /> : <Play className="h-5 w-5" />}
      Start Now
    </Button>
  );

  return (
    <div className="relative flex-1 flex flex-col overflow-hidden min-h-0">
      {/* Test content with conditional blur */}
      <div
        className={cn(
          "flex-1 flex flex-col min-h-0 transition-all duration-700",
          !isStarted && "blur-lg grayscale opacity-40 pointer-events-none select-none overflow-hidden"
        )}
      >
        {children}
      </div>

      {/* Overlay */}
      <AnimatePresence>
        {!isStarted && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0, transition: { duration: 0.5 } }}
            className="absolute inset-0 z-50 flex items-center justify-center bg-background/60 backdrop-blur-sm p-4"
          >
            <motion.div
              initial={{ scale: 0.92, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.95, opacity: 0 }}
              transition={{ type: "spring", stiffness: 300, damping: 24 }}
            >
              <Card className="w-full max-w-md border border-border bg-card shadow-2xl p-8 space-y-6">
                {/* Icon & Title */}
                <div className="text-center space-y-3">
                  <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-2xl bg-primary/10">
                    <Icon className="h-7 w-7 text-primary" />
                  </div>
                  <h2 className="text-xl font-bold text-foreground">{title}</h2>

                  {/* Metadata badges */}
                  <div className="flex items-center justify-center gap-2 flex-wrap">
                    <Badge variant="secondary" className="text-xs gap-1">
                      {sections}
                    </Badge>
                    <Badge variant="secondary" className="text-xs gap-1">
                      {questions}
                    </Badge>
                    <Badge variant="secondary" className="text-xs gap-1">
                      <Timer className="h-3 w-3" />
                      {durationMinutes} Minutes
                    </Badge>
                  </div>
                </div>

                {/* Instructions */}
                <div className="rounded-xl bg-secondary/50 border border-border p-4 space-y-2.5">
                  <h3 className="text-xs font-bold text-foreground uppercase tracking-widest flex items-center gap-1.5">
                    <Info className="h-3.5 w-3.5 text-primary" />
                    Instructions
                  </h3>
                  <ul className="space-y-1.5">
                    {rules.map((rule) => (
                      <li key={rule} className="flex items-start gap-2 text-sm text-muted-foreground">
                        <span className="mt-1 h-1.5 w-1.5 rounded-full bg-primary/50 shrink-0" />
                        {rule}
                      </li>
                    ))}
                  </ul>
                </div>

                {/* Lock banner — shown when a prerequisite is missing */}
                {locked && (
                  <Alert variant="destructive">
                    <AlertTriangle className="h-4 w-4" />
                    <AlertTitle>{lockTitle}</AlertTitle>
                    <AlertDescription className="space-y-3">
                      <p>{lockMessage}</p>
                      {onLockAction && (
                        <Button
                          type="button"
                          variant="outline"
                          size="sm"
                          onClick={onLockAction}
                          className="gap-1.5"
                        >
                          {lockActionLabel}
                        </Button>
                      )}
                    </AlertDescription>
                  </Alert>
                )}

                {/* Start Button */}
                {locked ? (
                  <Tooltip>
                    <TooltipTrigger asChild>
                      <span className="block w-full">{startButton}</span>
                    </TooltipTrigger>
                    <TooltipContent>{lockMessage}</TooltipContent>
                  </Tooltip>
                ) : (
                  startButton
                )}
              </Card>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};

export default TestStartOverlay;
