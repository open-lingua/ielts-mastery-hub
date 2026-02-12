import React, { useState, useCallback, useRef, useMemo } from "react";
import { BookOpen, CheckCircle2, RotateCcw, Trophy, Eye, EyeOff, ChevronRight } from "lucide-react";
import { DashboardLayout } from "@/components/DashboardLayout";
import { QuestionRenderer, type Answers } from "@/components/reading/QuestionRenderer";
import { multiPassageReadingTest, calculateReadingBandScore, p2YnngQuestions, p3McQuestions } from "@/data/readingTestData";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { Tooltip, TooltipContent, TooltipTrigger, TooltipProvider } from "@/components/ui/tooltip";
import UnifiedTimer, { TimeUpOverlay } from "@/components/shared/UnifiedTimer";
import { motion, AnimatePresence } from "framer-motion";
import { cn } from "@/lib/utils";

const ReadingModule: React.FC = () => {
  const test = multiPassageReadingTest;
  const [activePassage, setActivePassage] = useState(0);
  const [answers, setAnswers] = useState<Answers>({});
  const [submitted, setSubmitted] = useState(false);
  const [reviewMode, setReviewMode] = useState(false);
  const [visitedPassages, setVisitedPassages] = useState<boolean[]>([true, false, false]);
  const [autoSubmitted, setAutoSubmitted] = useState(false);
  const [timerKey, setTimerKey] = useState(0);
  const passagePaneRef = useRef<HTMLDivElement>(null);
  const questionPaneRef = useRef<HTMLDivElement>(null);

  const handleTimeUp = useCallback(() => {
    if (submitted) return;
    setAutoSubmitted(true);
    setSubmitted(true);
  }, [submitted]);

  const handleAnswer = useCallback((key: string, value: string) => {
    if (submitted) return;
    setAnswers((prev) => ({ ...prev, [key]: value }));
  }, [submitted]);

  const handlePassageChange = useCallback((idx: number) => {
    setActivePassage(idx);
    setVisitedPassages((prev) => {
      const next = [...prev];
      next[idx] = true;
      return next;
    });
    passagePaneRef.current?.scrollTo({ top: 0, behavior: "smooth" });
    questionPaneRef.current?.scrollTo({ top: 0, behavior: "smooth" });
  }, []);

  const handleReset = () => {
    setAnswers({});
    setSubmitted(false);
    setReviewMode(false);
    setActivePassage(0);
    setVisitedPassages([true, false, false]);
    setAutoSubmitted(false);
    setTimerKey((k) => k + 1);
  };

  const answeredCount = Object.values(answers).filter((v) => v && (typeof v === "string" ? v.trim() : true)).length;
  const totalQuestions = 40;

  const passageQuestionRanges = [
    { start: 1, end: 13 },
    { start: 14, end: 27 },
    { start: 28, end: 40 },
  ];

  const getQuestionPassage = (qNum: number) => {
    for (let i = 0; i < passageQuestionRanges.length; i++) {
      if (qNum >= passageQuestionRanges[i].start && qNum <= passageQuestionRanges[i].end) return i;
    }
    return 0;
  };

  const currentPassage = test.passages[activePassage];

  return (
    <DashboardLayout>
      <TooltipProvider>
        <div className="flex flex-col h-[calc(100vh-4rem)]">
          {/* Unified Timer */}
          <UnifiedTimer
            key={timerKey}
            totalSeconds={3600}
            onTimeUp={handleTimeUp}
            testFinished={submitted}
          />

          {/* Sticky Header: Passage Stepper */}
          <div className="shrink-0 border-b border-border bg-card px-4 py-2.5 md:px-6">
            <div className="flex items-center justify-between gap-4">
              <div className="flex items-center gap-1 rounded-lg bg-muted p-1 flex-1 max-w-md">
                {test.passages.map((p, idx) => (
                  <button
                    key={p.id}
                    onClick={() => handlePassageChange(idx)}
                    className={cn(
                      "flex items-center gap-1.5 flex-1 justify-center rounded-md px-3 py-1.5 text-xs font-medium transition-all",
                      activePassage === idx
                        ? "bg-background text-foreground shadow-sm"
                        : "text-muted-foreground hover:bg-background/50 hover:text-foreground"
                    )}
                  >
                    <span className={cn(
                      "h-2 w-2 rounded-full shrink-0",
                      visitedPassages[idx] && activePassage !== idx ? "bg-success" : activePassage === idx ? "bg-primary" : "bg-border"
                    )} />
                    <span className="hidden sm:inline">Passage</span> {idx + 1}
                  </button>
                ))}
              </div>

              <Badge variant="secondary" className="text-xs gap-1 hidden md:flex">
                <BookOpen className="h-3 w-3" />
                {answeredCount}/{totalQuestions}
              </Badge>
            </div>

            <div className="mt-2 h-1 rounded-full bg-secondary overflow-hidden">
              <motion.div
                className="h-full bg-primary rounded-full"
                initial={{ width: 0 }}
                animate={{ width: `${(answeredCount / totalQuestions) * 100}%` }}
                transition={{ duration: 0.3 }}
              />
            </div>
          </div>

          {/* Results Banner */}
          {submitted && !reviewMode && (
            <motion.div
              initial={{ height: 0, opacity: 0 }}
              animate={{ height: "auto", opacity: 1 }}
              className="shrink-0 border-b border-border bg-card px-4 py-4 md:px-6"
            >
              <div className="flex flex-col md:flex-row items-center justify-between gap-4 max-w-4xl mx-auto">
                <div className="flex items-center gap-4">
                  <Trophy className="h-8 w-8 text-warning" />
                  <div>
                    <p className="text-sm text-muted-foreground">Estimated Band Score</p>
                    <p className="text-2xl font-extrabold text-foreground">
                      {calculateReadingBandScore(answeredCount, totalQuestions)}
                      <span className="text-sm text-muted-foreground font-normal ml-1">/ 9</span>
                    </p>
                  </div>
                  <Separator orientation="vertical" className="h-10 hidden md:block" />
                  <div className="hidden md:block">
                    <p className="text-sm text-muted-foreground">Correct Answers</p>
                    <p className="text-xl font-bold text-primary">{answeredCount}/{totalQuestions}</p>
                  </div>
                </div>
                <div className="flex gap-2">
                  <Button variant="outline" size="sm" className="gap-1.5" onClick={() => setReviewMode(true)}>
                    <Eye className="h-3.5 w-3.5" /> Review Answers
                  </Button>
                  <Button size="sm" className="gap-1.5" onClick={handleReset}>
                    <RotateCcw className="h-3.5 w-3.5" /> Try Again
                  </Button>
                </div>
              </div>
            </motion.div>
          )}

          {reviewMode && (
            <div className="shrink-0 border-b border-border bg-primary/5 px-4 py-2 md:px-6">
              <div className="flex items-center justify-between max-w-4xl mx-auto">
                <p className="text-xs font-semibold text-primary flex items-center gap-1.5">
                  <Eye className="h-3.5 w-3.5" /> Review Mode — Correct answers shown
                </p>
                <Button variant="ghost" size="sm" className="gap-1 text-xs" onClick={() => setReviewMode(false)}>
                  <EyeOff className="h-3.5 w-3.5" /> Exit Review
                </Button>
              </div>
            </div>
          )}

          {/* Main Split Content */}
          <div className="flex flex-col md:flex-row flex-1 overflow-hidden">
            <div ref={passagePaneRef} className="flex-1 overflow-y-auto border-b md:border-b-0 md:border-r border-border bg-card">
              <AnimatePresence mode="wait">
                <motion.div
                  key={activePassage}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  exit={{ opacity: 0, x: 20 }}
                  transition={{ duration: 0.25 }}
                  className="p-6 md:p-10 max-w-2xl mx-auto"
                >
                  <div className="flex items-center gap-2 mb-4">
                    <BookOpen className="h-5 w-5 text-primary" />
                    <Badge variant="secondary" className="text-[10px] uppercase tracking-wider">
                      Passage {activePassage + 1} — {test.format}
                    </Badge>
                  </div>
                  <h2 className="text-2xl font-serif font-bold text-foreground mb-6">{currentPassage.title}</h2>
                  {currentPassage.passage.split("\n\n").map((para, i) => (
                    <p key={i} className="text-base font-serif leading-[1.9] text-foreground/90 mb-6">{para}</p>
                  ))}
                </motion.div>
              </AnimatePresence>
            </div>

            <div className="w-full md:w-[460px] lg:w-[520px] flex flex-col shrink-0 bg-background">
              <div className="sticky top-0 z-10 bg-background border-b border-border px-5 py-3">
                <div className="flex items-center justify-between">
                  <h2 className="text-sm font-bold text-foreground">
                    Questions {passageQuestionRanges[activePassage].start}–{passageQuestionRanges[activePassage].end}
                  </h2>
                  <Badge variant="outline" className="text-[10px]">Passage {activePassage + 1} of 3</Badge>
                </div>
              </div>

              <div ref={questionPaneRef} className="flex-1 overflow-y-auto px-5 py-5 space-y-6">
                <AnimatePresence mode="wait">
                  <motion.div
                    key={activePassage}
                    initial={{ opacity: 0, y: 12 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -12 }}
                    transition={{ duration: 0.2 }}
                    className="space-y-6"
                  >
                    {currentPassage.sections.map((section, i) => (
                      <React.Fragment key={i}>
                        {i > 0 && <Separator className="my-2" />}
                        <QuestionRenderer
                          section={section}
                          answers={answers}
                          onAnswer={handleAnswer}
                          submitted={submitted}
                          ynngOverride={activePassage === 1 ? p2YnngQuestions : undefined}
                          mcOverride={activePassage === 2 ? p3McQuestions : undefined}
                        />
                      </React.Fragment>
                    ))}
                  </motion.div>
                </AnimatePresence>
              </div>

              <div className="shrink-0 border-t border-border bg-background px-5 py-3 space-y-3">
                <div className="flex flex-wrap gap-1">
                  {Array.from({ length: totalQuestions }, (_, i) => {
                    const qNum = i + 1;
                    const passageIdx = getQuestionPassage(qNum);
                    const isCurrentPassage = passageIdx === activePassage;
                    return (
                      <Tooltip key={qNum}>
                        <TooltipTrigger asChild>
                          <button
                            onClick={() => handlePassageChange(passageIdx)}
                            className={cn(
                              "h-6 w-6 rounded text-[10px] font-bold transition-all",
                              isCurrentPassage
                                ? "bg-primary text-primary-foreground"
                                : visitedPassages[passageIdx]
                                ? "bg-secondary text-foreground"
                                : "bg-muted text-muted-foreground/50",
                              "hover:ring-1 hover:ring-primary/30"
                            )}
                          >
                            {qNum}
                          </button>
                        </TooltipTrigger>
                        <TooltipContent side="top" className="text-[10px]">Passage {passageIdx + 1}, Q{qNum}</TooltipContent>
                      </Tooltip>
                    );
                  })}
                </div>

                {!submitted ? (
                  <div className="flex gap-2">
                    {activePassage < 2 && (
                      <Button variant="outline" size="sm" className="flex-1 gap-1.5 text-xs" onClick={() => handlePassageChange(activePassage + 1)}>
                        Next Passage <ChevronRight className="h-3.5 w-3.5" />
                      </Button>
                    )}
                    <Button
                      size="sm"
                      className="flex-1 gap-1.5 text-xs shadow-lg shadow-primary/20"
                      onClick={() => setSubmitted(true)}
                      disabled={answeredCount === 0}
                    >
                      <CheckCircle2 className="h-3.5 w-3.5" />
                      Submit Test ({answeredCount} answered)
                    </Button>
                  </div>
                ) : (
                  <Button variant="outline" size="sm" className="w-full gap-1.5 text-xs" onClick={handleReset}>
                    <RotateCcw className="h-3.5 w-3.5" /> Try Again
                  </Button>
                )}
              </div>
            </div>
          </div>
        </div>

        <TimeUpOverlay show={autoSubmitted} onDismiss={() => setAutoSubmitted(false)} />
      </TooltipProvider>
    </DashboardLayout>
  );
};

export default ReadingModule;
