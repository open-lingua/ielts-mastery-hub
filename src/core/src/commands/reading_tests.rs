use tauri::State;

use crate::database::Db;
use crate::repositories::reading_tests as repo;
use crate::models::reading_tests::{CreateReadingTest, ReadingTest, UpdateReadingTest};

#[tauri::command]
pub async fn get_reading_tests(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<Option<ReadingTest>, String> {
    repo::find_by_id(&db, &id, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn list_reading_tests(
    db: State<'_, Db>,
    user_id: String,
) -> Result<Vec<ReadingTest>, String> {
    repo::find_all(&db, &user_id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn create_reading_tests(
    db: State<'_, Db>,
    user_id: String,
    input: CreateReadingTest,
) -> Result<String, String> {
    repo::insert(&db, &input, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn update_reading_tests(
    db: State<'_, Db>,
    id: String,
    user_id: String,
    input: UpdateReadingTest,
) -> Result<(), String> {
    repo::update(&db, &id, &user_id, &input)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn delete_reading_tests(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<(), String> {
    repo::delete(&db, &id, &user_id).await.map_err(Into::into)
}
