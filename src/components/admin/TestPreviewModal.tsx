import React, { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import {
  Dialog,
  DialogContent,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  Select,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Monitor,
  Tablet,
  Smartphone,
  X,
  BookOpen,
  Headphones,
  PenTool,
  Clock,
  FileText,
  ImageIcon,
  AlertCircle,
  RotateCcw,
} from "lucide-react";
import { cn } from "@/lib/utils";

// ─── Types (shared with CreateContent) ────────

interface MCOption {
  id: string;
  text: string;
  isCorrect: boolean;
}

interface MatchingPair {
  id: string;
  left: string;
  right: string;
}

interface CompletionGap {
  id: string;
  gapText: string;
  answer: string;
}

interface AcceptedAnswer {
  id: string;
  text: string;
}

interface QuestionItem {
  id: string;
  text: string;
  answer: string;
  options: MCOption[];
  matchingPairs: MatchingPair[];
  completionGaps: CompletionGap[];
  acceptedAnswers: AcceptedAnswer[];
  timestamp?: string;
}

interface QuestionGroup {
  id: string;
  type: string;
  instructions: string;
  wordLimit: string;
  hasWordBank: boolean;
  wordBank: string[];
  sequentialOrder: boolean;
  multipleSelection: boolean;
  selectCount: number;
  questions: QuestionItem[];
}

export interface PreviewReadingPassage {
  id: number;
  title: string;
  content: string;
  questionGroups: QuestionGroup[];
}

export interface PreviewReadingState {
  testTitle: string;
  testType: string;
  difficulty: string;
  duration: string;
  passages: PreviewReadingPassage[];
}

export interface PreviewListeningSectionState {
  id: number;
  title: string;
  transcript: string;
  audioFileName: string;
  questionGroups: QuestionGroup[];
}

export interface PreviewListeningState {
  testTitle: string;
  difficulty: string;
  duration: string;
  sections: PreviewListeningSectionState[];
}

export interface PreviewWritingState {
  taskType: "task1" | "task2";
  title: string;
  difficulty: string;
  suggestedTime: string;
  prompt: string;
  minWords: number;
  maxWords: string;
}

export interface PreviewProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  activeModule: "reading" | "listening" | "writing";
  reading: PreviewReadingState;
  listening: PreviewListeningState;
  writing: PreviewWritingState;
}

// ─── Device Presets ─────────────────────────────

type DeviceType = "desktop" | "tablet" | "mobile";

interface DeviceConfig {
  width: number | null; // null = full width
  label: string;
  splitLayout: boolean; // whether to use side-by-side layout
}

const deviceConfigs: Record<DeviceType, DeviceConfig> = {
  desktop: { width: null, label: "Desktop", splitLayout: true },
  tablet: { width: 768, label: "Tablet (768px)", splitLayout: true },
  mobile: { width: 375, label: "Mobile (375px)", splitLayout: false },
};

// ─── Question Type Config ───────────────────────

const typeLabels: Record<string, { label: string; badgeClass: string }> = {
  "multiple-choice": { label: "Multiple Choice", badgeClass: "bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400" },
  tfng: { label: "True / False / Not Given", badgeClass: "bg-sky-100 text-sky-700 dark:bg-sky-900/30 dark:text-sky-400" },
  ynng: { label: "Yes / No / Not Given", badgeClass: "bg-cyan-100 text-cyan-700 dark:bg-cyan-900/30 dark:text-cyan-400" },
  "matching-headings": { label: "Matching Headings", badgeClass: "bg-violet-100 text-violet-700 dark:bg-violet-900/30 dark:text-violet-400" },
  "matching-information": { label: "Matching Info", badgeClass: "bg-purple-100 text-purple-700 dark:bg-purple-900/30 dark:text-purple-400" },
  "matching-features": { label: "Matching Features", badgeClass: "bg-fuchsia-100 text-fuchsia-700 dark:bg-fuchsia-900/30 dark:text-fuchsia-400" },
  "matching-sentence-endings": { label: "Sentence Endings", badgeClass: "bg-pink-100 text-pink-700 dark:bg-pink-900/30 dark:text-pink-400" },
  "sentence-completion": { label: "Sentence Completion", badgeClass: "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400" },
  "summary-completion": { label: "Summary Completion", badgeClass: "bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400" },
  "note-completion": { label: "Note Completion", badgeClass: "bg-teal-100 text-teal-700 dark:bg-teal-900/30 dark:text-teal-400" },
  "table-completion": { label: "Table Completion", badgeClass: "bg-lime-100 text-lime-700 dark:bg-lime-900/30 dark:text-lime-400" },
  "flow-chart-completion": { label: "Flowchart", badgeClass: "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400" },
  "diagram-labeling": { label: "Diagram Label", badgeClass: "bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400" },
  "short-answer": { label: "Short Answer", badgeClass: "bg-orange-100 text-orange-700 dark:bg-orange-900/30 dark:text-orange-400" },
};

// ─── Empty State ────────────────────────────────

const EmptyPreview: React.FC<{ message?: string }> = ({ message }) => (
  <div className="flex flex-col items-center justify-center py-20 text-center px-4">
    <div className="rounded-full bg-muted p-4 mb-4">
      <AlertCircle className="h-8 w-8 text-muted-foreground" />
    </div>
    <h3 className="text-lg font-semibold text-foreground">No Content Yet</h3>
    <p className="text-sm text-muted-foreground mt-1 max-w-sm">
      {message || "Add content to the editor to see a live preview here."}
    </p>
  </div>
);

// ─── Student-Style Question Preview ─────────────

const QuestionPreview: React.FC<{ group: QuestionGroup; groupIndex: number; compact?: boolean }> = ({ group, groupIndex, compact }) => {
  const meta = typeLabels[group.type] || { label: group.type, badgeClass: "bg-muted text-muted-foreground" };
  const isIdentification = group.type === "tfng" || group.type === "ynng";
  const isMatching = group.type.startsWith("matching");
  const isCompletion = ["sentence-completion", "summary-completion", "note-completion", "table-completion", "flow-chart-completion"].includes(group.type);

  const tfngOptions = group.type === "tfng" ? ["TRUE", "FALSE", "NOT GIVEN"] : ["YES", "NO", "NOT GIVEN"];

  return (
    <div className="space-y-3">
      <div className="flex items-center gap-2 flex-wrap">
        <span className={cn("inline-flex items-center rounded-full px-2 py-0.5 text-[10px] font-semibold border", meta.badgeClass)}>
          {meta.label}
        </span>
        <Badge variant="secondary" className="text-[10px]">{group.questions.length} Qs</Badge>
      </div>
      {group.instructions && (
        <p className="text-xs text-muted-foreground italic">{group.instructions}</p>
      )}
      {group.wordLimit && (
        <Badge variant="outline" className="text-[10px]">📏 {group.wordLimit}</Badge>
      )}

      {group.hasWordBank && group.wordBank.length > 0 && (
        <div className="flex flex-wrap gap-1 p-2 rounded-lg border border-border bg-secondary/50">
          {group.wordBank.map((w, i) => (
            <Badge key={i} variant="secondary" className="text-[10px]">{w}</Badge>
          ))}
        </div>
      )}

      <div className="space-y-2">
        {group.questions.map((q, qIdx) => (
          <div key={q.id} className={cn("rounded-lg border border-border bg-card space-y-2", compact ? "p-2" : "p-3")}>
            {q.text && (
              <p className={cn("font-medium text-foreground", compact ? "text-xs" : "text-sm")}>
                <span className="font-bold text-primary mr-1">{groupIndex + qIdx + 1}.</span>
                {q.text}
              </p>
            )}

            {/* MC options */}
            {group.type === "multiple-choice" && q.options.length > 0 && (
              <div className={cn("space-y-1.5", compact ? "ml-2" : "ml-4")}>
                {q.options.map((opt, oIdx) => (
                  <div key={opt.id} className={cn(
                    "flex items-center gap-2 rounded-lg border border-border text-muted-foreground hover:bg-secondary transition-colors",
                    compact ? "px-2 py-1.5 text-xs" : "px-3 py-2 text-sm"
                  )}>
                    <div className="h-3.5 w-3.5 rounded-full border-2 border-muted-foreground/30 shrink-0" />
                    <span className="break-words min-w-0">{String.fromCharCode(65 + oIdx)}. {opt.text || "(empty)"}</span>
                  </div>
                ))}
              </div>
            )}

            {/* TFNG / YNNG pills */}
            {isIdentification && (
              <div className={cn("flex flex-wrap gap-1.5", compact ? "ml-2" : "ml-4")}>
                {tfngOptions.map((opt) => (
                  <button key={opt} className={cn(
                    "rounded-lg border border-border font-medium text-muted-foreground hover:bg-secondary transition-colors",
                    compact ? "px-2 py-1 text-[10px]" : "px-3 py-1.5 text-xs"
                  )}>
                    {opt}
                  </button>
                ))}
              </div>
            )}

            {/* Matching pairs */}
            {isMatching && q.matchingPairs.length > 0 && (
              <div className={cn("space-y-1.5", compact ? "ml-2" : "ml-4")}>
                {q.matchingPairs.map((pair) => (
                  <div key={pair.id} className="flex items-center gap-2 text-sm flex-wrap">
                    <span className="font-medium text-foreground flex-1 min-w-0 break-words text-xs">{pair.left || "—"}</span>
                    <Select disabled>
                      <SelectTrigger className={cn("h-7 text-xs shrink-0", compact ? "w-24" : "w-28")}>
                        <SelectValue placeholder="Select..." />
                      </SelectTrigger>
                    </Select>
                  </div>
                ))}
              </div>
            )}

            {/* Completion gaps */}
            {(isCompletion || group.type === "diagram-labeling") && q.completionGaps.length > 0 && (
              <div className={cn("space-y-1.5", compact ? "ml-2" : "ml-4")}>
                {q.completionGaps.map((gap, gIdx) => (
                  <div key={gap.id} className="flex items-start gap-2 text-xs flex-wrap">
                    <span className="text-muted-foreground w-4 shrink-0 pt-1">{gIdx + 1}.</span>
                    <span className="text-foreground flex-1 min-w-0 break-words">
                      {gap.gapText ? gap.gapText.replace(/\{\{gap\}\}/g, "______") : "(empty)"}
                    </span>
                    <Input disabled placeholder="..." className={cn("h-7 text-xs shrink-0", compact ? "w-20" : "w-28")} />
                  </div>
                ))}
              </div>
            )}

            {/* Short answer */}
            {group.type === "short-answer" && (
              <div className={compact ? "ml-2" : "ml-4"}>
                <Input disabled placeholder="Type answer..." className="h-7 text-xs w-full" />
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
};

// ─── Questions Panel (reused across modules) ────

const QuestionsPanel: React.FC<{ groups: QuestionGroup[]; compact?: boolean; className?: string }> = ({ groups, compact, className }) => (
  <div className={cn("bg-background overflow-y-auto", className)}>
    <h3 className={cn("font-bold text-foreground mb-4", compact ? "text-xs" : "text-sm")}>Questions</h3>
    <div className="space-y-5">
      {groups.map((group, gIdx) => {
        const startQ = groups.slice(0, gIdx).reduce((a, g) => a + g.questions.length, 0);
        return (
          <React.Fragment key={group.id}>
            {gIdx > 0 && <Separator />}
            <QuestionPreview group={group} groupIndex={startQ} compact={compact} />
          </React.Fragment>
        );
      })}
    </div>
  </div>
);

// ─── Mobile Pane Toggle ─────────────────────────

const PaneToggle: React.FC<{
  activePane: "content" | "questions";
  onToggle: (pane: "content" | "questions") => void;
  contentLabel: string;
  questionCount: number;
}> = ({ activePane, onToggle, contentLabel, questionCount }) => (
  <div className="flex bg-muted rounded-lg p-0.5 mb-3">
    <button
      onClick={() => onToggle("content")}
      className={cn(
        "flex-1 text-xs font-medium py-1.5 rounded-md transition-all text-center",
        activePane === "content"
          ? "bg-background text-foreground shadow-sm"
          : "text-muted-foreground"
      )}
    >
      {contentLabel}
    </button>
    <button
      onClick={() => onToggle("questions")}
      className={cn(
        "flex-1 text-xs font-medium py-1.5 rounded-md transition-all text-center",
        activePane === "questions"
          ? "bg-background text-foreground shadow-sm"
          : "text-muted-foreground"
      )}
    >
      Questions ({questionCount})
    </button>
  </div>
);

// ─── Reading Preview ────────────────────────────

const ReadingPreviewContent: React.FC<{ data: PreviewReadingState; split: boolean }> = ({ data, split }) => {
  const [activePassage, setActivePassage] = useState(0);
  const [activePane, setActivePane] = useState<"content" | "questions">("content");

  const hasAny = data.passages.some(
    (p) => p.title.trim() || p.content.trim() || p.questionGroups.some((g) => g.questions.length > 0 && (g.questions[0].text || g.questions[0].options.some((o) => o.text) || g.questions[0].matchingPairs.length > 0 || g.questions[0].completionGaps.length > 0))
  );

  if (!hasAny && !data.testTitle.trim()) {
    return <EmptyPreview message="Add passage titles and content in the Reading editor to see the student view." />;
  }

  const currentPassage = data.passages[activePassage];
  const totalQs = currentPassage?.questionGroups.reduce((a, g) => a + g.questions.length, 0) || 0;

  const passageTabs = (
    <div className="flex items-center gap-1 p-1 rounded-lg bg-muted overflow-x-auto">
      {data.passages.map((p, i) => (
        <button
          key={p.id}
          onClick={() => { setActivePassage(i); setActivePane("content"); }}
          className={cn(
            "flex-1 min-w-0 whitespace-nowrap rounded-md px-3 py-1.5 text-xs font-medium transition-all text-center",
            activePassage === i
              ? "bg-background text-foreground shadow-sm"
              : "text-muted-foreground hover:bg-background/50"
          )}
        >
          Passage {i + 1}
        </button>
      ))}
    </div>
  );

  const passageContent = (
    <div className={cn(split ? "p-5" : "p-4")}>
      <div className="flex items-center gap-2 mb-3">
        <BookOpen className="h-4 w-4 text-primary" />
        <span className="text-sm font-semibold text-foreground">
          {data.testTitle || "Reading Test"}
        </span>
      </div>
      {passageTabs}
      {currentPassage?.title && (
        <h2 className={cn("font-serif font-bold text-foreground mt-4 mb-4", split ? "text-xl" : "text-lg")}>
          {currentPassage.title}
        </h2>
      )}
      {currentPassage?.content ? (
        currentPassage.content.split("\n\n").map((para, i) => (
          <p key={i} className={cn("font-serif text-foreground/90 mb-3", split ? "text-sm leading-[1.8]" : "text-xs leading-[1.7]")}>{para}</p>
        ))
      ) : (
        <p className="text-sm text-muted-foreground italic mt-4">Passage content will appear here...</p>
      )}
    </div>
  );

  if (split) {
    return (
      <div className="flex flex-row h-full min-h-[500px]">
        <div className="flex-1 overflow-y-auto border-r border-border bg-card">
          {passageContent}
        </div>
        <QuestionsPanel groups={currentPassage?.questionGroups || []} className="w-[45%] shrink-0 p-5 max-h-[80vh] overflow-y-auto" />
      </div>
    );
  }

  return (
    <div className="p-3">
      <PaneToggle activePane={activePane} onToggle={setActivePane} contentLabel="Passage" questionCount={totalQs} />
      <AnimatePresence mode="wait">
        <motion.div
          key={`${activePassage}-${activePane}`}
          initial={{ opacity: 0, x: activePane === "content" ? -10 : 10 }}
          animate={{ opacity: 1, x: 0 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.15 }}
          className="max-h-[70vh] overflow-y-auto rounded-lg border border-border bg-card"
        >
          {activePane === "content" ? (
            passageContent
          ) : (
            <QuestionsPanel groups={currentPassage?.questionGroups || []} compact className="p-3" />
          )}
        </motion.div>
      </AnimatePresence>
    </div>
  );
};

// ─── Listening Preview ──────────────────────────

const ListeningPreviewContent: React.FC<{ data: PreviewListeningState; split: boolean }> = ({ data, split }) => {
  const [previewSection, setPreviewSection] = useState(0);
  const [activePane, setActivePane] = useState<"content" | "questions">("content");

  const hasSections = data.sections.some(
    (s) => s.title.trim() || s.questionGroups.some((g) => g.questions.length > 0)
  );

  if (!hasSections && !data.testTitle.trim()) {
    return <EmptyPreview message="Add section titles and questions in the Listening editor to see the student view." />;
  }

  const currentSection = data.sections[previewSection];
  const totalQs = currentSection?.questionGroups.reduce((a, g) => a + g.questions.length, 0) || 0;

  const sectionTabs = (
    <div className="flex items-center gap-1 p-1 rounded-lg bg-muted overflow-x-auto">
      {data.sections.map((s, i) => (
        <button
          key={s.id}
          onClick={() => { setPreviewSection(i); setActivePane("content"); }}
          className={cn(
            "flex-1 min-w-0 whitespace-nowrap rounded-md px-3 py-1.5 text-xs font-medium transition-all text-center",
            previewSection === i
              ? "bg-background text-foreground shadow-sm"
              : "text-muted-foreground hover:bg-background/50"
          )}
        >
          S{i + 1}
        </button>
      ))}
    </div>
  );

  const audioContent = (
    <div className={cn(split ? "p-5" : "p-4", "space-y-4")}>
      <div className="flex items-center gap-2">
        <Headphones className="h-4 w-4 text-primary" />
        <span className="text-sm font-semibold text-foreground">
          {data.testTitle || "Listening Test"}
        </span>
      </div>
      {sectionTabs}
      {currentSection?.title && (
        <h2 className={cn("font-bold text-foreground", split ? "text-lg" : "text-base")}>
          Section {previewSection + 1}: {currentSection.title}
        </h2>
      )}
      {/* Audio player mock */}
      <div className="flex items-center gap-3 p-3 rounded-lg bg-muted/50 border border-border">
        <div className="h-9 w-9 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
          <Headphones className="h-4 w-4 text-primary" />
        </div>
        <div className="flex-1 min-w-0 space-y-1">
          <div className="h-2 bg-border rounded-full overflow-hidden">
            <div className="h-full w-0 bg-primary rounded-full" />
          </div>
          <div className="flex justify-between text-[10px] text-muted-foreground">
            <span>00:00</span>
            <span>{data.duration || "—"}</span>
          </div>
        </div>
      </div>
      {currentSection?.transcript && (
        <div className="space-y-1">
          <p className="text-xs font-semibold text-muted-foreground">Transcript</p>
          <div className="rounded-lg border border-border bg-background p-3">
            {currentSection.transcript.split("\n\n").map((para, i) => (
              <p key={i} className="text-xs text-foreground/90 mb-2">{para}</p>
            ))}
          </div>
        </div>
      )}
    </div>
  );

  if (split) {
    return (
      <div className="flex flex-row h-full min-h-[500px]">
        <div className="flex-1 overflow-y-auto border-r border-border bg-card">
          {audioContent}
        </div>
        <QuestionsPanel groups={currentSection?.questionGroups || []} className="w-[45%] shrink-0 p-5 max-h-[80vh] overflow-y-auto" />
      </div>
    );
  }

  return (
    <div className="p-3">
      <PaneToggle activePane={activePane} onToggle={setActivePane} contentLabel="Audio" questionCount={totalQs} />
      <AnimatePresence mode="wait">
        <motion.div
          key={`${previewSection}-${activePane}`}
          initial={{ opacity: 0, x: activePane === "content" ? -10 : 10 }}
          animate={{ opacity: 1, x: 0 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.15 }}
          className="max-h-[70vh] overflow-y-auto rounded-lg border border-border bg-card"
        >
          {activePane === "content" ? (
            audioContent
          ) : (
            <QuestionsPanel groups={currentSection?.questionGroups || []} compact className="p-3" />
          )}
        </motion.div>
      </AnimatePresence>
    </div>
  );
};

// ─── Writing Preview ────────────────────────────

const WritingPreviewContent: React.FC<{ data: PreviewWritingState; split: boolean }> = ({ data, split }) => {
  const hasContent = data.title.trim() || data.prompt.trim();

  if (!hasContent) {
    return <EmptyPreview message="Add a title and prompt in the Writing editor to see the student view." />;
  }

  const promptContent = (
    <div className={cn(split ? "p-5" : "p-4", "space-y-4")}>
      <div className="flex items-center gap-2">
        <PenTool className="h-4 w-4 text-primary" />
        <span className="text-sm font-semibold text-foreground">
          Writing {data.taskType === "task1" ? "Task 1" : "Task 2"}
        </span>
      </div>
      {data.title && (
        <h2 className={cn("font-bold text-foreground", split ? "text-xl" : "text-lg")}>{data.title}</h2>
      )}
      {data.taskType === "task1" && (
        <div className="border-2 border-dashed border-border rounded-xl p-6 flex flex-col items-center gap-2 bg-muted/30 overflow-hidden">
          <ImageIcon className="h-6 w-6 text-muted-foreground" />
          <p className="text-xs text-muted-foreground">Chart / Graph will appear here</p>
        </div>
      )}
      {data.prompt && (
        <div className="rounded-lg border border-border bg-background p-3 overflow-hidden">
          {data.prompt.split("\n").map((line, i) => (
            <p key={i} className="text-xs text-foreground/90 mb-1 break-words">{line || <br />}</p>
          ))}
        </div>
      )}
      <div className="flex items-center gap-3 text-xs text-muted-foreground flex-wrap">
        <span className="flex items-center gap-1"><FileText className="h-3 w-3" /> Min: {data.minWords} words</span>
        <span className="flex items-center gap-1"><Clock className="h-3 w-3" /> {data.suggestedTime}</span>
      </div>
    </div>
  );

  if (split) {
    return (
      <div className="flex flex-row h-full min-h-[500px]">
        <div className="flex-1 overflow-y-auto border-r border-border bg-card">
          {promptContent}
        </div>
        <div className="w-[45%] shrink-0 overflow-y-auto bg-background p-5">
          <h3 className="text-sm font-bold text-foreground mb-3">Your Response</h3>
          <Textarea disabled placeholder="Students will write their response here..." className="min-h-[300px] text-sm font-serif w-full" />
          <div className="flex justify-between items-center mt-3 text-xs text-muted-foreground">
            <span>Word count: 0 / {data.minWords}+</span>
            <Badge variant="outline" className="text-[10px]">Practice Mode</Badge>
          </div>
        </div>
      </div>
    );
  }

  // Stacked (mobile)
  return (
    <div className="overflow-hidden">
      <div className="bg-card border-b border-border">
        {promptContent}
      </div>
      <div className="p-3 bg-background">
        <h3 className="text-xs font-bold text-foreground mb-2">Your Response</h3>
        <Textarea disabled placeholder="Students will write here..." className="min-h-[200px] text-xs font-serif w-full" />
        <div className="flex justify-between items-center mt-2 text-[10px] text-muted-foreground">
          <span>0 / {data.minWords}+ words</span>
          <Badge variant="outline" className="text-[10px]">Practice</Badge>
        </div>
      </div>
    </div>
  );
};

// ─── Main Preview Modal ─────────────────────────

export const TestPreviewModal: React.FC<PreviewProps> = ({
  open,
  onOpenChange,
  activeModule,
  reading,
  listening,
  writing,
}) => {
  const [device, setDevice] = useState<DeviceType>("desktop");
  const [landscape, setLandscape] = useState(false);

  const config = deviceConfigs[device];
  const useSplit = config.splitLayout;

  // Calculate container dimensions
  const containerStyle: React.CSSProperties = {};
  if (config.width) {
    if (landscape && device !== "desktop") {
      // Landscape: swap dimensions conceptually — wider container
      containerStyle.width = device === "mobile" ? 667 : 1024;
      containerStyle.maxWidth = "100%";
    } else {
      containerStyle.width = config.width;
      containerStyle.maxWidth = "100%";
    }
  }

  const ModuleIcon = activeModule === "reading" ? BookOpen : activeModule === "listening" ? Headphones : PenTool;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-[95vw] w-full h-[90vh] p-0 gap-0 flex flex-col overflow-hidden">
        {/* Toolbar */}
        <div className="flex items-center justify-between px-4 py-2.5 border-b border-border bg-muted/50 shrink-0 flex-wrap gap-2">
          <div className="flex items-center gap-3">
            <DialogTitle className="text-sm font-semibold flex items-center gap-2">
              <ModuleIcon className="h-4 w-4 text-primary" />
              Preview — <span className="capitalize">{activeModule}</span>
            </DialogTitle>
            <Badge variant="outline" className="text-[10px]">Read-only</Badge>
          </div>

          <div className="flex items-center gap-2">
            {/* Device Toggle */}
            <div className="flex items-center gap-0.5 bg-background rounded-lg p-0.5 border border-border">
              {(["desktop", "tablet", "mobile"] as DeviceType[]).map((type) => {
                const Icon = type === "desktop" ? Monitor : type === "tablet" ? Tablet : Smartphone;
                return (
                  <button
                    key={type}
                    onClick={() => { setDevice(type); setLandscape(false); }}
                    title={deviceConfigs[type].label}
                    className={cn(
                      "p-1.5 rounded-md transition-all",
                      device === type
                        ? "bg-primary text-primary-foreground shadow-sm"
                        : "text-muted-foreground hover:text-foreground"
                    )}
                  >
                    <Icon className="h-4 w-4" />
                  </button>
                );
              })}
            </div>

            {/* Rotate (tablet/mobile only) */}
            {device !== "desktop" && (
              <button
                onClick={() => setLandscape((p) => !p)}
                title={landscape ? "Portrait" : "Landscape"}
                className={cn(
                  "p-1.5 rounded-md border border-border transition-all",
                  landscape ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:text-foreground bg-background"
                )}
              >
                <RotateCcw className="h-4 w-4" />
              </button>
            )}
          </div>

          <Button variant="ghost" size="icon" className="h-7 w-7" onClick={() => onOpenChange(false)}>
            <X className="h-4 w-4" />
          </Button>
        </div>

        {/* Preview Content */}
        <div className="flex-1 overflow-hidden bg-muted/30 flex justify-center items-start p-4 overflow-x-hidden">
          <motion.div
            layout
            transition={{ duration: 0.3, ease: "easeInOut" }}
            style={containerStyle}
            className={cn(
              "bg-background rounded-xl border border-border shadow-xl overflow-hidden",
              device === "desktop" ? "w-full h-full" : "mx-auto",
              device !== "desktop" && "shadow-2xl"
            )}
          >
            <ScrollArea className={cn(device === "desktop" ? "h-full" : "max-h-[80vh]")}>
              <div className="overflow-x-hidden">
                <AnimatePresence mode="wait">
                  <motion.div
                    key={`${activeModule}-${device}-${landscape}`}
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    exit={{ opacity: 0 }}
                    transition={{ duration: 0.15 }}
                  >
                    {activeModule === "reading" && <ReadingPreviewContent data={reading} split={useSplit || (landscape && device !== "desktop")} />}
                    {activeModule === "listening" && <ListeningPreviewContent data={listening} split={useSplit || (landscape && device !== "desktop")} />}
                    {activeModule === "writing" && <WritingPreviewContent data={writing} split={useSplit || (landscape && device !== "desktop")} />}
                  </motion.div>
                </AnimatePresence>
              </div>
            </ScrollArea>
          </motion.div>
        </div>
      </DialogContent>
    </Dialog>
  );
};
