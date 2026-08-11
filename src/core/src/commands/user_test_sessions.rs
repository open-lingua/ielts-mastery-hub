use tauri::State;

use crate::database::Db;
use crate::repositories::user_test_sessions as repo;
use crate::repositories::user_test_sessions::{
    CreateUserTestSession, UpdateUserTestSession, UserTestSession,
};

#[tauri::command]
pub async fn get_user_test_sessions(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<Option<UserTestSession>, String> {
    repo::find_by_id(&db, &id, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn list_user_test_sessions(
    db: State<'_, Db>,
    user_id: String,
) -> Result<Vec<UserTestSession>, String> {
    repo::find_all(&db, &user_id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn create_user_test_sessions(
    db: State<'_, Db>,
    user_id: String,
    input: CreateUserTestSession,
) -> Result<String, String> {
    repo::insert(&db, &input, &user_id)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn update_user_test_sessions(
    db: State<'_, Db>,
    id: String,
    user_id: String,
    input: UpdateUserTestSession,
) -> Result<(), String> {
    repo::update(&db, &id, &user_id, &input)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn delete_user_test_sessions(
    db: State<'_, Db>,
    id: String,
    user_id: String,
) -> Result<(), String> {
    repo::delete(&db, &id, &user_id).await.map_err(Into::into)
}
