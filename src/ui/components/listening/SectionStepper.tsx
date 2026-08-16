import { CheckCircle2, Headphones, Lock } from "lucide-react";
import React from "react";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";
import { cn } from "@/lib/utils";

interface SectionStepperProps {
  totalSections: number;
  activeSection: number;
  completedSections: boolean[];
  unlockedSections: boolean[];
  onSectionClick: (index: number) => void;
}

const SectionStepper: React.FC<SectionStepperProps> = ({
  totalSections,
  activeSection,
  completedSections,
  unlockedSections,
  onSectionClick,
}) => {
  return (
    <div className="flex items-center gap-1 w-full">
      {Array.from({ length: totalSections }).map((_, i) => {
        const isCompleted = completedSections[i];
        const isActive = activeSection === i;
        const isUnlocked = unlockedSections[i];

        return (
          <React.Fragment key={i}>
            {i > 0 && (
              <div
                className={cn(
                  "h-0.5 flex-1 rounded-full transition-colors",
                  isCompleted || (unlockedSections[i] && completedSections[i - 1]) ? "bg-success" : "bg-border"
                )}
              />
            )}
            <Tooltip>
              <TooltipTrigger asChild>
                <button
                  type="button"
                  onClick={() => isUnlocked && onSectionClick(i)}
                  disabled={!isUnlocked}
                  className={cn(
                    "relative flex h-10 w-10 shrink-0 items-center justify-center rounded-full border-2 text-sm font-bold transition-all",
                    isCompleted && "border-success bg-success text-success-foreground",
                    isActive &&
                      !isCompleted &&
                      "border-primary bg-primary text-primary-foreground shadow-lg shadow-primary/25 scale-110",
                    !isActive &&
                      !isCompleted &&
                      isUnlocked &&
                      "border-border bg-card text-muted-foreground hover:border-primary/50 cursor-pointer",
                    !isUnlocked && "border-border bg-muted text-muted-foreground/40 cursor-not-allowed opacity-60"
                  )}
                >
                  {isCompleted ? (
                    <CheckCircle2 className="h-5 w-5" />
                  ) : !isUnlocked ? (
                    <Lock className="h-4 w-4" />
                  ) : isActive ? (
                    <Headphones className="h-4 w-4" />
                  ) : (
                    i + 1
                  )}
                </button>
              </TooltipTrigger>
              <TooltipContent side="bottom">
                {!isUnlocked
                  ? "Complete the previous section first"
                  : isCompleted
                    ? `Section ${i + 1} — Completed`
                    : `Section ${i + 1}`}
              </TooltipContent>
            </Tooltip>
          </React.Fragment>
        );
      })}
    </div>
  );
};

export default SectionStepper;
