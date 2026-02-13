import { fetchReadingTest } from "./readingTestService";
import type {
  ReadingPassage,
  ReadingSection,
  QuestionSection,
  MCQuestion,
  TFNGQuestion,
  YNNGQuestion,
  MatchingHeadingsQuestion,
  MatchingInformationQuestion,
  MatchingFeaturesQuestion,
  MatchingSentenceEndingsQuestion,
  SentenceCompletionQuestion,
  SummaryCompletionQuestion,
  NoteCompletionQuestion,
  TableCompletionQuestion,
  FlowchartCompletionQuestion,
  ShortAnswerQuestion,
} from "@/data/readingTestData";

// ─── Types from DB service ───────────────────────────
interface DBQuestion {
  id: string;
  text: string;
  answer: string;
  options: { id: string; text: string; isCorrect: boolean }[];
  matchingPairs: { id: string; left: string; right: string }[];
  completionGaps: { id: string; gapText: string; answer: string }[];
  acceptedAnswers: { id: string; text: string }[];
}

interface DBQuestionGroup {
  id: string;
  type: string;
  instructions: string;
  wordLimit: string;
  hasWordBank: boolean;
  wordBank: string[];
  sequentialOrder: boolean;
  multipleSelection: boolean;
  selectCount: number;
  questions: DBQuestion[];
}

interface DBPassage {
  id: number;
  title: string;
  content: string;
  notes: string;
  questionGroups: DBQuestionGroup[];
}

// Flat question arrays used by TFNG/YNNG/MC renderers
export interface FlatTFNGQuestion {
  id: string;
  label: string;
  text: string;
  answer: "TRUE" | "FALSE" | "NOT GIVEN";
}

export interface FlatYNNGQuestion {
  id: string;
  label: string;
  text: string;
  answer: "YES" | "NO" | "NOT GIVEN";
}

export interface FlatMCQuestion {
  id: string;
  label: string;
  text: string;
  options: string[];
  answer: string;
  multiSelect?: boolean | undefined;
}

export interface ReadingTestPracticePayload {
  title: string;
  testType: string;
  difficulty: string;
  duration: string;
  passages: ReadingPassage[];
  totalQuestions: number;
  passageQuestionRanges: { start: number; end: number }[];
  // Per-passage flat question overrides for TFNG/YNNG/MC renderers
  passageOverrides: {
    tfng?: FlatTFNGQuestion[];
    ynng?: FlatYNNGQuestion[];
    mc?: FlatMCQuestion[];
  }[];
}

const typeMap: Record<string, string> = {
  "multiple-choice": "MULTIPLE_CHOICE",
  "true-false-not-given": "TRUE_FALSE_NOT_GIVEN",
  "yes-no-not-given": "YES_NO_NOT_GIVEN",
  "matching-headings": "MATCHING_HEADINGS",
  "matching-information": "MATCHING_INFORMATION",
  "matching-features": "MATCHING_FEATURES",
  "matching-sentence-endings": "MATCHING_SENTENCE_ENDINGS",
  "sentence-completion": "SENTENCE_COMPLETION",
  "summary-completion": "SUMMARY_COMPLETION",
  "note-completion": "NOTE_COMPLETION",
  "table-completion": "TABLE_COMPLETION",
  "flowchart-completion": "FLOWCHART_COMPLETION",
  "short-answer": "SHORT_ANSWER",
};

/**
 * Build a QuestionSection from a DB question group + running question counter.
 * Returns the data + how many questions were consumed.
 */
function buildQuestionSection(
  group: DBQuestionGroup,
  startNum: number,
): { data: QuestionSection; count: number; title: string; questionRange: string } {
  const mappedType = typeMap[group.type] || group.type;
  const qs = group.questions;
  const count = qs.length;
  const endNum = startNum + count - 1;
  const title = `Questions ${startNum}–${endNum}`;
  const questionRange = `${startNum}-${endNum}`;

  switch (mappedType) {
    case "TRUE_FALSE_NOT_GIVEN":
      return {
        data: { id: group.id, type: "TRUE_FALSE_NOT_GIVEN", text: "", answer: "TRUE" } as TFNGQuestion,
        count, title, questionRange,
      };

    case "YES_NO_NOT_GIVEN":
      return {
        data: { id: group.id, type: "YES_NO_NOT_GIVEN", text: "", answer: "YES" } as YNNGQuestion,
        count, title, questionRange,
      };

    case "MULTIPLE_CHOICE":
      return {
        data: { id: group.id, type: "MULTIPLE_CHOICE", text: "", options: [], answer: "" } as MCQuestion,
        count, title, questionRange,
      };

    case "MATCHING_INFORMATION": {
      const paragraphs = qs.length > 0 && qs[0].matchingPairs.length > 0
        ? [...new Set(qs[0].matchingPairs.map((p) => p.right))]
        : extractParagraphLabels(qs);
      const statements = qs.map((q, i) => ({
        label: String(startNum + i),
        text: q.text,
      }));
      const answers: Record<string, string> = {};
      qs.forEach((q, i) => { answers[String(startNum + i)] = q.answer; });
      return {
        data: {
          id: group.id,
          type: "MATCHING_INFORMATION",
          statements,
          paragraphs,
          answers,
        } as MatchingInformationQuestion,
        count, title, questionRange,
      };
    }

    case "MATCHING_HEADINGS": {
      const paragraphs = qs.map((q) => q.text);
      const headings = group.wordBank.length > 0
        ? group.wordBank
        : qs.flatMap((q) => q.options.map((o) => o.text));
      const answers: Record<string, string> = {};
      qs.forEach((q) => { answers[q.text] = q.answer; });
      return {
        data: {
          id: group.id,
          type: "MATCHING_HEADINGS",
          paragraphs,
          headings,
          answers,
        } as MatchingHeadingsQuestion,
        count, title, questionRange,
      };
    }

    case "MATCHING_FEATURES": {
      const features = qs.map((q, i) => ({
        label: String(startNum + i),
        text: q.text,
      }));
      const entities = group.wordBank.length > 0
        ? group.wordBank
        : [...new Set(qs.map((q) => q.answer))];
      const answers: Record<string, string> = {};
      qs.forEach((q, i) => { answers[String(startNum + i)] = q.answer; });
      return {
        data: {
          id: group.id,
          type: "MATCHING_FEATURES",
          features,
          entities,
          answers,
        } as MatchingFeaturesQuestion,
        count, title, questionRange,
      };
    }

    case "MATCHING_SENTENCE_ENDINGS": {
      const stems = qs.map((q, i) => ({
        label: String(startNum + i),
        text: q.text,
      }));
      const endings = qs[0]?.options?.map((o) => ({
        label: o.id || o.text.charAt(0),
        text: o.text,
      })) || [];
      const answers: Record<string, string> = {};
      qs.forEach((q, i) => { answers[String(startNum + i)] = q.answer; });
      return {
        data: {
          id: group.id,
          type: "MATCHING_SENTENCE_ENDINGS",
          stems,
          endings,
          answers,
        } as MatchingSentenceEndingsQuestion,
        count, title, questionRange,
      };
    }

    case "SENTENCE_COMPLETION": {
      const sentences = qs.map((q, i) => ({
        label: String(startNum + i),
        text: q.text,
        gap: `gap_${group.id}_${i}`,
        answer: q.answer,
      }));
      return {
        data: {
          id: group.id,
          type: "SENTENCE_COMPLETION",
          wordLimit: parseInt(group.wordLimit) || 2,
          sentences,
        } as SentenceCompletionQuestion,
        count, title, questionRange,
      };
    }

    case "SUMMARY_COMPLETION": {
      const gaps = qs.map((q, i) => ({
        id: `gap_${group.id}_${i}`,
        answer: q.answer,
      }));
      // Build summary text from the group instructions or first question text
      const summaryText = qs[0]?.text || group.instructions;
      return {
        data: {
          id: group.id,
          type: "SUMMARY_COMPLETION",
          wordLimit: parseInt(group.wordLimit) || 2,
          useWordBank: group.hasWordBank,
          wordBank: group.hasWordBank ? group.wordBank : undefined,
          summaryText,
          gaps,
        } as SummaryCompletionQuestion,
        count, title, questionRange,
      };
    }

    case "NOTE_COMPLETION": {
      const notes = qs.map((q, i) => ({
        label: String(startNum + i),
        text: q.text,
        gap: `gap_${group.id}_${i}`,
        answer: q.answer,
      }));
      return {
        data: {
          id: group.id,
          type: "NOTE_COMPLETION",
          wordLimit: parseInt(group.wordLimit) || 2,
          notes,
        } as NoteCompletionQuestion,
        count, title, questionRange,
      };
    }

    case "TABLE_COMPLETION": {
      // Reconstruct table from completion_gaps
      const headers = qs[0]?.completionGaps?.length > 0
        ? qs[0].completionGaps.map((g) => g.gapText)
        : ["Column 1", "Column 2", "Column 3"];
      const rows = qs.map((q) => ({
        cells: q.completionGaps.length > 0
          ? q.completionGaps.map((g) =>
              g.answer ? { gap: g.id, answer: g.answer } : g.gapText
            )
          : [q.text, { gap: `gap_${q.id}`, answer: q.answer }],
      }));
      return {
        data: {
          id: group.id,
          type: "TABLE_COMPLETION",
          wordLimit: parseInt(group.wordLimit) || 2,
          headers,
          rows,
        } as TableCompletionQuestion,
        count, title, questionRange,
      };
    }

    case "FLOWCHART_COMPLETION": {
      const steps = qs.map((q) => ({
        text: q.text,
        gap: q.answer ? `gap_${q.id}` : undefined,
        answer: q.answer || undefined,
      }));
      return {
        data: {
          id: group.id,
          type: "FLOWCHART_COMPLETION",
          wordLimit: parseInt(group.wordLimit) || 2,
          steps,
        } as FlowchartCompletionQuestion,
        count, title, questionRange,
      };
    }

    case "SHORT_ANSWER": {
      const questions = qs.map((q, i) => ({
        label: String(startNum + i),
        text: q.text,
        answer: q.answer,
        acceptedAnswers: q.acceptedAnswers.map((a) => a.text),
      }));
      return {
        data: {
          id: group.id,
          type: "SHORT_ANSWER",
          wordLimit: parseInt(group.wordLimit) || 3,
          questions,
        } as ShortAnswerQuestion,
        count, title, questionRange,
      };
    }

    default:
      return {
        data: { id: group.id, type: mappedType, text: "" } as unknown as QuestionSection,
        count, title, questionRange,
      };
  }
}

function extractParagraphLabels(qs: DBQuestion[]): string[] {
  const labels = new Set<string>();
  qs.forEach((q) => {
    q.matchingPairs.forEach((p) => labels.add(p.right));
  });
  return labels.size > 0 ? Array.from(labels) : ["A", "B", "C", "D", "E", "F"];
}

/**
 * Build flat TFNG/YNNG/MC override arrays from a group's questions.
 */
function buildFlatOverrides(
  group: DBQuestionGroup,
  startNum: number,
): {
  tfng?: FlatTFNGQuestion[];
  ynng?: FlatYNNGQuestion[];
  mc?: FlatMCQuestion[];
} {
  const mapped = typeMap[group.type] || group.type;

  if (mapped === "TRUE_FALSE_NOT_GIVEN") {
    return {
      tfng: group.questions.map((q, i) => ({
        id: q.id,
        label: String(startNum + i),
        text: q.text,
        answer: q.answer as "TRUE" | "FALSE" | "NOT GIVEN",
      })),
    };
  }

  if (mapped === "YES_NO_NOT_GIVEN") {
    return {
      ynng: group.questions.map((q, i) => ({
        id: q.id,
        label: String(startNum + i),
        text: q.text,
        answer: q.answer as "YES" | "NO" | "NOT GIVEN",
      })),
    };
  }

  if (mapped === "MULTIPLE_CHOICE") {
    return {
      mc: group.questions.map((q, i) => ({
        id: q.id,
        label: String(startNum + i),
        text: q.text,
        options: q.options.map((o) => o.text),
        answer: q.answer,
        multiSelect: group.multipleSelection || false,
      })),
    };
  }

  return {};
}

/**
 * Fetch a reading test for the practice engine and transform to ReadingPassage[] format.
 */
export async function fetchReadingTestForPractice(
  testId: string,
): Promise<ReadingTestPracticePayload> {
  const result = await fetchReadingTest(testId);

  const passages: ReadingPassage[] = [];
  const passageQuestionRanges: { start: number; end: number }[] = [];
  const passageOverrides: ReadingTestPracticePayload["passageOverrides"] = [];
  let questionCounter = 1;

  for (const dbPassage of result.passages as unknown as DBPassage[]) {
    const sections: ReadingSection[] = [];
    const overrides: ReadingTestPracticePayload["passageOverrides"][0] = {};
    const passageStart = questionCounter;

    for (const group of dbPassage.questionGroups) {
      const { data, count, title, questionRange } = buildQuestionSection(group, questionCounter);

      sections.push({
        title,
        instructions: group.instructions,
        questionRange,
        data,
      });

      // Build flat overrides for TFNG/YNNG/MC
      const flat = buildFlatOverrides(group, questionCounter);
      if (flat.tfng) overrides.tfng = [...(overrides.tfng || []), ...flat.tfng];
      if (flat.ynng) overrides.ynng = [...(overrides.ynng || []), ...flat.ynng];
      if (flat.mc) overrides.mc = [...(overrides.mc || []), ...flat.mc];

      questionCounter += count;
    }

    const passageEnd = questionCounter - 1;

    passages.push({
      id: dbPassage.id,
      title: dbPassage.title,
      passage: dbPassage.content,
      paragraphLabels: extractParagraphLabelsFromContent(dbPassage.content),
      sections,
    });

    passageQuestionRanges.push({ start: passageStart, end: passageEnd });
    passageOverrides.push(overrides);
  }

  return {
    title: result.title,
    testType: result.testType,
    difficulty: result.difficulty,
    duration: result.duration,
    passages,
    totalQuestions: questionCounter - 1,
    passageQuestionRanges,
    passageOverrides,
  };
}

/**
 * Extract paragraph labels (A), (B), etc. from passage content.
 */
function extractParagraphLabelsFromContent(content: string): string[] | undefined {
  const matches = content.match(/\(([A-Z])\)/g);
  if (!matches || matches.length < 2) return undefined;
  return matches.map((m) => m.replace(/[()]/g, ""));
}
