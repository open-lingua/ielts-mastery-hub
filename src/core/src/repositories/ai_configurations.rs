use crate::database::Db;
use crate::error::AppError;
use crate::models::ai_configurations::AiConfiguration;

pub async fn find_all(pool: &Db) -> Result<Vec<AiConfiguration>, AppError> {
    let result = sqlx::query_as!(
        AiConfiguration,
        r#"SELECT provider_id, is_active AS "is_active: bool", credentials_json, created_at, updated_at
           FROM ai_configurations ORDER BY provider_id"#
    )
    .fetch_all(pool)
    .await?;
    Ok(result)
}

pub async fn find_by_provider(
    pool: &Db,
    provider_id: &str,
) -> Result<Option<AiConfiguration>, AppError> {
    let result = sqlx::query_as!(
        AiConfiguration,
        r#"SELECT provider_id, is_active AS "is_active: bool", credentials_json, created_at, updated_at
           FROM ai_configurations WHERE provider_id = ?"#,
        provider_id
    )
    .fetch_optional(pool)
    .await?;
    Ok(result)
}

pub async fn find_active(pool: &Db) -> Result<Option<AiConfiguration>, AppError> {
    let result = sqlx::query_as!(
        AiConfiguration,
        r#"SELECT provider_id, is_active AS "is_active: bool", credentials_json, created_at, updated_at
           FROM ai_configurations WHERE is_active = 1"#
    )
    .fetch_optional(pool)
    .await?;
    Ok(result)
}

/// Upserts the encrypted credentials for `provider_id` and makes it the sole active
/// provider, deactivating any other provider that was previously active. Runs in a
/// transaction so the "only one active provider" invariant is never observable as
/// violated (e.g. two active rows) by a concurrent reader.
pub async fn upsert_and_activate(
    pool: &Db,
    provider_id: &str,
    encrypted_credentials: &str,
) -> Result<(), AppError> {
    let now = chrono::Utc::now().to_rfc3339();
    let mut tx = pool.begin().await?;

    sqlx::query!(
        "UPDATE ai_configurations SET is_active = 0 WHERE provider_id != ?",
        provider_id
    )
    .execute(&mut *tx)
    .await?;

    sqlx::query!(
        "INSERT INTO ai_configurations (provider_id, is_active, credentials_json, created_at, updated_at)
         VALUES (?, 1, ?, ?, ?)
         ON CONFLICT(provider_id) DO UPDATE SET
           is_active = 1,
           credentials_json = excluded.credentials_json,
           updated_at = excluded.updated_at",
        provider_id,
        encrypted_credentials,
        now,
        now
    )
    .execute(&mut *tx)
    .await?;

    tx.commit().await?;
    Ok(())
}

/// Makes `provider_id` the sole active provider without touching its stored
/// credentials, deactivating any other provider that was previously active. Runs in a
/// transaction so the "only one active provider" invariant is never observable as
/// violated. Returns `AppError::NotFound` (and rolls back) if `provider_id` has no
/// stored row.
pub async fn activate(pool: &Db, provider_id: &str) -> Result<(), AppError> {
    let now = chrono::Utc::now().to_rfc3339();
    let mut tx = pool.begin().await?;

    sqlx::query!(
        "UPDATE ai_configurations SET is_active = 0 WHERE provider_id != ?",
        provider_id
    )
    .execute(&mut *tx)
    .await?;

    let result = sqlx::query!(
        "UPDATE ai_configurations SET is_active = 1, updated_at = ? WHERE provider_id = ?",
        now,
        provider_id
    )
    .execute(&mut *tx)
    .await?;

    if result.rows_affected() == 0 {
        return Err(AppError::NotFound(provider_id.to_string()));
    }

    tx.commit().await?;
    Ok(())
}

/// Clears a provider's stored credentials and deactivates it. Backs the
/// `delete_ai_configuration` command; a no-op if the provider has no stored row.
pub async fn clear(pool: &Db, provider_id: &str) -> Result<(), AppError> {
    let now = chrono::Utc::now().to_rfc3339();
    sqlx::query!(
        "UPDATE ai_configurations SET credentials_json = '', is_active = 0, updated_at = ?
         WHERE provider_id = ?",
        now,
        provider_id
    )
    .execute(pool)
    .await?;
    Ok(())
}
