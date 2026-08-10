import { listUserTestSessions } from "@/lib/tauri";

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
  const sessions = await listUserTestSessions(userId);

  return sessions
    .sort((a, b) => new Date(b.last_active_at).getTime() - new Date(a.last_active_at).getTime())
    .slice(0, limit)
    .map((row) => ({
      id: row.id,
      test_type: row.test_type,
      test_id: row.test_id,
      status: row.status,
      score_band: row.score_band !== null ? Number(row.score_band) : null,
      progress_percent: row.progress_percent,
      started_at: row.started_at,
      completed_at: row.completed_at,
      last_active_at: row.last_active_at,
      attempt_number: row.attempt_number,
    }));
}
