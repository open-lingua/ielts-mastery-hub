import React, { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
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
  Trophy,
  RotateCcw,
} from "lucide-react";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";
import { DashboardLayout } from "@/components/DashboardLayout";
import { useAuth } from "@/contexts/AuthContext";
import { cn } from "@/lib/utils";
import { toast } from "sonner";
import {
  fetchLibraryData,
  fetchActiveSession,
  fetchTestTitle,
  type PracticeTestCard,
  type TestModule,
  type SessionStatus,
  type ActiveSessionInfo,
} from "@/services/practiceLibraryService";
import { formatDistanceToNow } from "date-fns";
import ActiveSessionBanner from "@/components/shared/ActiveSessionBanner";

const moduleIcons: Record<TestModule, React.ElementType> = {
  reading: BookOpen,
  writing: PenTool,
  listening: Headphones,
};

const moduleLabels: Record<TestModule, string> = {
  reading: "Reading",
  writing: "Writing",
  listening: "Listening",
};

const moduleIconColors: Record<TestModule, string> = {
  reading: "text-primary",
  writing: "text-accent",
  listening: "text-destructive",
};

const dotColors: Record<SessionStatus, string> = {
  completed: "bg-[hsl(var(--success))]",
  in_progress: "bg-primary",
  not_started: "bg-muted-foreground/30",
};

const cardBorderColors: Record<SessionStatus, string> = {
  completed: "border-[hsl(var(--success))]/30",
  in_progress: "border-primary/30",
  not_started: "border-border",
};

const TestCardSkeleton = () => (
  <Card className="flex flex-col md:flex-row overflow-hidden">
    <div className="p-5 md:w-1/3 space-y-3">
      <Skeleton className="h-4 w-20" />
      <Skeleton className="h-6 w-full" />
    </div>
    <div className="px-5 py-4 md:w-1/3">
      <Skeleton className="h-10 w-full" />
    </div>
    <div className="p-5 md:w-1/3 flex items-center justify-end">
      <Skeleton className="h-9 w-24" />
    </div>
  </Card>
);

const TestCard: React.FC<{
  test: PracticeTestCard;
  onStart: (test: PracticeTestCard) => void;
}> = ({ test, onStart }) => {
  const Icon = moduleIcons[test.module];
  const isCompleted = test.status === "completed";
  const isInProgress = test.status === "in_progress";

  const targetRoute = `/${test.module}?id=${test.id}`;

  const handleAction = (e: React.MouseEvent) => {
    if (test.status === "not_started") {
      e.preventDefault();
      onStart(test);
    }
  };

  return (
    <Card
      className={cn(
        "flex flex-col md:flex-row overflow-hidden hover:shadow-md transition-shadow",
        cardBorderColors[test.status]
      )}
    >
      {/* Info */}
      <div className="p-5 md:w-1/3 space-y-3 flex flex-col justify-center border-b md:border-b-0 md:border-r border-border">
        <div className="flex justify-between items-start">
          <div className="flex items-center gap-2 text-sm font-medium text-muted-foreground">
            <Icon className={cn("h-4 w-4", moduleIconColors[test.module])} />
            <span>{moduleLabels[test.module]}</span>
          </div>
          <Badge variant="outline" className="text-[10px]">
            Band {test.difficulty}
          </Badge>
        </div>
        <h3 className="font-semibold leading-tight text-lg text-foreground">
          {test.title}
        </h3>
      </div>

      {/* Status */}
      <div className="px-5 py-4 md:py-5 md:w-1/3 flex flex-col justify-center space-y-3 border-b md:border-b-0 md:border-r border-border">
        {isCompleted ? (
          <div className="flex items-center justify-between bg-[hsl(var(--success))]/10 p-3 rounded-lg border border-[hsl(var(--success))]/20">
            <div className="flex flex-col">
              <span className="text-[10px] text-[hsl(var(--success))] font-medium uppercase tracking-wider">
                Score Achieved
              </span>
              <span className="text-2xl font-bold text-[hsl(var(--success))]">
                Band {test.score_band}
              </span>
            </div>
            <Trophy className="h-8 w-8 text-[hsl(var(--success))]/40" />
          </div>
        ) : isInProgress ? (
          <div className="space-y-2">
            <div className="flex justify-between text-xs font-medium text-muted-foreground">
              <span>Progress</span>
              <span>{test.progress_percent}%</span>
            </div>
            <Progress value={test.progress_percent} className="h-2" />
            {test.last_active_at && (
              <p className="text-xs text-muted-foreground pt-1">
                Last active{" "}
                {formatDistanceToNow(new Date(test.last_active_at), {
                  addSuffix: true,
                })}
              </p>
            )}
          </div>
        ) : (
          <div className="flex items-center text-muted-foreground text-sm gap-2">
            <Clock className="h-4 w-4" />
            <span>Est. Duration: {test.duration}</span>
          </div>
        )}
      </div>

      {/* Action */}
      <div className="p-5 md:w-1/3 flex flex-col justify-center">
        <div className="flex items-center justify-between md:justify-end md:gap-4">
          <div className="md:hidden">
            {isCompleted && (
              <Badge className="bg-[hsl(var(--success))]/10 text-[hsl(var(--success))] border-[hsl(var(--success))]/20 gap-1">
                <CheckCircle2 className="h-3 w-3" /> Completed
              </Badge>
            )}
            {isInProgress && (
              <Badge className="bg-primary/10 text-primary border-primary/20 gap-1">
                <PlayCircle className="h-3 w-3" /> Resumable
              </Badge>
            )}
            {test.status === "not_started" && (
              <Badge variant="secondary">New</Badge>
            )}
          </div>
          <Button
            variant={isCompleted ? "secondary" : "default"}
            size="sm"
            className={cn(
              "gap-2 w-full md:w-auto",
              isInProgress && "bg-primary hover:bg-primary/90 text-primary-foreground"
            )}
            onClick={handleAction}
            asChild={test.status !== "not_started"}
          >
            {test.status === "not_started" ? (
              <span>
                Start
                <PlayCircle className="h-3 w-3" />
              </span>
            ) : (
              <Link to={targetRoute}>
                {isCompleted ? "Review" : "Continue"}
                {isCompleted ? (
                  <RotateCcw className="h-3 w-3" />
                ) : (
                  <ArrowRight className="h-3 w-3" />
                )}
              </Link>
            )}
          </Button>
        </div>
      </div>
    </Card>
  );
};

const TestLibrary: React.FC = () => {
  const { user, isAuthenticated } = useAuth();
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState("All");
  const [tests, setTests] = useState<PracticeTestCard[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [activeSessionInfo, setActiveSessionInfo] = useState<{ session: ActiveSessionInfo; title: string } | null>(null);

  const tabs = ["All", "Reading", "Writing", "Listening"];

  useEffect(() => {
    if (!user) {
      setIsLoading(false);
      return;
    }
    setIsLoading(true);

    const load = async () => {
      try {
        const [testsData, active] = await Promise.all([
          fetchLibraryData(user.id),
          fetchActiveSession(user.id),
        ]);
        setTests(testsData);

        if (active) {
          const title = await fetchTestTitle(active.test_id, active.test_type as TestModule);
          setActiveSessionInfo({ session: active, title });
        } else {
          setActiveSessionInfo(null);
        }
      } catch {
        toast.error("Failed to load tests");
      } finally {
        setIsLoading(false);
      }
    };
    load();
  }, [user]);

  const filteredTests = tests.filter(
    (t) => activeTab === "All" || moduleLabels[t.module] === activeTab
  );

  const handleStart = (test: PracticeTestCard) => {
    if (!user) return;

    // Block if another test is already in progress
    if (activeSessionInfo && activeSessionInfo.session.test_id !== test.id) {
      toast.error("You already have a test in progress. Please resume or submit it first.");
      return;
    }

    // Navigate to the module — the Test Guard overlay will handle session creation
    navigate(`/${test.module}?id=${test.id}`);
  };

  return (
    <DashboardLayout>
      <div className="p-4 md:p-8 max-w-4xl mx-auto space-y-8">
        {/* Active Session Banner */}
        {activeSessionInfo && (
          <ActiveSessionBanner
            testTitle={activeSessionInfo.title}
            testType={activeSessionInfo.session.test_type as TestModule}
            testId={activeSessionInfo.session.test_id}
          />
        )}

        {/* Header */}
        <div className="space-y-1">
          <h1 className="text-2xl font-bold md:text-3xl">Practice Library</h1>
          <p className="text-muted-foreground">
            Select a module to improve your band score. Track your progress in real-time.
          </p>
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
                  : "hover:bg-accent/20 hover:text-accent-foreground"
              )}
            >
              {tab}
            </button>
          ))}
        </div>

        {/* Timeline */}
        <div className="relative ml-4 md:ml-6 border-l-2 border-border space-y-8 pb-10">
          {isLoading ? (
            Array.from({ length: 4 }).map((_, i) => (
              <div key={i} className="relative pl-8 md:pl-10">
                <div className="absolute -left-[9px] top-8 h-4 w-4 rounded-full bg-muted" />
                <TestCardSkeleton />
              </div>
            ))
          ) : (
            <AnimatePresence mode="popLayout">
              {filteredTests.map((test, i) => (
                <motion.div
                  key={test.id}
                  layout
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  exit={{ opacity: 0, x: -20 }}
                  transition={{ duration: 0.25, delay: i * 0.05 }}
                  className="relative pl-8 md:pl-10"
                >
                  <div
                    className={cn(
                      "absolute -left-[9px] top-8 h-4 w-4 rounded-full border-2 border-background shadow-sm z-10",
                      dotColors[test.status]
                    )}
                  />
                  <TestCard
                    test={test}
                    onStart={handleStart}
                  />
                </motion.div>
              ))}
            </AnimatePresence>
          )}

          {!isLoading && filteredTests.length === 0 && (
            <div className="relative pl-8 md:pl-10">
              <div className="flex flex-col items-center justify-center py-16 text-center border-2 border-dashed border-border rounded-xl bg-muted/50">
                <div className="bg-muted p-4 rounded-full mb-4">
                  <MoreHorizontal className="h-8 w-8 text-muted-foreground" />
                </div>
                <h3 className="text-lg font-semibold">No tests found</h3>
                <p className="text-muted-foreground max-w-sm mt-1 mb-4">
                  {isAuthenticated
                    ? "No published tests are available in this category yet."
                    : "Please log in to view available practice tests."}
                </p>
                {!isAuthenticated && (
                  <Button asChild>
                    <Link to="/login">Log In</Link>
                  </Button>
                )}
                {isAuthenticated && (
                  <Button onClick={() => setActiveTab("All")}>
                    View All Tests
                  </Button>
                )}
              </div>
            </div>
          )}
        </div>
      </div>
    </DashboardLayout>
  );
};

export default TestLibrary;
