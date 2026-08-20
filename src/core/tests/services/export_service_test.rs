use app_lib::error::AppError;
use app_lib::repositories::{reading_passages, reading_tests, writing_tasks, writing_tests};
use app_lib::services::export_service;
use assert_matches::assert_matches;
use zip::ZipArchive;

use crate::common::builders::{CreateReadingPassageBuilder, CreateReadingTestBuilder, CreateWritingTaskBuilder, CreateWritingTestBuilder, default_reading_test};
use crate::common::fixtures::test_pool;

const OWNER_ID: &str = "owner-1";
const OTHER_USER_ID: &str = "other-user";
const UNKNOWN_ID: &str = "unknown-id";

mod build_export {
    use super::*;

    #[tokio::test]
    async fn it_builds_a_zip_for_a_reading_test() {
        // Arrange
        let pool = test_pool().await;
        let test_input = CreateReadingTestBuilder::default().with_title("Ocean Life").build();
        let test_id = reading_tests::insert(&pool, &test_input, OWNER_ID).await.expect("insert test");
        let passage_input = CreateReadingPassageBuilder::default().with_test_id(&test_id).build();
        reading_passages::insert(&pool, &passage_input, OWNER_ID).await.expect("insert passage");

        // Act
        let built = export_service::build_export(&pool, OWNER_ID, "reading", &test_id).await;

        // Assert
        let built = built.expect("build_export should succeed");
        assert!(built.file_name.starts_with("ielts-reading-ocean-life"));
    }

    #[tokio::test]
    async fn it_builds_a_zip_whose_archive_contains_the_export_json() {
        // Arrange
        let pool = test_pool().await;
        let test_input = CreateReadingTestBuilder::default().with_title("Ocean Life").build();
        let test_id = reading_tests::insert(&pool, &test_input, OWNER_ID).await.expect("insert test");
        let passage_input = CreateReadingPassageBuilder::default().with_test_id(&test_id).build();
        reading_passages::insert(&pool, &passage_input, OWNER_ID).await.expect("insert passage");
        let built = export_service::build_export(&pool, OWNER_ID, "reading", &test_id).await.expect("build_export");

        // Act
        let mut archive = ZipArchive::new(std::io::Cursor::new(built.zip_bytes)).expect("open zip");

        // Assert
        assert_eq!(archive.len(), 1);
    }

    #[tokio::test]
    async fn it_builds_a_zip_for_a_writing_test() {
        // Arrange
        let pool = test_pool().await;
        let test_input = CreateWritingTestBuilder::default().with_title("Bar Chart Essays").build();
        let test_id = writing_tests::insert(&pool, &test_input, OWNER_ID).await.expect("insert test");
        let task_input = CreateWritingTaskBuilder::default().with_test_id(&test_id).build();
        writing_tasks::insert(&pool, &task_input, OWNER_ID).await.expect("insert task");

        // Act
        let built = export_service::build_export(&pool, OWNER_ID, "writing", &test_id).await;

        // Assert
        let built = built.expect("build_export should succeed");
        assert!(built.file_name.starts_with("ielts-writing-bar-chart-essays"));
    }

    #[tokio::test]
    async fn it_builds_a_zip_for_a_listening_test() {
        // Arrange
        let pool = test_pool().await;
        let test_input = app_lib::models::listening_tests::CreateListeningTest {
            title: Some("Airport Chatter".to_string()),
            difficulty: None,
            duration: None,
            status: None,
        };
        let test_id = app_lib::repositories::listening_tests::insert(&pool, &test_input, OWNER_ID)
            .await
            .expect("insert test");

        // Act
        let built = export_service::build_export(&pool, OWNER_ID, "listening", &test_id).await;

        // Assert
        let built = built.expect("build_export should succeed");
        assert!(built.file_name.starts_with("ielts-listening-airport-chatter"));
    }

    #[tokio::test]
    async fn it_rejects_an_unknown_export_kind() {
        // Arrange
        let pool = test_pool().await;
        let test_input = default_reading_test();
        let test_id = reading_tests::insert(&pool, &test_input, OWNER_ID).await.expect("insert test");

        // Act
        let result = export_service::build_export(&pool, OWNER_ID, "speaking", &test_id).await;

        // Assert
        assert_matches!(result, Err(AppError::Validation(message)) if message.contains("Unknown export kind"));
    }

    #[tokio::test]
    async fn it_returns_not_found_when_the_test_id_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let result = export_service::build_export(&pool, OWNER_ID, "reading", UNKNOWN_ID).await;

        // Assert
        assert_matches!(result, Err(AppError::NotFound(_)));
    }

    #[tokio::test]
    async fn it_returns_not_found_when_a_non_owner_exports_a_draft_test() {
        // Arrange
        let pool = test_pool().await;
        let test_input = CreateReadingTestBuilder::default().with_status("draft").build();
        let test_id = reading_tests::insert(&pool, &test_input, OWNER_ID).await.expect("insert test");

        // Act
        let result = export_service::build_export(&pool, OTHER_USER_ID, "reading", &test_id).await;

        // Assert
        assert_matches!(result, Err(AppError::NotFound(_)));
    }
}

mod default_export_dir {
    use super::*;

    #[test]
    fn it_appends_downloads_to_the_home_directory() {
        // Arrange
        let home = std::env::var("HOME").expect("HOME must be set for this test to be meaningful");

        // Act
        let dir = export_service::default_export_dir();

        // Assert
        assert_eq!(dir, Some(std::path::PathBuf::from(home).join("Downloads")));
    }
}
