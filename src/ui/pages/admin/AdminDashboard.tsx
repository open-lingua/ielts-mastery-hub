import { formatDistanceToNow } from "date-fns";
import { motion } from "framer-motion";
import {
  BookOpen,
  CheckCircle2,
  Clock,
  Edit3,
  FileText,
  Headphones,
  PenTool,
  PlusCircle,
  TrendingUp,
  Users,
} from "lucide-react";
import type React from "react";
import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { AdminLayout } from "@/components/AdminLayout";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { getAnonId } from "@/lib/anonId";
import { listListeningTests, listProfiles, listReadingTests, listWritingTests } from "@/lib/tauri";
import { cn } from "@/lib/utils";

// ── Types ──────────────────────────────────────────────────
interface RecentItem {
  id: string;
  title: string;
  module: "Reading" | "Writing" | "Listening";
  status: string;
  updated_at: string;
}

interface DashboardStats {
  totalTests: number;
  published: number;
  activeStudents: number;
}

const moduleIcons: Record<string, React.ElementType> = {
  Reading: BookOpen,
  Writing: PenTool,
  Listening: Headphones,
};

// ── Component ──────────────────────────────────────────────
const AdminDashboard: React.FC = () => {
  const [recentItems, setRecentItems] = useState<RecentItem[]>([]);
  const [stats, setStats] = useState<DashboardStats>({
    totalTests: 0,
    published: 0,
    activeStudents: 0,
  });
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const load = async () => {
      setIsLoading(true);
      const adminId = getAnonId();
      try {
        const [reading, writing, listening, profiles] = await Promise.all([
          listReadingTests(adminId),
          listWritingTests(adminId),
          listListeningTests(adminId),
          listProfiles(),
        ]);

        const all: RecentItem[] = [
          ...reading.map((r) => ({
            id: r.id,
            title: r.title,
            status: r.status,
            updated_at: r.updated_at,
            module: "Reading" as const,
          })),
          ...writing.map((w) => ({
            id: w.id,
            title: w.title,
            status: w.status,
            updated_at: w.updated_at,
            module: "Writing" as const,
          })),
          ...listening.map((l) => ({
            id: l.id,
            title: l.title,
            status: l.status,
            updated_at: l.updated_at,
            module: "Listening" as const,
          })),
        ]
          .sort((a, b) => new Date(b.updated_at).getTime() - new Date(a.updated_at).getTime())
          .slice(0, 6);

        setRecentItems(all);

        const allTests = [...reading, ...writing, ...listening];
        setStats({
          totalTests: allTests.length,
          published: allTests.filter((t) => t.status === "published").length,
          activeStudents: profiles.length,
        });
      } catch (err) {
        console.error("Failed to load admin dashboard data", err);
      } finally {
        setIsLoading(false);
      }
    };
    load();
  }, []);

  const publishedPercent = stats.totalTests > 0 ? Math.round((stats.published / stats.totalTests) * 100) : 0;

  const statCards = [
    {
      label: "Total Tests",
      value: String(stats.totalTests),
      icon: FileText,
      change: `Across all modules`,
    },
    {
      label: "Published",
      value: String(stats.published),
      icon: CheckCircle2,
      change: `${publishedPercent}% of total`,
    },
    {
      label: "Registered Students",
      value: String(stats.activeStudents),
      icon: Users,
      change: "All accounts",
    },
    { label: "Modules", value: "3", icon: TrendingUp, change: "Reading · Writing · Listening" },
  ];

  return (
    <AdminLayout>
      <div className="p-6 md:p-8 max-w-6xl mx-auto space-y-8">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <h1 className="text-2xl font-bold md:text-3xl">Admin Dashboard</h1>
            <p className="text-muted-foreground mt-1">Manage your IELTS content and track performance.</p>
          </div>
          <Button asChild className="gap-2 bg-violet-600 hover:bg-violet-700 text-white">
            <Link to="/admin/create">
              <PlusCircle className="h-4 w-4" /> Create New Test
            </Link>
          </Button>
        </div>

        {/* Stats */}
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {statCards.map((stat, i) => (
            <motion.div
              key={stat.label}
              initial={{ opacity: 0, y: 12 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.05 }}
            >
              <Card>
                <CardContent className="p-5">
                  <div className="flex items-center justify-between mb-3">
                    <span className="text-xs font-medium text-muted-foreground uppercase tracking-wider">
                      {stat.label}
                    </span>
                    <stat.icon className="h-4 w-4 text-violet-500" />
                  </div>
                  {isLoading ? (
                    <Skeleton className="h-7 w-16 mb-1" />
                  ) : (
                    <p className="text-2xl font-bold">{stat.value}</p>
                  )}
                  <p className="text-xs text-muted-foreground mt-1">{stat.change}</p>
                </CardContent>
              </Card>
            </motion.div>
          ))}
        </div>

        {/* Recent Content */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-4">
            <CardTitle className="text-lg">Recent Content</CardTitle>
            <Button variant="ghost" size="sm" asChild>
              <Link to="/admin/content">View all</Link>
            </Button>
          </CardHeader>
          <CardContent className="p-0">
            <div className="divide-y divide-border">
              {isLoading
                ? Array.from({ length: 4 }).map((_, i) => (
                    <div key={i} className="flex items-center justify-between px-6 py-4">
                      <div className="flex items-center gap-4">
                        <Skeleton className="h-9 w-9 rounded-lg" />
                        <div className="space-y-1.5">
                          <Skeleton className="h-4 w-40" />
                          <Skeleton className="h-3 w-16" />
                        </div>
                      </div>
                      <div className="flex items-center gap-3">
                        <Skeleton className="h-5 w-16" />
                        <Skeleton className="h-3 w-20" />
                      </div>
                    </div>
                  ))
                : recentItems.map((item) => {
                    const Icon = moduleIcons[item.module] ?? Edit3;
                    const isPublished = item.status === "published";
                    return (
                      <div
                        key={`${item.module}-${item.id}`}
                        className="flex items-center justify-between px-6 py-4 hover:bg-muted/50 transition-colors"
                      >
                        <div className="flex items-center gap-4">
                          <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-violet-100 dark:bg-violet-900/30">
                            <Icon className="h-4 w-4 text-violet-600 dark:text-violet-400" />
                          </div>
                          <div>
                            <p className="text-sm font-semibold">{item.title || "Untitled"}</p>
                            <p className="text-xs text-muted-foreground">{item.module}</p>
                          </div>
                        </div>
                        <div className="flex items-center gap-3">
                          <Badge
                            variant={isPublished ? "default" : "secondary"}
                            className={cn(
                              isPublished &&
                                "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400"
                            )}
                          >
                            {isPublished ? "Published" : "Draft"}
                          </Badge>
                          <span className="text-xs text-muted-foreground flex items-center gap-1">
                            <Clock className="h-3 w-3" />
                            {formatDistanceToNow(new Date(item.updated_at), { addSuffix: true })}
                          </span>
                        </div>
                      </div>
                    );
                  })}
              {!isLoading && recentItems.length === 0 && (
                <div className="px-6 py-12 text-center text-muted-foreground">
                  No content created yet. Start by creating a new test.
                </div>
              )}
            </div>
          </CardContent>
        </Card>
      </div>
    </AdminLayout>
  );
};

export default AdminDashboard;
