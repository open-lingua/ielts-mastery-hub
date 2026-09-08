//! Mirrors `src/database/listening_assets_migration.rs`.
//!
//! End-to-end coverage of `sync_listening_assets_from_dir` — the
//! injectable-parameters variant of `sync_listening_assets_to_local_storage`
//! that takes the seed source directory and the local destination root as
//! arguments so this can run against temp directories instead of the real
//! seed assets/`$HOME`. Unlike `writing_assets_migration_test.rs`, no
//! database pool or repositories are involved: this sync has no
//! `image_url`/`audio_url`-style column to backfill, it's a pure additive
//! directory copy.
mod sync_listening_assets_from_dir_test {
    use app_lib::database::listening_assets_migration::sync_listening_assets_from_dir;

    fn unique_temp_dir(label: &str) -> std::path::PathBuf {
        std::env::temp_dir().join(format!(
            "imh-test-{label}-{}-{}",
            std::process::id(),
            uuid::Uuid::new_v4()
        ))
    }

    #[tokio::test]
    async fn it_recursively_copies_nested_seed_files_into_the_destination() {
        // Arrange
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
        let result = sync_listening_assets_from_dir(&source_dir, &dest_dir).await;

        // Assert
        assert!(result.is_ok());
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
        let source_dir = unique_temp_dir("source-existing");
        let dest_dir = unique_temp_dir("dest-existing");
        let test_id = "22222222-2222-2222-2222-222222222222";
        let seed_tts_dir = source_dir.join(test_id).join("tts-config");
        tokio::fs::create_dir_all(&seed_tts_dir)
            .await
            .expect("create nested seed dir");
        tokio::fs::write(seed_tts_dir.join("section-1-tts-config.json"), b"seed-bytes")
            .await
            .expect("write seed asset");

        let dest_tts_dir = dest_dir.join(test_id).join("tts-config");
        tokio::fs::create_dir_all(&dest_tts_dir)
            .await
            .expect("create existing dest dir");
        tokio::fs::write(dest_tts_dir.join("section-1-tts-config.json"), b"user-bytes")
            .await
            .expect("seed existing destination file");

        // Act
        let result = sync_listening_assets_from_dir(&source_dir, &dest_dir).await;

        // Assert
        assert!(result.is_ok());
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
        let source_dir = unique_temp_dir("source-unrelated");
        let dest_dir = unique_temp_dir("dest-unrelated");
        let test_id = "33333333-3333-3333-3333-333333333333";
        let seed_tts_dir = source_dir.join(test_id).join("tts-config");
        tokio::fs::create_dir_all(&seed_tts_dir)
            .await
            .expect("create nested seed dir");
        tokio::fs::write(seed_tts_dir.join("section-1-tts-config.json"), b"seed-bytes")
            .await
            .expect("write seed asset");

        // A file the seed tree knows nothing about, already present under
        // the destination test folder (e.g. a user-recorded audio file).
        let dest_test_dir = dest_dir.join(test_id);
        tokio::fs::create_dir_all(&dest_test_dir)
            .await
            .expect("create existing dest test dir");
        tokio::fs::write(dest_test_dir.join("section-1-audio.mp3"), b"real-audio-bytes")
            .await
            .expect("seed unrelated existing file");

        // Act
        let result = sync_listening_assets_from_dir(&source_dir, &dest_dir).await;

        // Assert
        assert!(result.is_ok());
        let unrelated = tokio::fs::read(dest_test_dir.join("section-1-audio.mp3"))
            .await
            .expect("unrelated existing file should be preserved");
        assert_eq!(unrelated, b"real-audio-bytes");
        let copied = tokio::fs::read(dest_test_dir.join("tts-config").join("section-1-tts-config.json"))
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
        let missing_source_dir = unique_temp_dir("does-not-exist");
        let dest_dir = unique_temp_dir("dest-missing-source");

        // Act
        let result = sync_listening_assets_from_dir(&missing_source_dir, &dest_dir).await;

        // Assert
        assert!(result.is_ok());
        assert!(
            tokio::fs::metadata(&dest_dir).await.is_err(),
            "no destination directory should be created when the source is missing"
        );
    }
}
