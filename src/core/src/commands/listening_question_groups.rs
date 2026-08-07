use tauri::State;

use crate::db::Db;
use crate::repositories::listening_question_groups::{CreateListeningQuestionGroup, ListeningQuestionGroup, UpdateListeningQuestionGroup};
use crate::repositories::listening_question_groups as repo;

#[tauri::command]
pub async fn get_listening_question_groups(db: State<'_, Db>, id: String, user_id: String) -> Result<Option<ListeningQuestionGroup>, String> {
    repo::find_by_id(&db, &id, &user_id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn list_listening_question_groups(db: State<'_, Db>, user_id: String) -> Result<Vec<ListeningQuestionGroup>, String> {
    repo::find_all(&db, &user_id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn create_listening_question_groups(db: State<'_, Db>, user_id: String, input: CreateListeningQuestionGroup) -> Result<String, String> {
    repo::insert(&db, &input, &user_id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn update_listening_question_groups(db: State<'_, Db>, id: String, user_id: String, input: UpdateListeningQuestionGroup) -> Result<(), String> {
    repo::update(&db, &id, &user_id, &input).await.map_err(Into::into)
}

#[tauri::command]
pub async fn delete_listening_question_groups(db: State<'_, Db>, id: String, user_id: String) -> Result<(), String> {
    repo::delete(&db, &id, &user_id).await.map_err(Into::into)
}
