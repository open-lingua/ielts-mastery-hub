use tauri::{AppHandle, State};
use tauri_plugin_dialog::DialogExt;

use crate::database::Db;
use crate::services::export_service::{self, ExportResult};

/// Builds the export zip in memory, then prompts the admin with a native "Save As" dialog to
/// choose the destination. Returns `Ok(None)` if the admin cancels the dialog (not an error).
#[tauri::command]
pub async fn export_test_to_zip(
    app: AppHandle,
    db: State<'_, Db>,
    user_id: String,
    kind: String,
    id: String,
) -> Result<Option<ExportResult>, String> {
    let built = export_service::build_export(&db, &user_id, &kind, &id)
        .await
        .map_err(Into::<String>::into)?;

    let file_name = built.file_name.clone();
    let default_dir = export_service::default_export_dir();

    let chosen = tauri::async_runtime::spawn_blocking(move || {
        let mut dialog = app
            .dialog()
            .file()
            .set_file_name(&file_name)
            .add_filter("Zip Archive", &["zip"]);
        if let Some(dir) = default_dir {
            dialog = dialog.set_directory(dir);
        }
        dialog.blocking_save_file()
    })
    .await
    .map_err(|e| e.to_string())?;

    let Some(file_path) = chosen else {
        return Ok(None);
    };
    let path = file_path.into_path().map_err(|e| e.to_string())?;

    if let Some(parent) = path.parent() {
        tokio::fs::create_dir_all(parent)
            .await
            .map_err(|e| e.to_string())?;
    }
    tokio::fs::write(&path, &built.zip_bytes)
        .await
        .map_err(|e| e.to_string())?;

    Ok(Some(ExportResult {
        file_path: path.to_string_lossy().into_owned(),
        file_name: path
            .file_name()
            .map(|n| n.to_string_lossy().into_owned())
            .unwrap_or(built.file_name),
        warnings: built.warnings,
    }))
}
