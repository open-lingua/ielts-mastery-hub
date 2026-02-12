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
  SelectContent,
  SelectItem,
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

export interface PreviewReadingState {
  title: string;
  passage: string;
  difficulty: string;
  duration: string;
  questionGroups: QuestionGroup[];
}

export interface PreviewListeningState {
  sectionTitle: string;
  difficulty: string;
  duration: string;
  transcript: string;
  questionGroups: QuestionGroup[];
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

const deviceWidths: Record<DeviceType, string> = {
  desktop: "w-full",
  tablet: "max-w-[768px]",
  mobile: "max-w-[375px]",
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
  <div className="flex flex-col items-center justify-center py-20 text-center">
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

const QuestionPreview: React.FC<{ group: QuestionGroup; groupIndex: number }> = ({ group, groupIndex }) => {
  const meta = typeLabels[group.type] || { label: group.type, badgeClass: "bg-muted text-muted-foreground" };
  const isIdentification = group.type === "tfng" || group.type === "ynng";
  const isMatching = group.type.startsWith("matching");
  const isCompletion = ["sentence-completion", "summary-completion", "note-completion", "table-completion", "flow-chart-completion"].includes(group.type);

  const tfngOptions = group.type === "tfng" ? ["TRUE", "FALSE", "NOT GIVEN"] : ["YES", "NO", "NOT GIVEN"];

  return (
    <div className="space-y-3">
      <div className="flex items-center gap-2">
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

      {/* Word bank */}
      {group.hasWordBank && group.wordBank.length > 0 && (
        <div className="flex flex-wrap gap-1 p-2 rounded-lg border border-border bg-secondary/50">
          {group.wordBank.map((w, i) => (
            <Badge key={i} variant="secondary" className="text-[10px]">{w}</Badge>
          ))}
        </div>
      )}

      <div className="space-y-2">
        {group.questions.map((q, qIdx) => (
          <div key={q.id} className="rounded-lg border border-border bg-card p-3 space-y-2">
            {/* Question text */}
            {q.text && (
              <p className="text-sm font-medium text-foreground">
                <span className="font-bold text-primary mr-1">{groupIndex + qIdx + 1}.</span>
                {q.text}
              </p>
            )}

            {/* MC options */}
            {group.type === "multiple-choice" && q.options.length > 0 && (
              <div className="space-y-1.5 ml-4">
                {q.options.map((opt, oIdx) => (
                  <div key={opt.id} className="flex items-center gap-2 rounded-lg border border-border px-3 py-2 text-sm text-muted-foreground hover:bg-secondary transition-colors">
                    <div className="h-4 w-4 rounded-full border-2 border-muted-foreground/30 shrink-0" />
                    <span>{String.fromCharCode(65 + oIdx)}. {opt.text || "(empty option)"}</span>
                  </div>
                ))}
              </div>
            )}

            {/* TFNG / YNNG pills */}
            {isIdentification && (
              <div className="flex gap-2 ml-4">
                {tfngOptions.map((opt) => (
                  <button key={opt} className="rounded-lg border border-border px-3 py-1.5 text-xs font-medium text-muted-foreground hover:bg-secondary transition-colors">
                    {opt}
                  </button>
                ))}
              </div>
            )}

            {/* Matching pairs */}
            {isMatching && q.matchingPairs.length > 0 && (
              <div className="space-y-1.5 ml-4">
                {q.matchingPairs.map((pair) => (
                  <div key={pair.id} className="flex items-center gap-2 text-sm">
                    <span className="font-medium text-foreground flex-1">{pair.left || "—"}</span>
                    <Select disabled>
                      <SelectTrigger className="w-32 h-7 text-xs">
                        <SelectValue placeholder="Select..." />
                      </SelectTrigger>
                    </Select>
                  </div>
                ))}
              </div>
            )}

            {/* Completion gaps */}
            {(isCompletion || group.type === "diagram-labeling") && q.completionGaps.length > 0 && (
              <div className="space-y-1.5 ml-4">
                {q.completionGaps.map((gap, gIdx) => (
                  <div key={gap.id} className="flex items-center gap-2 text-sm">
                    <span className="text-xs text-muted-foreground w-4">{gIdx + 1}.</span>
                    <span className="text-foreground flex-1">
                      {gap.gapText
                        ? gap.gapText.replace(/\{\{gap\}\}/g, "______")
                        : "(empty)"}
                    </span>
                    <Input disabled placeholder="Type answer..." className="w-32 h-7 text-xs" />
                  </div>
                ))}
              </div>
            )}

            {/* Short answer */}
            {group.type === "short-answer" && (
              <div className="ml-4">
                <Input disabled placeholder="Type answer..." className="h-8 text-sm" />
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
};

// ─── Reading Preview ────────────────────────────

const ReadingPreviewContent: React.FC<{ data: PreviewReadingState }> = ({ data }) => {
  const hasContent = data.title.trim() || data.passage.trim();
  const hasQuestions = data.questionGroups.some((g) => g.questions.length > 0 && (g.questions[0].text || g.questions[0].options.some((o) => o.text) || g.questions[0].matchingPairs.length > 0 || g.questions[0].completionGaps.length > 0));

  if (!hasContent && !hasQuestions) {
    return <EmptyPreview message="Add a title and passage in the Reading editor to see the student view." />;
  }

  return (
    <div className="flex flex-col md:flex-row h-full min-h-[600px]">
      {/* Passage */}
      <div className="flex-1 overflow-y-auto border-b md:border-b-0 md:border-r border-border bg-card p-6">
        <div className="max-w-xl mx-auto">
          <div className="flex items-center gap-2 mb-4">
            <BookOpen className="h-4 w-4 text-primary" />
            <span className="text-sm font-semibold text-foreground">Reading Passage</span>
          </div>
          {data.title && (
            <h2 className="text-xl font-serif font-bold text-foreground mb-4">{data.title}</h2>
          )}
          {data.passage ? (
            data.passage.split("\n\n").map((para, i) => (
              <p key={i} className="text-sm font-serif leading-[1.8] text-foreground/90 mb-3">{para}</p>
            ))
          ) : (
            <p className="text-sm text-muted-foreground italic">Passage content will appear here...</p>
          )}
        </div>
      </div>

      {/* Questions */}
      <div className="w-full md:w-[380px] lg:w-[420px] overflow-y-auto bg-background p-5 shrink-0">
        <h3 className="text-sm font-bold text-foreground mb-4">Questions</h3>
        <div className="space-y-6">
          {data.questionGroups.map((group, gIdx) => {
            const startQ = data.questionGroups.slice(0, gIdx).reduce((a, g) => a + g.questions.length, 0);
            return (
              <React.Fragment key={group.id}>
                {gIdx > 0 && <Separator />}
                <QuestionPreview group={group} groupIndex={startQ} />
              </React.Fragment>
            );
          })}
        </div>
      </div>
    </div>
  );
};

// ─── Listening Preview ──────────────────────────

const ListeningPreviewContent: React.FC<{ data: PreviewListeningState }> = ({ data }) => {
  const hasContent = data.sectionTitle.trim() || data.transcript.trim();
  const hasQuestions = data.questionGroups.some((g) => g.questions.length > 0);

  if (!hasContent && !hasQuestions) {
    return <EmptyPreview message="Add a section title and questions in the Listening editor to see the student view." />;
  }

  return (
    <div className="flex flex-col md:flex-row h-full min-h-[600px]">
      {/* Audio & Transcript */}
      <div className="flex-1 overflow-y-auto border-b md:border-b-0 md:border-r border-border bg-card p-6">
        <div className="max-w-xl mx-auto space-y-4">
          <div className="flex items-center gap-2 mb-2">
            <Headphones className="h-4 w-4 text-primary" />
            <span className="text-sm font-semibold text-foreground">Listening Section</span>
          </div>
          {data.sectionTitle && (
            <h2 className="text-xl font-bold text-foreground">{data.sectionTitle}</h2>
          )}
          {/* Mock audio player */}
          <div className="flex items-center gap-3 p-3 rounded-lg bg-muted/50 border border-border">
            <div className="h-10 w-10 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
              <Headphones className="h-5 w-5 text-primary" />
            </div>
            <div className="flex-1 space-y-1">
              <div className="h-2 bg-border rounded-full overflow-hidden">
                <div className="h-full w-0 bg-primary rounded-full" />
              </div>
              <div className="flex justify-between text-[10px] text-muted-foreground">
                <span>00:00</span>
                <span>{data.duration || "—"}</span>
              </div>
            </div>
          </div>
          {data.transcript && (
            <div className="space-y-1">
              <p className="text-xs font-semibold text-muted-foreground">Transcript</p>
              <div className="rounded-lg border border-border bg-background p-4">
                {data.transcript.split("\n\n").map((para, i) => (
                  <p key={i} className="text-sm text-foreground/90 mb-2">{para}</p>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Questions */}
      <div className="w-full md:w-[380px] lg:w-[420px] overflow-y-auto bg-background p-5 shrink-0">
        <h3 className="text-sm font-bold text-foreground mb-4">Questions</h3>
        <div className="space-y-6">
          {data.questionGroups.map((group, gIdx) => {
            const startQ = data.questionGroups.slice(0, gIdx).reduce((a, g) => a + g.questions.length, 0);
            return (
              <React.Fragment key={group.id}>
                {gIdx > 0 && <Separator />}
                <QuestionPreview group={group} groupIndex={startQ} />
              </React.Fragment>
            );
          })}
        </div>
      </div>
    </div>
  );
};

// ─── Writing Preview ────────────────────────────

const WritingPreviewContent: React.FC<{ data: PreviewWritingState }> = ({ data }) => {
  const hasContent = data.title.trim() || data.prompt.trim();

  if (!hasContent) {
    return <EmptyPreview message="Add a title and prompt in the Writing editor to see the student view." />;
  }

  return (
    <div className="flex flex-col md:flex-row h-full min-h-[600px]">
      {/* Prompt */}
      <div className="flex-1 overflow-y-auto border-b md:border-b-0 md:border-r border-border bg-card p-6">
        <div className="max-w-xl mx-auto space-y-4">
          <div className="flex items-center gap-2 mb-2">
            <PenTool className="h-4 w-4 text-primary" />
            <span className="text-sm font-semibold text-foreground">
              Writing {data.taskType === "task1" ? "Task 1" : "Task 2"}
            </span>
          </div>
          {data.title && (
            <h2 className="text-xl font-bold text-foreground">{data.title}</h2>
          )}
          {data.taskType === "task1" && (
            <div className="border-2 border-dashed border-border rounded-xl p-8 flex flex-col items-center gap-2 bg-muted/30">
              <ImageIcon className="h-6 w-6 text-muted-foreground" />
              <p className="text-xs text-muted-foreground">Chart / Graph will appear here</p>
            </div>
          )}
          {data.prompt && (
            <div className="rounded-lg border border-border bg-background p-4">
              {data.prompt.split("\n").map((line, i) => (
                <p key={i} className="text-sm text-foreground/90 mb-1">{line || <br />}</p>
              ))}
            </div>
          )}
          <div className="flex items-center gap-4 text-xs text-muted-foreground">
            <span className="flex items-center gap-1"><FileText className="h-3 w-3" /> Min: {data.minWords} words</span>
            <span className="flex items-center gap-1"><Clock className="h-3 w-3" /> {data.suggestedTime}</span>
          </div>
        </div>
      </div>

      {/* Writing area */}
      <div className="w-full md:w-[420px] lg:w-[480px] overflow-y-auto bg-background p-5 shrink-0">
        <h3 className="text-sm font-bold text-foreground mb-3">Your Response</h3>
        <Textarea
          disabled
          placeholder="Students will write their response here..."
          className="min-h-[400px] text-sm font-serif"
        />
        <div className="flex justify-between items-center mt-3 text-xs text-muted-foreground">
          <span>Word count: 0 / {data.minWords}+</span>
          <Badge variant="outline" className="text-[10px]">Practice Mode</Badge>
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

  const moduleIcon = activeModule === "reading" ? BookOpen : activeModule === "listening" ? Headphones : PenTool;
  const ModuleIcon = moduleIcon;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-[95vw] w-full h-[90vh] p-0 gap-0 flex flex-col overflow-hidden">
        {/* Toolbar */}
        <div className="flex items-center justify-between px-4 py-2.5 border-b border-border bg-muted/50 shrink-0">
          <div className="flex items-center gap-3">
            <DialogTitle className="text-sm font-semibold flex items-center gap-2">
              <ModuleIcon className="h-4 w-4 text-primary" />
              Student Preview — <span className="capitalize">{activeModule}</span>
            </DialogTitle>
            <Badge variant="outline" className="text-[10px]">Read-only</Badge>
          </div>

          {/* Device Toggle */}
          <div className="flex items-center gap-1 bg-background rounded-lg p-0.5 border border-border">
            {([
              { type: "desktop" as DeviceType, icon: Monitor, label: "Desktop" },
              { type: "tablet" as DeviceType, icon: Tablet, label: "Tablet" },
              { type: "mobile" as DeviceType, icon: Smartphone, label: "Mobile" },
            ]).map(({ type, icon: Icon, label }) => (
              <button
                key={type}
                onClick={() => setDevice(type)}
                title={label}
                className={cn(
                  "p-1.5 rounded-md transition-all",
                  device === type
                    ? "bg-primary text-primary-foreground shadow-sm"
                    : "text-muted-foreground hover:text-foreground"
                )}
              >
                <Icon className="h-4 w-4" />
              </button>
            ))}
          </div>

          <Button variant="ghost" size="icon" className="h-7 w-7" onClick={() => onOpenChange(false)}>
            <X className="h-4 w-4" />
          </Button>
        </div>

        {/* Preview Content */}
        <div className="flex-1 overflow-hidden bg-muted/30 flex justify-center p-4">
          <motion.div
            layout
            transition={{ duration: 0.3, ease: "easeInOut" }}
            className={cn(
              "bg-background rounded-xl border border-border shadow-xl overflow-hidden h-full",
              deviceWidths[device],
              device !== "desktop" && "mx-auto"
            )}
          >
            <ScrollArea className="h-full">
              <AnimatePresence mode="wait">
                <motion.div
                  key={activeModule}
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  exit={{ opacity: 0 }}
                  transition={{ duration: 0.15 }}
                >
                  {activeModule === "reading" && <ReadingPreviewContent data={reading} />}
                  {activeModule === "listening" && <ListeningPreviewContent data={listening} />}
                  {activeModule === "writing" && <WritingPreviewContent data={writing} />}
                </motion.div>
              </AnimatePresence>
            </ScrollArea>
          </motion.div>
        </div>
      </DialogContent>
    </Dialog>
  );
};
