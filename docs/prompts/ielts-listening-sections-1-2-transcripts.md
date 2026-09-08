# Role: Senior Full-Stack Content Engineer & Database Architect & Senior IELTS Content Creator, Assessment Design, Educational Measurement

# Context
You are tasked with generating **PART 1 of 2** of a comprehensive SQLite SQL Seed File for the Listening module (`src/core/src/database/seeds/listening/ielts_listening_band_<band>_test_<n>.sql`). This part covers **Section 1 and Section 2 only**. Section 3, Section 4, and the final combined SQL file will be produced in a separate follow-up prompt.

In THIS prompt, your job is ONLY to generate the validated transcripts for Section 1 and Section 2. Do NOT generate SQL, questions, or JSON yet — that comes after both transcripts are validated.

# Tech Stack
- **Database:** SQLite — target for the final `.sql` script (produced later, not in this step).
- **Data Format:** Standard SQL `INSERT INTO` statements with complex `JSONB` payloads for question options and accepted answers (produced later, not in this step).

# Feature Specification (context for the overall test — for your awareness only)
- **Section 1 (Transactional Dialogue):** Title + full Audio Transcript (e.g., everyday social context like a booking). Q1–10: Form/Sentence Completion.
- **Section 2 (Monologue):** Title + full Audio Transcript (e.g., everyday social context like a facility tour). Q11–20: Multiple Choice and Map Labeling (simulated via multiple choice/matching).
- Sections 3 and 4 are NOT part of this prompt.

# Transcript Technical Specifications (MANDATORY per Section)
*Each `transcript` field MUST comply with the technical parameters below. These parameters are non-negotiable and are designed to replicate the pacing, length, and linguistic complexity of authentic IELTS audio recordings. Respect the target word count strictly, as it directly determines the realistic audio duration.*

*The transcript must wrap the dialogue/monologue with one speaker label per line:*

```
Agent: ...
Customer: ...
Agent: ...
Customer: ...
```

*When counting words to validate the target word count below, do not count the dialogue tags or the speaker labels (e.g. "Agent:", "Customer:") — only count the actual spoken content.*

## Section 1 — Everyday conversation
- Speakers: **2 people** (typically customer service + customer, or similar)
- Audio duration: **~4 to 5 minutes**
- Transcript word count: **~700 to 900 words**
- Context: hotel booking, course enrollment, travel information, etc.
- Level: easiest, slow speech with natural pauses
- Must-include content hooks: several concrete testable facts (spelled names, numbers, dates, times, prices, addresses, phone/email), a question→answer→correction pattern, and at least one moment where a speaker corrects a previously stated detail (typical IELTS trap).

## Section 2 — Everyday monologue
- Speakers: **1 person** (sometimes with a brief initial exchange with a radio host)
- Audio duration: **~4 to 5 minutes**
- Transcript word count: **~700 to 900 words**
- Context: guide to a place, informative talk, radio announcement, facility presentation
- Level: lower-intermediate
- Must-include content hooks: a sequence of locations/features/options suitable for map labeling or matching, several distinct facts suitable for multiple-choice items, and signposting language ("first", "over to your left", "next", "finally").

# Agent Execution Workflow (MANDATORY order of operations)
*Follow this exact sequence. Do not skip steps or merge them into a single pass — each transcript's word-count and format constraints are strict, and generating both at once tends to produce transcripts that drift off target.*

1. **Generate the Section 1 transcript first, alone, in a single uninterrupted piece of writing.** Produce ONLY the title and transcript — nothing else.
2. **Validate the word count immediately**: count only the actual spoken content (excluding speaker labels). If the count falls outside 700–900, regenerate before moving on. Do NOT carry an out-of-range transcript forward.
3. **Generate the Section 2 transcript next, alone, in a single uninterrupted piece of writing.** Produce ONLY the title and transcript — nothing else.
4. **Validate the word count immediately**: count only the actual spoken content (excluding speaker labels). If the count falls outside 700–900, regenerate before moving on.
5. Output both validated transcripts using the exact template below. Do not add SQL, questions, JSON, or commentary of any kind.

# Data Handling: Output Requirements
- Output ONLY the two transcripts and their titles, each followed by its validated word count.
- No SQL, no questions, no JSONB, no IDs — those belong to the follow-up prompt.
- No preamble, no explanations, no meta-commentary.

# UUID Inventory (Input Section)
*Not consumed in this step (no SQL is generated here) — kept for consistency with the companion prompt that will assemble the final SQL file.*

**PASTE YOUR RANDOM UUIDS BELOW:**
```
PASTE_YOUR_RANDOM_UUIDS_BELOW
```

# These files already exist in seeds/
```sql
01_ielts_practice_test.sql
```

# Configuration Variables
- **TARGET_BAND_DIFFICULTY:** [5 to 9]
# Role: Senior Full-Stack Content Engineer & Database Architect & Senior IELTS Content Creator, Assessment Design, Educational Measurement

# Context
You are tasked with generating a comprehensive **SQLite SQL Seed File** specifically for the Listening module (`src/core/src/database/seeds/listening/ielts_listening_band_<band>_test_<n>.sql`). It will populate the database with a completely new, highly realistic listening test based on the Configuration Variables. The content must strictly mirror the official IELTS format, featuring brand-new, fully written out **Audio Transcripts**, prompts, and 40 mapped questions geared towards the specified Target Band complexity.

**This is PART 1 of 2: generate ONLY Section 1 and Section 2.**

# Tech Stack
- **Database:** SQLite - Target for the `.sql` script.
- **Data Format:** Standard SQL `INSERT INTO` statements with complex `JSONB` payloads for question options and accepted answers.

# Feature Specification

## 1. Database Seed Strategy & Relational Integrity
- **Do not use `TRUNCATE` in this script**.
- **Non-Deterministic UUIDs:** Generate unique **UUID v4** identifiers for all records (tests, sections, questions).

## 2. Seed: IELTS Listening Test
- **Test Record:** Create 1 entry in `listening_tests` using the Test Title.
- **Section 1 (Transactional Dialogue):** Include a clear **Title** and a full **Audio Transcript** (e.g., everyday social context like a booking). 
  - Q1-10: Form/Sentence Completion.
- **Section 2 (Monologue):** Include a clear **Title** and a full **Audio Transcript** (e.g., everyday social context like a facility tour).
  - Q11-20: Multiple Choice and Map Labeling (simulated via multiple choice/matching).

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

- **Section 1 — Everyday conversation**
  - Speakers: **2 people** (typically customer service + customer, or similar)
  - Audio duration: **~4 to 5 minutes**
  - Transcript word count: **~700 to 900 words**
  - Context: hotel booking, course enrollment, travel information, etc.
  - Level: easiest, slow speech with natural pauses

- **Section 2 — Everyday monologue**
  - Speakers: **1 person** (sometimes with a brief initial exchange with a radio host)
  - Audio duration: **~4 to 5 minutes**
  - Transcript word count: **~700 to 900 words**
  - Context: guide to a place, informative talk, radio announcement, facility presentation
  - Level: lower-intermediate

# Agent Execution Workflow (MANDATORY order of operations)
*Note to AI: Follow this exact sequence. Do not skip steps or merge them into a single pass — each transcript's word-count and format constraints are strict, and generating everything at once tends to produce transcripts that drift off target.*

1. **Generate each transcript separately, one at a time, in its own dedicated response/call.** For each of the 2 sections (in order), produce ONLY that section's full `audio_transcript` text (nothing else — no SQL, no questions yet). Each transcript must be generated in a single, uninterrupted call so the required word count, speaker count, and pacing/vocabulary level (per section 3 below) can all be satisfied consistently within one continuous piece of writing.
2. **Validate the word count immediately after generating each transcript**, before moving on: count only the actual spoken content (excluding speaker labels like "Agent:"/"Customer:"). If the count falls outside the target range for that section, regenerate that transcript before proceeding — do not carry an out-of-range transcript forward.
3. **Only after both transcripts are generated and validated**, move on to writing the questions (Q1-20) and the SQL seed script for Section 1 and Section 2.
4. **Cross-check consistency**: every fact, name, number, date, or detail referenced in an `accepted_answer` or question `option` must actually appear in its section's validated transcript (and vice versa — don't introduce answers the transcript never mentions). Fix any mismatch by adjusting the question, not by silently changing the already-validated transcript's word count.

# Data Handling: Output Requirements
- Provide the **complete, exact SQL script** for Section 1 and Section 2.
- Ensure the `audio_transcript` fields contain the full conversational text formatted with speaker labels.
- Ensure all `accepted_answers` and `options` are valid `::jsonb` arrays.
- Ensure the `question_order` sequences perfectly from 1 to 20.

# UUID Inventory (Input Section)

**PASTE YOUR RANDOM UUIDS BELOW:**
```
PASTE_YOUR_RANDOM_UUIDS_BELOW
```

*Note to AI: You must strictly use the UUIDs provided in this section for the Primary Keys (`id`) of the records. Ensure Foreign Key relationships correctly reference these specific values to maintain relational integrity.*

# These files already exist in seeds/

```sql
01_ielts_practice_test.sql
```

# Configuration Variables
- **TARGET_BAND_DIFFICULTY:** [5 to 9]
