import { supabase } from "@/integrations/supabase/client";
import type { Json } from "@/integrations/supabase/types";

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

/**
 * Upload audio to the listening-audio bucket.
 */
export async function uploadListeningAudio(
  userId: string,
  file: File
): Promise<string> {
  const ext = file.name.split(".").pop() || "mp3";
  const filePath = `${userId}/${Date.now()}-${crypto.randomUUID()}.${ext}`;

  const { error } = await supabase.storage
    .from("listening-audio")
    .upload(filePath, file, { upsert: false });

  if (error) {
    throw new Error(`Audio upload failed: ${error.message}`);
  }

  const { data: urlData } = supabase.storage
    .from("listening-audio")
    .getPublicUrl(filePath);

  return urlData.publicUrl;
}

/**
 * Save a complete Listening Test with sections, groups, and questions.
 */
export async function saveListeningTest(
  params: SaveListeningTestParams
): Promise<{ testId: string }> {
  const { userId, title, difficulty, duration, status, sections } = params;

  // 1. Upload audio files
  const audioUrls: (string | undefined)[] = [];
  for (const section of sections) {
    if (section.audioFile) {
      const url = await uploadListeningAudio(userId, section.audioFile);
      audioUrls.push(url);
    } else {
      audioUrls.push(section.audioUrl || "");
    }
  }

  // 2. Insert test
  const { data: testData, error: testError } = await supabase
    .from("listening_tests")
    .insert({ created_by: userId, title, difficulty, duration, status })
    .select("id")
    .single();

  if (testError || !testData) {
    throw new Error(testError?.message || "Failed to create listening test");
  }

  const testId = testData.id;

  // 3. Insert sections
  const sectionInserts = sections.map((s, idx) => ({
    test_id: testId,
    section_number: idx + 1,
    title: s.title,
    transcript: s.transcript,
    audio_url: audioUrls[idx] || "",
  }));

  const { data: sectionData, error: sectionError } = await supabase
    .from("listening_sections")
    .insert(sectionInserts)
    .select("id, section_number");

  if (sectionError || !sectionData) {
    await supabase.from("listening_tests").delete().eq("id", testId);
    throw new Error(sectionError?.message || "Failed to create sections");
  }

  const sectionIdMap = new Map<number, string>();
  sectionData.forEach((s) => sectionIdMap.set(s.section_number, s.id));

  // 4. Insert question groups
  const groupInserts: Array<{
    section_id: string;
    group_order: number;
    question_type: string;
    instructions: string;
    word_limit: string;
    has_word_bank: boolean;
    word_bank: Json;
    sequential_order: boolean;
    multiple_selection: boolean;
    select_count: number;
  }> = [];

  // Track mapping for questions
  const groupMapping: Array<{ sectionIdx: number; groupIdx: number }> = [];

  sections.forEach((s, sIdx) => {
    const sectionId = sectionIdMap.get(sIdx + 1);
    if (!sectionId) return;

    s.questionGroups.forEach((g, gIdx) => {
      groupInserts.push({
        section_id: sectionId,
        group_order: gIdx,
        question_type: g.type,
        instructions: g.instructions,
        word_limit: g.wordLimit,
        has_word_bank: g.hasWordBank,
        word_bank: g.wordBank as Json,
        sequential_order: g.sequentialOrder,
        multiple_selection: g.multipleSelection,
        select_count: g.selectCount,
      });
      groupMapping.push({ sectionIdx: sIdx, groupIdx: gIdx });
    });
  });

  const { data: groupData, error: groupError } = await supabase
    .from("listening_question_groups")
    .insert(groupInserts)
    .select("id");

  if (groupError || !groupData) {
    await supabase.from("listening_tests").delete().eq("id", testId);
    throw new Error(groupError?.message || "Failed to create question groups");
  }

  // 5. Insert questions
  const questionInserts: Array<{
    group_id: string;
    question_order: number;
    text: string;
    answer: string;
    options: Json;
    matching_pairs: Json;
    completion_gaps: Json;
    accepted_answers: Json;
    timestamp: string;
  }> = [];

  groupMapping.forEach((map, dbIdx) => {
    const groupId = groupData[dbIdx]?.id;
    if (!groupId) return;

    const group = sections[map.sectionIdx].questionGroups[map.groupIdx];
    group.questions.forEach((q, qIdx) => {
      questionInserts.push({
        group_id: groupId,
        question_order: qIdx,
        text: q.text,
        answer: q.answer,
        options: q.options as unknown as Json,
        matching_pairs: q.matchingPairs as unknown as Json,
        completion_gaps: q.completionGaps as unknown as Json,
        accepted_answers: q.acceptedAnswers as unknown as Json,
        timestamp: q.timestamp || "",
      });
    });
  });

  if (questionInserts.length > 0) {
    const { error: qError } = await supabase
      .from("listening_questions")
      .insert(questionInserts);

    if (qError) {
      await supabase.from("listening_tests").delete().eq("id", testId);
      throw new Error(qError.message || "Failed to create questions");
    }
  }

  return { testId };
}

/**
 * Fetch a complete Listening Test with sections, groups, and questions for edit mode.
 */
export async function fetchListeningTest(testId: string) {
  const { data: test, error: testError } = await supabase
    .from("listening_tests")
    .select("*")
    .eq("id", testId)
    .single();

  if (testError || !test) {
    throw new Error(testError?.message || "Listening test not found");
  }

  const { data: sections, error: secError } = await supabase
    .from("listening_sections")
    .select("*")
    .eq("test_id", testId)
    .order("section_number");

  if (secError) throw new Error(secError.message || "Failed to load sections");

  const sectionIds = (sections || []).map((s) => s.id);

  const { data: groups, error: grpError } = await supabase
    .from("listening_question_groups")
    .select("*")
    .in("section_id", sectionIds.length ? sectionIds : ["__none__"])
    .order("group_order");

  if (grpError) throw new Error(grpError.message || "Failed to load question groups");

  const groupIds = (groups || []).map((g) => g.id);

  const { data: questions, error: qError } = await supabase
    .from("listening_questions")
    .select("*")
    .in("group_id", groupIds.length ? groupIds : ["__none__"])
    .order("question_order");

  if (qError) throw new Error(qError.message || "Failed to load questions");

  // Nest questions into groups
  const groupMap = new Map<string, typeof groups>();
  (groups || []).forEach((g) => {
    if (!groupMap.has(g.section_id)) groupMap.set(g.section_id, []);
    groupMap.get(g.section_id)!.push(g);
  });

  const questionMap = new Map<string, typeof questions>();
  (questions || []).forEach((q) => {
    if (!questionMap.has(q.group_id)) questionMap.set(q.group_id, []);
    questionMap.get(q.group_id)!.push(q);
  });

  return {
    id: test.id,
    title: test.title,
    difficulty: test.difficulty,
    duration: test.duration,
    status: test.status,
    sections: (sections || []).map((s) => ({
      id: s.section_number,
      title: s.title,
      transcript: s.transcript || "",
      audioUrl: s.audio_url || "",
      questionGroups: (groupMap.get(s.id) || []).map((g) => ({
        id: g.id,
        type: g.question_type,
        instructions: g.instructions,
        wordLimit: g.word_limit || "",
        hasWordBank: g.has_word_bank,
        wordBank: Array.isArray(g.word_bank) ? (g.word_bank as string[]) : [],
        sequentialOrder: g.sequential_order,
        multipleSelection: g.multiple_selection,
        selectCount: g.select_count,
        questions: (questionMap.get(g.id) || []).map((q) => ({
          id: q.id,
          text: q.text,
          answer: q.answer || "",
          options: Array.isArray(q.options) ? q.options : [],
          matchingPairs: Array.isArray(q.matching_pairs) ? q.matching_pairs : [],
          completionGaps: Array.isArray(q.completion_gaps) ? q.completion_gaps : [],
          acceptedAnswers: Array.isArray(q.accepted_answers) ? q.accepted_answers : [],
          timestamp: q.timestamp || "",
        })),
      })),
    })),
  };
}

/**
 * Update an existing Listening Test and sync its children.
 */
export async function updateListeningTest(
  params: Omit<SaveListeningTestParams, "userId"> & { testId: string }
): Promise<void> {
  const { testId, title, difficulty, duration, status, sections } = params;

  // Get the owner for audio uploads
  const { data: existing } = await supabase
    .from("listening_tests")
    .select("created_by")
    .eq("id", testId)
    .single();

  const userId = existing?.created_by || "";

  // 1. Upload audio files
  const audioUrls: (string | undefined)[] = [];
  for (const section of sections) {
    if (section.audioFile) {
      const url = await uploadListeningAudio(userId, section.audioFile);
      audioUrls.push(url);
    } else {
      audioUrls.push(section.audioUrl || "");
    }
  }

  // 2. Update parent test
  const { error: updateError } = await supabase
    .from("listening_tests")
    .update({ title, difficulty, duration, status, updated_at: new Date().toISOString() })
    .eq("id", testId);

  if (updateError) throw new Error(updateError.message || "Failed to update listening test");

  // 3. Delete existing children (cascade: sections → groups → questions)
  // Get existing section IDs
  const { data: oldSections } = await supabase
    .from("listening_sections")
    .select("id")
    .eq("test_id", testId);

  if (oldSections && oldSections.length > 0) {
    const oldSectionIds = oldSections.map((s) => s.id);

    const { data: oldGroups } = await supabase
      .from("listening_question_groups")
      .select("id")
      .in("section_id", oldSectionIds);

    if (oldGroups && oldGroups.length > 0) {
      const oldGroupIds = oldGroups.map((g) => g.id);
      await supabase.from("listening_questions").delete().in("group_id", oldGroupIds);
    }

    await supabase.from("listening_question_groups").delete().in("section_id", oldSectionIds);
    await supabase.from("listening_sections").delete().eq("test_id", testId);
  }

  // 4. Re-insert sections
  const sectionInserts = sections.map((s, idx) => ({
    test_id: testId,
    section_number: idx + 1,
    title: s.title,
    transcript: s.transcript,
    audio_url: audioUrls[idx] || "",
  }));

  const { data: sectionData, error: sectionError } = await supabase
    .from("listening_sections")
    .insert(sectionInserts)
    .select("id, section_number");

  if (sectionError || !sectionData) {
    throw new Error(sectionError?.message || "Failed to re-create sections");
  }

  const sectionIdMap = new Map<number, string>();
  sectionData.forEach((s) => sectionIdMap.set(s.section_number, s.id));

  // 5. Re-insert question groups
  const groupInserts: Array<{
    section_id: string;
    group_order: number;
    question_type: string;
    instructions: string;
    word_limit: string;
    has_word_bank: boolean;
    word_bank: Json;
    sequential_order: boolean;
    multiple_selection: boolean;
    select_count: number;
  }> = [];

  const groupMapping: Array<{ sectionIdx: number; groupIdx: number }> = [];

  sections.forEach((s, sIdx) => {
    const sectionId = sectionIdMap.get(sIdx + 1);
    if (!sectionId) return;
    s.questionGroups.forEach((g, gIdx) => {
      groupInserts.push({
        section_id: sectionId,
        group_order: gIdx,
        question_type: g.type,
        instructions: g.instructions,
        word_limit: g.wordLimit,
        has_word_bank: g.hasWordBank,
        word_bank: g.wordBank as Json,
        sequential_order: g.sequentialOrder,
        multiple_selection: g.multipleSelection,
        select_count: g.selectCount,
      });
      groupMapping.push({ sectionIdx: sIdx, groupIdx: gIdx });
    });
  });

  const { data: groupData, error: groupError } = await supabase
    .from("listening_question_groups")
    .insert(groupInserts)
    .select("id");

  if (groupError || !groupData) {
    throw new Error(groupError?.message || "Failed to re-create question groups");
  }

  // 6. Re-insert questions
  const questionInserts: Array<{
    group_id: string;
    question_order: number;
    text: string;
    answer: string;
    options: Json;
    matching_pairs: Json;
    completion_gaps: Json;
    accepted_answers: Json;
    timestamp: string;
  }> = [];

  groupMapping.forEach((map, dbIdx) => {
    const groupId = groupData[dbIdx]?.id;
    if (!groupId) return;
    const group = sections[map.sectionIdx].questionGroups[map.groupIdx];
    group.questions.forEach((q, qIdx) => {
      questionInserts.push({
        group_id: groupId,
        question_order: qIdx,
        text: q.text,
        answer: q.answer,
        options: q.options as unknown as Json,
        matching_pairs: q.matchingPairs as unknown as Json,
        completion_gaps: q.completionGaps as unknown as Json,
        accepted_answers: q.acceptedAnswers as unknown as Json,
        timestamp: q.timestamp || "",
      });
    });
  });

  if (questionInserts.length > 0) {
    const { error: qError } = await supabase
      .from("listening_questions")
      .insert(questionInserts);

    if (qError) throw new Error(qError.message || "Failed to re-create questions");
  }
}
