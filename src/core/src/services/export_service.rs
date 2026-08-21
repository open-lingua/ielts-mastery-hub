use std::io::{Cursor, Write};
use std::path::{Path, PathBuf};

use serde::Serialize;
use serde_json::Value;
use zip::write::SimpleFileOptions;
use zip::ZipWriter;

use crate::database::Db;
use crate::error::AppError;
use crate::models::listening_questions::ListeningQuestion;
use crate::models::reading_questions::ReadingQuestion;
use crate::repositories::{
    listening_question_groups, listening_questions, listening_sections, listening_tests,
    reading_passages, reading_question_groups, reading_questions, reading_tests, writing_tasks,
    writing_tests,
};

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct ExportResult {
    pub file_path: String,
    pub file_name: String,
    pub warnings: Vec<String>,
}

#[derive(Debug)]
pub struct BuiltExport {
    pub file_name: String,
    pub zip_bytes: Vec<u8>,
    pub warnings: Vec<String>,
}

struct MediaFile {
    /// Path inside the zip, e.g. `media/section-1.mp3`.
    archive_path: String,
    /// Absolute path on disk to read the bytes from.
    source_path: PathBuf,
}

/// Assembles the Import-schema-compatible JSON for `id`, bundles any linked media, and zips
/// everything up in memory. Does not touch the filesystem beyond reading source media files —
/// callers decide where (and whether) to persist the resulting bytes.
pub async fn build_export(
    db: &Db,
    user_id: &str,
    kind: &str,
    id: &str,
) -> Result<BuiltExport, AppError> {
    let mut warnings: Vec<String> = Vec::new();
    let mut media: Vec<MediaFile> = Vec::new();

    let (title, module, json) = match kind {
        "reading" => {
            let json = build_reading_json(db, user_id, id).await?;
            (json_title(&json), "reading", json)
        }
        "writing" => {
            let json = build_writing_json(db, user_id, id, &mut media, &mut warnings).await?;
            (json_title(&json), "writing", json)
        }
        "listening" => {
            let json = build_listening_json(db, user_id, id, &mut media, &mut warnings).await?;
            (json_title(&json), "listening", json)
        }
        other => {
            return Err(AppError::Validation(format!(
                "Unknown export kind `{other}`."
            )))
        }
    };

    let file_name = format!("ielts-{module}-{}_export.zip", slugify(&title));
    let folder_name = file_name
        .strip_suffix(".zip")
        .unwrap_or(&file_name)
        .to_string();
    let json_file_name = format!("{}.json", slugify(&title).replace('-', "_"));
    let json_bytes = serde_json::to_vec_pretty(&json)?;

    let zip_bytes = build_zip(
        &folder_name,
        &json_file_name,
        &json_bytes,
        &media,
        &mut warnings,
    )?;

    Ok(BuiltExport {
        file_name,
        zip_bytes,
        warnings,
    })
}

fn json_title(json: &Value) -> String {
    json.get("title")
        .and_then(Value::as_str)
        .unwrap_or("untitled")
        .to_string()
}

// ── zip assembly ─────────────────────────────────────────────────────────────

fn build_zip(
    folder_name: &str,
    json_file_name: &str,
    json_bytes: &[u8],
    media: &[MediaFile],
    warnings: &mut Vec<String>,
) -> Result<Vec<u8>, AppError> {
    let mut cursor = Cursor::new(Vec::new());
    {
        let mut writer = ZipWriter::new(&mut cursor);
        let options = SimpleFileOptions::default();

        writer
            .start_file(format!("{folder_name}/{json_file_name}"), options)
            .map_err(|e| AppError::Validation(e.to_string()))?;
        writer
            .write_all(json_bytes)
            .map_err(|e| AppError::Validation(e.to_string()))?;

        for file in media {
            match std::fs::read(&file.source_path) {
                Ok(bytes) => {
                    writer
                        .start_file(format!("{folder_name}/{}", file.archive_path), options)
                        .map_err(|e| AppError::Validation(e.to_string()))?;
                    writer
                        .write_all(&bytes)
                        .map_err(|e| AppError::Validation(e.to_string()))?;
                }
                Err(_) => {
                    warnings.push(format!(
                        "Missing media file: {}",
                        file.source_path
                            .file_name()
                            .map(|n| n.to_string_lossy().into_owned())
                            .unwrap_or_default()
                    ));
                }
            }
        }

        writer
            .finish()
            .map_err(|e| AppError::Validation(e.to_string()))?;
    }
    Ok(cursor.into_inner())
}

// ── reading ──────────────────────────────────────────────────────────────────

async fn build_reading_json(db: &Db, user_id: &str, test_id: &str) -> Result<Value, AppError> {
    let test = reading_tests::find_by_id(db, test_id, user_id)
        .await?
        .ok_or_else(|| AppError::NotFound(format!("Reading test `{test_id}` not found.")))?;

    let all_passages = reading_passages::find_all(db, user_id).await?;
    let all_groups = reading_question_groups::find_all(db, user_id).await?;
    let all_questions = reading_questions::find_all(db, user_id).await?;

    let mut passages: Vec<_> = all_passages
        .into_iter()
        .filter(|p| p.test_id == test_id)
        .collect();
    passages.sort_by_key(|p| p.passage_number);

    let passages_json: Vec<Value> = passages
        .into_iter()
        .map(|p| {
            let mut groups: Vec<_> = all_groups
                .iter()
                .filter(|g| g.passage_id == p.id)
                .cloned()
                .collect();
            groups.sort_by_key(|g| g.group_order);
            let groups_json: Vec<Value> = groups
                .into_iter()
                .map(|g| {
                    let mut questions: Vec<_> = all_questions
                        .iter()
                        .filter(|q| q.group_id == g.id)
                        .cloned()
                        .collect();
                    questions.sort_by_key(|q| q.question_order);
                    let questions_json: Vec<Value> =
                        questions.into_iter().map(question_to_json).collect();
                    serde_json::json!({
                        "group_order": g.group_order,
                        "question_type": g.question_type,
                        "instructions": g.instructions,
                        "word_limit": g.word_limit,
                        "has_word_bank": g.has_word_bank,
                        "word_bank": parse_or(&g.word_bank, Value::Array(vec![])),
                        "sequential_order": g.sequential_order,
                        "multiple_selection": g.multiple_selection,
                        "select_count": g.select_count,
                        "questions": questions_json,
                    })
                })
                .collect();
            serde_json::json!({
                "passage_number": p.passage_number,
                "title": p.title,
                "content": p.content,
                "notes": p.notes,
                "question_groups": groups_json,
            })
        })
        .collect();

    Ok(serde_json::json!({
        "title": test.title,
        "test_type": test.test_type,
        "difficulty": test.difficulty,
        "duration": test.duration,
        "status": test.status,
        "passages": passages_json,
    }))
}

fn question_to_json(q: ReadingQuestion) -> Value {
    serde_json::json!({
        "question_order": q.question_order,
        "text": q.text,
        "answer": q.answer,
        "options": rename_keys_in_str(&q.options, &[("isCorrect", "is_correct")]),
        "matching_pairs": parse_or(&q.matching_pairs, Value::Array(vec![])),
        "completion_gaps": rename_keys_in_str(&q.completion_gaps, &[("gapText", "gap_text")]),
        "accepted_answers": parse_or(&q.accepted_answers, Value::Array(vec![])),
    })
}

fn listening_question_to_json(q: ListeningQuestion) -> Value {
    serde_json::json!({
        "question_order": q.question_order,
        "text": q.text,
        "answer": q.answer,
        "options": rename_keys_in_str(&q.options, &[("isCorrect", "is_correct")]),
        "matching_pairs": parse_or(&q.matching_pairs, Value::Array(vec![])),
        "completion_gaps": rename_keys_in_str(&q.completion_gaps, &[("gapText", "gap_text")]),
        "accepted_answers": parse_or(&q.accepted_answers, Value::Array(vec![])),
    })
}

// ── writing ──────────────────────────────────────────────────────────────────

async fn build_writing_json(
    db: &Db,
    user_id: &str,
    test_id: &str,
    media: &mut Vec<MediaFile>,
    warnings: &mut Vec<String>,
) -> Result<Value, AppError> {
    let test = writing_tests::find_by_id(db, test_id, user_id)
        .await?
        .ok_or_else(|| AppError::NotFound(format!("Writing test `{test_id}` not found.")))?;

    let all_tasks = writing_tasks::find_all(db, user_id).await?;
    let mut tasks: Vec<_> = all_tasks
        .into_iter()
        .filter(|t| t.test_id == test_id)
        .collect();
    tasks.sort_by_key(|t| t.task_number);

    let tasks_json: Vec<Value> = tasks
        .into_iter()
        .map(|t| {
            let image_url = t.image_url.as_ref().and_then(|path| {
                if path.trim().is_empty() {
                    return None;
                }
                let source = PathBuf::from(path);
                if !source.exists() {
                    warnings.push(format!(
                        "Missing image file for Task {}: {}",
                        t.task_number,
                        source
                            .file_name()
                            .map(|n| n.to_string_lossy().into_owned())
                            .unwrap_or_default()
                    ));
                    return None;
                }
                let ext = source.extension().and_then(|e| e.to_str()).unwrap_or("png");
                let archive_path = format!("media/task-{}-image.{}", t.task_number, ext);
                media.push(MediaFile {
                    archive_path: archive_path.clone(),
                    source_path: source,
                });
                Some(format!("./{archive_path}"))
            });

            serde_json::json!({
                "task_number": t.task_number,
                "task_type": t.task_type,
                "title": t.title,
                "difficulty": t.difficulty,
                "suggested_time": t.suggested_time,
                "prompt": t.prompt,
                "min_words": t.min_words,
                "max_words": t.max_words,
                "image_url": image_url,
                "include_model_answer": t.include_model_answer,
                "model_answer": t.model_answer,
            })
        })
        .collect();

    Ok(serde_json::json!({
        "title": test.title,
        "status": test.status,
        "tasks": tasks_json,
    }))
}

// ── listening ────────────────────────────────────────────────────────────────

async fn build_listening_json(
    db: &Db,
    user_id: &str,
    test_id: &str,
    media: &mut Vec<MediaFile>,
    warnings: &mut Vec<String>,
) -> Result<Value, AppError> {
    let test = listening_tests::find_by_id(db, test_id, user_id)
        .await?
        .ok_or_else(|| AppError::NotFound(format!("Listening test `{test_id}` not found.")))?;

    let all_sections = listening_sections::find_all(db, user_id).await?;
    let all_groups = listening_question_groups::find_all(db, user_id).await?;
    let all_questions = listening_questions::find_all(db, user_id).await?;

    let mut sections: Vec<_> = all_sections
        .into_iter()
        .filter(|s| s.test_id == test_id)
        .collect();
    sections.sort_by_key(|s| s.section_number);

    let sections_json: Vec<Value> = sections
        .into_iter()
        .map(|s| {
            let audio_url = s.audio_url.as_ref().and_then(|path| {
                if path.trim().is_empty() {
                    return None;
                }
                let source = PathBuf::from(path);
                if !source.exists() {
                    warnings.push(format!(
                        "Missing audio file for Section {}: {}",
                        s.section_number,
                        source
                            .file_name()
                            .map(|n| n.to_string_lossy().into_owned())
                            .unwrap_or_default()
                    ));
                    return None;
                }
                let ext = source.extension().and_then(|e| e.to_str()).unwrap_or("mp3");
                let archive_path = format!("media/section-{}.{}", s.section_number, ext);
                media.push(MediaFile {
                    archive_path: archive_path.clone(),
                    source_path: source,
                });
                Some(format!("./{archive_path}"))
            });

            let mut groups: Vec<_> = all_groups
                .iter()
                .filter(|g| g.section_id == s.id)
                .cloned()
                .collect();
            groups.sort_by_key(|g| g.group_order);
            let groups_json: Vec<Value> = groups
                .into_iter()
                .map(|g| {
                    let mut questions: Vec<_> = all_questions
                        .iter()
                        .filter(|q| q.group_id == g.id)
                        .cloned()
                        .collect();
                    questions.sort_by_key(|q| q.question_order);
                    let questions_json: Vec<Value> = questions
                        .into_iter()
                        .map(listening_question_to_json)
                        .collect();
                    serde_json::json!({
                        "group_order": g.group_order,
                        "question_type": g.question_type,
                        "instructions": g.instructions,
                        "word_limit": g.word_limit,
                        "has_word_bank": g.has_word_bank,
                        "word_bank": parse_or(&g.word_bank, Value::Array(vec![])),
                        "sequential_order": g.sequential_order,
                        "multiple_selection": g.multiple_selection,
                        "select_count": g.select_count,
                        "questions": questions_json,
                    })
                })
                .collect();

            serde_json::json!({
                "section_number": s.section_number,
                "title": s.title,
                "transcript": s.transcript,
                "audio_url": audio_url,
                "question_groups": groups_json,
            })
        })
        .collect();

    Ok(serde_json::json!({
        "title": test.title,
        "difficulty": test.difficulty,
        "duration": test.duration,
        "status": test.status,
        "sections": sections_json,
    }))
}

// ── helpers ──────────────────────────────────────────────────────────────────

fn parse_or(raw: &str, default: Value) -> Value {
    serde_json::from_str(raw).unwrap_or(default)
}

/// Parses a JSON-string DB column (array of objects) and renames keys within each object,
/// reversing the camelCase transformation `import_service::rename_keys` applies on the way in.
fn rename_keys_in_str(raw: &str, renames: &[(&str, &str)]) -> Value {
    let parsed: Value = parse_or(raw, Value::Array(vec![]));
    let Value::Array(arr) = parsed else {
        return Value::Array(vec![]);
    };
    let renamed: Vec<Value> = arr
        .into_iter()
        .map(|item| {
            if let Value::Object(map) = item {
                let mut new_map = serde_json::Map::new();
                for (k, v) in map {
                    let renamed_key = renames
                        .iter()
                        .find(|(from, _)| *from == k)
                        .map(|(_, to)| *to);
                    new_map.insert(renamed_key.unwrap_or(&k).to_string(), v);
                }
                Value::Object(new_map)
            } else {
                item
            }
        })
        .collect();
    Value::Array(renamed)
}

pub(crate) fn slugify(title: &str) -> String {
    let mut out = String::new();
    let mut last_dash = false;
    for c in title.to_lowercase().chars() {
        if c.is_ascii_alphanumeric() {
            out.push(c);
            last_dash = false;
        } else if !last_dash {
            out.push('-');
            last_dash = true;
        }
    }
    let slug: String = out.trim_matches('-').chars().take(60).collect();
    if slug.is_empty() {
        "untitled".to_string()
    } else {
        slug
    }
}

/// Best-effort `~/Downloads` path used only to seed the save dialog's initial directory.
/// Returns `None` if `$HOME` can't be resolved — the dialog will fall back to its own default.
pub fn default_export_dir() -> Option<PathBuf> {
    let home = std::env::var("HOME").ok()?;
    Some(Path::new(&home).join("Downloads"))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::services::import_service::{
        validate_listening, validate_reading, validate_writing, AudioMeta,
    };
    use sqlx::sqlite::SqlitePoolOptions;

    #[test]
    fn slugify_lowercases_and_dashes_special_chars() {
        assert_eq!(
            slugify("Carbon Capture: The Process!"),
            "carbon-capture-the-process"
        );
    }

    #[test]
    fn slugify_truncates_long_titles() {
        let long_title = "a".repeat(200);
        assert_eq!(slugify(&long_title).len(), 60);
    }

    #[test]
    fn slugify_falls_back_when_title_has_no_alnum_chars() {
        assert_eq!(slugify("???"), "untitled");
    }

    #[test]
    fn rename_keys_in_str_reverses_camel_case_options() {
        let raw = r#"[{"id":"1","text":"A","isCorrect":true}]"#;
        let renamed = rename_keys_in_str(raw, &[("isCorrect", "is_correct")]);
        assert_eq!(renamed[0]["is_correct"], Value::Bool(true));
        assert!(renamed[0].get("isCorrect").is_none());
    }

    #[test]
    fn rename_keys_in_str_falls_back_to_empty_array_on_bad_json() {
        assert_eq!(rename_keys_in_str("not json", &[]), Value::Array(vec![]));
    }

    #[test]
    fn parse_or_falls_back_on_invalid_json() {
        assert_eq!(parse_or("nope", Value::Array(vec![])), Value::Array(vec![]));
        assert_eq!(
            parse_or("[1,2]", Value::Array(vec![])),
            serde_json::json!([1, 2])
        );
    }

    #[test]
    fn build_zip_includes_json_and_warns_on_missing_media() {
        let mut warnings = Vec::new();
        let media = vec![MediaFile {
            archive_path: "media/missing.mp3".to_string(),
            source_path: PathBuf::from("/nonexistent/path/missing.mp3"),
        }];
        let zip_bytes = build_zip(
            "ielts-reading-sample_export",
            "test.json",
            b"{\"title\":\"t\"}",
            &media,
            &mut warnings,
        )
        .unwrap();

        assert_eq!(warnings.len(), 1);
        assert!(warnings[0].contains("missing.mp3"));

        let mut archive = zip::ZipArchive::new(Cursor::new(zip_bytes)).unwrap();
        assert_eq!(archive.len(), 1);
        let mut file = archive
            .by_name("ielts-reading-sample_export/test.json")
            .unwrap();
        let mut contents = String::new();
        std::io::Read::read_to_string(&mut file, &mut contents).unwrap();
        assert_eq!(contents, "{\"title\":\"t\"}");
    }

    #[test]
    fn build_zip_nests_media_under_same_folder_as_json() {
        let dir = std::env::temp_dir().join(format!("export-zip-media-{}", uuid::Uuid::new_v4()));
        std::fs::create_dir_all(&dir).unwrap();
        let audio_path = dir.join("section-1.mp3");
        std::fs::write(&audio_path, b"audio bytes").unwrap();

        let mut warnings = Vec::new();
        let media = vec![MediaFile {
            archive_path: "media/section-1.mp3".to_string(),
            source_path: audio_path,
        }];
        let zip_bytes = build_zip(
            "ielts-listening-sample_export",
            "test.json",
            b"{}",
            &media,
            &mut warnings,
        )
        .unwrap();

        assert!(warnings.is_empty());
        let mut archive = zip::ZipArchive::new(Cursor::new(zip_bytes)).unwrap();
        assert!(archive
            .by_name("ielts-listening-sample_export/test.json")
            .is_ok());
        assert!(archive
            .by_name("ielts-listening-sample_export/media/section-1.mp3")
            .is_ok());

        std::fs::remove_dir_all(&dir).unwrap();
    }

    async fn test_pool() -> Db {
        let pool = SqlitePoolOptions::new()
            .max_connections(1)
            .connect("sqlite::memory:")
            .await
            .unwrap();
        sqlx::migrate!("./src/database/migrations")
            .run(&pool)
            .await
            .unwrap();
        pool
    }

    #[tokio::test]
    async fn build_reading_json_round_trips_through_validate_reading() {
        let pool = test_pool().await;
        let user_id = "user-1";
        let test_id = "test-1";
        let now = "2026-01-01T00:00:00Z";

        sqlx::query!(
            "INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status, created_at, updated_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
            test_id, user_id, "Sample Reading Test", "Academic", "7", "60 mins", "draft", now, now
        )
        .execute(&pool)
        .await
        .unwrap();

        for n in 1..=3i64 {
            let passage_id = format!("passage-{n}");
            sqlx::query!(
                "INSERT INTO reading_passages (id, test_id, passage_number, title, content, notes, created_at)
                 VALUES (?, ?, ?, ?, ?, ?, ?)",
                passage_id, test_id, n, "Passage title", "Passage content", Option::<String>::None, now
            )
            .execute(&pool)
            .await
            .unwrap();

            if n == 1 {
                let group_id = "group-1";
                sqlx::query!(
                    "INSERT INTO reading_question_groups
                     (id, passage_id, group_order, question_type, instructions, word_limit,
                      has_word_bank, word_bank, sequential_order, multiple_selection, select_count, created_at)
                     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    group_id, passage_id, 0i64, "true-false-not-given", "Answer TFNG.",
                    Option::<String>::None, false, "[]", true, false, 1i64, now
                )
                .execute(&pool)
                .await
                .unwrap();

                sqlx::query!(
                    "INSERT INTO reading_questions
                     (id, group_id, question_order, text, answer, options, matching_pairs, completion_gaps, accepted_answers, created_at)
                     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    "question-1", group_id, 1i64, "Is this true?", Some("TRUE"), "[]", "[]", "[]", "[]", now
                )
                .execute(&pool)
                .await
                .unwrap();
            }
        }

        let json = build_reading_json(&pool, user_id, test_id).await.unwrap();
        assert_eq!(json["title"], "Sample Reading Test");
        assert_eq!(json["passages"].as_array().unwrap().len(), 3);
        assert_eq!(
            json["passages"][0]["question_groups"][0]["questions"][0]["answer"],
            "TRUE"
        );

        validate_reading(&json).expect("exported reading JSON should re-validate as importable");
    }

    #[tokio::test]
    async fn build_writing_json_warns_on_missing_image_and_round_trips() {
        let pool = test_pool().await;
        let user_id = "user-1";
        let test_id = "test-1";
        let now = "2026-01-01T00:00:00Z";

        sqlx::query!(
            "INSERT INTO writing_tests (id, created_by, title, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)",
            test_id, user_id, "Sample Writing Test", "draft", now, now
        )
        .execute(&pool)
        .await
        .unwrap();

        for (n, image) in [
            (1i64, Some("/nonexistent/chart.png".to_string())),
            (2i64, None),
        ] {
            sqlx::query!(
                "INSERT INTO writing_tasks
                 (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt,
                  min_words, max_words, image_url, include_model_answer, model_answer, created_at)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                format!("task-{n}"),
                test_id,
                n,
                if n == 2 { "task2" } else { "task1" },
                "Task title",
                "7",
                "20 mins",
                "Describe the chart.",
                150i64,
                Option::<String>::None,
                image,
                false,
                Option::<String>::None,
                now
            )
            .execute(&pool)
            .await
            .unwrap();
        }

        let mut media = Vec::new();
        let mut warnings = Vec::new();
        let json = build_writing_json(&pool, user_id, test_id, &mut media, &mut warnings)
            .await
            .unwrap();

        assert_eq!(warnings.len(), 1);
        assert!(warnings[0].contains("chart.png"));
        assert!(media.is_empty());
        assert_eq!(json["tasks"].as_array().unwrap().len(), 2);
        assert!(json["tasks"][0]["image_url"].is_null());

        validate_writing(&json).expect("exported writing JSON should re-validate as importable");
    }

    #[tokio::test]
    async fn build_listening_json_includes_present_audio_and_round_trips() {
        let pool = test_pool().await;
        let user_id = "user-1";
        let test_id = "test-1";
        let now = "2026-01-01T00:00:00Z";

        sqlx::query!(
            "INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status, created_at, updated_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            test_id, user_id, "Sample Listening Test", "7", "40 mins", "draft", now, now
        )
        .execute(&pool)
        .await
        .unwrap();

        let audio_dir = std::env::temp_dir().join(format!("export-audio-{}", uuid::Uuid::new_v4()));
        tokio::fs::create_dir_all(&audio_dir).await.unwrap();
        for n in 1..=4i64 {
            tokio::fs::write(
                audio_dir.join(format!("section-{n}.mp3")),
                b"fake audio bytes",
            )
            .await
            .unwrap();
        }

        for n in 1..=4i64 {
            let section_id = format!("section-{n}");
            let audio_url = Some(
                audio_dir
                    .join(format!("section-{n}.mp3"))
                    .to_string_lossy()
                    .into_owned(),
            );
            sqlx::query!(
                "INSERT INTO listening_sections (id, test_id, section_number, title, transcript, audio_url, created_at)
                 VALUES (?, ?, ?, ?, ?, ?, ?)",
                section_id, test_id, n, "Section title", "Transcript text", audio_url, now
            )
            .execute(&pool)
            .await
            .unwrap();
        }

        let mut media = Vec::new();
        let mut warnings = Vec::new();
        let json = build_listening_json(&pool, user_id, test_id, &mut media, &mut warnings)
            .await
            .unwrap();

        assert!(warnings.is_empty());
        assert_eq!(media.len(), 4);
        assert_eq!(json["sections"].as_array().unwrap().len(), 4);
        assert_eq!(json["sections"][0]["audio_url"], "./media/section-1.mp3");

        let audio_meta: Vec<AudioMeta> = (1..=4)
            .map(|n| AudioMeta {
                section_number: n,
                file_name: format!("section-{n}.mp3"),
                size: 17,
            })
            .collect();
        validate_listening(&json, &audio_meta)
            .expect("exported listening JSON should re-validate as importable");

        tokio::fs::remove_dir_all(&audio_dir).await.unwrap();
    }

    #[tokio::test]
    async fn build_listening_json_warns_on_missing_audio_file() {
        let pool = test_pool().await;
        let user_id = "user-1";
        let test_id = "test-1";
        let now = "2026-01-01T00:00:00Z";

        sqlx::query!(
            "INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status, created_at, updated_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            test_id, user_id, "Sample Listening Test", "7", "40 mins", "draft", now, now
        )
        .execute(&pool)
        .await
        .unwrap();

        for n in 1..=4i64 {
            let section_id = format!("section-{n}");
            let audio_url = if n == 1 {
                Some("/nonexistent/section-1.mp3".to_string())
            } else {
                None
            };
            sqlx::query!(
                "INSERT INTO listening_sections (id, test_id, section_number, title, transcript, audio_url, created_at)
                 VALUES (?, ?, ?, ?, ?, ?, ?)",
                section_id, test_id, n, "Section title", "Transcript text", audio_url, now
            )
            .execute(&pool)
            .await
            .unwrap();
        }

        let mut media = Vec::new();
        let mut warnings = Vec::new();
        let json = build_listening_json(&pool, user_id, test_id, &mut media, &mut warnings)
            .await
            .unwrap();

        assert_eq!(warnings.len(), 1);
        assert!(warnings[0].contains("Section 1"));
        assert!(media.is_empty());
        assert!(json["sections"][0]["audio_url"].is_null());
    }
}
