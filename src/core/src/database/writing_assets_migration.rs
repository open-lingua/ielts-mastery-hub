use std::path::{Path, PathBuf};

use tauri::Manager;

use crate::database::asset_sync::AssetSyncOutcome;
use crate::database::Db;
use crate::error::AppError;

/// Resource-relative path (as configured in `tauri.conf.json`'s
/// `bundle.resources`) to the directory bundling seed images for Writing
/// Task 1 prompts, whose filenames (stem) are `writing_tasks.id` values.
///
/// Resolved at *runtime* via `tauri::Manager::path()`'s
/// `resolve(.., BaseDirectory::Resource)`, so it works both in dev (Tauri
/// resolves resources relative to the crate/source tree) and in a
/// distributed production bundle (resolved relative to the bundled app's
/// Resources directory) — see `sync_writing_assets_to_local_storage`.
const SEED_WRITING_ASSETS_RESOURCE_PATH: &str = "seeds/writing/writing-assets";

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
/// `$HOME/.imh/writing-assets/<task_id>/figure.<ext>` convention.
pub fn writing_asset_seed_dest_path(home: &str, task_id: &str, ext: &str) -> PathBuf {
    Path::new(home)
        .join(".imh")
        .join("writing-assets")
        .join(task_id)
        .join(format!("figure.{ext}"))
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
            b'A'..=b'Z'
            | b'a'..=b'z'
            | b'0'..=b'9'
            | b'-'
            | b'_'
            | b'.'
            | b'!'
            | b'~'
            | b'*'
            | b'\''
            | b'('
            | b')' => out.push(byte as char),
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
/// Individual per-file problems (a task subfolder with no `figure.<ext>`
/// file inside it, a `task_id` with no matching `writing_tasks` row, a
/// copy/IO error, or a failed `UPDATE`) are logged with `log::warn!`/`log::error!`
/// and skipped — they never abort the sync or block app startup. A missing
/// seed source directory is also non-fatal (see [`AssetSyncOutcome::SourceMissing`]):
/// it's logged loudly with `log::warn!` (including the exact resolved path) so it's
/// visible in both `tauri dev` and packaged-build logs, but never blocks startup,
/// since a build may legitimately ship without seed assets. Only a missing `$HOME`
/// is propagated as `Err`.
pub async fn sync_writing_assets_to_local_storage(
    pool: &Db,
    app_handle: &tauri::AppHandle,
) -> Result<AssetSyncOutcome, AppError> {
    let home = std::env::var("HOME")
        .map_err(|_| AppError::Validation("HOME environment variable is not set".to_string()))?;
    let source_dir = app_handle
        .path()
        .resolve(
            SEED_WRITING_ASSETS_RESOURCE_PATH,
            tauri::path::BaseDirectory::Resource,
        )
        .map_err(|e| {
            AppError::Validation(format!(
                "failed to resolve writing asset seed resource directory {SEED_WRITING_ASSETS_RESOURCE_PATH}: {e}"
            ))
        })?;

    let source_exists = tokio::fs::metadata(&source_dir).await.is_ok();
    log::info!(
        "[sync_writing_assets_to_local_storage] resolved seed source directory to {} (exists: {source_exists})",
        source_dir.display()
    );

    let outcome = sync_writing_assets_from_dir(pool, &source_dir, &home).await?;
    if let AssetSyncOutcome::SourceMissing { source_dir } = &outcome {
        log::warn!(
            "[sync_writing_assets_to_local_storage] seed source directory {} does not exist; no writing task images were copied. \
             If this is unexpected (e.g. not an intentionally asset-free build), check `bundle.resources` in tauri.conf.json \
             and how resources are resolved in this environment.",
            source_dir.display()
        );
    }
    Ok(outcome)
}

/// Internal implementation of [`sync_writing_assets_to_local_storage`],
/// parameterized on the source directory and home directory so it can be
/// exercised end-to-end in tests without touching the real seed assets or
/// `$HOME`. `pub` (rather than crate-private) solely so integration tests in
/// `tests/database/writing_assets_migration_test.rs` can call it directly.
///
/// A missing `source_dir` is not fatal: it's reported via
/// `Ok(AssetSyncOutcome::SourceMissing { .. })` rather than `Err`, mirroring
/// `listening_assets_migration::sync_listening_assets_from_dir` — there may
/// legitimately be no bundled Writing seed assets to sync (e.g. an
/// assets-free build, or a `tauri dev` environment where resources aren't
/// laid out the same way as in a packaged app).
pub async fn sync_writing_assets_from_dir(
    pool: &Db,
    source_dir: &Path,
    home: &str,
) -> Result<AssetSyncOutcome, AppError> {
    if tokio::fs::metadata(source_dir).await.is_err() {
        return Ok(AssetSyncOutcome::SourceMissing {
            source_dir: source_dir.to_path_buf(),
        });
    }

    let mut entries = tokio::fs::read_dir(source_dir).await.map_err(|e| {
        AppError::Validation(format!(
            "failed to read writing asset seed directory {}: {e}",
            source_dir.display()
        ))
    })?;

    let mut copied = 0usize;

    loop {
        let entry = match entries.next_entry().await {
            Ok(Some(entry)) => entry,
            Ok(None) => break,
            Err(e) => {
                log::warn!(
                    "[sync_writing_assets_to_local_storage] failed to read a directory entry: {e}"
                );
                continue;
            }
        };

        // Each seed asset lives in a `<task_id>/` subfolder containing a
        // single `figure.<ext>` file; skip anything else (e.g. stray files).
        let task_dir = entry.path();
        if !task_dir.is_dir() {
            continue;
        }
        let Some(task_id) = task_dir.file_name().and_then(|n| n.to_str()) else {
            log::warn!(
                "[sync_writing_assets_to_local_storage] skipping non-UTF-8 directory name at {}",
                task_dir.display()
            );
            continue;
        };
        let task_id = task_id.to_string();

        let figure_path = match find_figure_file(&task_dir).await {
            Ok(Some(path)) => path,
            Ok(None) => {
                log::warn!(
                    "[sync_writing_assets_to_local_storage] no figure.<ext> file found in {}, skipping",
                    task_dir.display()
                );
                continue;
            }
            Err(e) => {
                log::warn!(
                    "[sync_writing_assets_to_local_storage] failed to read task asset directory {}: {e}",
                    task_dir.display()
                );
                continue;
            }
        };

        let Some(file_name) = figure_path.file_name().and_then(|n| n.to_str()) else {
            log::warn!(
                "[sync_writing_assets_to_local_storage] skipping non-UTF-8 file name at {}",
                figure_path.display()
            );
            continue;
        };
        let Some((_, ext)) = split_task_id_and_ext(file_name) else {
            log::warn!(
                "[sync_writing_assets_to_local_storage] could not parse an extension from filename `{file_name}`, skipping"
            );
            continue;
        };

        let dest = writing_asset_seed_dest_path(home, &task_id, ext);

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
                log::warn!(
                    "[sync_writing_assets_to_local_storage] seed writing asset {task_id} has no matching writing_tasks row, skipping"
                );
                continue;
            }
            Err(e) => {
                log::warn!(
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
                log::warn!(
                    "[sync_writing_assets_to_local_storage] failed to create directory {}: {e}",
                    parent.display()
                );
                continue;
            }
        }

        let bytes = match tokio::fs::read(&figure_path).await {
            Ok(bytes) => bytes,
            Err(e) => {
                log::warn!(
                    "[sync_writing_assets_to_local_storage] failed to read seed asset {}: {e}",
                    figure_path.display()
                );
                continue;
            }
        };

        if let Err(e) = tokio::fs::write(&dest, bytes).await {
            log::warn!(
                "[sync_writing_assets_to_local_storage] failed to write {}: {e}",
                dest.display()
            );
            continue;
        }
        copied += 1;

        if let Err(e) = sqlx::query!(
            "UPDATE writing_tasks SET image_url = ? WHERE id = ?",
            asset_url,
            task_id
        )
        .execute(pool)
        .await
        {
            log::error!(
                "[sync_writing_assets_to_local_storage] failed to update image_url for writing_tasks {task_id}: {e}"
            );
        }
    }

    log::info!(
        "[sync_writing_assets_to_local_storage] copied {copied} writing task image(s) from {}",
        source_dir.display()
    );
    Ok(AssetSyncOutcome::Synced { copied })
}

/// Looks inside a `<task_id>/` seed asset subfolder for its `figure.<ext>`
/// file, returning `Ok(None)` if the directory has no such file. Only the
/// stem (`figure`) is required to match; any extension is accepted so the
/// caller can derive it via [`split_task_id_and_ext`]. If more than one
/// `figure.*` file is present, the first one found is used.
async fn find_figure_file(task_dir: &Path) -> std::io::Result<Option<PathBuf>> {
    let mut entries = tokio::fs::read_dir(task_dir).await?;
    while let Some(entry) = entries.next_entry().await? {
        let path = entry.path();
        if !path.is_file() {
            continue;
        }
        if path.file_stem().and_then(|s| s.to_str()) == Some("figure") {
            return Ok(Some(path));
        }
    }
    Ok(None)
}
