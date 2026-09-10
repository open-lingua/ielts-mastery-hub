use std::path::PathBuf;

use sqlx::sqlite::SqlitePoolOptions;

use crate::error::AppError;

pub mod asset_sync;
pub mod listening_assets_migration;
pub mod seed_data;
pub mod writing_assets_migration;

pub type Db = sqlx::SqlitePool;

/// Bundle identifier used to namespace the app's data directory, matching
/// `identifier` in `tauri.conf.json`.
pub const APP_IDENTIFIER: &str = "com.openlingua.ieltsmasteryhub";

/// Resolves the SQLite connection URL to use at runtime.
///
/// If `DATABASE_URL` is set in the environment, it is returned verbatim
/// (trusted as-is, matching the standard `sqlx` convention). Otherwise, a
/// default path is derived per OS using only `std::env`:
///
/// - macOS: `$HOME/Library/Application Support/<identifier>/imh.db`
/// - Linux: `$HOME/.local/share/<identifier>/imh.db`
/// - Windows: `%APPDATA%\<identifier>\imh.db`
pub fn resolve_database_url() -> Result<String, AppError> {
    if let Ok(url) = std::env::var("DATABASE_URL") {
        if !url.is_empty() {
            return Ok(url);
        }
    }

    let db_path = default_db_path(std::env::consts::OS)?;
    Ok(format!("sqlite://{}?mode=rwc", db_path.to_string_lossy()))
}

/// Builds the default database file path for the given OS identifier
/// (as returned by `std::env::consts::OS`), reading the appropriate
/// home/user directory environment variable.
pub fn default_db_path(os: &str) -> Result<PathBuf, AppError> {
    match os {
        "macos" => {
            let home = std::env::var("HOME").map_err(|_| {
                AppError::Validation("HOME environment variable is not set".to_string())
            })?;
            Ok(PathBuf::from(home)
                .join("Library")
                .join("Application Support")
                .join(APP_IDENTIFIER)
                .join("imh.db"))
        }
        "windows" => {
            let app_data = std::env::var("APPDATA").map_err(|_| {
                AppError::Validation("APPDATA environment variable is not set".to_string())
            })?;
            Ok(PathBuf::from(app_data).join(APP_IDENTIFIER).join("imh.db"))
        }
        _ => {
            // Linux and other Unix-like platforms.
            let home = std::env::var("HOME").map_err(|_| {
                AppError::Validation("HOME environment variable is not set".to_string())
            })?;
            Ok(PathBuf::from(home)
                .join(".local")
                .join("share")
                .join(APP_IDENTIFIER)
                .join("imh.db"))
        }
    }
}

/// Extracts the filesystem path from a `sqlite://...` connection URL (stripping any
/// trailing `?mode=...` query string). Shared by [`init`] and by callers that need the
/// database's directory without opening a connection (e.g. to locate sibling files like
/// the AI credentials encryption key).
pub fn resolve_db_path(db_url: &str) -> PathBuf {
    let db_path = db_url
        .strip_prefix("sqlite://")
        .and_then(|s| s.split('?').next())
        .unwrap_or(db_url);
    PathBuf::from(db_path)
}

pub async fn init(app_handle: &tauri::AppHandle) -> Result<Db, AppError> {
    let db_url = resolve_database_url()?;
    let db_path = resolve_db_path(&db_url);
    if let Some(parent) = db_path.parent() {
        std::fs::create_dir_all(parent).map_err(|e| AppError::Validation(e.to_string()))?;
    }
    let pool = SqlitePoolOptions::new()
        .max_connections(5)
        .connect(&db_url)
        .await?;
    sqlx::query("PRAGMA journal_mode=WAL")
        .execute(&pool)
        .await?;
    sqlx::query("PRAGMA foreign_keys=ON").execute(&pool).await?;
    sqlx::migrate!("./src/database/migrations")
        .set_ignore_missing(true)
        .run(&pool)
        .await?;
    // Deliberately fail-fast on `run_seed_data` errors (via `?`): a failure there indicates a
    // broken database/SQL seed file, not merely a missing bundled asset, so it's treated as a
    // startup-blocking condition distinct from the two asset syncs below.
    seed_data::run_seed_data(&pool, app_handle).await?;
    // Both asset syncs are unconditional on every startup (no feature flag or early return
    // skips them) and are individually non-fatal: a missing seed source directory is logged
    // loudly via `log::warn!` (see each module's docs) but never blocks startup, since a build
    // may legitimately ship without bundled seed assets.
    writing_assets_migration::sync_writing_assets_to_local_storage(&pool, app_handle).await?;
    listening_assets_migration::sync_listening_assets_to_local_storage(&pool, app_handle).await?;
    Ok(pool)
}
