use tauri::State;

use crate::database::Db;
use crate::models::ai_configurations::{AiConfigurationSummary, SaveAiConfiguration};
use crate::services::ai_configuration_service as service;
use crate::state::AiConfigKey;

#[tauri::command]
pub async fn list_ai_configurations(
    db: State<'_, Db>,
    key: State<'_, AiConfigKey>,
) -> Result<Vec<AiConfigurationSummary>, String> {
    service::list_configurations(&db, &key).await.map_err(Into::into)
}

#[tauri::command]
pub async fn save_ai_configuration(
    db: State<'_, Db>,
    key: State<'_, AiConfigKey>,
    input: SaveAiConfiguration,
) -> Result<AiConfigurationSummary, String> {
    service::save_configuration(&db, &key, &input)
        .await
        .map_err(Into::into)
}

#[tauri::command]
pub async fn delete_ai_configuration(db: State<'_, Db>, provider_id: String) -> Result<(), String> {
    service::delete_configuration(&db, &provider_id)
        .await
        .map_err(Into::into)
}
