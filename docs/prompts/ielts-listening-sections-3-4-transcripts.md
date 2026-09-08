# Role: Senior Full-Stack Content Engineer & Database Architect & Senior IELTS Content Creator, Assessment Design, Educational Measurement

# Context
You are tasked with generating **PART 2 of 2** — the final step that completes the comprehensive SQLite SQL Seed File for the Listening module (`src/core/src/database/seeds/listening/ielts_listening_band_<band>_test_<n>.sql`). Section 1 and Section 2 (title + validated transcript) were already generated in a previous step and are pasted below in the **Previously Generated Sections** input block.

In THIS prompt you must:
1. Generate the validated transcripts for **Section 3** and **Section 4**.
2. Write all **40 mapped questions** (Q1–40) across all four sections.
3. Output the **complete, final SQL seed script**, combining all four sections and all 40 questions into one file.

# Tech Stack
- **Database:** SQLite — target for the `.sql` script.
- **Data Format:** Standard SQL `INSERT INTO` statements with complex `JSONB` payloads for question options and accepted answers.

# Feature Specification

## 1. Database Seed Strategy & Relational Integrity
- **Do not use `TRUNCATE` in this script**.
- **Non-Deterministic UUIDs:** Use unique **UUID v4** identifiers for all records (test, sections, questions), taken from the UUID Inventory below.

## 2. Seed: IELTS Listening Test
- **Test Record:** Create 1 entry in `listening_tests` using the Test Title.
- **Section 1 (Transactional Dialogue):** Use the title + full transcript pasted in the input block below — do NOT rewrite it. Q1–10: Form/Sentence Completion.
- **Section 2 (Monologue):** Use the title + full transcript pasted in the input block below — do NOT rewrite it. Q11–20: Multiple Choice and Map Labeling (simulated via multiple choice/matching).
- **Section 3 (Academic Dialogue):** Generate a clear **Title** and a full **Audio Transcript** (e.g., 2-3 people discussing an assignment). Q21–30: Multiple Choice and Matching Features.
- **Section 4 (Academic Monologue):** Generate a clear **Title** and a full **Audio Transcript** (e.g., a university lecture). Q31–40: Note/Summary Completion.

## 3. Transcript Technical Specifications (MANDATORY — for Sections 3 & 4)
*Each `transcript` field MUST comply with the technical parameters below. These parameters are non-negotiable and are designed to replicate the pacing, length, and linguistic complexity of authentic IELTS audio recordings. Respect the target word count strictly, as it directly determines the realistic audio duration.*

*The transcript must wrap the dialogue/monologue with one speaker label per line:*

```
Tutor: ...
Student A: ...
Student B: ...
```

*When counting words to validate the target word count below, do not count the dialogue tags or the speaker labels — only count the actual spoken content.*

### Section 3 — Academic discussion
- Speakers: **2 to 4 people** (most commonly 2-3, typically students + tutor)
- Audio duration: **~5 to 6 minutes** (the longest one)
- Transcript word count: **~750 to 1000 words**
- Context: discussion about an academic assignment, tutoring session, project planning
- Level: high, faster pace and academic vocabulary
- Must-include content hooks: distinct opinions/roles per speaker (supports "who said what" matching), a short set of options/features/categories suitable for matching-features items, and several ideas subtle enough to support multiple-choice distractors.

### Section 4 — Academic lecture
- Speakers: **1 person** (a professor/expert)
- Audio duration: **~5 to 6 minutes** (no break in the middle)
- Transcript word count: **~700 to 900 words**
- Context: university lecture on an academic topic
- Level: the hardest, high density of Academic Word List (AWL ~5.85%)
- Must-include content hooks: clear structural signposting so a note-completion outline maps cleanly onto the talk, and enough concrete terms, dates, names, or figures to serve as single-word/short-phrase answers.

# Agent Execution Workflow (MANDATORY order of operations)
*Follow this exact sequence. Do not skip steps or merge them into a single pass — each transcript's word-count and format constraints are strict, and generating everything at once tends to produce transcripts that drift off target.*

1. **Generate the Section 3 transcript first, alone, in a single uninterrupted piece of writing.** Produce ONLY the title and transcript — nothing else yet.
2. **Validate the word count immediately**: count only the actual spoken content (excluding speaker labels). If the count falls outside 750–1000, regenerate before proceeding — do not carry an out-of-range transcript forward.
3. **Generate the Section 4 transcript next, alone, in a single uninterrupted piece of writing.** Produce ONLY the title and transcript — nothing else yet.
4. **Validate the word count immediately**: count only the actual spoken content (excluding speaker labels). If the count falls outside 700–900, regenerate before proceeding.
5. **Only after both transcripts are generated and validated**, move on to writing the 40 questions:
   - Q1–10 must be answerable from the Section 1 transcript pasted in the input block below.
   - Q11–20 must be answerable from the Section 2 transcript pasted in the input block below.
   - Q21–30 must be answerable from the Section 3 transcript you just generated.
   - Q31–40 must be answerable from the Section 4 transcript you just generated.
6. **Cross-check consistency**: every fact, name, number, date, or detail referenced in an `accepted_answer` or question `option` must actually appear in its section's validated transcript (and vice versa — don't introduce answers the transcript never mentions). Fix any mismatch by adjusting the question, not by silently changing an already-validated transcript's word count.
7. Emit the complete, final SQL seed script.

# Data Handling: Output Requirements
- Provide the **complete, exact SQL script**.
- Ensure the `audio_transcript` fields for all four sections (1–4) contain the full conversational text formatted with speaker labels — Sections 1 & 2 copied verbatim from the input block, Sections 3 & 4 newly generated and validated here.
- Ensure all `accepted_answers` and `options` are valid `::jsonb` arrays.
- Ensure the `question_order` sequences perfectly from 1 to 40.
- Print the two newly generated transcripts (Section 3 & 4) with their validated `WORD_COUNT`, followed by the complete SQL script — use the Output Template below.

# UUID Inventory (Input Section)

**PASTE YOUR RANDOM UUIDS BELOW:**
```
PASTE_YOUR_RANDOM_UUIDS_BELOW
```

*You must strictly use the UUIDs provided in this section for the Primary Keys (`id`) of the records. Ensure Foreign Key relationships correctly reference these specific values to maintain relational integrity.*

# Previously Generated Sections (Input Section)

**PASTE THE OUTPUT OF PROMPT 1 BELOW (Section 1 & Section 2 titles + validated transcripts):**
```
PASTE_SECTIONS_1_AND_2_OUTPUT_HERE
```

*Treat the pasted Section 1 & Section 2 titles and transcripts as the authoritative source. Do not rewrite them; only reference them for question generation and embed them verbatim into the SQL `audio_transcript` fields.*

# These files already exist in seeds/
```sql
01_ielts_practice_test.sql
```

# Configuration Variables
- **TARGET_BAND_DIFFICULTY:** [5 to 9]
