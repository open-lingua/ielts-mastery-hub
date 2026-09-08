use std::path::Path;

use crate::database::Db;
use crate::error::AppError;

/// Old, pre-rename directory name for imported Listening test audio assets
/// (superseded by `NEW_DIR_NAME` — see module docs on
/// [`migrate_listening_assets_dir`]).
const OLD_DIR_NAME: &str = "listening-tests";

/// Current directory name for imported Listening test audio assets,
/// mirroring `services::import_service::build_listening_assets_dir`'s
/// `$HOME/.imh/listening-assets/<test_id>/` convention.
const NEW_DIR_NAME: &str = "listening-assets";

/// One-time startup migration: renames the legacy
/// `$HOME/.imh/listening-tests/` directory (used by early versions of the
/// Listening JSON import feature) to `$HOME/.imh/listening-assets/`, and
/// fixes up any `listening_sections.audio_url` rows that still hold an
/// absolute path under the old location.
///
/// See [`migrate_listening_assets_dir`] for the injectable-parameters
/// implementation and full idempotency details.
pub async fn migrate_listening_assets_dir_to_local_storage(pool: &Db) -> Result<(), AppError> {
    let home = std::env::var("HOME").map_err(|_| {
        AppError::Validation("HOME environment variable is not set".to_string())
    })?;
    migrate_listening_assets_dir(pool, &home).await
}

/// Internal implementation of
/// [`migrate_listening_assets_dir_to_local_storage`], parameterized on the
/// home directory so it can be exercised end-to-end in tests without
/// touching the real `$HOME`. `pub` (rather than crate-private) solely so
/// integration tests in `tests/database/listening_assets_migration_test.rs`
/// can call it directly.
///
/// Two independent, idempotent steps:
/// 1. If the old directory exists and the new one doesn't, rename the whole
///    tree in one atomic move. Never overwrites/clobbers an existing new
///    directory. A failure here is logged (`eprintln!`) and does not abort
///    startup or step 2.
/// 2. Regardless of whether step 1 ran this time, rewrite any
///    `listening_sections.audio_url` value that still starts with the old
///    directory's absolute path so it points at the new one instead. This
///    is a plain string prefix replace via SQL, safe to run on every
///    startup: once no row matches the old prefix, it's a cheap no-op. This
///    also self-heals the case where the directory was already renamed (by
///    a previous run, or externally) but the DB was never updated.
pub async fn migrate_listening_assets_dir(pool: &Db, home: &str) -> Result<(), AppError> {
    let old_dir = Path::new(home).join(".imh").join(OLD_DIR_NAME);
    let new_dir = Path::new(home).join(".imh").join(NEW_DIR_NAME);

    let old_exists = tokio::fs::metadata(&old_dir).await.is_ok();
    let new_exists = tokio::fs::metadata(&new_dir).await.is_ok();

    if old_exists && !new_exists {
        if let Err(e) = tokio::fs::rename(&old_dir, &new_dir).await {
            eprintln!(
                "[migrate_listening_assets_dir] failed to rename {} to {}: {e}",
                old_dir.display(),
                new_dir.display()
            );
        }
    }

    let old_prefix = old_dir.to_string_lossy().into_owned();
    let new_prefix = new_dir.to_string_lossy().into_owned();
    let like_pattern = format!("{old_prefix}%");

    if let Err(e) = sqlx::query!(
        "UPDATE listening_sections SET audio_url = REPLACE(audio_url, ?, ?) WHERE audio_url LIKE ?",
        old_prefix,
        new_prefix,
        like_pattern
    )
    .execute(pool)
    .await
    {
        eprintln!("[migrate_listening_assets_dir] failed to update audio_url paths: {e}");
    }

    Ok(())
}
