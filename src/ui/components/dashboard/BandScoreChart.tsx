import { format } from "date-fns";
import { TrendingUp } from "lucide-react";
import type React from "react";
import { useEffect, useMemo, useState } from "react";
import { CartesianGrid, Legend, Line, LineChart, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { Skeleton } from "@/components/ui/skeleton";
import { getAnonId } from "@/lib/anonId";
import { listUserTestSessions } from "@/lib/tauri";

interface SessionRow {
  test_type: string;
  score_band: number | null;
  completed_at: string | null;
}

interface ChartPoint {
  date: string;
  reading?: number;
  listening?: number;
  writing?: number;
}

const MODULE_COLORS: Record<string, string> = {
  reading: "hsl(var(--success))",
  listening: "hsl(var(--warning))",
  writing: "hsl(var(--primary))",
};

const BandScoreChart: React.FC = () => {
  const userId = getAnonId();
  const [sessions, setSessions] = useState<SessionRow[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    listUserTestSessions(userId)
      .then((all) => {
        const filtered = all
          .filter((s) => s.status === "completed" && s.score_band !== null && s.completed_at !== null)
          .sort((a, b) => new Date(a.completed_at!).getTime() - new Date(b.completed_at!).getTime())
          .map((s) => ({
            test_type: s.test_type,
            score_band: s.score_band !== null ? Number(s.score_band) : null,
            completed_at: s.completed_at,
          }));
        setSessions(filtered);
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, [userId]);

  const chartData = useMemo(() => {
    const dateMap = new Map<string, ChartPoint>();
    sessions.forEach((s) => {
      if (!s.completed_at || s.score_band === null) return;
      const dateKey = format(new Date(s.completed_at), "MMM d");
      const existing = dateMap.get(dateKey) || { date: dateKey };
      existing[s.test_type as keyof Omit<ChartPoint, "date">] = Number(s.score_band);
      dateMap.set(dateKey, existing);
    });
    return Array.from(dateMap.values());
  }, [sessions]);

  const activeModules = useMemo(() => {
    const types = new Set(sessions.map((s) => s.test_type));
    return ["reading", "listening", "writing"].filter((t) => types.has(t));
  }, [sessions]);

  if (loading) {
    return (
      <div className="space-y-3">
        <div className="flex items-center gap-2 mb-4">
          <TrendingUp className="h-5 w-5 text-primary" />
          <h2 className="text-lg font-bold">Band Score Progress</h2>
        </div>
        <Skeleton className="h-64 w-full rounded-xl" />
      </div>
    );
  }

  return (
    <>
      <div className="mb-4 flex items-center gap-2">
        <TrendingUp className="h-5 w-5 text-primary" />
        <h2 className="text-lg font-bold">Band Score Progress</h2>
      </div>
      <div className="h-64">
        {chartData.length > 0 ? (
          <ResponsiveContainer width="100%" height="100%">
            <LineChart data={chartData}>
              <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" />
              <XAxis dataKey="date" tick={{ fontSize: 12, fill: "hsl(var(--muted-foreground))" }} />
              <YAxis
                domain={[0, 9]}
                ticks={[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]}
                tick={{ fontSize: 12, fill: "hsl(var(--muted-foreground))" }}
              />
              <Tooltip
                contentStyle={{
                  backgroundColor: "hsl(var(--card))",
                  border: "1px solid hsl(var(--border))",
                  borderRadius: "0.75rem",
                  color: "hsl(var(--foreground))",
                }}
              />
              {activeModules.length > 1 && (
                <Legend
                  wrapperStyle={{ fontSize: 12 }}
                  formatter={(value: string) => value.charAt(0).toUpperCase() + value.slice(1)}
                />
              )}
              {activeModules.includes("reading") && (
                <Line
                  type="monotone"
                  dataKey="reading"
                  name="Reading"
                  stroke={MODULE_COLORS.reading}
                  strokeWidth={2.5}
                  dot={{ r: 4, fill: MODULE_COLORS.reading }}
                  activeDot={{ r: 6 }}
                  connectNulls
                />
              )}
              {activeModules.includes("listening") && (
                <Line
                  type="monotone"
                  dataKey="listening"
                  name="Listening"
                  stroke={MODULE_COLORS.listening}
                  strokeWidth={2.5}
                  dot={{ r: 4, fill: MODULE_COLORS.listening }}
                  activeDot={{ r: 6 }}
                  connectNulls
                />
              )}
              {activeModules.includes("writing") && (
                <Line
                  type="monotone"
                  dataKey="writing"
                  name="Writing"
                  stroke={MODULE_COLORS.writing}
                  strokeWidth={2.5}
                  dot={{ r: 4, fill: MODULE_COLORS.writing }}
                  activeDot={{ r: 6 }}
                  connectNulls
                />
              )}
            </LineChart>
          </ResponsiveContainer>
        ) : (
          <div className="flex flex-col items-center justify-center h-full text-center">
            <TrendingUp className="h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-sm text-muted-foreground">No scores yet.</p>
            <p className="text-xs text-muted-foreground mt-1">Complete a test to see your band score progress here.</p>
          </div>
        )}
      </div>
    </>
  );
};

export default BandScoreChart;
