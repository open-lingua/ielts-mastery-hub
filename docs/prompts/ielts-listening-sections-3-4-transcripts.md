# Role: Senior Full-Stack Content Engineer & Database Architect & Senior IELTS Content Creator, Assessment Design, Educational Measurement

# Context
You are tasked with generating a comprehensive **SQLite SQL Seed File** specifically for the Listening module (`src/core/src/database/seeds/listening/ielts_listening_band_<band>_test_<n>.sql`). It will populate the database with a completely new, highly realistic listening test based on the Configuration Variables. The content must strictly mirror the official IELTS format, featuring brand-new, fully written out **Audio Transcripts**, prompts, and 40 mapped questions geared towards the specified Target Band complexity.

**This is PART 2 of 2: generate ONLY Section 3 and Section 4.**

# Tech Stack
- **Database:** SQLite - Target for the `.sql` script.
- **Data Format:** Standard SQL `INSERT INTO` statements with complex `JSONB` payloads for question options and accepted answers.

# Feature Specification

## 1. Database Seed Strategy & Relational Integrity
- **Do not use `TRUNCATE` in this script**.
- **Non-Deterministic UUIDs:** Generate unique **UUID v4** identifiers for all records (tests, sections, questions).

## 2. Seed: IELTS Listening Test
- **Test Record:** Create 1 entry in `listening_tests` using the Test Title.
- **Section 3 (Academic Dialogue):** Include a clear **Title** and a full **Audio Transcript** (e.g., 2-3 people discussing an assignment).
  - Q21-30: Multiple Choice and Matching Features.
- **Section 4 (Academic Monologue):** Include a clear **Title** and a full **Audio Transcript** (e.g., a university lecture).
  - Q31-40: Note/Summary Completion.

## 3. Transcript Technical Specifications (MANDATORY per Section)
*Note to AI: Each `transcript` field MUST comply with the technical parameters below. These parameters are non-negotiable and are designed to replicate the pacing, length, and linguistic complexity of authentic IELTS audio recordings. Respect the target word count strictly, as it directly determines the realistic audio duration.*

*Note to AI: The script will have a structure like the following, wrapping the dialogue/monologue with one speaker label per line:*

```
Agent: ...
Customer: ...
Agent: ...
Customer: ...
Agent: ...
Customer: ...
```

*When counting words to validate the target word count below, do not count the dialogue tags or the speaker labels (e.g. "Agent:", "Customer:") — only count the actual spoken content.*

- **Section 3 — Academic discussion**
  - Speakers: **2 to 4 people** (most commonly 2-3, typically students + tutor)
  - Audio duration: **~5 to 6 minutes** (the longest one)
  - Transcript word count: **~750 to 1000 words**
  - Context: discussion about an academic assignment, tutoring session, project planning
  - Level: high, faster pace and academic vocabulary

- **Section 4 — Academic lecture**
  - Speakers: **1 person** (a professor/expert)
  - Audio duration: **~5 to 6 minutes** (no break in the middle)
  - Transcript word count: **~700 to 900 words**
  - Context: university lecture on an academic topic
  - Level: the hardest, high density of Academic Word List (AWL ~5.85%)

# Agent Execution Workflow (MANDATORY order of operations)
*Note to AI: Follow this exact sequence. Do not skip steps or merge them into a single pass — each transcript's word-count and format constraints are strict, and generating everything at once tends to produce transcripts that drift off target.*

1. **Generate each transcript separately, one at a time, in its own dedicated response/call.** For each of the 2 sections (in order), produce ONLY that section's full `audio_transcript` text (nothing else — no SQL, no questions yet). Each transcript must be generated in a single, uninterrupted call so the required word count, speaker count, and pacing/vocabulary level (per section 3 below) can all be satisfied consistently within one continuous piece of writing.
2. **Validate the word count immediately after generating each transcript**, before moving on: count only the actual spoken content (excluding speaker labels like "Agent:"/"Customer:"). If the count falls outside the target range for that section, regenerate that transcript before proceeding — do not carry an out-of-range transcript forward.
3. **Only after both transcripts are generated and validated**, move on to writing the questions (Q21-40) and the SQL seed script for Section 3 and Section 4.
4. **Cross-check consistency**: every fact, name, number, date, or detail referenced in an `accepted_answer` or question `option` must actually appear in its section's validated transcript (and vice versa — don't introduce answers the transcript never mentions). Fix any mismatch by adjusting the question, not by silently changing the already-validated transcript's word count.

# Data Handling: Output Requirements
- Provide the **complete, exact SQL script** for Section 3 and Section 4.
- Ensure the `audio_transcript` fields contain the full conversational text formatted with speaker labels.
- Ensure all `accepted_answers` and `options` are valid `::jsonb` arrays.
- Ensure the `question_order` sequences perfectly from 21 to 40.

# UUID Inventory (Input Section)

**PASTE YOUR RANDOM UUIDS BELOW:**
```
PASTE_YOUR_RANDOM_UUIDS_BELOW
```

*Note to AI: You must strictly use the UUIDs provided in this section for the Primary Keys (`id`) of the records. Ensure Foreign Key relationships correctly reference these specific values to maintain relational integrity.*

# Previously Generated Sections (Input Section)

**PASTE THE OUTPUT OF PROMPT 1 BELOW (Section 1 & Section 2 titles + validated transcripts):**

```
PASTE_SECTIONS_1_AND_2_OUTPUT_HERE
```

# These files already exist in seeds/

```sql
01_ielts_practice_test.sql
```

# Configuration Variables
- **TARGET_BAND_DIFFICULTY:** [5 to 9]
