use app_lib::repositories::user_test_sessions;
use assert_matches::assert_matches;

use crate::common::builders::{
    default_user_test_session, CreateUserTestSessionBuilder, UpdateUserTestSessionBuilder,
};
use crate::common::fixtures::test_pool;

const OWNER_ID: &str = "owner-1";
const OTHER_USER_ID: &str = "other-user";
const UNKNOWN_ID: &str = "unknown-id";

mod insert_and_find_by_id {
    use super::*;

    #[tokio::test]
    async fn it_finds_the_session_when_owner_looks_it_up() {
        // Arrange
        let pool = test_pool().await;
        let input = CreateUserTestSessionBuilder::default()
            .with_test_type("listening")
            .build();
        let id = user_test_sessions::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");

        // Act
        let found = user_test_sessions::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(Some(session)) if session.test_type == "listening");
    }

    #[tokio::test]
    async fn it_returns_none_when_id_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let found = user_test_sessions::find_by_id(&pool, UNKNOWN_ID, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }

    #[tokio::test]
    async fn it_returns_none_when_looked_up_by_a_different_user() {
        // Arrange
        let pool = test_pool().await;
        let input = default_user_test_session();
        let id = user_test_sessions::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");

        // Act
        let found = user_test_sessions::find_by_id(&pool, &id, OTHER_USER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }

    #[tokio::test]
    async fn it_defaults_attempt_number_to_one_when_not_provided() {
        // Arrange
        let pool = test_pool().await;
        let input = default_user_test_session();
        let id = user_test_sessions::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");

        // Act
        let found = user_test_sessions::find_by_id(&pool, &id, OWNER_ID)
            .await
            .expect("find")
            .expect("present");

        // Assert
        assert_eq!(found.attempt_number, 1);
    }
}

mod find_all {
    use super::*;

    #[tokio::test]
    async fn it_returns_an_empty_list_when_the_user_has_no_sessions() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let all = user_test_sessions::find_all(&pool, OWNER_ID).await;

        // Assert
        assert_matches!(all, Ok(sessions) if sessions.is_empty());
    }

    #[tokio::test]
    async fn it_excludes_sessions_belonging_to_other_users() {
        // Arrange
        let pool = test_pool().await;
        let input = default_user_test_session();
        user_test_sessions::insert(&pool, &input, OTHER_USER_ID)
            .await
            .expect("insert");

        // Act
        let all = user_test_sessions::find_all(&pool, OWNER_ID)
            .await
            .expect("find_all");

        // Assert
        assert!(all.is_empty());
    }
}

mod update {
    use super::*;

    #[tokio::test]
    async fn it_updates_only_the_provided_field() {
        // Arrange
        let pool = test_pool().await;
        let input = default_user_test_session();
        let id = user_test_sessions::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");
        let update = UpdateUserTestSessionBuilder::default()
            .with_status("completed")
            .build();

        // Act
        user_test_sessions::update(&pool, &id, OWNER_ID, &update)
            .await
            .expect("update");
        let found = user_test_sessions::find_by_id(&pool, &id, OWNER_ID)
            .await
            .expect("find")
            .expect("present");

        // Assert
        assert_eq!(found.status, "completed");
    }

    #[tokio::test]
    async fn it_does_not_update_a_session_owned_by_another_user() {
        // Arrange
        let pool = test_pool().await;
        let input = default_user_test_session();
        let id = user_test_sessions::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");
        let update = UpdateUserTestSessionBuilder::default()
            .with_status("completed")
            .build();

        // Act
        user_test_sessions::update(&pool, &id, OTHER_USER_ID, &update)
            .await
            .expect("update");
        let found = user_test_sessions::find_by_id(&pool, &id, OWNER_ID)
            .await
            .expect("find")
            .expect("present");

        // Assert
        assert_eq!(found.status, "in_progress");
    }

    #[tokio::test]
    async fn it_marks_an_abandoned_in_progress_session_as_aborted() {
        // Arrange: an "in_progress" session that was never explicitly closed
        // (e.g. the app crashed or was force-closed mid-test).
        let pool = test_pool().await;
        let input = default_user_test_session();
        let id = user_test_sessions::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");
        let found_before = user_test_sessions::find_by_id(&pool, &id, OWNER_ID)
            .await
            .expect("find")
            .expect("present");
        assert_eq!(found_before.status, "in_progress");

        let update = UpdateUserTestSessionBuilder::default()
            .with_status("aborted")
            .with_last_active_at("2024-01-01T00:00:00Z")
            .build();

        // Act: simulate the abort fallback path (mirrors the frontend's
        // abortSession helper) marking the session terminal instead of
        // deleting it.
        user_test_sessions::update(&pool, &id, OWNER_ID, &update)
            .await
            .expect("update");
        let found_after = user_test_sessions::find_by_id(&pool, &id, OWNER_ID)
            .await
            .expect("find")
            .expect("present");

        // Assert: the session is no longer "in_progress", so it can no
        // longer be picked up as the user's active session.
        assert_eq!(found_after.status, "aborted");
        assert_ne!(found_after.status, "in_progress");
    }
}

mod delete {
    use super::*;

    #[tokio::test]
    async fn it_removes_the_session_when_owner_deletes_it() {
        // Arrange
        let pool = test_pool().await;
        let input = default_user_test_session();
        let id = user_test_sessions::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");

        // Act
        user_test_sessions::delete(&pool, &id, OWNER_ID)
            .await
            .expect("delete");
        let found = user_test_sessions::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }

    #[tokio::test]
    async fn it_succeeds_as_a_no_op_when_the_session_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let result = user_test_sessions::delete(&pool, UNKNOWN_ID, OWNER_ID).await;

        // Assert
        assert!(result.is_ok());
    }
}
