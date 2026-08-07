use tauri::State;

use crate::db::Db;
use crate::repositories::writing_tests::{CreateWritingTest, UpdateWritingTest, WritingTest};
use crate::repositories::writing_tests as repo;

#[tauri::command]
pub async fn get_writing_tests(db: State<'_, Db>, id: String, user_id: String) -> Result<Option<WritingTest>, String> {
    repo::find_by_id(&db, &id, &user_id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn list_writing_tests(db: State<'_, Db>, user_id: String) -> Result<Vec<WritingTest>, String> {
    repo::find_all(&db, &user_id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn create_writing_tests(db: State<'_, Db>, user_id: String, input: CreateWritingTest) -> Result<String, String> {
    repo::insert(&db, &input, &user_id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn update_writing_tests(db: State<'_, Db>, id: String, user_id: String, input: UpdateWritingTest) -> Result<(), String> {
    repo::update(&db, &id, &user_id, &input).await.map_err(Into::into)
}

#[tauri::command]
pub async fn delete_writing_tests(db: State<'_, Db>, id: String, user_id: String) -> Result<(), String> {
    repo::delete(&db, &id, &user_id).await.map_err(Into::into)
}
