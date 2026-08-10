import { getAnonId } from "@/lib/anonId";
import {
  getReadingTest,
  createReadingTest,
  updateReadingTest as tauriUpdateReadingTest,
  listReadingPassages,
  createReadingPassage,
  deleteReadingPassage,
  listReadingQuestionGroups,
  createReadingQuestionGroup,
  deleteReadingQuestionGroup,
  listReadingQuestions,
  createReadingQuestion,
  deleteReadingQuestion,
} from "@/lib/tauri";

interface MCOption {
  id: string;
  text: string;
  isCorrect: boolean;
}

interface MatchingPair {
  id: string;
  left: string;
  right: string;
}

interface CompletionGap {
  id: string;
  gapText: string;
  answer: string;
}

interface AcceptedAnswer {
  id: string;
  text: string;
}

interface QuestionItem {
  id: string;
  text: string;
  answer: string;
  options: MCOption[];
  matchingPairs: MatchingPair[];
  completionGaps: CompletionGap[];
  acceptedAnswers: AcceptedAnswer[];
  timestamp?: string;
}

interface QuestionGroup {
  id: string;
  type: string;
  instructions: string;
  wordLimit: string;
  hasWordBank: boolean;
  wordBank: string[];
  sequentialOrder: boolean;
  multipleSelection: boolean;
  selectCount: number;
  questions: QuestionItem[];
}

export interface ReadingPassageState {
  id: number;
  title: string;
  content: string;
  notes: string;
  questionGroups: QuestionGroup[];
}

function parseJsonField<T>(raw: string | null | undefined, fallback: T): T {
  if (!raw) return fallback;
  try { return JSON.parse(raw) as T; } catch { return fallback; }
}

export async function fetchReadingTest(testId: string): Promise<{
  title: string;
  testType: string;
  difficulty: string;
  duration: string;
  status: string;
  passages: ReadingPassageState[];
}> {
  const userId = getAnonId();

  const [test, allPassages, allGroups, allQuestions] = await Promise.all([
    getReadingTest(testId, userId),
    listReadingPassages(userId),
    listReadingQuestionGroups(userId),
    listReadingQuestions(userId),
  ]);

  if (!test) throw new Error("Test not found");

  const passages = allPassages
    .filter((p) => p.test_id === testId)
    .sort((a, b) => a.passage_number - b.passage_number);

  const passageIds = new Set(passages.map((p) => p.id));
  const groups = allGroups
    .filter((g) => passageIds.has(g.passage_id))
    .sort((a, b) => a.group_order - b.group_order);

  const groupIds = new Set(groups.map((g) => g.id));
  const questions = allQuestions
    .filter((q) => groupIds.has(q.group_id))
    .sort((a, b) => a.question_order - b.question_order);

  const questionsByGroup = new Map<string, QuestionItem[]>();
  for (const q of questions) {
    if (!questionsByGroup.has(q.group_id)) questionsByGroup.set(q.group_id, []);
    questionsByGroup.get(q.group_id)!.push({
      id: q.id,
      text: q.text,
      answer: q.answer || "",
      options: parseJsonField<MCOption[]>(q.options, []),
      matchingPairs: parseJsonField<MatchingPair[]>(q.matching_pairs, []),
      completionGaps: parseJsonField<CompletionGap[]>(q.completion_gaps, []),
      acceptedAnswers: parseJsonField<AcceptedAnswer[]>(q.accepted_answers, []),
    });
  }

  const groupsByPassage = new Map<string, QuestionGroup[]>();
  for (const g of groups) {
    if (!groupsByPassage.has(g.passage_id)) groupsByPassage.set(g.passage_id, []);
    groupsByPassage.get(g.passage_id)!.push({
      id: g.id,
      type: g.question_type,
      instructions: g.instructions,
      wordLimit: g.word_limit || "",
      hasWordBank: g.has_word_bank,
      wordBank: parseJsonField<string[]>(g.word_bank, []),
      sequentialOrder: g.sequential_order,
      multipleSelection: g.multiple_selection,
      selectCount: g.select_count,
      questions: questionsByGroup.get(g.id) || [],
    });
  }

  const mappedPassages: ReadingPassageState[] = passages.map((p) => ({
    id: p.passage_number,
    title: p.title,
    content: p.content,
    notes: p.notes || "",
    questionGroups: groupsByPassage.get(p.id) || [],
  }));

  while (mappedPassages.length < 3) {
    mappedPassages.push({ id: mappedPassages.length + 1, title: "", content: "", notes: "", questionGroups: [] });
  }

  return {
    title: test.title,
    testType: test.test_type,
    difficulty: test.difficulty,
    duration: test.duration,
    status: test.status,
    passages: mappedPassages,
  };
}

async function insertPassagesAndQuestions(
  testId: string,
  userId: string,
  passages: ReadingPassageState[]
): Promise<void> {
  const passageIds = await Promise.all(
    passages.map((p, idx) =>
      createReadingPassage(userId, {
        test_id: testId,
        passage_number: idx + 1,
        title: p.title,
        content: p.content,
        notes: p.notes,
      })
    )
  );

  const groupIdsByPassage = await Promise.all(
    passages.map((p, pIdx) =>
      Promise.all(
        p.questionGroups.map((g, gIdx) =>
          createReadingQuestionGroup(userId, {
            passage_id: passageIds[pIdx],
            group_order: gIdx,
            question_type: g.type,
            instructions: g.instructions,
            word_limit: g.wordLimit,
            has_word_bank: g.hasWordBank,
            word_bank: JSON.stringify(g.wordBank),
            sequential_order: g.sequentialOrder,
            multiple_selection: g.multipleSelection,
            select_count: g.selectCount,
          })
        )
      )
    )
  );

  await Promise.all(
    passages.flatMap((p, pIdx) =>
      p.questionGroups.flatMap((g, gIdx) =>
        g.questions.map((q, qIdx) =>
          createReadingQuestion(userId, {
            group_id: groupIdsByPassage[pIdx][gIdx],
            question_order: qIdx,
            text: q.text,
            answer: q.answer,
            options: JSON.stringify(q.options),
            matching_pairs: JSON.stringify(q.matchingPairs),
            completion_gaps: JSON.stringify(q.completionGaps),
            accepted_answers: JSON.stringify(q.acceptedAnswers),
          })
        )
      )
    )
  );
}

export async function saveReadingTest(params: {
  userId: string;
  title: string;
  testType: string;
  difficulty: string;
  duration: string;
  status: "draft" | "published";
  passages: ReadingPassageState[];
}): Promise<{ testId: string }> {
  const { userId, title, testType, difficulty, duration, status, passages } = params;
  const testId = await createReadingTest(userId, { title, test_type: testType, difficulty, duration, status });
  await insertPassagesAndQuestions(testId, userId, passages);
  return { testId };
}

export async function updateReadingTest(params: {
  testId: string;
  title: string;
  testType: string;
  difficulty: string;
  duration: string;
  status: "draft" | "published";
  passages: ReadingPassageState[];
}): Promise<void> {
  const { testId, title, testType, difficulty, duration, status, passages } = params;
  const userId = getAnonId();

  await tauriUpdateReadingTest(testId, userId, { title, test_type: testType, difficulty, duration, status });

  const allPassages = (await listReadingPassages(userId)).filter((p) => p.test_id === testId);
  const passageIdSet = new Set(allPassages.map((p) => p.id));
  const allGroups = (await listReadingQuestionGroups(userId)).filter((g) => passageIdSet.has(g.passage_id));
  const groupIdSet = new Set(allGroups.map((g) => g.id));
  const allQuestions = (await listReadingQuestions(userId)).filter((q) => groupIdSet.has(q.group_id));

  await Promise.all(allQuestions.map((q) => deleteReadingQuestion(q.id, userId)));
  await Promise.all(allGroups.map((g) => deleteReadingQuestionGroup(g.id, userId)));
  await Promise.all(allPassages.map((p) => deleteReadingPassage(p.id, userId)));

  await insertPassagesAndQuestions(testId, userId, passages);
}
