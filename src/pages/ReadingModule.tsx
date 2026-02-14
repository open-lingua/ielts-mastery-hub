import React, { useState, useCallback, useRef, useEffect } from "react";
import { useSearchParams, useNavigate } from "react-router-dom";
import { BookOpen, CheckCircle2, RotateCcw, Trophy, Eye, EyeOff, ChevronRight, AlertTriangle } from "lucide-react";
import { DashboardLayout } from "@/components/DashboardLayout";
import { QuestionRenderer, type Answers } from "@/components/reading/QuestionRenderer";

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";
import { Tooltip, TooltipContent, TooltipTrigger, TooltipProvider } from "@/components/ui/tooltip";
import UnifiedTimer, { TimeUpOverlay } from "@/components/shared/UnifiedTimer";
import TestStartOverlay from "@/components/shared/TestStartOverlay";
import { motion, AnimatePresence } from "framer-motion";
import { cn } from "@/lib/utils";
import { toast } from "sonner";
import { useAuth } from "@/contexts/AuthContext";
import { fetchReadingTestForPractice, submitReadingTest, type ReadingTestPracticePayload } from "@/services/readingPracticeService";
import { startTestSession, fetchExistingSession, fetchActiveSession } from "@/services/practiceLibraryService";
import { usePersistedTimer } from "@/hooks/usePersistedTimer";

// ─── Loading Skeleton ────────────────────────────────
const ReadingLoadingSkeleton: React.FC = () => (
  <DashboardLayout>
    <div className="flex flex-col h-[calc(100vh-4rem)]">
      <div className="shrink-0 border-b border-border bg-card px-4 py-2.5 md:px-6">
        <div className="flex items-center gap-2">
          <Skeleton className="h-8 w-28 rounded-md" />
          <Skeleton className="h-8 w-28 rounded-md" />
          <Skeleton className="h-8 w-28 rounded-md" />
        </div>
        <Skeleton className="mt-2 h-1 w-full rounded-full" />
      </div>
      <div className="flex flex-col md:flex-row flex-1 overflow-hidden">
        <div className="flex-1 p-6 md:p-10 space-y-4">
          <Skeleton className="h-6 w-40" />
          <Skeleton className="h-8 w-3/4" />
          <Skeleton className="h-32 w-full rounded-xl" />
          <Skeleton className="h-32 w-full rounded-xl" />
          <Skeleton className="h-24 w-full rounded-xl" />
        </div>
        <div className="w-full md:w-[460px] lg:w-[520px] border-l border-border p-5 space-y-4">
          <Skeleton className="h-6 w-48" />
          <Skeleton className="h-24 w-full rounded-lg" />
          <Skeleton className="h-24 w-full rounded-lg" />
          <Skeleton className="h-24 w-full rounded-lg" />
        </div>
      </div>
    </div>
  </DashboardLayout>
);

// ─── Error State ─────────────────────────────────────
const ReadingErrorState: React.FC<{ message: string; onBack: () => void }> = ({ message, onBack }) => (
  <DashboardLayout>
    <div className="flex items-center justify-center h-[calc(100vh-4rem)]">
      <div className="text-center space-y-4 max-w-md">
        <div className="bg-destructive/10 p-4 rounded-full inline-flex">
          <AlertTriangle className="h-8 w-8 text-destructive" />
        </div>
        <h2 className="text-xl font-bold text-foreground">Test Not Found</h2>
        <p className="text-muted-foreground">{message}</p>
        <Button onClick={onBack} variant="default">Return to Library</Button>
      </div>
    </div>
  </DashboardLayout>
);

const ReadingModule: React.FC = () => {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const { user } = useAuth();
  const testId = searchParams.get("id");

  // Data fetching
  const [testData, setTestData] = useState<ReadingTestPracticePayload | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [fetchError, setFetchError] = useState<string | null>(null);

  // Test engine state
  const [activePassage, setActivePassage] = useState(0);
  const [answers, setAnswers] = useState<Answers>({});
  const [submitted, setSubmitted] = useState(false);
  const [reviewMode, setReviewMode] = useState(false);
  const [visitedPassages, setVisitedPassages] = useState<boolean[]>([true, false, false]);
  const [autoSubmitted, setAutoSubmitted] = useState(false);
  const [timerKey, setTimerKey] = useState(0);
  const [isStarted, setIsStarted] = useState(false);
  const [startedAt, setStartedAt] = useState<string | null>(null);
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [sessionLoading, setSessionLoading] = useState(true);
  const passagePaneRef = useRef<HTMLDivElement>(null);
  const questionPaneRef = useRef<HTMLDivElement>(null);

  // Fetch test data + existing session
  useEffect(() => {
    if (!testId) {
      navigate("/tests", { replace: true });
      return;
    }

    setIsLoading(true);
    setFetchError(null);
    setSessionLoading(true);

    const loadData = async () => {
      try {
        const data = await fetchReadingTestForPractice(testId);
        if (!data.passages || data.passages.length === 0) {
          setFetchError("This test has no passages configured.");
          return;
        }
        setTestData(data);
        setVisitedPassages(data.passages.map((_, i) => i === 0));

        // Hydrate existing session
        if (user) {
          const session = await fetchExistingSession(user.id, testId, "reading");
          if (session && session.status === "in_progress" && session.started_at) {
            const elapsed = Math.floor((Date.now() - new Date(session.started_at).getTime()) / 1000);
            const remaining = 3600 - elapsed;
            if (remaining > 0) {
              setStartedAt(session.started_at);
              setSessionId(session.id);
              setIsStarted(true);
            }
          }
        }
      } catch (err: any) {
        setFetchError(err.message || "Failed to load reading test");
        toast.error("Failed to load reading test");
      } finally {
        setIsLoading(false);
        setSessionLoading(false);
      }
    };
    loadData();
  }, [testId, navigate, user]);

  const [gradingResult, setGradingResult] = useState<{ rawScore: number; bandScore: number } | null>(null);

  const persistResults = useCallback(async () => {
    if (!sessionId || !testData) return;
    try {
      const flatAnswers: Record<string, string> = {};
      for (const [k, v] of Object.entries(answers)) {
        flatAnswers[k] = Array.isArray(v) ? v.join(", ") : v;
      }
      const result = await submitReadingTest(sessionId, testData, flatAnswers);
      setGradingResult(result);
      toast.success(`Reading test submitted! Band Score: ${result.bandScore} (${result.rawScore}/${testData.totalQuestions} correct)`);
    } catch (err) {
      console.error("Failed to persist reading submission:", err);
      toast.error("Failed to save your submission.");
    }
  }, [sessionId, testData, answers]);

  const handleTimeUp = useCallback(() => {
    if (submitted) return;
    setAutoSubmitted(true);
    setSubmitted(true);
    persistResults();
  }, [submitted, persistResults]);

  // Persisted timer
  const { remainingSeconds } = usePersistedTimer({
    totalSeconds: 3600,
    startedAt,
    onTimeUp: handleTimeUp,
    isFinished: submitted,
  });

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
    setVisitedPassages(testData ? testData.passages.map((_, i) => i === 0) : [true, false, false]);
    setAutoSubmitted(false);
    setGradingResult(null);
    setTimerKey((k) => k + 1);
    setIsStarted(false);
    setStartedAt(null);
    setSessionId(null);
  };

  const handleStart = async () => {
    if (user && testId) {
      try {
        // Check for active session on a different test
        const active = await fetchActiveSession(user.id);
        if (active && active.test_id !== testId) {
          toast.error("You already have a test in progress. Please resume or submit it first.");
          return;
        }
        const session = await startTestSession(user.id, testId, "reading");
        setStartedAt(session.started_at);
        setSessionId(session.id);
      } catch {
        setStartedAt(new Date().toISOString());
      }
    } else {
      setStartedAt(new Date().toISOString());
    }
    setIsStarted(true);
  };

  // Loading
  if (isLoading) return <ReadingLoadingSkeleton />;

  // Error
  if (fetchError || !testData) {
    return <ReadingErrorState message={fetchError || "Test data could not be loaded."} onBack={() => navigate("/tests")} />;
  }

  const { passages, totalQuestions, passageQuestionRanges, passageOverrides } = testData;
  const currentPassage = passages[activePassage];
  const answeredCount = Object.values(answers).filter((v) => v && (typeof v === "string" ? v.trim() : true)).length;

  const getQuestionPassage = (qNum: number) => {
    for (let i = 0; i < passageQuestionRanges.length; i++) {
      if (qNum >= passageQuestionRanges[i].start && qNum <= passageQuestionRanges[i].end) return i;
    }
    return 0;
  };

  return (
    <DashboardLayout>
      <TooltipProvider>
        <div className="flex flex-col h-[calc(100vh-4rem)]">
          <UnifiedTimer
            key={timerKey}
            totalSeconds={startedAt ? remainingSeconds : 3600}
            onTimeUp={handleTimeUp}
            isPaused={!isStarted}
            testFinished={submitted}
          />

          <TestStartOverlay
            isStarted={isStarted}
            onStart={handleStart}
            title={testData.title}
            module="reading"
            sections={`${passages.length} Passages`}
            questions={`${totalQuestions} Questions`}
            durationMinutes={60}
          >
            {/* Sticky Header: Passage Stepper */}
            <div className="shrink-0 border-b border-border bg-card px-4 py-2.5 md:px-6">
              <div className="flex items-center justify-between gap-4">
                <div className="flex items-center gap-1 rounded-lg bg-muted p-1 flex-1 max-w-md">
                  {passages.map((p, idx) => (
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
                      <p className="text-sm text-muted-foreground">Band Score</p>
                      <p className="text-2xl font-extrabold text-foreground">
                        {gradingResult ? gradingResult.bandScore : "—"}
                        <span className="text-sm text-muted-foreground font-normal ml-1">/ 9</span>
                      </p>
                    </div>
                    <Separator orientation="vertical" className="h-10 hidden md:block" />
                    <div className="hidden md:block">
                      <p className="text-sm text-muted-foreground">Correct Answers</p>
                      <p className="text-xl font-bold text-primary">{gradingResult ? gradingResult.rawScore : answeredCount}/{totalQuestions}</p>
                    </div>
                  </div>
                  <div className="flex gap-2">
                    <Button variant="outline" size="sm" className="gap-1.5" onClick={() => navigate("/tests")}>
                      ← Practice Library
                    </Button>
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
                        Passage {activePassage + 1} — {testData.testType}
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
                      Questions {passageQuestionRanges[activePassage]?.start}–{passageQuestionRanges[activePassage]?.end}
                    </h2>
                    <Badge variant="outline" className="text-[10px]">Passage {activePassage + 1} of {passages.length}</Badge>
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
                            tfngOverride={passageOverrides[activePassage]?.tfng}
                            ynngOverride={passageOverrides[activePassage]?.ynng}
                            mcOverride={passageOverrides[activePassage]?.mc as any}
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
                      {activePassage < passages.length - 1 && (
                        <Button variant="outline" size="sm" className="flex-1 gap-1.5 text-xs" onClick={() => handlePassageChange(activePassage + 1)}>
                          Next Passage <ChevronRight className="h-3.5 w-3.5" />
                        </Button>
                      )}
                      <Button
                        size="sm"
                        className="flex-1 gap-1.5 text-xs shadow-lg shadow-primary/20"
                        onClick={() => { setSubmitted(true); persistResults(); }}
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
          </TestStartOverlay>
        </div>

        <TimeUpOverlay show={autoSubmitted} onDismiss={() => setAutoSubmitted(false)} />
      </TooltipProvider>
    </DashboardLayout>
  );
};

export default ReadingModule;
