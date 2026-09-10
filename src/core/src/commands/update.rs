use crate::services::update_service::{self, UpdateCheckResult};

/// Checks GitHub for the latest release of this repo and returns its version + release page URL.
/// Comparison-only — the frontend decides whether to surface an "update available" indicator and
/// only opens the release URL on explicit user action; nothing is downloaded or installed here.
#[tauri::command]
pub async fn check_for_update() -> Result<UpdateCheckResult, String> {
    update_service::check_for_update(update_service::GITHUB_API_BASE)
        .await
        .map_err(Into::<String>::into)
}
