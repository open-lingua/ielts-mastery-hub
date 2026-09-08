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
