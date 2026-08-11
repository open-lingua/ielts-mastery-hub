use serde::{Deserialize, Serialize};

use crate::database::Db;
use crate::error::AppError;

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct Profile {
    pub id: String,
    pub full_name: Option<String>,
    pub avatar_url: Option<String>,
    pub plan_type: String,
    pub email: Option<String>,
    pub is_banned: bool,
    pub ban_reason: Option<String>,
    pub banned_until: Option<String>,
    pub updated_at: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateProfile {
    pub full_name: Option<String>,
    pub avatar_url: Option<String>,
    pub plan_type: Option<String>,
    pub email: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateProfile {
    pub full_name: Option<String>,
    pub avatar_url: Option<String>,
    pub plan_type: Option<String>,
    pub email: Option<String>,
    pub is_banned: Option<bool>,
    pub ban_reason: Option<String>,
    pub banned_until: Option<String>,
}

pub async fn find_by_id(pool: &Db, id: &str) -> Result<Option<Profile>, AppError> {
    let result = sqlx::query_as!(
        Profile,
        r#"SELECT id, full_name, avatar_url, plan_type, email,
           is_banned AS "is_banned: bool", ban_reason, banned_until, updated_at
           FROM profiles WHERE id = ?"#,
        id
    )
    .fetch_optional(pool)
    .await?;
    Ok(result)
}

pub async fn find_all(pool: &Db) -> Result<Vec<Profile>, AppError> {
    let result = sqlx::query_as!(
        Profile,
        r#"SELECT id, full_name, avatar_url, plan_type, email,
           is_banned AS "is_banned: bool", ban_reason, banned_until, updated_at
           FROM profiles"#
    )
    .fetch_all(pool)
    .await?;
    Ok(result)
}

pub async fn insert(pool: &Db, input: &CreateProfile) -> Result<String, AppError> {
    let id = uuid::Uuid::new_v4().to_string();
    let now = chrono::Utc::now().to_rfc3339();
    let plan_type = input.plan_type.as_deref().unwrap_or("free");
    sqlx::query!(
        "INSERT INTO profiles (id, full_name, avatar_url, plan_type, email, updated_at)
         VALUES (?, ?, ?, ?, ?, ?)",
        id,
        input.full_name,
        input.avatar_url,
        plan_type,
        input.email,
        now
    )
    .execute(pool)
    .await?;
    Ok(id)
}

pub async fn update(pool: &Db, user_id: &str, input: &UpdateProfile) -> Result<(), AppError> {
    let now = chrono::Utc::now().to_rfc3339();
    let is_banned = input.is_banned.map(|b| b as i64);
    sqlx::query!(
        "UPDATE profiles SET
         full_name = COALESCE(?, full_name),
         avatar_url = COALESCE(?, avatar_url),
         plan_type = COALESCE(?, plan_type),
         email = COALESCE(?, email),
         is_banned = COALESCE(?, is_banned),
         ban_reason = COALESCE(?, ban_reason),
         banned_until = COALESCE(?, banned_until),
         updated_at = ?
         WHERE id = ?",
        input.full_name,
        input.avatar_url,
        input.plan_type,
        input.email,
        is_banned,
        input.ban_reason,
        input.banned_until,
        now,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}

pub async fn delete(pool: &Db, user_id: &str) -> Result<(), AppError> {
    sqlx::query!("DELETE FROM profiles WHERE id = ?", user_id)
        .execute(pool)
        .await?;
    Ok(())
}
