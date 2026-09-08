//! Mirrors `src/database/listening_assets_migration.rs`.

use app_lib::database::listening_assets_migration::migrate_listening_assets_dir;
use app_lib::database::Db;
use app_lib::repositories::{listening_sections, listening_tests};

use crate::common::builders::{
    default_listening_test, CreateListeningSectionBuilder,
};
use crate::common::fixtures::test_pool;

const OWNER_ID: &str = "owner-1";

async fn given_test(pool: &Db) -> String {
    listening_tests::insert(pool, &default_listening_test(), OWNER_ID)
        .await
        .expect("insert listening test")
}

async fn given_section(pool: &Db, test_id: &str, audio_url: &str) -> String {
    let input = CreateListeningSectionBuilder::default()
        .with_test_id(test_id)
        .with_audio_url(audio_url)
        .build();
    listening_sections::insert(pool, &input, OWNER_ID)
        .await
        .expect("insert listening section")
}

fn unique_temp_home(label: &str) -> std::path::PathBuf {
    std::env::temp_dir().join(format!(
        "imh-test-{label}-{}-{}",
        std::process::id(),
        uuid::Uuid::new_v4()
    ))
}

#[tokio::test]
async fn it_renames_the_old_directory_to_the_new_one_when_only_the_old_exists() {
    // Arrange
    let pool = test_pool().await;
    let home_dir = unique_temp_home("rename");
    let old_dir = home_dir.join(".imh").join("listening-tests");
    let test_id = "11111111-1111-1111-1111-111111111111";
    let test_dir = old_dir.join(test_id);
    tokio::fs::create_dir_all(&test_dir).await.expect("create old test dir");
    tokio::fs::write(test_dir.join("section-1.mp3"), b"fake-audio-bytes")
        .await
        .expect("write fake audio file");

    // Act
    let result = migrate_listening_assets_dir(&pool, &home_dir.to_string_lossy()).await;

    // Assert
    assert!(result.is_ok());
    let new_dir = home_dir.join(".imh").join("listening-assets");
    assert!(
        tokio::fs::metadata(&old_dir).await.is_err(),
        "old directory should no longer exist after the rename"
    );
    let moved_file = new_dir.join(test_id).join("section-1.mp3");
    let bytes = tokio::fs::read(&moved_file)
        .await
        .expect("moved audio file should exist under the new directory");
    assert_eq!(bytes, b"fake-audio-bytes");

    // Cleanup
    let _ = tokio::fs::remove_dir_all(&home_dir).await;
}

#[tokio::test]
async fn it_is_a_no_op_when_neither_directory_exists() {
    // Arrange
    let pool = test_pool().await;
    let home_dir = unique_temp_home("neither-exists");

    // Act
    let result = migrate_listening_assets_dir(&pool, &home_dir.to_string_lossy()).await;

    // Assert
    assert!(result.is_ok());
    let new_dir = home_dir.join(".imh").join("listening-assets");
    assert!(
        tokio::fs::metadata(&new_dir).await.is_err(),
        "no new directory should be created out of thin air"
    );

    // Cleanup
    let _ = tokio::fs::remove_dir_all(&home_dir).await;
}

#[tokio::test]
async fn it_does_not_clobber_an_already_existing_new_directory() {
    // Arrange
    let pool = test_pool().await;
    let home_dir = unique_temp_home("already-migrated");
    let old_dir = home_dir.join(".imh").join("listening-tests");
    let new_dir = home_dir.join(".imh").join("listening-assets");
    let test_id = "22222222-2222-2222-2222-222222222222";

    tokio::fs::create_dir_all(old_dir.join(test_id))
        .await
        .expect("create old test dir");
    tokio::fs::write(old_dir.join(test_id).join("section-1.mp3"), b"old-bytes")
        .await
        .expect("write old audio file");

    tokio::fs::create_dir_all(new_dir.join(test_id))
        .await
        .expect("create new test dir");
    tokio::fs::write(new_dir.join(test_id).join("section-1.mp3"), b"new-bytes")
        .await
        .expect("write new audio file");

    // Act
    let result = migrate_listening_assets_dir(&pool, &home_dir.to_string_lossy()).await;

    // Assert
    assert!(result.is_ok());
    let new_bytes = tokio::fs::read(new_dir.join(test_id).join("section-1.mp3"))
        .await
        .expect("new directory's file should still exist");
    assert_eq!(
        new_bytes, b"new-bytes",
        "an already-existing new directory must never be overwritten"
    );
    assert!(
        tokio::fs::metadata(&old_dir).await.is_ok(),
        "the old directory must be left alone when the new one already exists"
    );

    // Cleanup
    let _ = tokio::fs::remove_dir_all(&home_dir).await;
}

#[tokio::test]
async fn it_rewrites_audio_url_rows_pointing_at_the_old_directory() {
    // Arrange
    let pool = test_pool().await;
    let home_dir = unique_temp_home("rewrite-audio-url");
    let test_id = given_test(&pool).await;
    let old_dir = home_dir.join(".imh").join("listening-tests");
    let old_audio_path = old_dir.join(&test_id).join("section-1.mp3");
    let section_id = given_section(&pool, &test_id, &old_audio_path.to_string_lossy()).await;

    // Act
    let result = migrate_listening_assets_dir(&pool, &home_dir.to_string_lossy()).await;

    // Assert
    assert!(result.is_ok());
    let section = listening_sections::find_by_id(&pool, &section_id, OWNER_ID)
        .await
        .expect("find")
        .expect("present");
    let new_dir = home_dir.join(".imh").join("listening-assets");
    let expected_audio_path = new_dir.join(&test_id).join("section-1.mp3");
    assert_eq!(
        section.audio_url,
        Some(expected_audio_path.to_string_lossy().into_owned())
    );

    // Cleanup
    let _ = tokio::fs::remove_dir_all(&home_dir).await;
}

#[tokio::test]
async fn it_leaves_an_audio_url_row_alone_when_it_does_not_point_at_the_old_directory() {
    // Arrange
    let pool = test_pool().await;
    let home_dir = unique_temp_home("unrelated-audio-url");
    let test_id = given_test(&pool).await;
    let unrelated_audio_url = "/some/unrelated/path/section-1.mp3";
    let section_id = given_section(&pool, &test_id, unrelated_audio_url).await;

    // Act
    let result = migrate_listening_assets_dir(&pool, &home_dir.to_string_lossy()).await;

    // Assert
    assert!(result.is_ok());
    let section = listening_sections::find_by_id(&pool, &section_id, OWNER_ID)
        .await
        .expect("find")
        .expect("present");
    assert_eq!(section.audio_url.as_deref(), Some(unrelated_audio_url));

    // Cleanup
    let _ = tokio::fs::remove_dir_all(&home_dir).await;
}
