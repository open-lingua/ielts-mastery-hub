use tauri::State;

use crate::db::Db;
use crate::repositories::user_roles::{CreateUserRole, UpdateUserRole, UserRole};
use crate::repositories::user_roles as repo;

#[tauri::command]
pub async fn get_user_roles(db: State<'_, Db>, id: String, user_id: String) -> Result<Option<UserRole>, String> {
    repo::find_by_id(&db, &id, &user_id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn list_user_roles(db: State<'_, Db>, user_id: String) -> Result<Vec<UserRole>, String> {
    repo::find_all(&db, &user_id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn create_user_roles(db: State<'_, Db>, input: CreateUserRole) -> Result<String, String> {
    repo::insert(&db, &input).await.map_err(Into::into)
}

#[tauri::command]
pub async fn update_user_roles(db: State<'_, Db>, id: String, user_id: String, input: UpdateUserRole) -> Result<(), String> {
    repo::update(&db, &id, &user_id, &input).await.map_err(Into::into)
}

#[tauri::command]
pub async fn delete_user_roles(db: State<'_, Db>, id: String, user_id: String) -> Result<(), String> {
    repo::delete(&db, &id, &user_id).await.map_err(Into::into)
}
