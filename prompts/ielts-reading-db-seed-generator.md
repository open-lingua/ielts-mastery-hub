# Role: Senior Full-Stack Content Engineer & Database Architect & Senior IELTS Content Creator, Assessment Design, Educational Measurement

# Context
You are tasked with generating a comprehensive **Supabase SQL Seed File** specifically for the Reading module (`supabase/seeds/02a_ielts_reading_test.sql`). This script must act as a seamless continuation of our existing database initialization. It will populate the database with a completely new, highly realistic reading test based on the Configuration Variables provided above. The content must strictly mirror the official IELTS format for the specified Test Type and target the vocabulary/complexity appropriate for the Target Band. This data will be directly consumed by our frontend practice engine.

# Tech Stack
- **Database:** Supabase (PostgreSQL) - Target for the `.sql` script.
- **Data Format:** Standard SQL `INSERT INTO` statements with complex `JSONB` payloads for question options and accepted answers.

# Feature Specification

## 1. Database Seed Strategy & Relational Integrity
- **Do not use `TRUNCATE` in this script**, as it should append to existing seed data.
- **Non-Deterministic UUIDs:** Generate unique **UUID v4** identifiers for all records (e.g., `'550e8400-e29b-41d4-a716-446655440000'`) to eliminate primary key collisions.

## 2. Seed: IELTS Reading Test
- **Test Record:** Create 1 entry in `reading_tests` using the Test Title and `[TEST_TYPE]`.
- **Passage 1:** Generte a new text (~600 words) suited for Section 1 of the chosen `[TEST_TYPE]`. Include a suitable **Title**.
  - Q1-13. Question Types: TRUE/FALSE/NOT GIVEN, Table Completion, Short Answer.
- **Passage 2:** Generate a new text (~750 words) suited for Section 2. Include a suitable **Title**.
  - Q14-27. Question Types: Matching Headings, Matching Information, Multiple Choice.
- **Passage 3:** Generate a new text (~800 words) suited for Section 3 (more complex/abstract). Include a suitable **Title**.
  - Q28-40. Question Types: YES/NO/NOT GIVEN, Matching Sentence Endings, Summary Completion.

# Data Handling: Output Requirements
- Provide the **complete, exact SQL script**.
- Ensure all `accepted_answers` and `options` are valid `::jsonb` arrays (e.g., `'["TRUE", "True", "true"]'::jsonb`).
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

- **TEST_TYPE:** [Academic / General Training]
- **TARGET_BAND_DIFFICULTY:** [5 to 9]
