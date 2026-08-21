use tauri::State;

use crate::database::Db;
use crate::models::writing_tasks::{CreateWritingTask, UpdateWritingTask, WritingTask};
use crate::repositories::writing_tasks as repo;

#[tauri::command]
pub async fn get_writing_tasks(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<Option<WritingTask>, String> {
    repo::find_by_id(&db, &id, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn list_writing_tasks(
    db: State<'_, Db>,
    user_id: String,
) -> Result<Vec<WritingTask>, String> {
    repo::find_all(&db, &user_id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn create_writing_tasks(
    db: State<'_, Db>,
    user_id: String,
    input: CreateWritingTask,
) -> Result<String, String> {
    repo::insert(&db, &input, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn update_writing_tasks(
    db: State<'_, Db>,
    id: String,
    user_id: String,
    input: UpdateWritingTask,
) -> Result<(), String> {
    repo::update(&db, &id, &user_id, &input)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn delete_writing_tasks(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<(), String> {
    repo::delete(&db, &id, &user_id).await.map_err(Into::into)
}
