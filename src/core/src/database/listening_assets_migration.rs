use std::path::{Path, PathBuf};

use crate::database::Db;
use crate::error::AppError;

/// Directory name for imported Listening test audio assets under
/// `$HOME/.imh/`, mirroring
/// `services::import_service::build_listening_assets_dir`'s
/// `$HOME/.imh/listening-assets/<test_id>/` convention.
pub const LISTENING_ASSETS_DIR_NAME: &str = "listening-assets";

/// Directory bundling seed Listening test assets (currently per-test
/// `tts-config/*.json` files, keyed by `<test_id>/` subfolder). Resolved at
/// compile time relative to this crate, mirroring the crate-relative style
/// used by `writing_assets_migration::SEED_WRITING_ASSETS_DIR`.
///
/// Same caveat as `SEED_WRITING_ASSETS_DIR`: this only embeds the *path* to
/// the source tree, not its contents, so it only resolves correctly when
/// the running binary can still reach that path on disk (dev builds /
/// running from a repo checkout).
const SEED_LISTENING_ASSETS_DIR: &str =
    concat!(env!("CARGO_MANIFEST_DIR"), "/src/database/seeds/listening/listening-assets");

/// Copies bundled seed Listening test assets (`SEED_LISTENING_ASSETS_DIR`)
/// into the user's local `$HOME/.imh/listening-assets/` storage.
///
/// Unlike `writing_assets_migration::sync_writing_assets_to_local_storage`,
/// there is no `image_url`/`audio_url`-style database column to backfill
/// for these assets, so `pool` is currently unused — it's kept purely for
/// call-site parity with the writing-assets sync and to leave room for a
/// future DB-backed step.
///
/// Purely additive/non-destructive: only files missing from the
/// destination are copied over; anything already present under
/// `$HOME/.imh/listening-assets/` (whether seeded previously or created by
/// the user/app) is left untouched. Individual per-entry problems (an
/// unreadable subdirectory, an unreadable file, a failed copy) are logged
/// with `eprintln!` and skipped — they never abort the sync or block app
/// startup. Only a missing `$HOME` is propagated as `Err`.
pub async fn sync_listening_assets_to_local_storage(_pool: &Db) -> Result<(), AppError> {
    let home = std::env::var("HOME").map_err(|_| {
        AppError::Validation("HOME environment variable is not set".to_string())
    })?;
    let dest_root = Path::new(&home).join(".imh").join(LISTENING_ASSETS_DIR_NAME);
    sync_listening_assets_from_dir(Path::new(SEED_LISTENING_ASSETS_DIR), &dest_root).await
}

/// Internal implementation of [`sync_listening_assets_to_local_storage`],
/// parameterized on the seed source directory and local destination root so
/// it can be exercised end-to-end in tests without touching the real seed
/// assets or `$HOME`. `pub` (rather than crate-private) solely so
/// integration tests in
/// `tests/database/listening_assets_migration_test.rs` can call it
/// directly.
///
/// Unlike `writing_assets_migration::sync_writing_assets_from_dir` (which
/// treats a missing seed directory as a hard error), a missing
/// `source_dir` here is not fatal: it's skipped gracefully, returning
/// `Ok(())`, since there may legitimately be no bundled Listening seed
/// assets to sync.
pub async fn sync_listening_assets_from_dir(
    source_dir: &Path,
    dest_root: &Path,
) -> Result<(), AppError> {
    if tokio::fs::metadata(source_dir).await.is_err() {
        return Ok(());
    }
    copy_dir_additive(source_dir, dest_root).await;
    Ok(())
}

/// Recursively copies every file under `source_root` into the mirrored
/// path under `dest_root`, creating destination directories as needed, but
/// **never overwriting a file that already exists** at the destination.
/// Walks the tree with an explicit stack (rather than async recursion) to
/// avoid `Box::pin` boilerplate for a self-referential `async fn`.
///
/// Every per-entry failure (unreadable directory, unreadable file type,
/// failed read/write) is logged with `eprintln!`
/// (`[sync_listening_assets_to_local_storage]` prefix) and skipped; it
/// never aborts the overall walk.
async fn copy_dir_additive(source_root: &Path, dest_root: &Path) {
    let mut stack: Vec<(PathBuf, PathBuf)> = vec![(source_root.to_path_buf(), dest_root.to_path_buf())];

    while let Some((src_dir, dest_dir)) = stack.pop() {
        let mut entries = match tokio::fs::read_dir(&src_dir).await {
            Ok(entries) => entries,
            Err(e) => {
                eprintln!(
                    "[sync_listening_assets_to_local_storage] failed to read directory {}: {e}",
                    src_dir.display()
                );
                continue;
            }
        };

        loop {
            let entry = match entries.next_entry().await {
                Ok(Some(entry)) => entry,
                Ok(None) => break,
                Err(e) => {
                    eprintln!(
                        "[sync_listening_assets_to_local_storage] failed to read a directory entry in {}: {e}",
                        src_dir.display()
                    );
                    continue;
                }
            };

            let src_path = entry.path();
            let dest_path = dest_dir.join(entry.file_name());

            let file_type = match entry.file_type().await {
                Ok(file_type) => file_type,
                Err(e) => {
                    eprintln!(
                        "[sync_listening_assets_to_local_storage] failed to read file type for {}: {e}",
                        src_path.display()
                    );
                    continue;
                }
            };

            if file_type.is_dir() {
                stack.push((src_path, dest_path));
                continue;
            }

            if !file_type.is_file() {
                // Skip symlinks and any other non-regular-file entries.
                continue;
            }

            // Non-destructive: never touch a file that already exists at
            // the destination (whether seeded previously or written by the
            // app/user since).
            if tokio::fs::metadata(&dest_path).await.is_ok() {
                continue;
            }

            if let Err(e) = tokio::fs::create_dir_all(&dest_dir).await {
                eprintln!(
                    "[sync_listening_assets_to_local_storage] failed to create directory {}: {e}",
                    dest_dir.display()
                );
                continue;
            }

            let bytes = match tokio::fs::read(&src_path).await {
                Ok(bytes) => bytes,
                Err(e) => {
                    eprintln!(
                        "[sync_listening_assets_to_local_storage] failed to read seed asset {}: {e}",
                        src_path.display()
                    );
                    continue;
                }
            };

            if let Err(e) = tokio::fs::write(&dest_path, bytes).await {
                eprintln!(
                    "[sync_listening_assets_to_local_storage] failed to write {}: {e}",
                    dest_path.display()
                );
            }
        }
    }
}
