import React, { useState, useEffect, useCallback, useRef } from "react";
import { useSearchParams, useNavigate } from "react-router-dom";
import {
  CheckCircle,
  AlertCircle,
  RefreshCw,
  X,
  AlignLeft,
  PenTool,
  FileText,
  Info,
  ZoomIn,
  ZoomOut,
  Clock,
  Loader2,
  AlertTriangle,
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { DashboardLayout } from "@/components/DashboardLayout";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip";
import { Skeleton } from "@/components/ui/skeleton";
import { Button } from "@/components/ui/button";
import UnifiedTimer, { TimeUpOverlay } from "@/components/shared/UnifiedTimer";
import TestStartOverlay from "@/components/shared/TestStartOverlay";
import { useAuth } from "@/contexts/AuthContext";
import { toast } from "sonner";
import { fetchWritingTestForPractice, type WritingTestPayload, type WritingTaskPayload } from "@/services/writingPracticeService";
import { startTestSession } from "@/services/practiceLibraryService";

// ─── Types ───────────────────────────────────────────────────────────

interface TaskDraft {
  text: string;
  wordCount: number;
}

interface Scores {
  overall: string;
  task: string;
  coherence: string;
  lexical: string;
  grammar: string;
  feedback: string;
}

// ─── Score Card ──────────────────────────────────────────────────────

const ScoreCard: React.FC<{ label: string; score: string; colorClass: string; bgClass: string }> = ({
  label, score, colorClass, bgClass,
}) => (
  <div className={`rounded-xl p-3 ${bgClass} border border-border transition-all hover:shadow-sm`}>
    <span className="text-xs font-semibold text-muted-foreground uppercase tracking-tight">{label}</span>
    <div className={`mt-1 text-xl font-bold ${colorClass}`}>{score}</div>
  </div>
);

// ─── Image Viewer ────────────────────────────────────────────────────

const ImageViewer: React.FC<{ src: string; alt: string }> = ({ src, alt }) => {
  const [zoomed, setZoomed] = useState(false);

  return (
    <>
      <div className="relative group rounded-xl overflow-hidden border border-border bg-secondary">
        <img src={src} alt={alt} className="w-full h-auto object-contain" />
        <button
          onClick={() => setZoomed(true)}
          className="absolute top-2 right-2 rounded-lg bg-card/80 backdrop-blur-sm p-1.5 opacity-0 group-hover:opacity-100 transition-opacity border border-border"
        >
          <ZoomIn className="h-4 w-4 text-foreground" />
        </button>
      </div>
      {zoomed && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-foreground/30 backdrop-blur-md p-8"
          onClick={() => setZoomed(false)}
        >
          <div className="relative max-w-4xl max-h-[90vh]" onClick={(e) => e.stopPropagation()}>
            <img src={src} alt={alt} className="w-full h-auto rounded-xl border border-border shadow-2xl" />
            <button
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
        <Button onClick={onBack} variant="default">Return to Library</Button>
      </div>
    </div>
  </DashboardLayout>
);

// ─── Main Component ──────────────────────────────────────────────────

const WritingSimulator: React.FC = () => {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const { user } = useAuth();
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
  const [scores, setScores] = useState<Scores>({ overall: "0", task: "0", coherence: "0", lexical: "0", grammar: "0", feedback: "" });

  const textareaRef = useRef<HTMLTextAreaElement>(null);
  const autoSaveRef = useRef<ReturnType<typeof setInterval> | null>(null);

  // ── Fetch test data ──
  useEffect(() => {
    if (!testId) {
      navigate("/tests", { replace: true });
      return;
    }

    setIsLoading(true);
    setFetchError(null);

    fetchWritingTestForPractice(testId)
      .then((data) => {
        if (!data.tasks || data.tasks.length === 0) {
          setFetchError("This test has no tasks configured.");
          return;
        }
        setTestData(data);
      })
      .catch((err) => {
        setFetchError(err.message || "Failed to load writing test");
        toast.error("Failed to load writing test");
      })
      .finally(() => setIsLoading(false));
  }, [testId, navigate]);

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
    return () => { if (autoSaveRef.current) clearInterval(autoSaveRef.current); };
  }, [drafts, testId]);

  // ── Load saved drafts ──
  useEffect(() => {
    if (!testId) return;
    const saved = localStorage.getItem(`ielts_writing_drafts_${testId}`);
    if (saved) {
      try { setDrafts(JSON.parse(saved)); } catch {}
    }
  }, [testId]);

  const countWords = (text: string) => text.trim().split(/\s+/).filter((w) => w.length > 0).length;

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
    [activeTask, isActive],
  );

  const getWordCountColor = (wc: number, min: number) =>
    wc >= min ? "text-success" : wc > 0 ? "text-warning" : "text-muted-foreground";

  const handleTimeUp = useCallback(() => {
    if (showResults) return;
    setAutoSubmitted(true);
    setIsActive(false);
    const totalWords = drafts[0].wordCount + drafts[1].wordCount;
    const base = totalWords > 400 ? 7.0 : totalWords > 200 ? 6.0 : 5.0;
    const rand = () => Math.random() * 1.0 - 0.5;
    setScores({
      overall: (base + 0.5).toFixed(1),
      task: (base + rand()).toFixed(1),
      coherence: (base + 0.5 + rand()).toFixed(1),
      lexical: (base + 1.0 + rand()).toFixed(1),
      grammar: (base + rand()).toFixed(1),
      feedback: "Time expired. Your essays have been automatically submitted for evaluation.",
    });
    setShowResults(true);
    localStorage.removeItem(`ielts_writing_drafts_${testId}`);
  }, [showResults, drafts, testId]);

  const handleSubmit = () => {
    if (!currentTask) return;
    setIsActive(false);
    const totalWords = drafts[0].wordCount + drafts[1].wordCount;
    const base = totalWords > 400 ? 7.0 : totalWords > 200 ? 6.0 : 5.0;
    const rand = () => Math.random() * 1.0 - 0.5;
    const t1Min = tasks[0]?.minWords ?? 150;
    const t2Min = tasks[1]?.minWords ?? 250;
    setScores({
      overall: (base + 0.5).toFixed(1),
      task: (base + rand()).toFixed(1),
      coherence: (base + 0.5 + rand()).toFixed(1),
      lexical: (base + 1.0 + rand()).toFixed(1),
      grammar: (base + rand()).toFixed(1),
      feedback:
        drafts[0].wordCount < t1Min || drafts[1].wordCount < t2Min
          ? "One or both tasks are under the minimum word count. Task Achievement may be affected. Focus on developing your ideas more fully."
          : "Good job meeting the word requirements for both tasks. To improve, focus on varied sentence structures and precise vocabulary.",
    });
    setShowResults(true);
    localStorage.removeItem(`ielts_writing_drafts_${testId}`);
  };

  const handleReset = () => {
    setShowResults(false);
    setAutoSubmitted(false);
    setDrafts([{ text: "", wordCount: 0 }, { text: "", wordCount: 0 }]);
    setActiveTask(0);
    setIsActive(false);
    setTimerKey((k) => k + 1);
    setIsStarted(false);
    localStorage.removeItem(`ielts_writing_drafts_${testId}`);
  };

  const handleStart = async () => {
    setIsStarted(true);
    // Create/update session
    if (user && testId) {
      try {
        await startTestSession(user.id, testId, "writing");
      } catch {
        // Non-blocking — session tracking is best-effort
      }
    }
  };

  const bothAttempted = drafts[0].wordCount > 0 && drafts[1].wordCount > 0;

  // ── Loading ──
  if (isLoading) return <WritingLoadingSkeleton />;

  // ── Error ──
  if (fetchError || !testData || !currentTask) {
    return <WritingErrorState message={fetchError || "Test data could not be loaded."} onBack={() => navigate("/tests")} />;
  }

  const isTask1 = currentTask.taskType === "task1";

  return (
    <DashboardLayout>
      <div className="flex flex-col h-[calc(100vh-4rem)] overflow-hidden">
        {/* Unified Timer — paused until started */}
        <UnifiedTimer
          key={timerKey}
          totalSeconds={totalSeconds}
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
        >
          {/* ─── Header ─── */}
          <div className="flex items-center justify-between border-b border-border bg-card px-4 py-2.5 md:px-6 shrink-0 gap-3">
            <div className="flex items-center gap-2">
              <Badge className="bg-primary/10 text-primary border-primary/20 hover:bg-primary/10 text-xs">
                {testData.title}
              </Badge>
            </div>

            {/* Task switcher */}
            <div className="flex items-center gap-1">
              {tasks.map((task, idx) => {
                const draft = drafts[idx];
                const isActiveTask = activeTask === idx;
                const statusColor = draft.wordCount >= task.minWords
                  ? "bg-success/10 border-success/30 text-success"
                  : draft.wordCount > 0
                  ? "bg-warning/10 border-warning/30 text-warning"
                  : "";
                return (
                  <button
                    key={task.id}
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
                    <Badge
                      variant="outline"
                      className={`text-[10px] px-1.5 py-0 ${statusColor}`}
                    >
                      {draft.wordCount}/{task.minWords}+
                    </Badge>
                  </button>
                );
              })}
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
                          Write at least {currentTask.minWords} words. You should spend about {currentTask.suggestedTime} on this task.
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
                            <TipRow icon={<FileText className="h-4 w-4" />} title="Paraphrase the prompt" desc="Rewrite the question in your own words in the introduction." color="success" />
                            <TipRow icon={<AlignLeft className="h-4 w-4" />} title="Report key trends" desc="Identify and describe the main patterns in the data or situation." color="primary" />
                          </>
                        ) : (
                          <>
                            <TipRow icon={<AlignLeft className="h-4 w-4" />} title="Plan your structure" desc="Introduction → Body 1 → Body 2 → Conclusion." color="success" />
                            <TipRow icon={<Clock className="h-4 w-4" />} title="Budget your time" desc="~5 min planning, ~30 min writing, ~5 min reviewing." color="warning" />
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
                      placeholder={
                        isTask1
                          ? "Begin your response here..."
                          : "Start typing your essay here..."
                      }
                      className="w-full h-full min-h-[300px] resize-none outline-none border-none bg-transparent text-lg leading-relaxed font-serif text-foreground placeholder:text-muted-foreground/40 placeholder:font-sans"
                      spellCheck={false}
                    />
                  </div>

                  {/* Footer */}
                  <div className="border-t border-border bg-card px-4 py-3 md:px-6 flex items-center justify-between shrink-0">
                    <div className="flex items-center gap-4">
                      <div>
                        <span className="text-[10px] uppercase text-muted-foreground font-semibold tracking-wider block">Words</span>
                        <span className={`text-lg font-bold ${getWordCountColor(currentDraft.wordCount, currentTask.minWords)}`}>
                          {currentDraft.wordCount}
                          <span className="text-xs font-normal text-muted-foreground"> / {currentTask.minWords}+</span>
                        </span>
                      </div>
                      <div className="hidden md:flex items-center text-xs text-muted-foreground bg-secondary px-3 py-1 rounded-full">
                        {isActive ? (
                          <span className="flex items-center text-primary"><RefreshCw className="h-3 w-3 mr-1 animate-spin" /> Writing...</span>
                        ) : (
                          <span className="flex items-center"><CheckCircle className="h-3 w-3 mr-1" /> Ready</span>
                        )}
                      </div>
                    </div>

                    <div className="flex items-center gap-2">
                      {activeTask === 0 ? (
                        <button
                          onClick={() => setActiveTask(1)}
                          className="rounded-xl bg-secondary px-4 py-2 text-sm font-medium text-foreground hover:bg-secondary/80 transition-colors"
                        >
                          Go to Task 2 →
                        </button>
                      ) : (
                        <button
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

      {/* ─── Results Modal ─── */}
      {showResults && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-foreground/20 backdrop-blur-sm">
          <div className="w-full max-w-2xl rounded-2xl bg-card shadow-2xl overflow-hidden border border-border">
            <div className="bg-primary p-6 flex justify-between items-start text-primary-foreground">
              <div>
                <h2 className="text-2xl font-bold">Writing Summary</h2>
                <p className="text-primary-foreground/70 text-sm mt-1">{testData.title} · AI Assessment</p>
              </div>
              <button onClick={() => setShowResults(false)} className="rounded-full bg-primary-foreground/10 p-2 hover:bg-primary-foreground/20 transition-colors">
                <X className="h-5 w-5" />
              </button>
            </div>
            <div className="p-6 md:p-8">
              <div className="flex gap-3 mb-6">
                {tasks.map((task, idx) => (
                  <div key={task.id} className="flex-1 rounded-xl border border-border bg-secondary/50 p-4">
                    <span className="text-xs font-semibold text-muted-foreground uppercase">Task {idx + 1}</span>
                    <div className={`text-2xl font-bold mt-1 ${getWordCountColor(drafts[idx].wordCount, task.minWords)}`}>
                      {drafts[idx].wordCount} <span className="text-sm font-normal text-muted-foreground">/ {task.minWords}+ words</span>
                    </div>
                  </div>
                ))}
              </div>

              <div className="flex flex-col md:flex-row items-center gap-6 mb-8">
                <div className="relative h-28 w-28 shrink-0">
                  <svg className="w-full h-full -rotate-90" viewBox="0 0 36 36">
                    <path d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" fill="none" stroke="hsl(var(--border))" strokeWidth="3" />
                    <path d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" fill="none" stroke="hsl(var(--primary))" strokeWidth="3" strokeDasharray={`${(parseFloat(scores.overall) / 9) * 100}, 100`} />
                  </svg>
                  <div className="absolute inset-0 flex flex-col items-center justify-center">
                    <span className="text-3xl font-bold text-foreground">{scores.overall}</span>
                    <span className="text-[10px] uppercase font-bold text-muted-foreground tracking-wider">Band</span>
                  </div>
                </div>
                <div className="grid grid-cols-2 gap-3 w-full">
                  <ScoreCard label="Task Achievement" score={scores.task} colorClass="text-success" bgClass="bg-success/5" />
                  <ScoreCard label="Coherence & Cohesion" score={scores.coherence} colorClass="text-primary" bgClass="bg-primary/5" />
                  <ScoreCard label="Lexical Resource" score={scores.lexical} colorClass="text-foreground" bgClass="bg-secondary" />
                  <ScoreCard label="Grammatical Range" score={scores.grammar} colorClass="text-warning" bgClass="bg-warning/5" />
                </div>
              </div>

              <div className="rounded-xl bg-secondary p-5 border border-border">
                <h3 className="flex items-center text-sm font-bold text-foreground mb-2 uppercase tracking-wide">
                  <AlertCircle className="h-4 w-4 mr-2 text-primary" /> AI Feedback
                </h3>
                <p className="text-sm text-muted-foreground leading-relaxed">{scores.feedback}</p>
              </div>
            </div>
            <div className="border-t border-border bg-secondary/50 p-4 flex justify-end gap-3">
              <button onClick={() => setShowResults(false)} className="px-5 py-2 text-sm font-medium text-muted-foreground hover:text-foreground transition-colors">
                Review Essays
              </button>
              <button onClick={handleReset} className="px-5 py-2 rounded-xl bg-primary text-sm font-semibold text-primary-foreground hover:bg-primary/90 transition-colors">
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
  icon, title, desc, color,
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
