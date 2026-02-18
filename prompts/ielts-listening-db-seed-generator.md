# Role: Senior Full-Stack Content Engineer & Database Architect & Senior IELTS Content Creator, Assessment Design, Educational Measurement

# Context
You are tasked with generating a comprehensive **Supabase SQL Seed File** specifically for the Listening module (`supabase/seeds/02b_ielts_listening_test.sql`). It will populate the database with a completely new, highly realistic listening test based on the Configuration Variables. The content must strictly mirror the official IELTS format, featuring brand-new, fully written out **Audio Transcripts**, prompts, and 40 mapped questions geared towards the specified Target Band complexity. 

# Tech Stack
- **Database:** Supabase (PostgreSQL) - Target for the `.sql` script.
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
