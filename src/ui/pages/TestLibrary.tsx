import { formatDistanceToNow } from "date-fns";
import { AnimatePresence, motion } from "framer-motion";
import {
  ArrowRight,
  ArrowUpDown,
  BookOpen,
  CheckCircle2,
  Clock,
  Headphones,
  MoreHorizontal,
  PenTool,
  PlayCircle,
  RotateCcw,
  Trophy,
} from "lucide-react";
import { useQuery } from "@tanstack/react-query";
import type React from "react";
import { useEffect, useMemo, useRef, useState } from "react";
import { Link, useNavigate, useSearchParams } from "react-router-dom";
import { toast } from "sonner";
import { DashboardLayout } from "@/components/DashboardLayout";
import ActiveSessionBanner from "@/components/shared/ActiveSessionBanner";
import Pagination from "@/components/shared/Pagination";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Progress } from "@/components/ui/progress";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Skeleton } from "@/components/ui/skeleton";
import { usePagination } from "@/hooks/usePagination";
import { getAnonId } from "@/lib/anonId";
import { cn } from "@/lib/utils";
import {
  type ActiveSessionInfo,
  fetchActiveSession,
  fetchLibraryPage,
  fetchTestTitle,
  type PracticeTestCard,
  type SessionStatus,
  type TestModule,
} from "@/services/practiceLibraryService";

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
        <h3 className="font-semibold leading-tight text-lg text-foreground">{test.title}</h3>
      </div>

      {/* Status */}
      <div className="px-5 py-4 md:py-5 md:w-1/3 flex flex-col justify-center space-y-3 border-b md:border-b-0 md:border-r border-border">
        {isCompleted ? (
          <div className="flex items-center justify-between bg-[hsl(var(--success))]/10 p-3 rounded-lg border border-[hsl(var(--success))]/20">
            <div className="flex flex-col">
              <span className="text-[10px] text-[hsl(var(--success))] font-medium uppercase tracking-wider">
                Score Achieved
              </span>
              <span className="text-2xl font-bold text-[hsl(var(--success))]">Band {test.score_band}</span>
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
            {test.status === "not_started" && <Badge variant="secondary">New</Badge>}
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
                {isCompleted ? <RotateCcw className="h-3 w-3" /> : <ArrowRight className="h-3 w-3" />}
              </Link>
            )}
          </Button>
        </div>
      </div>
    </Card>
  );
};

const moduleForTab: Record<string, TestModule | undefined> = {
  All: undefined,
  Reading: "reading",
  Writing: "writing",
  Listening: "listening",
};

const TestLibrary: React.FC = () => {
  const userId = getAnonId();
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const [activeTab, setActiveTab] = useState(searchParams.get("tab") ?? "All");
  const [unresolvedOnly, setUnresolvedOnly] = useState(false);
  const listTopRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    setActiveTab(searchParams.get("tab") ?? "All");
  }, [searchParams]);
  const [sortOrder, setSortOrder] = useState<"newest" | "oldest">("newest");
  const [activeSessionInfo, setActiveSessionInfo] = useState<{
    session: ActiveSessionInfo;
    title: string;
  } | null>(null);

  const tabs = ["All", "Reading", "Writing", "Listening"];
  const module = moduleForTab[activeTab];

  const { page, pageSize, setPage } = usePagination({
    resetKey: activeTab,
    pageSize: 10,
    scrollTargetRef: listTopRef,
  });

  const {
    data: libraryPage,
    isLoading,
    isError,
  } = useQuery({
    queryKey: ["practice-tests", userId, module, page, pageSize],
    queryFn: () => fetchLibraryPage(userId, module, page, pageSize),
  });

  useEffect(() => {
    const loadActiveSession = async () => {
      try {
        const active = await fetchActiveSession(userId);
        if (active) {
          const title = await fetchTestTitle(active.test_id, active.test_type as TestModule);
          setActiveSessionInfo({ session: active, title });
        } else {
          setActiveSessionInfo(null);
        }
      } catch (error) {
        console.error(error);
      }
    };
    loadActiveSession();
  }, [userId]);

  useEffect(() => {
    if (isError) {
      toast.error("Failed to load tests");
    }
  }, [isError]);

  const tests = useMemo(() => libraryPage?.data ?? [], [libraryPage]);

  const filteredTests = useMemo(
    () =>
      tests
        .filter((t) => !unresolvedOnly || t.status !== "completed")
        .sort((a, b) => {
          const diff = new Date(b.created_at).getTime() - new Date(a.created_at).getTime();
          return sortOrder === "newest" ? diff : -diff;
        }),
    [tests, unresolvedOnly, sortOrder]
  );

  const handleStart = (test: PracticeTestCard) => {
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

        {/* Filters Row */}
        <div className="flex items-center justify-between gap-4 flex-wrap">
          {/* Pill Tabs */}
          <div className="inline-flex h-10 items-center justify-center rounded-lg bg-muted p-1 text-muted-foreground">
            {tabs.map((tab) => (
              <button
                key={tab}
                type="button"
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

          {/* Unresolved Filter */}
          <button
            type="button"
            onClick={() => setUnresolvedOnly((prev) => !prev)}
            className={cn(
              "inline-flex h-10 items-center gap-2 rounded-lg border px-4 text-sm font-medium transition-all",
              unresolvedOnly
                ? "border-primary bg-primary/10 text-primary"
                : "border-border bg-background text-muted-foreground hover:text-foreground hover:border-foreground/30"
            )}
          >
            <PlayCircle className="h-3.5 w-3.5" />
            Unresolved
            {!unresolvedOnly && (
              <span className="rounded-full bg-muted px-1.5 py-0.5 text-xs">
                {tests.filter((t) => t.status !== "completed").length}
              </span>
            )}
          </button>

          {/* Sort Dropdown */}
          <Select value={sortOrder} onValueChange={(v) => setSortOrder(v as "newest" | "oldest")}>
            <SelectTrigger className="w-[160px] h-10">
              <ArrowUpDown className="h-3.5 w-3.5 mr-2 text-muted-foreground" />
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="newest">Newest First</SelectItem>
              <SelectItem value="oldest">Oldest First</SelectItem>
            </SelectContent>
          </Select>
        </div>

        {/* Timeline */}
        <div ref={listTopRef} className="relative ml-4 md:ml-6 border-l-2 border-border space-y-8 pb-10">
          {isLoading ? (
            ["sk-1", "sk-2", "sk-3", "sk-4"].map((skKey) => (
              <div key={skKey} className="relative pl-8 md:pl-10">
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
                  <TestCard test={test} onStart={handleStart} />
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
                  No published tests are available in this category yet.
                </p>
                <Button onClick={() => setActiveTab("All")}>View All Tests</Button>
              </div>
            </div>
          )}
        </div>

        {/* Pagination */}
        {!isLoading && libraryPage && (
          <Pagination pagination={libraryPage.pagination} onPageChange={setPage} />
        )}
      </div>
    </DashboardLayout>
  );
};

export default TestLibrary;
