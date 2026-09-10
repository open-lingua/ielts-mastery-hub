import { AnimatePresence, motion } from "framer-motion";
import {
  AlertTriangle,
  AlignLeft,
  CheckCircle,
  Clock,
  FileText,
  Info,
  PenTool,
  RefreshCw,
  XCircle,
  ZoomIn,
  ZoomOut,
} from "lucide-react";
import React, { useCallback, useEffect, useRef, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { toast } from "sonner";
import { DashboardLayout } from "@/components/DashboardLayout";
import TestStartOverlay from "@/components/shared/TestStartOverlay";
import UnifiedTimer, { TimeUpOverlay } from "@/components/shared/UnifiedTimer";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip";
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
import WritingGradingLoader from "@/components/writing/WritingGradingLoader";
import WritingResultsDashboard from "@/components/writing/WritingResultsDashboard";
import { useAutoSaveAnswers } from "@/hooks/useAutoSaveAnswers";
import { useAiConfigurationStatus } from "@/hooks/useAiConfigurationStatus";
import { usePersistedTimer } from "@/hooks/usePersistedTimer";
import { getAnonId } from "@/lib/anonId";
import { gradeWritingTest, persistFeedback, type WritingGradingResult } from "@/services/aiGradingService";
import { fetchActiveSession, fetchExistingSession, startTestSession } from "@/services/practiceLibraryService";
import {
  fetchWritingTestForPractice,
  submitWritingTest,
  type WritingTaskPayload,
  type WritingTestPayload,
} from "@/services/writingPracticeService";

// ─── Types ───────────────────────────────────────────────────────────

interface TaskDraft {
  text: string;
  wordCount: number;
}

// AI grading results
interface GradingResults {
  task1: WritingGradingResult;
  task2: WritingGradingResult;
  overallBand: number;
}

// ─── Score Card ──────────────────────────────────────────────────────

// (ScoreCard removed — replaced by WritingResultsDashboard)

const ImageViewer: React.FC<{ src: string; alt: string }> = ({ src, alt }) => {
  const [zoomed, setZoomed] = useState(false);

  return (
    <>
      <div className="relative group rounded-xl overflow-hidden border border-border bg-secondary">
        <img src={src} alt={alt} className="w-full h-auto object-contain" />
        <button
          type="button"
          onClick={() => setZoomed(true)}
          className="absolute top-2 right-2 rounded-lg bg-card/80 backdrop-blur-sm p-1.5 opacity-0 group-hover:opacity-100 transition-opacity border border-border"
        >
          <ZoomIn className="h-4 w-4 text-foreground" />
        </button>
      </div>
      {zoomed && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-8">
          <button
            type="button"
            aria-label="Close image preview"
            onClick={() => setZoomed(false)}
            className="absolute inset-0 bg-foreground/30 backdrop-blur-md"
          />
          <div className="relative max-w-4xl max-h-[90vh]">
            <img src={src} alt={alt} className="w-full h-auto rounded-xl border border-border shadow-2xl" />
            <button
              type="button"
              onClick={() => setZoomed(false)}
              className="absolute top-3 right-3 rounded-full bg-card p-2 border border-border hover:bg-secondary transition-colors"
            >
              <ZoomOut className="h-4 w-4 text-foreground" />
            </button>
          </div>
        </div>
      )}
    </>
  );
};

// ─── Loading Skeleton ────────────────────────────────────────────────

const WritingLoadingSkeleton: React.FC = () => (
  <DashboardLayout>
    <div className="flex flex-col h-[calc(100vh-4rem)] overflow-hidden">
      {/* Header skeleton */}
      <div className="flex items-center justify-between border-b border-border bg-card px-4 py-2.5 md:px-6 shrink-0">
        <Skeleton className="h-8 w-32" />
        <div className="flex items-center gap-2">
          <Skeleton className="h-9 w-24 rounded-lg" />
          <Skeleton className="h-9 w-24 rounded-lg" />
        </div>
      </div>
      {/* Split pane skeleton */}
      <div className="flex-1 flex flex-col md:flex-row overflow-hidden">
        <div className="w-full md:w-[420px] lg:w-[480px] border-b md:border-b-0 md:border-r border-border bg-background p-6 space-y-4">
          <Skeleton className="h-6 w-40" />
          <Skeleton className="h-48 w-full rounded-xl" />
          <Skeleton className="h-24 w-full rounded-xl" />
          <Skeleton className="h-16 w-full rounded-xl" />
        </div>
        <div className="flex-1 bg-card p-6 md:p-10 space-y-4">
          <Skeleton className="h-6 w-60" />
          <Skeleton className="h-[300px] w-full rounded-xl" />
          <div className="flex justify-between items-center pt-4">
            <Skeleton className="h-8 w-32" />
            <Skeleton className="h-10 w-28 rounded-xl" />
          </div>
        </div>
      </div>
    </div>
  </DashboardLayout>
);

// ─── Error State ─────────────────────────────────────────────────────

const WritingErrorState: React.FC<{ message: string; onBack: () => void }> = ({ message, onBack }) => (
  <DashboardLayout>
    <div className="flex items-center justify-center h-[calc(100vh-4rem)]">
      <div className="text-center space-y-4 max-w-md">
        <div className="bg-destructive/10 p-4 rounded-full inline-flex">
          <AlertTriangle className="h-8 w-8 text-destructive" />
        </div>
        <h2 className="text-xl font-bold text-foreground">Test Not Found</h2>
        <p className="text-muted-foreground">{message}</p>
        <Button onClick={onBack} variant="default">
          Return to Library
        </Button>
      </div>
    </div>
  </DashboardLayout>
);

// ─── Main Component ──────────────────────────────────────────────────

const WritingSimulator: React.FC = () => {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const userId = getAnonId();
  const testId = searchParams.get("id");

  // Data fetching state
  const [testData, setTestData] = useState<WritingTestPayload | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [fetchError, setFetchError] = useState<string | null>(null);

  // Test engine state
  const [activeTask, setActiveTask] = useState(0);
  const [drafts, setDrafts] = useState<[TaskDraft, TaskDraft]>([
    { text: "", wordCount: 0 },
    { text: "", wordCount: 0 },
  ]);
  const [isActive, setIsActive] = useState(false);
  const [showResults, setShowResults] = useState(false);
  const [autoSubmitted, setAutoSubmitted] = useState(false);
  const [timerKey, setTimerKey] = useState(0);
  const [isStarted, setIsStarted] = useState(false);
  const [startedAt, setStartedAt] = useState<string | null>(null);
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [isGrading, setIsGrading] = useState(false);
  const [gradingResults, setGradingResults] = useState<GradingResults | null>(null);

  const textareaRef = useRef<HTMLTextAreaElement>(null);
  const autoSaveRef = useRef<ReturnType<typeof setInterval> | null>(null);

  // ── Fetch test data + existing session ──
  useEffect(() => {
    if (!testId) {
      navigate("/tests", { replace: true });
      return;
    }

    setIsLoading(true);
    setFetchError(null);

    const loadData = async () => {
      try {
        const data = await fetchWritingTestForPractice(testId);
        if (!data.tasks || data.tasks.length === 0) {
          setFetchError("This test has no tasks configured.");
          return;
        }
        setTestData(data);

        // Hydrate existing session
        {
          const session = await fetchExistingSession(userId, testId, "writing");
          if (session && session.status === "in_progress" && session.started_at) {
            const elapsed = Math.floor((Date.now() - new Date(session.started_at).getTime()) / 1000);
            const remaining = 3600 - elapsed;
            if (remaining > 0) {
              setStartedAt(session.started_at);
              setSessionId(session.id);
              setIsStarted(true);
              // Restore saved drafts from DB
              if (session.answers && typeof session.answers === "object") {
                const saved = session.answers as Record<string, unknown>;
                const countWords = (t: string) =>
                  t
                    .trim()
                    .split(/\s+/)
                    .filter((w) => w.length > 0).length;
                setDrafts([
                  {
                    text: (saved.task1 as string) || "",
                    wordCount: countWords((saved.task1 as string) || ""),
                  },
                  {
                    text: (saved.task2 as string) || "",
                    wordCount: countWords((saved.task2 as string) || ""),
                  },
                ]);
              }
            }
          }
        }
      } catch (err) {
        const message = err instanceof Error ? err.message : "Failed to load writing test";
        setFetchError(message);
        toast.error("Failed to load writing test");
      } finally {
        setIsLoading(false);
      }
    };
    loadData();
  }, [testId, navigate, userId]);

  // Derived from fetched data
  const tasks = testData?.tasks || [];
  const currentTask: WritingTaskPayload | undefined = tasks[activeTask];
  const currentDraft = drafts[activeTask];
  const totalSeconds = 3600; // 60 minutes standard

  // ── Auto-save every 30s ──
  useEffect(() => {
    autoSaveRef.current = setInterval(() => {
      if (drafts[0].text || drafts[1].text) {
        localStorage.setItem(`ielts_writing_drafts_${testId}`, JSON.stringify(drafts));
      }
    }, 30000);
    return () => {
      if (autoSaveRef.current) clearInterval(autoSaveRef.current);
    };
  }, [drafts, testId]);

  // ── Load saved drafts ──
  useEffect(() => {
    if (!testId) return;
    const saved = localStorage.getItem(`ielts_writing_drafts_${testId}`);
    if (saved) {
      try {
        setDrafts(JSON.parse(saved));
      } catch {}
    }
  }, [testId]);

  const countWords = useCallback(
    (text: string) =>
      text
        .trim()
        .split(/\s+/)
        .filter((w) => w.length > 0).length,
    []
  );

  const handleTextChange = useCallback(
    (e: React.ChangeEvent<HTMLTextAreaElement>) => {
      const text = e.target.value;
      const wc = countWords(text);
      setDrafts((prev) => {
        const next = [...prev] as [TaskDraft, TaskDraft];
        next[activeTask] = { text, wordCount: wc };
        return next;
      });
      if (!isActive && text.length > 0) setIsActive(true);
    },
    [activeTask, isActive, countWords]
  );

  const getWordCountColor = (wc: number, min: number) =>
    wc >= min ? "text-success" : wc > 0 ? "text-warning" : "text-muted-foreground";

  const runAIGrading = useCallback(async () => {
    if (!sessionId || !tasks[0] || !tasks[1]) return;
    setIsGrading(true);
    try {
      // Persist raw answers first
      await submitWritingTest(sessionId, {
        task1: drafts[0].text,
        task2: drafts[1].text,
        task1WordCount: drafts[0].wordCount,
        task2WordCount: drafts[1].wordCount,
      });

      // Call AI grading
      const results = await gradeWritingTest([
        { taskType: "task1", prompt: tasks[0].prompt, userResponse: drafts[0].text },
        { taskType: "task2", prompt: tasks[1].prompt, userResponse: drafts[1].text },
      ]);

      setGradingResults(results);

      // Persist feedback
      await persistFeedback(sessionId, results.overallBand, {
        task1: results.task1,
        task2: results.task2,
        overallBand: results.overallBand,
      });

      toast.success("Your writing has been graded by AI.");
    } catch (err) {
      console.error("AI grading failed:", err);
      toast.error("AI grading failed. Your work has been saved.");
    } finally {
      setIsGrading(false);
      setShowResults(true);
      localStorage.removeItem(`ielts_writing_drafts_${testId}`);
    }
  }, [sessionId, drafts, tasks, testId]);

  const handleTimeUp = useCallback(() => {
    if (showResults || isGrading) return;
    setAutoSubmitted(true);
    setIsActive(false);
    runAIGrading();
  }, [showResults, isGrading, runAIGrading]);

  const handleSubmit = () => {
    if (!currentTask) return;
    setIsActive(false);
    runAIGrading();
  };

  const handleReset = () => {
    setShowResults(false);
    setAutoSubmitted(false);
    setGradingResults(null);
    setDrafts([
      { text: "", wordCount: 0 },
      { text: "", wordCount: 0 },
    ]);
    setActiveTask(0);
    setIsActive(false);
    setTimerKey((k) => k + 1);
    setIsStarted(false);
    setStartedAt(null);
    setSessionId(null);
    localStorage.removeItem(`ielts_writing_drafts_${testId}`);
  };

  const handleAbort = async () => {
    if (sessionId) {
      try {
        await deleteUserTestSession(sessionId, getAnonId());
      } catch {
        toast.error("Failed to clear session");
      }
    }
    setShowResults(false);
    setAutoSubmitted(false);
    setGradingResults(null);
    setDrafts([
      { text: "", wordCount: 0 },
      { text: "", wordCount: 0 },
    ]);
    setActiveTask(0);
    setIsActive(false);
    setTimerKey((k) => k + 1);
    setIsStarted(false);
    setStartedAt(null);
    setSessionId(null);
    localStorage.removeItem(`ielts_writing_drafts_${testId}`);
    navigate("/tests");
  };

  const { hasActiveConfig, isLoading: isAiConfigLoading } = useAiConfigurationStatus();

  const handleStart = async () => {
    if (!hasActiveConfig) {
      toast.error("Set up an active AI configuration before starting the Writing test.");
      return;
    }
    if (testId) {
      try {
        const active = await fetchActiveSession(userId);
        if (active && active.test_id !== testId) {
          toast.error("You already have a test in progress. Please resume or submit it first.");
          return;
        }
        const session = await startTestSession(userId, testId, "writing");
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

  const { remainingSeconds } = usePersistedTimer({
    totalSeconds: totalSeconds,
    startedAt,
    onTimeUp: handleTimeUp,
    isFinished: showResults,
  });

  // Auto-save writing drafts to DB
  const writingAnswers = React.useMemo(() => ({ task1: drafts[0].text, task2: drafts[1].text }), [drafts]);
  useAutoSaveAnswers({
    sessionId,
    answers: writingAnswers,
    enabled: isStarted && !showResults && !isGrading,
  });

  const bothAttempted = drafts[0].wordCount > 0 && drafts[1].wordCount > 0;

  // ── Loading ──
  if (isLoading) return <WritingLoadingSkeleton />;

  // ── Error ──
  if (fetchError || !testData || !currentTask) {
    return (
      <WritingErrorState message={fetchError || "Test data could not be loaded."} onBack={() => navigate("/tests")} />
    );
  }

  const isTask1 = currentTask.taskType === "task1";

  return (
    <DashboardLayout>
      <div className="flex flex-col h-[calc(100vh-4rem)] overflow-hidden">
        {/* Unified Timer — paused until started */}
        <UnifiedTimer
          key={timerKey}
          totalSeconds={startedAt ? remainingSeconds : totalSeconds}
          onTimeUp={handleTimeUp}
          isPaused={!isStarted}
          testFinished={showResults}
        />

        <TestStartOverlay
          isStarted={isStarted}
          onStart={handleStart}
          title={testData.title}
          module="writing"
          sections="2 Tasks"
          questions="2 Essays"
          durationMinutes={60}
          locked={!isAiConfigLoading && !hasActiveConfig}
          lockTitle="AI configuration required"
          lockMessage="The Writing test is graded by AI. Set up and activate an AI configuration before starting."
          lockActionLabel="Go to AI Configurations"
          onLockAction={() => navigate("/admin/ai-configurations")}
        >
          {/* ─── Header ─── */}
          <div className="flex items-center justify-between border-b border-border bg-card px-4 py-2.5 md:px-6 shrink-0 gap-3">
            <div className="flex items-center gap-2">
              <Badge className="bg-primary/10 text-primary border-primary/20 hover:bg-primary/10 text-xs">
                {testData.title}
              </Badge>
            </div>

            <div className="flex items-center gap-3">
            {/* Task switcher */}
            <div className="flex items-center gap-1">
              {tasks.map((task, idx) => {
                const draft = drafts[idx];
                const isActiveTask = activeTask === idx;
                const statusColor =
                  draft.wordCount >= task.minWords
                    ? "bg-success/10 border-success/30 text-success"
                    : draft.wordCount > 0
                      ? "bg-warning/10 border-warning/30 text-warning"
                      : "";
                return (
                  <button
                    key={task.id}
                    type="button"
                    onClick={() => setActiveTask(idx)}
                    className={`relative flex items-center gap-2 rounded-lg px-3 py-2 text-sm font-medium transition-all border ${
                      isActiveTask
                        ? "bg-primary/10 border-primary/30 text-primary shadow-sm"
                        : "border-transparent text-muted-foreground hover:text-foreground hover:bg-secondary"
                    }`}
                  >
                    <PenTool className="h-3.5 w-3.5" />
                    <span className="hidden sm:inline">Task {idx + 1}</span>
                    <span className="sm:hidden">T{idx + 1}</span>
                    <Badge variant="outline" className={`text-[10px] px-1.5 py-0 ${statusColor}`}>
                      {draft.wordCount}/{task.minWords}+
                    </Badge>
                  </button>
                );
              })}
            </div>
            {!showResults && (
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

          {/* ─── Split Layout ─── */}
          <div className="flex-1 flex flex-col md:flex-row overflow-hidden">
            {/* Left: Prompt & Reference */}
            <div className="w-full md:w-[420px] lg:w-[480px] border-b md:border-b-0 md:border-r border-border bg-background overflow-hidden shrink-0 flex flex-col">
              <ScrollArea className="flex-1">
                <div className="p-6">
                  <AnimatePresence mode="wait">
                    <motion.div
                      key={`prompt-${activeTask}`}
                      initial={{ opacity: 0, y: 12 }}
                      animate={{ opacity: 1, y: 0 }}
                      exit={{ opacity: 0, y: -12 }}
                      transition={{ duration: 0.2 }}
                    >
                      {/* Task badge */}
                      <div className="flex items-center gap-2 mb-4">
                        <Badge className="bg-primary/10 text-primary border-primary/20 hover:bg-primary/10">
                          {currentTask.title}
                        </Badge>
                        <Badge variant="outline" className="text-muted-foreground">
                          {currentTask.suggestedTime}
                        </Badge>
                      </div>

                      {/* Task 1 image */}
                      {isTask1 && currentTask.imageUrl && (
                        <div className="mb-5">
                          <ImageViewer src={currentTask.imageUrl} alt="IELTS Task 1 Reference" />
                        </div>
                      )}

                      {/* Prompt card */}
                      <div className="rounded-2xl border border-border bg-card p-5 mb-5">
                        <h2 className="text-base font-serif font-bold text-foreground leading-relaxed whitespace-pre-line">
                          {currentTask.prompt}
                        </h2>
                        <Separator className="my-4" />
                        <p className="text-sm text-muted-foreground italic leading-relaxed">
                          Write at least {currentTask.minWords} words. You should spend about{" "}
                          {currentTask.suggestedTime} on this task.
                        </p>
                      </div>

                      {/* Tips */}
                      <div className="space-y-3">
                        <h3 className="text-xs font-bold text-foreground uppercase tracking-widest flex items-center gap-1.5">
                          <Info className="h-3.5 w-3.5 text-primary" />
                          Writing Tips
                        </h3>
                        {isTask1 ? (
                          <>
                            <TipRow
                              icon={<FileText className="h-4 w-4" />}
                              title="Paraphrase the prompt"
                              desc="Rewrite the question in your own words in the introduction."
                              color="success"
                            />
                            <TipRow
                              icon={<AlignLeft className="h-4 w-4" />}
                              title="Report key trends"
                              desc="Identify and describe the main patterns in the data or situation."
                              color="primary"
                            />
                          </>
                        ) : (
                          <>
                            <TipRow
                              icon={<AlignLeft className="h-4 w-4" />}
                              title="Plan your structure"
                              desc="Introduction → Body 1 → Body 2 → Conclusion."
                              color="success"
                            />
                            <TipRow
                              icon={<Clock className="h-4 w-4" />}
                              title="Budget your time"
                              desc="~5 min planning, ~30 min writing, ~5 min reviewing."
                              color="warning"
                            />
                          </>
                        )}
                      </div>
                    </motion.div>
                  </AnimatePresence>
                </div>
              </ScrollArea>
            </div>

            {/* Right: Editor */}
            <div className="flex-1 flex flex-col bg-card">
              <AnimatePresence mode="wait">
                <motion.div
                  key={`editor-${activeTask}`}
                  initial={{ opacity: 0, x: 20 }}
                  animate={{ opacity: 1, x: 0 }}
                  exit={{ opacity: 0, x: -20 }}
                  transition={{ duration: 0.2 }}
                  className="flex-1 flex flex-col"
                >
                  <div className="flex-1 p-6 md:p-10 overflow-y-auto">
                    <textarea
                      ref={textareaRef}
                      value={currentDraft.text}
                      onChange={handleTextChange}
                      placeholder={isTask1 ? "Begin your response here..." : "Start typing your essay here..."}
                      className="w-full h-full min-h-[300px] resize-none outline-none border-none bg-transparent text-lg leading-relaxed font-serif text-foreground placeholder:text-muted-foreground/40 placeholder:font-sans"
                      spellCheck={false}
                    />
                  </div>

                  {/* Footer */}
                  <div className="border-t border-border bg-card px-4 py-3 md:px-6 flex items-center justify-between shrink-0">
                    <div className="flex items-center gap-4">
                      <div>
                        <span className="text-[10px] uppercase text-muted-foreground font-semibold tracking-wider block">
                          Words
                        </span>
                        <span
                          className={`text-lg font-bold ${getWordCountColor(currentDraft.wordCount, currentTask.minWords)}`}
                        >
                          {currentDraft.wordCount}
                          <span className="text-xs font-normal text-muted-foreground"> / {currentTask.minWords}+</span>
                        </span>
                      </div>
                      <div className="hidden md:flex items-center text-xs text-muted-foreground bg-secondary px-3 py-1 rounded-full">
                        {isActive ? (
                          <span className="flex items-center text-primary">
                            <RefreshCw className="h-3 w-3 mr-1 animate-spin" /> Writing...
                          </span>
                        ) : (
                          <span className="flex items-center">
                            <CheckCircle className="h-3 w-3 mr-1" /> Ready
                          </span>
                        )}
                      </div>
                    </div>

                    <div className="flex items-center gap-2">
                      {activeTask === 0 ? (
                        <button
                          type="button"
                          onClick={() => setActiveTask(1)}
                          className="rounded-xl bg-secondary px-4 py-2 text-sm font-medium text-foreground hover:bg-secondary/80 transition-colors"
                        >
                          Go to Task 2 →
                        </button>
                      ) : (
                        <button
                          type="button"
                          onClick={() => setActiveTask(0)}
                          className="rounded-xl bg-secondary px-4 py-2 text-sm font-medium text-foreground hover:bg-secondary/80 transition-colors"
                        >
                          ← Back to Task 1
                        </button>
                      )}
                      <TooltipProvider>
                        <Tooltip>
                          <TooltipTrigger asChild>
                            <button
                              type="button"
                              onClick={handleSubmit}
                              disabled={!bothAttempted}
                              className="rounded-xl bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground shadow-lg shadow-primary/20 transition-all hover:scale-105 active:scale-95 disabled:opacity-50 disabled:hover:scale-100 flex items-center gap-2"
                            >
                              Submit Test <CheckCircle className="h-4 w-4" />
                            </button>
                          </TooltipTrigger>
                          {!bothAttempted && (
                            <TooltipContent>
                              <p>Both tasks must be attempted before submitting</p>
                            </TooltipContent>
                          )}
                        </Tooltip>
                      </TooltipProvider>
                    </div>
                  </div>
                </motion.div>
              </AnimatePresence>
            </div>
          </div>
        </TestStartOverlay>
      </div>

      {/* ─── AI Grading Loader ─── */}
      {isGrading && <WritingGradingLoader />}

      {/* ─── AI Results Dashboard ─── */}
      {showResults && gradingResults && (
        <WritingResultsDashboard
          task1={gradingResults.task1}
          task2={gradingResults.task2}
          overallBand={gradingResults.overallBand}
          task1WordCount={drafts[0].wordCount}
          task2WordCount={drafts[1].wordCount}
          task1MinWords={tasks[0]?.minWords ?? 150}
          task2MinWords={tasks[1]?.minWords ?? 250}
          testTitle={testData.title}
          onClose={() => setShowResults(false)}
          onBackToLibrary={() => navigate("/tests")}
          onReset={handleReset}
        />
      )}

      {/* Fallback results (no AI result) */}
      {showResults && !gradingResults && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-foreground/20 backdrop-blur-sm">
          <div className="w-full max-w-md rounded-2xl bg-card shadow-2xl overflow-hidden border border-border p-8 text-center space-y-4">
            <AlertTriangle className="h-10 w-10 text-warning mx-auto" />
            <h2 className="text-xl font-bold text-foreground">Test Submitted</h2>
            <p className="text-sm text-muted-foreground">
              Your answers have been saved but AI grading was unavailable. You can review your essays or return to the
              library.
            </p>
            <div className="flex justify-center gap-3 pt-2">
              <button
                type="button"
                onClick={() => navigate("/tests")}
                className="px-5 py-2 text-sm font-medium text-muted-foreground hover:text-foreground transition-colors"
              >
                ← Practice Library
              </button>
              <button
                type="button"
                onClick={() => setShowResults(false)}
                className="px-5 py-2 text-sm font-medium text-muted-foreground hover:text-foreground transition-colors"
              >
                Review Essays
              </button>
              <button
                type="button"
                onClick={handleReset}
                className="px-5 py-2 rounded-xl bg-primary text-sm font-semibold text-primary-foreground hover:bg-primary/90 transition-colors"
              >
                Start New Test
              </button>
            </div>
          </div>
        </div>
      )}

      <TimeUpOverlay show={autoSubmitted} onDismiss={() => setAutoSubmitted(false)} />
    </DashboardLayout>
  );
};

// ─── Tip Row ─────────────────────────────────────────────────────────

const TipRow: React.FC<{ icon: React.ReactNode; title: string; desc: string; color: string }> = ({
  icon,
  title,
  desc,
  color,
}) => (
  <div className="flex gap-3 items-start">
    <div className={`flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-${color}/10 text-${color}`}>
      {icon}
    </div>
    <div>
      <h4 className="text-sm font-semibold text-foreground">{title}</h4>
      <p className="mt-0.5 text-xs text-muted-foreground leading-relaxed">{desc}</p>
    </div>
  </div>
);

export default WritingSimulator;
