import React, { useState } from "react";
import { Link } from "react-router-dom";
import { motion, AnimatePresence } from "framer-motion";
import {
  CheckCircle,
  PlayCircle,
  Clock,
  ArrowRight,
  BookOpen,
  PenTool,
  Headphones,
  Sparkles,
} from "lucide-react";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { Button } from "@/components/ui/button";
import { DashboardLayout } from "@/components/DashboardLayout";
import { cn } from "@/lib/utils";

type TestStatus = "new" | "in-progress" | "completed";
type TestModule = "Reading" | "Writing" | "Listening";

interface MockTest {
  id: number;
  title: string;
  module: TestModule;
  status: TestStatus;
  score?: number;
  date?: string;
  progress?: number;
  duration?: string;
  difficulty: "Easy" | "Medium" | "Hard";
}

const mockTests: MockTest[] = [
  { id: 1, title: "Academic Reading Test 1", module: "Reading", status: "completed", score: 7.5, date: "2023-10-15", difficulty: "Hard" },
  { id: 2, title: "General Training Writing Task 1", module: "Writing", status: "in-progress", progress: 60, difficulty: "Medium" },
  { id: 3, title: "Listening Section 4: Lecture", module: "Listening", status: "new", duration: "30 mins", difficulty: "Hard" },
  { id: 4, title: "Academic Reading Test 2", module: "Reading", status: "in-progress", progress: 25, difficulty: "Medium" },
  { id: 5, title: "Writing Task 2: Essay", module: "Writing", status: "completed", score: 6.5, date: "2023-10-12", difficulty: "Hard" },
  { id: 6, title: "Listening Section 1: Conversation", module: "Listening", status: "completed", score: 8.0, date: "2023-10-10", difficulty: "Easy" },
  { id: 7, title: "Academic Reading Test 3", module: "Reading", status: "new", duration: "60 mins", difficulty: "Hard" },
  { id: 8, title: "Writing Task 1: Graph Description", module: "Writing", status: "new", duration: "20 mins", difficulty: "Medium" },
  { id: 9, title: "Listening Section 3: Discussion", module: "Listening", status: "in-progress", progress: 45, difficulty: "Medium" },
];

const moduleIcons: Record<TestModule, React.ElementType> = {
  Reading: BookOpen,
  Writing: PenTool,
  Listening: Headphones,
};

const moduleColors: Record<TestModule, string> = {
  Reading: "text-emerald-600 dark:text-emerald-400",
  Writing: "text-primary",
  Listening: "text-amber-600 dark:text-amber-400",
};

const moduleIconBg: Record<TestModule, string> = {
  Reading: "bg-emerald-100 dark:bg-emerald-900/40",
  Writing: "bg-primary/10",
  Listening: "bg-amber-100 dark:bg-amber-900/40",
};

const difficultyColors: Record<string, string> = {
  Easy: "bg-emerald-100 text-emerald-800 dark:bg-emerald-900/50 dark:text-emerald-300",
  Medium: "bg-amber-100 text-amber-800 dark:bg-amber-900/50 dark:text-amber-300",
  Hard: "bg-red-100 text-red-800 dark:bg-red-900/50 dark:text-red-300",
};

const TestCard: React.FC<{ test: MockTest }> = ({ test }) => {
  const Icon = moduleIcons[test.module];

  return (
    <motion.div
      layout
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, scale: 0.95 }}
      transition={{ duration: 0.25 }}
    >
      <Card
        className={cn(
          "group relative overflow-hidden transition-all hover:shadow-lg hover:-translate-y-0.5",
          test.status === "completed" && "opacity-80",
          test.status === "in-progress" && "ring-1 ring-sky-400/40 dark:ring-sky-500/30"
        )}
      >
        {test.status === "completed" && (
          <div className="absolute top-0 left-0 w-full h-0.5 bg-emerald-500" />
        )}
        {test.status === "in-progress" && (
          <div className="absolute top-0 left-0 w-full h-0.5 bg-sky-500" />
        )}

        <CardContent className="p-5 space-y-4">
          {/* Header row */}
          <div className="flex items-start justify-between gap-3">
            <div className={cn("flex h-10 w-10 shrink-0 items-center justify-center rounded-xl", moduleIconBg[test.module])}>
              <Icon className={cn("h-5 w-5", moduleColors[test.module])} />
            </div>
            <div className="flex items-center gap-2">
              <Badge variant="outline" className={cn("text-[10px] font-semibold", difficultyColors[test.difficulty])}>
                {test.difficulty}
              </Badge>
              {test.status === "completed" && (
                <Badge className="bg-emerald-100 text-emerald-800 dark:bg-emerald-900/50 dark:text-emerald-300 border-0 gap-1">
                  <CheckCircle className="h-3 w-3" /> Done
                </Badge>
              )}
              {test.status === "in-progress" && (
                <Badge className="bg-sky-100 text-sky-800 dark:bg-sky-900/50 dark:text-sky-300 border-0 gap-1">
                  <PlayCircle className="h-3 w-3" /> Resumable
                </Badge>
              )}
              {test.status === "new" && (
                <Badge className="bg-secondary text-secondary-foreground border-0 gap-1">
                  <Sparkles className="h-3 w-3" /> New
                </Badge>
              )}
            </div>
          </div>

          {/* Title & module */}
          <div>
            <h3 className="text-sm font-bold text-foreground leading-tight">{test.title}</h3>
            <p className="text-xs text-muted-foreground mt-1">{test.module} Module</p>
          </div>

          {/* Status-specific content */}
          {test.status === "completed" && (
            <div className="flex items-center justify-between rounded-lg bg-emerald-50 dark:bg-emerald-900/20 px-3 py-2">
              <span className="text-xs text-muted-foreground">Band Score</span>
              <span className="text-lg font-bold text-emerald-700 dark:text-emerald-300">{test.score}</span>
            </div>
          )}

          {test.status === "in-progress" && (
            <div className="space-y-1.5">
              <div className="flex justify-between text-xs text-muted-foreground">
                <span>Progress</span>
                <span className="font-semibold text-foreground">{test.progress}%</span>
              </div>
              <Progress value={test.progress} className="h-2" />
            </div>
          )}

          {test.status === "new" && (
            <div className="flex items-center gap-1.5 text-xs text-muted-foreground">
              <Clock className="h-3.5 w-3.5" />
              <span>Estimated: {test.duration}</span>
            </div>
          )}

          {/* Action button */}
          <Button
            variant={test.status === "completed" ? "outline" : test.status === "in-progress" ? "secondary" : "default"}
            className="w-full gap-2 text-sm"
            asChild
          >
            <Link to={`/${test.module.toLowerCase()}`}>
              {test.status === "completed" && "Review Results"}
              {test.status === "in-progress" && "Continue Test"}
              {test.status === "new" && "Start Practice"}
              <ArrowRight className="h-4 w-4" />
            </Link>
          </Button>
        </CardContent>
      </Card>
    </motion.div>
  );
};

const TestLibrary: React.FC = () => {
  const [activeTab, setActiveTab] = useState("all");

  const filteredTests =
    activeTab === "all"
      ? mockTests
      : mockTests.filter((t) => t.module.toLowerCase() === activeTab);

  const counts = {
    all: mockTests.length,
    reading: mockTests.filter((t) => t.module === "Reading").length,
    writing: mockTests.filter((t) => t.module === "Writing").length,
    listening: mockTests.filter((t) => t.module === "Listening").length,
  };

  return (
    <DashboardLayout>
      <div className="p-4 md:p-8 max-w-6xl mx-auto space-y-6">
        {/* Header */}
        <div>
          <h1 className="text-2xl font-bold md:text-3xl">Practice Library</h1>
          <p className="mt-1 text-muted-foreground">
            Choose a module to improve your band score.
          </p>
        </div>

        {/* Tabs */}
        <Tabs value={activeTab} onValueChange={setActiveTab}>
          <TabsList>
            <TabsTrigger value="all">All ({counts.all})</TabsTrigger>
            <TabsTrigger value="reading">Reading ({counts.reading})</TabsTrigger>
            <TabsTrigger value="writing">Writing ({counts.writing})</TabsTrigger>
            <TabsTrigger value="listening">Listening ({counts.listening})</TabsTrigger>
          </TabsList>

          <TabsContent value={activeTab} className="mt-6">
            <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
              <AnimatePresence mode="popLayout">
                {filteredTests.map((test) => (
                  <TestCard key={test.id} test={test} />
                ))}
              </AnimatePresence>
            </div>
          </TabsContent>
        </Tabs>
      </div>
    </DashboardLayout>
  );
};

export default TestLibrary;
