use app_lib::database::Db;
use app_lib::models::practice_library::PracticeTestRow;
use app_lib::repositories::{
    listening_tests, practice_library, reading_tests, user_test_sessions, writing_tests,
};

use crate::common::builders::{
    CreateListeningTestBuilder, CreateReadingTestBuilder, CreateUserTestSessionBuilder,
    CreateWritingTestBuilder,
};
use crate::common::fixtures::test_pool;

const OWNER_ID: &str = "owner-1";

async fn given_published_reading_test(pool: &Db, title: &str) -> String {
    let input = CreateReadingTestBuilder::default()
        .with_title(title)
        .with_status("published")
        .build();
    reading_tests::insert(pool, &input, OWNER_ID)
        .await
        .expect("insert reading test")
}

async fn given_published_writing_test(pool: &Db, title: &str) -> String {
    let input = CreateWritingTestBuilder::default()
        .with_title(title)
        .with_status("published")
        .build();
    writing_tests::insert(pool, &input, OWNER_ID)
        .await
        .expect("insert writing test")
}

async fn given_published_listening_test(pool: &Db, title: &str) -> String {
    let input = CreateListeningTestBuilder::default()
        .with_title(title)
        .with_status("published")
        .build();
    listening_tests::insert(pool, &input, OWNER_ID)
        .await
        .expect("insert listening test")
}

mod count_published {
    use super::*;

    #[tokio::test]
    async fn it_counts_only_published_reading_tests() {
        // Arrange
        let pool = test_pool().await;
        given_published_reading_test(&pool, "Published One").await;
        let draft = CreateReadingTestBuilder::default()
            .with_status("draft")
            .build();
        reading_tests::insert(&pool, &draft, OWNER_ID)
            .await
            .expect("insert draft");

        // Act
        let count = practice_library::count_reading_published(&pool).await;

        // Assert
        assert_eq!(count.expect("count"), 1);
    }

    #[tokio::test]
    async fn it_returns_zero_when_no_writing_tests_are_published() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let count = practice_library::count_writing_published(&pool).await;

        // Assert
        assert_eq!(count.expect("count"), 0);
    }

    #[tokio::test]
    async fn it_counts_published_listening_tests() {
        // Arrange
        let pool = test_pool().await;
        given_published_listening_test(&pool, "Published Listening").await;

        // Act
        let count = practice_library::count_listening_published(&pool).await;

        // Assert
        assert_eq!(count.expect("count"), 1);
    }
}

mod find_all_page {
    use super::*;

    #[tokio::test]
    async fn it_returns_an_empty_page_and_zero_total_when_nothing_is_published() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let (page, total) = practice_library::find_all_page(&pool, 0, 10)
            .await
            .expect("find_all_page");

        // Assert
        assert!(page.is_empty());
        assert_eq!(total, 0);
    }

    #[tokio::test]
    async fn it_merges_all_three_modules_into_a_single_page() {
        // Arrange
        let pool = test_pool().await;
        given_published_reading_test(&pool, "Reading Test").await;
        given_published_writing_test(&pool, "Writing Test").await;
        given_published_listening_test(&pool, "Listening Test").await;

        // Act
        let (page, total) = practice_library::find_all_page(&pool, 0, 10)
            .await
            .expect("find_all_page");

        // Assert
        assert_eq!(total, 3);
        assert_eq!(page.len(), 3);
    }

    #[tokio::test]
    async fn it_slices_the_requested_page_boundary() {
        // Arrange
        let pool = test_pool().await;
        given_published_reading_test(&pool, "First").await;
        given_published_writing_test(&pool, "Second").await;
        given_published_listening_test(&pool, "Third").await;

        // Act
        let (page, total) = practice_library::find_all_page(&pool, 2, 10)
            .await
            .expect("find_all_page");

        // Assert
        assert_eq!(total, 3);
        assert_eq!(page.len(), 1);
    }

    #[tokio::test]
    async fn it_returns_an_empty_page_when_the_offset_is_beyond_the_total() {
        // Arrange
        let pool = test_pool().await;
        given_published_reading_test(&pool, "Only Test").await;

        // Act
        let (page, total) = practice_library::find_all_page(&pool, 10, 10)
            .await
            .expect("find_all_page");

        // Assert
        assert_eq!(total, 1);
        assert!(page.is_empty());
    }
}

mod merge_sessions {
    use super::*;

    fn row(id: &str, module: &str) -> PracticeTestRow {
        PracticeTestRow {
            id: id.to_string(),
            title: "Some Test".to_string(),
            module: module.to_string(),
            difficulty: "7".to_string(),
            duration: "40 mins".to_string(),
            created_at: "2024-01-01T00:00:00Z".to_string(),
        }
    }

    #[tokio::test]
    async fn it_reports_not_started_when_the_user_has_no_session_for_the_test() {
        // Arrange
        let pool = test_pool().await;
        let rows = vec![row("test-1", "reading")];

        // Act
        let cards = practice_library::merge_sessions(&pool, OWNER_ID, rows)
            .await
            .expect("merge_sessions");

        // Assert
        assert_eq!(cards[0].status, "not_started");
        assert_eq!(cards[0].progress_percent, 0);
        assert!(cards[0].session_id.is_none());
    }

    #[tokio::test]
    async fn it_merges_the_matching_session_status_and_progress() {
        // Arrange
        let pool = test_pool().await;
        let session_input = CreateUserTestSessionBuilder::default()
            .with_test_id("test-1")
            .with_test_type("reading")
            .build();
        let session_id = user_test_sessions::insert(&pool, &session_input, OWNER_ID)
            .await
            .expect("insert session");
        let update = app_lib::models::user_test_sessions::UpdateUserTestSession {
            status: Some("completed".to_string()),
            progress_percent: Some(100),
            score_band: None,
            answers: None,
            feedback_data: None,
            completed_at: None,
            last_active_at: None,
        };
        user_test_sessions::update(&pool, &session_id, OWNER_ID, &update)
            .await
            .expect("update session");
        let rows = vec![row("test-1", "reading")];

        // Act
        let cards = practice_library::merge_sessions(&pool, OWNER_ID, rows)
            .await
            .expect("merge_sessions");

        // Assert
        assert_eq!(cards[0].status, "completed");
        assert_eq!(cards[0].progress_percent, 100);
        assert_eq!(cards[0].session_id, Some(session_id));
    }

    #[tokio::test]
    async fn it_picks_the_session_with_the_highest_attempt_number_when_several_exist() {
        // Arrange
        let pool = test_pool().await;
        let first = CreateUserTestSessionBuilder::default()
            .with_test_id("test-1")
            .with_test_type("reading")
            .with_attempt_number(1)
            .build();
        user_test_sessions::insert(&pool, &first, OWNER_ID)
            .await
            .expect("insert first");

        let second = CreateUserTestSessionBuilder::default()
            .with_test_id("test-1")
            .with_test_type("reading")
            .with_attempt_number(2)
            .build();
        let latest_id = user_test_sessions::insert(&pool, &second, OWNER_ID)
            .await
            .expect("insert second");
        let rows = vec![row("test-1", "reading")];

        // Act
        let cards = practice_library::merge_sessions(&pool, OWNER_ID, rows)
            .await
            .expect("merge_sessions");

        // Assert
        assert_eq!(cards[0].session_id, Some(latest_id));
    }

    #[tokio::test]
    async fn it_only_merges_sessions_matching_both_module_and_test_id() {
        // Arrange
        let pool = test_pool().await;
        let other_module_session = CreateUserTestSessionBuilder::default()
            .with_test_id("test-1")
            .with_test_type("listening")
            .build();
        user_test_sessions::insert(&pool, &other_module_session, OWNER_ID)
            .await
            .expect("insert");
        let rows = vec![row("test-1", "reading")];

        // Act
        let cards = practice_library::merge_sessions(&pool, OWNER_ID, rows)
            .await
            .expect("merge_sessions");

        // Assert
        assert_eq!(cards[0].status, "not_started");
    }
}
