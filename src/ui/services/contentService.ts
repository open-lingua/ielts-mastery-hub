import { getAnonId } from "@/lib/anonId";
import {
  deleteListeningTest,
  deleteReadingTest,
  deleteWritingTest,
  type ExportResult,
  exportTestToZip,
  listListeningQuestionGroups,
  listListeningQuestions,
  listListeningSections,
  listListeningTests,
  listReadingPassages,
  listReadingQuestionGroups,
  listReadingQuestions,
  listReadingTests,
  listWritingTasks,
  listWritingTests,
} from "@/lib/tauri";

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
  const userId = getAnonId();

  const [
    readingTests,
    passages,
    qGroups,
    questions,
    writingTests,
    tasks,
    listeningTests,
    sections,
    lGroups,
    lQuestions,
  ] = await Promise.all([
    listReadingTests(userId),
    listReadingPassages(userId),
    listReadingQuestionGroups(userId),
    listReadingQuestions(userId),
    listWritingTests(userId),
    listWritingTasks(userId),
    listListeningTests(userId),
    listListeningSections(userId),
    listListeningQuestionGroups(userId),
    listListeningQuestions(userId),
  ]);

  const items: ContentItem[] = [];

  // Build passage → groups → questions counts for reading
  const questionsByGroup = new Map<string, number>();
  for (const q of questions) {
    questionsByGroup.set(q.group_id, (questionsByGroup.get(q.group_id) ?? 0) + 1);
  }
  const groupsByPassage = new Map<string, number>();
  for (const g of qGroups) {
    groupsByPassage.set(g.passage_id, (groupsByPassage.get(g.passage_id) ?? 0) + (questionsByGroup.get(g.id) ?? 0));
  }
  const questionsByTest = new Map<string, number>();
  for (const p of passages) {
    questionsByTest.set(p.test_id, (questionsByTest.get(p.test_id) ?? 0) + (groupsByPassage.get(p.id) ?? 0));
  }

  for (const r of readingTests) {
    items.push({
      id: r.id,
      title: r.title || "Untitled Reading Test",
      module: "Reading",
      status: normalizeStatus(r.status),
      questions: questionsByTest.get(r.id) ?? 0,
      lastEdited: formatRelativeTime(r.updated_at),
      band: r.difficulty || "7",
      createdAt: r.created_at,
    });
  }

  // Writing: task count per test
  const tasksByTest = new Map<string, number>();
  for (const t of tasks) {
    tasksByTest.set(t.test_id, (tasksByTest.get(t.test_id) ?? 0) + 1);
  }
  const taskDifficultyByTest = new Map<string, string>();
  for (const t of tasks.sort((a, b) => a.task_number - b.task_number)) {
    if (!taskDifficultyByTest.has(t.test_id)) {
      taskDifficultyByTest.set(t.test_id, t.difficulty);
    }
  }

  for (const w of writingTests) {
    items.push({
      id: w.id,
      title: w.title || "Untitled Writing Test",
      module: "Writing",
      status: normalizeStatus(w.status),
      questions: tasksByTest.get(w.id) ?? 0,
      lastEdited: formatRelativeTime(w.updated_at),
      band: taskDifficultyByTest.get(w.id) || "7",
      createdAt: w.created_at,
    });
  }

  // Listening: section → groups → questions counts
  const lQuestionsByGroup = new Map<string, number>();
  for (const q of lQuestions) {
    lQuestionsByGroup.set(q.group_id, (lQuestionsByGroup.get(q.group_id) ?? 0) + 1);
  }
  const lGroupsBySection = new Map<string, number>();
  for (const g of lGroups) {
    lGroupsBySection.set(g.section_id, (lGroupsBySection.get(g.section_id) ?? 0) + (lQuestionsByGroup.get(g.id) ?? 0));
  }
  const lQuestionsByTest = new Map<string, number>();
  for (const s of sections) {
    lQuestionsByTest.set(s.test_id, (lQuestionsByTest.get(s.test_id) ?? 0) + (lGroupsBySection.get(s.id) ?? 0));
  }

  for (const l of listeningTests) {
    items.push({
      id: l.id,
      title: l.title || "Untitled Listening Test",
      module: "Listening",
      status: normalizeStatus(l.status),
      questions: lQuestionsByTest.get(l.id) ?? 0,
      lastEdited: formatRelativeTime(l.updated_at),
      band: l.difficulty || "7",
      createdAt: l.created_at,
    });
  }

  items.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
  return items;
}

export async function deleteContent(id: string, module: ContentModule): Promise<void> {
  const userId = getAnonId();
  if (module === "Reading") return deleteReadingTest(id, userId);
  if (module === "Writing") return deleteWritingTest(id, userId);
  return deleteListeningTest(id, userId);
}

export async function exportContent(item: ContentItem): Promise<ExportResult> {
  const userId = getAnonId();
  const kind = item.module.toLowerCase() as "reading" | "writing" | "listening";
  return exportTestToZip(userId, kind, item.id);
}
