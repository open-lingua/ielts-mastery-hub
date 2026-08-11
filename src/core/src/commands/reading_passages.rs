use tauri::State;

use crate::db::Db;
use crate::repositories::reading_passages as repo;
use crate::repositories::reading_passages::{
    CreateReadingPassage, ReadingPassage, UpdateReadingPassage,
};

#[tauri::command]
pub async fn get_reading_passages(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<Option<ReadingPassage>, String> {
    repo::find_by_id(&db, &id, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn list_reading_passages(
    db: State<'_, Db>,
    user_id: String,
) -> Result<Vec<ReadingPassage>, String> {
    repo::find_all(&db, &user_id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn create_reading_passages(
    db: State<'_, Db>,
    user_id: String,
    input: CreateReadingPassage,
) -> Result<String, String> {
    repo::insert(&db, &input, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn update_reading_passages(
    db: State<'_, Db>,
    id: String,
    user_id: String,
    input: UpdateReadingPassage,
) -> Result<(), String> {
    repo::update(&db, &id, &user_id, &input)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn delete_reading_passages(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<(), String> {
    repo::delete(&db, &id, &user_id).await.map_err(Into::into)
}
