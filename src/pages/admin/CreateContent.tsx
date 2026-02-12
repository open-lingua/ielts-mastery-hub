import React, { useState } from "react";
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
import { cn } from "@/lib/utils";

// ─── Types ────────────────────────────────────
interface QuestionOption {
  id: string;
  text: string;
}

interface Question {
  id: string;
  text: string;
  type: "mc" | "tfng" | "matching";
  options: QuestionOption[];
  answer: string;
  timestamp?: string; // for listening
}

interface QuestionGroup {
  id: string;
  type: "Multiple Choice" | "True/False/Not Given" | "Matching Headings";
  questions: Question[];
}

// ─── Helpers ──────────────────────────────────
let idCounter = 0;
const uid = () => `q-${++idCounter}-${Date.now()}`;

const emptyOption = (): QuestionOption => ({ id: uid(), text: "" });
const emptyQuestion = (type: Question["type"] = "mc"): Question => ({
  id: uid(),
  text: "",
  type,
  options: type === "mc" ? [emptyOption(), emptyOption(), emptyOption(), emptyOption()] : [],
  answer: "",
});
const emptyGroup = (): QuestionGroup => ({
  id: uid(),
  type: "Multiple Choice",
  questions: [emptyQuestion("mc")],
});

const groupTypeToQuestionType = (gt: QuestionGroup["type"]): Question["type"] => {
  if (gt === "Multiple Choice") return "mc";
  if (gt === "True/False/Not Given") return "tfng";
  return "matching";
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

  const updateQuestion = (gIdx: number, qIdx: number, patch: Partial<Question>) => {
    const next = [...groups];
    next[gIdx].questions[qIdx] = { ...next[gIdx].questions[qIdx], ...patch };
    onChange(next);
  };

  const updateOption = (gIdx: number, qIdx: number, oIdx: number, text: string) => {
    const next = [...groups];
    next[gIdx].questions[qIdx].options[oIdx] = { ...next[gIdx].questions[qIdx].options[oIdx], text };
    onChange(next);
  };

  const addQuestion = (gIdx: number) => {
    const next = [...groups];
    next[gIdx].questions.push(emptyQuestion(groupTypeToQuestionType(next[gIdx].type)));
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

  const changeGroupType = (gIdx: number, type: QuestionGroup["type"]) => {
    const qt = groupTypeToQuestionType(type);
    const next = [...groups];
    next[gIdx] = {
      ...next[gIdx],
      type,
      questions: next[gIdx].questions.map((q) => ({
        ...q,
        type: qt,
        options: qt === "mc" ? (q.options.length ? q.options : [emptyOption(), emptyOption(), emptyOption(), emptyOption()]) : [],
      })),
    };
    onChange(next);
  };

  return (
    <div className="space-y-4">
      {groups.map((group, gIdx) => (
        <Card key={group.id} className="border-violet-200 dark:border-violet-900/50">
          <CardHeader className="pb-3 flex flex-row items-center justify-between">
            <div className="flex items-center gap-3 flex-1">
              <GripVertical className="h-4 w-4 text-muted-foreground cursor-grab" />
              <Select value={group.type} onValueChange={(v) => changeGroupType(gIdx, v as QuestionGroup["type"])}>
                <SelectTrigger className="w-52 h-8 text-xs">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="Multiple Choice">Multiple Choice</SelectItem>
                  <SelectItem value="True/False/Not Given">True/False/Not Given</SelectItem>
                  <SelectItem value="Matching Headings">Matching Headings</SelectItem>
                </SelectContent>
              </Select>
              <Badge variant="secondary" className="text-[10px]">{group.questions.length} Qs</Badge>
            </div>
            <Button variant="ghost" size="icon" className="h-7 w-7 text-destructive" onClick={() => removeGroup(gIdx)}>
              <Trash2 className="h-3.5 w-3.5" />
            </Button>
          </CardHeader>
          <CardContent className="space-y-4">
            {group.questions.map((q, qIdx) => (
              <motion.div
                key={q.id}
                initial={{ opacity: 0, height: 0 }}
                animate={{ opacity: 1, height: "auto" }}
                exit={{ opacity: 0, height: 0 }}
                className="rounded-lg border border-border p-4 space-y-3 bg-muted/30"
              >
                <div className="flex items-start justify-between gap-2">
                  <span className="text-xs font-semibold text-muted-foreground mt-2">Q{qIdx + 1}</span>
                  <div className="flex-1 space-y-2">
                    <Input
                      placeholder="Enter question text..."
                      value={q.text}
                      onChange={(e) => updateQuestion(gIdx, qIdx, { text: e.target.value })}
                      className="text-sm"
                    />
                    {showTimestamp && (
                      <div className="flex items-center gap-2">
                        <Clock className="h-3.5 w-3.5 text-muted-foreground" />
                        <Input
                          placeholder="e.g. 02:15"
                          value={q.timestamp || ""}
                          onChange={(e) => updateQuestion(gIdx, qIdx, { timestamp: e.target.value })}
                          className="w-28 h-8 text-xs"
                        />
                      </div>
                    )}
                  </div>
                  <Button variant="ghost" size="icon" className="h-7 w-7 text-destructive shrink-0" onClick={() => removeQuestion(gIdx, qIdx)}>
                    <Trash2 className="h-3.5 w-3.5" />
                  </Button>
                </div>

                {/* Options for MC */}
                {group.type === "Multiple Choice" && (
                  <div className="pl-6 space-y-2">
                    {q.options.map((opt, oIdx) => (
                      <div key={opt.id} className="flex items-center gap-2">
                        <span className="text-xs text-muted-foreground w-4">{String.fromCharCode(65 + oIdx)}.</span>
                        <Input
                          placeholder={`Option ${String.fromCharCode(65 + oIdx)}`}
                          value={opt.text}
                          onChange={(e) => updateOption(gIdx, qIdx, oIdx, e.target.value)}
                          className="text-sm h-8 flex-1"
                        />
                      </div>
                    ))}
                  </div>
                )}

                {/* Answer key */}
                <div className="pl-6">
                  <Label className="text-xs text-muted-foreground">Correct Answer</Label>
                  {group.type === "True/False/Not Given" ? (
                    <Select value={q.answer} onValueChange={(v) => updateQuestion(gIdx, qIdx, { answer: v })}>
                      <SelectTrigger className="w-40 h-8 text-xs mt-1">
                        <SelectValue placeholder="Select..." />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="True">True</SelectItem>
                        <SelectItem value="False">False</SelectItem>
                        <SelectItem value="Not Given">Not Given</SelectItem>
                      </SelectContent>
                    </Select>
                  ) : (
                    <Input
                      placeholder={group.type === "Multiple Choice" ? "e.g. A" : "Enter answer..."}
                      value={q.answer}
                      onChange={(e) => updateQuestion(gIdx, qIdx, { answer: e.target.value })}
                      className="w-40 h-8 text-xs mt-1"
                    />
                  )}
                </div>
              </motion.div>
            ))}
            <Button variant="outline" size="sm" className="gap-2 w-full" onClick={() => addQuestion(gIdx)}>
              <Plus className="h-3.5 w-3.5" /> Add Question
            </Button>
          </CardContent>
        </Card>
      ))}
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

// ─── Reading Creator ──────────────────────────
const ReadingCreator: React.FC = () => {
  const [groups, setGroups] = useState<QuestionGroup[]>([emptyGroup()]);

  return (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
      {/* Left - Content */}
      <div className="space-y-4">
        <div className="space-y-2">
          <Label>Test Title</Label>
          <Input placeholder="e.g. Academic Reading: The History of Glass" />
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div className="space-y-2">
            <Label>Difficulty (Band)</Label>
            <Select defaultValue="7">
              <SelectTrigger><SelectValue /></SelectTrigger>
              <SelectContent>
                {["6", "6.5", "7", "7.5", "8", "8.5", "9"].map((b) => (
                  <SelectItem key={b} value={b}>Band {b}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <Label>Duration</Label>
            <Input placeholder="e.g. 60 mins" defaultValue="60 mins" />
          </div>
        </div>
        <div className="space-y-2">
          <Label>Reading Passage</Label>
          <Textarea placeholder="Paste the full reading passage here..." className="min-h-[300px] font-serif text-sm leading-relaxed" />
        </div>
      </div>

      {/* Right - Questions */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h3 className="text-sm font-semibold">Question Builder</h3>
          <Badge variant="secondary" className="text-[10px]">
            {groups.reduce((a, g) => a + g.questions.length, 0)} questions total
          </Badge>
        </div>
        <QuestionBuilder groups={groups} onChange={setGroups} />
      </div>
    </div>
  );
};

// ─── Listening Creator ────────────────────────
const ListeningCreator: React.FC = () => {
  const [groups, setGroups] = useState<QuestionGroup[]>([emptyGroup()]);
  const [transcriptOpen, setTranscriptOpen] = useState(false);

  return (
    <div className="space-y-6">
      {/* Audio upload */}
      <Card>
        <CardContent className="p-6 space-y-4">
          <Label className="text-base font-semibold">Audio Source</Label>
          <div className="border-2 border-dashed border-border rounded-xl p-8 flex flex-col items-center justify-center gap-3 bg-muted/30 hover:bg-muted/50 transition-colors cursor-pointer">
            <Upload className="h-8 w-8 text-muted-foreground" />
            <p className="text-sm text-muted-foreground text-center">Drag & drop an audio file here, or click to browse</p>
            <p className="text-xs text-muted-foreground">MP3, WAV up to 50MB</p>
          </div>
          {/* Mock player */}
          <div className="flex items-center gap-3 p-3 rounded-lg bg-muted/50 border border-border">
            <div className="h-10 w-10 rounded-full bg-violet-100 dark:bg-violet-900/30 flex items-center justify-center">
              <Headphones className="h-5 w-5 text-violet-600 dark:text-violet-400" />
            </div>
            <div className="flex-1 space-y-1">
              <div className="h-2 bg-border rounded-full overflow-hidden">
                <div className="h-full w-1/3 bg-violet-500 rounded-full" />
              </div>
              <div className="flex justify-between text-[10px] text-muted-foreground">
                <span>01:23</span>
                <span>04:15</span>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

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
              <Textarea placeholder="Paste the full audio transcript here for accessibility..." className="min-h-[200px] text-sm" />
            </CardContent>
          </CollapsibleContent>
        </Card>
      </Collapsible>

      {/* Metadata */}
      <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
        <div className="space-y-2">
          <Label>Section Title</Label>
          <Input placeholder="e.g. Section 4: Marine Biology" />
        </div>
        <div className="space-y-2">
          <Label>Difficulty</Label>
          <Select defaultValue="7">
            <SelectTrigger><SelectValue /></SelectTrigger>
            <SelectContent>
              {["6", "6.5", "7", "7.5", "8", "8.5", "9"].map((b) => (
                <SelectItem key={b} value={b}>Band {b}</SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
        <div className="space-y-2">
          <Label>Duration</Label>
          <Input placeholder="e.g. 30 mins" defaultValue="30 mins" />
        </div>
      </div>

      {/* Questions with timestamps */}
      <div className="space-y-3">
        <h3 className="text-sm font-semibold">Time-Synced Questions</h3>
        <QuestionBuilder groups={groups} onChange={setGroups} showTimestamp />
      </div>
    </div>
  );
};

// ─── Writing Creator ──────────────────────────
const WritingCreator: React.FC = () => {
  const [taskType, setTaskType] = useState<"task1" | "task2">("task1");

  return (
    <div className="space-y-6">
      {/* Task Selector */}
      <div className="flex items-center gap-4">
        <Label className="text-sm font-semibold">Task Type</Label>
        <div className="inline-flex items-center rounded-lg bg-muted p-1">
          <button
            onClick={() => setTaskType("task1")}
            className={cn(
              "px-4 py-1.5 rounded-md text-sm font-medium transition-all",
              taskType === "task1" ? "bg-background text-foreground shadow-sm" : "text-muted-foreground"
            )}
          >
            Task 1 – Visual
          </button>
          <button
            onClick={() => setTaskType("task2")}
            className={cn(
              "px-4 py-1.5 rounded-md text-sm font-medium transition-all",
              taskType === "task2" ? "bg-background text-foreground shadow-sm" : "text-muted-foreground"
            )}
          >
            Task 2 – Essay
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Left */}
        <div className="space-y-4">
          <div className="space-y-2">
            <Label>Title</Label>
            <Input placeholder={taskType === "task1" ? "e.g. Bar Chart – International Tourism" : "e.g. Essay on Technology in Education"} />
          </div>
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label>Difficulty</Label>
              <Select defaultValue="7">
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
              <Input placeholder="e.g. 20 mins" defaultValue={taskType === "task1" ? "20 mins" : "40 mins"} />
            </div>
          </div>

          {/* Task 1 – Image Upload */}
          {taskType === "task1" && (
            <div className="space-y-2">
              <Label>Chart / Graph Image</Label>
              <div className="border-2 border-dashed border-border rounded-xl p-8 flex flex-col items-center justify-center gap-3 bg-muted/30 hover:bg-muted/50 transition-colors cursor-pointer">
                <ImageIcon className="h-8 w-8 text-muted-foreground" />
                <p className="text-sm text-muted-foreground">Upload chart, graph, or diagram</p>
                <p className="text-xs text-muted-foreground">PNG, JPG, SVG up to 10MB</p>
              </div>
            </div>
          )}
        </div>

        {/* Right */}
        <div className="space-y-4">
          <div className="space-y-2">
            <Label>Question Prompt</Label>
            <Textarea
              placeholder={
                taskType === "task1"
                  ? "Summarise the information by selecting and reporting the main features, and make comparisons where relevant..."
                  : "Write about the following topic:\n\nSome people believe that...\n\nDiscuss both views and give your own opinion."
              }
              className="min-h-[200px] text-sm"
            />
          </div>
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label>Min. Words</Label>
              <Input type="number" defaultValue={taskType === "task1" ? 150 : 250} />
            </div>
            <div className="space-y-2">
              <Label>Max. Words (optional)</Label>
              <Input type="number" placeholder="No limit" />
            </div>
          </div>
          <div className="flex items-center gap-3 p-3 rounded-lg bg-muted/50">
            <Switch id="model-answer" />
            <Label htmlFor="model-answer" className="text-sm cursor-pointer">Include Model Answer</Label>
          </div>
        </div>
      </div>
    </div>
  );
};

// ─── Main Page ────────────────────────────────
const CreateContent: React.FC = () => {
  const [activeTab, setActiveTab] = useState("reading");

  return (
    <AdminLayout>
      <div className="p-6 md:p-8 max-w-6xl mx-auto space-y-6">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <h1 className="text-2xl font-bold md:text-3xl">Test Creator Studio</h1>
            <p className="text-muted-foreground mt-1">Build IELTS practice tests for your students.</p>
          </div>
        </div>

        {/* Tab Creator */}
        <Tabs value={activeTab} onValueChange={setActiveTab}>
          <TabsList>
            <TabsTrigger value="reading" className="gap-2">
              <BookOpen className="h-4 w-4" /> Reading
            </TabsTrigger>
            <TabsTrigger value="listening" className="gap-2">
              <Headphones className="h-4 w-4" /> Listening
            </TabsTrigger>
            <TabsTrigger value="writing" className="gap-2">
              <PenTool className="h-4 w-4" /> Writing
            </TabsTrigger>
          </TabsList>

          <AnimatePresence mode="wait">
            <motion.div
              key={activeTab}
              initial={{ opacity: 0, y: 8 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -8 }}
              transition={{ duration: 0.2 }}
            >
              <TabsContent value="reading" className="mt-6">
                <ReadingCreator />
              </TabsContent>
              <TabsContent value="listening" className="mt-6">
                <ListeningCreator />
              </TabsContent>
              <TabsContent value="writing" className="mt-6">
                <WritingCreator />
              </TabsContent>
            </motion.div>
          </AnimatePresence>
        </Tabs>

        {/* Floating Action Bar */}
        <div className="sticky bottom-0 bg-background/80 backdrop-blur-lg border-t border-border -mx-6 md:-mx-8 px-6 md:px-8 py-4">
          <div className="flex items-center justify-between max-w-6xl mx-auto">
            <p className="text-xs text-muted-foreground">Auto-saved as draft</p>
            <div className="flex items-center gap-3">
              <Button variant="outline" className="gap-2">
                <Save className="h-4 w-4" /> Save Draft
              </Button>
              <Button variant="outline" className="gap-2">
                <Eye className="h-4 w-4" /> Preview
              </Button>
              <Button className="gap-2 bg-violet-600 hover:bg-violet-700 text-white">
                <Send className="h-4 w-4" /> Publish
              </Button>
            </div>
          </div>
        </div>
      </div>
    </AdminLayout>
  );
};

export default CreateContent;
