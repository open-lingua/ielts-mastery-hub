import React, { useState, useEffect } from "react";
import { useSearchParams, useNavigate } from "react-router-dom";
import { motion, AnimatePresence } from "framer-motion";
import {
  BookOpen,
  PenTool,
  Headphones,
  Plus,
  Trash2,
  Save,
  Eye,
  Send,
  Upload,
  Clock,
  GripVertical,
  Image as ImageIcon,
  ChevronDown,
  ChevronUp,
  ListChecks,
  CheckSquare,
  ArrowRightLeft,
  AlignLeft,
  FileText,
  MessageSquare,
  Table2,
  GitBranch,
  MapPin,
  Type,
  Loader2,
} from "lucide-react";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Switch } from "@/components/ui/switch";
import { Separator } from "@/components/ui/separator";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Collapsible,
  CollapsibleContent,
  CollapsibleTrigger,
} from "@/components/ui/collapsible";
import { AdminLayout } from "@/components/AdminLayout";
import { TestPreviewModal } from "@/components/admin/TestPreviewModal";
import { cn } from "@/lib/utils";
import { useAuth } from "@/contexts/AuthContext";
import { saveReadingTest, updateReadingTest, fetchReadingTest } from "@/services/readingTestService";
import { saveWritingTest, updateWritingTest, fetchWritingTest } from "@/services/writingService";
import { saveListeningTest, updateListeningTest, fetchListeningTest } from "@/services/listeningService";
import { toast } from "@/hooks/use-toast";

// ─── Types ────────────────────────────────────
const QUESTION_TYPES = [
  // Identification
  { value: "multiple-choice", label: "Multiple Choice", category: "choice", color: "bg-blue-500" },
  { value: "tfng", label: "True / False / Not Given", category: "identification", color: "bg-sky-500" },
  { value: "ynng", label: "Yes / No / Not Given", category: "identification", color: "bg-cyan-500" },
  // Matching
  { value: "matching-headings", label: "Matching Headings", category: "matching", color: "bg-violet-500" },
  { value: "matching-information", label: "Matching Information", category: "matching", color: "bg-purple-500" },
  { value: "matching-features", label: "Matching Features", category: "matching", color: "bg-fuchsia-500" },
  { value: "matching-sentence-endings", label: "Matching Sentence Endings", category: "matching", color: "bg-pink-500" },
  // Completion
  { value: "sentence-completion", label: "Sentence Completion", category: "completion", color: "bg-emerald-500" },
  { value: "summary-completion", label: "Summary Completion", category: "completion", color: "bg-green-500" },
  { value: "note-completion", label: "Note Completion", category: "completion", color: "bg-teal-500" },
  { value: "table-completion", label: "Table Completion", category: "completion", color: "bg-lime-500" },
  { value: "flow-chart-completion", label: "Flow-chart Completion", category: "completion", color: "bg-emerald-600" },
  // Other
  { value: "diagram-labeling", label: "Diagram Labeling", category: "completion", color: "bg-amber-500" },
  { value: "short-answer", label: "Short Answer Questions", category: "other", color: "bg-orange-500" },
] as const;

type QuestionType = (typeof QUESTION_TYPES)[number]["value"];

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
  type: QuestionType;
  instructions: string;
  wordLimit: string;
  hasWordBank: boolean;
  wordBank: string[];
  sequentialOrder: boolean;
  multipleSelection: boolean;
  selectCount: number;
  questions: QuestionItem[];
}

// ─── Helpers ──────────────────────────────────
let idCounter = 0;
const uid = () => `q-${++idCounter}-${Date.now()}`;

const emptyOption = (idx: number): MCOption => ({ id: uid(), text: "", isCorrect: idx === 0 });
const emptyPair = (): MatchingPair => ({ id: uid(), left: "", right: "" });
const emptyGap = (): CompletionGap => ({ id: uid(), gapText: "", answer: "" });
const emptyAccepted = (): AcceptedAnswer => ({ id: uid(), text: "" });

const emptyQuestion = (): QuestionItem => ({
  id: uid(),
  text: "",
  answer: "",
  options: [emptyOption(0), emptyOption(1), emptyOption(2), emptyOption(3)],
  matchingPairs: [],
  completionGaps: [],
  acceptedAnswers: [],
});

const emptyGroup = (type: QuestionType = "multiple-choice"): QuestionGroup => ({
  id: uid(),
  type,
  instructions: "",
  wordLimit: "",
  hasWordBank: false,
  wordBank: [],
  sequentialOrder: true,
  multipleSelection: false,
  selectCount: 1,
  questions: [emptyQuestion()],
});

const getTypeMeta = (type: QuestionType) =>
  QUESTION_TYPES.find((t) => t.value === type) || QUESTION_TYPES[0];

const getCategoryBadge = (category: string) => {
  switch (category) {
    case "choice": return "bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400";
    case "identification": return "bg-sky-100 text-sky-700 dark:bg-sky-900/30 dark:text-sky-400";
    case "matching": return "bg-violet-100 text-violet-700 dark:bg-violet-900/30 dark:text-violet-400";
    case "completion": return "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400";
    default: return "bg-orange-100 text-orange-700 dark:bg-orange-900/30 dark:text-orange-400";
  }
};

// ─── Sub-Components for Each Type ─────────────

// Multiple Choice
const MCQuestionEditor: React.FC<{
  q: QuestionItem;
  group: QuestionGroup;
  onChange: (patch: Partial<QuestionItem>) => void;
}> = ({ q, group, onChange }) => {
  const updateOpt = (idx: number, patch: Partial<MCOption>) => {
    const next = [...q.options];
    next[idx] = { ...next[idx], ...patch };
    onChange({ options: next });
  };
  const toggleCorrect = (idx: number) => {
    const next = q.options.map((o, i) => ({
      ...o,
      isCorrect: group.multipleSelection ? (i === idx ? !o.isCorrect : o.isCorrect) : i === idx,
    }));
    onChange({ options: next });
  };
  const addOpt = () => onChange({ options: [...q.options, { id: uid(), text: "", isCorrect: false }] });
  const removeOpt = (idx: number) => onChange({ options: q.options.filter((_, i) => i !== idx) });

  return (
    <div className="space-y-2">
      {q.options.map((opt, oIdx) => (
        <div key={opt.id} className="flex items-center gap-2">
          <button
            type="button"
            onClick={() => toggleCorrect(oIdx)}
            className={cn(
              "h-5 w-5 rounded-full border-2 flex items-center justify-center shrink-0 transition-colors",
              opt.isCorrect
                ? "border-emerald-500 bg-emerald-500 text-white"
                : "border-muted-foreground/30 hover:border-muted-foreground/60"
            )}
          >
            {opt.isCorrect && <CheckSquare className="h-3 w-3" />}
          </button>
          <span className="text-xs text-muted-foreground w-4 shrink-0">{String.fromCharCode(65 + oIdx)}.</span>
          <Input
            placeholder={`Option ${String.fromCharCode(65 + oIdx)}`}
            value={opt.text}
            onChange={(e) => updateOpt(oIdx, { text: e.target.value })}
            className="text-sm h-8 flex-1"
          />
          {q.options.length > 2 && (
            <Button variant="ghost" size="icon" className="h-6 w-6 text-destructive shrink-0" onClick={() => removeOpt(oIdx)}>
              <Trash2 className="h-3 w-3" />
            </Button>
          )}
        </div>
      ))}
      <Button variant="ghost" size="sm" className="gap-1 text-xs h-7" onClick={addOpt}>
        <Plus className="h-3 w-3" /> Add Option
      </Button>
    </div>
  );
};

// TFNG / YNNG
const IdentificationEditor: React.FC<{
  q: QuestionItem;
  type: "tfng" | "ynng";
  onChange: (patch: Partial<QuestionItem>) => void;
}> = ({ q, type, onChange }) => {
  const options = type === "tfng" ? ["TRUE", "FALSE", "NOT GIVEN"] : ["YES", "NO", "NOT GIVEN"];
  return (
    <div className="flex items-center gap-2">
      <Label className="text-xs text-muted-foreground shrink-0">Answer:</Label>
      <Select value={q.answer} onValueChange={(v) => onChange({ answer: v })}>
        <SelectTrigger className="w-40 h-8 text-xs">
          <SelectValue placeholder="Select..." />
        </SelectTrigger>
        <SelectContent>
          {options.map((o) => (
            <SelectItem key={o} value={o}>{o}</SelectItem>
          ))}
        </SelectContent>
      </Select>
    </div>
  );
};

// Matching (Headings, Information, Features, Sentence Endings)
const MatchingEditor: React.FC<{
  q: QuestionItem;
  type: QuestionType;
  onChange: (patch: Partial<QuestionItem>) => void;
}> = ({ q, type, onChange }) => {
  const pairs = q.matchingPairs.length ? q.matchingPairs : [emptyPair()];

  const updatePair = (idx: number, patch: Partial<MatchingPair>) => {
    const next = [...pairs];
    next[idx] = { ...next[idx], ...patch };
    onChange({ matchingPairs: next });
  };
  const addPair = () => onChange({ matchingPairs: [...pairs, emptyPair()] });
  const removePair = (idx: number) => onChange({ matchingPairs: pairs.filter((_, i) => i !== idx) });

  const leftLabel =
    type === "matching-headings" ? "Paragraph" :
    type === "matching-information" ? "Detail" :
    type === "matching-features" ? "Name / Entity" :
    "Sentence Stem";

  const rightLabel =
    type === "matching-headings" ? "Heading (e.g. iv)" :
    type === "matching-information" ? "Paragraph (A, B...)" :
    type === "matching-features" ? "Statement" :
    "Ending Option";

  return (
    <div className="space-y-2">
      <div className="grid grid-cols-[1fr_auto_1fr_auto] gap-2 items-center">
        <span className="text-[10px] font-medium text-muted-foreground uppercase tracking-wider">{leftLabel}</span>
        <span />
        <span className="text-[10px] font-medium text-muted-foreground uppercase tracking-wider">{rightLabel}</span>
        <span />
      </div>
      {pairs.map((pair, idx) => (
        <div key={pair.id} className="grid grid-cols-[1fr_auto_1fr_auto] gap-2 items-center">
          <Input
            placeholder={leftLabel}
            value={pair.left}
            onChange={(e) => updatePair(idx, { left: e.target.value })}
            className="text-sm h-8"
          />
          <ArrowRightLeft className="h-3 w-3 text-muted-foreground shrink-0" />
          <Input
            placeholder={rightLabel}
            value={pair.right}
            onChange={(e) => updatePair(idx, { right: e.target.value })}
            className="text-sm h-8"
          />
          {pairs.length > 1 && (
            <Button variant="ghost" size="icon" className="h-6 w-6 text-destructive shrink-0" onClick={() => removePair(idx)}>
              <Trash2 className="h-3 w-3" />
            </Button>
          )}
        </div>
      ))}
      <Button variant="ghost" size="sm" className="gap-1 text-xs h-7" onClick={addPair}>
        <Plus className="h-3 w-3" /> Add Pair
      </Button>
    </div>
  );
};

// Completion types (Sentence, Summary, Note, Table, Flow-chart)
const CompletionEditor: React.FC<{
  q: QuestionItem;
  type: QuestionType;
  onChange: (patch: Partial<QuestionItem>) => void;
}> = ({ q, onChange }) => {
  const gaps = q.completionGaps.length ? q.completionGaps : [emptyGap()];

  const updateGap = (idx: number, patch: Partial<CompletionGap>) => {
    const next = [...gaps];
    next[idx] = { ...next[idx], ...patch };
    onChange({ completionGaps: next });
  };
  const addGap = () => onChange({ completionGaps: [...gaps, emptyGap()] });
  const removeGap = (idx: number) => onChange({ completionGaps: gaps.filter((_, i) => i !== idx) });

  return (
    <div className="space-y-2">
      <p className="text-[10px] text-muted-foreground">Use <code className="bg-muted px-1 rounded text-[10px]">{`{{gap}}`}</code> in the text to mark blanks.</p>
      {gaps.map((gap, idx) => (
        <div key={gap.id} className="flex items-start gap-2">
          <span className="text-xs text-muted-foreground mt-2 w-4 shrink-0">{idx + 1}.</span>
          <div className="flex-1 space-y-1">
            <Input
              placeholder="Sentence with {{gap}} marker..."
              value={gap.gapText}
              onChange={(e) => updateGap(idx, { gapText: e.target.value })}
              className="text-sm h-8"
            />
            <Input
              placeholder="Correct answer"
              value={gap.answer}
              onChange={(e) => updateGap(idx, { answer: e.target.value })}
              className="text-sm h-7 text-xs bg-emerald-50/50 dark:bg-emerald-950/20 border-emerald-200 dark:border-emerald-900/50"
            />
          </div>
          {gaps.length > 1 && (
            <Button variant="ghost" size="icon" className="h-6 w-6 text-destructive shrink-0 mt-1" onClick={() => removeGap(idx)}>
              <Trash2 className="h-3 w-3" />
            </Button>
          )}
        </div>
      ))}
      <Button variant="ghost" size="sm" className="gap-1 text-xs h-7" onClick={addGap}>
        <Plus className="h-3 w-3" /> Add Gap
      </Button>
    </div>
  );
};

// Diagram Labeling
const DiagramLabelingEditor: React.FC<{
  q: QuestionItem;
  onChange: (patch: Partial<QuestionItem>) => void;
}> = ({ q, onChange }) => {
  const gaps = q.completionGaps.length ? q.completionGaps : [emptyGap()];

  const updateGap = (idx: number, patch: Partial<CompletionGap>) => {
    const next = [...gaps];
    next[idx] = { ...next[idx], ...patch };
    onChange({ completionGaps: next });
  };
  const addGap = () => onChange({ completionGaps: [...gaps, emptyGap()] });
  const removeGap = (idx: number) => onChange({ completionGaps: gaps.filter((_, i) => i !== idx) });

  return (
    <div className="space-y-3">
      <div className="border-2 border-dashed border-border rounded-xl p-6 flex flex-col items-center gap-2 bg-muted/30">
        <ImageIcon className="h-6 w-6 text-muted-foreground" />
        <p className="text-xs text-muted-foreground">Upload diagram image</p>
      </div>
      <div className="space-y-2">
        <span className="text-[10px] font-medium text-muted-foreground uppercase tracking-wider">Labels</span>
        {gaps.map((gap, idx) => (
          <div key={gap.id} className="flex items-center gap-2">
            <Badge variant="outline" className="text-[10px] shrink-0 w-8 justify-center">{idx + 1}</Badge>
            <Input
              placeholder="Label position / part name"
              value={gap.gapText}
              onChange={(e) => updateGap(idx, { gapText: e.target.value })}
              className="text-sm h-8 flex-1"
            />
            <Input
              placeholder="Answer"
              value={gap.answer}
              onChange={(e) => updateGap(idx, { answer: e.target.value })}
              className="text-sm h-8 w-32"
            />
            {gaps.length > 1 && (
              <Button variant="ghost" size="icon" className="h-6 w-6 text-destructive shrink-0" onClick={() => removeGap(idx)}>
                <Trash2 className="h-3 w-3" />
              </Button>
            )}
          </div>
        ))}
        <Button variant="ghost" size="sm" className="gap-1 text-xs h-7" onClick={addGap}>
          <Plus className="h-3 w-3" /> Add Label
        </Button>
      </div>
    </div>
  );
};

// Short Answer
const ShortAnswerEditor: React.FC<{
  q: QuestionItem;
  onChange: (patch: Partial<QuestionItem>) => void;
}> = ({ q, onChange }) => {
  const accepted = q.acceptedAnswers.length ? q.acceptedAnswers : [emptyAccepted()];

  const updateAccepted = (idx: number, text: string) => {
    const next = [...accepted];
    next[idx] = { ...next[idx], text };
    onChange({ acceptedAnswers: next });
  };
  const addAccepted = () => onChange({ acceptedAnswers: [...accepted, emptyAccepted()] });
  const removeAccepted = (idx: number) => onChange({ acceptedAnswers: accepted.filter((_, i) => i !== idx) });

  return (
    <div className="space-y-2">
      <Label className="text-xs text-muted-foreground">Accepted Answers (variations)</Label>
      {accepted.map((a, idx) => (
        <div key={a.id} className="flex items-center gap-2">
          <Input
            placeholder={idx === 0 ? "Primary answer" : "Alternative (e.g. plural)"}
            value={a.text}
            onChange={(e) => updateAccepted(idx, e.target.value)}
            className="text-sm h-8 flex-1"
          />
          {accepted.length > 1 && (
            <Button variant="ghost" size="icon" className="h-6 w-6 text-destructive shrink-0" onClick={() => removeAccepted(idx)}>
              <Trash2 className="h-3 w-3" />
            </Button>
          )}
        </div>
      ))}
      <Button variant="ghost" size="sm" className="gap-1 text-xs h-7" onClick={addAccepted}>
        <Plus className="h-3 w-3" /> Add Variant
      </Button>
    </div>
  );
};

// ─── Question Builder ─────────────────────────
const QuestionBuilder: React.FC<{
  groups: QuestionGroup[];
  onChange: (groups: QuestionGroup[]) => void;
  showTimestamp?: boolean;
}> = ({ groups, onChange, showTimestamp }) => {
  const updateGroup = (gIdx: number, patch: Partial<QuestionGroup>) => {
    const next = [...groups];
    next[gIdx] = { ...next[gIdx], ...patch };
    onChange(next);
  };

  const updateQuestion = (gIdx: number, qIdx: number, patch: Partial<QuestionItem>) => {
    const next = [...groups];
    next[gIdx].questions[qIdx] = { ...next[gIdx].questions[qIdx], ...patch };
    onChange(next);
  };

  const addQuestion = (gIdx: number) => {
    const next = [...groups];
    next[gIdx].questions.push(emptyQuestion());
    onChange(next);
  };

  const removeQuestion = (gIdx: number, qIdx: number) => {
    const next = [...groups];
    next[gIdx].questions.splice(qIdx, 1);
    onChange(next);
  };

  const removeGroup = (gIdx: number) => {
    onChange(groups.filter((_, i) => i !== gIdx));
  };

  const changeGroupType = (gIdx: number, type: QuestionType) => {
    const next = [...groups];
    next[gIdx] = { ...next[gIdx], type, questions: [emptyQuestion()] };
    onChange(next);
  };

  const isMatching = (t: QuestionType) => t.startsWith("matching");
  const isCompletion = (t: QuestionType) =>
    ["sentence-completion", "summary-completion", "note-completion", "table-completion", "flow-chart-completion"].includes(t);
  const isIdentification = (t: QuestionType) => t === "tfng" || t === "ynng";

  const renderQuestionEditor = (group: QuestionGroup, q: QuestionItem, gIdx: number, qIdx: number) => {
    const update = (patch: Partial<QuestionItem>) => updateQuestion(gIdx, qIdx, patch);
    const type = group.type;

    if (type === "multiple-choice") return <MCQuestionEditor q={q} group={group} onChange={update} />;
    if (isIdentification(type)) return <IdentificationEditor q={q} type={type as "tfng" | "ynng"} onChange={update} />;
    if (isMatching(type)) return <MatchingEditor q={q} type={type} onChange={update} />;
    if (isCompletion(type)) return <CompletionEditor q={q} type={type} onChange={update} />;
    if (type === "diagram-labeling") return <DiagramLabelingEditor q={q} onChange={update} />;
    if (type === "short-answer") return <ShortAnswerEditor q={q} onChange={update} />;
    return null;
  };

  // For matching/completion, we show a single editor per question (not text + editor)
  const needsQuestionText = (t: QuestionType) => !isMatching(t) && !isCompletion(t) && t !== "diagram-labeling";

  return (
    <div className="space-y-4">
      {groups.map((group, gIdx) => {
        const meta = getTypeMeta(group.type);
        return (
          <Card key={group.id} className="border-border overflow-hidden">
            {/* Group Header */}
            <CardHeader className="pb-3 flex flex-row items-center justify-between bg-muted/30">
              <div className="flex items-center gap-3 flex-1 flex-wrap">
                <GripVertical className="h-4 w-4 text-muted-foreground cursor-grab shrink-0" />
                <div className={cn("h-3 w-3 rounded-full shrink-0", meta.color)} />
                <Select value={group.type} onValueChange={(v) => changeGroupType(gIdx, v as QuestionType)}>
                  <SelectTrigger className="w-56 h-8 text-xs">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem disabled value="__choice" className="text-[10px] font-semibold text-muted-foreground uppercase">── Choice ──</SelectItem>
                    <SelectItem value="multiple-choice">Multiple Choice</SelectItem>
                    <SelectItem disabled value="__id" className="text-[10px] font-semibold text-muted-foreground uppercase">── Identification ──</SelectItem>
                    <SelectItem value="tfng">True / False / Not Given</SelectItem>
                    <SelectItem value="ynng">Yes / No / Not Given</SelectItem>
                    <SelectItem disabled value="__match" className="text-[10px] font-semibold text-muted-foreground uppercase">── Matching ──</SelectItem>
                    <SelectItem value="matching-headings">Matching Headings</SelectItem>
                    <SelectItem value="matching-information">Matching Information</SelectItem>
                    <SelectItem value="matching-features">Matching Features</SelectItem>
                    <SelectItem value="matching-sentence-endings">Matching Sentence Endings</SelectItem>
                    <SelectItem disabled value="__comp" className="text-[10px] font-semibold text-muted-foreground uppercase">── Completion ──</SelectItem>
                    <SelectItem value="sentence-completion">Sentence Completion</SelectItem>
                    <SelectItem value="summary-completion">Summary Completion</SelectItem>
                    <SelectItem value="note-completion">Note Completion</SelectItem>
                    <SelectItem value="table-completion">Table Completion</SelectItem>
                    <SelectItem value="flow-chart-completion">Flow-chart Completion</SelectItem>
                    <SelectItem value="diagram-labeling">Diagram Labeling</SelectItem>
                    <SelectItem disabled value="__other" className="text-[10px] font-semibold text-muted-foreground uppercase">── Other ──</SelectItem>
                    <SelectItem value="short-answer">Short Answer Questions</SelectItem>
                  </SelectContent>
                </Select>
                <Badge className={cn("text-[10px] border-0", getCategoryBadge(meta.category))}>
                  {meta.category}
                </Badge>
                <Badge variant="secondary" className="text-[10px]">{group.questions.length} Qs</Badge>
              </div>
              <Button variant="ghost" size="icon" className="h-7 w-7 text-destructive shrink-0" onClick={() => removeGroup(gIdx)}>
                <Trash2 className="h-3.5 w-3.5" />
              </Button>
            </CardHeader>

            <CardContent className="space-y-4 pt-4">
              {/* Group-level settings */}
              <div className="space-y-3">
                <Input
                  placeholder="Instructions for this question group (e.g. 'Choose the correct heading for paragraphs A-D')..."
                  value={group.instructions}
                  onChange={(e) => updateGroup(gIdx, { instructions: e.target.value })}
                  className="text-sm h-9"
                />
                <div className="flex flex-wrap gap-3 items-center">
                  {/* MC multi-select toggle */}
                  {group.type === "multiple-choice" && (
                    <div className="flex items-center gap-2 bg-muted/50 rounded-lg px-3 py-1.5">
                      <Switch
                        id={`multi-${group.id}`}
                        checked={group.multipleSelection}
                        onCheckedChange={(v) => updateGroup(gIdx, { multipleSelection: v })}
                      />
                      <Label htmlFor={`multi-${group.id}`} className="text-xs cursor-pointer">Multiple Selection</Label>
                      {group.multipleSelection && (
                        <Input
                          type="number"
                          min={2}
                          value={group.selectCount}
                          onChange={(e) => updateGroup(gIdx, { selectCount: parseInt(e.target.value) || 2 })}
                          className="w-14 h-7 text-xs"
                          placeholder="2"
                        />
                      )}
                    </div>
                  )}
                  {/* Sequential order for identification */}
                  {isIdentification(group.type) && (
                    <div className="flex items-center gap-2 bg-muted/50 rounded-lg px-3 py-1.5">
                      <Switch
                        id={`seq-${group.id}`}
                        checked={group.sequentialOrder}
                        onCheckedChange={(v) => updateGroup(gIdx, { sequentialOrder: v })}
                      />
                      <Label htmlFor={`seq-${group.id}`} className="text-xs cursor-pointer">Sequential Order</Label>
                    </div>
                  )}
                  {/* Word limit for completion */}
                  {(isCompletion(group.type) || group.type === "short-answer" || group.type === "diagram-labeling") && (
                    <div className="flex items-center gap-2 bg-muted/50 rounded-lg px-3 py-1.5">
                      <Type className="h-3.5 w-3.5 text-muted-foreground" />
                      <Input
                        placeholder="e.g. NO MORE THAN TWO WORDS"
                        value={group.wordLimit}
                        onChange={(e) => updateGroup(gIdx, { wordLimit: e.target.value })}
                        className="w-56 h-7 text-xs"
                      />
                    </div>
                  )}
                  {/* Word bank for completion */}
                  {isCompletion(group.type) && (
                    <div className="flex items-center gap-2 bg-muted/50 rounded-lg px-3 py-1.5">
                      <Switch
                        id={`wb-${group.id}`}
                        checked={group.hasWordBank}
                        onCheckedChange={(v) => updateGroup(gIdx, { hasWordBank: v })}
                      />
                      <Label htmlFor={`wb-${group.id}`} className="text-xs cursor-pointer">Word Bank</Label>
                    </div>
                  )}
                </div>
                {/* Word bank input */}
                {group.hasWordBank && isCompletion(group.type) && (
                  <div className="space-y-1">
                    <Label className="text-xs text-muted-foreground">Word Bank (comma-separated)</Label>
                    <Input
                      placeholder="e.g. increase, decline, stable, fluctuate"
                      value={group.wordBank.join(", ")}
                      onChange={(e) => updateGroup(gIdx, { wordBank: e.target.value.split(",").map((w) => w.trim()) })}
                      className="text-sm h-8"
                    />
                  </div>
                )}
              </div>

              <Separator />

              {/* Timeline connector + questions */}
              <div className="relative ml-2 border-l-2 border-muted space-y-4 pl-6">
                {group.questions.map((q, qIdx) => (
                  <motion.div
                    key={q.id}
                    initial={{ opacity: 0, height: 0 }}
                    animate={{ opacity: 1, height: "auto" }}
                    exit={{ opacity: 0, height: 0 }}
                    className="relative"
                  >
                    {/* Timeline dot */}
                    <div className={cn(
                      "absolute -left-[calc(1.5rem+5px)] top-4 h-2.5 w-2.5 rounded-full border-2 border-background",
                      meta.color
                    )} />

                    <div className="rounded-lg border border-border p-4 space-y-3 bg-card">
                      <div className="flex items-start justify-between gap-2">
                        <span className="text-xs font-bold text-muted-foreground mt-1 shrink-0">Q{qIdx + 1}</span>
                        <div className="flex-1 space-y-3">
                          {needsQuestionText(group.type) && (
                            <Input
                              placeholder={
                                group.type === "short-answer"
                                  ? "Enter question..."
                                  : isIdentification(group.type)
                                  ? "Enter statement..."
                                  : "Enter question text..."
                              }
                              value={q.text}
                              onChange={(e) => updateQuestion(gIdx, qIdx, { text: e.target.value })}
                              className="text-sm"
                            />
                          )}
                          {showTimestamp && (
                            <div className="flex items-center gap-2">
                              <Clock className="h-3.5 w-3.5 text-muted-foreground" />
                              <Input
                                placeholder="e.g. 02:15"
                                value={q.timestamp || ""}
                                onChange={(e) => updateQuestion(gIdx, qIdx, { timestamp: e.target.value })}
                                className="w-28 h-7 text-xs"
                              />
                            </div>
                          )}
                          {renderQuestionEditor(group, q, gIdx, qIdx)}
                        </div>
                        <Button variant="ghost" size="icon" className="h-7 w-7 text-destructive shrink-0" onClick={() => removeQuestion(gIdx, qIdx)}>
                          <Trash2 className="h-3.5 w-3.5" />
                        </Button>
                      </div>
                    </div>
                  </motion.div>
                ))}
              </div>

              <Button variant="outline" size="sm" className="gap-2 w-full" onClick={() => addQuestion(gIdx)}>
                <Plus className="h-3.5 w-3.5" /> Add Question
              </Button>
            </CardContent>
          </Card>
        );
      })}

      <Button
        variant="outline"
        className="gap-2 w-full border-dashed border-violet-300 dark:border-violet-800 text-violet-600 dark:text-violet-400 hover:bg-violet-50 dark:hover:bg-violet-900/20"
        onClick={() => onChange([...groups, emptyGroup()])}
      >
        <Plus className="h-4 w-4" /> Add Question Group
      </Button>
    </div>
  );
};

// ─── Reading Passage Types ────────────────────
interface ReadingPassageState {
  id: number;
  title: string;
  content: string;
  notes: string;
  questionGroups: QuestionGroup[];
}

const PASSAGE_LABELS = [
  { id: 1, label: "Passage 1", desc: "Short factual text" },
  { id: 2, label: "Passage 2", desc: "Descriptive / analytical text" },
  { id: 3, label: "Passage 3", desc: "Complex argumentative text" },
];

const emptyPassages = (): ReadingPassageState[] =>
  PASSAGE_LABELS.map((p) => ({
    id: p.id,
    title: "",
    content: "",
    notes: "",
    questionGroups: [emptyGroup()],
  }));

const ReadingPassageEditor: React.FC<{
  passage: ReadingPassageState;
  meta: (typeof PASSAGE_LABELS)[number];
  onChange: (patch: Partial<ReadingPassageState>) => void;
}> = ({ passage, meta, onChange }) => {
  const [notesOpen, setNotesOpen] = useState(false);
  const wordCount = passage.content.trim() ? passage.content.trim().split(/\s+/).length : 0;

  return (
    <div className="space-y-5">
      <div className="flex items-center gap-2">
        <Badge variant="secondary" className="text-[10px] uppercase tracking-wider">
          {meta.desc}
        </Badge>
        <Badge variant="outline" className="text-[10px]">
          {wordCount} words
        </Badge>
        <Badge variant="outline" className="text-[10px]">
          {passage.questionGroups.reduce((a, g) => a + g.questions.length, 0)} questions
        </Badge>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Left - Passage content */}
        <div className="space-y-4">
          <div className="space-y-2">
            <Label>Passage Title</Label>
            <Input
              placeholder={`e.g. ${meta.id === 1 ? "The Rise of Renewable Energy" : meta.id === 2 ? "Ancient Civilizations of the Andes" : "The Psychology of Workplace Motivation"}`}
              value={passage.title}
              onChange={(e) => onChange({ title: e.target.value })}
            />
          </div>
          <div className="space-y-2">
            <Label>Passage Content</Label>
            <Textarea
              placeholder="Paste the full reading passage here..."
              className="min-h-[300px] font-serif text-sm leading-relaxed"
              value={passage.content}
              onChange={(e) => onChange({ content: e.target.value })}
            />
          </div>
          <Collapsible open={notesOpen} onOpenChange={setNotesOpen}>
            <CollapsibleTrigger asChild>
              <Button variant="ghost" size="sm" className="gap-2 text-xs text-muted-foreground w-full justify-start">
                {notesOpen ? <ChevronUp className="h-3 w-3" /> : <ChevronDown className="h-3 w-3" />}
                <MessageSquare className="h-3 w-3" />
                Instructor Notes
              </Button>
            </CollapsibleTrigger>
            <CollapsibleContent>
              <Textarea
                placeholder="Private notes, keywords, or pedagogical hints..."
                className="min-h-[80px] text-sm mt-2"
                value={passage.notes}
                onChange={(e) => onChange({ notes: e.target.value })}
              />
            </CollapsibleContent>
          </Collapsible>
        </div>

        {/* Right - Questions */}
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-sm font-semibold">Question Builder</h3>
            <Badge variant="secondary" className="text-[10px]">
              {passage.questionGroups.reduce((a, g) => a + g.questions.length, 0)} Qs
            </Badge>
          </div>
          <QuestionBuilder
            groups={passage.questionGroups}
            onChange={(g) => onChange({ questionGroups: g })}
          />
        </div>
      </div>
    </div>
  );
};

// ─── Reading Creator (3-Passage) ──────────────
const ReadingCreator: React.FC<{
  testTitle: string; onTestTitleChange: (v: string) => void;
  testType: string; onTestTypeChange: (v: string) => void;
  difficulty: string; onDifficultyChange: (v: string) => void;
  duration: string; onDurationChange: (v: string) => void;
  passages: ReadingPassageState[]; onPassagesChange: (p: ReadingPassageState[]) => void;
}> = ({ testTitle, onTestTitleChange, testType, onTestTypeChange, difficulty, onDifficultyChange, duration, onDurationChange, passages, onPassagesChange }) => {
  const [activePassage, setActivePassage] = useState(0);

  const updatePassage = (idx: number, patch: Partial<ReadingPassageState>) => {
    const next = [...passages];
    next[idx] = { ...next[idx], ...patch };
    onPassagesChange(next);
  };

  const duplicatePassage = (fromIdx: number, toIdx: number) => {
    const next = [...passages];
    next[toIdx] = {
      ...JSON.parse(JSON.stringify(next[fromIdx])),
      id: toIdx + 1,
      title: "",
      content: "",
    };
    onPassagesChange(next);
  };

  const clearPassageQuestions = (idx: number) => {
    const next = [...passages];
    next[idx] = { ...next[idx], questionGroups: [emptyGroup()] };
    onPassagesChange(next);
  };

  const getPassageStatus = (p: ReadingPassageState) => {
    const hasTitle = p.title.trim().length > 0;
    const hasContent = p.content.trim().length > 0;
    const hasQuestions = p.questionGroups.some((g) =>
      g.questions.some((q) => q.text.trim() || q.options.some((o) => o.text.trim()) || q.completionGaps.some((g) => g.answer.trim()) || q.matchingPairs.some((p) => p.left.trim()))
    );
    if (hasTitle && hasContent && hasQuestions) return "complete";
    if (hasTitle || hasContent || hasQuestions) return "partial";
    return "empty";
  };

  const totalQuestions = passages.reduce(
    (a, p) => a + p.questionGroups.reduce((b, g) => b + g.questions.length, 0),
    0
  );

  return (
    <div className="space-y-6">
      {/* Global metadata */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="space-y-2 md:col-span-2">
          <Label>Test Title</Label>
          <Input placeholder="e.g. Academic Reading Practice Test 14" value={testTitle} onChange={(e) => onTestTitleChange(e.target.value)} />
        </div>
        <div className="space-y-2">
          <Label>Test Type</Label>
          <Select value={testType} onValueChange={onTestTypeChange}>
            <SelectTrigger><SelectValue /></SelectTrigger>
            <SelectContent>
              <SelectItem value="Academic">Academic</SelectItem>
              <SelectItem value="General">General Training</SelectItem>
            </SelectContent>
          </Select>
        </div>
        <div className="space-y-2">
          <Label>Difficulty</Label>
          <Select value={difficulty} onValueChange={onDifficultyChange}>
            <SelectTrigger><SelectValue /></SelectTrigger>
            <SelectContent>
              {["5", "5.5", "6", "6.5", "7", "7.5", "8", "8.5", "9"].map((b) => (
                <SelectItem key={b} value={b}>Band {b}</SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      </div>

      {/* Test summary card */}
      <Card className="border-border">
        <CardContent className="p-4 flex items-center justify-between flex-wrap gap-3">
          <div className="flex items-center gap-4">
            <div className="flex items-center gap-2 text-sm font-medium text-foreground">
              <BookOpen className="h-4 w-4 text-primary" />
              <span>{totalQuestions}/40 questions</span>
            </div>
            <div className="flex items-center gap-2 text-sm text-muted-foreground">
              <Clock className="h-3.5 w-3.5" />
              <Input
                placeholder="60 mins"
                value={duration}
                onChange={(e) => onDurationChange(e.target.value)}
                className="w-24 h-7 text-xs"
              />
            </div>
          </div>
          <div className="flex items-center gap-2">
            {passages.map((p, idx) => {
              const status = getPassageStatus(p);
              const qCount = p.questionGroups.reduce((a, g) => a + g.questions.length, 0);
              return (
                <Badge key={idx} variant="outline" className="text-[10px] gap-1">
                  <span className={cn(
                    "h-1.5 w-1.5 rounded-full inline-block",
                    status === "complete" ? "bg-emerald-500" : status === "partial" ? "bg-amber-500" : "bg-border"
                  )} />
                  P{idx + 1}: {qCount}Qs
                </Badge>
              );
            })}
          </div>
        </CardContent>
      </Card>

      {/* Passage Tabs */}
      <div className="space-y-4">
        <div className="flex items-center gap-1 rounded-lg bg-muted p-1 overflow-x-auto">
          {PASSAGE_LABELS.map((meta, idx) => {
            const status = getPassageStatus(passages[idx]);
            return (
              <button
                key={meta.id}
                onClick={() => setActivePassage(idx)}
                className={cn(
                  "flex items-center gap-2 whitespace-nowrap rounded-md px-3 py-2 text-sm font-medium transition-all flex-1 justify-center min-w-0",
                  activePassage === idx
                    ? "bg-background text-foreground shadow-sm"
                    : "text-muted-foreground hover:bg-background/50 hover:text-foreground"
                )}
              >
                <span className={cn(
                  "h-2 w-2 rounded-full shrink-0",
                  status === "complete" ? "bg-emerald-500" : status === "partial" ? "bg-amber-500" : "bg-border"
                )} />
                <span className="truncate">{meta.label}</span>
              </button>
            );
          })}
        </div>

        {/* Bulk actions */}
        <div className="flex justify-end gap-2">
          {activePassage > 0 && (
            <Button
              variant="ghost"
              size="sm"
              className="text-xs gap-1.5 text-muted-foreground"
              onClick={() => duplicatePassage(activePassage - 1, activePassage)}
            >
              <ListChecks className="h-3.5 w-3.5" />
              Duplicate questions from P{activePassage}
            </Button>
          )}
          <Button
            variant="ghost"
            size="sm"
            className="text-xs gap-1.5 text-destructive"
            onClick={() => clearPassageQuestions(activePassage)}
          >
            <Trash2 className="h-3.5 w-3.5" />
            Clear Questions
          </Button>
        </div>

        {/* Active passage editor */}
        <AnimatePresence mode="wait">
          <motion.div
            key={activePassage}
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -20 }}
            transition={{ duration: 0.2 }}
          >
            <ReadingPassageEditor
              passage={passages[activePassage]}
              meta={PASSAGE_LABELS[activePassage]}
              onChange={(patch) => updatePassage(activePassage, patch)}
            />
          </motion.div>
        </AnimatePresence>
      </div>
    </div>
  );
};

// ─── Listening Section Types ──────────────────
interface ListeningSectionState {
  id: number;
  title: string;
  transcript: string;
  audioFileName: string;
  audioFile?: File | null;
  audioPreviewUrl?: string;
  questionGroups: QuestionGroup[];
}

const SECTION_LABELS = [
  { id: 1, label: "Section 1", desc: "Social / Conversation", placeholder: "e.g. Library Registration" },
  { id: 2, label: "Section 2", desc: "Social / Monologue", placeholder: "e.g. City Cycling Tour Guide" },
  { id: 3, label: "Section 3", desc: "Educational / Discussion", placeholder: "e.g. Research Project Discussion" },
  { id: 4, label: "Section 4", desc: "Academic / Lecture", placeholder: "e.g. Psychology of Decision-Making" },
];

const emptySections = (): ListeningSectionState[] =>
  SECTION_LABELS.map((s) => ({
    id: s.id,
    title: "",
    transcript: "",
    audioFileName: "",
    questionGroups: [emptyGroup()],
  }));

// Per-section editor
const ListeningSectionEditor: React.FC<{
  section: ListeningSectionState;
  meta: (typeof SECTION_LABELS)[number];
  onChange: (patch: Partial<ListeningSectionState>) => void;
}> = ({ section, meta, onChange }) => {
  const [transcriptOpen, setTranscriptOpen] = useState(false);
  const audioInputRef = React.useRef<HTMLInputElement>(null);

  const handleAudioSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      onChange({ audioFile: file, audioFileName: file.name, audioPreviewUrl: URL.createObjectURL(file) });
    }
  };

  const clearAudio = () => {
    onChange({ audioFile: null, audioFileName: "", audioPreviewUrl: "" });
    if (audioInputRef.current) audioInputRef.current.value = "";
  };

  return (
    <div className="space-y-5">
      {/* Context badge */}
      <div className="flex items-center gap-2">
        <Badge variant="secondary" className="text-[10px] uppercase tracking-wider">
          {meta.desc}
        </Badge>
        <Badge variant="outline" className="text-[10px]">
          {section.questionGroups.reduce((a, g) => a + g.questions.length, 0)} questions
        </Badge>
      </div>

      {/* Audio upload */}
      <Card>
        <CardContent className="p-5 space-y-3">
          <Label className="text-sm font-semibold">Audio Source</Label>
          <input
            ref={audioInputRef}
            type="file"
            accept="audio/mpeg,audio/wav,audio/mp3,audio/x-wav"
            className="hidden"
            onChange={handleAudioSelect}
          />
          {section.audioPreviewUrl ? (
            <div className="space-y-3">
              <div className="flex items-center gap-3 p-3 rounded-lg bg-muted/50 border border-border">
                <div className="h-9 w-9 rounded-full bg-violet-100 dark:bg-violet-900/30 flex items-center justify-center shrink-0">
                  <Headphones className="h-4 w-4 text-violet-600 dark:text-violet-400" />
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium truncate">{section.audioFileName}</p>
                  <audio src={section.audioPreviewUrl} controls className="w-full mt-1 h-8" />
                </div>
                <Button variant="ghost" size="icon" className="h-7 w-7 text-destructive shrink-0" onClick={clearAudio}>
                  <Trash2 className="h-3.5 w-3.5" />
                </Button>
              </div>
            </div>
          ) : (
            <div
              className="border-2 border-dashed border-border rounded-xl p-6 flex flex-col items-center justify-center gap-2 bg-muted/30 hover:bg-muted/50 transition-colors cursor-pointer"
              onClick={() => audioInputRef.current?.click()}
            >
              <Upload className="h-6 w-6 text-muted-foreground" />
              <p className="text-xs text-muted-foreground text-center">Drag & drop audio or click to browse</p>
              <p className="text-[10px] text-muted-foreground">MP3, WAV up to 50MB</p>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Section Title */}
      <div className="space-y-2">
        <Label>Section Title</Label>
        <Input
          placeholder={meta.placeholder}
          value={section.title}
          onChange={(e) => onChange({ title: e.target.value })}
        />
      </div>

      {/* Transcript */}
      <Collapsible open={transcriptOpen} onOpenChange={setTranscriptOpen}>
        <Card>
          <CollapsibleTrigger asChild>
            <CardHeader className="cursor-pointer flex flex-row items-center justify-between pb-3 hover:bg-muted/30 transition-colors">
              <CardTitle className="text-sm">Audio Transcript</CardTitle>
              {transcriptOpen ? <ChevronUp className="h-4 w-4" /> : <ChevronDown className="h-4 w-4" />}
            </CardHeader>
          </CollapsibleTrigger>
          <CollapsibleContent>
            <CardContent>
              <Textarea
                placeholder="Paste the audio transcript for this section..."
                className="min-h-[150px] text-sm"
                value={section.transcript}
                onChange={(e) => onChange({ transcript: e.target.value })}
              />
            </CardContent>
          </CollapsibleContent>
        </Card>
      </Collapsible>

      {/* Questions */}
      <div className="space-y-3">
        <h3 className="text-sm font-semibold">Time-Synced Questions</h3>
        <QuestionBuilder
          groups={section.questionGroups}
          onChange={(g) => onChange({ questionGroups: g })}
          showTimestamp
        />
      </div>
    </div>
  );
};

// ─── Listening Creator (4-Section Tabs) ───────
const ListeningCreator: React.FC<{
  testTitle: string; onTestTitleChange: (v: string) => void;
  difficulty: string; onDifficultyChange: (v: string) => void;
  duration: string; onDurationChange: (v: string) => void;
  sections: ListeningSectionState[]; onSectionsChange: (s: ListeningSectionState[]) => void;
}> = ({ testTitle, onTestTitleChange, difficulty, onDifficultyChange, duration, onDurationChange, sections, onSectionsChange }) => {
  const [activeSection, setActiveSection] = useState(0);

  const updateSection = (idx: number, patch: Partial<ListeningSectionState>) => {
    const next = [...sections];
    next[idx] = { ...next[idx], ...patch };
    onSectionsChange(next);
  };

  const duplicateSection = (fromIdx: number, toIdx: number) => {
    const next = [...sections];
    next[toIdx] = {
      ...JSON.parse(JSON.stringify(next[fromIdx])),
      id: toIdx + 1,
      title: "",
    };
    onSectionsChange(next);
  };

  const getSectionStatus = (s: ListeningSectionState) => {
    const hasTitle = s.title.trim().length > 0;
    const hasQuestions = s.questionGroups.some((g) => g.questions.some((q) => q.text.trim() || q.options.some((o) => o.text.trim()) || q.completionGaps.some((g) => g.answer.trim()) || q.matchingPairs.some((p) => p.left.trim())));
    if (hasTitle && hasQuestions) return "complete";
    if (hasTitle || hasQuestions) return "partial";
    return "empty";
  };

  return (
    <div className="space-y-6">
      {/* Global metadata */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div className="space-y-2">
          <Label>Test Title</Label>
          <Input placeholder="e.g. IELTS Listening Practice Test 1" value={testTitle} onChange={(e) => onTestTitleChange(e.target.value)} />
        </div>
        <div className="space-y-2">
          <Label>Difficulty</Label>
          <Select value={difficulty} onValueChange={onDifficultyChange}>
            <SelectTrigger><SelectValue /></SelectTrigger>
            <SelectContent>
              {["6", "6.5", "7", "7.5", "8", "8.5", "9"].map((b) => (
                <SelectItem key={b} value={b}>Band {b}</SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
        <div className="space-y-2">
          <Label>Total Duration</Label>
          <Input placeholder="e.g. 40 mins" value={duration} onChange={(e) => onDurationChange(e.target.value)} />
        </div>
      </div>

      {/* Section Tabs */}
      <div className="space-y-4">
        <div className="flex items-center gap-1 rounded-lg bg-muted p-1 overflow-x-auto">
          {SECTION_LABELS.map((meta, idx) => {
            const status = getSectionStatus(sections[idx]);
            return (
              <button
                key={meta.id}
                onClick={() => setActiveSection(idx)}
                className={cn(
                  "flex items-center gap-2 whitespace-nowrap rounded-md px-3 py-2 text-sm font-medium transition-all flex-1 justify-center min-w-0",
                  activeSection === idx
                    ? "bg-background text-foreground shadow-sm"
                    : "text-muted-foreground hover:bg-background/50 hover:text-foreground"
                )}
              >
                <span className={cn(
                  "h-2 w-2 rounded-full shrink-0",
                  status === "complete" ? "bg-emerald-500" : status === "partial" ? "bg-amber-500" : "bg-border"
                )} />
                <span className="truncate">{meta.label}</span>
              </button>
            );
          })}
        </div>

        {/* Duplicate hint */}
        {activeSection > 0 && (
          <div className="flex justify-end">
            <Button
              variant="ghost"
              size="sm"
              className="text-xs gap-1.5 text-muted-foreground"
              onClick={() => duplicateSection(activeSection - 1, activeSection)}
            >
              <ListChecks className="h-3.5 w-3.5" />
              Duplicate from Section {activeSection}
            </Button>
          </div>
        )}

        {/* Active section editor */}
        <AnimatePresence mode="wait">
          <motion.div
            key={activeSection}
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -20 }}
            transition={{ duration: 0.2 }}
          >
            <ListeningSectionEditor
              section={sections[activeSection]}
              meta={SECTION_LABELS[activeSection]}
              onChange={(patch) => updateSection(activeSection, patch)}
            />
          </motion.div>
        </AnimatePresence>
      </div>
    </div>
  );
};

// ─── Writing Task State ───────────────────────
interface WritingTaskState {
  taskType: "task1" | "task2";
  title: string;
  difficulty: string;
  suggestedTime: string;
  prompt: string;
  minWords: number;
  maxWords: string;
  imageFile: File | null;
  imagePreview: string;
  includeModelAnswer: boolean;
  modelAnswer: string;
}

const emptyWritingTask = (type: "task1" | "task2"): WritingTaskState => ({
  taskType: type,
  title: "",
  difficulty: "7",
  suggestedTime: type === "task1" ? "20 mins" : "40 mins",
  prompt: "",
  minWords: type === "task1" ? 150 : 250,
  maxWords: "",
  imageFile: null,
  imagePreview: "",
  includeModelAnswer: false,
  modelAnswer: "",
});

// ─── Writing Creator ──────────────────────────
const WritingCreator: React.FC<{
  tasks: [WritingTaskState, WritingTaskState];
  onTasksChange: (tasks: [WritingTaskState, WritingTaskState]) => void;
}> = ({ tasks, onTasksChange }) => {
  const [activeIndex, setActiveIndex] = useState(0);
  const task = tasks[activeIndex];
  const fileInputRef = React.useRef<HTMLInputElement>(null);

  const updateTask = (patch: Partial<WritingTaskState>) => {
    const next = [...tasks] as [WritingTaskState, WritingTaskState];
    next[activeIndex] = { ...next[activeIndex], ...patch };
    onTasksChange(next);
  };

  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      updateTask({ imageFile: file, imagePreview: URL.createObjectURL(file) });
    }
  };

  const clearImage = () => {
    updateTask({ imageFile: null, imagePreview: "" });
    if (fileInputRef.current) fileInputRef.current.value = "";
  };

  return (
    <div className="space-y-6">
      {/* Task Selector */}
      <div className="flex items-center gap-4">
        <Label className="text-sm font-semibold">Task Type</Label>
        <div className="inline-flex items-center rounded-lg bg-muted p-1">
          <button
            onClick={() => setActiveIndex(0)}
            className={cn(
              "px-4 py-1.5 rounded-md text-sm font-medium transition-all",
              activeIndex === 0 ? "bg-background text-foreground shadow-sm" : "text-muted-foreground"
            )}
          >
            Task 1 – Visual
          </button>
          <button
            onClick={() => setActiveIndex(1)}
            className={cn(
              "px-4 py-1.5 rounded-md text-sm font-medium transition-all",
              activeIndex === 1 ? "bg-background text-foreground shadow-sm" : "text-muted-foreground"
            )}
          >
            Task 2 – Essay
          </button>
        </div>
      </div>

      <AnimatePresence mode="wait">
        <motion.div
          key={activeIndex}
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          exit={{ opacity: 0, x: -20 }}
          transition={{ duration: 0.2 }}
        >
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Left */}
            <div className="space-y-4">
              <div className="space-y-2">
                <Label>Title</Label>
                <Input
                  placeholder={task.taskType === "task1" ? "e.g. Bar Chart – International Tourism" : "e.g. Essay on Technology in Education"}
                  value={task.title}
                  onChange={(e) => updateTask({ title: e.target.value })}
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label>Difficulty</Label>
                  <Select value={task.difficulty} onValueChange={(v) => updateTask({ difficulty: v })}>
                    <SelectTrigger><SelectValue /></SelectTrigger>
                    <SelectContent>
                      {["6", "6.5", "7", "7.5", "8", "8.5", "9"].map((b) => (
                        <SelectItem key={b} value={b}>Band {b}</SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label>Suggested Time</Label>
                  <Input placeholder="e.g. 20 mins" value={task.suggestedTime} onChange={(e) => updateTask({ suggestedTime: e.target.value })} />
                </div>
              </div>

              {/* Task 1 – Image Upload */}
              {task.taskType === "task1" && (
                <div className="space-y-2">
                  <Label>Chart / Graph Image</Label>
                  <input
                    ref={fileInputRef}
                    type="file"
                    accept="image/png,image/jpeg,image/svg+xml,image/webp"
                    className="hidden"
                    onChange={handleFileSelect}
                  />
                  {task.imagePreview ? (
                    <div className="relative rounded-xl border border-border overflow-hidden">
                      <img src={task.imagePreview} alt="Chart preview" className="w-full max-h-48 object-contain bg-muted/30" />
                      <Button
                        variant="destructive"
                        size="icon"
                        className="absolute top-2 right-2 h-7 w-7"
                        onClick={clearImage}
                      >
                        <Trash2 className="h-3.5 w-3.5" />
                      </Button>
                    </div>
                  ) : (
                    <div
                      className="border-2 border-dashed border-border rounded-xl p-8 flex flex-col items-center justify-center gap-3 bg-muted/30 hover:bg-muted/50 transition-colors cursor-pointer"
                      onClick={() => fileInputRef.current?.click()}
                    >
                      <ImageIcon className="h-8 w-8 text-muted-foreground" />
                      <p className="text-sm text-muted-foreground">Upload chart, graph, or diagram</p>
                      <p className="text-xs text-muted-foreground">PNG, JPG, SVG up to 10MB</p>
                    </div>
                  )}
                </div>
              )}
            </div>

            {/* Right */}
            <div className="space-y-4">
              <div className="space-y-2">
                <Label>Question Prompt</Label>
                <Textarea
                  placeholder={
                    task.taskType === "task1"
                      ? "Summarise the information by selecting and reporting the main features, and make comparisons where relevant..."
                      : "Write about the following topic:\n\nSome people believe that...\n\nDiscuss both views and give your own opinion."
                  }
                  className="min-h-[200px] text-sm"
                  value={task.prompt}
                  onChange={(e) => updateTask({ prompt: e.target.value })}
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label>Min. Words</Label>
                  <Input type="number" value={task.minWords} onChange={(e) => updateTask({ minWords: parseInt(e.target.value) || 0 })} />
                </div>
                <div className="space-y-2">
                  <Label>Max. Words (optional)</Label>
                  <Input type="number" placeholder="No limit" value={task.maxWords} onChange={(e) => updateTask({ maxWords: e.target.value })} />
                </div>
              </div>
              <div className="flex items-center gap-3 p-3 rounded-lg bg-muted/50">
                <Switch
                  id={`model-answer-${activeIndex}`}
                  checked={task.includeModelAnswer}
                  onCheckedChange={(v) => updateTask({ includeModelAnswer: v })}
                />
                <Label htmlFor={`model-answer-${activeIndex}`} className="text-sm cursor-pointer">Include Model Answer</Label>
              </div>
              {task.includeModelAnswer && (
                <div className="space-y-2">
                  <Label>Model Answer</Label>
                  <Textarea
                    placeholder="Enter the model answer..."
                    className="min-h-[120px] text-sm"
                    value={task.modelAnswer}
                    onChange={(e) => updateTask({ modelAnswer: e.target.value })}
                  />
                </div>
              )}
            </div>
          </div>
        </motion.div>
      </AnimatePresence>
    </div>
  );
};

// ─── Tab Content Wrapper (eager mount, CSS visibility) ──────
const TabPanel: React.FC<{ active: boolean; children: React.ReactNode }> = ({ active, children }) => (
  <div className={active ? "block mt-6" : "hidden"} aria-hidden={!active}>
    <AnimatePresence mode="wait">
      {active && (
        <motion.div
          key="panel"
          initial={{ opacity: 0, y: 8 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: -8 }}
          transition={{ duration: 0.2 }}
        >
          {children}
        </motion.div>
      )}
    </AnimatePresence>
  </div>
);

// ─── Main Page ────────────────────────────────
const VALID_TABS = ["reading", "listening", "writing"] as const;
type TabValue = (typeof VALID_TABS)[number];

const CreateContent: React.FC = () => {
  const [searchParams, setSearchParams] = useSearchParams();
  const navigate = useNavigate();
  const { user } = useAuth();
  const tabParam = searchParams.get("type") as TabValue | null;
  const editId = searchParams.get("id");
  const [activeTab, setActiveTab] = useState<TabValue>(
    tabParam && VALID_TABS.includes(tabParam) ? tabParam : "reading"
  );
  const [previewOpen, setPreviewOpen] = useState(false);
  const [isSaving, setIsSaving] = useState(false);
  const [isLoadingEdit, setIsLoadingEdit] = useState(false);

  // ── Lifted Reading State (3-passage) ──
  const [readingTestTitle, setReadingTestTitle] = useState("");
  const [readingTestType, setReadingTestType] = useState("Academic");
  const [readingDifficulty, setReadingDifficulty] = useState("7");
  const [readingDuration, setReadingDuration] = useState("60 mins");
  const [readingPassages, setReadingPassages] = useState<ReadingPassageState[]>(emptyPassages());

  // ── Lifted Listening State (4-section) ──
  const [listeningTestTitle, setListeningTestTitle] = useState("");
  const [listeningDifficulty, setListeningDifficulty] = useState("7");
  const [listeningDuration, setListeningDuration] = useState("40 mins");
  const [listeningSections, setListeningSections] = useState<ListeningSectionState[]>(emptySections());

  // ── Lifted Writing State (2 independent tasks) ──
  const [writingTasks, setWritingTasks] = useState<[WritingTaskState, WritingTaskState]>([
    emptyWritingTask("task1"),
    emptyWritingTask("task2"),
  ]);

  // ── Load existing test for edit mode ──
  useEffect(() => {
    if (!editId) return;

    if (activeTab === "reading") {
      setIsLoadingEdit(true);
      fetchReadingTest(editId)
        .then((data) => {
          setReadingTestTitle(data.title);
          setReadingTestType(data.testType);
          setReadingDifficulty(data.difficulty);
          setReadingDuration(data.duration);
          setReadingPassages(data.passages.map((p) => ({
            ...p,
            questionGroups: p.questionGroups.map((g) => ({
              ...g,
              type: g.type as QuestionType,
            })),
          })));
        })
        .catch((err) => {
          toast({ title: "Failed to load test", description: err?.message, variant: "destructive" });
        })
        .finally(() => setIsLoadingEdit(false));
    }

    if (activeTab === "writing") {
      setIsLoadingEdit(true);
      fetchWritingTest(editId)
        .then((data) => {
          const newTasks: [WritingTaskState, WritingTaskState] = [
            emptyWritingTask("task1"),
            emptyWritingTask("task2"),
          ];
          data.tasks.forEach((t, i) => {
            if (i < 2) {
              newTasks[i] = {
                taskType: t.taskType,
                title: t.title,
                difficulty: t.difficulty,
                suggestedTime: t.suggestedTime,
                prompt: t.prompt,
                minWords: t.minWords,
                maxWords: t.maxWords,
                imageFile: null,
                imagePreview: t.imageUrl || "",
                includeModelAnswer: t.includeModelAnswer || false,
                modelAnswer: t.modelAnswer || "",
              };
            }
          });
          setWritingTasks(newTasks);
        })
        .catch((err) => {
          toast({ title: "Failed to load test", description: err?.message, variant: "destructive" });
        })
        .finally(() => setIsLoadingEdit(false));
    }

    if (activeTab === "listening") {
      setIsLoadingEdit(true);
      fetchListeningTest(editId)
        .then((data) => {
          setListeningTestTitle(data.title);
          setListeningDifficulty(data.difficulty);
          setListeningDuration(data.duration);
          // Map sections into the 4-slot state
          const newSections = emptySections();
          data.sections.forEach((s) => {
            const idx = s.id - 1; // section id is 1-based
            if (idx >= 0 && idx < 4) {
              newSections[idx] = {
                id: s.id,
                title: s.title,
                transcript: s.transcript,
                audioFileName: s.audioUrl ? s.audioUrl.split("/").pop() || "Audio" : "",
                audioFile: null,
                audioPreviewUrl: s.audioUrl || "",
                questionGroups: s.questionGroups.length > 0
                  ? s.questionGroups.map((g) => ({
                      ...g,
                      type: g.type as QuestionType,
                      questions: g.questions.map((q) => ({
                        ...q,
                        options: (q.options || []) as unknown as MCOption[],
                        matchingPairs: (q.matchingPairs || []) as unknown as MatchingPair[],
                        completionGaps: (q.completionGaps || []) as unknown as CompletionGap[],
                        acceptedAnswers: (q.acceptedAnswers || []) as unknown as AcceptedAnswer[],
                      })),
                    }))
                  : [emptyGroup()],
              };
            }
          });
          setListeningSections(newSections);
        })
        .catch((err) => {
          toast({ title: "Failed to load test", description: err?.message, variant: "destructive" });
        })
        .finally(() => setIsLoadingEdit(false));
    }
  }, [editId, activeTab]);

  // Sync URL
  useEffect(() => {
    const params: Record<string, string> = { type: activeTab };
    if (editId) params.id = editId;
    setSearchParams(params, { replace: true });
  }, [activeTab, setSearchParams, editId]);

  const handleTabChange = (value: string) => {
    if (VALID_TABS.includes(value as TabValue)) {
      setActiveTab(value as TabValue);
    }
  };

  const handleSaveReadingTest = async (status: "draft" | "published") => {
    if (!user) {
      toast({ title: "Error", description: "You must be logged in to save a test.", variant: "destructive" });
      return;
    }
    setIsSaving(true);
    try {
      if (editId) {
        await updateReadingTest({
          testId: editId,
          title: readingTestTitle,
          testType: readingTestType,
          difficulty: readingDifficulty,
          duration: readingDuration,
          status,
          passages: readingPassages,
        });
      } else {
        await saveReadingTest({
          userId: user.id,
          title: readingTestTitle,
          testType: readingTestType,
          difficulty: readingDifficulty,
          duration: readingDuration,
          status,
          passages: readingPassages,
        });
      }
      toast({
        title: editId
          ? "Test Updated!"
          : status === "published" ? "Test Published!" : "Draft Saved!",
        description: `"${readingTestTitle || "Untitled Test"}" has been ${editId ? "updated" : status === "published" ? "published" : "saved as draft"} successfully.`,
      });
      if (status === "published" || editId) {
        navigate("/admin/content");
      }
    } catch (err: any) {
      toast({
        title: "Failed to save test",
        description: err?.message || "An unexpected error occurred.",
        variant: "destructive",
      });
    } finally {
      setIsSaving(false);
    }
  };

  const handleSaveWritingTest = async (status: "draft" | "published") => {
    if (!user) {
      toast({ title: "Error", description: "You must be logged in to save a test.", variant: "destructive" });
      return;
    }
    setIsSaving(true);
    const taskPayload: Parameters<typeof saveWritingTest>[0]["tasks"] = writingTasks
      .filter((t) => t.title.trim() || t.prompt.trim())
      .map((t) => ({
        taskType: t.taskType,
        title: t.title,
        difficulty: t.difficulty,
        suggestedTime: t.suggestedTime,
        prompt: t.prompt,
        minWords: t.minWords,
        maxWords: t.maxWords,
        imageFile: t.taskType === "task1" ? t.imageFile : null,
        imageUrl: t.taskType === "task1" ? t.imagePreview : undefined,
        includeModelAnswer: t.includeModelAnswer,
        modelAnswer: t.modelAnswer,
      }));
    const testTitle = writingTasks[0].title || writingTasks[1].title || "Writing Test";
    try {
      if (editId) {
        await updateWritingTest({
          testId: editId,
          title: testTitle,
          status,
          tasks: taskPayload,
        });
      } else {
        await saveWritingTest({
          userId: user.id,
          title: testTitle,
          status,
          tasks: taskPayload,
        });
      }
      toast({
        title: editId
          ? "Test Updated!"
          : status === "published" ? "Test Published!" : "Draft Saved!",
        description: `"${testTitle}" has been ${editId ? "updated" : status === "published" ? "published" : "saved"} successfully.`,
      });
      if (status === "published" || editId) {
        navigate("/admin/content");
      }
    } catch (err: any) {
      toast({
        title: "Failed to save writing test",
        description: err?.message || "An unexpected error occurred.",
        variant: "destructive",
      });
    } finally {
      setIsSaving(false);
    }
  };

  const handleSaveListeningTest = async (status: "draft" | "published") => {
    if (!user) {
      toast({ title: "Error", description: "You must be logged in to save a test.", variant: "destructive" });
      return;
    }
    setIsSaving(true);
    const sectionPayload = listeningSections.map((s) => ({
      id: s.id,
      title: s.title,
      transcript: s.transcript,
      audioFile: s.audioFile || null,
      audioUrl: s.audioPreviewUrl || "",
      questionGroups: s.questionGroups,
    }));
    try {
      if (editId) {
        await updateListeningTest({
          testId: editId,
          title: listeningTestTitle,
          difficulty: listeningDifficulty,
          duration: listeningDuration,
          status,
          sections: sectionPayload,
        });
      } else {
        await saveListeningTest({
          userId: user.id,
          title: listeningTestTitle,
          difficulty: listeningDifficulty,
          duration: listeningDuration,
          status,
          sections: sectionPayload,
        });
      }
      toast({
        title: editId
          ? "Test Updated!"
          : status === "published" ? "Test Published!" : "Draft Saved!",
        description: `"${listeningTestTitle || "Untitled"}" has been ${editId ? "updated" : status === "published" ? "published" : "saved"} successfully.`,
      });
      if (status === "published" || editId) {
        navigate("/admin/content");
      }
    } catch (err: any) {
      toast({
        title: "Failed to save listening test",
        description: err?.message || "An unexpected error occurred.",
        variant: "destructive",
      });
    } finally {
      setIsSaving(false);
    }
  };

  const handleSave = async (status: "draft" | "published") => {
    if (activeTab === "reading") {
      await handleSaveReadingTest(status);
    } else if (activeTab === "writing") {
      await handleSaveWritingTest(status);
    } else if (activeTab === "listening") {
      await handleSaveListeningTest(status);
    }
  };

  return (
    <AdminLayout>
      <div className="p-6 md:p-8 max-w-6xl mx-auto space-y-6">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <h1 className="text-2xl font-bold md:text-3xl">
              {editId ? "Edit Test" : "Test Creator Studio"}
            </h1>
            <p className="text-muted-foreground mt-1">
              {editId ? "Editing an existing test." : "Build IELTS practice tests for your students."}
            </p>
          </div>
        </div>

        {/* Tab Navigation */}
        <div className="inline-flex h-10 items-center justify-center rounded-lg bg-muted p-1 text-muted-foreground">
          {VALID_TABS.map((tab) => {
            const Icon = tab === "reading" ? BookOpen : tab === "listening" ? Headphones : PenTool;
            return (
              <button
                key={tab}
                onClick={() => handleTabChange(tab)}
                className={cn(
                  "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md px-4 py-1.5 text-sm font-medium transition-all capitalize",
                  activeTab === tab
                    ? "bg-background text-foreground shadow-sm"
                    : "hover:bg-background/50 hover:text-foreground"
                )}
              >
                <Icon className="h-4 w-4" />
                {tab}
              </button>
            );
          })}
        </div>

        {/* Eagerly mounted tab panels */}
        <TabPanel active={activeTab === "reading"}>
          {isLoadingEdit ? (
            <div className="flex items-center justify-center py-20 gap-3">
              <Loader2 className="h-6 w-6 animate-spin text-primary" />
              <span className="text-muted-foreground">Loading test data...</span>
            </div>
          ) : (
            <ReadingCreator
              testTitle={readingTestTitle} onTestTitleChange={setReadingTestTitle}
              testType={readingTestType} onTestTypeChange={setReadingTestType}
              difficulty={readingDifficulty} onDifficultyChange={setReadingDifficulty}
              duration={readingDuration} onDurationChange={setReadingDuration}
              passages={readingPassages} onPassagesChange={setReadingPassages}
            />
          )}
        </TabPanel>
        <TabPanel active={activeTab === "listening"}>
          {isLoadingEdit ? (
            <div className="flex items-center justify-center py-20 gap-3">
              <Loader2 className="h-6 w-6 animate-spin text-primary" />
              <span className="text-muted-foreground">Loading test data...</span>
            </div>
          ) : (
            <ListeningCreator
              testTitle={listeningTestTitle} onTestTitleChange={setListeningTestTitle}
              difficulty={listeningDifficulty} onDifficultyChange={setListeningDifficulty}
              duration={listeningDuration} onDurationChange={setListeningDuration}
              sections={listeningSections} onSectionsChange={setListeningSections}
            />
          )}
        </TabPanel>
        <TabPanel active={activeTab === "writing"}>
          {isLoadingEdit ? (
            <div className="flex items-center justify-center py-20 gap-3">
              <Loader2 className="h-6 w-6 animate-spin text-primary" />
              <span className="text-muted-foreground">Loading test data...</span>
            </div>
          ) : (
            <WritingCreator
              tasks={writingTasks}
              onTasksChange={setWritingTasks}
            />
          )}
        </TabPanel>

        {/* Floating Action Bar */}
        <div className="sticky bottom-0 bg-background/80 backdrop-blur-lg border-t border-border -mx-6 md:-mx-8 px-6 md:px-8 py-4">
          <div className="flex items-center justify-between max-w-6xl mx-auto">
            <p className="text-xs text-muted-foreground">Auto-saved as draft</p>
            <div className="flex items-center gap-3">
              <Button
                variant="outline"
                className="gap-2"
                disabled={isSaving}
                onClick={() => handleSave("draft")}
              >
                {isSaving ? <Loader2 className="h-4 w-4 animate-spin" /> : <Save className="h-4 w-4" />}
                {editId ? "Update Draft" : "Save Draft"}
              </Button>
              <Button variant="outline" className="gap-2" onClick={() => setPreviewOpen(true)}>
                <Eye className="h-4 w-4" /> Preview
              </Button>
              <Button
                className="gap-2 bg-violet-600 hover:bg-violet-700 text-white"
                disabled={isSaving}
                onClick={() => handleSave("published")}
              >
                {isSaving ? <Loader2 className="h-4 w-4 animate-spin" /> : <Send className="h-4 w-4" />}
                {editId ? "Update & Publish" : "Publish"}
              </Button>
            </div>
          </div>
        </div>
      </div>

      {/* Preview Modal */}
      <TestPreviewModal
        open={previewOpen}
        onOpenChange={setPreviewOpen}
        activeModule={activeTab}
        reading={{
          testTitle: readingTestTitle,
          testType: readingTestType,
          difficulty: readingDifficulty,
          duration: readingDuration,
          passages: readingPassages.map((p) => ({
            id: p.id,
            title: p.title,
            content: p.content,
            questionGroups: p.questionGroups,
          })),
        }}
        listening={{
          testTitle: listeningTestTitle,
          difficulty: listeningDifficulty,
          duration: listeningDuration,
          sections: listeningSections,
        }}
        writing={{
          taskType: writingTasks[0].taskType,
          title: writingTasks[0].title,
          difficulty: writingTasks[0].difficulty,
          suggestedTime: writingTasks[0].suggestedTime,
          prompt: writingTasks[0].prompt,
          minWords: writingTasks[0].minWords,
          maxWords: writingTasks[0].maxWords,
        }}
      />
    </AdminLayout>
  );
};

export default CreateContent;
