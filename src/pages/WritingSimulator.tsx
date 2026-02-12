import React, { useState, useEffect, useRef } from "react";
import {
  Clock,
  ChevronDown,
  AlignLeft,
  CheckCircle,
  AlertCircle,
  Maximize2,
  RefreshCw,
  X,
  BookOpen,
} from "lucide-react";
import { writingTasks } from "@/data/mockData";
import { DashboardLayout } from "@/components/DashboardLayout";

interface Scores {
  overall: string;
  task: string;
  coherence: string;
  lexical: string;
  grammar: string;
  feedback: string;
}

const ScoreCard: React.FC<{ label: string; score: string; colorClass: string; bgClass: string }> = ({
  label,
  score,
  colorClass,
  bgClass,
}) => (
  <div className={`rounded-xl p-3 ${bgClass} border border-border transition-all hover:shadow-sm`}>
    <span className="text-xs font-semibold text-muted-foreground uppercase tracking-tight">{label}</span>
    <div className={`mt-1 text-xl font-bold ${colorClass}`}>{score}</div>
  </div>
);

const WritingSimulator: React.FC = () => {
  const [essayText, setEssayText] = useState("");
  const [selectedTask, setSelectedTask] = useState(writingTasks[0]);
  const [timeLeft, setTimeLeft] = useState(selectedTask.timeMinutes * 60);
  const [isActive, setIsActive] = useState(false);
  const [showDropdown, setShowDropdown] = useState(false);
  const [showResults, setShowResults] = useState(false);
  const [wordCount, setWordCount] = useState(0);
  const [scores, setScores] = useState<Scores>({
    overall: "0",
    task: "0",
    coherence: "0",
    lexical: "0",
    grammar: "0",
    feedback: "",
  });

  const textareaRef = useRef<HTMLTextAreaElement>(null);

  useEffect(() => {
    if (!isActive || timeLeft <= 0) return;
    const interval = setInterval(() => setTimeLeft((t) => t - 1), 1000);
    return () => clearInterval(interval);
  }, [isActive, timeLeft]);

  const handleTextChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    const text = e.target.value;
    setEssayText(text);
    const words = text.trim().split(/\s+/).filter((w) => w.length > 0);
    setWordCount(words.length);
    if (!isActive && timeLeft > 0 && text.length > 0) setIsActive(true);
  };

  const formatTime = (s: number) => {
    const m = Math.floor(s / 60);
    const sec = s % 60;
    return `${m.toString().padStart(2, "0")}:${sec.toString().padStart(2, "0")}`;
  };

  const getTimerColor = () => {
    if (timeLeft < 300) return "text-destructive";
    if (timeLeft < 600) return "text-warning";
    return "text-foreground";
  };

  const handleSubmit = () => {
    setIsActive(false);
    const base = wordCount > selectedTask.minWords ? 7.0 : 6.0;
    const rand = () => (Math.random() * 1.0 - 0.5);
    setScores({
      overall: (base + 0.5).toFixed(1),
      task: (base + rand()).toFixed(1),
      coherence: (base + 0.5 + rand()).toFixed(1),
      lexical: (base + 1.0 + rand()).toFixed(1),
      grammar: (base + rand()).toFixed(1),
      feedback:
        wordCount < selectedTask.minWords
          ? "Your essay is under the word count limit, which may penalize your Task Achievement score. Focus on expanding your supporting arguments."
          : "Good length. You've developed your ideas well. To improve further, try to use more varied sentence structures and less common vocabulary.",
    });
    setShowResults(true);
  };

  const handleTaskSelect = (task: typeof writingTasks[0]) => {
    setSelectedTask(task);
    setShowDropdown(false);
    setEssayText("");
    setWordCount(0);
    setTimeLeft(task.timeMinutes * 60);
    setIsActive(false);
  };

  return (
    <DashboardLayout>
      <div className="flex flex-col h-[calc(100vh-4rem)] overflow-hidden">
        {/* Writing Header */}
        <div className="flex items-center justify-between border-b border-border bg-card px-4 py-3 md:px-6 shrink-0">
          <div className="relative">
            <button
              onClick={() => setShowDropdown(!showDropdown)}
              className="flex items-center gap-2 rounded-xl border border-border bg-secondary px-3 py-2 text-sm font-medium text-foreground hover:bg-secondary/80 transition-colors"
            >
              <BookOpen className="h-4 w-4 text-primary" />
              <span className="hidden sm:inline">{selectedTask.type}: {selectedTask.title}</span>
              <span className="sm:hidden">{selectedTask.type}</span>
              <ChevronDown className="h-4 w-4" />
            </button>
            {showDropdown && (
              <div className="absolute top-full left-0 mt-2 w-80 rounded-xl border border-border bg-card shadow-xl z-50">
                {writingTasks.map((task) => (
                  <button
                    key={task.id}
                    onClick={() => handleTaskSelect(task)}
                    className="w-full text-left px-4 py-3 hover:bg-secondary transition-colors first:rounded-t-xl last:rounded-b-xl"
                  >
                    <div className="flex items-center gap-2 mb-1">
                      <span className="text-xs font-bold text-primary uppercase">{task.type}</span>
                      <span className="text-xs text-muted-foreground">· {task.category}</span>
                    </div>
                    <div className="text-sm font-medium text-foreground">{task.title}</div>
                  </button>
                ))}
              </div>
            )}
          </div>

          <div className={`flex items-center gap-2 rounded-xl border border-border px-3 py-2 font-mono text-lg font-medium tabular-nums ${getTimerColor()}`}>
            <Clock className="h-4 w-4 opacity-75" />
            {formatTime(timeLeft)}
          </div>
        </div>

        {/* Two-Pane Layout */}
        <div className="flex-1 flex flex-col md:flex-row overflow-hidden">
          {/* Editor */}
          <div className="flex-1 flex flex-col bg-card">
            <div className="flex-1 p-6 md:p-10 overflow-y-auto">
              <textarea
                ref={textareaRef}
                value={essayText}
                onChange={handleTextChange}
                placeholder="Start typing your essay here..."
                className="w-full h-full min-h-[300px] resize-none outline-none border-none bg-transparent text-lg leading-relaxed font-serif text-foreground placeholder:text-muted-foreground/40 placeholder:font-sans"
                spellCheck={false}
              />
            </div>

            {/* Footer Bar */}
            <div className="border-t border-border bg-card px-4 py-3 md:px-6 flex items-center justify-between shrink-0">
              <div className="flex items-center gap-4">
                <div>
                  <span className="text-[10px] uppercase text-muted-foreground font-semibold tracking-wider block">Words</span>
                  <span className={`text-lg font-bold ${wordCount < selectedTask.minWords ? "text-warning" : "text-success"}`}>
                    {wordCount}
                    <span className="text-xs font-normal text-muted-foreground"> / {selectedTask.minWords}+</span>
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
              <button
                onClick={handleSubmit}
                disabled={wordCount === 0}
                className="rounded-xl bg-primary px-6 py-2.5 text-sm font-semibold text-primary-foreground shadow-lg shadow-primary/20 transition-all hover:scale-105 active:scale-95 disabled:opacity-50 disabled:hover:scale-100 flex items-center gap-2"
              >
                Submit Essay <CheckCircle className="h-4 w-4" />
              </button>
            </div>
          </div>

          {/* Right Panel */}
          <div className="w-full md:w-[420px] lg:w-[480px] border-t md:border-t-0 md:border-l border-border bg-background overflow-y-auto shrink-0">
            <div className="p-6">
              <div className="rounded-2xl border border-border bg-card p-6 mb-6">
                <div className="flex items-center justify-between mb-4">
                  <span className="rounded-lg bg-primary/10 px-2.5 py-1 text-xs font-bold text-primary uppercase tracking-wide">
                    {selectedTask.type} · {selectedTask.category}
                  </span>
                  <Maximize2 className="h-4 w-4 text-muted-foreground cursor-pointer hover:text-primary transition-colors" />
                </div>
                <h2 className="text-lg font-serif font-bold text-foreground leading-snug whitespace-pre-line">
                  {selectedTask.question}
                </h2>
                <hr className="my-4 border-border" />
                <p className="text-sm text-muted-foreground italic leading-relaxed">{selectedTask.context}</p>
              </div>

              <div className="space-y-4">
                <h3 className="text-xs font-bold text-foreground uppercase tracking-widest">Examiner's Advice</h3>
                <div className="flex gap-3 items-start">
                  <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-success/10 text-success">
                    <AlignLeft className="h-4 w-4" />
                  </div>
                  <div>
                    <h4 className="text-sm font-semibold text-foreground">Structure your paragraphs</h4>
                    <p className="mt-1 text-xs text-muted-foreground leading-relaxed">
                      Ensure each paragraph has a clear topic sentence and one main idea.
                    </p>
                  </div>
                </div>
                <div className="flex gap-3 items-start">
                  <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-warning/10 text-warning">
                    <Clock className="h-4 w-4" />
                  </div>
                  <div>
                    <h4 className="text-sm font-semibold text-foreground">Watch your timing</h4>
                    <p className="mt-1 text-xs text-muted-foreground leading-relaxed">
                      Spend ~5 min planning, ~30 min writing, and ~5 min checking.
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Results Modal */}
      {showResults && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-foreground/20 backdrop-blur-sm">
          <div className="w-full max-w-2xl rounded-2xl bg-card shadow-2xl overflow-hidden border border-border">
            <div className="bg-primary p-6 flex justify-between items-start text-primary-foreground">
              <div>
                <h2 className="text-2xl font-bold">Evaluation Report</h2>
                <p className="text-primary-foreground/70 text-sm mt-1">AI-Powered Assessment based on IELTS Criteria</p>
              </div>
              <button onClick={() => setShowResults(false)} className="rounded-full bg-primary-foreground/10 p-2 hover:bg-primary-foreground/20 transition-colors">
                <X className="h-5 w-5" />
              </button>
            </div>
            <div className="p-6 md:p-8">
              <div className="flex flex-col md:flex-row items-center gap-6 mb-8">
                <div className="relative h-32 w-32 shrink-0">
                  <svg className="w-full h-full -rotate-90" viewBox="0 0 36 36">
                    <path
                      d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"
                      fill="none"
                      stroke="hsl(var(--border))"
                      strokeWidth="3"
                    />
                    <path
                      d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"
                      fill="none"
                      stroke="hsl(var(--primary))"
                      strokeWidth="3"
                      strokeDasharray={`${(parseFloat(scores.overall) / 9) * 100}, 100`}
                    />
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
                Review Essay
              </button>
              <button
                onClick={() => {
                  setShowResults(false);
                  setEssayText("");
                  setWordCount(0);
                  setTimeLeft(selectedTask.timeMinutes * 60);
                  setIsActive(false);
                }}
                className="px-5 py-2 rounded-xl bg-primary text-sm font-semibold text-primary-foreground hover:bg-primary/90 transition-colors"
              >
                Start New Task
              </button>
            </div>
          </div>
        </div>
      )}
    </DashboardLayout>
  );
};

export default WritingSimulator;
