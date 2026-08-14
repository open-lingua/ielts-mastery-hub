import { getAnonId } from "@/lib/anonId";
import {
  createListeningQuestion,
  createListeningQuestionGroup,
  createListeningSection,
  createListeningTest,
  deleteListeningQuestion,
  deleteListeningQuestionGroup,
  deleteListeningSection,
  getListeningTest,
  listListeningQuestionGroups,
  listListeningQuestions,
  listListeningSections,
  updateListeningTest as tauriUpdateListeningTest,
  uploadListeningAudio,
} from "@/lib/tauri";

interface QuestionItem {
  id: string;
  text: string;
  answer: string;
  options: Array<{ id: string; text: string; isCorrect: boolean }>;
  matchingPairs: Array<{ id: string; left: string; right: string }>;
  completionGaps: Array<{ id: string; gapText: string; answer: string }>;
  acceptedAnswers: Array<{ id: string; text: string }>;
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

interface ListeningSectionData {
  id: number;
  title: string;
  transcript: string;
  audioFile?: File | null;
  audioUrl?: string;
  questionGroups: QuestionGroup[];
}

interface SaveListeningTestParams {
  userId: string;
  title: string;
  difficulty: string;
  duration: string;
  status: "draft" | "published";
  sections: ListeningSectionData[];
}

function parseJsonField<T>(raw: string | null | undefined, fallback: T): T {
  if (!raw) return fallback;
  try {
    return JSON.parse(raw) as T;
  } catch {
    return fallback;
  }
}

async function resolveAudioUrls(userId: string, sections: ListeningSectionData[]): Promise<string[]> {
  const urls: string[] = [];
  for (const s of sections) {
    if (s.audioFile) {
      urls.push(await uploadListeningAudio(userId, s.audioFile));
    } else {
      urls.push(s.audioUrl || "");
    }
  }
  return urls;
}

async function insertSectionsGroupsQuestions(
  testId: string,
  userId: string,
  sections: ListeningSectionData[],
  audioUrls: string[]
): Promise<void> {
  const sectionIds = await Promise.all(
    sections.map((s, idx) =>
      createListeningSection(userId, {
        test_id: testId,
        section_number: idx + 1,
        title: s.title,
        transcript: s.transcript,
        audio_url: audioUrls[idx],
      })
    )
  );

  const groupIdsBySection = await Promise.all(
    sections.map((s, sIdx) =>
      Promise.all(
        s.questionGroups.map((g, gIdx) =>
          createListeningQuestionGroup(userId, {
            section_id: sectionIds[sIdx],
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
    sections.flatMap((s, sIdx) =>
      s.questionGroups.flatMap((g, gIdx) =>
        g.questions.map((q, qIdx) =>
          createListeningQuestion(userId, {
            group_id: groupIdsBySection[sIdx][gIdx],
            question_order: qIdx,
            text: q.text,
            answer: q.answer,
            options: JSON.stringify(q.options),
            matching_pairs: JSON.stringify(q.matchingPairs),
            completion_gaps: JSON.stringify(q.completionGaps),
            accepted_answers: JSON.stringify(q.acceptedAnswers),
            timestamp: q.timestamp || "",
          })
        )
      )
    )
  );
}

export async function saveListeningTest(params: SaveListeningTestParams): Promise<{ testId: string }> {
  const { userId, title, difficulty, duration, status, sections } = params;
  const audioUrls = await resolveAudioUrls(userId, sections);
  const testId = await createListeningTest(userId, { title, difficulty, duration, status });
  await insertSectionsGroupsQuestions(testId, userId, sections, audioUrls);
  return { testId };
}

export async function fetchListeningTest(testId: string) {
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

  return {
    id: test.id,
    title: test.title,
    difficulty: test.difficulty,
    duration: test.duration,
    status: test.status,
    sections: sections.map((s) => ({
      id: s.section_number,
      title: s.title,
      transcript: s.transcript || "",
      audioUrl: s.audio_url || "",
      questionGroups: (groupsBySection.get(s.id) || []).map((g) => ({
        id: g.id,
        type: g.question_type,
        instructions: g.instructions,
        wordLimit: g.word_limit || "",
        hasWordBank: g.has_word_bank,
        wordBank: parseJsonField<string[]>(g.word_bank, []),
        sequentialOrder: g.sequential_order,
        multipleSelection: g.multiple_selection,
        selectCount: g.select_count,
        questions: (questionsByGroup.get(g.id) || []).map((q) => ({
          id: q.id,
          text: q.text,
          answer: q.answer || "",
          options: parseJsonField(q.options, []),
          matchingPairs: parseJsonField(q.matching_pairs, []),
          completionGaps: parseJsonField(q.completion_gaps, []),
          acceptedAnswers: parseJsonField(q.accepted_answers, []),
          timestamp: q.timestamp || "",
        })),
      })),
    })),
  };
}

export async function updateListeningTest(
  params: Omit<SaveListeningTestParams, "userId"> & { testId: string }
): Promise<void> {
  const { testId, title, difficulty, duration, status, sections } = params;
  const userId = getAnonId();
  const audioUrls = await resolveAudioUrls(userId, sections);

  await tauriUpdateListeningTest(testId, userId, { title, difficulty, duration, status });

  const allSections = (await listListeningSections(userId)).filter((s) => s.test_id === testId);
  const sectionIdSet = new Set(allSections.map((s) => s.id));
  const allGroups = (await listListeningQuestionGroups(userId)).filter((g) => sectionIdSet.has(g.section_id));
  const groupIdSet = new Set(allGroups.map((g) => g.id));
  const allQuestions = (await listListeningQuestions(userId)).filter((q) => groupIdSet.has(q.group_id));

  await Promise.all(allQuestions.map((q) => deleteListeningQuestion(q.id, userId)));
  await Promise.all(allGroups.map((g) => deleteListeningQuestionGroup(g.id, userId)));
  await Promise.all(allSections.map((s) => deleteListeningSection(s.id, userId)));

  await insertSectionsGroupsQuestions(testId, userId, sections, audioUrls);
}
