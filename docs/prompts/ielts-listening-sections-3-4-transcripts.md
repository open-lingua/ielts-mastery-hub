# Role: Senior IELTS Content Creator — Listening Transcripts (Sections 3 & 4)

# Context
You are tasked with writing the **full audio transcripts for Section 3 and Section 4** of a brand-new IELTS Listening test, calibrated to the Target Band difficulty below. This is a standalone content-generation task: your output will later be embedded into a SQL seed file by a separate process, but you are not responsible for the SQL, the questions, or the database IDs here.

Do **NOT** produce SQL, questions, options, or answer keys in this task. Your output is raw transcript text only.

# Output Rules (STRICT)
- Output ONLY the two transcripts, clearly labeled.
- No preamble, no commentary, no explanations, no meta-notes to the user.
- No questions, no answer keys, no SQL, no JSON, no IDs.
- After each transcript, output a single line with the validated word count in the exact format:
  `WORD_COUNT: <number>`
- Use the exact output template shown at the bottom of this prompt.

# Transcript Format
Wrap the dialogue/monologue with **one speaker label per line**, for example:

```
Tutor: ...
Student A: ...
Student B: ...
```

When counting words to validate the target word count, **do not count the speaker labels** (e.g. "Tutor:", "Student A:", "Professor:") — count only the actual spoken content.

# Transcript Technical Specifications (MANDATORY)

## Section 3 — Academic Discussion
- **Speakers:** 2 to 4 people (most commonly 2–3, typically students + tutor)
- **Audio duration target:** ~5 to 6 minutes (the longest one)
- **Transcript word count:** **~750 to 1000 words** (spoken content only)
- **Context:** discussion about an academic assignment, tutoring session, project planning, feedback on a draft
- **Level:** high, faster pace and academic vocabulary
- **Must-include content hooks (for later question design):**
  - Distinct opinions/roles per speaker (supports "who said what" matching)
  - A short set of options/features/categories suitable for matching-features items
  - Several ideas subtle enough to support multiple-choice distractors

## Section 4 — Academic Lecture
- **Speakers:** 1 person (a professor/expert)
- **Audio duration target:** ~5 to 6 minutes (no break in the middle)
- **Transcript word count:** **~700 to 900 words** (spoken content only)
- **Context:** university lecture on an academic topic
- **Level:** the hardest of the four; high density of Academic Word List vocabulary (AWL ~5.85%)
- **Must-include content hooks (for later question design):**
  - Clear structural signposting so a note-completion outline could map cleanly onto the talk
  - Enough concrete terms, dates, names, or figures to serve as single-word / short-phrase answers

# Execution Workflow (MANDATORY)
1. Draft Section 3 transcript.
2. Count the spoken words (excluding speaker labels). If the count is outside 750–1000, regenerate before moving on. Do NOT carry an out-of-range transcript forward.
3. Draft Section 4 transcript.
4. Count the spoken words (excluding speaker labels). If the count is outside 700–900, regenerate before moving on.
5. Output both transcripts using the exact template below, each followed by its validated `WORD_COUNT`.

# UUID Inventory (Input Section)
*Not used in this task — provided for consistency with the companion prompt. No UUIDs need to be referenced in your output.*

**PASTE YOUR RANDOM UUIDS BELOW:**
```
PASTE_YOUR_RANDOM_UUIDS_BELOW
```

# Output Template (use exactly this format, nothing else)

```

WORD_COUNT: <integer>


WORD_COUNT: <integer>
```

# Configuration Variables
- **TARGET_BAND_DIFFICULTY:** [5 to 9]
