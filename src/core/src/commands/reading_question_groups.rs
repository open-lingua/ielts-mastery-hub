use tauri::State;

use crate::database::Db;
use crate::models::reading_question_groups::{
    CreateReadingQuestionGroup, ReadingQuestionGroup, UpdateReadingQuestionGroup,
};
use crate::repositories::reading_question_groups as repo;

#[tauri::command]
pub async fn get_reading_question_groups(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<Option<ReadingQuestionGroup>, String> {
    repo::find_by_id(&db, &id, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn list_reading_question_groups(
    db: State<'_, Db>,
    user_id: String,
) -> Result<Vec<ReadingQuestionGroup>, String> {
    repo::find_all(&db, &user_id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn create_reading_question_groups(
    db: State<'_, Db>,
    user_id: String,
    input: CreateReadingQuestionGroup,
) -> Result<String, String> {
    repo::insert(&db, &input, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn update_reading_question_groups(
    db: State<'_, Db>,
    id: String,
    user_id: String,
    input: UpdateReadingQuestionGroup,
) -> Result<(), String> {
    repo::update(&db, &id, &user_id, &input)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn delete_reading_question_groups(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<(), String> {
    repo::delete(&db, &id, &user_id).await.map_err(Into::into)
}
