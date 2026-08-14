import { Eye, EyeOff, RotateCcw, Trophy } from "lucide-react";
import type React from "react";
import { Button } from "@/components/ui/button";
import type { ListeningTest } from "@/data/listeningTestData";
import { cn } from "@/lib/utils";
import { calculateListeningBandScore, isAnswerCorrect } from "@/utils/ieltsGrading";

interface ResultsCardProps {
  test: ListeningTest;
  answers: Record<string, string>;
  reviewMode: boolean;
  onToggleReview: () => void;
  onRetry: () => void;
  onBackToLibrary?: () => void;
}

const ResultsCard: React.FC<ResultsCardProps> = ({
  test,
  answers,
  reviewMode,
  onToggleReview,
  onRetry,
  onBackToLibrary,
}) => {
  const allQuestions = test.sections.flatMap((s) => s.questions);
  const totalCorrect = allQuestions.filter((q) => isAnswerCorrect(answers[q.id], q.answer)).length;
  const bandScore = calculateListeningBandScore(totalCorrect);

  const sectionResults = test.sections.map((section) => {
    const correct = section.questions.filter((q) => isAnswerCorrect(answers[q.id], q.answer)).length;
    return { title: `S${section.id}`, correct, total: section.questions.length };
  });

  return (
    <div className="rounded-2xl border border-border bg-card p-6 space-y-6">
      {/* Band Score */}
      <div className="text-center space-y-2">
        <Trophy className="h-10 w-10 text-warning mx-auto" />
        <div>
          <span className="text-4xl font-extrabold text-foreground">{bandScore}</span>
          <span className="text-lg text-muted-foreground ml-1">/ 9</span>
        </div>
        <p className="text-sm text-muted-foreground">Estimated Band Score</p>
      </div>

      {/* Overall Score */}
      <div className="rounded-xl bg-primary/5 border border-primary/10 p-4 text-center">
        <span className="text-2xl font-bold text-primary">
          {totalCorrect}/{allQuestions.length}
        </span>
        <p className="text-xs text-muted-foreground mt-1">Total Correct Answers</p>
      </div>

      {/* Per-Section Breakdown */}
      <div className="grid grid-cols-4 gap-2">
        {sectionResults.map((s) => (
          <div key={s.title} className="rounded-xl border border-border bg-background p-3 text-center">
            <p className="text-[10px] font-bold text-muted-foreground uppercase tracking-wider">{s.title}</p>
            <p
              className={cn(
                "text-lg font-bold mt-1",
                s.correct / s.total >= 0.7
                  ? "text-success"
                  : s.correct / s.total >= 0.4
                    ? "text-warning"
                    : "text-destructive"
              )}
            >
              {s.correct}/{s.total}
            </p>
          </div>
        ))}
      </div>

      {/* Actions */}
      <div className="flex flex-col gap-3">
        <div className="flex gap-3">
          <Button variant="outline" className="flex-1 gap-2" onClick={onToggleReview}>
            {reviewMode ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
            {reviewMode ? "Hide Answers" : "Review Answers"}
          </Button>
          <Button variant="default" className="flex-1 gap-2" onClick={onRetry}>
            <RotateCcw className="h-4 w-4" />
            Try Again
          </Button>
        </div>
        {onBackToLibrary && (
          <Button variant="outline" className="w-full gap-2" onClick={onBackToLibrary}>
            ← Return to Practice Library
          </Button>
        )}
      </div>
    </div>
  );
};

export default ResultsCard;
