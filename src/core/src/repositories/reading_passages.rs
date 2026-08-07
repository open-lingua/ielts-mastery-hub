use serde::{Deserialize, Serialize};

use crate::db::Db;
use crate::error::AppError;

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct ReadingPassage {
    pub id: String,
    pub test_id: String,
    pub passage_number: i64,
    pub title: String,
    pub content: String,
    pub notes: Option<String>,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateReadingPassage {
    pub test_id: String,
    pub passage_number: Option<i64>,
    pub title: Option<String>,
    pub content: Option<String>,
    pub notes: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateReadingPassage {
    pub passage_number: Option<i64>,
    pub title: Option<String>,
    pub content: Option<String>,
    pub notes: Option<String>,
}

pub async fn find_by_id(pool: &Db, id: &str, user_id: &str) -> Result<Option<ReadingPassage>, AppError> {
    let result = sqlx::query_as!(
        ReadingPassage,
        "SELECT p.id, p.test_id, p.passage_number, p.title, p.content, p.notes, p.created_at
         FROM reading_passages p JOIN reading_tests t ON t.id = p.test_id
         WHERE p.id = ? AND (t.created_by = ? OR t.status = 'published')",
        id,
        user_id
    )
    .fetch_optional(pool)
    .await?;
    Ok(result)
}

pub async fn find_all(pool: &Db, user_id: &str) -> Result<Vec<ReadingPassage>, AppError> {
    let result = sqlx::query_as!(
        ReadingPassage,
        "SELECT p.id, p.test_id, p.passage_number, p.title, p.content, p.notes, p.created_at
         FROM reading_passages p JOIN reading_tests t ON t.id = p.test_id
         WHERE t.created_by = ? OR t.status = 'published'",
        user_id
    )
    .fetch_all(pool)
    .await?;
    Ok(result)
}

pub async fn insert(pool: &Db, input: &CreateReadingPassage, user_id: &str) -> Result<String, AppError> {
    let owned: i64 = sqlx::query_scalar!(
        "SELECT COUNT(*) FROM reading_tests WHERE id = ? AND created_by = ?",
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
    let passage_number = input.passage_number.unwrap_or(1);
    let title = input.title.as_deref().unwrap_or("");
    let content = input.content.as_deref().unwrap_or("");
    sqlx::query!(
        "INSERT INTO reading_passages (id, test_id, passage_number, title, content, notes, created_at)
         VALUES (?, ?, ?, ?, ?, ?, ?)",
        id,
        input.test_id,
        passage_number,
        title,
        content,
        input.notes,
        now
    )
    .execute(pool)
    .await?;
    Ok(id)
}

pub async fn update(pool: &Db, id: &str, user_id: &str, input: &UpdateReadingPassage) -> Result<(), AppError> {
    sqlx::query!(
        "UPDATE reading_passages SET
         passage_number = COALESCE(?, passage_number),
         title = COALESCE(?, title),
         content = COALESCE(?, content),
         notes = COALESCE(?, notes)
         WHERE id = ? AND EXISTS (
           SELECT 1 FROM reading_tests t WHERE t.id = test_id AND t.created_by = ?
         )",
        input.passage_number,
        input.title,
        input.content,
        input.notes,
        id,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}

pub async fn delete(pool: &Db, id: &str, user_id: &str) -> Result<(), AppError> {
    sqlx::query!(
        "DELETE FROM reading_passages WHERE id = ? AND EXISTS (
           SELECT 1 FROM reading_tests t WHERE t.id = test_id AND t.created_by = ?
         )",
        id,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}
