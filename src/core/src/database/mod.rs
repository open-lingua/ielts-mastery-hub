use std::path::{Path, PathBuf};

use sqlx::sqlite::SqlitePoolOptions;

use crate::error::AppError;

pub type Db = sqlx::SqlitePool;

/// Bundle identifier used to namespace the app's data directory, matching
/// `identifier` in `tauri.conf.json`.
pub const APP_IDENTIFIER: &str = "com.openlingua.ieltsmasteryhub";

/// Directory bundling seed images for Writing Task 1 prompts, whose
/// filenames (stem) are `writing_tasks.id` values. Resolved at compile time
/// relative to this crate, mirroring the crate-relative style used by
/// `sqlx::migrate!("./src/database/seeds")` above.
///
/// Caveat: unlike `sqlx::migrate!` (which embeds file *contents* into the
/// binary at compile time), this only embeds the *path* to the source tree.
/// It only resolves correctly when the running binary can still reach that
/// path on disk (e.g. dev builds / running from a repo checkout) — a
/// distributed production bundle would need a different mechanism (e.g.
/// Tauri bundled resources or `include_bytes!` via a build script).
const SEED_WRITING_ASSETS_DIR: &str =
    concat!(env!("CARGO_MANIFEST_DIR"), "/src/database/seeds/writing/writing-assets");

/// Resolves the SQLite connection URL to use at runtime.
///
/// If `DATABASE_URL` is set in the environment, it is returned verbatim
/// (trusted as-is, matching the standard `sqlx` convention). Otherwise, a
/// default path is derived per OS using only `std::env`:
///
/// - macOS: `$HOME/Library/Application Support/<identifier>/ielts.db`
/// - Linux: `$HOME/.local/share/<identifier>/ielts.db`
/// - Windows: `%APPDATA%\<identifier>\ielts.db`
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
                .join("ielts.db"))
        }
        "windows" => {
            let app_data = std::env::var("APPDATA").map_err(|_| {
                AppError::Validation("APPDATA environment variable is not set".to_string())
            })?;
            Ok(PathBuf::from(app_data)
                .join(APP_IDENTIFIER)
                .join("ielts.db"))
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
                .join("ielts.db"))
        }
    }
}

pub async fn init(_app_handle: &tauri::AppHandle) -> Result<Db, AppError> {
    let db_url = resolve_database_url()?;
    let db_path = db_url
        .strip_prefix("sqlite://")
        .and_then(|s| s.split('?').next())
        .unwrap_or(&db_url);
    if let Some(parent) = std::path::Path::new(db_path).parent() {
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
    sqlx::migrate!("./src/database/seeds")
        .set_ignore_missing(true)
        .run(&pool)
        .await?;
    sync_writing_assets_to_local_storage(&pool).await?;
    Ok(pool)
}

/// Splits a seed asset filename (e.g. `"<uuid>.jpeg"`) into its
/// `(task_id, ext)` stem/extension pair, splitting on the last `.`. Returns
/// `None` when the filename has no extension.
pub fn split_task_id_and_ext(file_name: &str) -> Option<(&str, &str)> {
    let dot_index = file_name.rfind('.')?;
    if dot_index == 0 || dot_index == file_name.len() - 1 {
        return None;
    }
    Some((&file_name[..dot_index], &file_name[dot_index + 1..]))
}

/// Builds the local-storage destination path for a writing asset,
/// mirroring `commands::storage::upload_writing_asset`'s
/// `$HOME/.imh/writing-assets/<task_id>.<ext>` convention.
pub fn writing_asset_seed_dest_path(home: &str, task_id: &str, ext: &str) -> PathBuf {
    Path::new(home)
        .join(".imh")
        .join("writing-assets")
        .join(format!("{task_id}.{ext}"))
}

/// Percent-encodes a string exactly like JavaScript's `encodeURIComponent`:
/// every byte is escaped as `%XX` (uppercase hex) except ASCII letters,
/// digits, and the literal characters `- _ . ! ~ * ' ( )`. This must match
/// `@tauri-apps/api`'s `convertFileSrc` (see `tauri`'s bundled
/// `scripts/core.js`, which calls `encodeURIComponent(filePath)`) so the
/// frontend and this startup sync agree on `writing_tasks.image_url`.
fn encode_uri_component(input: &str) -> String {
    let mut out = String::with_capacity(input.len());
    for byte in input.bytes() {
        match byte {
            b'A'..=b'Z' | b'a'..=b'z' | b'0'..=b'9' | b'-' | b'_' | b'.' | b'!' | b'~' | b'*'
            | b'\'' | b'(' | b')' => out.push(byte as char),
            _ => out.push_str(&format!("%{byte:02X}")),
        }
    }
    out
}

/// Builds the Tauri asset-protocol URL for a local file path, matching what
/// the frontend's `convertFileSrc(path)` (from `@tauri-apps/api/core`, used
/// in `src/ui/lib/tauri.ts`) produces on macOS/Linux:
/// `asset://localhost/<url-encoded-absolute-path>`.
pub fn to_asset_url(path: &Path) -> String {
    format!(
        "asset://localhost/{}",
        encode_uri_component(&path.to_string_lossy())
    )
}

/// Copies bundled seed images for Writing Task 1 prompts
/// (`SEED_WRITING_ASSETS_DIR`) into the user's local
/// `$HOME/.imh/writing-assets/` storage, backfilling each matching
/// `writing_tasks.image_url` to point at the copied file.
///
/// Idempotent: a task is skipped entirely once its destination file already
/// exists on disk, so re-running this on every app startup is a cheap no-op
/// once assets are seeded, and it never clobbers an `image_url` a user has
/// since intentionally changed away from the seeded value.
///
/// Individual per-file problems (an asset filename that doesn't parse, a
/// `task_id` with no matching `writing_tasks` row, a copy/IO error, or a
/// failed `UPDATE`) are logged with `eprintln!` and skipped — they never
/// abort the sync or block app startup. Only a failure to read the seed
/// directory itself, or a missing `$HOME`, is propagated as `Err`
pub async fn sync_writing_assets_to_local_storage(pool: &Db) -> Result<(), AppError> {
    let home = std::env::var("HOME").map_err(|_| {
        AppError::Validation("HOME environment variable is not set".to_string())
    })?;
    sync_writing_assets_from_dir(pool, Path::new(SEED_WRITING_ASSETS_DIR), &home).await
}

/// Internal implementation of [`sync_writing_assets_to_local_storage`],
/// parameterized on the source directory and home directory so it can be
/// exercised end-to-end in tests without touching the real seed assets or
/// `$HOME`. `pub` (rather than crate-private) solely so integration tests in
/// `tests/database/mod_test.rs` can call it directly.
pub async fn sync_writing_assets_from_dir(
    pool: &Db,
    source_dir: &Path,
    home: &str,
) -> Result<(), AppError> {
    let mut entries = tokio::fs::read_dir(source_dir).await.map_err(|e| {
        AppError::Validation(format!(
            "failed to read writing asset seed directory {}: {e}",
            source_dir.display()
        ))
    })?;

    loop {
        let entry = match entries.next_entry().await {
            Ok(Some(entry)) => entry,
            Ok(None) => break,
            Err(e) => {
                eprintln!("[sync_writing_assets_to_local_storage] failed to read a directory entry: {e}");
                continue;
            }
        };

        let path = entry.path();
        if !path.is_file() {
            continue;
        }
        let Some(file_name) = path.file_name().and_then(|n| n.to_str()) else {
            eprintln!(
                "[sync_writing_assets_to_local_storage] skipping non-UTF-8 file name at {}",
                path.display()
            );
            continue;
        };

        let Some((task_id, ext)) = split_task_id_and_ext(file_name) else {
            eprintln!(
                "[sync_writing_assets_to_local_storage] could not parse a task id from filename `{file_name}`, skipping"
            );
            continue;
        };

        let dest = writing_asset_seed_dest_path(home, task_id, ext);

        // Idempotent skip: once the file exists at its destination, never
        // touch this task again (also protects a user-edited `image_url`).
        if tokio::fs::metadata(&dest).await.is_ok() {
            continue;
        }

        let asset_url = to_asset_url(&dest);

        let existing_image_url: Option<String> = match sqlx::query_scalar!(
            "SELECT image_url FROM writing_tasks WHERE id = ?",
            task_id
        )
        .fetch_optional(pool)
        .await
        {
            Ok(Some(row)) => row,
            Ok(None) => {
                eprintln!(
                    "[sync_writing_assets_to_local_storage] seed writing asset {task_id} has no matching writing_tasks row, skipping"
                );
                continue;
            }
            Err(e) => {
                eprintln!(
                    "[sync_writing_assets_to_local_storage] failed to look up writing_tasks row {task_id}: {e}"
                );
                continue;
            }
        };

        if existing_image_url.as_deref() == Some(asset_url.as_str()) {
            continue;
        }

        if let Some(parent) = dest.parent() {
            if let Err(e) = tokio::fs::create_dir_all(parent).await {
                eprintln!(
                    "[sync_writing_assets_to_local_storage] failed to create directory {}: {e}",
                    parent.display()
                );
                continue;
            }
        }

        let bytes = match tokio::fs::read(&path).await {
            Ok(bytes) => bytes,
            Err(e) => {
                eprintln!(
                    "[sync_writing_assets_to_local_storage] failed to read seed asset {}: {e}",
                    path.display()
                );
                continue;
            }
        };

        if let Err(e) = tokio::fs::write(&dest, bytes).await {
            eprintln!(
                "[sync_writing_assets_to_local_storage] failed to write {}: {e}",
                dest.display()
            );
            continue;
        }

        if let Err(e) = sqlx::query!(
            "UPDATE writing_tasks SET image_url = ? WHERE id = ?",
            asset_url,
            task_id
        )
        .execute(pool)
        .await
        {
            eprintln!(
                "[sync_writing_assets_to_local_storage] failed to update image_url for writing_tasks {task_id}: {e}"
            );
        }
    }

    Ok(())
}
