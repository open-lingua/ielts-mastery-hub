//! Mirrors `src/database/listening_assets_migration.rs`.
//!
//! End-to-end coverage of `sync_listening_assets_from_dir` — the
//! injectable-parameters variant of `sync_listening_assets_to_local_storage`
//! that takes a database pool, the seed source directory, and the local
//! destination root as arguments so this can run against temp directories
//! and a test database instead of the real seed assets/`$HOME`.
mod sync_listening_assets_from_dir_test {
    use app_lib::database::asset_sync::AssetSyncOutcome;
    use app_lib::database::listening_assets_migration::sync_listening_assets_from_dir;
    use app_lib::database::Db;
    use app_lib::repositories::listening_sections;

    use crate::common::builders::CreateListeningSectionBuilder;
    use crate::common::fixtures::test_pool;

    const OWNER_ID: &str = "owner-1";

    fn unique_temp_dir(label: &str) -> std::path::PathBuf {
        std::env::temp_dir().join(format!(
            "imh-test-{label}-{}-{}",
            std::process::id(),
            uuid::Uuid::new_v4()
        ))
    }

    /// Inserts a `listening_tests` row with a **specific** `id` (unlike
    /// `repositories::listening_tests::insert`, which always generates its
    /// own UUID) so it can be matched against a seed folder whose name is
    /// the same `test_id`.
    async fn given_test(pool: &Db, test_id: &str) {
        let now = chrono::Utc::now().to_rfc3339();
        sqlx::query!(
            "INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status, created_at, updated_at)
             VALUES (?, ?, 'Sample Listening Test', '7', '40 mins', 'draft', ?, ?)",
            test_id,
            OWNER_ID,
            now,
            now
        )
        .execute(pool)
        .await
        .expect("insert listening test");
    }

    async fn given_section(pool: &Db, test_id: &str, section_number: i64) {
        let input = CreateListeningSectionBuilder::default()
            .with_test_id(test_id)
            .with_section_number(section_number)
            .build();
        listening_sections::insert(pool, &input, OWNER_ID)
            .await
            .expect("insert listening section");
    }

    #[tokio::test]
    async fn it_recursively_copies_nested_seed_files_into_the_destination() {
        // Arrange
        let pool = test_pool().await;
        let source_dir = unique_temp_dir("source");
        let dest_dir = unique_temp_dir("dest");
        let test_id = "11111111-1111-1111-1111-111111111111";
        let tts_config_dir = source_dir.join(test_id).join("tts-config");
        tokio::fs::create_dir_all(&tts_config_dir)
            .await
            .expect("create nested seed dir");
        tokio::fs::write(
            tts_config_dir.join("section-1-tts-config.json"),
            b"{\"voice\":\"alloy\"}",
        )
        .await
        .expect("write seed asset");

        // Act
        let result = sync_listening_assets_from_dir(&pool, &source_dir, &dest_dir).await;

        // Assert
        assert_eq!(result.unwrap(), AssetSyncOutcome::Synced { copied: 1 });
        let copied = tokio::fs::read(
            dest_dir
                .join(test_id)
                .join("tts-config")
                .join("section-1-tts-config.json"),
        )
        .await
        .expect("destination file should exist");
        assert_eq!(copied, b"{\"voice\":\"alloy\"}");

        // Cleanup
        let _ = tokio::fs::remove_dir_all(&source_dir).await;
        let _ = tokio::fs::remove_dir_all(&dest_dir).await;
    }

    #[tokio::test]
    async fn it_does_not_overwrite_a_destination_file_that_already_exists() {
        // Arrange
        let pool = test_pool().await;
        let source_dir = unique_temp_dir("source-existing");
        let dest_dir = unique_temp_dir("dest-existing");
        let test_id = "22222222-2222-2222-2222-222222222222";
        let seed_tts_dir = source_dir.join(test_id).join("tts-config");
        tokio::fs::create_dir_all(&seed_tts_dir)
            .await
            .expect("create nested seed dir");
        tokio::fs::write(
            seed_tts_dir.join("section-1-tts-config.json"),
            b"seed-bytes",
        )
        .await
        .expect("write seed asset");

        let dest_tts_dir = dest_dir.join(test_id).join("tts-config");
        tokio::fs::create_dir_all(&dest_tts_dir)
            .await
            .expect("create existing dest dir");
        tokio::fs::write(
            dest_tts_dir.join("section-1-tts-config.json"),
            b"user-bytes",
        )
        .await
        .expect("seed existing destination file");

        // Act
        let result = sync_listening_assets_from_dir(&pool, &source_dir, &dest_dir).await;

        // Assert
        assert_eq!(result.unwrap(), AssetSyncOutcome::Synced { copied: 0 });
        let contents = tokio::fs::read(dest_tts_dir.join("section-1-tts-config.json"))
            .await
            .expect("destination file should still exist");
        assert_eq!(
            contents, b"user-bytes",
            "existing destination file must not be overwritten"
        );

        // Cleanup
        let _ = tokio::fs::remove_dir_all(&source_dir).await;
        let _ = tokio::fs::remove_dir_all(&dest_dir).await;
    }

    #[tokio::test]
    async fn it_preserves_unrelated_existing_files_in_the_destination() {
        // Arrange
        let pool = test_pool().await;
        let source_dir = unique_temp_dir("source-unrelated");
        let dest_dir = unique_temp_dir("dest-unrelated");
        let test_id = "33333333-3333-3333-3333-333333333333";
        let seed_tts_dir = source_dir.join(test_id).join("tts-config");
        tokio::fs::create_dir_all(&seed_tts_dir)
            .await
            .expect("create nested seed dir");
        tokio::fs::write(
            seed_tts_dir.join("section-1-tts-config.json"),
            b"seed-bytes",
        )
        .await
        .expect("write seed asset");

        // A file the seed tree knows nothing about, already present under
        // the destination test folder (e.g. a user-recorded audio file).
        let dest_test_dir = dest_dir.join(test_id);
        tokio::fs::create_dir_all(&dest_test_dir)
            .await
            .expect("create existing dest test dir");
        tokio::fs::write(
            dest_test_dir.join("section-1-audio.mp3"),
            b"real-audio-bytes",
        )
        .await
        .expect("seed unrelated existing file");

        // Act
        let result = sync_listening_assets_from_dir(&pool, &source_dir, &dest_dir).await;

        // Assert
        assert_eq!(result.unwrap(), AssetSyncOutcome::Synced { copied: 1 });
        let unrelated = tokio::fs::read(dest_test_dir.join("section-1-audio.mp3"))
            .await
            .expect("unrelated existing file should be preserved");
        assert_eq!(unrelated, b"real-audio-bytes");
        let copied = tokio::fs::read(
            dest_test_dir
                .join("tts-config")
                .join("section-1-tts-config.json"),
        )
        .await
        .expect("new seed file should still be copied alongside the unrelated file");
        assert_eq!(copied, b"seed-bytes");

        // Cleanup
        let _ = tokio::fs::remove_dir_all(&source_dir).await;
        let _ = tokio::fs::remove_dir_all(&dest_dir).await;
    }

    #[tokio::test]
    async fn it_is_a_graceful_no_op_when_the_source_directory_does_not_exist() {
        // Arrange
        let pool = test_pool().await;
        let missing_source_dir = unique_temp_dir("does-not-exist");
        let dest_dir = unique_temp_dir("dest-missing-source");

        // Act
        let result = sync_listening_assets_from_dir(&pool, &missing_source_dir, &dest_dir).await;

        // Assert
        assert_eq!(
            result.unwrap(),
            AssetSyncOutcome::SourceMissing {
                source_dir: missing_source_dir.clone()
            }
        );
        assert!(
            tokio::fs::metadata(&dest_dir).await.is_err(),
            "no destination directory should be created when the source is missing"
        );
    }

    #[tokio::test]
    async fn it_backfills_audio_url_for_the_matching_section_only() {
        // Arrange
        let pool = test_pool().await;
        let test_id = "44444444-4444-4444-4444-444444444444";
        given_test(&pool, test_id).await;
        let section_1_id = {
            let input = CreateListeningSectionBuilder::default()
                .with_test_id(test_id)
                .with_section_number(1)
                .build();
            listening_sections::insert(&pool, &input, OWNER_ID)
                .await
                .expect("insert section 1")
        };
        given_section(&pool, test_id, 2).await;

        let source_dir = unique_temp_dir("source-audio-url");
        let dest_dir = unique_temp_dir("dest-audio-url");
        let test_source_dir = source_dir.join(test_id);
        tokio::fs::create_dir_all(&test_source_dir)
            .await
            .expect("create seed test dir");
        tokio::fs::write(test_source_dir.join("section-2.mp3"), b"fake-mp3-bytes")
            .await
            .expect("write seed audio asset");

        // Act
        let result = sync_listening_assets_from_dir(&pool, &source_dir, &dest_dir).await;

        // Assert
        assert_eq!(result.unwrap(), AssetSyncOutcome::Synced { copied: 1 });
        let dest_audio_path = dest_dir.join(test_id).join("section-2.mp3");
        let copied = tokio::fs::read(&dest_audio_path)
            .await
            .expect("destination audio file should exist");
        assert_eq!(copied, b"fake-mp3-bytes");

        let section_1 = listening_sections::find_by_id(&pool, &section_1_id, OWNER_ID)
            .await
            .expect("find section 1")
            .expect("section 1 present");
        assert_eq!(
            section_1.audio_url, None,
            "section 1 (no matching seed file) must not be touched"
        );

        let sections = sqlx::query!(
            "SELECT id, audio_url FROM listening_sections WHERE test_id = ? AND section_number = 2",
            test_id
        )
        .fetch_one(&pool)
        .await
        .expect("find section 2 row");
        assert_eq!(
            sections.audio_url.as_deref(),
            Some(dest_audio_path.to_string_lossy().into_owned().as_str())
        );

        // Cleanup
        let _ = tokio::fs::remove_dir_all(&source_dir).await;
        let _ = tokio::fs::remove_dir_all(&dest_dir).await;
    }

    #[tokio::test]
    async fn it_does_not_clobber_a_custom_audio_url_on_a_second_run() {
        // Arrange
        let pool = test_pool().await;
        let test_id = "55555555-5555-5555-5555-555555555555";
        given_test(&pool, test_id).await;
        given_section(&pool, test_id, 3).await;

        let source_dir = unique_temp_dir("source-idempotent");
        let dest_dir = unique_temp_dir("dest-idempotent");
        let test_source_dir = source_dir.join(test_id);
        tokio::fs::create_dir_all(&test_source_dir)
            .await
            .expect("create seed test dir");
        tokio::fs::write(test_source_dir.join("section-3.mp3"), b"original-bytes")
            .await
            .expect("write seed audio asset");

        sync_listening_assets_from_dir(&pool, &source_dir, &dest_dir)
            .await
            .expect("first run");

        // Simulate a user having since edited audio_url away from the
        // seeded path.
        let section = sqlx::query!(
            "SELECT id FROM listening_sections WHERE test_id = ? AND section_number = 3",
            test_id
        )
        .fetch_one(&pool)
        .await
        .expect("find section 3 row");
        sqlx::query!(
            "UPDATE listening_sections SET audio_url = 'custom-user-value' WHERE id = ?",
            section.id
        )
        .execute(&pool)
        .await
        .expect("simulate user edit");

        // Overwrite the seed source file to prove a second run doesn't
        // re-copy it or clobber the row.
        tokio::fs::write(test_source_dir.join("section-3.mp3"), b"changed-bytes")
            .await
            .expect("rewrite seed audio asset");

        // Act
        let result = sync_listening_assets_from_dir(&pool, &source_dir, &dest_dir).await;

        // Assert
        assert_eq!(result.unwrap(), AssetSyncOutcome::Synced { copied: 0 });
        let dest_audio_path = dest_dir.join(test_id).join("section-3.mp3");
        let copied = tokio::fs::read(&dest_audio_path)
            .await
            .expect("destination audio file should still exist");
        assert_eq!(
            copied, b"original-bytes",
            "destination file must not be overwritten"
        );

        let updated = sqlx::query!(
            "SELECT audio_url FROM listening_sections WHERE id = ?",
            section.id
        )
        .fetch_one(&pool)
        .await
        .expect("find section row");
        assert_eq!(
            updated.audio_url.as_deref(),
            Some("custom-user-value"),
            "user-edited audio_url must not be clobbered"
        );

        // Cleanup
        let _ = tokio::fs::remove_dir_all(&source_dir).await;
        let _ = tokio::fs::remove_dir_all(&dest_dir).await;
    }

    #[tokio::test]
    async fn it_copies_a_section_audio_file_with_no_matching_row_without_erroring() {
        // Arrange
        let pool = test_pool().await;
        let source_dir = unique_temp_dir("source-orphan");
        let dest_dir = unique_temp_dir("dest-orphan");
        let test_id = "66666666-6666-6666-6666-666666666666";
        let test_source_dir = source_dir.join(test_id);
        tokio::fs::create_dir_all(&test_source_dir)
            .await
            .expect("create seed test dir");
        tokio::fs::write(test_source_dir.join("section-1.mp3"), b"orphan-bytes")
            .await
            .expect("write seed audio asset");

        // Act
        let result = sync_listening_assets_from_dir(&pool, &source_dir, &dest_dir).await;

        // Assert
        assert_eq!(result.unwrap(), AssetSyncOutcome::Synced { copied: 1 });
        let copied = tokio::fs::read(dest_dir.join(test_id).join("section-1.mp3"))
            .await
            .expect("destination audio file should still be copied");
        assert_eq!(copied, b"orphan-bytes");

        // Cleanup
        let _ = tokio::fs::remove_dir_all(&source_dir).await;
        let _ = tokio::fs::remove_dir_all(&dest_dir).await;
    }
}
