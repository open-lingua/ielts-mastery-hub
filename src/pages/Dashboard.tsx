import React from "react";
import { Link } from "react-router-dom";
import { PenTool, BookOpen, Headphones, TrendingUp, Flame, Clock } from "lucide-react";
import { mockUser } from "@/data/mockData";
import { useAuth } from "@/contexts/AuthContext";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from "recharts";
import { DashboardLayout } from "@/components/DashboardLayout";
import StudyHeatmap from "@/components/dashboard/StudyHeatmap";
import RecentActivity from "@/components/dashboard/RecentActivity";

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

const Dashboard: React.FC = () => {
  const { user, profile, isAuthenticated } = useAuth();
  const displayName = profile?.full_name?.split(" ")[0] || user?.email?.split("@")[0] || "Future Achiever";
  const streak = isAuthenticated ? mockUser.streak : 0;
  return (
    <DashboardLayout>
      <div className="p-4 md:p-8 max-w-6xl mx-auto space-y-8">
        {/* Welcome */}
        <div className="rounded-2xl border border-border bg-card p-6 md:p-8">
          <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
            <div>
              <h1 className="text-2xl font-bold md:text-3xl">
                Welcome{isAuthenticated ? " back" : ""}, {displayName}! 👋
              </h1>
              <p className="mt-1 text-muted-foreground">
                {isAuthenticated ? "Keep up the great work on your IELTS journey." : "Explore freely — sign up anytime to save your progress."}
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
            <div className="mb-4 flex items-center gap-2">
              <TrendingUp className="h-5 w-5 text-primary" />
              <h2 className="text-lg font-bold">Band Score Progress</h2>
            </div>
            <div className="h-64">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={mockUser.recentScores}>
                  <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" />
                  <XAxis dataKey="date" tick={{ fontSize: 12, fill: "hsl(var(--muted-foreground))" }} />
                  <YAxis domain={[4, 9]} tick={{ fontSize: 12, fill: "hsl(var(--muted-foreground))" }} />
                  <Tooltip
                    contentStyle={{
                      backgroundColor: "hsl(var(--card))",
                      border: "1px solid hsl(var(--border))",
                      borderRadius: "0.75rem",
                      color: "hsl(var(--foreground))",
                    }}
                  />
                  <Line
                    type="monotone"
                    dataKey="score"
                    stroke="hsl(var(--primary))"
                    strokeWidth={3}
                    dot={{ r: 5, fill: "hsl(var(--primary))" }}
                    activeDot={{ r: 7 }}
                  />
                </LineChart>
              </ResponsiveContainer>
            </div>
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
