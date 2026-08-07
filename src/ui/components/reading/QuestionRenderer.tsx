import React from "react";
import { cn } from "@/lib/utils";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { Checkbox } from "@/components/ui/checkbox";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { CheckCircle2, XCircle, HelpCircle, ArrowRight, X } from "lucide-react";
import type {
  QuestionSection,
  MCQuestion,
  MatchingInformationQuestion,
  MatchingHeadingsQuestion,
  MatchingFeaturesQuestion,
  MatchingSentenceEndingsQuestion,
  SentenceCompletionQuestion,
  SummaryCompletionQuestion,
  NoteCompletionQuestion,
  TableCompletionQuestion,
  FlowchartCompletionQuestion,
  ShortAnswerQuestion,
} from "@/data/readingTestData";
import { tfngQuestions as defaultTfng, mcQuestions as defaultMc, ynngQuestions as defaultYnng } from "@/data/readingTestData";

// ─── Types ──────────────────────────────────────────

export type Answers = Record<string, string | string[]>;

interface SectionProps {
  data: QuestionSection;
  answers: Answers;
  onAnswer: (key: string, value: string) => void;
  submitted: boolean;
  tfngOverride?: typeof defaultTfng;
  mcOverride?: typeof defaultMc;
  ynngOverride?: typeof defaultYnng;
}

// ─── Status icon helper ─────────────────────────────

const AnswerStatus = ({ correct }: { correct: boolean }) =>
  correct ? (
    <CheckCircle2 className="h-4 w-4 text-success shrink-0" />
  ) : (
    <XCircle className="h-4 w-4 text-destructive shrink-0" />
  );

// ─── 1. TRUE / FALSE / NOT GIVEN ────────────────────

const TFNGRenderer: React.FC<SectionProps> = ({ answers, onAnswer, submitted, tfngOverride }) => {
  const tfngQuestions = tfngOverride || defaultTfng;
  const options = ["TRUE", "FALSE", "NOT GIVEN"];
  return (
    <div className="space-y-4">
      {tfngQuestions.map((q) => {
        const selected = answers[q.id] as string;
        const isCorrect = selected === q.answer;
        return (
          <div key={q.id} className="rounded-lg border border-border bg-card p-4 space-y-3">
            <p className="text-sm font-medium text-foreground">
              <span className="font-bold text-primary mr-2">{q.label}.</span>
              {q.text}
            </p>
            <div className="flex flex-wrap gap-2">
              {options.map((opt) => (
                <button
                  key={opt}
                  onClick={() => !submitted && onAnswer(q.id, opt)}
                  disabled={submitted}
                  className={cn(
                    "rounded-lg border px-4 py-2 text-xs font-semibold transition-all",
                    selected === opt
                      ? "border-primary bg-primary/10 text-primary ring-2 ring-primary/20"
                      : "border-border text-muted-foreground hover:bg-secondary",
                    submitted && q.answer === opt && "!border-success !bg-success/10 !text-success",
                    submitted && selected === opt && !isCorrect && "!border-destructive !bg-destructive/10 !text-destructive"
                  )}
                >
                  {opt}
                </button>
              ))}
            </div>
            {submitted && (
              <div className="flex items-center gap-1.5 text-xs">
                <AnswerStatus correct={isCorrect} />
                <span className={isCorrect ? "text-success" : "text-destructive"}>
                  {isCorrect ? "Correct" : `Answer: ${q.answer}`}
                </span>
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
};

// ─── 2. YES / NO / NOT GIVEN ────────────────────────

const YNNGRenderer: React.FC<SectionProps> = ({ answers, onAnswer, submitted, ynngOverride }) => {
  const ynngQuestions = ynngOverride || defaultYnng;
  const options = ["YES", "NO", "NOT GIVEN"];
  return (
    <div className="space-y-4">
      {ynngQuestions.map((q) => {
        const selected = answers[q.id] as string;
        const isCorrect = selected === q.answer;
        return (
          <div key={q.id} className="rounded-lg border border-border bg-card p-4 space-y-3">
            <p className="text-sm font-medium text-foreground">
              <span className="font-bold text-primary mr-2">{q.label}.</span>
              {q.text}
            </p>
            <div className="flex flex-wrap gap-2">
              {options.map((opt) => (
                <button
                  key={opt}
                  onClick={() => !submitted && onAnswer(q.id, opt)}
                  disabled={submitted}
                  className={cn(
                    "rounded-lg border px-4 py-2 text-xs font-semibold transition-all",
                    selected === opt
                      ? "border-primary bg-primary/10 text-primary ring-2 ring-primary/20"
                      : "border-border text-muted-foreground hover:bg-secondary",
                    submitted && q.answer === opt && "!border-success !bg-success/10 !text-success",
                    submitted && selected === opt && !isCorrect && "!border-destructive !bg-destructive/10 !text-destructive"
                  )}
                >
                  {opt}
                </button>
              ))}
            </div>
            {submitted && (
              <div className="flex items-center gap-1.5 text-xs">
                <AnswerStatus correct={isCorrect} />
                <span className={isCorrect ? "text-success" : "text-destructive"}>
                  {isCorrect ? "Correct" : `Answer: ${q.answer}`}
                </span>
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
};

// ─── 3. MULTIPLE CHOICE ─────────────────────────────

const MCRenderer: React.FC<SectionProps> = ({ answers, onAnswer, submitted, mcOverride }) => {
  const mcQuestions = mcOverride || defaultMc;
  return (
    <div className="space-y-5">
      {mcQuestions.map((q) => {
        const selected = answers[q.id] as string;
        const isCorrect = selected === q.answer;
        return (
          <div key={q.id} className="rounded-lg border border-border bg-card p-4 space-y-3">
            <p className="text-sm font-medium text-foreground">
              <span className="font-bold text-primary mr-2">{q.label}.</span>
              {q.text}
            </p>
            <RadioGroup
              value={selected || ""}
              onValueChange={(v) => !submitted && onAnswer(q.id, v)}
              disabled={submitted}
              className="space-y-2"
            >
              {q.options.map((opt) => (
                <div
                  key={opt}
                  className={cn(
                    "flex items-center gap-3 rounded-lg border px-4 py-2.5 transition-all cursor-pointer",
                    selected === opt
                      ? "border-primary bg-primary/5 ring-1 ring-primary/20"
                      : "border-border hover:bg-secondary",
                    submitted && q.answer === opt && "!border-success !bg-success/10",
                    submitted && selected === opt && !isCorrect && "!border-destructive !bg-destructive/10"
                  )}
                >
                  <RadioGroupItem value={opt} id={`${q.id}-${opt}`} />
                  <Label htmlFor={`${q.id}-${opt}`} className="text-sm cursor-pointer flex-1">
                    {opt}
                  </Label>
                </div>
              ))}
            </RadioGroup>
            {submitted && (
              <div className="flex items-center gap-1.5 text-xs">
                <AnswerStatus correct={isCorrect} />
                <span className={isCorrect ? "text-success" : "text-destructive"}>
                  {isCorrect ? "Correct" : `Answer: ${q.answer}`}
                </span>
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
};

// ─── 4. MATCHING INFORMATION ────────────────────────

const MatchingInformationRenderer: React.FC<SectionProps> = ({ data, answers, onAnswer, submitted }) => {
  const d = data as MatchingInformationQuestion;
  return (
    <div className="space-y-3">
      {d.statements.map((s) => {
        const key = `mi_${s.label}`;
        const selected = answers[key] as string;
        const correct = d.answers[s.label];
        const isCorrect = selected === correct;
        return (
          <div key={s.label} className="rounded-lg border border-border bg-card p-4 space-y-2">
            <p className="text-sm font-medium text-foreground">
              <span className="font-bold text-primary mr-2">{s.label}.</span>
              {s.text}
            </p>
            <Select
              value={selected || ""}
              onValueChange={(v) => !submitted && onAnswer(key, v)}
              disabled={submitted}
            >
              <SelectTrigger className="w-40">
                <SelectValue placeholder="Paragraph" />
              </SelectTrigger>
              <SelectContent>
                {d.paragraphs.filter((p) => p !== "").map((p) => (
                  <SelectItem key={p} value={p}>Paragraph {p}</SelectItem>
                ))}
              </SelectContent>
            </Select>
            {submitted && (
              <div className="flex items-center gap-1.5 text-xs">
                <AnswerStatus correct={isCorrect} />
                <span className={isCorrect ? "text-success" : "text-destructive"}>
                  {isCorrect ? "Correct" : `Answer: Paragraph ${correct}`}
                </span>
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
};

// ─── 5. MATCHING HEADINGS ───────────────────────────

const MatchingHeadingsRenderer: React.FC<SectionProps> = ({ data, answers, onAnswer, submitted }) => {
  const d = data as MatchingHeadingsQuestion;
  return (
    <div className="space-y-2">
      <div className="rounded-lg border border-border bg-secondary/50 p-3 mb-4">
        <p className="text-xs font-semibold text-muted-foreground mb-2">List of Headings</p>
        <div className="space-y-1">
          {d.headings.map((h, i) => (
            <p key={i} className="text-xs text-foreground">{h}</p>
          ))}
        </div>
      </div>
      {d.paragraphs.map((para, idx) => {
        const qNum = 13 + idx;
        const key = `mh_${para}`;
        const selected = answers[key] as string;
        const correct = d.answers[para];
        const isCorrect = selected === correct;
        return (
          <div key={para} className="flex items-center gap-3 rounded-lg border border-border bg-card p-3">
            <span className="text-sm font-bold text-primary w-6">{qNum}.</span>
            <span className="text-sm font-medium text-foreground flex-1">Paragraph {para}</span>
            <Select
              value={selected || ""}
              onValueChange={(v) => !submitted && onAnswer(key, v)}
              disabled={submitted}
            >
              <SelectTrigger className="w-28">
                <SelectValue placeholder="Heading" />
              </SelectTrigger>
              <SelectContent>
                {d.headings.map((h) => {
                  const numeral = h.split(".")[0]?.trim() || h;
                  const safeValue = numeral || `heading_${h}`;
                  return (
                    <SelectItem key={safeValue} value={safeValue}>{numeral || h}</SelectItem>
                  );
                })}
              </SelectContent>
            </Select>
            {submitted && (
              <div className="flex items-center gap-1">
                <AnswerStatus correct={isCorrect} />
                {!isCorrect && <span className="text-xs text-destructive">{correct}</span>}
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
};

// ─── 6. MATCHING FEATURES ───────────────────────────

const MatchingFeaturesRenderer: React.FC<SectionProps> = ({ data, answers, onAnswer, submitted }) => {
  const d = data as MatchingFeaturesQuestion;
  return (
    <div className="space-y-2">
      <div className="rounded-lg border border-border bg-secondary/50 p-3 mb-4">
        <p className="text-xs font-semibold text-muted-foreground mb-2">List of Researchers</p>
        {d.entities.map((e, i) => (
          <p key={i} className="text-xs text-foreground">{e}</p>
        ))}
      </div>
      {d.features.map((f) => {
        const key = `mf_${f.label}`;
        const selected = answers[key] as string;
        const correct = d.answers[f.label];
        const isCorrect = selected === correct;
        return (
          <div key={f.label} className="rounded-lg border border-border bg-card p-4 space-y-2">
            <p className="text-sm font-medium text-foreground">
              <span className="font-bold text-primary mr-2">{f.label}.</span>
              {f.text}
            </p>
            <Select
              value={selected || ""}
              onValueChange={(v) => !submitted && onAnswer(key, v)}
              disabled={submitted}
            >
              <SelectTrigger className="w-56">
                <SelectValue placeholder="Select researcher" />
              </SelectTrigger>
              <SelectContent>
                {d.entities.filter((e) => e !== "").map((e) => (
                  <SelectItem key={e} value={e}>{e}</SelectItem>
                ))}
              </SelectContent>
            </Select>
            {submitted && (
              <div className="flex items-center gap-1.5 text-xs">
                <AnswerStatus correct={isCorrect} />
                <span className={isCorrect ? "text-success" : "text-destructive"}>
                  {isCorrect ? "Correct" : `Answer: ${correct}`}
                </span>
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
};

// ─── 7. MATCHING SENTENCE ENDINGS ───────────────────

const MatchingSentenceEndingsRenderer: React.FC<SectionProps> = ({ data, answers, onAnswer, submitted }) => {
  const d = data as MatchingSentenceEndingsQuestion;
  return (
    <div className="space-y-2">
      <div className="rounded-lg border border-border bg-secondary/50 p-3 mb-4">
        <p className="text-xs font-semibold text-muted-foreground mb-2">Sentence Endings</p>
        {d.endings.map((e) => (
          <p key={e.label} className="text-xs text-foreground"><span className="font-bold">{e.label}.</span> {e.text}</p>
        ))}
      </div>
      {d.stems.map((s) => {
        const key = `mse_${s.label}`;
        const selected = answers[key] as string;
        const correct = d.answers[s.label];
        const isCorrect = selected === correct;
        return (
          <div key={s.label} className="rounded-lg border border-border bg-card p-4 space-y-2">
            <p className="text-sm font-medium text-foreground">
              <span className="font-bold text-primary mr-2">{s.label}.</span>
              {s.text}...
            </p>
            <Select
              value={selected || ""}
              onValueChange={(v) => !submitted && onAnswer(key, v)}
              disabled={submitted}
            >
              <SelectTrigger className="w-24">
                <SelectValue placeholder="Ending" />
              </SelectTrigger>
              <SelectContent>
                {d.endings.filter((e) => e.label !== "").map((e) => (
                  <SelectItem key={e.label} value={e.label}>{e.label}</SelectItem>
                ))}
              </SelectContent>
            </Select>
            {submitted && (
              <div className="flex items-center gap-1.5 text-xs">
                <AnswerStatus correct={isCorrect} />
                <span className={isCorrect ? "text-success" : "text-destructive"}>
                  {isCorrect ? "Correct" : `Answer: ${correct}`}
                </span>
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
};

// ─── 8. SENTENCE COMPLETION ─────────────────────────

const SentenceCompletionRenderer: React.FC<SectionProps> = ({ data, answers, onAnswer, submitted }) => {
  const d = data as SentenceCompletionQuestion;
  return (
    <div className="space-y-4">
      <Badge variant="outline" className="text-xs">
        <HelpCircle className="h-3 w-3 mr-1" /> No more than {d.wordLimit} word{d.wordLimit > 1 ? "s" : ""}
      </Badge>
      {d.sentences.map((s) => {
        const key = `sc_${s.gap}`;
        const val = (answers[key] as string) || "";
        const isCorrect = val.toLowerCase().trim() === s.answer.toLowerCase();
        const parts = s.text.split("{{gap}}");
        return (
          <div key={s.gap} className="rounded-lg border border-border bg-card p-4 space-y-2">
            <div className="text-sm font-medium text-foreground flex flex-wrap items-center gap-1">
              <span className="font-bold text-primary mr-1">{s.label}.</span>
              <span>{parts[0]}</span>
              <Input
                value={val}
                onChange={(e) => !submitted && onAnswer(key, e.target.value)}
                disabled={submitted}
                placeholder="Type answer..."
                className={cn(
                  "inline-block w-40 h-8 text-sm",
                  submitted && isCorrect && "border-success bg-success/10",
                  submitted && !isCorrect && val && "border-destructive bg-destructive/10"
                )}
              />
              <span>{parts[1]}</span>
            </div>
            {submitted && (
              <div className="flex items-center gap-1.5 text-xs">
                <AnswerStatus correct={isCorrect} />
                <span className={isCorrect ? "text-success" : "text-destructive"}>
                  {isCorrect ? "Correct" : `Answer: ${s.answer}`}
                </span>
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
};

// ─── 9. SUMMARY COMPLETION ──────────────────────────

const SummaryCompletionRenderer: React.FC<SectionProps> = ({ data, answers, onAnswer, submitted }) => {
  const d = data as SummaryCompletionQuestion;

  const renderSummary = () => {
    const parts = d.summaryText.split(/(\{\{[^}]+\}\})/);
    return parts.map((part, i) => {
      const match = part.match(/\{\{([^}]+)\}\}/);
      if (match) {
        const gapId = match[1];
        const gap = d.gaps.find((g) => g.id === gapId);
        if (!gap) return null;
        const key = `sumc_${gapId}`;
        const val = (answers[key] as string) || "";
        const isCorrect = val.toLowerCase().trim() === gap.answer.toLowerCase();

        if (d.useWordBank && d.wordBank) {
          return (
            <Select
              key={i}
              value={val}
              onValueChange={(v) => !submitted && onAnswer(key, v)}
              disabled={submitted}
            >
              <SelectTrigger className={cn(
                "inline-flex w-40 h-8 text-xs mx-1",
                submitted && isCorrect && "border-success",
                submitted && !isCorrect && val && "border-destructive"
              )}>
                <SelectValue placeholder="Select..." />
              </SelectTrigger>
              <SelectContent>
                {d.wordBank!.filter((w) => w !== "").map((w) => (
                  <SelectItem key={w} value={w}>{w}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          );
        }

        return (
          <Input
            key={i}
            value={val}
            onChange={(e) => !submitted && onAnswer(key, e.target.value)}
            disabled={submitted}
            placeholder="..."
            className={cn(
              "inline-block w-36 h-8 text-xs mx-1",
              submitted && isCorrect && "border-success bg-success/10",
              submitted && !isCorrect && val && "border-destructive bg-destructive/10"
            )}
          />
        );
      }
      return <span key={i} className="text-sm text-foreground">{part}</span>;
    });
  };

  return (
    <div className="space-y-4">
      <Badge variant="outline" className="text-xs">
        <HelpCircle className="h-3 w-3 mr-1" /> No more than {d.wordLimit} word{d.wordLimit > 1 ? "s" : ""}
      </Badge>
      {d.useWordBank && d.wordBank && (
        <div className="flex flex-wrap gap-1.5 p-3 rounded-lg border border-border bg-secondary/50">
          {d.wordBank.map((w) => (
            <Badge key={w} variant="secondary" className="text-xs">{w}</Badge>
          ))}
        </div>
      )}
      <div className="rounded-lg border border-border bg-card p-4 leading-relaxed flex flex-wrap items-center gap-y-2">
        {renderSummary()}
      </div>
      {submitted && (
        <div className="space-y-1">
          {d.gaps.map((g) => {
            const key = `sumc_${g.id}`;
            const val = (answers[key] as string) || "";
            const isCorrect = val.toLowerCase().trim() === g.answer.toLowerCase();
            return (
              <div key={g.id} className="flex items-center gap-1.5 text-xs">
                <AnswerStatus correct={isCorrect} />
                <span className={isCorrect ? "text-success" : "text-destructive"}>
                  {g.id}: {isCorrect ? "Correct" : `Answer: ${g.answer}`}
                </span>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
};

// ─── 10. NOTE COMPLETION ────────────────────────────

const NoteCompletionRenderer: React.FC<SectionProps> = ({ data, answers, onAnswer, submitted }) => {
  const d = data as NoteCompletionQuestion;
  return (
    <div className="space-y-4">
      <Badge variant="outline" className="text-xs">
        <HelpCircle className="h-3 w-3 mr-1" /> No more than {d.wordLimit} word{d.wordLimit > 1 ? "s" : ""}
      </Badge>
      {d.notes.map((n) => {
        const key = `nc_${n.gap}`;
        const val = (answers[key] as string) || "";
        const isCorrect = val.toLowerCase().trim() === n.answer.toLowerCase();
        const parts = n.text.split("{{gap}}");
        return (
          <div key={n.gap} className="rounded-lg border border-border bg-card p-4 space-y-2">
            <div className="text-sm font-medium text-foreground flex flex-wrap items-center gap-1">
              <span className="font-bold text-primary mr-1">{n.label}.</span>
              <span>{parts[0]}</span>
              <Input
                value={val}
                onChange={(e) => !submitted && onAnswer(key, e.target.value)}
                disabled={submitted}
                placeholder="Type answer..."
                className={cn(
                  "inline-block w-40 h-8 text-sm",
                  submitted && isCorrect && "border-success bg-success/10",
                  submitted && !isCorrect && val && "border-destructive bg-destructive/10"
                )}
              />
              {parts[1] && <span>{parts[1]}</span>}
            </div>
            {submitted && (
              <div className="flex items-center gap-1.5 text-xs">
                <AnswerStatus correct={isCorrect} />
                <span className={isCorrect ? "text-success" : "text-destructive"}>
                  {isCorrect ? "Correct" : `Answer: ${n.answer}`}
                </span>
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
};

// ─── 11. TABLE COMPLETION ───────────────────────────

const TableCompletionRenderer: React.FC<SectionProps> = ({ data, answers, onAnswer, submitted }) => {
  const d = data as TableCompletionQuestion;
  return (
    <div className="space-y-4">
      <Badge variant="outline" className="text-xs">
        <HelpCircle className="h-3 w-3 mr-1" /> No more than {d.wordLimit} word{d.wordLimit > 1 ? "s" : ""}
      </Badge>
      <div className="rounded-lg border border-border overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="bg-secondary">
              {d.headers.map((h) => (
                <th key={h} className="px-4 py-2.5 text-left font-semibold text-foreground">{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {d.rows.map((row, ri) => (
              <tr key={ri} className="border-t border-border">
                {row.cells.map((cell, ci) => (
                  <td key={ci} className="px-4 py-2.5">
                    {typeof cell === "string" ? (
                      <span className="text-foreground">{cell}</span>
                    ) : (
                      (() => {
                        const key = `tc_${cell.gap}`;
                        const val = (answers[key] as string) || "";
                        const isCorrect = val.toLowerCase().trim() === cell.answer.toLowerCase();
                        return (
                          <div className="space-y-1">
                            <Input
                              value={val}
                              onChange={(e) => !submitted && onAnswer(key, e.target.value)}
                              disabled={submitted}
                              placeholder="..."
                              className={cn(
                                "h-8 text-sm w-full",
                                submitted && isCorrect && "border-success bg-success/10",
                                submitted && !isCorrect && val && "border-destructive bg-destructive/10"
                              )}
                            />
                            {submitted && !isCorrect && (
                              <span className="text-xs text-destructive">{cell.answer}</span>
                            )}
                          </div>
                        );
                      })()
                    )}
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

// ─── 12. FLOWCHART COMPLETION ───────────────────────

const FlowchartCompletionRenderer: React.FC<SectionProps> = ({ data, answers, onAnswer, submitted }) => {
  const d = data as FlowchartCompletionQuestion;
  return (
    <div className="space-y-4">
      <Badge variant="outline" className="text-xs">
        <HelpCircle className="h-3 w-3 mr-1" /> No more than {d.wordLimit} word{d.wordLimit > 1 ? "s" : ""}
      </Badge>
      <div className="space-y-0">
        {d.steps.map((step, i) => {
          const hasGap = !!step.gap;
          return (
            <div key={i}>
              <div className="rounded-lg border border-border bg-card p-4 flex flex-wrap items-center gap-1 text-sm text-foreground">
                {hasGap ? (
                  (() => {
                    const parts = step.text.split("{{gap}}");
                    const key = `fc_${step.gap}`;
                    const val = (answers[key] as string) || "";
                    const isCorrect = val.toLowerCase().trim() === step.answer!.toLowerCase();
                    return (
                      <>
                        <span>{parts[0]}</span>
                        <Input
                          value={val}
                          onChange={(e) => !submitted && onAnswer(key, e.target.value)}
                          disabled={submitted}
                          placeholder="..."
                          className={cn(
                            "inline-block w-36 h-8 text-sm",
                            submitted && isCorrect && "border-success bg-success/10",
                            submitted && !isCorrect && val && "border-destructive bg-destructive/10"
                          )}
                        />
                        <span>{parts[1]}</span>
                        {submitted && !isCorrect && (
                          <span className="text-xs text-destructive ml-2">({step.answer})</span>
                        )}
                      </>
                    );
                  })()
                ) : (
                  <span className="font-medium">{step.text}</span>
                )}
              </div>
              {i < d.steps.length - 1 && (
                <div className="flex justify-center py-1">
                  <ArrowRight className="h-4 w-4 text-muted-foreground rotate-90" />
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
};

// ─── 13. SHORT ANSWER ───────────────────────────────

const ShortAnswerRenderer: React.FC<SectionProps> = ({ data, answers, onAnswer, submitted }) => {
  const d = data as ShortAnswerQuestion;
  return (
    <div className="space-y-4">
      <Badge variant="outline" className="text-xs">
        <HelpCircle className="h-3 w-3 mr-1" /> No more than {d.wordLimit} word{d.wordLimit > 1 ? "s" : ""}
      </Badge>
      {d.questions.map((q) => {
        const key = `sa_${q.label}`;
        const val = (answers[key] as string) || "";
        const accepted = q.acceptedAnswers || [q.answer];
        const isCorrect = accepted.some((a) => val.toLowerCase().trim() === a.toLowerCase());
        return (
          <div key={q.label} className="rounded-lg border border-border bg-card p-4 space-y-2">
            <p className="text-sm font-medium text-foreground">
              <span className="font-bold text-primary mr-2">{q.label}.</span>
              {q.text}
            </p>
            <div className="flex items-center gap-2">
              <Input
                value={val}
                onChange={(e) => !submitted && onAnswer(key, e.target.value)}
                disabled={submitted}
                placeholder="Type answer..."
                className={cn(
                  "flex-1 h-9",
                  submitted && isCorrect && "border-success bg-success/10",
                  submitted && !isCorrect && val && "border-destructive bg-destructive/10"
                )}
              />
              {val && !submitted && (
                <button onClick={() => onAnswer(key, "")} className="text-muted-foreground hover:text-foreground">
                  <X className="h-4 w-4" />
                </button>
              )}
            </div>
            {submitted && (
              <div className="flex items-center gap-1.5 text-xs">
                <AnswerStatus correct={isCorrect} />
                <span className={isCorrect ? "text-success" : "text-destructive"}>
                  {isCorrect ? "Correct" : `Answer: ${q.answer}`}
                </span>
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
};

// ─── MAIN RENDERER ──────────────────────────────────

interface QuestionRendererProps {
  section: {
    title: string;
    instructions: string;
    data: QuestionSection;
  };
  answers: Answers;
  onAnswer: (key: string, value: string) => void;
  submitted: boolean;
  tfngOverride?: typeof defaultTfng;
  mcOverride?: typeof defaultMc;
  ynngOverride?: typeof defaultYnng;
}

const typeBadgeColors: Record<string, string> = {
  TRUE_FALSE_NOT_GIVEN: "bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400",
  YES_NO_NOT_GIVEN: "bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400",
  MULTIPLE_CHOICE: "bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400",
  MATCHING_INFORMATION: "bg-violet-100 text-violet-700 dark:bg-violet-900/30 dark:text-violet-400",
  MATCHING_HEADINGS: "bg-violet-100 text-violet-700 dark:bg-violet-900/30 dark:text-violet-400",
  MATCHING_FEATURES: "bg-violet-100 text-violet-700 dark:bg-violet-900/30 dark:text-violet-400",
  MATCHING_SENTENCE_ENDINGS: "bg-violet-100 text-violet-700 dark:bg-violet-900/30 dark:text-violet-400",
  SENTENCE_COMPLETION: "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400",
  SUMMARY_COMPLETION: "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400",
  NOTE_COMPLETION: "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400",
  TABLE_COMPLETION: "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400",
  FLOWCHART_COMPLETION: "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400",
  SHORT_ANSWER: "bg-rose-100 text-rose-700 dark:bg-rose-900/30 dark:text-rose-400",
};

const typeLabels: Record<string, string> = {
  TRUE_FALSE_NOT_GIVEN: "Identification",
  YES_NO_NOT_GIVEN: "Identification",
  MULTIPLE_CHOICE: "Multiple Choice",
  MATCHING_INFORMATION: "Matching",
  MATCHING_HEADINGS: "Matching",
  MATCHING_FEATURES: "Matching",
  MATCHING_SENTENCE_ENDINGS: "Matching",
  SENTENCE_COMPLETION: "Completion",
  SUMMARY_COMPLETION: "Completion",
  NOTE_COMPLETION: "Completion",
  TABLE_COMPLETION: "Completion",
  FLOWCHART_COMPLETION: "Completion",
  SHORT_ANSWER: "Short Answer",
};

export const QuestionRenderer: React.FC<QuestionRendererProps> = ({
  section,
  answers,
  onAnswer,
  submitted,
  tfngOverride,
  mcOverride,
  ynngOverride,
}) => {
  const type = section.data.type;
  const badgeColor = typeBadgeColors[type] || "";
  const label = typeLabels[type] || type;

  const renderSection = () => {
    const props: SectionProps = { data: section.data, answers, onAnswer, submitted, tfngOverride, mcOverride, ynngOverride };
    switch (type) {
      case "TRUE_FALSE_NOT_GIVEN": return <TFNGRenderer {...props} />;
      case "YES_NO_NOT_GIVEN": return <YNNGRenderer {...props} />;
      case "MULTIPLE_CHOICE": return <MCRenderer {...props} />;
      case "MATCHING_INFORMATION": return <MatchingInformationRenderer {...props} />;
      case "MATCHING_HEADINGS": return <MatchingHeadingsRenderer {...props} />;
      case "MATCHING_FEATURES": return <MatchingFeaturesRenderer {...props} />;
      case "MATCHING_SENTENCE_ENDINGS": return <MatchingSentenceEndingsRenderer {...props} />;
      case "SENTENCE_COMPLETION": return <SentenceCompletionRenderer {...props} />;
      case "SUMMARY_COMPLETION": return <SummaryCompletionRenderer {...props} />;
      case "NOTE_COMPLETION": return <NoteCompletionRenderer {...props} />;
      case "TABLE_COMPLETION": return <TableCompletionRenderer {...props} />;
      case "FLOWCHART_COMPLETION": return <FlowchartCompletionRenderer {...props} />;
      case "SHORT_ANSWER": return <ShortAnswerRenderer {...props} />;
      default: return <p className="text-muted-foreground text-sm">Unknown question type</p>;
    }
  };

  return (
    <div className="space-y-4">
      <div className="space-y-2">
        <div className="flex items-center gap-2">
          <h3 className="text-sm font-bold text-foreground">{section.title}</h3>
          <span className={cn("inline-flex items-center rounded-full px-2 py-0.5 text-[10px] font-semibold", badgeColor)}>
            {label}
          </span>
        </div>
        <p className="text-xs text-muted-foreground italic">{section.instructions}</p>
      </div>
      {renderSection()}
    </div>
  );
};
