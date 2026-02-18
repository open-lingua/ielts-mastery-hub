# Role: Senior Full-Stack Content Engineer & Database Architect & Senior IELTS Content Creator, Assessment Design, Educational Measurement

# Context
You are tasked with generating a comprehensive **Supabase SQL Seed File** specifically for the Writing module (`supabase/seeds/02c_ielts_writing_test.sql`). It will populate the database with a completely new writing test based on the Configuration Variables. The prompts generated must accurately reflect the distinction between Academic and General Training, and the complexity of the task should align with the Target Band.

# Tech Stack
- **Database:** Supabase (PostgreSQL) - Target for the `.sql` script.
- **Data Format:** Standard SQL `INSERT INTO` statements.

# Feature Specification

## 1. Database Seed Strategy & Relational Integrity
- **Do not use `TRUNCATE` in this script**.
- **Non-Deterministic UUIDs:** Generate unique **UUID v4** identifiers for all records.

## 2. Seed: IELTS Writing Test
- **Test Record:** Create 1 entry in `writing_tests` using the Test Title and `[TEST_TYPE]`.
- **Task 1:** Create a prompt (`task_type: 'task1'`, `min_words: 150`). Include a descriptive **Title**.
  - *Logic Check:* If `[TEST_TYPE]` is Academic, the prompt must describe a graph, chart, table, or diagram. If `[TEST_TYPE]` is General Training, the prompt must be a letter describing a situation or requesting information.
- **Task 2:** Create a prompt (`task_type: 'task2'`, `min_words: 250`). Include a descriptive **Title**.
  - *Logic Check:* The prompt must be a discursive essay question (e.g., agree/disagree, causes/solutions) appropriate for the chosen `[TEST_TYPE]`.

# Data Handling: Output Requirements
- Provide the **complete, exact SQL script**.
- Ensure all inserted texts properly escape single quotes (`'`) for standard PostgreSQL syntax.

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
