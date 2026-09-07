# Spec: "Import Dataset" (Admin Section)

## 1. Summary and Objective

Add a new **Admin → Import Dataset** feature that lets an admin upload a JSON file (Reading, Writing, or Listening) matching the app's existing content schemas, validate it, and persist it into the local SQLite database in one atomic operation — without going through the manual multi-step `CreateContent` form. For Listening imports, the four section audio files must also be copied into a well-organized, discoverable folder structure under `~/.ielts-hub` and their paths recorded as `audio_url` on the corresponding `listening_sections` rows.

This is a superset of user story **US-14** (admin creation) that adds a **bulk JSON import** path, filling the "Bulk CSV/JSON import" gap explicitly marked "Out of Scope" in `docs/product.md` — this spec brings it into scope for JSON.

---

## 2. Product Requirements

### 2.1 User Stories

- **US-16: Import a test from JSON**
  As an admin, I want to upload a JSON file that already contains a full test (passages/sections/tasks, question groups, questions) so that I don't have to manually re-enter content built outside the app.

- **US-17: Import a Listening test with audio**
  As an admin, I want to attach 4 audio files (one per section) alongside the Listening JSON so that the imported test is immediately playable.

- **US-18: Get actionable import errors**
  As an admin, if my JSON is invalid I want a specific, human-readable message (e.g., "section 2 question_groups[1].questions[3] is missing `answer`") so I can fix the file and retry, instead of a generic failure.

### 2.2 Admin Flow (step-by-step)

1. Admin navigates to a new sidebar item **"Import Dataset"** (`/admin/import`), added to `AdminLayout.tsx`'s `navItems`, using an icon such as `UploadCloud`/`FileJson` from `lucide-react`, consistent with existing nav items.
2. Admin selects **Test Type**: Reading / Writing / Listening (segmented control / `Select`, same style as `CreateContent.tsx`'s type/difficulty selects).
3. Based on type:
   - Reading / Writing: a single file dropzone (`.json` only).
   - Listening: a file dropzone for the JSON **plus** 4 labeled dropzones/slots: "Section 1 audio", "Section 2 audio", "Section 3 audio", "Section 4 audio" (accepting `.mp3`/`.wav`/`.m4a`). Each slot is explicitly bound to `sections[n].section_number` — not inferred from upload order — to avoid ambiguity.
4. Admin clicks **"Validate"** (client-side/pre-flight structural check + preview: test title, counts of passages/sections/tasks, questions, groups) before committing.
5. Admin clicks **"Import"**.
   - UI shows a loading state (reuse `Loader2` spinner patterns from `CreateContent.tsx`).
   - On success: toast (`useToast`) with test title + id, and redirect to `/admin/content` (Content Library) or the new test's edit page.
   - On failure: inline error panel showing the **full error message** (not just a toast, since messages can be detailed) plus a "Copy error" button; nothing is written to DB or disk.
6. Optional secondary action: "Download example JSON" links per type (can point at `assets/examples/*` schemas or generated examples) to help admins prepare files.

### 2.3 Acceptance Criteria

- Selecting a type constrains the accepted file picker(s) and constrains the shown audio slots (only for Listening).
- For Listening, import is blocked client-side if fewer or more than 4 audio files are attached, or if a required section has no audio assigned to it.
- Import is **all-or-nothing**: partial rows never persist; on failure, any audio files copied during this attempt are removed.
- A successfully imported test appears immediately in Content Library / Dashboard recent items with status taken from the JSON's `status` field (`draft` default if absent, otherwise `published`).
- Re-importing the same JSON file (same `id`s) does not silently overwrite existing content unless the admin explicitly confirms an "overwrite" option (see Edge Cases).
- All validation error messages are in English and name the exact JSON path/field at fault.

### 2.4 Edge Cases

| Case | Behavior |
|---|---|
| JSON is not valid JSON (parse error) | Reject immediately: "The selected file is not valid JSON: `<parser error/location>`." |
| Required top-level field missing (e.g. `title`) | Reject: "Missing required field `title` at document root." |
| Wrong `test_type`/shape for selected import type (e.g. picks "Reading" but JSON has `sections` instead of `passages`) | Reject: "The selected file does not match the Reading schema (expected `passages[]`, found `sections[]`). Did you mean to import as Listening?" |
| Listening: JSON has `sections.length !== 4` | Reject: "Listening tests must have exactly 4 sections; found `<n>`." |
| Listening: audio file count ≠ 4, or a section has no matching audio | Reject: "Expected 4 audio files (one per section); received `<n>`." / "No audio file was assigned to Section `<n>`." |
| Duplicate `id` values within the same JSON (e.g. two questions share an id) | Reject: "Duplicate id `<uuid>` found at `<path1>` and `<path2>`." |
| `id` in JSON collides with an existing DB row from a different test | Treat JSON ids as **advisory only** — see §3.3, new UUIDs are always generated server-side; no collision possible. |
| Same test re-imported (same `title` + `created_by`, or same source JSON hash) | Detect via a title+creator match prompt: "A test with this title already exists (id `<existing_id>`). Import as a new copy?" Admin confirms to proceed (creates a new test with new ids) or cancels. |
| `~/.ielts-hub` or subfolders missing | Created automatically and silently (`create_dir_all`), same as `commands::storage::save_file` already does. |
| Disk write fails mid-copy (e.g. disk full) | Whole import fails; any files already written for this import are deleted; DB transaction rolled back/never committed. |
| Audio file extension unsupported | Reject: "Unsupported audio format `.<ext>` for Section `<n>`; expected mp3, wav, m4a, or ogg." |
| Large JSON/audio (no explicit limit today) | Recommend a soft warning above e.g. 100MB total audio, non-blocking. |

---

## 3. Technical Definition

### 3.1 JSON Contracts (derived from the examples)

All three types share:
```
{
  "id": string (uuid, ADVISORY ONLY — ignored, server always generates new ids),
  "created_by": string (uuid, ADVISORY ONLY — replaced by current admin's anon id),
  "title": string (required),
  "status": "draft" | "published" (optional, default "draft"),
  ...
}
```

#### Reading (`ReadingImport`)
| JSON field | Type | Required | Notes |
|---|---|---|---|
| `test_type` | string | optional | e.g. "Academic"; default `"Academic"` |
| `duration` | string | optional | default `"60 mins"` |
| `passages[]` | array | required, **exactly 3** (matches existing 3-passage engine assumption; reject with a specific count error otherwise, or allow 1–3 if flexible — see Open Questions) |
| `passages[].passage_number` | int | required | must be unique per test, 1-based |
| `passages[].title` | string | required |
| `passages[].content` | string | required |
| `passages[].notes` | string | optional |
| `passages[].question_groups[]` | array | required |
| `question_groups[].group_order` | int | required |
| `question_groups[].question_type` | string | required | must be one of the 13 known types used in `CreateContent.tsx`'s Select (`multiple-choice`, `true-false-not-given`, `yes-no-not-given`, `matching-headings`, `matching-information`, `matching-features`, `matching-sentence-endings`, `sentence-completion`, `summary-completion`, `note-completion`, `table-completion`, `flow-chart-completion`/`flowchart-completion`, `diagram-labeling`, `short-answer`) |
| `question_groups[].instructions` | string | required |
| `question_groups[].sequential_order` | bool | optional, default true |
| `question_groups[].word_limit` | string | optional |
| `question_groups[].has_word_bank` | bool | optional, default false |
| `question_groups[].word_bank[]` | string[] | required if `has_word_bank=true` |
| `question_groups[].multiple_selection` / `select_count` | bool/int | optional |
| `questions[]` | array | required, non-empty |
| `questions[].question_order` | int | required, unique within the whole test (1–40) |
| `questions[].text` | string | required (except summary-completion continuation rows, which may be `""`) |
| `questions[].answer` | string | required for scoreable types |
| `questions[].options[]` | array | required for MCQ/matching-sentence-endings — each `{id, text, is_correct}` |
| `questions[].accepted_answers[]` | array | for completion/short-answer types — each is either `string` or `{id, text}` (both shapes seen in example — normalize both) |
| `questions[].completion_gaps[]` | array | for table/note/flowchart completion — each `{id, gap_text, answer}` |
| `questions[].matching_pairs[]` | array | for matching-features type (not present in example but exists in DB schema) |

#### Writing (`WritingImport`)
| JSON field | Type | Required |
|---|---|---|
| `tasks[]` | array | required, **exactly 2** |
| `tasks[].task_number` | int (1 or 2) | required, unique |
| `tasks[].task_type` | `"task1"` \| `"task2"` | required |
| `tasks[].title` | string | required |
| `tasks[].suggested_time` | string | optional, default `"20 mins"`/`"40 mins"` by task |
| `tasks[].prompt` | string | required |
| `tasks[].min_words` | int | required (150 for task1, 250 for task2 by convention) |
| `tasks[].max_words` | string | optional |
| `tasks[].image_url` | string | optional (Task 1 chart/graph image; out of scope for this import unless a 5th "task image" upload slot is added — see Open Questions) |
| `tasks[].figure_description` | string | optional, nullable, default `null` (text description of the Task 1 chart/diagram, e.g. for accessibility or when no image is provided) |
| `difficulty` | string | optional, default `"7"` (present in DB schema, absent from writing example — default applied) |

#### Listening (`ListeningImport`)
| JSON field | Type | Required |
|---|---|---|
| `duration` | string | optional, default `"40 mins"` |
| `sections[]` | array | required, **exactly 4** |
| `sections[].section_number` | int (1–4) | required, unique |
| `sections[].title` | string | required |
| `sections[].transcript` | string | required |
| `sections[].audio_url` (in example, e.g. `./section_1.mp3`) | string | **not persisted verbatim** — used only as a hint to map which uploaded audio file belongs to this section by filename/section number; final `audio_url` is server-computed (see §3.4) |
| `sections[].question_groups[]` | same shape/rules as Reading |

Common validation rules across all types:
- Every array with an `_order`/`_number` field must have contiguous, unique ordering (1-based) matching the count of items.
- `question_order` (or task_number/section_number at that level) must map exactly to 1..40 for Reading/Listening (or 1..2 for Writing tasks) with no gaps/duplicates across the whole test.
- Strings that are supposed to be non-empty (`title`, `text` for most types) must not be blank/whitespace-only, except explicitly-allowed empty continuation rows (summary-completion follow-up questions).

### 3.2 Field-Level Mapping (JSON → SQLite)

Using the real tables from `20260811000000_initial_schema.sql`:

**Reading**
- `title, test_type, duration, status, created_by(=current admin)` → `reading_tests` (`difficulty` defaults `'7'` unless added to JSON schema)
- `passages[]` → `reading_passages` (`id` generated, `test_id`, `passage_number`, `title`, `content`, `notes`)
- `passages[].question_groups[]` → `reading_question_groups` (`id` generated, `passage_id`, `group_order`, `question_type`, `instructions`, `word_limit`, `has_word_bank`, `word_bank` as JSON string, `sequential_order`, `multiple_selection`, `select_count`)
- `questions[]` → `reading_questions` (`id` generated, `group_id`, `question_order`, `text`, `answer`, `options`/`matching_pairs`/`completion_gaps`/`accepted_answers` as JSON strings)

**Writing**
- `title, status, created_by` → `writing_tests`
- `tasks[]` → `writing_tasks` (`id` generated, `test_id`, `task_number`, `task_type`, `title`, `difficulty`, `suggested_time`, `prompt`, `min_words`, `max_words`, `image_url`, `include_model_answer` default 0, `model_answer` default '', `figure_description` default `null`)

**Listening**
- `title, duration, status, created_by` → `listening_tests` (`difficulty` defaults `'7'`)
- `sections[]` → `listening_sections` (`id` generated, `test_id`, `section_number`, `title`, `transcript`, `audio_url` = resolved final path, see §3.4)
- `question_groups[]` → `listening_question_groups` (same columns as reading groups but `section_id` FK)
- `questions[]` → `listening_questions` (same as reading_questions plus `timestamp` column — optional, default `''`)

All JSON `id`/`created_by` fields in the source file are **ignored for insertion** — the backend always mints new UUIDv4s via `uuid::Uuid::new_v4()` (as done in existing `repositories::*::insert`), and `created_by` is always the current admin's id, matching the existing ownership model enforced in e.g. `reading_passages::insert`.

### 3.3 Validation Layer & Import Service Design

Location, following existing conventions (`src/core/AGENTS.md`, `src/core/README.md` module layout):

```
src/core/src/
├── models/
│   └── import.rs           # NEW: Deserialize structs mirroring the JSON contracts (§3.1)
├── services/
│   └── import_service.rs   # NEW: validate_* + import_* orchestration, calls repositories
├── commands/
│   └── import.rs           # NEW: #[tauri::command] entry points
```

**`models/import.rs`** — `#[derive(Debug, Deserialize)]` structs: `ReadingImport`, `WritingImport`, `ListeningImport`, plus shared `QuestionGroupImport`, `QuestionImport`, etc. Use `#[serde(deny_unknown_fields)]` off (be lenient on extra fields) but validate required fields manually post-deserialize rather than relying solely on serde's `Option` absence, so error messages can be field-path-specific (serde's own errors are too generic for the "actionable" requirement).

**`services/import_service.rs`** — proposed signatures:

```rust
pub struct ImportError {
    pub path: String,      // e.g. "sections[1].question_groups[0].questions[3].answer"
    pub message: String,   // human-readable English explanation
}

pub enum ImportKind { Reading, Writing, Listening }

pub struct AudioAssignment {
    pub section_number: i64,
    pub file_name: String,
    pub data: Vec<u8>,
}

/// Pure structural + semantic validation, no I/O side effects.
pub fn validate_reading(raw: &serde_json::Value) -> Result<ReadingImport, Vec<ImportError>>;
pub fn validate_writing(raw: &serde_json::Value) -> Result<WritingImport, Vec<ImportError>>;
pub fn validate_listening(
    raw: &serde_json::Value,
    audios: &[AudioAssignment],
) -> Result<ListeningImport, Vec<ImportError>>;

/// Orchestrates: begin DB transaction -> insert test + children -> (listening only) copy audio
/// files -> commit; on any failure, rollback tx and delete any audio already written.
pub async fn import_reading(pool: &Db, user_id: &str, data: ReadingImport) -> Result<String, AppError>;
pub async fn import_writing(pool: &Db, user_id: &str, data: WritingImport) -> Result<String, AppError>;
pub async fn import_listening(
    pool: &Db,
    user_id: &str,
    data: ListeningImport,
    audios: Vec<AudioAssignment>,
) -> Result<String, AppError>;
```

**`commands/import.rs`** — Tauri command surface (registered in `lib.rs`'s `invoke_handler`, following the existing pattern):

```rust
#[tauri::command]
pub async fn import_reading_test(
    user_id: String,
    json_data: serde_json::Value,
    db: tauri::State<'_, Db>,
) -> Result<String, AppError>;

#[tauri::command]
pub async fn import_writing_test(
    user_id: String,
    json_data: serde_json::Value,
    db: tauri::State<'_, Db>,
) -> Result<String, AppError>;

#[tauri::command]
pub async fn import_listening_test(
    user_id: String,
    json_data: serde_json::Value,
    audio_files: Vec<ListeningAudioUpload>, // { section_number: i64, file_name: String, file_data: Vec<u8> }
    db: tauri::State<'_, Db>,
) -> Result<String, AppError>;
```

Frontend wrappers added to `src/ui/lib/tauri.ts` mirroring existing `create*Test` helpers:
```ts
export async function importReadingTest(userId: string, json: unknown): Promise<string> { ... }
export async function importWritingTest(userId: string, json: unknown): Promise<string> { ... }
export async function importListeningTest(
  userId: string,
  json: unknown,
  audioFiles: { sectionNumber: number; file: File }[]
): Promise<string> { ... }
```
And a new `src/ui/services/importService.ts` for any client-side pre-validation/preview logic, analogous to `readingTestService.ts`/`listeningService.ts`.

### 3.4 Audio File Handling for Listening

**Storage root:** `~/.ielts-hub` (same base directory already used by `commands::storage::save_file` for `writing-assets` and `listening-audio`).

**Proposed folder structure (new, descriptive, test-scoped):**

```
~/.ielts-hub/
└── listening-tests/
    └── <test-id>-<title-slug>/
        ├── section-1.<ext>
        ├── section-2.<ext>
        ├── section-3.<ext>
        └── section-4.<ext>
```

- `<test-id>` = the **newly generated** UUID of the `listening_tests` row (not the JSON's advisory id), guaranteeing no collision across re-imports.
- `<title-slug>` = lowercased, ASCII, hyphenated slug of the test title (e.g. `ielts-academic-listening-relocation-community-centres-architecture`), truncated to ~60 chars, for human readability when browsing the filesystem.
- File name is fixed per section (`section-<n>.<ext>`) — the original uploaded filename is discarded except for its extension, since section number (not filename) is the authoritative mapping key chosen explicitly by the admin in the UI (§2.2 step 3). This avoids relying on the JSON's `audio_url` hint (`./section_1.mp3`), though that hint may be used as a *default suggestion* to pre-fill which upload slot the admin should use.
- Extension is taken from the uploaded file (validated against an allow-list: `mp3`, `wav`, `m4a`, `ogg`); rejected otherwise (see Edge Cases table).

**When folders are created:** Only during a successful, committed import — the whole `listening-tests/<test-id>-<slug>/` directory tree is created via `tokio::fs::create_dir_all` right before writing files, inside the same service function that performs the DB insert, called only after JSON validation has fully passed.

**`audio_url` persisted value:** the **absolute filesystem path** to the file (e.g. `/home/alice/.ielts-hub/listening-tests/<id>-<slug>/section-1.mp3`), exactly matching the existing convention in `commands::storage::save_file`, which returns the absolute path and where the frontend calls `convertFileSrc(path)` (Tauri's asset-protocol helper, already enabled per `RELEASES.md`: *"enable asset protocol for ~/.ielts-hub"*) to turn it into a playable URL at runtime. This keeps the new feature consistent with `uploadListeningAudio`'s existing behavior — the DB never stores a `convertFileSrc`-transformed URL, only the raw path, and the UI re-derives the playable URL via `convertFileSrc` at read time (see `listeningPracticeService.ts` / audio player components) — confirm this by checking how `audio_url` is consumed by the player component before finalizing (Open Question).

**Collision handling:** Because `<test-id>` is always a freshly generated UUID, directory collisions are structurally impossible even if the same JSON (with the same advisory `id`/title) is imported multiple times — each import creates its own timestamp-free but UUID-unique folder. The only "collision" a user perceives is duplicate *titles* in the test list, handled by the confirm-before-import UX in Edge Cases, not by file-path collision logic.

**Rollback/cleanup:** The import service must track every file path it successfully wrote during the current import attempt. If:
- validation fails before any I/O → nothing to clean up (fail fast, before touching disk or DB).
- DB insert fails after some audio files were already copied → all previously copied files for this attempt are deleted, and the just-created test directory is removed if now empty.
- DB transaction commits successfully → files are kept permanently; no further action.

Recommended implementation shape:
```rust
async fn import_listening(...) -> Result<String, AppError> {
    let mut tx = pool.begin().await?;
    let test_id = insert_listening_test(&mut tx, ...).await?;
    let mut written_files: Vec<PathBuf> = Vec::new();

    let result: Result<(), AppError> = async {
        let dir = build_test_dir(&test_id, &title);
        tokio::fs::create_dir_all(&dir).await?;
        for section in &data.sections {
            let path = dir.join(format!("section-{}.{}", section.section_number, ext));
            tokio::fs::write(&path, audio_bytes).await?;
            written_files.push(path.clone());
            insert_listening_section(&mut tx, ..., audio_url: path.to_string_lossy()).await?;
        }
        insert_groups_and_questions(&mut tx, ...).await?;
        Ok(())
    }.await;

    match result {
        Ok(()) => { tx.commit().await?; Ok(test_id) }
        Err(e) => {
            tx.rollback().await.ok();
            for f in written_files { let _ = tokio::fs::remove_file(&f).await; }
            let _ = tokio::fs::remove_dir(&dir).await; // no-op if not empty
            Err(e)
        }
    }
}
```

### 3.5 Transaction / Rollback Strategy

- Use a single `sqlx::Transaction` (`pool.begin()`) spanning: test row insert → all children (passages/sections/tasks) → all question groups → all questions.
- Every repository call used during import must accept `&mut Transaction` (or the import service duplicates minimal insert logic against the transaction rather than the pool) — this is a deviation from the current `repositories::*::insert(pool: &Db, ...)` signatures, which take a pool directly. **Action needed:** either (a) add transaction-aware insert variants used only by the import path, or (b) refactor repositories to accept `impl Executor` generically. Recommend (a) for now to avoid touching existing, tested code paths — new `insert_tx(&mut tx, ...)` functions colocated in the same repository files.
- Any error at any stage aborts the transaction (`tx.rollback()`), and, for Listening, triggers audio cleanup as in §3.4.
- No partial commit is possible: only the last line of the service function calls `tx.commit()`.
- The Tauri command layer surfaces `AppError` (already `Serialize`) to the frontend `catch` block, consistent with existing error propagation (`src/core/AGENTS.md`).

### 3.6 Error Catalog

| Code / Scenario | Trigger | English Message Template |
|---|---|---|
| `INVALID_JSON` | File content is not parseable JSON | "The selected file is not valid JSON. Parser error: `{details}`." |
| `MISSING_FIELD` | Required field absent | "Missing required field `{path}`." |
| `INVALID_TYPE` | Field has wrong JSON type | "Field `{path}` must be a `{expected_type}`, got `{actual_type}`." |
| `EMPTY_STRING` | Required text field blank | "Field `{path}` cannot be empty." |
| `WRONG_SECTION_COUNT` | Listening sections ≠ 4 | "Listening tests must contain exactly 4 sections; found {n}." |
| `WRONG_PASSAGE_COUNT` | Reading passages ≠ expected | "Reading tests must contain exactly {expected} passages; found {n}." |
| `WRONG_TASK_COUNT` | Writing tasks ≠ 2 | "Writing tests must contain exactly 2 tasks; found {n}." |
| `DUPLICATE_ID` | Repeated id within file | "Duplicate id `{id}` found at `{path1}` and `{path2}`." |
| `DUPLICATE_ORDER` | Repeated `question_order`/`section_number`/etc. | "Duplicate `{field}` value `{value}` at `{path1}` and `{path2}`." |
| `NON_CONTIGUOUS_ORDER` | Ordering has gaps | "`{field}` values must be contiguous starting at 1; found gap at `{value}`." |
| `SCHEMA_MISMATCH` | JSON shape doesn't match selected type | "The selected file does not match the {expected} schema (expected `{expected_key}`, found `{found_key}`). Did you mean to import as {suggested_type}?" |
| `UNKNOWN_QUESTION_TYPE` | `question_type` not in known list | "Unknown `question_type` value `{value}` at `{path}`. Expected one of: {list}." |
| `WORD_BANK_REQUIRED` | `has_word_bank=true` but `word_bank` empty | "`{path}.word_bank` must be a non-empty array when `has_word_bank` is true." |
| `AUDIO_COUNT_MISMATCH` | Not exactly 4 audio files | "Expected exactly 4 audio files (one per section); received {n}." |
| `AUDIO_MISSING_FOR_SECTION` | A section has no audio assigned | "No audio file was assigned to Section {n}." |
| `AUDIO_UNSUPPORTED_FORMAT` | Extension not allowed | "Unsupported audio format `.{ext}` for Section {n}; expected mp3, wav, m4a, or ogg." |
| `DUPLICATE_TITLE` | Existing test with same title/creator | "A test titled \"{title}\" already exists (id `{existing_id}`). Confirm to import as a new copy." |
| `IO_ERROR` | Filesystem failure during audio copy | "Failed to save audio file for Section {n}: {os_error}. The import was cancelled and no data was saved." |
| `DB_ERROR` | Any sqlx error during transaction | "A database error occurred while saving the test: {db_error}. No changes were saved." |

---

## 4. UI Integration Note

The new "Import Dataset" page must reuse the existing design system exactly as the rest of Admin does: `AdminLayout` shell, shadcn/ui primitives (`Card`, `Button`, `Select`, `Input`, `Badge`, `Collapsible`, toasts via `useToast`), Tailwind semantic tokens (no hardcoded colors), `lucide-react` icons matching the sidebar's icon style, and `framer-motion` entrance animations consistent with `AdminDashboard.tsx`/`CreateContent.tsx`. The step flow (type selector → file/audio pickers → preview/validate → commit) should visually resemble the existing `CreateContent.tsx` tabbed/section pattern and reuse `TestPreviewModal` if feasible to preview the parsed content before committing. No UI code is included here per the request scope.

---

## 5. Assumptions and Open Questions

1. **Passage/section/task counts:** Assumed Reading = exactly 3 passages, Listening = exactly 4 sections, Writing = exactly 2 tasks, matching current engine assumptions (`ReadingModule.tsx` iterates `passages`, product doc says "3 passages / 4 sections"). Should imports be allowed to be more flexible (e.g. 1–3 passages) for partial/custom tests? Needs confirmation.
2. **`audio_url` consumption:** Need to confirm whether the Listening practice player calls `convertFileSrc(audio_url)` at read time or expects `audio_url` to already be a converted asset URL stored in the DB (current `uploadListeningAudio` returns the converted URL to the frontend, which then presumably stores *that* value via `createListeningSection`). If the DB is expected to store the `asset://` URL rather than the raw path, the import command must perform the same `convertFileSrc`-equivalent conversion server-side (or return raw paths and let the frontend convert before calling `create_listening_sections`, mirroring `resolveAudioUrls` in `listeningService.ts`). This spec currently proposes storing the raw absolute path for consistency with `storage.rs::save_file`'s return value, but the exact consumption point in the player component should be verified before implementation.
3. **Repository transaction support:** Existing `repositories::*::insert` functions take `&Db` (pool), not a transaction. Implementing true atomicity requires either new transaction-aware variants or a broader refactor of the repository layer to be `Executor`-generic. This is flagged as required scope for this feature, not optional.
4. **Duplicate-title detection:** Proposed matching on `(title, created_by)` — confirm whether admins expect duplicate-detection to also consider unpublished drafts, or only published tests.
5. **Task 1 image (`image_url`) for Writing:** The Writing JSON schema includes `image_url` but the import spec doesn't define a file upload for it since the given example has empty `image_url`. If admins need to import Task 1 charts/diagrams as well, a 5th optional file upload slot for Writing imports should be added, or `image_url` should accept only an external URL string.
6. **Difficulty field:** Reading/Listening JSON examples include a top-level `difficulty`-like value only implicitly (not shown in the shared examples). The DB requires `difficulty` on `reading_tests`/`listening_tests`. Confirm whether the JSON contract should require it explicitly (e.g. `"difficulty": "9"`) rather than defaulting to `'7'` for all imports.
7. **Max file size limits:** No current limit enforced in `commands::storage`; recommend adding one for imported audio (e.g. per-file 50MB) to avoid IPC payload issues over Tauri's `invoke`, since files are passed as `Vec<u8>` bytes over IPC rather than streamed.
8. **Client vs. server validation duplication:** Recommend implementing full validation only in Rust (source of truth) and a lightweight structural pre-check in TypeScript purely for early UX feedback (file counts, JSON parse), to avoid maintaining two validation rule sets.
