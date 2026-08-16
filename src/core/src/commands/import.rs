use serde::{Deserialize, Serialize};
use tauri::State;

use crate::database::Db;
use crate::services::import_service::{
    self, errors_to_string, AudioAssignment, AudioMeta,
};

#[derive(Debug, Deserialize)]
pub struct AudioMetaInput {
    pub section_number: i64,
    pub file_name: String,
    pub size: usize,
}

#[derive(Debug, Deserialize)]
pub struct ListeningAudioUpload {
    pub section_number: i64,
    pub file_name: String,
    pub file_data: Vec<u8>,
}

#[derive(Debug, Serialize)]
pub struct ImportPreview {
    pub title: String,
    pub status: String,
    pub kind: String,
    pub passage_or_section_or_task_count: usize,
    pub group_count: usize,
    pub question_count: usize,
    pub duplicate_of: Option<String>,
}

fn count_reading(data: &crate::models::import::ReadingImport) -> (usize, usize, usize) {
    let groups: usize = data.passages.iter().map(|p| p.question_groups.len()).sum();
    let questions: usize = data
        .passages
        .iter()
        .flat_map(|p| &p.question_groups)
        .map(|g| g.questions.len())
        .sum();
    (data.passages.len(), groups, questions)
}

fn count_listening(data: &crate::models::import::ListeningImport) -> (usize, usize, usize) {
    let groups: usize = data.sections.iter().map(|s| s.question_groups.len()).sum();
    let questions: usize = data
        .sections
        .iter()
        .flat_map(|s| &s.question_groups)
        .map(|g| g.questions.len())
        .sum();
    (data.sections.len(), groups, questions)
}

#[tauri::command]
pub async fn validate_import(
    db: State<'_, Db>,
    user_id: String,
    kind: String,
    json_data: serde_json::Value,
    audio_meta: Vec<AudioMetaInput>,
) -> Result<ImportPreview, String> {
    let audio_meta: Vec<AudioMeta> = audio_meta
        .into_iter()
        .map(|m| AudioMeta {
            section_number: m.section_number,
            file_name: m.file_name,
            size: m.size,
        })
        .collect();

    match kind.as_str() {
        "reading" => {
            let data = import_service::validate_reading(&json_data).map_err(|e| errors_to_string(&e))?;
            let title = data.title.clone().unwrap_or_default();
            let duplicate_of = import_service::find_duplicate_reading_title(&db, &user_id, &title)
                .await
                .map_err(String::from)?;
            let (children, groups, questions) = count_reading(&data);
            Ok(ImportPreview {
                title,
                status: data.status.unwrap_or_else(|| "draft".to_string()),
                kind,
                passage_or_section_or_task_count: children,
                group_count: groups,
                question_count: questions,
                duplicate_of,
            })
        }
        "writing" => {
            let data = import_service::validate_writing(&json_data).map_err(|e| errors_to_string(&e))?;
            let title = data.title.clone().unwrap_or_default();
            let duplicate_of = import_service::find_duplicate_writing_title(&db, &user_id, &title)
                .await
                .map_err(String::from)?;
            Ok(ImportPreview {
                title,
                status: data.status.unwrap_or_else(|| "draft".to_string()),
                kind,
                passage_or_section_or_task_count: data.tasks.len(),
                group_count: 0,
                question_count: 0,
                duplicate_of,
            })
        }
        "listening" => {
            let data = import_service::validate_listening(&json_data, &audio_meta).map_err(|e| errors_to_string(&e))?;
            let title = data.title.clone().unwrap_or_default();
            let duplicate_of = import_service::find_duplicate_listening_title(&db, &user_id, &title)
                .await
                .map_err(String::from)?;
            let (children, groups, questions) = count_listening(&data);
            Ok(ImportPreview {
                title,
                status: data.status.unwrap_or_else(|| "draft".to_string()),
                kind,
                passage_or_section_or_task_count: children,
                group_count: groups,
                question_count: questions,
                duplicate_of,
            })
        }
        other => Err(format!("Unknown import kind `{other}`.")),
    }
}

#[tauri::command]
pub async fn import_reading_test(
    db: State<'_, Db>,
    user_id: String,
    json_data: serde_json::Value,
) -> Result<String, String> {
    let data = import_service::validate_reading(&json_data).map_err(|e| errors_to_string(&e))?;
    import_service::import_reading(&db, &user_id, data).await.map_err(Into::into)
}

#[tauri::command]
pub async fn import_writing_test(
    db: State<'_, Db>,
    user_id: String,
    json_data: serde_json::Value,
) -> Result<String, String> {
    let data = import_service::validate_writing(&json_data).map_err(|e| errors_to_string(&e))?;
    import_service::import_writing(&db, &user_id, data).await.map_err(Into::into)
}

#[tauri::command]
pub async fn import_listening_test(
    db: State<'_, Db>,
    user_id: String,
    json_data: serde_json::Value,
    audio_files: Vec<ListeningAudioUpload>,
) -> Result<String, String> {
    let assignments: Vec<AudioAssignment> = audio_files
        .into_iter()
        .map(|f| AudioAssignment {
            section_number: f.section_number,
            file_name: f.file_name,
            data: f.file_data,
        })
        .collect();
    let audio_meta: Vec<AudioMeta> = assignments.iter().map(AudioAssignment::to_meta).collect();

    let data = import_service::validate_listening(&json_data, &audio_meta).map_err(|e| errors_to_string(&e))?;
    import_service::import_listening(&db, &user_id, data, assignments)
        .await
        .map_err(Into::into)
}
