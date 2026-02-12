import React, { useState } from "react";
import { Link } from "react-router-dom";
import { motion, AnimatePresence } from "framer-motion";
import {
  BookOpen,
  PenTool,
  Headphones,
  CheckCircle2,
  PlayCircle,
  Clock,
  ArrowRight,
  BarChart3,
  MoreHorizontal,
  Timer,
} from "lucide-react";
import { Card } from "@/components/ui/card";
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
  duration: string;
  difficulty: "Easy" | "Medium" | "Hard";
}

const mockTests: MockTest[] = [
  { id: 1, title: "Academic Reading: The History of Glass", module: "Reading", status: "completed", score: 8.5, date: "2023-10-15", difficulty: "Hard", duration: "60 mins" },
  { id: 2, title: "General Writing Task 1: Letter to Council", module: "Writing", status: "in-progress", progress: 65, difficulty: "Medium", duration: "20 mins" },
  { id: 3, title: "Listening Section 4: Marine Biology", module: "Listening", status: "new", duration: "30 mins", difficulty: "Hard" },
  { id: 4, title: "Academic Reading: Urban Planning", module: "Reading", status: "in-progress", progress: 25, difficulty: "Medium", duration: "60 mins" },
  { id: 5, title: "Writing Task 2: Essay on Technology", module: "Writing", status: "new", duration: "40 mins", difficulty: "Easy" },
  { id: 6, title: "Listening Section 1: Hotel Reservation", module: "Listening", status: "completed", score: 9.0, date: "2023-10-18", difficulty: "Easy", duration: "30 mins" },
  { id: 7, title: "Academic Reading: Cognitive Science", module: "Reading", status: "new", duration: "60 mins", difficulty: "Hard" },
  { id: 8, title: "General Writing Task 2: Public Transport", module: "Writing", status: "completed", score: 6.5, date: "2023-10-20", difficulty: "Medium", duration: "40 mins" },
];

const moduleIcons: Record<TestModule, React.ElementType> = {
  Reading: BookOpen,
  Writing: PenTool,
  Listening: Headphones,
};

const moduleIconColors: Record<TestModule, string> = {
  Reading: "text-blue-500",
  Writing: "text-amber-500",
  Listening: "text-rose-500",
};

const difficultyVariant: Record<string, "default" | "secondary" | "outline" | "destructive"> = {
  Easy: "secondary",
  Medium: "outline",
  Hard: "destructive",
};

const dotColors: Record<TestStatus, string> = {
  completed: "bg-emerald-500",
  "in-progress": "bg-blue-500",
  new: "bg-slate-300 dark:bg-slate-600",
};

const cardBorderColors: Record<TestStatus, string> = {
  completed: "border-emerald-200 dark:border-emerald-900",
  "in-progress": "border-blue-200 dark:border-blue-900",
  new: "border-border",
};

const TestCard: React.FC<{ test: MockTest }> = ({ test }) => {
  const Icon = moduleIcons[test.module];
  const isCompleted = test.status === "completed";
  const isInProgress = test.status === "in-progress";

  return (
    <Card className={cn("flex flex-col md:flex-row overflow-hidden hover:shadow-md transition-shadow", cardBorderColors[test.status])}>
      {/* Info Section */}
      <div className="p-5 md:w-1/3 space-y-3 flex flex-col justify-center border-b md:border-b-0 md:border-r border-border">
        <div className="flex justify-between items-start">
          <div className={cn("flex items-center gap-2 text-sm font-medium text-muted-foreground")}>
            <Icon className={cn("h-4 w-4", moduleIconColors[test.module])} />
            <span>{test.module}</span>
          </div>
          <Badge variant={difficultyVariant[test.difficulty]} className="text-[10px]">
            {test.difficulty}
          </Badge>
        </div>
        <h3 className="font-semibold leading-tight text-lg text-foreground">{test.title}</h3>
      </div>

      {/* Status Section */}
      <div className="px-5 py-4 md:py-5 md:w-1/3 flex flex-col justify-center space-y-3 border-b md:border-b-0 md:border-r border-border">
        {isCompleted ? (
          <div className="flex items-center justify-between bg-emerald-50 dark:bg-emerald-950/30 p-3 rounded-lg border border-emerald-100 dark:border-emerald-900/50">
            <div className="flex flex-col">
              <span className="text-[10px] text-emerald-600 dark:text-emerald-400 font-medium uppercase tracking-wider">Score Achieved</span>
              <span className="text-2xl font-bold text-emerald-700 dark:text-emerald-300">Band {test.score}</span>
            </div>
            <BarChart3 className="h-8 w-8 text-emerald-300 dark:text-emerald-700 opacity-50" />
          </div>
        ) : isInProgress ? (
          <div className="space-y-2">
            <div className="flex justify-between text-xs font-medium text-muted-foreground">
              <span>Progress</span>
              <span>{test.progress}%</span>
            </div>
            <Progress value={test.progress} className="h-2" />
            <p className="text-xs text-muted-foreground pt-1">Last active 2 hours ago</p>
          </div>
        ) : (
          <div className="flex items-center text-muted-foreground text-sm gap-2">
            <Clock className="h-4 w-4" />
            <span>Est. Duration: {test.duration}</span>
          </div>
        )}
      </div>

      {/* Action Section */}
      <div className="p-5 md:w-1/3 flex flex-col justify-center">
        <div className="flex items-center justify-between md:justify-end md:gap-4">
          <div className="md:hidden">
            {isCompleted && (
              <Badge className="bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400 border-emerald-200 dark:border-emerald-800 gap-1">
                <CheckCircle2 className="h-3 w-3" /> Completed
              </Badge>
            )}
            {isInProgress && (
              <Badge className="bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400 border-blue-200 dark:border-blue-800 gap-1">
                <PlayCircle className="h-3 w-3" /> Resumable
              </Badge>
            )}
            {test.status === "new" && (
              <Badge variant="secondary">New</Badge>
            )}
          </div>
          <Button
            variant={isCompleted ? "secondary" : "default"}
            size="sm"
            className={cn("gap-2 w-full md:w-auto", isInProgress && "bg-blue-600 hover:bg-blue-700 dark:bg-blue-600 dark:hover:bg-blue-500 text-white")}
            asChild
          >
            <Link to={`/${test.module.toLowerCase()}`}>
              {isCompleted ? "Review" : isInProgress ? "Continue" : "Start"}
              {isCompleted || isInProgress ? <ArrowRight className="h-3 w-3" /> : <PlayCircle className="h-3 w-3" />}
            </Link>
          </Button>
        </div>
      </div>
    </Card>
  );
};

const TestLibrary: React.FC = () => {
  const [activeTab, setActiveTab] = useState("All");
  const tabs = ["All", "Reading", "Writing", "Listening"];

  const filteredTests = mockTests.filter(
    (test) => activeTab === "All" || test.module === activeTab
  );

  return (
    <DashboardLayout>
      <div className="p-4 md:p-8 max-w-4xl mx-auto space-y-8">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div className="space-y-1">
            <h1 className="text-2xl font-bold md:text-3xl">Practice Library</h1>
            <p className="text-muted-foreground">
              Select a module to improve your band score. Track your progress in real-time.
            </p>
          </div>
          <div className="flex items-center gap-2">
            <Button variant="outline" className="gap-2">
              <Timer className="h-4 w-4" /> History
            </Button>
            <Button>Random Test</Button>
          </div>
        </div>

        {/* Pill Tabs */}
        <div className="inline-flex h-10 items-center justify-center rounded-lg bg-muted p-1 text-muted-foreground">
          {tabs.map((tab) => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className={cn(
                "inline-flex items-center justify-center whitespace-nowrap rounded-md px-5 py-1.5 text-sm font-medium transition-all",
                activeTab === tab
                  ? "bg-background text-foreground shadow-sm"
                  : "hover:bg-accent hover:text-accent-foreground"
              )}
            >
              {tab}
            </button>
          ))}
        </div>

        {/* Timeline */}
        <div className="relative ml-4 md:ml-6 border-l-2 border-border space-y-8 pb-10">
          <AnimatePresence mode="popLayout">
            {filteredTests.map((test) => (
              <motion.div
                key={test.id}
                layout
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, x: -20 }}
                transition={{ duration: 0.3 }}
                className="relative pl-8 md:pl-10"
              >
                {/* Timeline Dot */}
                <div
                  className={cn(
                    "absolute -left-[9px] top-8 h-4 w-4 rounded-full border-2 border-background shadow-sm z-10",
                    dotColors[test.status]
                  )}
                />
                <TestCard test={test} />
              </motion.div>
            ))}
          </AnimatePresence>

          {filteredTests.length === 0 && (
            <div className="relative pl-8 md:pl-10">
              <div className="flex flex-col items-center justify-center py-16 text-center border-2 border-dashed border-border rounded-xl bg-muted/50">
                <div className="bg-muted p-4 rounded-full mb-4">
                  <MoreHorizontal className="h-8 w-8 text-muted-foreground" />
                </div>
                <h3 className="text-lg font-semibold">No tests found</h3>
                <p className="text-muted-foreground max-w-sm mt-1 mb-4">
                  We couldn't find any tests for this category.
                </p>
                <Button onClick={() => setActiveTab("All")}>View All Tests</Button>
              </div>
            </div>
          )}
        </div>
      </div>
    </DashboardLayout>
  );
};

export default TestLibrary;
