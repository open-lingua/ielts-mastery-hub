//! Shared helper for tests that mutate process-global environment variables
//! (`HOME`, `USERPROFILE`, `APPDATA`, `DATABASE_URL`) to exercise OS-specific
//! path-resolution code (see `database::home_dir`, `database::default_db_path`,
//! `services::export_service::default_export_dir`,
//! `services::import_service::build_listening_assets_dir`).
//!
//! Reading env vars directly is a deliberate, narrow exception to the "no
//! ambient global state" testing rule for exactly these OS-detection seams.
//! Because `std::env::set_var`/`remove_var` mutate global process state and
//! the whole suite runs as a single binary with tests on multiple threads by
//! default, every test that mutates an env var must serialize on the shared
//! [`ENV_LOCK`] and restore the previous value before returning — otherwise
//! it could race with any other test in the binary that also touches these
//! vars.

use std::sync::Mutex;

/// Process-wide lock guarding any test that reads/writes `HOME`,
/// `USERPROFILE`, `APPDATA`, or `DATABASE_URL`. Acquire this (`let _guard =
/// ENV_LOCK.lock().unwrap();`) before calling [`with_env_var`].
pub static ENV_LOCK: Mutex<()> = Mutex::new(());

/// Sets `var` to `value` for the duration of `f`, restoring the previous
/// value (or removing the var if it was previously unset) afterwards.
/// Callers must hold [`ENV_LOCK`] before invoking this.
pub fn with_env_var<T>(var: &str, value: Option<&str>, f: impl FnOnce() -> T) -> T {
    let previous = std::env::var(var).ok();
    match value {
        Some(v) => std::env::set_var(var, v),
        None => std::env::remove_var(var),
    }

    let result = f();

    match previous {
        Some(v) => std::env::set_var(var, v),
        None => std::env::remove_var(var),
    }
    result
}
