import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { BookOpen, Headphones, PenTool, Clock, CheckCircle, ChevronRight, AlertCircle, PlayCircle } from "lucide-react";
import { motion } from "framer-motion";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { useAuth } from "@/contexts/AuthContext";
import { fetchRecentActivity, type RecentActivity as ActivityItem } from "@/services/dashboardService";
import { formatDistanceToNow } from "date-fns";

const typeConfig: Record<string, { label: string; icon: React.FC<{ className?: string }>; color: string }> = {
  reading: { label: "Reading Practice", icon: BookOpen, color: "text-success bg-success/10" },
  listening: { label: "Listening Practice", icon: Headphones, color: "text-warning bg-warning/10" },
  writing: { label: "Writing Practice", icon: PenTool, color: "text-primary bg-primary/10" },
};

const statusBadge: Record<string, { label: string; className: string }> = {
  completed: { label: "Completed", className: "bg-success/15 text-success border-success/30" },
  in_progress: { label: "In Progress", className: "bg-warning/15 text-warning border-warning/30" },
  abandoned: { label: "Abandoned", className: "bg-muted text-muted-foreground border-border" },
};

function getActivityLink(activity: ActivityItem): string {
  const base = `/${activity.test_type}`;
  if (activity.status === "in_progress") return `${base}?testId=${activity.test_id}`;
  return `${base}?testId=${activity.test_id}`;
}

const RecentActivity: React.FC = () => {
  const { user } = useAuth();
  const [activities, setActivities] = useState<ActivityItem[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!user) {
      setIsLoading(false);
      return;
    }
    fetchRecentActivity(user.id)
      .then(setActivities)
      .catch((e) => setError(e.message))
      .finally(() => setIsLoading(false));
  }, [user]);

  if (isLoading) {
    return (
      <div className="space-y-3">
        {Array.from({ length: 4 }).map((_, i) => (
          <div key={i} className="flex items-center gap-3 rounded-xl bg-secondary/50 p-4">
            <Skeleton className="h-10 w-10 rounded-lg shrink-0" />
            <div className="flex-1 space-y-2">
              <Skeleton className="h-4 w-3/4" />
              <Skeleton className="h-3 w-1/2" />
            </div>
            <Skeleton className="h-6 w-14 rounded-md" />
          </div>
        ))}
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex items-center gap-2 text-sm text-destructive p-4 rounded-xl bg-destructive/5">
        <AlertCircle className="h-4 w-4 shrink-0" />
        <span>Failed to load activity.</span>
      </div>
    );
  }

  if (!user || activities.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center py-8 text-center">
        <Clock className="h-10 w-10 text-muted-foreground/40 mb-3" />
        <p className="text-sm text-muted-foreground">No recent activity yet.</p>
        <p className="text-xs text-muted-foreground mt-1">Start a practice test to see your progress here!</p>
      </div>
    );
  }

  return (
    <div className="space-y-2">
      {activities.map((activity, i) => {
        const config = typeConfig[activity.test_type] || typeConfig.reading;
        const badge = statusBadge[activity.status] || statusBadge.in_progress;
        const Icon = config.icon;
        const timeAgo = formatDistanceToNow(new Date(activity.last_active_at), { addSuffix: true });

        return (
          <motion.div
            key={activity.id}
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.2, delay: i * 0.05 }}
          >
            <Link
              to={getActivityLink(activity)}
              className="group flex items-center gap-3 rounded-xl bg-secondary/50 p-3.5 transition-colors hover:bg-secondary"
            >
              <div className={`flex h-10 w-10 items-center justify-center rounded-lg shrink-0 ${config.color}`}>
                <Icon className="h-5 w-5" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm font-semibold text-foreground truncate">
                  {config.label}
                  {activity.attempt_number > 1 && (
                    <span className="text-muted-foreground font-normal"> · Attempt {activity.attempt_number}</span>
                  )}
                </p>
                <p className="text-xs text-muted-foreground">{timeAgo}</p>
              </div>
              <div className="flex items-center gap-2 shrink-0">
                {activity.status === "completed" && activity.score_band !== null ? (
                  <div className="flex items-center gap-1.5">
                    <CheckCircle className="h-3.5 w-3.5 text-success" />
                    <span className="text-sm font-bold text-foreground">{activity.score_band}</span>
                  </div>
                ) : activity.status === "in_progress" ? (
                  <Badge variant="outline" className={badge.className + " text-xs"}>
                    <PlayCircle className="h-3 w-3 mr-1" />
                    {activity.progress_percent}%
                  </Badge>
                ) : (
                  <Badge variant="outline" className={badge.className + " text-xs"}>
                    {badge.label}
                  </Badge>
                )}
                <ChevronRight className="h-4 w-4 text-muted-foreground opacity-0 group-hover:opacity-100 transition-opacity" />
              </div>
            </Link>
          </motion.div>
        );
      })}
    </div>
  );
};

export default RecentActivity;
