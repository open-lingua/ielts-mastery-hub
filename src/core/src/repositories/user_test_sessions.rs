use serde::{Deserialize, Serialize};

use crate::db::Db;
use crate::error::AppError;

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct UserTestSession {
    pub id: String,
    pub user_id: String,
    pub test_id: String,
    pub test_type: String,
    pub status: String,
    pub progress_percent: i64,
    pub score_band: Option<f64>,
    pub attempt_number: i64,
    pub answers: Option<String>,
    pub feedback_data: Option<String>,
    pub started_at: String,
    pub completed_at: Option<String>,
    pub last_active_at: String,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateUserTestSession {
    pub test_id: String,
    pub test_type: String,
    pub attempt_number: Option<i64>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateUserTestSession {
    pub status: Option<String>,
    pub progress_percent: Option<i64>,
    pub score_band: Option<f64>,
    pub answers: Option<String>,
    pub feedback_data: Option<String>,
    pub completed_at: Option<String>,
    pub last_active_at: Option<String>,
}

pub async fn find_by_id(
    pool: &Db,
    id: &str,
    user_id: &str,
) -> Result<Option<UserTestSession>, AppError> {
    let result = sqlx::query_as!(
        UserTestSession,
        "SELECT id, user_id, test_id, test_type, status, progress_percent, score_band,
         attempt_number, answers, feedback_data, started_at, completed_at, last_active_at, created_at
         FROM user_test_sessions WHERE id = ? AND user_id = ?",
        id,
        user_id
    )
    .fetch_optional(pool)
    .await?;
    Ok(result)
}

pub async fn find_all(pool: &Db, user_id: &str) -> Result<Vec<UserTestSession>, AppError> {
    let result = sqlx::query_as!(
        UserTestSession,
        "SELECT id, user_id, test_id, test_type, status, progress_percent, score_band,
         attempt_number, answers, feedback_data, started_at, completed_at, last_active_at, created_at
         FROM user_test_sessions WHERE user_id = ? ORDER BY created_at DESC",
        user_id
    )
    .fetch_all(pool)
    .await?;
    Ok(result)
}

pub async fn insert(
    pool: &Db,
    input: &CreateUserTestSession,
    user_id: &str,
) -> Result<String, AppError> {
    let id = uuid::Uuid::new_v4().to_string();
    let now = chrono::Utc::now().to_rfc3339();
    let attempt_number = input.attempt_number.unwrap_or(1);
    sqlx::query!(
        "INSERT INTO user_test_sessions
         (id, user_id, test_id, test_type, attempt_number, started_at, last_active_at, created_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        id,
        user_id,
        input.test_id,
        input.test_type,
        attempt_number,
        now,
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
    input: &UpdateUserTestSession,
) -> Result<(), AppError> {
    sqlx::query!(
        "UPDATE user_test_sessions SET
         status = COALESCE(?, status),
         progress_percent = COALESCE(?, progress_percent),
         score_band = COALESCE(?, score_band),
         answers = COALESCE(?, answers),
         feedback_data = COALESCE(?, feedback_data),
         completed_at = COALESCE(?, completed_at),
         last_active_at = COALESCE(?, last_active_at)
         WHERE id = ? AND user_id = ?",
        input.status,
        input.progress_percent,
        input.score_band,
        input.answers,
        input.feedback_data,
        input.completed_at,
        input.last_active_at,
        id,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}

pub async fn delete(pool: &Db, id: &str, user_id: &str) -> Result<(), AppError> {
    sqlx::query!(
        "DELETE FROM user_test_sessions WHERE id = ? AND user_id = ?",
        id,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}
