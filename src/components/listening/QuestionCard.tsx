import React from "react";
import { cn } from "@/lib/utils";
import type { ListeningQuestion } from "@/data/listeningTestData";

interface QuestionCardProps {
  question: ListeningQuestion;
  index: number;
  answer: string;
  onAnswer: (value: string) => void;
  submitted: boolean;
  reviewMode: boolean;
}

const QuestionCard: React.FC<QuestionCardProps> = ({
  question,
  index,
  answer,
  onAnswer,
  submitted,
  reviewMode,
}) => {
  const isCorrect = answer?.toLowerCase().trim() === question.answer.toLowerCase().trim();

  return (
    <div
      className={cn(
        "rounded-xl border p-4 transition-colors",
        submitted && reviewMode
          ? isCorrect
            ? "border-success/30 bg-success/5"
            : "border-destructive/30 bg-destructive/5"
          : "border-border bg-card"
      )}
    >
      <p className="text-sm font-semibold text-foreground mb-3">
        <span className="text-muted-foreground mr-1.5">{index}.</span>
        {question.text}
      </p>

      {question.type === "fill" && (
        <div className="space-y-2">
          <input
            type="text"
            value={answer || ""}
            onChange={(e) => !submitted && onAnswer(e.target.value)}
            disabled={submitted}
            placeholder="Type your answer..."
            className="w-full rounded-lg border border-border bg-background px-4 py-2.5 text-sm text-foreground placeholder:text-muted-foreground/40 outline-none focus:ring-2 focus:ring-primary/30 disabled:opacity-60"
          />
          {question.wordLimit && !submitted && (
            <p className="text-[10px] text-muted-foreground">
              Write no more than {question.wordLimit} word{question.wordLimit > 1 ? "s" : ""}
            </p>
          )}
        </div>
      )}

      {question.type === "mcq" && (
        <div className="space-y-2">
          {question.options?.map((opt) => (
            <button
              key={opt}
              onClick={() => !submitted && onAnswer(opt)}
              disabled={submitted}
              className={cn(
                "w-full text-left rounded-lg border px-4 py-2.5 text-sm transition-colors",
                answer === opt
                  ? "border-primary bg-primary/10 text-primary font-medium"
                  : "border-border text-muted-foreground hover:bg-secondary",
                submitted && reviewMode && question.answer === opt && "!border-success !bg-success/10 !text-success",
                submitted && "cursor-default"
              )}
            >
              {opt}
            </button>
          ))}
        </div>
      )}

      {question.type === "matching" && question.matchOptions && (
        <div className="space-y-3">
          <p className="text-xs text-muted-foreground whitespace-pre-line">{question.matchOptions.left}</p>
          <div className="space-y-2">
            {question.matchOptions.right.map((opt) => (
              <button
                key={opt}
                onClick={() => {
                  if (submitted) return;
                  const current = answer ? answer.split(",") : [];
                  if (current.includes(opt)) {
                    onAnswer(current.filter((c) => c !== opt).join(","));
                  } else {
                    onAnswer([...current, opt].join(","));
                  }
                }}
                disabled={submitted}
                className={cn(
                  "w-full text-left rounded-lg border px-4 py-2.5 text-sm transition-colors",
                  answer?.split(",").includes(opt)
                    ? "border-primary bg-primary/10 text-primary"
                    : "border-border text-muted-foreground hover:bg-secondary",
                  submitted && "cursor-default"
                )}
              >
                {opt}
              </button>
            ))}
          </div>
        </div>
      )}

      {submitted && reviewMode && (
        <p
          className={cn(
            "mt-2 text-xs font-medium",
            isCorrect ? "text-success" : "text-destructive"
          )}
        >
          {isCorrect ? "✓ Correct" : `✗ Correct answer: ${question.answer}`}
        </p>
      )}
    </div>
  );
};

export default QuestionCard;
