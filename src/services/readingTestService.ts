import { supabase } from "@/integrations/supabase/client";
import type { Json } from "@/integrations/supabase/types";

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

interface ReadingPassageState {
  id: number;
  title: string;
  content: string;
  notes: string;
  questionGroups: QuestionGroup[];
}

interface SaveReadingTestParams {
  userId: string;
  title: string;
  testType: string;
  difficulty: string;
  duration: string;
  status: "draft" | "published";
  passages: ReadingPassageState[];
}

export async function saveReadingTest(params: SaveReadingTestParams): Promise<{ testId: string }> {
  const { userId, title, testType, difficulty, duration, status, passages } = params;

  // 1. Insert the test
  const { data: testData, error: testError } = await supabase
    .from("reading_tests")
    .insert({
      created_by: userId,
      title,
      test_type: testType,
      difficulty,
      duration,
      status,
    })
    .select("id")
    .single();

  if (testError || !testData) {
    throw new Error(testError?.message || "Failed to create reading test");
  }

  const testId = testData.id;

  // 2. Insert passages
  const passageInserts = passages.map((p, idx) => ({
    test_id: testId,
    passage_number: idx + 1,
    title: p.title,
    content: p.content,
    notes: p.notes,
  }));

  const { data: passageData, error: passageError } = await supabase
    .from("reading_passages")
    .insert(passageInserts)
    .select("id, passage_number");

  if (passageError || !passageData) {
    // Attempt cleanup
    await supabase.from("reading_tests").delete().eq("id", testId);
    throw new Error(passageError?.message || "Failed to create passages");
  }

  // Map passage_number to DB id
  const passageIdMap = new Map<number, string>();
  passageData.forEach((p) => passageIdMap.set(p.passage_number, p.id));

  // 3. Insert question groups
  const groupInserts: Array<{
    passage_id: string;
    group_order: number;
    question_type: string;
    instructions: string;
    word_limit: string;
    has_word_bank: boolean;
    word_bank: Json;
    sequential_order: boolean;
    multiple_selection: boolean;
    select_count: number;
    _passageIdx: number;
    _groupIdx: number;
  }> = [];

  passages.forEach((p, pIdx) => {
    const passageId = passageIdMap.get(pIdx + 1);
    if (!passageId) return;

    p.questionGroups.forEach((g, gIdx) => {
      groupInserts.push({
        passage_id: passageId,
        group_order: gIdx,
        question_type: g.type,
        instructions: g.instructions,
        word_limit: g.wordLimit,
        has_word_bank: g.hasWordBank,
        word_bank: g.wordBank as Json,
        sequential_order: g.sequentialOrder,
        multiple_selection: g.multipleSelection,
        select_count: g.selectCount,
        _passageIdx: pIdx,
        _groupIdx: gIdx,
      });
    });
  });

  // Strip internal tracking fields before insert
  const cleanGroupInserts = groupInserts.map(({ _passageIdx, _groupIdx, ...rest }) => rest);

  const { data: groupData, error: groupError } = await supabase
    .from("reading_question_groups")
    .insert(cleanGroupInserts)
    .select("id");

  if (groupError || !groupData) {
    await supabase.from("reading_tests").delete().eq("id", testId);
    throw new Error(groupError?.message || "Failed to create question groups");
  }

  // Map group inserts order to DB ids
  const questionInserts: Array<{
    group_id: string;
    question_order: number;
    text: string;
    answer: string;
    options: Json;
    matching_pairs: Json;
    completion_gaps: Json;
    accepted_answers: Json;
  }> = [];

  let groupDbIdx = 0;
  passages.forEach((p) => {
    p.questionGroups.forEach((g) => {
      const groupId = groupData[groupDbIdx]?.id;
      groupDbIdx++;
      if (!groupId) return;

      g.questions.forEach((q, qIdx) => {
        questionInserts.push({
          group_id: groupId,
          question_order: qIdx,
          text: q.text,
          answer: q.answer,
          options: q.options as unknown as Json,
          matching_pairs: q.matchingPairs as unknown as Json,
          completion_gaps: q.completionGaps as unknown as Json,
          accepted_answers: q.acceptedAnswers as unknown as Json,
        });
      });
    });
  });

  if (questionInserts.length > 0) {
    const { error: qError } = await supabase
      .from("reading_questions")
      .insert(questionInserts);

    if (qError) {
      await supabase.from("reading_tests").delete().eq("id", testId);
      throw new Error(qError.message || "Failed to create questions");
    }
  }

  return { testId };
}
