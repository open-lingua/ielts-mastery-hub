use std::collections::HashMap;

use crate::crypto;
use crate::database::Db;
use crate::error::AppError;
use crate::models::ai_configurations::{AiConfiguration, AiConfigurationSummary, SaveAiConfiguration};
use crate::repositories::ai_configurations as repo;
use crate::state::AiConfigKey;

/// Known provider IDs and the credential fields each one requires, mirroring the
/// frontend's `PROVIDERS` schema (`src/ui/pages/admin/AiConfigurations.tsx`).
fn required_fields(provider_id: &str) -> Option<&'static [&'static str]> {
    match provider_id {
        // `model` is optional for `chatgpt`/`gemini` (default to OPENAI_MODEL/GEMINI_MODEL
        // in ai_provider_client.rs when not set), same as `general`'s optional `model` field.
        "gemini" => Some(&["apiKey"]),
        "chatgpt" => Some(&["apiKey"]),
        "claude" => Some(&["apiKey"]),
        "local" => Some(&["endpoint", "model"]),
        "general" => Some(&["endpoint", "headerName"]),
        _ => None,
    }
}

fn is_blank(value: Option<&String>) -> bool {
    value.map(|v| v.trim().is_empty()).unwrap_or(true)
}

fn has_required_fields(provider_id: &str, credentials: &HashMap<String, String>) -> bool {
    match required_fields(provider_id) {
        Some(fields) => fields.iter().all(|f| !is_blank(credentials.get(*f))),
        None => false,
    }
}

fn to_summary(row: &AiConfiguration, key: &AiConfigKey) -> AiConfigurationSummary {
    let configured = decrypt_credentials(row, key)
        .map(|creds| has_required_fields(&row.provider_id, &creds))
        .unwrap_or(false);

    AiConfigurationSummary {
        provider_id: row.provider_id.clone(),
        is_active: row.is_active,
        configured,
        updated_at: row.updated_at.clone(),
    }
}

fn decrypt_credentials(
    row: &AiConfiguration,
    key: &AiConfigKey,
) -> Result<HashMap<String, String>, AppError> {
    if row.credentials_json.is_empty() {
        return Ok(HashMap::new());
    }
    let plaintext = crypto::decrypt(&key.0, &row.credentials_json)?;
    let credentials: HashMap<String, String> = serde_json::from_str(&plaintext)?;
    Ok(credentials)
}

pub async fn list_configurations(
    pool: &Db,
    key: &AiConfigKey,
) -> Result<Vec<AiConfigurationSummary>, AppError> {
    let rows = repo::find_all(pool).await?;
    Ok(rows.iter().map(|row| to_summary(row, key)).collect())
}

pub async fn save_configuration(
    pool: &Db,
    key: &AiConfigKey,
    input: &SaveAiConfiguration,
) -> Result<AiConfigurationSummary, AppError> {
    let fields = required_fields(&input.provider_id).ok_or_else(|| {
        AppError::Validation(format!("unknown AI provider: {}", input.provider_id))
    })?;

    for field in fields {
        if is_blank(input.credentials.get(*field)) {
            return Err(AppError::Validation(format!(
                "missing required field `{}` for provider `{}`",
                field, input.provider_id
            )));
        }
    }

    let plaintext = serde_json::to_string(&input.credentials)?;
    let encrypted = crypto::encrypt(&key.0, &plaintext)?;

    repo::upsert_and_activate(pool, &input.provider_id, &encrypted).await?;

    let row = repo::find_by_provider(pool, &input.provider_id)
        .await?
        .ok_or_else(|| AppError::NotFound(input.provider_id.clone()))?;

    Ok(to_summary(&row, key))
}

/// Reactivates an already-configured provider without touching its stored
/// credentials, deactivating whichever provider was previously active. Rejects unknown
/// provider ids, providers with no stored row, and providers whose stored credentials
/// don't satisfy their required fields (so `grade_writing` never silently ends up
/// "active" with unusable credentials).
pub async fn activate_configuration(
    pool: &Db,
    key: &AiConfigKey,
    provider_id: &str,
) -> Result<AiConfigurationSummary, AppError> {
    if required_fields(provider_id).is_none() {
        return Err(AppError::Validation(format!(
            "unknown AI provider: {}",
            provider_id
        )));
    }

    let row = repo::find_by_provider(pool, provider_id)
        .await?
        .ok_or_else(|| AppError::NotFound(provider_id.to_string()))?;

    let credentials = decrypt_credentials(&row, key)?;
    if !has_required_fields(provider_id, &credentials) {
        return Err(AppError::Validation(format!(
            "provider `{}` is not configured",
            provider_id
        )));
    }

    repo::activate(pool, provider_id).await?;

    let row = repo::find_by_provider(pool, provider_id)
        .await?
        .ok_or_else(|| AppError::NotFound(provider_id.to_string()))?;

    Ok(to_summary(&row, key))
}

pub async fn delete_configuration(pool: &Db, provider_id: &str) -> Result<(), AppError> {
    if required_fields(provider_id).is_none() {
        return Err(AppError::Validation(format!(
            "unknown AI provider: {}",
            provider_id
        )));
    }
    repo::clear(pool, provider_id).await
}

/// Returns the currently active provider's ID and decrypted credentials, or `None` if
/// no provider is active. Used only by `grade_writing` — the plaintext credentials
/// never leave the backend process.
pub async fn get_active_credentials(
    pool: &Db,
    key: &AiConfigKey,
) -> Result<Option<(String, HashMap<String, String>)>, AppError> {
    let Some(row) = repo::find_active(pool).await? else {
        return Ok(None);
    };
    let credentials = decrypt_credentials(&row, key)?;
    Ok(Some((row.provider_id, credentials)))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_recognizes_known_providers_and_their_required_fields() {
        assert_eq!(required_fields("gemini"), Some(&["apiKey"][..]));
        assert_eq!(required_fields("general"), Some(&["endpoint", "headerName"][..]));
        assert_eq!(required_fields("local"), Some(&["endpoint", "model"][..]));
        assert_eq!(required_fields("unknown"), None);
    }

    #[test]
    fn it_treats_missing_or_blank_values_as_not_configured() {
        let mut credentials = HashMap::new();
        assert!(!has_required_fields("gemini", &credentials));

        credentials.insert("apiKey".to_string(), "   ".to_string());
        assert!(!has_required_fields("gemini", &credentials));

        credentials.insert("apiKey".to_string(), "sk-real-key".to_string());
        assert!(has_required_fields("gemini", &credentials));
    }
}
