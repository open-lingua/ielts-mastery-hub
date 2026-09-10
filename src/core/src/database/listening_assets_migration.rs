use std::path::{Path, PathBuf};

use tauri::Manager;

use crate::database::Db;
use crate::error::AppError;

/// Directory name for imported Listening test audio assets under
/// `$HOME/.imh/`, mirroring
/// `services::import_service::build_listening_assets_dir`'s
/// `$HOME/.imh/listening-assets/<test_id>/` convention.
pub const LISTENING_ASSETS_DIR_NAME: &str = "listening-assets";

/// Resource-relative path (as configured in `tauri.conf.json`'s
/// `bundle.resources`) to the directory bundling seed Listening test
/// assets, keyed by `<test_id>/` subfolder (currently `tts-config/*.json`
/// files and, once generated, `section-<N>.mp3` audio files).
///
/// Resolved at *runtime* via `tauri::Manager::path()`'s
/// `resolve(.., BaseDirectory::Resource)`, mirroring
/// `writing_assets_migration::SEED_WRITING_ASSETS_RESOURCE_PATH` — see that
/// module's docs for why this must be resolved at runtime rather than baked
/// in at compile time.
const SEED_LISTENING_ASSETS_RESOURCE_PATH: &str = "seeds/listening/listening-assets";

/// Copies bundled seed Listening test assets (`SEED_LISTENING_ASSETS_DIR`)
/// into the user's local `$HOME/.imh/listening-assets/` storage, backfilling
/// each matching `listening_sections.audio_url` to point at a freshly-copied
/// `section-<N>.mp3` file.
///
/// Purely additive/non-destructive: only files missing from the
/// destination are copied over; anything already present under
/// `$HOME/.imh/listening-assets/` (whether seeded previously or created by
/// the user/app) is left untouched, and `audio_url` is only ever backfilled
/// — never overwritten once set. Individual per-entry problems (an
/// unreadable subdirectory, an unreadable file, a failed copy, a failed
/// `audio_url` update) are logged with `eprintln!` and skipped — they never
/// abort the sync or block app startup. Only a missing `$HOME` is
/// propagated as `Err`.
pub async fn sync_listening_assets_to_local_storage(
    pool: &Db,
    app_handle: &tauri::AppHandle,
) -> Result<(), AppError> {
    let home = std::env::var("HOME")
        .map_err(|_| AppError::Validation("HOME environment variable is not set".to_string()))?;
    let dest_root = Path::new(&home)
        .join(".imh")
        .join(LISTENING_ASSETS_DIR_NAME);
    let source_dir = app_handle
        .path()
        .resolve(
            SEED_LISTENING_ASSETS_RESOURCE_PATH,
            tauri::path::BaseDirectory::Resource,
        )
        .map_err(|e| {
            AppError::Validation(format!(
                "failed to resolve listening asset seed resource directory {SEED_LISTENING_ASSETS_RESOURCE_PATH}: {e}"
            ))
        })?;
    sync_listening_assets_from_dir(pool, &source_dir, &dest_root).await
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
///
/// Each immediate subdirectory of `source_dir` is treated as a `<test_id>/`
/// folder (mirroring `writing_assets_migration`'s per-`<task_id>/` seed
/// layout): its contents are copied additively into
/// `dest_root/<test_id>/`, and every freshly-copied file named
/// `section-<N>.<ext>` backfills the `audio_url` of the
/// `listening_sections` row where `test_id = <test_id> AND section_number = N`,
/// provided that row's `audio_url` is still empty/unset.
pub async fn sync_listening_assets_from_dir(
    pool: &Db,
    source_dir: &Path,
    dest_root: &Path,
) -> Result<(), AppError> {
    if tokio::fs::metadata(source_dir).await.is_err() {
        return Ok(());
    }

    let mut entries = match tokio::fs::read_dir(source_dir).await {
        Ok(entries) => entries,
        Err(e) => {
            eprintln!(
                "[sync_listening_assets_to_local_storage] failed to read seed directory {}: {e}",
                source_dir.display()
            );
            return Ok(());
        }
    };

    loop {
        let entry = match entries.next_entry().await {
            Ok(Some(entry)) => entry,
            Ok(None) => break,
            Err(e) => {
                eprintln!(
                    "[sync_listening_assets_to_local_storage] failed to read a directory entry in {}: {e}",
                    source_dir.display()
                );
                continue;
            }
        };

        // Each seed test's assets live in a `<test_id>/` subfolder; skip
        // anything else (e.g. stray files at the seed root).
        let test_source_dir = entry.path();
        if !test_source_dir.is_dir() {
            continue;
        }
        let Some(test_id) = test_source_dir.file_name().and_then(|n| n.to_str()) else {
            eprintln!(
                "[sync_listening_assets_to_local_storage] skipping non-UTF-8 directory name at {}",
                test_source_dir.display()
            );
            continue;
        };
        let test_id = test_id.to_string();

        let test_dest_dir = dest_root.join(&test_id);
        let copied_files = copy_dir_additive(&test_source_dir, &test_dest_dir).await;

        for dest_file in copied_files {
            let Some(file_name) = dest_file.file_name().and_then(|n| n.to_str()) else {
                continue;
            };
            let Some(section_number) = section_number_from_file_name(file_name) else {
                continue;
            };

            let audio_url = dest_file.to_string_lossy().into_owned();

            if let Err(e) = sqlx::query!(
                "UPDATE listening_sections SET audio_url = ? \
                 WHERE test_id = ? AND section_number = ? AND (audio_url IS NULL OR audio_url = '')",
                audio_url,
                test_id,
                section_number
            )
            .execute(pool)
            .await
            {
                eprintln!(
                    "[sync_listening_assets_to_local_storage] failed to update audio_url for test {test_id} section {section_number}: {e}"
                );
            }
        }
    }

    Ok(())
}

/// Parses a seed audio filename's section number, requiring the file
/// *stem* (name without its final extension) to be exactly
/// `section-<digits>` — e.g. `section-2.mp3` -> `Some(2)`. Anything else
/// (including `section-1-tts-config.json`, whose stem is
/// `section-1-tts-config`) returns `None`, since it doesn't correspond to
/// an audio file matching a `listening_sections.section_number`.
fn section_number_from_file_name(file_name: &str) -> Option<i64> {
    let stem = Path::new(file_name).file_stem()?.to_str()?;
    stem.strip_prefix("section-")?.parse::<i64>().ok()
}

/// Recursively copies every file under `source_root` into the mirrored
/// path under `dest_root`, creating destination directories as needed, but
/// **never overwriting a file that already exists** at the destination.
/// Walks the tree with an explicit stack (rather than async recursion) to
/// avoid `Box::pin` boilerplate for a self-referential `async fn`. Returns
/// the destination paths of every file it actually wrote (i.e. genuinely
/// new copies — pre-existing files that were skipped are not included).
///
/// Every per-entry failure (unreadable directory, unreadable file type,
/// failed read/write) is logged with `eprintln!`
/// (`[sync_listening_assets_to_local_storage]` prefix) and skipped; it
/// never aborts the overall walk.
async fn copy_dir_additive(source_root: &Path, dest_root: &Path) -> Vec<PathBuf> {
    let mut copied = Vec::new();
    let mut stack: Vec<(PathBuf, PathBuf)> =
        vec![(source_root.to_path_buf(), dest_root.to_path_buf())];

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

            if let Err(e) = tokio::fs::write(&dest_path, &bytes).await {
                eprintln!(
                    "[sync_listening_assets_to_local_storage] failed to write {}: {e}",
                    dest_path.display()
                );
                continue;
            }

            copied.push(dest_path);
        }
    }

    copied
}
