use tauri::State;

use crate::db::Db;
use crate::repositories::reading_questions as repo;
use crate::repositories::reading_questions::{
    CreateReadingQuestion, ReadingQuestion, UpdateReadingQuestion,
};

#[tauri::command]
pub async fn get_reading_questions(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<Option<ReadingQuestion>, String> {
    repo::find_by_id(&db, &id, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn list_reading_questions(
    db: State<'_, Db>,
    user_id: String,
) -> Result<Vec<ReadingQuestion>, String> {
    repo::find_all(&db, &user_id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn create_reading_questions(
    db: State<'_, Db>,
    user_id: String,
    input: CreateReadingQuestion,
) -> Result<String, String> {
    repo::insert(&db, &input, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn update_reading_questions(
    db: State<'_, Db>,
    id: String,
    user_id: String,
    input: UpdateReadingQuestion,
) -> Result<(), String> {
    repo::update(&db, &id, &user_id, &input)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn delete_reading_questions(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<(), String> {
    repo::delete(&db, &id, &user_id).await.map_err(Into::into)
}
