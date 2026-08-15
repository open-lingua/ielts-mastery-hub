import { AnimatePresence, motion } from "framer-motion";
import { AlertTriangle, ChevronRight, Headphones, Info, XCircle } from "lucide-react";
import type React from "react";
import { useCallback, useEffect, useRef, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { toast } from "sonner";
import { DashboardLayout } from "@/components/DashboardLayout";
import AudioPlayer from "@/components/listening/AudioPlayer";
import QuestionCard from "@/components/listening/QuestionCard";
import ResultsCard from "@/components/listening/ResultsCard";
import SectionStepper from "@/components/listening/SectionStepper";
import TestStartOverlay from "@/components/shared/TestStartOverlay";
import UnifiedTimer, { TimeUpOverlay } from "@/components/shared/UnifiedTimer";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";
import { TooltipProvider } from "@/components/ui/tooltip";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog";
import { deleteUserTestSession } from "@/lib/tauri";
import type { ListeningTest } from "@/data/listeningTestData";
import { useAutoSaveAnswers } from "@/hooks/useAutoSaveAnswers";
import { usePersistedTimer } from "@/hooks/usePersistedTimer";
import { getAnonId } from "@/lib/anonId";
import { fetchListeningTestForPractice, submitListeningTest } from "@/services/listeningPracticeService";
import { fetchActiveSession, fetchExistingSession, startTestSession } from "@/services/practiceLibraryService";

const ListeningLoadingSkeleton = () => (
  <DashboardLayout>
    <div className="flex flex-col h-[calc(100vh-4rem)]">
      <div className="shrink-0 border-b border-border bg-card px-4 py-3 md:px-8 space-y-3">
        <div className="max-w-4xl mx-auto space-y-3">
          <div className="flex items-center gap-2">
            <Skeleton className="h-5 w-5 rounded" />
            <Skeleton className="h-6 w-64" />
          </div>
          <div className="flex items-center gap-3">
            {[1, 2, 3, 4].map((i) => (
              <Skeleton key={i} className="h-10 w-10 rounded-full" />
            ))}
          </div>
        </div>
      </div>
      <div className="flex-1 p-4 md:p-8">
        <div className="max-w-4xl mx-auto space-y-6">
          <div className="rounded-2xl border border-border bg-card p-6 space-y-4">
            <Skeleton className="h-4 w-24" />
            <Skeleton className="h-7 w-80" />
            <Skeleton className="h-4 w-48" />
            <Separator />
            <Skeleton className="h-14 w-full rounded-xl" />
            <Skeleton className="h-16 w-full rounded-lg" />
          </div>
          <div className="space-y-3">
            <Skeleton className="h-5 w-40" />
            {[1, 2, 3, 4, 5].map((i) => (
              <Skeleton key={i} className="h-24 w-full rounded-xl" />
            ))}
          </div>
        </div>
      </div>
    </div>
  </DashboardLayout>
);

const ListeningErrorState = ({ onBack }: { onBack: () => void }) => (
  <DashboardLayout>
    <div className="flex items-center justify-center min-h-[60vh]">
      <Alert variant="destructive" className="max-w-md">
        <AlertTriangle className="h-5 w-5" />
        <AlertTitle>Test Not Found</AlertTitle>
        <AlertDescription className="mt-2">
          This listening test could not be loaded. It may have been removed or you don't have access.
          <Button variant="outline" size="sm" className="mt-4 w-full" onClick={onBack}>
            Return to Practice Library
          </Button>
        </AlertDescription>
      </Alert>
    </div>
  </DashboardLayout>
);

const ListeningModule: React.FC = () => {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const userId = getAnonId();
  const testId = searchParams.get("id");

  const [test, setTest] = useState<ListeningTest | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [hasError, setHasError] = useState(false);

  const [activeSection, setActiveSection] = useState(0);
  const [unlockedSections, setUnlockedSections] = useState<boolean[]>([]);
  const [completedSections, setCompletedSections] = useState<boolean[]>([]);
  const [audioEnded, setAudioEnded] = useState<boolean[]>([]);
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [testFinished, setTestFinished] = useState(false);
  const [reviewMode, setReviewMode] = useState(false);
  const [autoSubmitted, setAutoSubmitted] = useState(false);
  const [timerKey, setTimerKey] = useState(0);
  const [isStarted, setIsStarted] = useState(false);
  const [startedAt, setStartedAt] = useState<string | null>(null);
  const [sessionId, setSessionId] = useState<string | null>(null);

  const contentRef = useRef<HTMLDivElement>(null);

  // Redirect if no ID
  useEffect(() => {
    if (!testId) {
      navigate("/tests", { replace: true });
    }
  }, [testId, navigate]);

  // Fetch test data + existing session
  useEffect(() => {
    if (!testId) return;
    setIsLoading(true);
    setHasError(false);

    const loadData = async () => {
      try {
        const data = await fetchListeningTestForPractice(testId);
        setTest(data);
        const count = data.sections.length;
        setUnlockedSections([true, ...Array(count - 1).fill(false)]);
        setCompletedSections(Array(count).fill(false));
        setAudioEnded(Array(count).fill(false));

        // Hydrate existing session
        {
          const session = await fetchExistingSession(userId, testId, "listening");
          if (session && session.status === "in_progress" && session.started_at) {
            const elapsed = Math.floor((Date.now() - new Date(session.started_at).getTime()) / 1000);
            const remaining = data.totalTime - elapsed;
            if (remaining > 0) {
              setStartedAt(session.started_at);
              setSessionId(session.id);
              setIsStarted(true);
              // Restore saved answers
              if (session.answers && typeof session.answers === "object") {
                setAnswers(session.answers as Record<string, string>);
              }
            }
          }
        }
      } catch (err) {
        console.error("Failed to load listening test:", err);
        toast.error("Failed to load listening test");
        setHasError(true);
      } finally {
        setIsLoading(false);
      }
    };
    loadData();
  }, [testId, userId]);

  const scrollToTop = () => {
    contentRef.current?.scrollTo({ top: 0, behavior: "smooth" });
  };

  const handleAudioEnded = useCallback((sectionIndex: number) => {
    setAudioEnded((prev) => {
      const next = [...prev];
      next[sectionIndex] = true;
      return next;
    });
  }, []);

  const handleAnswer = (qId: string, value: string) => {
    if (testFinished) return;
    setAnswers((prev) => ({ ...prev, [qId]: value }));
  };

  const persistResults = useCallback(async () => {
    if (!sessionId || !test) return;
    try {
      const result = await submitListeningTest(sessionId, test, answers);
      toast.success(`Test submitted! Band Score: ${result.bandScore}`);
    } catch (err) {
      console.error("Failed to save results:", err);
      toast.error("Could not save your results. Please try again.");
    }
  }, [sessionId, test, answers]);

  const handleSubmitSection = async () => {
    if (!test) return;
    const totalSections = test.sections.length;
    const nextIndex = activeSection + 1;
    setCompletedSections((prev) => {
      const next = [...prev];
      next[activeSection] = true;
      return next;
    });
    if (nextIndex < totalSections) {
      setUnlockedSections((prev) => {
        const next = [...prev];
        next[nextIndex] = true;
        return next;
      });
      setActiveSection(nextIndex);
      scrollToTop();
    } else {
      setTestFinished(true);
      scrollToTop();
      await persistResults();
    }
  };

  const handleTimeUp = useCallback(async () => {
    if (testFinished || !test) return;
    setAutoSubmitted(true);
    setCompletedSections(Array(test.sections.length).fill(true));
    setTestFinished(true);
    // Persist on time-up too
    if (testId) {
      try {
        await submitListeningTest(sessionId!, test, answers);
      } catch (err) {
        console.error("Failed to save results on time-up:", err);
      }
    }
  }, [testFinished, test, testId, sessionId, answers]);

  const handleRetry = () => {
    if (!test) return;
    const count = test.sections.length;
    setActiveSection(0);
    setUnlockedSections([true, ...Array(count - 1).fill(false)]);
    setCompletedSections(Array(count).fill(false));
    setAudioEnded(Array(count).fill(false));
    setAnswers({});
    setTestFinished(false);
    setReviewMode(false);
    setAutoSubmitted(false);
    setTimerKey((k) => k + 1);
    setIsStarted(false);
    setStartedAt(null);
    setSessionId(null);
    scrollToTop();
  };

  const handleAbort = async () => {
    if (sessionId) {
      try {
        await deleteUserTestSession(sessionId, getAnonId());
      } catch {
        toast.error("Failed to clear session");
      }
    }
    if (!test) return;
    const count = test.sections.length;
    setActiveSection(0);
    setUnlockedSections([true, ...Array(count - 1).fill(false)]);
    setCompletedSections(Array(count).fill(false));
    setAudioEnded(Array(count).fill(false));
    setAnswers({});
    setTestFinished(false);
    setReviewMode(false);
    setAutoSubmitted(false);
    setTimerKey((k) => k + 1);
    setIsStarted(false);
    setStartedAt(null);
    setSessionId(null);
    navigate("/tests");
  };

  const handleStart = async () => {
    if (testId) {
      try {
        const active = await fetchActiveSession(userId);
        if (active && active.test_id !== testId) {
          toast.error("You already have a test in progress. Please resume or submit it first.");
          return;
        }
        const session = await startTestSession(userId, testId, "listening");
        setStartedAt(session.started_at);
        setSessionId(session.id);
      } catch (err) {
        console.error("Failed to start session:", err);
        setStartedAt(new Date().toISOString());
      }
    } else {
      setStartedAt(new Date().toISOString());
    }
    setIsStarted(true);
  };

  const totalTime = test?.totalTime ?? 1800;
  const { remainingSeconds } = usePersistedTimer({
    totalSeconds: totalTime,
    startedAt,
    onTimeUp: handleTimeUp,
    isFinished: testFinished,
  });

  // Auto-save answers to DB
  useAutoSaveAnswers({
    sessionId,
    answers,
    enabled: isStarted && !testFinished,
  });

  if (!testId) return null;
  if (isLoading) return <ListeningLoadingSkeleton />;
  if (hasError || !test) return <ListeningErrorState onBack={() => navigate("/tests")} />;

  const totalSections = test.sections.length;
  const currentSection = test.sections[activeSection];
  const sectionQuestions = currentSection.questions;
  const answeredCount = sectionQuestions.filter((q) => answers[q.id]?.trim()).length;
  const canSubmit = answeredCount > 0;
  const globalOffset = test.sections.slice(0, activeSection).reduce((acc, s) => acc + s.questions.length, 0);

  return (
    <DashboardLayout>
      <TooltipProvider>
        <div className="flex flex-col h-[calc(100vh-4rem)]">
          <UnifiedTimer
            key={timerKey}
            totalSeconds={startedAt ? remainingSeconds : totalTime}
            onTimeUp={handleTimeUp}
            isPaused={!isStarted}
            testFinished={testFinished}
          />

          <TestStartOverlay
            isStarted={isStarted}
            onStart={handleStart}
            title={test.title}
            module="listening"
            sections={`${totalSections} Sections`}
            questions={`${test.sections.reduce((acc, s) => acc + s.questions.length, 0)} Questions`}
            durationMinutes={Math.round(test.totalTime / 60)}
          >
            {/* Sticky Header */}
            <div className="shrink-0 border-b border-border bg-card px-4 py-3 md:px-8 space-y-3">
              <div className="max-w-4xl mx-auto">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <Headphones className="h-5 w-5 text-primary" />
                    <h1 className="text-lg font-bold text-foreground">{test.title}</h1>
                  </div>
                  <div className="flex items-center gap-2">
                    {!testFinished && (
                      <Badge variant="outline" className="text-xs">
                        Section {activeSection + 1} of {totalSections}
                      </Badge>
                    )}
                    {!testFinished && (
                      <AlertDialog>
                        <AlertDialogTrigger asChild>
                          <Button variant="ghost" size="sm" className="text-muted-foreground hover:text-destructive gap-1">
                            <XCircle className="h-4 w-4" />
                            <span className="hidden sm:inline">Abort</span>
                          </Button>
                        </AlertDialogTrigger>
                        <AlertDialogContent>
                          <AlertDialogHeader>
                            <AlertDialogTitle>Abort test?</AlertDialogTitle>
                            <AlertDialogDescription>
                              Your progress will not be saved. This cannot be undone.
                            </AlertDialogDescription>
                          </AlertDialogHeader>
                          <AlertDialogFooter>
                            <AlertDialogCancel>Continue</AlertDialogCancel>
                            <AlertDialogAction
                              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
                              onClick={handleAbort}
                            >
                              Abort
                            </AlertDialogAction>
                          </AlertDialogFooter>
                        </AlertDialogContent>
                      </AlertDialog>
                    )}
                  </div>
                </div>
                <div className="mt-3">
                  <SectionStepper
                    totalSections={totalSections}
                    activeSection={activeSection}
                    completedSections={completedSections}
                    unlockedSections={unlockedSections}
                    onSectionClick={(i) => {
                      if (unlockedSections[i]) {
                        setActiveSection(i);
                        scrollToTop();
                      }
                    }}
                  />
                </div>
              </div>
            </div>

            {/* Scrollable Content */}
            <div ref={contentRef} className="flex-1 overflow-y-auto p-4 md:p-8">
              <div className="max-w-4xl mx-auto">
                <AnimatePresence mode="wait">
                  {testFinished ? (
                    <motion.div
                      key="results"
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      exit={{ opacity: 0, y: -20 }}
                      transition={{ duration: 0.3 }}
                      className="space-y-6"
                    >
                      <ResultsCard
                        test={test}
                        answers={answers}
                        reviewMode={reviewMode}
                        onToggleReview={() => setReviewMode((r) => !r)}
                        onRetry={handleRetry}
                        onBackToLibrary={() => navigate("/tests")}
                      />
                      {reviewMode && (
                        <div className="space-y-6">
                          {test.sections.map((section, sectionIdx) => {
                            const offset = test.sections
                              .slice(0, sectionIdx)
                              .reduce((acc, s) => acc + s.questions.length, 0);
                            return (
                              <div key={section.id} className="rounded-2xl border border-border bg-card p-6 space-y-4">
                                <div>
                                  <Badge variant="secondary" className="text-[10px] uppercase tracking-wider mb-2">
                                    {section.context}
                                  </Badge>
                                  <h3 className="text-base font-bold text-foreground">{section.title}</h3>
                                </div>
                                <div className="space-y-3">
                                  {section.questions.map((q, qi) => (
                                    <QuestionCard
                                      key={q.id}
                                      question={q}
                                      index={offset + qi + 1}
                                      answer={answers[q.id] || ""}
                                      onAnswer={() => {}}
                                      submitted={true}
                                      reviewMode={true}
                                    />
                                  ))}
                                </div>
                              </div>
                            );
                          })}
                        </div>
                      )}
                    </motion.div>
                  ) : (
                    <motion.div
                      key={`section-${activeSection}`}
                      initial={{ opacity: 0, x: 40 }}
                      animate={{ opacity: 1, x: 0 }}
                      exit={{ opacity: 0, x: -40 }}
                      transition={{ duration: 0.3 }}
                      className="space-y-6"
                    >
                      <div className="rounded-2xl border border-border bg-card p-6">
                        <Badge variant="secondary" className="text-[10px] uppercase tracking-wider mb-2">
                          {currentSection.context}
                        </Badge>
                        <h2 className="text-xl font-bold text-foreground">{currentSection.title}</h2>
                        <p className="text-sm text-muted-foreground mt-1">{currentSection.subtitle}</p>
                        <Separator className="my-4" />
                        <AudioPlayer
                          sectionIndex={activeSection}
                          audioUrl={currentSection.audioUrl}
                          onEnded={() => handleAudioEnded(activeSection)}
                          disabled={completedSections[activeSection]}
                        />
                        <div className="mt-4 flex items-start gap-2 rounded-lg bg-primary/5 border border-primary/10 p-3">
                          <Info className="h-4 w-4 text-primary shrink-0 mt-0.5" />
                          <p className="text-xs text-foreground leading-relaxed">{currentSection.instructions}</p>
                        </div>
                      </div>

                      <div className="space-y-3">
                        <div className="flex items-center justify-between">
                          <p className="text-sm font-semibold text-foreground">
                            Questions {globalOffset + 1}–{globalOffset + sectionQuestions.length}
                          </p>
                          <p className="text-xs text-muted-foreground">
                            {answeredCount}/{sectionQuestions.length} answered
                          </p>
                        </div>
                        {sectionQuestions.map((q, qi) => (
                          <QuestionCard
                            key={q.id}
                            question={q}
                            index={globalOffset + qi + 1}
                            answer={answers[q.id] || ""}
                            onAnswer={(val) => handleAnswer(q.id, val)}
                            submitted={testFinished}
                            reviewMode={reviewMode}
                          />
                        ))}
                      </div>

                      <motion.div animate={canSubmit ? { scale: [1, 1.02, 1] } : {}} transition={{ duration: 0.4 }}>
                        <Button
                          onClick={handleSubmitSection}
                          disabled={!canSubmit}
                          className="w-full gap-2 rounded-xl py-3 text-sm font-semibold shadow-lg shadow-primary/20"
                          size="lg"
                        >
                          {activeSection < totalSections - 1 ? (
                            <>
                              Submit & Continue to Section {activeSection + 2} <ChevronRight className="h-4 w-4" />
                            </>
                          ) : (
                            "Submit & View Results"
                          )}
                        </Button>
                      </motion.div>
                      {!canSubmit && (
                        <p className="text-center text-xs text-muted-foreground">
                          Answer at least one question to proceed.
                        </p>
                      )}
                    </motion.div>
                  )}
                </AnimatePresence>
              </div>
            </div>
          </TestStartOverlay>
        </div>

        <TimeUpOverlay show={autoSubmitted} onDismiss={() => setAutoSubmitted(false)} />
      </TooltipProvider>
    </DashboardLayout>
  );
};

export default ListeningModule;
