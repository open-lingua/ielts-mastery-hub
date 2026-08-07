use serde::{Deserialize, Serialize};

use crate::db::Db;
use crate::error::AppError;

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct ReadingTest {
    pub id: String,
    pub created_by: String,
    pub title: String,
    pub test_type: String,
    pub difficulty: String,
    pub duration: String,
    pub status: String,
    pub created_at: String,
    pub updated_at: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateReadingTest {
    pub title: Option<String>,
    pub test_type: Option<String>,
    pub difficulty: Option<String>,
    pub duration: Option<String>,
    pub status: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateReadingTest {
    pub title: Option<String>,
    pub test_type: Option<String>,
    pub difficulty: Option<String>,
    pub duration: Option<String>,
    pub status: Option<String>,
}

pub async fn find_by_id(pool: &Db, id: &str, user_id: &str) -> Result<Option<ReadingTest>, AppError> {
    let result = sqlx::query_as!(
        ReadingTest,
        "SELECT id, created_by, title, test_type, difficulty, duration, status, created_at, updated_at
         FROM reading_tests WHERE id = ? AND (created_by = ? OR status = 'published')",
        id,
        user_id
    )
    .fetch_optional(pool)
    .await?;
    Ok(result)
}

pub async fn find_all(pool: &Db, user_id: &str) -> Result<Vec<ReadingTest>, AppError> {
    let result = sqlx::query_as!(
        ReadingTest,
        "SELECT id, created_by, title, test_type, difficulty, duration, status, created_at, updated_at
         FROM reading_tests WHERE created_by = ? OR status = 'published'",
        user_id
    )
    .fetch_all(pool)
    .await?;
    Ok(result)
}

pub async fn insert(pool: &Db, input: &CreateReadingTest, user_id: &str) -> Result<String, AppError> {
    let id = uuid::Uuid::new_v4().to_string();
    let now = chrono::Utc::now().to_rfc3339();
    let title = input.title.as_deref().unwrap_or("");
    let test_type = input.test_type.as_deref().unwrap_or("Academic");
    let difficulty = input.difficulty.as_deref().unwrap_or("7");
    let duration = input.duration.as_deref().unwrap_or("60 mins");
    let status = input.status.as_deref().unwrap_or("draft");
    sqlx::query!(
        "INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status, created_at, updated_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
        id,
        user_id,
        title,
        test_type,
        difficulty,
        duration,
        status,
        now,
        now
    )
    .execute(pool)
    .await?;
    Ok(id)
}

pub async fn update(pool: &Db, id: &str, user_id: &str, input: &UpdateReadingTest) -> Result<(), AppError> {
    let now = chrono::Utc::now().to_rfc3339();
    sqlx::query!(
        "UPDATE reading_tests SET
         title = COALESCE(?, title),
         test_type = COALESCE(?, test_type),
         difficulty = COALESCE(?, difficulty),
         duration = COALESCE(?, duration),
         status = COALESCE(?, status),
         updated_at = ?
         WHERE id = ? AND created_by = ?",
        input.title,
        input.test_type,
        input.difficulty,
        input.duration,
        input.status,
        now,
        id,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}

pub async fn delete(pool: &Db, id: &str, user_id: &str) -> Result<(), AppError> {
    sqlx::query!(
        "DELETE FROM reading_tests WHERE id = ? AND created_by = ?",
        id,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}
