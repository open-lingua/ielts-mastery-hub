use serde::{Deserialize, Serialize};

use crate::db::Db;
use crate::error::AppError;

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct UserRole {
    pub id: String,
    pub user_id: String,
    pub role: String,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateUserRole {
    pub user_id: String,
    pub role: String,
}

#[derive(Debug, Deserialize)]
pub struct UpdateUserRole {
    pub role: Option<String>,
}

pub async fn find_by_id(pool: &Db, id: &str, user_id: &str) -> Result<Option<UserRole>, AppError> {
    let result = sqlx::query_as!(
        UserRole,
        "SELECT id, user_id, role, created_at FROM user_roles WHERE id = ? AND user_id = ?",
        id,
        user_id
    )
    .fetch_optional(pool)
    .await?;
    Ok(result)
}

pub async fn find_all(pool: &Db, user_id: &str) -> Result<Vec<UserRole>, AppError> {
    let result = sqlx::query_as!(
        UserRole,
        "SELECT id, user_id, role, created_at FROM user_roles WHERE user_id = ?",
        user_id
    )
    .fetch_all(pool)
    .await?;
    Ok(result)
}

pub async fn insert(pool: &Db, input: &CreateUserRole) -> Result<String, AppError> {
    let id = uuid::Uuid::new_v4().to_string();
    let now = chrono::Utc::now().to_rfc3339();
    sqlx::query!(
        "INSERT INTO user_roles (id, user_id, role, created_at) VALUES (?, ?, ?, ?)",
        id,
        input.user_id,
        input.role,
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
    input: &UpdateUserRole,
) -> Result<(), AppError> {
    sqlx::query!(
        "UPDATE user_roles SET role = COALESCE(?, role) WHERE id = ? AND user_id = ?",
        input.role,
        id,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}

pub async fn delete(pool: &Db, id: &str, user_id: &str) -> Result<(), AppError> {
    sqlx::query!(
        "DELETE FROM user_roles WHERE id = ? AND user_id = ?",
        id,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}
