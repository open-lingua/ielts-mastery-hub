//! Shared in-memory SQLite fixture for repository/service tests.
//!
//! `repositories::*` take a concrete `sqlx::SqlitePool` with compile-time
//! checked queries — there is no repository trait to fake without modifying
//! production source. As a pragmatic, deliberate exception to the "no real
//! I/O" rule (see `docs/core/testing/03-01-mocking-and-fakes.md`), tests spin
//! up a fresh in-memory SQLite database with the real migrations applied.
//! This mirrors the precedent already set by the existing inline
//! `#[cfg(test)]` blocks in `services/export_service.rs` and
//! `services/import_service.rs`.

use app_lib::database::Db;

/// Builds a fresh, isolated in-memory database with all production
/// migrations applied. Every test calls this itself — no shared/static pool
/// — so tests never leak state or depend on run order.
pub async fn test_pool() -> Db {
    let pool = sqlx::sqlite::SqlitePoolOptions::new()
        .max_connections(1)
        .connect("sqlite::memory:")
        .await
        .expect("failed to open in-memory sqlite pool");

    sqlx::migrate!("./src/database/migrations")
        .run(&pool)
        .await
        .expect("failed to run migrations against in-memory pool");

    pool
}
