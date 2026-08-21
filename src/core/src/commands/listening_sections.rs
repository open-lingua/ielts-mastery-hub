use tauri::State;

use crate::database::Db;
use crate::models::listening_sections::{
    CreateListeningSection, ListeningSection, UpdateListeningSection,
};
use crate::repositories::listening_sections as repo;

#[tauri::command]
pub async fn get_listening_sections(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<Option<ListeningSection>, String> {
    repo::find_by_id(&db, &id, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn list_listening_sections(
    db: State<'_, Db>,
    user_id: String,
) -> Result<Vec<ListeningSection>, String> {
    repo::find_all(&db, &user_id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn create_listening_sections(
    db: State<'_, Db>,
    user_id: String,
    input: CreateListeningSection,
) -> Result<String, String> {
    repo::insert(&db, &input, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn update_listening_sections(
    db: State<'_, Db>,
    id: String,
    user_id: String,
    input: UpdateListeningSection,
) -> Result<(), String> {
    repo::update(&db, &id, &user_id, &input)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn delete_listening_sections(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<(), String> {
    repo::delete(&db, &id, &user_id).await.map_err(Into::into)
}
