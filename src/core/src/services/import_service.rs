use std::collections::HashMap;
use std::path::{Path, PathBuf};

use chrono::Utc;
use serde_json::Value;
use sqlx::{Sqlite, Transaction};
use uuid::Uuid;

use crate::database::Db;
use crate::error::AppError;
use crate::models::import::{
    ListeningImport, PassageImport, QuestionGroupImport, ReadingImport, TaskImport, WritingImport,
};

const KNOWN_QUESTION_TYPES: &[&str] = &[
    "multiple-choice",
    "tfng",
    "true-false-not-given",
    "ynng",
    "yes-no-not-given",
    "matching-headings",
    "matching-information",
    "matching-features",
    "matching-sentence-endings",
    "sentence-completion",
    "summary-completion",
    "note-completion",
    "table-completion",
    "flow-chart-completion",
    "flowchart-completion",
    "diagram-labeling",
    "short-answer",
];

const ALLOWED_AUDIO_EXTS: &[&str] = &["mp3", "wav", "m4a", "ogg"];
const MAX_AUDIO_BYTES: usize = 50 * 1024 * 1024;

#[derive(Debug, Clone)]
pub struct ImportError {
    pub path: String,
    pub message: String,
}

impl ImportError {
    fn new(path: impl Into<String>, message: impl Into<String>) -> Self {
        Self {
            path: path.into(),
            message: message.into(),
        }
    }

    pub fn to_message(&self) -> String {
        format!("{} (at `{}`)", self.message, self.path)
    }
}

pub fn errors_to_string(errors: &[ImportError]) -> String {
    errors
        .iter()
        .map(ImportError::to_message)
        .collect::<Vec<_>>()
        .join("\n")
}

pub struct AudioAssignment {
    pub section_number: i64,
    pub file_name: String,
    pub data: Vec<u8>,
}

impl AudioAssignment {
    pub fn to_meta(&self) -> AudioMeta {
        AudioMeta {
            section_number: self.section_number,
            file_name: self.file_name.clone(),
            size: self.data.len(),
        }
    }
}

#[derive(Debug, Clone)]
pub struct AudioMeta {
    pub section_number: i64,
    pub file_name: String,
    pub size: usize,
}

// ── shared helpers ──────────────────────────────────────────────────────────

fn find_duplicate_ids(
    value: &Value,
    path: &str,
    seen: &mut HashMap<String, String>,
    errors: &mut Vec<ImportError>,
) {
    match value {
        Value::Object(map) => {
            if let Some(Value::String(id)) = map.get("id") {
                if let Some(prev_path) = seen.get(id) {
                    errors.push(ImportError::new(
                        path,
                        format!("Duplicate id `{id}` found at `{prev_path}` and `{path}`."),
                    ));
                } else {
                    seen.insert(id.clone(), path.to_string());
                }
            }
            for (key, val) in map {
                if key == "id" {
                    continue;
                }
                find_duplicate_ids(val, &format!("{path}.{key}"), seen, errors);
            }
        }
        Value::Array(items) => {
            for (i, item) in items.iter().enumerate() {
                find_duplicate_ids(item, &format!("{path}[{i}]"), seen, errors);
            }
        }
        _ => {}
    }
}

fn validate_ordering(values: &[i64], field: &str, context: &str, errors: &mut Vec<ImportError>) {
    let mut counts: HashMap<i64, usize> = HashMap::new();
    for v in values {
        *counts.entry(*v).or_insert(0) += 1;
    }
    for (v, count) in &counts {
        if *count > 1 {
            errors.push(ImportError::new(
                context,
                format!("Duplicate `{field}` value `{v}` found in {context}."),
            ));
        }
    }
    let n = values.len() as i64;
    let missing: Vec<i64> = (1..=n).filter(|i| !counts.contains_key(i)).collect();
    if !missing.is_empty() {
        errors.push(ImportError::new(
            context,
            format!("`{field}` values in {context} must be contiguous starting at 1; missing {missing:?}."),
        ));
    }
}

fn validate_question_group(group: &QuestionGroupImport, path: &str, errors: &mut Vec<ImportError>) {
    let question_type = group.question_type.as_deref().unwrap_or("");
    if !KNOWN_QUESTION_TYPES.contains(&question_type) {
        errors.push(ImportError::new(
            format!("{path}.question_type"),
            format!(
                "Unknown `question_type` value `{question_type}`. Expected one of: {}.",
                KNOWN_QUESTION_TYPES.join(", ")
            ),
        ));
    }
    if group.has_word_bank.unwrap_or(false) {
        let empty = match &group.word_bank {
            Some(Value::Array(a)) => a.is_empty(),
            _ => true,
        };
        if empty {
            errors.push(ImportError::new(
                format!("{path}.word_bank"),
                "`word_bank` must be a non-empty array when `has_word_bank` is true.".to_string(),
            ));
        }
    }
    for (qi, question) in group.questions.iter().enumerate() {
        let is_summary_continuation = question_type == "summary-completion";
        let text_blank = question.text.as_deref().unwrap_or("").trim().is_empty();
        if text_blank && !is_summary_continuation {
            errors.push(ImportError::new(
                format!("{path}.questions[{qi}].text"),
                "Field cannot be empty.".to_string(),
            ));
        }
    }
}

fn json_or_default(v: &Option<Value>, default: &str) -> String {
    v.as_ref()
        .map(|x| x.to_string())
        .unwrap_or_else(|| default.to_string())
}

fn normalize_accepted_answers(v: &Option<Value>) -> String {
    let arr = match v {
        Some(Value::Array(a)) => a.clone(),
        _ => return "[]".to_string(),
    };
    let normalized: Vec<Value> = arr
        .into_iter()
        .map(|item| match item {
            Value::String(s) => serde_json::json!({ "id": Uuid::new_v4().to_string(), "text": s }),
            Value::Object(mut map) => {
                if !map.contains_key("id") {
                    map.insert("id".into(), Value::String(Uuid::new_v4().to_string()));
                }
                Value::Object(map)
            }
            other => other,
        })
        .collect();
    Value::Array(normalized).to_string()
}

fn rename_keys(v: &Option<Value>, renames: &[(&str, &str)]) -> String {
    let arr = match v {
        Some(Value::Array(a)) => a.clone(),
        _ => return "[]".to_string(),
    };
    let normalized: Vec<Value> = arr
        .into_iter()
        .map(|item| {
            if let Value::Object(map) = item {
                let mut new_map = serde_json::Map::new();
                for (k, val) in map {
                    let renamed = renames
                        .iter()
                        .find(|(from, _)| *from == k)
                        .map(|(_, to)| *to);
                    new_map.insert(renamed.unwrap_or(&k).to_string(), val);
                }
                Value::Object(new_map)
            } else {
                item
            }
        })
        .collect();
    Value::Array(normalized).to_string()
}

// ── validation ───────────────────────────────────────────────────────────────

pub fn validate_reading(raw: &Value) -> Result<ReadingImport, Vec<ImportError>> {
    if raw.get("passages").is_none() {
        if raw.get("sections").is_some() {
            return Err(vec![ImportError::new(
                "$",
                "The selected file does not match the Reading schema (expected `passages[]`, found `sections[]`). Did you mean to import as Listening?",
            )]);
        }
        if raw.get("tasks").is_some() {
            return Err(vec![ImportError::new(
                "$",
                "The selected file does not match the Reading schema (expected `passages[]`, found `tasks[]`). Did you mean to import as Writing?",
            )]);
        }
    }

    let data: ReadingImport = serde_json::from_value(raw.clone()).map_err(|e| {
        vec![ImportError::new(
            "$",
            format!("The selected file is not valid JSON: {e}"),
        )]
    })?;

    let mut errors = Vec::new();
    let mut seen_ids = HashMap::new();
    find_duplicate_ids(raw, "$", &mut seen_ids, &mut errors);

    if data.title.as_deref().unwrap_or("").trim().is_empty() {
        errors.push(ImportError::new(
            "title",
            "Missing required field `title` at document root.",
        ));
    }
    if data.passages.len() != 3 {
        errors.push(ImportError::new(
            "passages",
            format!(
                "Reading tests must contain exactly 3 passages; found {}.",
                data.passages.len()
            ),
        ));
    }
    validate_ordering(
        &data
            .passages
            .iter()
            .map(|p| p.passage_number.unwrap_or(0))
            .collect::<Vec<_>>(),
        "passage_number",
        "passages",
        &mut errors,
    );

    let mut all_question_orders = Vec::new();
    for (pi, passage) in data.passages.iter().enumerate() {
        let path = format!("passages[{pi}]");
        if passage.title.as_deref().unwrap_or("").trim().is_empty() {
            errors.push(ImportError::new(
                format!("{path}.title"),
                "Field cannot be empty.",
            ));
        }
        for (gi, group) in passage.question_groups.iter().enumerate() {
            let group_path = format!("{path}.question_groups[{gi}]");
            validate_question_group(group, &group_path, &mut errors);
            for question in &group.questions {
                all_question_orders.push(question.question_order.unwrap_or(0));
            }
        }
    }
    validate_ordering(
        &all_question_orders,
        "question_order",
        "the test",
        &mut errors,
    );

    if errors.is_empty() {
        Ok(data)
    } else {
        Err(errors)
    }
}

pub fn validate_writing(raw: &Value) -> Result<WritingImport, Vec<ImportError>> {
    if raw.get("tasks").is_none() {
        if raw.get("passages").is_some() {
            return Err(vec![ImportError::new(
                "$",
                "The selected file does not match the Writing schema (expected `tasks[]`, found `passages[]`). Did you mean to import as Reading?",
            )]);
        }
        if raw.get("sections").is_some() {
            return Err(vec![ImportError::new(
                "$",
                "The selected file does not match the Writing schema (expected `tasks[]`, found `sections[]`). Did you mean to import as Listening?",
            )]);
        }
    }

    let data: WritingImport = serde_json::from_value(raw.clone()).map_err(|e| {
        vec![ImportError::new(
            "$",
            format!("The selected file is not valid JSON: {e}"),
        )]
    })?;

    let mut errors = Vec::new();
    let mut seen_ids = HashMap::new();
    find_duplicate_ids(raw, "$", &mut seen_ids, &mut errors);

    if data.title.as_deref().unwrap_or("").trim().is_empty() {
        errors.push(ImportError::new(
            "title",
            "Missing required field `title` at document root.",
        ));
    }
    if data.tasks.len() != 2 {
        errors.push(ImportError::new(
            "tasks",
            format!(
                "Writing tests must contain exactly 2 tasks; found {}.",
                data.tasks.len()
            ),
        ));
    }
    validate_ordering(
        &data
            .tasks
            .iter()
            .map(|t| t.task_number.unwrap_or(0))
            .collect::<Vec<_>>(),
        "task_number",
        "tasks",
        &mut errors,
    );
    for (ti, task) in data.tasks.iter().enumerate() {
        let path = format!("tasks[{ti}]");
        if task.title.as_deref().unwrap_or("").trim().is_empty() {
            errors.push(ImportError::new(
                format!("{path}.title"),
                "Field cannot be empty.",
            ));
        }
        if task.prompt.as_deref().unwrap_or("").trim().is_empty() {
            errors.push(ImportError::new(
                format!("{path}.prompt"),
                "Field cannot be empty.",
            ));
        }
    }

    if errors.is_empty() {
        Ok(data)
    } else {
        Err(errors)
    }
}

pub fn validate_listening(
    raw: &Value,
    audios: &[AudioMeta],
) -> Result<ListeningImport, Vec<ImportError>> {
    if raw.get("sections").is_none() {
        if raw.get("passages").is_some() {
            return Err(vec![ImportError::new(
                "$",
                "The selected file does not match the Listening schema (expected `sections[]`, found `passages[]`). Did you mean to import as Reading?",
            )]);
        }
        if raw.get("tasks").is_some() {
            return Err(vec![ImportError::new(
                "$",
                "The selected file does not match the Listening schema (expected `sections[]`, found `tasks[]`). Did you mean to import as Writing?",
            )]);
        }
    }

    let data: ListeningImport = serde_json::from_value(raw.clone()).map_err(|e| {
        vec![ImportError::new(
            "$",
            format!("The selected file is not valid JSON: {e}"),
        )]
    })?;

    let mut errors = Vec::new();
    let mut seen_ids = HashMap::new();
    find_duplicate_ids(raw, "$", &mut seen_ids, &mut errors);

    if data.title.as_deref().unwrap_or("").trim().is_empty() {
        errors.push(ImportError::new(
            "title",
            "Missing required field `title` at document root.",
        ));
    }
    if data.sections.len() != 4 {
        errors.push(ImportError::new(
            "sections",
            format!(
                "Listening tests must have exactly 4 sections; found {}.",
                data.sections.len()
            ),
        ));
    }
    validate_ordering(
        &data
            .sections
            .iter()
            .map(|s| s.section_number.unwrap_or(0))
            .collect::<Vec<_>>(),
        "section_number",
        "sections",
        &mut errors,
    );

    if audios.len() != 4 {
        errors.push(ImportError::new(
            "audio_files",
            format!(
                "Expected exactly 4 audio files (one per section); received {}.",
                audios.len()
            ),
        ));
    }
    let audio_sections: HashMap<i64, &AudioMeta> =
        audios.iter().map(|a| (a.section_number, a)).collect();

    let mut all_question_orders = Vec::new();
    for (si, section) in data.sections.iter().enumerate() {
        let path = format!("sections[{si}]");
        let section_number = section.section_number.unwrap_or((si + 1) as i64);
        if section.title.as_deref().unwrap_or("").trim().is_empty() {
            errors.push(ImportError::new(
                format!("{path}.title"),
                "Field cannot be empty.",
            ));
        }
        match audio_sections.get(&section_number) {
            None => {
                errors.push(ImportError::new(
                    format!("{path}.audio"),
                    format!("No audio file was assigned to Section {section_number}."),
                ));
            }
            Some(audio) => {
                let ext = audio
                    .file_name
                    .rsplit('.')
                    .next()
                    .unwrap_or("")
                    .to_lowercase();
                if !ALLOWED_AUDIO_EXTS.contains(&ext.as_str()) {
                    errors.push(ImportError::new(
                        format!("{path}.audio"),
                        format!(
                            "Unsupported audio format `.{ext}` for Section {section_number}; expected mp3, wav, m4a, or ogg."
                        ),
                    ));
                }
                if audio.size > MAX_AUDIO_BYTES {
                    errors.push(ImportError::new(
                        format!("{path}.audio"),
                        format!("Audio file for Section {section_number} exceeds the 50MB limit."),
                    ));
                }
            }
        }
        for (gi, group) in section.question_groups.iter().enumerate() {
            let group_path = format!("{path}.question_groups[{gi}]");
            validate_question_group(group, &group_path, &mut errors);
            for question in &group.questions {
                all_question_orders.push(question.question_order.unwrap_or(0));
            }
        }
    }
    validate_ordering(
        &all_question_orders,
        "question_order",
        "the test",
        &mut errors,
    );

    if errors.is_empty() {
        Ok(data)
    } else {
        Err(errors)
    }
}

// ── duplicate title lookup ───────────────────────────────────────────────────

pub async fn find_duplicate_reading_title(
    pool: &Db,
    user_id: &str,
    title: &str,
) -> Result<Option<String>, AppError> {
    Ok(sqlx::query_scalar!(
        "SELECT id FROM reading_tests WHERE title = ? AND created_by = ?",
        title,
        user_id
    )
    .fetch_optional(pool)
    .await?)
}

pub async fn find_duplicate_writing_title(
    pool: &Db,
    user_id: &str,
    title: &str,
) -> Result<Option<String>, AppError> {
    Ok(sqlx::query_scalar!(
        "SELECT id FROM writing_tests WHERE title = ? AND created_by = ?",
        title,
        user_id
    )
    .fetch_optional(pool)
    .await?)
}

pub async fn find_duplicate_listening_title(
    pool: &Db,
    user_id: &str,
    title: &str,
) -> Result<Option<String>, AppError> {
    Ok(sqlx::query_scalar!(
        "SELECT id FROM listening_tests WHERE title = ? AND created_by = ?",
        title,
        user_id
    )
    .fetch_optional(pool)
    .await?)
}

// ── insert (transactional) ──────────────────────────────────────────────────

pub async fn import_reading(
    pool: &Db,
    user_id: &str,
    data: ReadingImport,
) -> Result<String, AppError> {
    let mut tx = pool.begin().await?;
    let test_id = Uuid::new_v4().to_string();
    let now = Utc::now().to_rfc3339();

    let title = data.title.unwrap_or_default();
    let test_type = data.test_type.unwrap_or_else(|| "Academic".to_string());
    let difficulty = data.difficulty.unwrap_or_else(|| "7".to_string());
    let duration = data.duration.unwrap_or_else(|| "60 mins".to_string());
    let status = data.status.unwrap_or_else(|| "draft".to_string());

    sqlx::query!(
        "INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status, created_at, updated_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
        test_id,
        user_id,
        title,
        test_type,
        difficulty,
        duration,
        status,
        now,
        now
    )
    .execute(&mut *tx)
    .await?;

    for passage in &data.passages {
        insert_reading_passage(&mut tx, &test_id, passage, &now).await?;
    }

    tx.commit().await?;
    Ok(test_id)
}

async fn insert_reading_passage(
    tx: &mut Transaction<'_, Sqlite>,
    test_id: &str,
    passage: &PassageImport,
    now: &str,
) -> Result<(), AppError> {
    let passage_id = Uuid::new_v4().to_string();
    let passage_number = passage.passage_number.unwrap_or(1);
    let title = passage.title.clone().unwrap_or_default();
    let content = passage.content.clone().unwrap_or_default();

    sqlx::query!(
        "INSERT INTO reading_passages (id, test_id, passage_number, title, content, notes, created_at)
         VALUES (?, ?, ?, ?, ?, ?, ?)",
        passage_id,
        test_id,
        passage_number,
        title,
        content,
        passage.notes,
        now
    )
    .execute(&mut **tx)
    .await?;

    for group in &passage.question_groups {
        insert_question_group_reading(tx, &passage_id, group, now).await?;
    }
    Ok(())
}

async fn insert_question_group_reading(
    tx: &mut Transaction<'_, Sqlite>,
    passage_id: &str,
    group: &QuestionGroupImport,
    now: &str,
) -> Result<(), AppError> {
    let group_id = Uuid::new_v4().to_string();
    let group_order = group.group_order.unwrap_or(0);
    let question_type = group
        .question_type
        .clone()
        .unwrap_or_else(|| "multiple-choice".to_string());
    let instructions = group.instructions.clone().unwrap_or_default();
    let word_bank = json_or_default(&group.word_bank, "[]");
    let has_word_bank = group.has_word_bank.unwrap_or(false) as i64;
    let sequential_order = group.sequential_order.unwrap_or(true) as i64;
    let multiple_selection = group.multiple_selection.unwrap_or(false) as i64;
    let select_count = group.select_count.unwrap_or(1);

    sqlx::query!(
        "INSERT INTO reading_question_groups
         (id, passage_id, group_order, question_type, instructions, word_limit,
          has_word_bank, word_bank, sequential_order, multiple_selection, select_count, created_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        group_id,
        passage_id,
        group_order,
        question_type,
        instructions,
        group.word_limit,
        has_word_bank,
        word_bank,
        sequential_order,
        multiple_selection,
        select_count,
        now
    )
    .execute(&mut **tx)
    .await?;

    for question in &group.questions {
        let q_id = Uuid::new_v4().to_string();
        let question_order = question.question_order.unwrap_or(0);
        let text = question.text.clone().unwrap_or_default();
        let options = rename_keys(&question.options, &[("is_correct", "isCorrect")]);
        let matching_pairs = json_or_default(&question.matching_pairs, "[]");
        let completion_gaps = rename_keys(&question.completion_gaps, &[("gap_text", "gapText")]);
        let accepted_answers = normalize_accepted_answers(&question.accepted_answers);

        sqlx::query!(
            "INSERT INTO reading_questions
             (id, group_id, question_order, text, answer, options, matching_pairs, completion_gaps, accepted_answers, created_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            q_id,
            group_id,
            question_order,
            text,
            question.answer,
            options,
            matching_pairs,
            completion_gaps,
            accepted_answers,
            now
        )
        .execute(&mut **tx)
        .await?;
    }
    Ok(())
}

pub async fn import_writing(
    pool: &Db,
    user_id: &str,
    data: WritingImport,
) -> Result<String, AppError> {
    let mut tx = pool.begin().await?;
    let test_id = Uuid::new_v4().to_string();
    let now = Utc::now().to_rfc3339();

    let title = data.title.unwrap_or_default();
    let status = data.status.unwrap_or_else(|| "draft".to_string());

    sqlx::query!(
        "INSERT INTO writing_tests (id, created_by, title, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)",
        test_id,
        user_id,
        title,
        status,
        now,
        now
    )
    .execute(&mut *tx)
    .await?;

    for task in &data.tasks {
        insert_writing_task(&mut tx, &test_id, task, &now).await?;
    }

    tx.commit().await?;
    Ok(test_id)
}

async fn insert_writing_task(
    tx: &mut Transaction<'_, Sqlite>,
    test_id: &str,
    task: &TaskImport,
    now: &str,
) -> Result<(), AppError> {
    let task_id = task
        .id
        .clone()
        .unwrap_or_else(|| Uuid::new_v4().to_string());
    let task_number = task.task_number.unwrap_or(1);
    let task_type = task.task_type.clone().unwrap_or_else(|| {
        if task_number == 2 {
            "task2".to_string()
        } else {
            "task1".to_string()
        }
    });
    let title = task.title.clone().unwrap_or_default();
    let difficulty = task.difficulty.clone().unwrap_or_else(|| "7".to_string());
    let suggested_time = task.suggested_time.clone().unwrap_or_else(|| {
        if task_number == 2 {
            "40 mins".to_string()
        } else {
            "20 mins".to_string()
        }
    });
    let prompt = task.prompt.clone().unwrap_or_default();
    let min_words = task
        .min_words
        .unwrap_or(if task_number == 2 { 250 } else { 150 });
    let include_model_answer = task.include_model_answer.unwrap_or(false) as i64;

    sqlx::query!(
        "INSERT INTO writing_tasks
         (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt,
          min_words, max_words, image_url, include_model_answer, model_answer,
          figure_description, created_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        task_id,
        test_id,
        task_number,
        task_type,
        title,
        difficulty,
        suggested_time,
        prompt,
        min_words,
        task.max_words,
        task.image_url,
        include_model_answer,
        task.model_answer,
        task.figure_description,
        now
    )
    .execute(&mut **tx)
    .await?;
    Ok(())
}

fn build_listening_assets_dir(test_id: &str) -> Result<PathBuf, AppError> {
    let home = std::env::var("HOME").map_err(|e| AppError::Validation(e.to_string()))?;
    Ok(Path::new(&home)
        .join(".imh")
        .join(crate::database::listening_assets::LISTENING_ASSETS_DIR_NAME)
        .join(test_id))
}

pub async fn import_listening(
    pool: &Db,
    user_id: &str,
    data: ListeningImport,
    audios: Vec<AudioAssignment>,
) -> Result<String, AppError> {
    let mut tx = pool.begin().await?;
    let test_id = Uuid::new_v4().to_string();
    let now = Utc::now().to_rfc3339();

    let title = data.title.clone().unwrap_or_default();
    let difficulty = data.difficulty.clone().unwrap_or_else(|| "7".to_string());
    let duration = data
        .duration
        .clone()
        .unwrap_or_else(|| "40 mins".to_string());
    let status = data.status.clone().unwrap_or_else(|| "draft".to_string());

    sqlx::query!(
        "INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status, created_at, updated_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        test_id,
        user_id,
        title,
        difficulty,
        duration,
        status,
        now,
        now
    )
    .execute(&mut *tx)
    .await?;

    let dir = build_listening_assets_dir(&test_id)?;
    let audio_by_section: HashMap<i64, &AudioAssignment> =
        audios.iter().map(|a| (a.section_number, a)).collect();
    let mut written_files: Vec<PathBuf> = Vec::new();

    let result = insert_listening_children(
        &mut tx,
        &test_id,
        &data,
        &audio_by_section,
        &dir,
        &mut written_files,
        &now,
    )
    .await;

    match result {
        Ok(()) => {
            tx.commit().await?;
            Ok(test_id)
        }
        Err(e) => {
            let _ = tx.rollback().await;
            for f in &written_files {
                let _ = tokio::fs::remove_file(f).await;
            }
            let _ = tokio::fs::remove_dir(&dir).await;
            Err(e)
        }
    }
}

async fn insert_listening_children(
    tx: &mut Transaction<'_, Sqlite>,
    test_id: &str,
    data: &ListeningImport,
    audio_by_section: &HashMap<i64, &AudioAssignment>,
    dir: &Path,
    written_files: &mut Vec<PathBuf>,
    now: &str,
) -> Result<(), AppError> {
    tokio::fs::create_dir_all(dir)
        .await
        .map_err(|e| AppError::Validation(e.to_string()))?;

    for section in &data.sections {
        let section_id = Uuid::new_v4().to_string();
        let section_number = section.section_number.unwrap_or(1);
        let title = section.title.clone().unwrap_or_default();

        let audio_url = if let Some(audio) = audio_by_section.get(&section_number) {
            let ext = audio.file_name.rsplit('.').next().unwrap_or("mp3");
            let path = dir.join(format!("section-{section_number}.{ext}"));
            tokio::fs::write(&path, &audio.data)
                .await
                .map_err(|e| AppError::Validation(e.to_string()))?;
            written_files.push(path.clone());
            path.to_string_lossy().into_owned()
        } else {
            String::new()
        };

        sqlx::query!(
            "INSERT INTO listening_sections (id, test_id, section_number, title, transcript, audio_url, created_at)
             VALUES (?, ?, ?, ?, ?, ?, ?)",
            section_id,
            test_id,
            section_number,
            title,
            section.transcript,
            audio_url,
            now
        )
        .execute(&mut **tx)
        .await?;

        for group in &section.question_groups {
            insert_question_group_listening(tx, &section_id, group, now).await?;
        }
    }
    Ok(())
}

async fn insert_question_group_listening(
    tx: &mut Transaction<'_, Sqlite>,
    section_id: &str,
    group: &QuestionGroupImport,
    now: &str,
) -> Result<(), AppError> {
    let group_id = Uuid::new_v4().to_string();
    let group_order = group.group_order.unwrap_or(0);
    let question_type = group
        .question_type
        .clone()
        .unwrap_or_else(|| "multiple-choice".to_string());
    let instructions = group.instructions.clone().unwrap_or_default();
    let word_bank = json_or_default(&group.word_bank, "[]");
    let has_word_bank = group.has_word_bank.unwrap_or(false) as i64;
    let sequential_order = group.sequential_order.unwrap_or(true) as i64;
    let multiple_selection = group.multiple_selection.unwrap_or(false) as i64;
    let select_count = group.select_count.unwrap_or(1);

    sqlx::query!(
        "INSERT INTO listening_question_groups
         (id, section_id, group_order, question_type, instructions, word_limit,
          has_word_bank, word_bank, sequential_order, multiple_selection, select_count, created_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        group_id,
        section_id,
        group_order,
        question_type,
        instructions,
        group.word_limit,
        has_word_bank,
        word_bank,
        sequential_order,
        multiple_selection,
        select_count,
        now
    )
    .execute(&mut **tx)
    .await?;

    for question in &group.questions {
        let q_id = Uuid::new_v4().to_string();
        let question_order = question.question_order.unwrap_or(0);
        let text = question.text.clone().unwrap_or_default();
        let options = rename_keys(&question.options, &[("is_correct", "isCorrect")]);
        let matching_pairs = json_or_default(&question.matching_pairs, "[]");
        let completion_gaps = rename_keys(&question.completion_gaps, &[("gap_text", "gapText")]);
        let accepted_answers = normalize_accepted_answers(&question.accepted_answers);
        let timestamp = question.timestamp.clone().unwrap_or_default();

        sqlx::query!(
            "INSERT INTO listening_questions
             (id, group_id, question_order, text, answer, options, matching_pairs,
              completion_gaps, accepted_answers, timestamp, created_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            q_id,
            group_id,
            question_order,
            text,
            question.answer,
            options,
            matching_pairs,
            completion_gaps,
            accepted_answers,
            timestamp,
            now
        )
        .execute(&mut **tx)
        .await?;
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn good_reading_json() -> Value {
        let question = serde_json::json!({
            "question_order": 1,
            "text": "Is this true?",
            "answer": "TRUE"
        });
        let group = serde_json::json!({
            "group_order": 0,
            "question_type": "true-false-not-given",
            "instructions": "Answer TRUE/FALSE/NOT GIVEN.",
            "questions": [question]
        });
        let passage = |n: i64| {
            serde_json::json!({
                "passage_number": n,
                "title": format!("Passage {n}"),
                "content": "Some content",
                "question_groups": if n == 1 { vec![group.clone()] } else { vec![] }
            })
        };
        serde_json::json!({
            "title": "Sample Reading Test",
            "passages": [passage(1), passage(2), passage(3)]
        })
    }

    #[test]
    fn validates_good_reading_json() {
        let raw = good_reading_json();
        let result = validate_reading(&raw);
        assert!(result.is_ok(), "{:?}", result.err());
    }

    #[test]
    fn reports_blank_title_path() {
        let mut raw = good_reading_json();
        raw["title"] = Value::String("".into());
        let errors = validate_reading(&raw).unwrap_err();
        assert!(errors.iter().any(|e| e.path == "title"));
    }

    #[test]
    fn rejects_wrong_passage_count() {
        let mut raw = good_reading_json();
        raw["passages"].as_array_mut().unwrap().pop();
        let errors = validate_reading(&raw).unwrap_err();
        assert!(errors
            .iter()
            .any(|e| e.message.contains("exactly 3 passages")));
    }

    #[test]
    fn rejects_audio_count_mismatch() {
        let raw = serde_json::json!({
            "title": "Listening Test",
            "sections": [
                {"section_number": 1, "title": "S1", "transcript": "t", "question_groups": []},
                {"section_number": 2, "title": "S2", "transcript": "t", "question_groups": []},
                {"section_number": 3, "title": "S3", "transcript": "t", "question_groups": []},
                {"section_number": 4, "title": "S4", "transcript": "t", "question_groups": []}
            ]
        });
        let audios = vec![
            AudioMeta {
                section_number: 1,
                file_name: "a.mp3".into(),
                size: 0,
            },
            AudioMeta {
                section_number: 2,
                file_name: "b.mp3".into(),
                size: 0,
            },
            AudioMeta {
                section_number: 3,
                file_name: "c.mp3".into(),
                size: 0,
            },
        ];
        let errors = validate_listening(&raw, &audios).unwrap_err();
        assert!(errors.iter().any(|e| e.message.contains("received 3")));
    }

    #[test]
    fn normalizes_bare_string_accepted_answers() {
        let v = Some(serde_json::json!(["blue", "sky"]));
        let normalized = normalize_accepted_answers(&v);
        let parsed: Vec<Value> = serde_json::from_str(&normalized).unwrap();
        assert_eq!(parsed.len(), 2);
        assert_eq!(parsed[0]["text"], "blue");
        assert!(parsed[0]["id"].is_string());
    }
}
