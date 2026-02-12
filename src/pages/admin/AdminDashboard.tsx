import React from "react";
import { Link } from "react-router-dom";
import { motion } from "framer-motion";
import {
  FileText,
  Users,
  TrendingUp,
  PlusCircle,
  Clock,
  CheckCircle2,
  Edit3,
} from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { AdminLayout } from "@/components/AdminLayout";
import { cn } from "@/lib/utils";

const stats = [
  { label: "Total Tests", value: "24", icon: FileText, change: "+3 this week" },
  { label: "Published", value: "18", icon: CheckCircle2, change: "75% of total" },
  { label: "Active Students", value: "342", icon: Users, change: "+12% growth" },
  { label: "Avg. Band Score", value: "7.2", icon: TrendingUp, change: "+0.3 vs last month" },
];

const recentDrafts = [
  { id: 101, title: "The Future of AI", module: "Reading", status: "Draft", lastEdited: "2 mins ago" },
  { id: 102, title: "Section 2: Campus Tour", module: "Listening", status: "Published", lastEdited: "1 day ago" },
  { id: 103, title: "Task 2: Climate Change Essay", module: "Writing", status: "Draft", lastEdited: "3 hours ago" },
  { id: 104, title: "Academic Reading: Coral Reefs", module: "Reading", status: "Published", lastEdited: "2 days ago" },
];

const AdminDashboard: React.FC = () => {
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
          {stats.map((stat, i) => (
            <motion.div
              key={stat.label}
              initial={{ opacity: 0, y: 12 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.05 }}
            >
              <Card>
                <CardContent className="p-5">
                  <div className="flex items-center justify-between mb-3">
                    <span className="text-xs font-medium text-muted-foreground uppercase tracking-wider">{stat.label}</span>
                    <stat.icon className="h-4 w-4 text-violet-500" />
                  </div>
                  <p className="text-2xl font-bold">{stat.value}</p>
                  <p className="text-xs text-muted-foreground mt-1">{stat.change}</p>
                </CardContent>
              </Card>
            </motion.div>
          ))}
        </div>

        {/* Recent Drafts */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-4">
            <CardTitle className="text-lg">Recent Content</CardTitle>
            <Button variant="ghost" size="sm" asChild>
              <Link to="/admin/content">View all</Link>
            </Button>
          </CardHeader>
          <CardContent className="p-0">
            <div className="divide-y divide-border">
              {recentDrafts.map((draft) => (
                <div key={draft.id} className="flex items-center justify-between px-6 py-4 hover:bg-muted/50 transition-colors">
                  <div className="flex items-center gap-4">
                    <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-violet-100 dark:bg-violet-900/30">
                      <Edit3 className="h-4 w-4 text-violet-600 dark:text-violet-400" />
                    </div>
                    <div>
                      <p className="text-sm font-semibold">{draft.title}</p>
                      <p className="text-xs text-muted-foreground">{draft.module}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-3">
                    <Badge
                      variant={draft.status === "Published" ? "default" : "secondary"}
                      className={cn(
                        draft.status === "Published" && "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400"
                      )}
                    >
                      {draft.status}
                    </Badge>
                    <span className="text-xs text-muted-foreground flex items-center gap-1">
                      <Clock className="h-3 w-3" /> {draft.lastEdited}
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </AdminLayout>
  );
};

export default AdminDashboard;
