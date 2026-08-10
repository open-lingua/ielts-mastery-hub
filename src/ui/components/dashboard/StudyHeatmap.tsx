import React, { useState, useEffect, useMemo } from "react";
import { motion } from "framer-motion";
import { CalendarDays } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/components/ui/tooltip";
import { Skeleton } from "@/components/ui/skeleton";
import { cn } from "@/lib/utils";
import { getAnonId } from "@/lib/anonId";
import { listUserTestSessions } from "@/lib/tauri";

const MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

const INTENSITY_CLASSES: Record<number, string> = {
  0: "bg-secondary",
  1: "bg-emerald-200 dark:bg-emerald-900/60",
  2: "bg-emerald-300 dark:bg-emerald-700",
  3: "bg-emerald-500 dark:bg-emerald-500",
  4: "bg-emerald-700 dark:bg-emerald-300",
};

interface DayData {
  date: Date;
  dateString: string;
  count: number;
  level: number;
}

function countToLevel(count: number): number {
  if (count === 0) return 0;
  if (count === 1) return 1;
  if (count <= 3) return 2;
  if (count <= 6) return 3;
  return 4;
}

function buildCalendar(year: number, countMap: Record<string, number>): DayData[] {
  const days: DayData[] = [];
  const cursor = new Date(year, 0, 1);
  const end = new Date(year, 11, 31);
  while (cursor <= end) {
    const dateString = cursor.toISOString().split("T")[0];
    const count = countMap[dateString] || 0;
    days.push({ date: new Date(cursor), dateString, count, level: countToLevel(count) });
    cursor.setDate(cursor.getDate() + 1);
  }
  return days;
}

function groupDaysIntoWeeks(days: DayData[]): (DayData | null)[][] {
  const weeks: (DayData | null)[][] = [];
  let currentWeek: (DayData | null)[] = new Array(7).fill(null);
  days.forEach((day) => {
    const dayOfWeek = day.date.getDay();
    currentWeek[dayOfWeek] = day;
    if (dayOfWeek === 6) {
      weeks.push(currentWeek);
      currentWeek = new Array(7).fill(null);
    }
  });
  if (currentWeek.some((d) => d !== null)) weeks.push(currentWeek);
  return weeks;
}

function calculateLongestStreak(days: DayData[]): number {
  let max = 0;
  let current = 0;
  for (const day of days) {
    if (day.count > 0) { current++; max = Math.max(max, current); }
    else { current = 0; }
  }
  return max;
}

const StudyHeatmap: React.FC = () => {
  const currentYear = new Date().getFullYear();
  const userId = getAnonId();
  const [selectedYear, setSelectedYear] = useState(String(currentYear));
  const [loading, setLoading] = useState(true);
  const [rawDays, setRawDays] = useState<DayData[]>([]);
  const [weeks, setWeeks] = useState<(DayData | null)[][]>([]);
  const [total, setTotal] = useState(0);
  const [availableYears, setAvailableYears] = useState<number[]>([currentYear]);
  const [allStartDates, setAllStartDates] = useState<string[]>([]);

  // Load all sessions once
  useEffect(() => {
    listUserTestSessions(userId)
      .then((sessions) => {
        const dates = sessions.map((s) => s.started_at);
        setAllStartDates(dates);

        const yearSet = new Set<number>(dates.map((d) => new Date(d).getFullYear()));
        yearSet.add(currentYear);
        setAvailableYears(Array.from(yearSet).sort((a, b) => b - a));
      })
      .catch(() => {});
  }, [userId, currentYear]);

  // Build calendar when year or data changes
  useEffect(() => {
    setLoading(true);
    const yearNum = Number(selectedYear);
    const countMap: Record<string, number> = {};
    allStartDates.forEach((d) => {
      const date = new Date(d);
      if (date.getFullYear() !== yearNum) return;
      const key = date.toISOString().split("T")[0];
      countMap[key] = (countMap[key] || 0) + 1;
    });

    const days = buildCalendar(yearNum, countMap);
    setRawDays(days);
    setWeeks(groupDaysIntoWeeks(days));
    setTotal(days.reduce((acc, d) => acc + d.count, 0));
    setLoading(false);
  }, [selectedYear, allStartDates]);

  const longestStreak = useMemo(() => calculateLongestStreak(rawDays), [rawDays]);

  const monthLabels = useMemo(() => {
    const labels: { name: string; index: number }[] = [];
    let lastMonth = -1;
    weeks.forEach((week, weekIndex) => {
      const firstDay = week.find((d) => d !== null);
      if (firstDay) {
        const month = firstDay.date.getMonth();
        if (month !== lastMonth) {
          labels.push({ name: MONTHS[month], index: weekIndex });
          lastMonth = month;
        }
      }
    });
    return labels;
  }, [weeks]);

  return (
    <Card className="overflow-hidden">
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-4">
        <div className="flex items-center gap-2">
          <CalendarDays className="h-5 w-5 text-primary" />
          <CardTitle className="text-lg font-bold">Consistency Tracker</CardTitle>
        </div>
        <Select value={selectedYear} onValueChange={setSelectedYear}>
          <SelectTrigger className="w-[100px] h-8 text-sm">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            {availableYears.map((y) => (
              <SelectItem key={y} value={String(y)}>{y}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </CardHeader>

      <CardContent className="space-y-4">
        <div className="overflow-x-auto pb-2">
          <div className="min-w-[720px]">
            <div className="flex gap-[3px] relative pt-5">
              {monthLabels.map((month) => (
                <span
                  key={month.name + month.index}
                  className="absolute top-0 text-[10px] text-muted-foreground"
                  style={{ left: `${month.index * 13}px` }}
                >
                  {month.name}
                </span>
              ))}
              <TooltipProvider delayDuration={100}>
                {loading
                  ? Array.from({ length: 53 }).map((_, i) => (
                      <div key={i} className="flex flex-col gap-[3px]">
                        {Array.from({ length: 7 }).map((_, j) => (
                          <Skeleton key={j} className="w-[10px] h-[10px] rounded-sm" style={{ animationDelay: `${(i * 7 + j) * 5}ms` }} />
                        ))}
                      </div>
                    ))
                  : weeks.map((week, weekIndex) => (
                      <motion.div
                        key={weekIndex}
                        initial={{ opacity: 0, y: 4 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: weekIndex * 0.008 }}
                        className="flex flex-col gap-[3px]"
                      >
                        {week.map((day, dayIndex) => {
                          if (!day) return <div key={`empty-${dayIndex}`} className="w-[10px] h-[10px]" />;
                          return (
                            <Tooltip key={day.dateString}>
                              <TooltipTrigger asChild>
                                <motion.div
                                  whileHover={{ scale: 1.3 }}
                                  className={cn(
                                    "w-[10px] h-[10px] rounded-sm cursor-pointer border border-transparent hover:border-muted-foreground/30",
                                    INTENSITY_CLASSES[day.level]
                                  )}
                                />
                              </TooltipTrigger>
                              <TooltipContent className="text-center">
                                <p className="font-semibold">{day.count === 0 ? "No" : day.count} sessions</p>
                                <p className="text-muted-foreground text-xs">
                                  {day.date.toLocaleDateString("en-US", { weekday: "short", month: "short", day: "numeric", year: "numeric" })}
                                </p>
                              </TooltipContent>
                            </Tooltip>
                          );
                        })}
                      </motion.div>
                    ))}
              </TooltipProvider>
            </div>
          </div>
        </div>

        <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between border-t border-border pt-4 text-sm text-muted-foreground">
          <div className="flex items-center gap-2">
            <span>Less</span>
            <div className="flex gap-1">
              {[0, 1, 2, 3, 4].map((level) => (
                <div key={level} className={cn("w-[10px] h-[10px] rounded-sm", INTENSITY_CLASSES[level])} />
              ))}
            </div>
            <span>More</span>
          </div>
          <div className="flex items-center gap-4 text-xs">
            <span>Total: <strong className="text-foreground">{total.toLocaleString()}</strong> sessions</span>
            <span>Longest Streak: <strong className="text-foreground">{longestStreak}</strong> days</span>
          </div>
        </div>
      </CardContent>
    </Card>
  );
};

export default StudyHeatmap;
