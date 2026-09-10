use std::collections::hash_map::DefaultHasher;
use std::hash::{Hash, Hasher};
use std::path::Path;

use tauri::Manager;

use crate::database::Db;
use crate::error::AppError;

// Note: seed application tracking uses a dedicated `_imh_applied_seeds`
// table, keyed by a stable `<module>/<file name>` identifier plus a
// content checksum.
//
// Deliberately **not** `_sqlx_migrations` (the table `sqlx::migrate!`
// uses for schema migrations): seed data is applied independently of
// schema migrations, with its own tracking, so the two can never collide
// on version numbers or be applied out of order relative to each other.

/// Resource-relative paths (as configured in `tauri.conf.json`'s
/// `bundle.resources`) to the directories bundling seed `.sql` files for
/// each module, keyed by a short module name used as the tracking-table
/// identifier prefix (e.g. `reading/ielts_reading_...sql`).
///
/// Resolved at *runtime* via `tauri::Manager::path()`'s `resolve(..,
/// BaseDirectory::Resource)`, mirroring
/// `listening_assets_migration`/`writing_assets_migration`'s resource
/// resolution — see those modules' docs for why this must happen at
/// runtime rather than compile time.
const SEED_SQL_RESOURCE_DIRS: [(&str, &str); 3] = [
    ("reading", "seeds/reading"),
    ("listening", "seeds/listening"),
    ("writing", "seeds/writing"),
];

/// Applies every not-yet-applied seed `.sql` file bundled under
/// `seeds/reading`, `seeds/listening`, and `seeds/writing` to `pool`.
///
/// Unlike schema migrations, seed files are **not** run through
/// `sqlx::migrate!`: that macro's directory resolver only scans the
/// immediate files of the given directory (it does not recurse), so
/// pointing it at `./src/database/seeds` (whose `.sql` files all live one
/// level down, under per-module subfolders) always resolved to zero
/// migrations and silently applied nothing. This function walks each
/// module's resource directory directly instead, tracking what's been
/// applied in `_imh_applied_seeds`.
pub async fn run_seed_data(pool: &Db, app_handle: &tauri::AppHandle) -> Result<(), AppError> {
    let mut dirs = Vec::with_capacity(SEED_SQL_RESOURCE_DIRS.len());
    for (module, resource_path) in SEED_SQL_RESOURCE_DIRS {
        let dir = app_handle
            .path()
            .resolve(resource_path, tauri::path::BaseDirectory::Resource)
            .map_err(|e| {
                AppError::Validation(format!(
                    "failed to resolve seed resource directory {resource_path}: {e}"
                ))
            })?;
        dirs.push((module, dir));
    }

    let dir_refs: Vec<(&str, &Path)> = dirs.iter().map(|(m, p)| (*m, p.as_path())).collect();
    run_seed_data_from_dirs(pool, &dir_refs).await
}

/// Internal implementation of [`run_seed_data`], parameterized on the
/// already-resolved `(module, directory)` pairs so it can be exercised in
/// tests without a real `tauri::AppHandle`. `pub` (rather than
/// crate-private) solely so integration tests in
/// `tests/database/seed_data_test.rs` can call it directly, including
/// against the real bundled `src/database/seeds/*` directories.
pub async fn run_seed_data_from_dirs(pool: &Db, dirs: &[(&str, &Path)]) -> Result<(), AppError> {
    ensure_tracking_table(pool).await?;

    for (module, dir) in dirs {
        if tokio::fs::metadata(dir).await.is_err() {
            // No bundled seed directory for this module; nothing to do.
            continue;
        }

        let mut file_names = Vec::new();
        let mut entries = tokio::fs::read_dir(dir).await.map_err(|e| {
            AppError::Validation(format!(
                "failed to read seed directory {}: {e}",
                dir.display()
            ))
        })?;
        while let Some(entry) = entries.next_entry().await.map_err(|e| {
            AppError::Validation(format!(
                "failed to read a directory entry in {}: {e}",
                dir.display()
            ))
        })? {
            let path = entry.path();
            if path.is_file() && path.extension().and_then(|e| e.to_str()) == Some("sql") {
                file_names.push(path);
            }
        }
        // Deterministic application order.
        file_names.sort();

        for file_path in file_names {
            apply_seed_file(pool, module, &file_path).await?;
        }
    }

    Ok(())
}

async fn ensure_tracking_table(pool: &Db) -> Result<(), AppError> {
    sqlx::raw_sql(
        "CREATE TABLE IF NOT EXISTS _imh_applied_seeds (
            path TEXT PRIMARY KEY NOT NULL,
            checksum TEXT NOT NULL,
            applied_at TEXT NOT NULL DEFAULT (datetime('now'))
        )",
    )
    .execute(pool)
    .await?;
    Ok(())
}

async fn apply_seed_file(pool: &Db, module: &str, file_path: &Path) -> Result<(), AppError> {
    let file_name = file_path
        .file_name()
        .and_then(|n| n.to_str())
        .ok_or_else(|| {
            AppError::Validation(format!(
                "seed file has a non-UTF-8 name: {}",
                file_path.display()
            ))
        })?;
    let key = format!("{module}/{file_name}");

    let sql = tokio::fs::read_to_string(file_path).await.map_err(|e| {
        AppError::Validation(format!(
            "failed to read seed file {}: {e}",
            file_path.display()
        ))
    })?;
    let checksum = checksum_of(&sql);

    let existing: Option<String> =
        sqlx::query_scalar("SELECT checksum FROM _imh_applied_seeds WHERE path = ?")
            .bind(&key)
            .fetch_optional(pool)
            .await?;

    match existing {
        Some(applied_checksum) if applied_checksum == checksum => {
            // Already applied, unchanged since. Nothing to do.
            return Ok(());
        }
        Some(_) => {
            // Already applied, but the file's contents changed afterwards.
            // Seeds are immutable once applied (same semantics as schema
            // migrations): warn, but never silently re-run a file that may
            // have already mutated user/local data.
            eprintln!(
                "[seed_data] seed file {key} has changed since it was applied; skipping re-application (seeds are immutable once applied)"
            );
            return Ok(());
        }
        None => {}
    }

    let mut tx = pool.begin().await.map_err(|e| {
        eprintln!("[seed_data] failed to begin transaction for seed {key}: {e}");
        e
    })?;

    sqlx::raw_sql(sqlx::AssertSqlSafe(sql.as_str()))
        .execute(&mut *tx)
        .await
        .map_err(|e| {
            eprintln!("[seed_data] failed to apply seed {key}: {e}");
            e
        })?;

    sqlx::query("INSERT INTO _imh_applied_seeds (path, checksum) VALUES (?, ?)")
        .bind(&key)
        .bind(&checksum)
        .execute(&mut *tx)
        .await
        .map_err(|e| {
            eprintln!("[seed_data] failed to record applied seed {key}: {e}");
            e
        })?;

    tx.commit().await.map_err(|e| {
        eprintln!("[seed_data] failed to commit seed {key}: {e}");
        e
    })?;

    Ok(())
}

/// Non-cryptographic content checksum used purely to detect whether a seed
/// file's contents changed after it was already applied. Not used for any
/// security-sensitive purpose, so `std`'s `DefaultHasher` (SipHash) is
/// sufficient and avoids pulling in an extra crate dependency.
fn checksum_of(content: &str) -> String {
    let mut hasher = DefaultHasher::new();
    content.hash(&mut hasher);
    format!("{:x}", hasher.finish())
}
