use tauri::State;

use crate::db::Db;
use crate::repositories::listening_tests as repo;
use crate::repositories::listening_tests::{
    CreateListeningTest, ListeningTest, UpdateListeningTest,
};

#[tauri::command]
pub async fn get_listening_tests(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<Option<ListeningTest>, String> {
    repo::find_by_id(&db, &id, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn list_listening_tests(
    db: State<'_, Db>,
    user_id: String,
) -> Result<Vec<ListeningTest>, String> {
    repo::find_all(&db, &user_id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn create_listening_tests(
    db: State<'_, Db>,
    user_id: String,
    input: CreateListeningTest,
) -> Result<String, String> {
    repo::insert(&db, &input, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn update_listening_tests(
    db: State<'_, Db>,
    id: String,
    user_id: String,
    input: UpdateListeningTest,
) -> Result<(), String> {
    repo::update(&db, &id, &user_id, &input)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn delete_listening_tests(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<(), String> {
    repo::delete(&db, &id, &user_id).await.map_err(Into::into)
}
