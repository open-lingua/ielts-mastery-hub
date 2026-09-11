//! Mirrors `src/database/mod.rs`.
//!
//! `resolve_database_url` and `default_db_path` read process-global
//! environment variables (`DATABASE_URL`, `HOME`, `APPDATA`) by design — this
//! is the one seam in the codebase where reading env vars directly is
//! intentional (mirroring the existing pragmatic exception already used by
//! `services::export_service::default_export_dir` and
//! `services::import_service::build_listening_assets_dir`). Because
//! `std::env::set_var`/`remove_var` mutate global process state and Rust runs
//! tests on multiple threads by default, every test that mutates an env var
//! serializes on the shared `common::env::ENV_LOCK` and restores the
//! previous value before returning (see `common::env` for the shared
//! helper).

use crate::common::env::{with_env_var, ENV_LOCK};
use app_lib::database::{default_db_path, resolve_database_url, APP_IDENTIFIER};
use std::path::PathBuf;

const CUSTOM_DATABASE_URL: &str = "sqlite://custom/path.db?mode=rwc";
const MACOS_HOME: &str = "/Users/alice";
const LINUX_HOME: &str = "/home/bob";

mod resolve_database_url_test {
    use super::*;

    #[test]
    fn it_returns_the_override_verbatim_when_database_url_is_set() {
        // Arrange
        let _guard = ENV_LOCK.lock().unwrap();

        // Act
        let result = with_env_var(
            "DATABASE_URL",
            Some(CUSTOM_DATABASE_URL),
            resolve_database_url,
        );

        // Assert
        assert_eq!(result.unwrap(), CUSTOM_DATABASE_URL);
    }

    #[test]
    fn it_falls_back_to_the_default_path_when_database_url_is_empty() {
        // Arrange
        let _guard = ENV_LOCK.lock().unwrap();

        // Act
        let result = with_env_var("DATABASE_URL", Some(""), || {
            with_env_var("HOME", Some(LINUX_HOME), resolve_database_url)
        });

        // Assert
        let url = result.unwrap();
        assert!(url.contains(APP_IDENTIFIER));
        assert!(url.contains("imh.db"));
    }
}

mod default_db_path_test {
    use super::*;

    #[test]
    fn it_builds_the_path_under_application_support_when_os_is_macos() {
        // Arrange
        let _guard = ENV_LOCK.lock().unwrap();

        // Act
        let result = with_env_var("HOME", Some(MACOS_HOME), || default_db_path("macos"));

        // Assert
        assert_eq!(
            result.unwrap(),
            PathBuf::from(format!(
                "{MACOS_HOME}/Library/Application Support/{APP_IDENTIFIER}/imh.db"
            ))
        );
    }

    #[test]
    fn it_builds_the_path_under_local_share_when_os_is_linux() {
        // Arrange
        let _guard = ENV_LOCK.lock().unwrap();

        // Act
        let result = with_env_var("HOME", Some(LINUX_HOME), || default_db_path("linux"));

        // Assert
        assert_eq!(
            result.unwrap(),
            PathBuf::from(format!("{LINUX_HOME}/.local/share/{APP_IDENTIFIER}/imh.db"))
        );
    }

    #[test]
    fn it_returns_validation_error_when_home_is_missing_on_linux() {
        // Arrange
        let _guard = ENV_LOCK.lock().unwrap();

        // Act
        let result = with_env_var("HOME", None, || default_db_path("linux"));

        // Assert
        assert!(matches!(
            result,
            Err(app_lib::error::AppError::Validation(_))
        ));
    }

    #[test]
    fn it_returns_validation_error_when_appdata_is_missing_on_windows() {
        // Arrange
        let _guard = ENV_LOCK.lock().unwrap();

        // Act
        let result = with_env_var("APPDATA", None, || default_db_path("windows"));

        // Assert
        assert!(matches!(
            result,
            Err(app_lib::error::AppError::Validation(_))
        ));
    }
}
