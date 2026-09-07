//! End-to-end coverage of `database::sync_writing_assets_from_dir` — the
//! injectable-parameters variant of `sync_writing_assets_to_local_storage`
//! that takes the seed source directory and `$HOME` as arguments so this can
//! run against temp directories instead of the real seed assets/`$HOME`.

use app_lib::database::sync_writing_assets_from_dir;
use app_lib::database::Db;
use app_lib::repositories::{writing_tasks, writing_tests};

use crate::common::builders::{default_writing_test, CreateWritingTaskBuilder};
use crate::common::fixtures::test_pool;

const OWNER_ID: &str = "owner-1";

async fn given_task(pool: &Db, task_id: &str) -> String {
    let test_id = writing_tests::insert(pool, &default_writing_test(), OWNER_ID)
        .await
        .expect("insert parent test");
    let input = CreateWritingTaskBuilder::default()
        .with_id(task_id)
        .with_test_id(&test_id)
        .build();
    writing_tasks::insert(pool, &input, OWNER_ID)
        .await
        .expect("insert task")
}

fn unique_temp_dir(label: &str) -> std::path::PathBuf {
    std::env::temp_dir().join(format!(
        "ielts-hub-test-{label}-{}-{}",
        std::process::id(),
        uuid::Uuid::new_v4()
    ))
}

#[tokio::test]
async fn it_copies_the_seed_asset_and_updates_image_url() {
    // Arrange
    let pool = test_pool().await;
    let task_id = "11111111-1111-1111-1111-111111111111";
    given_task(&pool, task_id).await;

    let source_dir = unique_temp_dir("source");
    let home_dir = unique_temp_dir("home");
    tokio::fs::create_dir_all(&source_dir).await.expect("create source dir");
    tokio::fs::write(source_dir.join(format!("{task_id}.jpeg")), b"fake-image-bytes")
        .await
        .expect("write seed asset");

    // Act
    let result = sync_writing_assets_from_dir(&pool, &source_dir, &home_dir.to_string_lossy()).await;

    // Assert
    assert!(result.is_ok());
    let dest = home_dir
        .join(".ielts-hub")
        .join("writing-assets")
        .join(format!("{task_id}.jpeg"));
    let copied = tokio::fs::read(&dest).await.expect("destination file should exist");
    assert_eq!(copied, b"fake-image-bytes");

    let task = writing_tasks::find_by_id(&pool, task_id, OWNER_ID)
        .await
        .expect("find")
        .expect("present");
    assert_eq!(task.image_url.as_deref(), Some(dest.to_string_lossy().as_ref()));

    // Cleanup
    let _ = tokio::fs::remove_dir_all(&source_dir).await;
    let _ = tokio::fs::remove_dir_all(&home_dir).await;
}

#[tokio::test]
async fn it_is_a_no_op_on_a_second_run_once_the_destination_file_exists() {
    // Arrange
    let pool = test_pool().await;
    let task_id = "22222222-2222-2222-2222-222222222222";
    given_task(&pool, task_id).await;

    let source_dir = unique_temp_dir("source-idempotent");
    let home_dir = unique_temp_dir("home-idempotent");
    tokio::fs::create_dir_all(&source_dir).await.expect("create source dir");
    tokio::fs::write(source_dir.join(format!("{task_id}.jpeg")), b"original-bytes")
        .await
        .expect("write seed asset");

    sync_writing_assets_from_dir(&pool, &source_dir, &home_dir.to_string_lossy())
        .await
        .expect("first run");

    let dest = home_dir
        .join(".ielts-hub")
        .join("writing-assets")
        .join(format!("{task_id}.jpeg"));

    // Simulate a user having since edited image_url away from the seeded path.
    writing_tasks::update(
        &pool,
        task_id,
        OWNER_ID,
        &app_lib::models::writing_tasks::UpdateWritingTask {
            task_number: None,
            task_type: None,
            title: None,
            difficulty: None,
            suggested_time: None,
            prompt: None,
            min_words: None,
            max_words: None,
            image_url: Some("custom-user-value".to_string()),
            include_model_answer: None,
            model_answer: None,
            figure_description: None,
        },
    )
    .await
    .expect("simulate user edit");

    // Overwrite the seed source file to prove a second run doesn't re-copy it.
    tokio::fs::write(source_dir.join(format!("{task_id}.jpeg")), b"changed-bytes")
        .await
        .expect("rewrite seed asset");

    // Act
    let result = sync_writing_assets_from_dir(&pool, &source_dir, &home_dir.to_string_lossy()).await;

    // Assert
    assert!(result.is_ok());
    let copied = tokio::fs::read(&dest).await.expect("destination file should still exist");
    assert_eq!(copied, b"original-bytes", "destination file must not be overwritten");

    let task = writing_tasks::find_by_id(&pool, task_id, OWNER_ID)
        .await
        .expect("find")
        .expect("present");
    assert_eq!(
        task.image_url.as_deref(),
        Some("custom-user-value"),
        "user-edited image_url must not be clobbered"
    );

    // Cleanup
    let _ = tokio::fs::remove_dir_all(&source_dir).await;
    let _ = tokio::fs::remove_dir_all(&home_dir).await;
}

#[tokio::test]
async fn it_skips_a_seed_asset_with_no_matching_writing_tasks_row() {
    // Arrange
    let pool = test_pool().await;
    let source_dir = unique_temp_dir("source-orphan");
    let home_dir = unique_temp_dir("home-orphan");
    tokio::fs::create_dir_all(&source_dir).await.expect("create source dir");
    tokio::fs::write(
        source_dir.join("99999999-9999-9999-9999-999999999999.jpeg"),
        b"orphan-bytes",
    )
    .await
    .expect("write seed asset");

    // Act
    let result = sync_writing_assets_from_dir(&pool, &source_dir, &home_dir.to_string_lossy()).await;

    // Assert
    assert!(result.is_ok());
    let dest_dir = home_dir.join(".ielts-hub").join("writing-assets");
    assert!(
        tokio::fs::metadata(&dest_dir).await.is_err(),
        "no destination directory should be created for an orphaned seed asset"
    );

    // Cleanup
    let _ = tokio::fs::remove_dir_all(&source_dir).await;
}

#[tokio::test]
async fn it_returns_an_error_when_the_source_directory_does_not_exist() {
    // Arrange
    let pool = test_pool().await;
    let missing_dir = unique_temp_dir("does-not-exist");
    let home_dir = unique_temp_dir("home-missing-source");

    // Act
    let result = sync_writing_assets_from_dir(&pool, &missing_dir, &home_dir.to_string_lossy()).await;

    // Assert
    assert!(result.is_err());
}
