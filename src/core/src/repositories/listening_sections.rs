use serde::{Deserialize, Serialize};

use crate::db::Db;
use crate::error::AppError;

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct ListeningSection {
    pub id: String,
    pub test_id: String,
    pub section_number: i64,
    pub title: String,
    pub transcript: Option<String>,
    pub audio_url: Option<String>,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateListeningSection {
    pub test_id: String,
    pub section_number: Option<i64>,
    pub title: Option<String>,
    pub transcript: Option<String>,
    pub audio_url: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateListeningSection {
    pub section_number: Option<i64>,
    pub title: Option<String>,
    pub transcript: Option<String>,
    pub audio_url: Option<String>,
}

pub async fn find_by_id(
    pool: &Db,
    id: &str,
    user_id: &str,
) -> Result<Option<ListeningSection>, AppError> {
    let result = sqlx::query_as!(
        ListeningSection,
        "SELECT s.id, s.test_id, s.section_number, s.title, s.transcript, s.audio_url, s.created_at
         FROM listening_sections s JOIN listening_tests t ON t.id = s.test_id
         WHERE s.id = ? AND (t.created_by = ? OR t.status = 'published')",
        id,
        user_id
    )
    .fetch_optional(pool)
    .await?;
    Ok(result)
}

pub async fn find_all(pool: &Db, user_id: &str) -> Result<Vec<ListeningSection>, AppError> {
    let result = sqlx::query_as!(
        ListeningSection,
        "SELECT s.id, s.test_id, s.section_number, s.title, s.transcript, s.audio_url, s.created_at
         FROM listening_sections s JOIN listening_tests t ON t.id = s.test_id
         WHERE t.created_by = ? OR t.status = 'published'",
        user_id
    )
    .fetch_all(pool)
    .await?;
    Ok(result)
}

pub async fn insert(
    pool: &Db,
    input: &CreateListeningSection,
    user_id: &str,
) -> Result<String, AppError> {
    let owned: i64 = sqlx::query_scalar!(
        "SELECT COUNT(*) FROM listening_tests WHERE id = ? AND created_by = ?",
        input.test_id,
        user_id
    )
    .fetch_one(pool)
    .await?;
    if owned == 0 {
        return Err(AppError::Validation("not authorized".to_string()));
    }
    let id = uuid::Uuid::new_v4().to_string();
    let now = chrono::Utc::now().to_rfc3339();
    let section_number = input.section_number.unwrap_or(1);
    let title = input.title.as_deref().unwrap_or("");
    sqlx::query!(
        "INSERT INTO listening_sections (id, test_id, section_number, title, transcript, audio_url, created_at)
         VALUES (?, ?, ?, ?, ?, ?, ?)",
        id,
        input.test_id,
        section_number,
        title,
        input.transcript,
        input.audio_url,
        now
    )
    .execute(pool)
    .await?;
    Ok(id)
}

pub async fn update(
    pool: &Db,
    id: &str,
    user_id: &str,
    input: &UpdateListeningSection,
) -> Result<(), AppError> {
    sqlx::query!(
        "UPDATE listening_sections SET
         section_number = COALESCE(?, section_number),
         title = COALESCE(?, title),
         transcript = COALESCE(?, transcript),
         audio_url = COALESCE(?, audio_url)
         WHERE id = ? AND EXISTS (
           SELECT 1 FROM listening_tests t WHERE t.id = test_id AND t.created_by = ?
         )",
        input.section_number,
        input.title,
        input.transcript,
        input.audio_url,
        id,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}

pub async fn delete(pool: &Db, id: &str, user_id: &str) -> Result<(), AppError> {
    sqlx::query!(
        "DELETE FROM listening_sections WHERE id = ? AND EXISTS (
           SELECT 1 FROM listening_tests t WHERE t.id = test_id AND t.created_by = ?
         )",
        id,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}
