import { motion } from "framer-motion";
import { AlertTriangle, ArrowLeft, CheckCircle, Sparkles, X } from "lucide-react";
import type React from "react";
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from "@/components/ui/accordion";
import { Progress } from "@/components/ui/progress";
import type { WritingGradingResult } from "@/services/aiGradingService";

interface Props {
  task1: WritingGradingResult;
  task2: WritingGradingResult;
  overallBand: number;
  task1WordCount: number;
  task2WordCount: number;
  task1MinWords: number;
  task2MinWords: number;
  testTitle: string;
  onClose: () => void;
  onBackToLibrary: () => void;
  onReset: () => void;
}

const bandColor = (score: number) => (score >= 7 ? "text-success" : score >= 5.5 ? "text-warning" : "text-destructive");

const bandBg = (score: number) => (score >= 7 ? "bg-success/5" : score >= 5.5 ? "text-warning/5" : "bg-destructive/5");

const progressColor = (score: number) =>
  score >= 7 ? "[&>div]:bg-success" : score >= 5.5 ? "[&>div]:bg-warning" : "[&>div]:bg-destructive";

const stagger = {
  hidden: {},
  show: { transition: { staggerChildren: 0.08 } },
};

const fadeUp = {
  hidden: { opacity: 0, y: 16 },
  show: { opacity: 1, y: 0, transition: { duration: 0.35 } },
};

const CriteriaCard: React.FC<{ label: string; score: number }> = ({ label, score }) => (
  <motion.div variants={fadeUp} className={`rounded-xl p-4 border border-border ${bandBg(score)}`}>
    <span className="text-xs font-semibold text-muted-foreground uppercase tracking-tight">{label}</span>
    <div className={`text-2xl font-bold mt-1 ${bandColor(score)}`}>{score.toFixed(1)}</div>
    <Progress value={(score / 9) * 100} className={`h-1.5 mt-2 ${progressColor(score)}`} />
  </motion.div>
);

const TaskFeedback: React.FC<{ label: string; result: WritingGradingResult }> = ({ label, result }) => (
  <AccordionItem value={label}>
    <AccordionTrigger className="text-sm font-semibold">
      <span className="flex items-center gap-2">
        {label}
        <span className={`text-xs font-bold ${bandColor(result.overallBand)}`}>
          Band {result.overallBand.toFixed(1)}
        </span>
      </span>
    </AccordionTrigger>
    <AccordionContent className="space-y-4 pt-2">
      {/* Criteria grid */}
      <div className="grid grid-cols-2 gap-2">
        <CriteriaCard label="Task Achievement" score={result.criteria.taskAchievement} />
        <CriteriaCard label="Coherence & Cohesion" score={result.criteria.coherenceCohesion} />
        <CriteriaCard label="Lexical Resource" score={result.criteria.lexicalResource} />
        <CriteriaCard label="Grammar Range" score={result.criteria.grammaticalRange} />
      </div>

      {/* Strengths */}
      <div className="space-y-1.5">
        <h4 className="text-xs font-bold uppercase tracking-wider text-success flex items-center gap-1.5">
          <CheckCircle className="h-3.5 w-3.5" /> Strengths
        </h4>
        <ul className="space-y-1">
          {result.feedback.strengths.map((s, i) => (
            <li key={i} className="text-sm text-muted-foreground flex gap-2">
              <CheckCircle className="h-3.5 w-3.5 mt-0.5 text-success shrink-0" />
              {s}
            </li>
          ))}
        </ul>
      </div>

      {/* Weaknesses */}
      <div className="space-y-1.5">
        <h4 className="text-xs font-bold uppercase tracking-wider text-warning flex items-center gap-1.5">
          <AlertTriangle className="h-3.5 w-3.5" /> Areas for Improvement
        </h4>
        <ul className="space-y-1">
          {result.feedback.weaknesses.map((w, i) => (
            <li key={i} className="text-sm text-muted-foreground flex gap-2">
              <AlertTriangle className="h-3.5 w-3.5 mt-0.5 text-warning shrink-0" />
              {w}
            </li>
          ))}
        </ul>
      </div>

      {/* Improvements */}
      <div className="rounded-xl bg-primary/5 border border-primary/10 p-4">
        <h4 className="text-xs font-bold uppercase tracking-wider text-primary flex items-center gap-1.5 mb-2">
          <Sparkles className="h-3.5 w-3.5" /> Suggested Improvements
        </h4>
        <p className="text-sm text-muted-foreground leading-relaxed">{result.feedback.improvements}</p>
      </div>
    </AccordionContent>
  </AccordionItem>
);

const WritingResultsDashboard: React.FC<Props> = ({
  task1,
  task2,
  overallBand,
  task1WordCount,
  task2WordCount,
  task1MinWords,
  task2MinWords,
  testTitle,
  onClose,
  onBackToLibrary,
  onReset,
}) => {
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-foreground/20 backdrop-blur-sm">
      <motion.div
        initial={{ opacity: 0, scale: 0.95, y: 20 }}
        animate={{ opacity: 1, scale: 1, y: 0 }}
        transition={{ duration: 0.4, ease: "easeOut" }}
        className="w-full max-w-2xl max-h-[90vh] rounded-2xl bg-card shadow-2xl overflow-hidden border border-border flex flex-col"
      >
        {/* Header */}
        <div className="bg-primary p-6 flex justify-between items-start text-primary-foreground shrink-0">
          <div>
            <h2 className="text-2xl font-bold">AI Writing Assessment</h2>
            <p className="text-primary-foreground/70 text-sm mt-1">{testTitle} · Powered by AI</p>
          </div>
          <button
            onClick={onClose}
            className="rounded-full bg-primary-foreground/10 p-2 hover:bg-primary-foreground/20 transition-colors"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        {/* Scrollable content */}
        <div className="flex-1 overflow-y-auto p-6 md:p-8 space-y-6">
          {/* Word counts */}
          <div className="flex gap-3">
            {[
              { label: "Task 1", wc: task1WordCount, min: task1MinWords },
              { label: "Task 2", wc: task2WordCount, min: task2MinWords },
            ].map((t) => (
              <div key={t.label} className="flex-1 rounded-xl border border-border bg-secondary/50 p-4">
                <span className="text-xs font-semibold text-muted-foreground uppercase">{t.label}</span>
                <div className={`text-2xl font-bold mt-1 ${t.wc >= t.min ? "text-success" : "text-warning"}`}>
                  {t.wc} <span className="text-sm font-normal text-muted-foreground">/ {t.min}+ words</span>
                </div>
              </div>
            ))}
          </div>

          {/* Overall band */}
          <motion.div variants={stagger} initial="hidden" animate="show" className="flex flex-col items-center gap-2">
            <motion.div variants={fadeUp} className="relative h-32 w-32">
              <svg className="w-full h-full -rotate-90" viewBox="0 0 36 36">
                <path
                  d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"
                  fill="none"
                  stroke="hsl(var(--border))"
                  strokeWidth="3"
                />
                <motion.path
                  d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"
                  fill="none"
                  stroke="hsl(var(--primary))"
                  strokeWidth="3"
                  initial={{ strokeDasharray: "0, 100" }}
                  animate={{
                    strokeDasharray: `${(overallBand / 9) * 100}, 100`,
                  }}
                  transition={{ duration: 1.2, ease: "easeOut", delay: 0.3 }}
                />
              </svg>
              <div className="absolute inset-0 flex flex-col items-center justify-center">
                <span className={`text-4xl font-bold ${bandColor(overallBand)}`}>{overallBand.toFixed(1)}</span>
                <span className="text-[10px] uppercase font-bold text-muted-foreground tracking-wider">
                  Overall Band
                </span>
              </div>
            </motion.div>
          </motion.div>

          {/* Task breakdowns */}
          <Accordion type="multiple" defaultValue={["Task 1", "Task 2"]} className="space-y-2">
            <TaskFeedback label="Task 1" result={task1} />
            <TaskFeedback label="Task 2" result={task2} />
          </Accordion>
        </div>

        {/* Footer */}
        <div className="border-t border-border bg-secondary/50 p-4 flex justify-end gap-3 shrink-0">
          <button
            onClick={onBackToLibrary}
            className="px-5 py-2 text-sm font-medium text-muted-foreground hover:text-foreground transition-colors flex items-center gap-1"
          >
            <ArrowLeft className="h-3.5 w-3.5" /> Practice Library
          </button>
          <button
            onClick={onClose}
            className="px-5 py-2 text-sm font-medium text-muted-foreground hover:text-foreground transition-colors"
          >
            Review Essays
          </button>
          <button
            onClick={onReset}
            className="px-5 py-2 rounded-xl bg-primary text-sm font-semibold text-primary-foreground hover:bg-primary/90 transition-colors"
          >
            Start New Test
          </button>
        </div>
      </motion.div>
    </div>
  );
};

export default WritingResultsDashboard;
