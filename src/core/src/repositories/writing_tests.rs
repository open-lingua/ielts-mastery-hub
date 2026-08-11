use serde::{Deserialize, Serialize};

use crate::db::Db;
use crate::error::AppError;

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct WritingTest {
    pub id: String,
    pub created_by: String,
    pub title: String,
    pub status: String,
    pub created_at: String,
    pub updated_at: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateWritingTest {
    pub title: Option<String>,
    pub status: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateWritingTest {
    pub title: Option<String>,
    pub status: Option<String>,
}

pub async fn find_by_id(
    pool: &Db,
    id: &str,
    user_id: &str,
) -> Result<Option<WritingTest>, AppError> {
    let result = sqlx::query_as!(
        WritingTest,
        "SELECT id, created_by, title, status, created_at, updated_at
         FROM writing_tests WHERE id = ? AND (created_by = ? OR status = 'published')",
        id,
        user_id
    )
    .fetch_optional(pool)
    .await?;
    Ok(result)
}

pub async fn find_all(pool: &Db, user_id: &str) -> Result<Vec<WritingTest>, AppError> {
    let result = sqlx::query_as!(
        WritingTest,
        "SELECT id, created_by, title, status, created_at, updated_at
         FROM writing_tests WHERE created_by = ? OR status = 'published'",
        user_id
    )
    .fetch_all(pool)
    .await?;
    Ok(result)
}

pub async fn insert(
    pool: &Db,
    input: &CreateWritingTest,
    user_id: &str,
) -> Result<String, AppError> {
    let id = uuid::Uuid::new_v4().to_string();
    let now = chrono::Utc::now().to_rfc3339();
    let title = input.title.as_deref().unwrap_or("");
    let status = input.status.as_deref().unwrap_or("draft");
    sqlx::query!(
        "INSERT INTO writing_tests (id, created_by, title, status, created_at, updated_at)
         VALUES (?, ?, ?, ?, ?, ?)",
        id,
        user_id,
        title,
        status,
        now,
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
    input: &UpdateWritingTest,
) -> Result<(), AppError> {
    let now = chrono::Utc::now().to_rfc3339();
    sqlx::query!(
        "UPDATE writing_tests SET
         title = COALESCE(?, title),
         status = COALESCE(?, status),
         updated_at = ?
         WHERE id = ? AND created_by = ?",
        input.title,
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
        "DELETE FROM writing_tests WHERE id = ? AND created_by = ?",
        id,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}
