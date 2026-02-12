import React, { useState, useMemo } from "react";
import { BookOpen, CheckCircle2, RotateCcw, Clock } from "lucide-react";
import { DashboardLayout } from "@/components/DashboardLayout";
import { QuestionRenderer, type Answers } from "@/components/reading/QuestionRenderer";
import { comprehensiveReadingTest } from "@/data/readingTestData";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import { motion, AnimatePresence } from "framer-motion";

const ReadingModule: React.FC = () => {
  const [answers, setAnswers] = useState<Answers>({});
  const [submitted, setSubmitted] = useState(false);

  const test = comprehensiveReadingTest;

  const handleAnswer = (key: string, value: string) => {
    if (submitted) return;
    setAnswers((prev) => ({ ...prev, [key]: value }));
  };

  const answeredCount = Object.values(answers).filter((v) => v && (typeof v === "string" ? v.trim() : v.length)).length;
  const totalQuestions = 40;

  const handleReset = () => {
    setAnswers({});
    setSubmitted(false);
  };

  return (
    <DashboardLayout>
      <div className="flex flex-col md:flex-row h-[calc(100vh-4rem)] overflow-hidden">
        {/* Passage Pane */}
        <div className="flex-1 overflow-y-auto border-b md:border-b-0 md:border-r border-border bg-card p-6 md:p-10">
          <div className="max-w-2xl mx-auto">
            <div className="flex items-center gap-2 mb-6">
              <BookOpen className="h-5 w-5 text-primary" />
              <h1 className="text-xl font-bold text-foreground">Reading Passage</h1>
            </div>
            <h2 className="text-2xl font-serif font-bold text-foreground mb-6">{test.title}</h2>
            {test.passage.split("\n\n").map((para, i) => (
              <p key={i} className="text-base font-serif leading-[1.9] text-foreground/90 mb-4">{para}</p>
            ))}
          </div>
        </div>

        {/* Questions Pane */}
        <div className="w-full md:w-[460px] lg:w-[520px] flex flex-col shrink-0 bg-background">
          {/* Progress Header */}
          <div className="sticky top-0 z-10 bg-background border-b border-border px-6 py-3">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <h2 className="text-lg font-bold text-foreground">Questions</h2>
                <Badge variant="secondary" className="text-xs">
                  {answeredCount}/{totalQuestions}
                </Badge>
              </div>
              {submitted && (
                <Badge className="bg-success/10 text-success border-success/20 text-xs">
                  <CheckCircle2 className="h-3 w-3 mr-1" /> Submitted
                </Badge>
              )}
            </div>
            <div className="mt-2 h-1.5 rounded-full bg-secondary overflow-hidden">
              <motion.div
                className="h-full bg-primary rounded-full"
                initial={{ width: 0 }}
                animate={{ width: `${(answeredCount / totalQuestions) * 100}%` }}
                transition={{ duration: 0.3 }}
              />
            </div>
          </div>

          {/* Scrollable Questions */}
          <div className="flex-1 overflow-y-auto px-6 py-6 space-y-8">
            {test.sections.map((section, i) => (
              <React.Fragment key={i}>
                {i > 0 && <Separator className="my-2" />}
                <QuestionRenderer
                  section={section}
                  answers={answers}
                  onAnswer={handleAnswer}
                  submitted={submitted}
                />
              </React.Fragment>
            ))}
          </div>

          {/* Action Footer */}
          <div className="sticky bottom-0 bg-background border-t border-border px-6 py-4">
            {!submitted ? (
              <button
                onClick={() => setSubmitted(true)}
                disabled={answeredCount === 0}
                className="w-full rounded-xl bg-primary py-3 text-sm font-semibold text-primary-foreground shadow-lg shadow-primary/20 disabled:opacity-50 transition-all hover:scale-[1.01]"
              >
                <CheckCircle2 className="h-4 w-4 inline mr-2" />
                Check Answers ({answeredCount} answered)
              </button>
            ) : (
              <button
                onClick={handleReset}
                className="w-full rounded-xl border border-border py-3 text-sm font-semibold text-foreground hover:bg-secondary transition-colors flex items-center justify-center gap-2"
              >
                <RotateCcw className="h-4 w-4" />
                Try Again
              </button>
            )}
          </div>
        </div>
      </div>
    </DashboardLayout>
  );
};

export default ReadingModule;
