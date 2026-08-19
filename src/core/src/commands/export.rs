use tauri::State;

use crate::database::Db;
use crate::services::export_service::{self, ExportResult};

#[tauri::command]
pub async fn export_test_to_zip(
    db: State<'_, Db>,
    user_id: String,
    kind: String,
    id: String,
) -> Result<ExportResult, String> {
    export_service::export_test(&db, &user_id, &kind, &id)
        .await
        .map_err(Into::into)
}
