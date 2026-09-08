# Role: Senior Full-Stack Content Engineer & Database Architect & Senior IELTS Content Creator, Assessment Design, Educational Measurement

# Context
You are tasked with generating a comprehensive **SQLite SQL Seed File** specifically for the Listening module (`src/core/src/database/seeds/listening/ielts_listening_band_<band>_test_<n>.sql`). It will populate the database with a completely new, highly realistic listening test based on the Configuration Variables. The content must strictly mirror the official IELTS format, featuring brand-new, fully written out **Audio Transcripts**, prompts, and 40 mapped questions geared towards the specified Target Band complexity. 

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
- **Section 3 (Academic Dialogue):** Include a clear **Title** and a full **Audio Transcript** (e.g., 2-3 people discussing an assignment).
  - Q21-30: Multiple Choice and Matching Features.
- **Section 4 (Academic Monologue):** Include a clear **Title** and a full **Audio Transcript** (e.g., a university lecture).
  - Q31-40: Note/Summary Completion.

## 3. Transcript Technical Specifications (MANDATORY per Section)
*Note to AI: Each `transcript` field MUST comply with the technical parameters below. These parameters are non-negotiable and are designed to replicate the pacing, length, and linguistic complexity of authentic IELTS audio recordings. Respect the target word count strictly, as it directly determines the realistic audio duration.*

*Note to AI: The script will have a structure like the following, wrapping the dialogue/monologue in a `<DIALOGUE>` tag with one speaker label per line:*

<DIALOGUE>
Agent: ...
Customer: ...
Agent: ...
Customer: ...
Agent: ...
Customer: ...
</DIALOGUE>

*When counting words to validate the target word count below, do not count the `<DIALOGUE>`/`</DIALOGUE>` tags or the speaker labels (e.g. "Agent:", "Customer:") — only count the actual spoken content.*

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

# Data Handling: Output Requirements
- Provide the **complete, exact SQL script**.
- Ensure the `audio_transcript` fields contain the full conversational text formatted with speaker labels.
- Ensure all `accepted_answers` and `options` are valid `::jsonb` arrays.
- Ensure the `question_order` sequences perfectly from 1 to 40.

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
