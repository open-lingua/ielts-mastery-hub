import { supabase } from "@/integrations/supabase/client";

export type ContentModule = "Reading" | "Writing" | "Listening";
export type ContentStatus = "Draft" | "Published" | "Archived";

export interface ContentItem {
  id: string;
  title: string;
  module: ContentModule;
  status: ContentStatus;
  questions: number;
  lastEdited: string;
  band: string;
  createdAt: string;
}

function formatRelativeTime(dateStr: string): string {
  const now = Date.now();
  const then = new Date(dateStr).getTime();
  const diff = now - then;
  const mins = Math.floor(diff / 60000);
  if (mins < 1) return "just now";
  if (mins < 60) return `${mins} min${mins > 1 ? "s" : ""} ago`;
  const hours = Math.floor(mins / 60);
  if (hours < 24) return `${hours} hour${hours > 1 ? "s" : ""} ago`;
  const days = Math.floor(hours / 24);
  if (days < 7) return `${days} day${days > 1 ? "s" : ""} ago`;
  const weeks = Math.floor(days / 7);
  return `${weeks} week${weeks > 1 ? "s" : ""} ago`;
}

function normalizeStatus(s: string): ContentStatus {
  const lower = s.toLowerCase();
  if (lower === "published") return "Published";
  if (lower === "archived") return "Archived";
  return "Draft";
}

export async function fetchAllContent(): Promise<ContentItem[]> {
  const [readingRes, writingRes, listeningRes] = await Promise.all([
    supabase.from("reading_tests").select("id, title, status, difficulty, updated_at, created_at, reading_passages(id, reading_question_groups(id, reading_questions(id)))"),
    supabase.from("writing_tests").select("id, title, status, updated_at, created_at, writing_tasks(id, difficulty)"),
    supabase.from("listening_tests").select("id, title, status, difficulty, updated_at, created_at, listening_sections(id, listening_question_groups(id, listening_questions(id)))"),
  ]);

  const items: ContentItem[] = [];

  // Reading
  if (readingRes.data) {
    for (const r of readingRes.data) {
      const qCount = (r.reading_passages || []).reduce(
        (sum: number, p: any) => sum + (p.reading_question_groups || []).reduce(
          (s2: number, g: any) => s2 + (g.reading_questions || []).length, 0
        ), 0
      );
      items.push({
        id: r.id,
        title: r.title || "Untitled Reading Test",
        module: "Reading",
        status: normalizeStatus(r.status),
        questions: qCount,
        lastEdited: formatRelativeTime(r.updated_at),
        band: r.difficulty || "7",
        createdAt: r.created_at,
      });
    }
  }

  // Writing
  if (writingRes.data) {
    for (const w of writingRes.data) {
      const tasks = w.writing_tasks || [];
      items.push({
        id: w.id,
        title: w.title || "Untitled Writing Test",
        module: "Writing",
        status: normalizeStatus(w.status),
        questions: tasks.length,
        lastEdited: formatRelativeTime(w.updated_at),
        band: tasks[0]?.difficulty || "7",
        createdAt: w.created_at,
      });
    }
  }

  // Listening
  if (listeningRes.data) {
    for (const l of listeningRes.data) {
      const qCount = (l.listening_sections || []).reduce(
        (sum: number, s: any) => sum + (s.listening_question_groups || []).reduce(
          (s2: number, g: any) => s2 + (g.listening_questions || []).length, 0
        ), 0
      );
      items.push({
        id: l.id,
        title: l.title || "Untitled Listening Test",
        module: "Listening",
        status: normalizeStatus(l.status),
        questions: qCount,
        lastEdited: formatRelativeTime(l.updated_at),
        band: l.difficulty || "7",
        createdAt: l.created_at,
      });
    }
  }

  items.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
  return items;
}

export async function deleteContent(id: string, module: ContentModule): Promise<void> {
  const table = module === "Reading" ? "reading_tests"
    : module === "Writing" ? "writing_tests"
    : "listening_tests";

  const { error } = await supabase.from(table).delete().eq("id", id);
  if (error) throw error;
}
