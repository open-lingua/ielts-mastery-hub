import { supabase } from "@/integrations/supabase/client";
import type { ListeningQuestion, ListeningSection, ListeningTest } from "@/data/listeningTestData";
import { calculateListeningBandScore, isAnswerCorrect } from "@/utils/ieltsGrading";

/**
 * Grade a completed listening test and persist the result to user_test_sessions.
 */
export async function submitListeningTest(
  sessionId: string,
  test: ListeningTest,
  answers: Record<string, string>
): Promise<{ rawScore: number; bandScore: number }> {
  const { completeSession } = await import("./practiceLibraryService");
  const allQuestions = test.sections.flatMap((s) => s.questions);
  const rawScore = allQuestions.filter((q) =>
    isAnswerCorrect(answers[q.id], q.answer)
  ).length;
  const bandScore = calculateListeningBandScore(rawScore);

  await completeSession(sessionId, bandScore, { userAnswers: answers });
  return { rawScore, bandScore };
}

interface DBQuestion {
  id: string;
  text: string;
  answer: string;
  options: { id: string; text: string; isCorrect: boolean }[];
  matchingPairs: { id: string; left: string; right: string }[];
  completionGaps: { id: string; gapText: string; answer: string }[];
  acceptedAnswers: { id: string; text: string }[];
  timestamp?: string;
}

interface DBQuestionGroup {
  type: string;
  instructions: string;
  wordLimit: string;
  questions: DBQuestion[];
}

interface DBSection {
  id: number;
  title: string;
  transcript: string;
  audioUrl: string;
  questionGroups: DBQuestionGroup[];
}

function mapDBQuestionToListening(q: DBQuestion, group: DBQuestionGroup): ListeningQuestion {
  const dbType = group.type;

  if (dbType === "multiple-choice") {
    return {
      id: q.id,
      type: "mcq",
      text: q.text,
      answer: q.answer,
      options: q.options.map((o) => o.text),
    };
  }

  if (dbType === "matching" || dbType === "matching-features" || dbType === "matching-information") {
    const leftParts = q.matchingPairs.map((p) => p.left).join(", ");
    const rightOptions = q.matchingPairs.map((p) => p.right);
    return {
      id: q.id,
      type: "matching",
      text: q.text,
      answer: q.answer,
      matchOptions: {
        left: leftParts || q.text,
        right: rightOptions.length > 0 ? rightOptions : q.options.map((o) => o.text),
      },
    };
  }

  // Default: fill-in-the-blank (completion, note-completion, sentence-completion, short-answer, etc.)
  const wordLimit = parseInt(group.wordLimit) || undefined;
  return {
    id: q.id,
    type: "fill",
    text: q.text,
    answer: q.answer,
    wordLimit,
  };
}

function buildContextFromSectionNumber(num: number): string {
  const contexts = ["Social / Everyday", "Social / Monologue", "Educational / Discussion", "Academic / Lecture"];
  return contexts[num - 1] || "General";
}

/**
 * Fetch a listening test for the practice engine.
 * Re-uses the existing fetchListeningTest from listeningService and transforms to the UI format.
 */
export async function fetchListeningTestForPractice(testId: string): Promise<ListeningTest> {
  // Fetch test
  const { data: test, error: testError } = await supabase
    .from("listening_tests")
    .select("id, title, duration")
    .eq("id", testId)
    .single();

  if (testError || !test) throw new Error(testError?.message || "Listening test not found");

  // Fetch sections
  const { data: sections, error: secError } = await supabase
    .from("listening_sections")
    .select("*")
    .eq("test_id", testId)
    .order("section_number");

  if (secError) throw new Error(secError.message);

  const sectionIds = (sections || []).map((s) => s.id);

  // Fetch groups and questions in parallel
  const [groupsRes, questionsRes] = await Promise.all([
    supabase
      .from("listening_question_groups")
      .select("*")
      .in("section_id", sectionIds.length ? sectionIds : ["__none__"])
      .order("group_order"),
    // We'll fetch questions after we have group IDs
    Promise.resolve(null),
  ]);

  if (groupsRes.error) throw new Error(groupsRes.error.message);
  const groups = groupsRes.data || [];
  const groupIds = groups.map((g) => g.id);

  const { data: questions, error: qError } = await supabase
    .from("listening_questions")
    .select("*")
    .in("group_id", groupIds.length ? groupIds : ["__none__"])
    .order("question_order");

  if (qError) throw new Error(qError.message);

  // Build nested maps
  const questionsByGroup = new Map<string, typeof questions>();
  (questions || []).forEach((q) => {
    if (!questionsByGroup.has(q.group_id)) questionsByGroup.set(q.group_id, []);
    questionsByGroup.get(q.group_id)!.push(q);
  });

  const groupsBySection = new Map<string, typeof groups>();
  groups.forEach((g) => {
    if (!groupsBySection.has(g.section_id)) groupsBySection.set(g.section_id, []);
    groupsBySection.get(g.section_id)!.push(g);
  });

  // Transform to UI format
  const uiSections: ListeningSection[] = (sections || []).map((s) => {
    const sectionGroups = groupsBySection.get(s.id) || [];
    const flatQuestions: ListeningQuestion[] = [];

    for (const g of sectionGroups) {
      const groupQs = questionsByGroup.get(g.id) || [];
      const dbGroup: DBQuestionGroup = {
        type: g.question_type,
        instructions: g.instructions,
        wordLimit: g.word_limit || "",
        questions: groupQs.map((q) => ({
          id: q.id,
          text: q.text,
          answer: q.answer || "",
          options: Array.isArray(q.options) ? q.options as any : [],
          matchingPairs: Array.isArray(q.matching_pairs) ? q.matching_pairs as any : [],
          completionGaps: Array.isArray(q.completion_gaps) ? q.completion_gaps as any : [],
          acceptedAnswers: Array.isArray(q.accepted_answers) ? q.accepted_answers as any : [],
          timestamp: q.timestamp || "",
        })),
      };

      for (const dbQ of dbGroup.questions) {
        flatQuestions.push(mapDBQuestionToListening(dbQ, dbGroup));
      }
    }

    // Build instructions from first group or default
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

  // Parse duration to seconds (e.g. "30 mins" -> 1800)
  const durationMatch = test.duration?.match(/(\d+)/);
  const totalTime = durationMatch ? parseInt(durationMatch[1]) * 60 : 1800;

  return {
    id: test.id,
    title: test.title,
    totalTime,
    sections: uiSections,
  };
}
