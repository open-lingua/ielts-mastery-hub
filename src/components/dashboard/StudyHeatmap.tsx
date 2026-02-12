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

function generateCalendarData(year: number): DayData[] {
  const startDate = new Date(year, 0, 1);
  const endDate = new Date(year, 11, 31);
  const days: DayData[] = [];
  const getRandomInt = (min: number, max: number) => Math.floor(Math.random() * (max - min + 1)) + min;
  const getWeightedLevel = () => {
    const rand = Math.random();
    if (rand < 0.4) return 0;
    if (rand < 0.65) return 1;
    if (rand < 0.85) return 2;
    if (rand < 0.95) return 3;
    return 4;
  };

  const streaks = Array.from({ length: 10 }, () => ({
    start: getRandomInt(0, 365),
    length: getRandomInt(3, 14),
    intensity: getRandomInt(2, 4),
  }));

  const currentLoopDate = new Date(startDate);
  let dayIndex = 0;

  while (currentLoopDate <= endDate) {
    let level = getWeightedLevel();
    let count = level === 0 ? 0 : getRandomInt(1, level * 5 + 3);

    streaks.forEach((streak) => {
      if (dayIndex >= streak.start && dayIndex < streak.start + streak.length) {
        level = Math.max(level, streak.intensity);
        count = Math.max(count, getRandomInt(5, 20));
      }
    });

    days.push({
      date: new Date(currentLoopDate),
      dateString: currentLoopDate.toISOString().split("T")[0],
      count,
      level,
    });

    currentLoopDate.setDate(currentLoopDate.getDate() + 1);
    dayIndex++;
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

  if (currentWeek.some((d) => d !== null)) {
    weeks.push(currentWeek);
  }

  return weeks;
}

function calculateLongestStreak(days: DayData[]): number {
  let max = 0;
  let current = 0;
  for (const day of days) {
    if (day.count > 0) {
      current++;
      max = Math.max(max, current);
    } else {
      current = 0;
    }
  }
  return max;
}

const StudyHeatmap: React.FC = () => {
  const currentYear = new Date().getFullYear();
  const [selectedYear, setSelectedYear] = useState(String(currentYear));
  const [loading, setLoading] = useState(true);
  const [rawDays, setRawDays] = useState<DayData[]>([]);
  const [weeks, setWeeks] = useState<(DayData | null)[][]>([]);
  const [total, setTotal] = useState(0);

  useEffect(() => {
    setLoading(true);
    const timer = setTimeout(() => {
      const data = generateCalendarData(Number(selectedYear));
      setRawDays(data);
      setWeeks(groupDaysIntoWeeks(data));
      setTotal(data.reduce((acc, d) => acc + d.count, 0));
      setLoading(false);
    }, 500);
    return () => clearTimeout(timer);
  }, [selectedYear]);

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

  const years = [currentYear, currentYear - 1, currentYear - 2];

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
            {years.map((y) => (
              <SelectItem key={y} value={String(y)}>
                {y}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </CardHeader>

      <CardContent className="space-y-4">
        {/* Heatmap Grid */}
        <div className="overflow-x-auto pb-2">
          <div className="min-w-[720px]">
            <div className="flex gap-[3px] relative pt-5">
              {/* Month Labels */}
              {monthLabels.map((month) => (
                <span
                  key={month.name + month.index}
                  className="absolute top-0 text-[10px] text-muted-foreground"
                  style={{ left: `${month.index * 13}px` }}
                >
                  {month.name}
                </span>
              ))}

              {/* Weeks */}
              <TooltipProvider delayDuration={100}>
                {loading
                  ? Array.from({ length: 53 }).map((_, i) => (
                      <div key={i} className="flex flex-col gap-[3px]">
                        {Array.from({ length: 7 }).map((_, j) => (
                          <Skeleton
                            key={j}
                            className="w-[10px] h-[10px] rounded-sm"
                            style={{ animationDelay: `${(i * 7 + j) * 5}ms` }}
                          />
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
                          if (!day)
                            return (
                              <div
                                key={`empty-${dayIndex}`}
                                className="w-[10px] h-[10px]"
                              />
                            );
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
                                <p className="font-semibold">
                                  {day.count === 0 ? "No" : day.count} sessions
                                </p>
                                <p className="text-muted-foreground text-xs">
                                  {day.date.toLocaleDateString("en-US", {
                                    weekday: "short",
                                    month: "short",
                                    day: "numeric",
                                    year: "numeric",
                                  })}
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

        {/* Footer: Legend + Stats */}
        <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between border-t border-border pt-4 text-sm text-muted-foreground">
          <div className="flex items-center gap-2">
            <span>Less</span>
            <div className="flex gap-1">
              {[0, 1, 2, 3, 4].map((level) => (
                <div
                  key={level}
                  className={cn("w-[10px] h-[10px] rounded-sm", INTENSITY_CLASSES[level])}
                />
              ))}
            </div>
            <span>More</span>
          </div>
          <div className="flex items-center gap-4 text-xs">
            <span>
              Total: <strong className="text-foreground">{total.toLocaleString()}</strong> sessions
            </span>
            <span>
              Longest Streak: <strong className="text-foreground">{longestStreak}</strong> days
            </span>
          </div>
        </div>
      </CardContent>
    </Card>
  );
};

export default StudyHeatmap;
