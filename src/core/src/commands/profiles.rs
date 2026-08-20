use tauri::State;

use crate::database::Db;
use crate::repositories::profiles as repo;
use crate::models::profiles::{CreateProfile, Profile, UpdateProfile};

#[tauri::command]
pub async fn get_profiles(db: State<'_, Db>, id: String) -> Result<Option<Profile>, String> {
    repo::find_by_id(&db, &id).await.map_err(Into::into)
}

#[tauri::command]
pub async fn list_profiles(db: State<'_, Db>) -> Result<Vec<Profile>, String> {
    repo::find_all(&db).await.map_err(Into::into)
}

#[tauri::command]
pub async fn create_profiles(db: State<'_, Db>, input: CreateProfile) -> Result<String, String> {
    repo::insert(&db, &input).await.map_err(Into::into)
}

#[tauri::command]
pub async fn update_profiles(
    db: State<'_, Db>,
    id: String,
    input: UpdateProfile,
) -> Result<(), String> {
    repo::update(&db, &id, &input).await.map_err(Into::into)
}

#[tauri::command]
pub async fn delete_profiles(db: State<'_, Db>, id: String) -> Result<(), String> {
    repo::delete(&db, &id).await.map_err(Into::into)
}
