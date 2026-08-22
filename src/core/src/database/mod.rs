use std::path::PathBuf;

use sqlx::sqlite::SqlitePoolOptions;

use crate::error::AppError;

pub type Db = sqlx::SqlitePool;

/// Bundle identifier used to namespace the app's data directory, matching
/// `identifier` in `tauri.conf.json`.
const APP_IDENTIFIER: &str = "com.openlingua.ieltsmasteryhub";

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
fn default_db_path(os: &str) -> Result<PathBuf, AppError> {
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
    Ok(pool)
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::Mutex;

    // `std::env::var`/`set_var` are process-global, and Rust runs tests in
    // parallel threads by default. Serialize access to the env vars this
    // module touches so tests don't stomp on each other.
    static ENV_LOCK: Mutex<()> = Mutex::new(());

    #[test]
    fn resolve_database_url_returns_override_verbatim_when_set() {
        let _guard = ENV_LOCK.lock().unwrap();
        let previous = std::env::var("DATABASE_URL").ok();
        std::env::set_var("DATABASE_URL", "sqlite://custom/path.db?mode=rwc");

        let result = resolve_database_url();

        match previous {
            Some(v) => std::env::set_var("DATABASE_URL", v),
            None => std::env::remove_var("DATABASE_URL"),
        }

        assert_eq!(result.unwrap(), "sqlite://custom/path.db?mode=rwc");
    }

    #[test]
    fn resolve_database_url_ignores_empty_override() {
        let _guard = ENV_LOCK.lock().unwrap();
        let previous_url = std::env::var("DATABASE_URL").ok();
        let previous_home = std::env::var("HOME").ok();
        std::env::set_var("DATABASE_URL", "");
        std::env::set_var("HOME", "/tmp/test-home");

        let result = resolve_database_url();

        match previous_url {
            Some(v) => std::env::set_var("DATABASE_URL", v),
            None => std::env::remove_var("DATABASE_URL"),
        }
        match previous_home {
            Some(v) => std::env::set_var("HOME", v),
            None => std::env::remove_var("HOME"),
        }

        let url = result.unwrap();
        assert!(url.contains(APP_IDENTIFIER));
        assert!(url.contains("ielts.db"));
    }

    #[test]
    fn default_db_path_builds_macos_path_under_application_support() {
        let path = default_db_path_with_home("macos", "/Users/alice").unwrap();
        assert_eq!(
            path,
            PathBuf::from(
                "/Users/alice/Library/Application Support/com.openlingua.ieltsmasteryhub/ielts.db"
            )
        );
    }

    #[test]
    fn default_db_path_builds_linux_path_under_xdg_data_home() {
        let path = default_db_path_with_home("linux", "/home/bob").unwrap();
        assert_eq!(
            path,
            PathBuf::from(
                "/home/bob/.local/share/com.openlingua.ieltsmasteryhub/ielts.db"
            )
        );
    }

    #[test]
    fn default_db_path_returns_validation_error_when_home_missing() {
        let _guard = ENV_LOCK.lock().unwrap();
        let previous = std::env::var("HOME").ok();
        std::env::remove_var("HOME");

        let result = default_db_path("linux");

        if let Some(v) = previous {
            std::env::set_var("HOME", v);
        }

        assert!(matches!(result, Err(AppError::Validation(_))));
    }

    #[test]
    fn default_db_path_returns_validation_error_when_appdata_missing() {
        let _guard = ENV_LOCK.lock().unwrap();
        let previous = std::env::var("APPDATA").ok();
        std::env::remove_var("APPDATA");

        let result = default_db_path("windows");

        if let Some(v) = previous {
            std::env::set_var("APPDATA", v);
        }

        assert!(matches!(result, Err(AppError::Validation(_))));
    }

    /// Test helper: builds the default path for `os` using an explicit home
    /// directory rather than reading `$HOME` directly, avoiding env
    /// mutation for the common-case assertions above.
    fn default_db_path_with_home(os: &str, home: &str) -> Result<PathBuf, AppError> {
        let _guard = ENV_LOCK.lock().unwrap();
        let var = if os == "windows" { "APPDATA" } else { "HOME" };
        let previous = std::env::var(var).ok();
        std::env::set_var(var, home);

        let result = default_db_path(os);

        match previous {
            Some(v) => std::env::set_var(var, v),
            None => std::env::remove_var(var),
        }
        result
    }
}
