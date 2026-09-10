//! Mirrors `src/database/seed_data.rs`.
//!
//! `run_seed_data_from_dirs` is exercised end-to-end against the *real*
//! bundled `src/database/seeds/{reading,listening,writing}` directories in
//! `it_seeds_the_real_bundled_seed_files_into_a_freshly_migrated_database`
//! below — this reproduces the exact fresh-install scenario that originally
//! shipped with `sqlx::migrate!("./src/database/seeds")` silently resolving
//! to zero migrations (that macro's directory resolver does not recurse
//! into subdirectories, so it never actually found any `.sql` file under
//! `seeds/`) and would have caught that regression.

mod run_seed_data_from_dirs_test {
    use std::path::{Path, PathBuf};

    use app_lib::database::seed_data::run_seed_data_from_dirs;
    use app_lib::database::Db;

    use crate::common::fixtures::test_pool;

    fn unique_temp_dir(label: &str) -> PathBuf {
        std::env::temp_dir().join(format!(
            "imh-seed-data-test-{label}-{}-{}",
            std::process::id(),
            uuid::Uuid::new_v4()
        ))
    }

    async fn write_seed_file(dir: &Path, file_name: &str, sql: &str) {
        tokio::fs::create_dir_all(dir)
            .await
            .expect("create seed dir");
        tokio::fs::write(dir.join(file_name), sql)
            .await
            .expect("write seed file");
    }

    async fn count(pool: &Db, table: &str) -> i64 {
        let sql = format!("SELECT COUNT(*) FROM {table}");
        sqlx::query_scalar::<_, i64>(sqlx::AssertSqlSafe(sql))
            .fetch_one(pool)
            .await
            .expect("count rows")
    }

    #[tokio::test]
    async fn it_seeds_the_real_bundled_seed_files_into_a_freshly_migrated_database() {
        // Arrange: a freshly migrated (schema-only) database, exactly as a
        // brand-new install would have immediately after
        // `sqlx::migrate!("./src/database/migrations")` runs and before any
        // seed data is applied.
        let pool = test_pool().await;
        let dirs: Vec<(&str, &Path)> = vec![
            ("reading", Path::new("src/database/seeds/reading")),
            ("listening", Path::new("src/database/seeds/listening")),
            ("writing", Path::new("src/database/seeds/writing")),
        ];

        assert_eq!(
            count(&pool, "reading_tests").await,
            0,
            "sanity check: schema migrations alone should not seed any data"
        );

        // Act
        let result = run_seed_data_from_dirs(&pool, &dirs).await;

        // Assert: every bundled module's seed data actually landed in the
        // database. This is the exact bug scenario -- prior to this fix,
        // this whole test's `Act` step was a silent no-op because
        // `sqlx::migrate!("./src/database/seeds")` never found any file.
        assert!(result.is_ok(), "seeding failed: {:?}", result.err());
        assert!(
            count(&pool, "reading_tests").await > 0,
            "expected reading seed data to be applied"
        );
        assert!(
            count(&pool, "listening_tests").await > 0,
            "expected listening seed data to be applied"
        );
        assert!(
            count(&pool, "writing_tasks").await > 0,
            "expected writing seed data to be applied"
        );
    }

    #[tokio::test]
    async fn it_is_idempotent_on_a_second_run_against_the_real_seed_files() {
        // Arrange
        let pool = test_pool().await;
        let dirs: Vec<(&str, &Path)> = vec![
            ("reading", Path::new("src/database/seeds/reading")),
            ("listening", Path::new("src/database/seeds/listening")),
            ("writing", Path::new("src/database/seeds/writing")),
        ];
        run_seed_data_from_dirs(&pool, &dirs)
            .await
            .expect("first seed run should succeed");
        let reading_count_after_first_run = count(&pool, "reading_tests").await;
        let listening_count_after_first_run = count(&pool, "listening_tests").await;
        let writing_count_after_first_run = count(&pool, "writing_tasks").await;

        // Act
        let result = run_seed_data_from_dirs(&pool, &dirs).await;

        // Assert
        assert!(result.is_ok(), "second seed run failed: {:?}", result.err());
        assert_eq!(
            count(&pool, "reading_tests").await,
            reading_count_after_first_run,
            "re-running seeding must not duplicate reading rows"
        );
        assert_eq!(
            count(&pool, "listening_tests").await,
            listening_count_after_first_run,
            "re-running seeding must not duplicate listening rows"
        );
        assert_eq!(
            count(&pool, "writing_tasks").await,
            writing_count_after_first_run,
            "re-running seeding must not duplicate writing rows"
        );
    }

    #[tokio::test]
    async fn it_skips_reapplying_a_seed_file_whose_contents_changed_after_it_was_applied() {
        // Arrange
        let pool = test_pool().await;
        let source_dir = unique_temp_dir("changed-checksum");
        write_seed_file(
            &source_dir,
            "001_seed.sql",
            "CREATE TABLE IF NOT EXISTS seed_data_test_marker (n INTEGER); \
             INSERT INTO seed_data_test_marker (n) VALUES (1);",
        )
        .await;
        let dirs: Vec<(&str, &Path)> = vec![("marker", source_dir.as_path())];
        run_seed_data_from_dirs(&pool, &dirs)
            .await
            .expect("first seed run should succeed");
        assert_eq!(count(&pool, "seed_data_test_marker").await, 1);

        // Act: rewrite the same file with different content (different
        // checksum) and re-run.
        write_seed_file(
            &source_dir,
            "001_seed.sql",
            "INSERT INTO seed_data_test_marker (n) VALUES (2);",
        )
        .await;
        let result = run_seed_data_from_dirs(&pool, &dirs).await;

        // Assert: the changed file is *not* re-applied (seeds are immutable
        // once applied), so the marker table still only has its original row.
        assert!(result.is_ok(), "seeding failed: {:?}", result.err());
        assert_eq!(
            count(&pool, "seed_data_test_marker").await,
            1,
            "a seed file that changed after being applied must not be re-run"
        );

        // Cleanup
        let _ = tokio::fs::remove_dir_all(&source_dir).await;
    }

    #[tokio::test]
    async fn it_is_a_no_op_when_a_module_directory_does_not_exist() {
        // Arrange
        let pool = test_pool().await;
        let missing_dir = unique_temp_dir("does-not-exist");
        let dirs: Vec<(&str, &Path)> = vec![("missing", missing_dir.as_path())];

        // Act
        let result = run_seed_data_from_dirs(&pool, &dirs).await;

        // Assert
        assert!(result.is_ok(), "seeding failed: {:?}", result.err());
    }
}
