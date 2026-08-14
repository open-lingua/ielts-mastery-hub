import type { ListeningQuestion, ListeningSection, ListeningTest } from "@/data/listeningTestData";
import { getAnonId } from "@/lib/anonId";
import {
  getListeningTest,
  listListeningQuestionGroups,
  listListeningQuestions,
  listListeningSections,
  type ListeningQuestionGroup as TauriListeningGroup,
  type ListeningQuestion as TauriListeningQuestion,
} from "@/lib/tauri";
import { calculateListeningBandScore, isAnswerCorrect } from "@/utils/ieltsGrading";

export async function submitListeningTest(
  sessionId: string,
  test: ListeningTest,
  answers: Record<string, string>
): Promise<{ rawScore: number; bandScore: number }> {
  const { completeSession } = await import("./practiceLibraryService");
  const allQuestions = test.sections.flatMap((s) => s.questions);
  const rawScore = allQuestions.filter((q) => isAnswerCorrect(answers[q.id], q.answer)).length;
  const bandScore = calculateListeningBandScore(rawScore);

  await completeSession(sessionId, bandScore, { userAnswers: answers });
  return { rawScore, bandScore };
}

function mapDBQuestionToListening(q: TauriListeningQuestion, group: TauriListeningGroup): ListeningQuestion {
  const options: Array<{ id: string; text: string; isCorrect: boolean }> = q.options
    ? (JSON.parse(q.options) as any[])
    : [];
  const matchingPairs: Array<{ id: string; left: string; right: string }> = q.matching_pairs
    ? (JSON.parse(q.matching_pairs) as any[])
    : [];

  if (group.question_type === "multiple-choice") {
    return {
      id: q.id,
      type: "mcq",
      text: q.text,
      answer: q.answer || "",
      options: options.map((o) => (typeof o === "string" ? o : o.text)),
    };
  }

  if (
    group.question_type === "matching" ||
    group.question_type === "matching-features" ||
    group.question_type === "matching-information"
  ) {
    const leftParts = matchingPairs.map((p) => p.left).join(", ");
    const rightOptions = matchingPairs.map((p) => p.right);
    return {
      id: q.id,
      type: "matching",
      text: q.text,
      answer: q.answer || "",
      matchOptions: {
        left: leftParts || q.text,
        right: rightOptions.length > 0 ? rightOptions : options.map((o) => (typeof o === "string" ? o : o.text)),
      },
    };
  }

  // Default: fill-in-the-blank
  const wordLimit = group.word_limit ? parseInt(group.word_limit, 10) || undefined : undefined;
  return {
    id: q.id,
    type: "fill",
    text: q.text,
    answer: q.answer || "",
    wordLimit,
  };
}

function buildContextFromSectionNumber(num: number): string {
  const contexts = ["Social / Everyday", "Social / Monologue", "Educational / Discussion", "Academic / Lecture"];
  return contexts[num - 1] || "General";
}

export async function fetchListeningTestForPractice(testId: string): Promise<ListeningTest> {
  const userId = getAnonId();

  const [test, allSections, allGroups, allQuestions] = await Promise.all([
    getListeningTest(testId, userId),
    listListeningSections(userId),
    listListeningQuestionGroups(userId),
    listListeningQuestions(userId),
  ]);

  if (!test) throw new Error("Listening test not found");

  const sections = allSections.filter((s) => s.test_id === testId).sort((a, b) => a.section_number - b.section_number);

  const sectionIds = new Set(sections.map((s) => s.id));
  const groups = allGroups.filter((g) => sectionIds.has(g.section_id)).sort((a, b) => a.group_order - b.group_order);

  const groupIds = new Set(groups.map((g) => g.id));
  const questions = allQuestions
    .filter((q) => groupIds.has(q.group_id))
    .sort((a, b) => a.question_order - b.question_order);

  // Build maps
  const questionsByGroup = new Map<string, typeof questions>();
  for (const q of questions) {
    if (!questionsByGroup.has(q.group_id)) questionsByGroup.set(q.group_id, []);
    questionsByGroup.get(q.group_id)?.push(q);
  }

  const groupsBySection = new Map<string, typeof groups>();
  for (const g of groups) {
    if (!groupsBySection.has(g.section_id)) groupsBySection.set(g.section_id, []);
    groupsBySection.get(g.section_id)?.push(g);
  }

  const uiSections: ListeningSection[] = sections.map((s) => {
    const sectionGroups = groupsBySection.get(s.id) || [];
    const flatQuestions: ListeningQuestion[] = [];

    for (const g of sectionGroups) {
      const groupQs = questionsByGroup.get(g.id) || [];
      for (const q of groupQs) {
        flatQuestions.push(mapDBQuestionToListening(q, g));
      }
    }

    const instructions = sectionGroups[0]?.instructions || "Answer the questions below.";

    return {
      id: s.section_number,
      title: s.title || `Section ${s.section_number}`,
      subtitle: "",
      context: buildContextFromSectionNumber(s.section_number),
      instructions,
      audioUrl: s.audio_url || undefined,
      questions: flatQuestions,
    };
  });

  const durationMatch = test.duration?.match(/(\d+)/);
  const totalTime = durationMatch ? parseInt(durationMatch[1], 10) * 60 : 1800;

  return {
    id: test.id,
    title: test.title,
    totalTime,
    sections: uiSections,
  };
}
