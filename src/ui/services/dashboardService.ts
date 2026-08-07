import { supabase } from "@/integrations/supabase/client";

export interface RecentActivity {
  id: string;
  test_type: string;
  test_id: string;
  status: string;
  score_band: number | null;
  progress_percent: number;
  started_at: string;
  completed_at: string | null;
  last_active_at: string;
  attempt_number: number;
}

export async function fetchRecentActivity(
  userId: string,
  limit: number = 5
): Promise<RecentActivity[]> {
  const { data, error } = await supabase
    .from("user_test_sessions")
    .select(
      "id, test_type, test_id, status, score_band, progress_percent, started_at, completed_at, last_active_at, attempt_number"
    )
    .eq("user_id", userId)
    .order("last_active_at", { ascending: false })
    .limit(limit);

  if (error) throw error;

  return (data ?? []).map((row) => ({
    ...row,
    score_band: row.score_band ? Number(row.score_band) : null,
  }));
}
