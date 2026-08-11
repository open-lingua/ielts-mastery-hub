use tauri::State;

use crate::db::Db;
use crate::repositories::listening_questions as repo;
use crate::repositories::listening_questions::{
    CreateListeningQuestion, ListeningQuestion, UpdateListeningQuestion,
};

#[tauri::command]
pub async fn get_listening_questions(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<Option<ListeningQuestion>, String> {
    repo::find_by_id(&db, &id, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn list_listening_questions(
    db: State<'_, Db>,
    user_id: String,
) -> Result<Vec<ListeningQuestion>, String> {
    repo::find_all(&db, &user_id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn create_listening_questions(
    db: State<'_, Db>,
    user_id: String,
    input: CreateListeningQuestion,
) -> Result<String, String> {
    repo::insert(&db, &input, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn update_listening_questions(
    db: State<'_, Db>,
    id: String,
    user_id: String,
    input: UpdateListeningQuestion,
) -> Result<(), String> {
    repo::update(&db, &id, &user_id, &input)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn delete_listening_questions(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<(), String> {
    repo::delete(&db, &id, &user_id).await.map_err(Into::into)
}
