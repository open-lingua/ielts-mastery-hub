import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { PenTool, BookOpen, Headphones, Flame, Clock } from "lucide-react";
import { getAnonId } from "@/lib/anonId";
import { DashboardLayout } from "@/components/DashboardLayout";
import StudyHeatmap from "@/components/dashboard/StudyHeatmap";
import RecentActivity from "@/components/dashboard/RecentActivity";
import BandScoreChart from "@/components/dashboard/BandScoreChart";
import { supabase } from "@/integrations/supabase/client";

const quickActions = [
  {
    label: "Practice Writing",
    description: "Essay & letter tasks with AI grading",
    path: "/writing",
    icon: PenTool,
    gradient: "from-primary/10 to-primary/5",
    iconBg: "bg-primary/10 text-primary",
  },
  {
    label: "Practice Reading",
    description: "Passages with comprehension questions",
    path: "/reading",
    icon: BookOpen,
    gradient: "from-success/10 to-success/5",
    iconBg: "bg-success/10 text-success",
  },
  {
    label: "Practice Listening",
    description: "Audio exercises with fill-in-the-blank",
    path: "/listening",
    icon: Headphones,
    gradient: "from-warning/10 to-warning/5",
    iconBg: "bg-warning/10 text-warning",
  },
];

function calculateStreak(dates: string[]): number {
  if (dates.length === 0) return 0;

  // Get unique local dates sorted descending
  const uniqueDays = new Set<string>();
  dates.forEach((d) => {
    const local = new Date(d);
    uniqueDays.add(`${local.getFullYear()}-${String(local.getMonth() + 1).padStart(2, "0")}-${String(local.getDate()).padStart(2, "0")}`);
  });

  const sorted = Array.from(uniqueDays).sort().reverse();
  const today = new Date();
  const todayStr = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, "0")}-${String(today.getDate()).padStart(2, "0")}`;
  const yesterday = new Date(today);
  yesterday.setDate(yesterday.getDate() - 1);
  const yesterdayStr = `${yesterday.getFullYear()}-${String(yesterday.getMonth() + 1).padStart(2, "0")}-${String(yesterday.getDate()).padStart(2, "0")}`;

  // Streak must start from today or yesterday (grace period)
  if (sorted[0] !== todayStr && sorted[0] !== yesterdayStr) return 0;

  let streak = 1;
  for (let i = 1; i < sorted.length; i++) {
    const prev = new Date(sorted[i - 1]);
    const curr = new Date(sorted[i]);
    const diff = (prev.getTime() - curr.getTime()) / (1000 * 60 * 60 * 24);
    if (Math.round(diff) === 1) {
      streak++;
    } else {
      break;
    }
  }

  return streak;
}

const Dashboard: React.FC = () => {
  const userId = getAnonId();
  const [streak, setStreak] = useState(0);

  useEffect(() => {
    const fetchStreak = async () => {
      const { data } = await supabase
        .from("user_test_sessions")
        .select("started_at")
        .eq("user_id", userId)
        .order("started_at", { ascending: false });
      if (data) {
        setStreak(calculateStreak(data.map((r) => r.started_at)));
      }
    };
    fetchStreak();
  }, [userId]);

  return (
    <DashboardLayout>
      <div className="p-4 md:p-8 max-w-6xl mx-auto space-y-8">
        {/* Welcome */}
        <div className="rounded-2xl border border-border bg-card p-6 md:p-8">
          <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
            <div>
              <h1 className="text-2xl font-bold md:text-3xl">
                Welcome back! 👋
              </h1>
              <p className="mt-1 text-muted-foreground">
                Keep up the great work on your IELTS journey.
              </p>
            </div>
            <div className="flex items-center gap-2 rounded-xl bg-warning/10 px-4 py-2.5 text-warning">
              <Flame className="h-5 w-5" />
              <span className="text-lg font-bold">{streak}</span>
              <span className="text-sm font-medium">day streak</span>
            </div>
          </div>
        </div>

        {/* Quick Actions */}
        <div className="grid gap-4 sm:grid-cols-3">
          {quickActions.map((action) => (
            <Link
              key={action.path}
              to={action.path}
              className={`group rounded-2xl border border-border bg-gradient-to-br ${action.gradient} bg-card p-6 transition-all hover:-translate-y-1 hover:shadow-lg`}
            >
              <div className={`mb-4 flex h-12 w-12 items-center justify-center rounded-xl ${action.iconBg}`}>
                <action.icon className="h-6 w-6" />
              </div>
              <h3 className="text-lg font-bold text-foreground">{action.label}</h3>
              <p className="mt-1 text-sm text-muted-foreground">{action.description}</p>
            </Link>
          ))}
        </div>

        {/* Charts & Activity */}
        <div className="grid gap-6 lg:grid-cols-5">
          {/* Progress Chart */}
          <div className="rounded-2xl border border-border bg-card p-6 lg:col-span-3">
            <BandScoreChart />
          </div>

          {/* Recent Activity */}
          <div className="rounded-2xl border border-border bg-card p-6 lg:col-span-2">
            <div className="mb-4 flex items-center gap-2">
              <Clock className="h-5 w-5 text-primary" />
              <h2 className="text-lg font-bold">Recent Activity</h2>
            </div>
            <RecentActivity />
          </div>
        </div>

        {/* Study Heatmap */}
        <StudyHeatmap />
      </div>
    </DashboardLayout>
  );
};

export default Dashboard;
