use std::collections::HashMap;

use serde::{Deserialize, Serialize};

/// Internal representation of a stored provider row. `credentials_json` holds an
/// *encrypted* envelope (see `crate::crypto`) — never a plaintext JSON literal, and
/// never serialized out to the frontend.
#[derive(Debug, Clone, sqlx::FromRow)]
pub struct AiConfiguration {
    pub provider_id: String,
    pub is_active: bool,
    pub credentials_json: String,
    pub created_at: String,
    pub updated_at: String,
}

/// The only shape ever returned to the frontend for an AI configuration — deliberately
/// excludes any credential values (API keys, endpoints, etc.), per the project's rule
/// against serializing sensitive data into command return values.
#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct AiConfigurationSummary {
    pub provider_id: String,
    pub is_active: bool,
    pub configured: bool,
    pub updated_at: String,
}

#[derive(Debug, Deserialize)]
pub struct SaveAiConfiguration {
    pub provider_id: String,
    pub credentials: HashMap<String, String>,
}
