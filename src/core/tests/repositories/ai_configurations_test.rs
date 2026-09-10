use app_lib::repositories::ai_configurations;
use assert_matches::assert_matches;

use crate::common::fixtures::test_pool;

mod upsert_and_activate {
    use super::*;

    #[tokio::test]
    async fn it_inserts_a_new_provider_as_active() {
        // Arrange
        let pool = test_pool().await;

        // Act
        ai_configurations::upsert_and_activate(&pool, "gemini", "encrypted-blob")
            .await
            .expect("upsert");
        let row = ai_configurations::find_by_provider(&pool, "gemini")
            .await
            .expect("find")
            .expect("present");

        // Assert
        assert!(row.is_active);
        assert_eq!(row.credentials_json, "encrypted-blob");
    }

    #[tokio::test]
    async fn it_deactivates_the_previously_active_provider() {
        // Arrange
        let pool = test_pool().await;
        ai_configurations::upsert_and_activate(&pool, "gemini", "gemini-creds")
            .await
            .expect("upsert gemini");

        // Act
        ai_configurations::upsert_and_activate(&pool, "claude", "claude-creds")
            .await
            .expect("upsert claude");

        // Assert
        let gemini = ai_configurations::find_by_provider(&pool, "gemini")
            .await
            .expect("find gemini")
            .expect("present");
        let claude = ai_configurations::find_by_provider(&pool, "claude")
            .await
            .expect("find claude")
            .expect("present");
        assert!(!gemini.is_active);
        assert!(claude.is_active);
    }

    #[tokio::test]
    async fn it_updates_credentials_and_reactivates_on_a_second_save_for_the_same_provider() {
        // Arrange
        let pool = test_pool().await;
        ai_configurations::upsert_and_activate(&pool, "gemini", "old-creds")
            .await
            .expect("first upsert");
        ai_configurations::upsert_and_activate(&pool, "claude", "claude-creds")
            .await
            .expect("upsert claude");

        // Act
        ai_configurations::upsert_and_activate(&pool, "gemini", "new-creds")
            .await
            .expect("second upsert");

        // Assert
        let gemini = ai_configurations::find_by_provider(&pool, "gemini")
            .await
            .expect("find gemini")
            .expect("present");
        let claude = ai_configurations::find_by_provider(&pool, "claude")
            .await
            .expect("find claude")
            .expect("present");
        assert_eq!(gemini.credentials_json, "new-creds");
        assert!(gemini.is_active);
        assert!(!claude.is_active);
    }
}

mod activate {
    use app_lib::error::AppError;

    use super::*;

    #[tokio::test]
    async fn it_activates_a_provider_without_touching_its_credentials() {
        // Arrange
        let pool = test_pool().await;
        ai_configurations::upsert_and_activate(&pool, "gemini", "gemini-creds")
            .await
            .expect("upsert gemini");
        ai_configurations::upsert_and_activate(&pool, "claude", "claude-creds")
            .await
            .expect("upsert claude (deactivates gemini)");

        // Act
        ai_configurations::activate(&pool, "gemini").await.expect("activate");

        // Assert
        let gemini = ai_configurations::find_by_provider(&pool, "gemini")
            .await
            .expect("find gemini")
            .expect("present");
        let claude = ai_configurations::find_by_provider(&pool, "claude")
            .await
            .expect("find claude")
            .expect("present");
        assert!(gemini.is_active);
        assert_eq!(gemini.credentials_json, "gemini-creds");
        assert!(!claude.is_active);
    }

    #[tokio::test]
    async fn it_is_a_harmless_no_op_when_reactivating_the_already_active_provider() {
        // Arrange
        let pool = test_pool().await;
        ai_configurations::upsert_and_activate(&pool, "gemini", "gemini-creds")
            .await
            .expect("upsert");

        // Act
        let result = ai_configurations::activate(&pool, "gemini").await;

        // Assert
        assert!(result.is_ok());
        let gemini = ai_configurations::find_by_provider(&pool, "gemini")
            .await
            .expect("find")
            .expect("present");
        assert!(gemini.is_active);
    }

    #[tokio::test]
    async fn it_returns_not_found_when_the_provider_has_no_stored_row() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let result = ai_configurations::activate(&pool, "gemini").await;

        // Assert
        assert_matches!(result, Err(AppError::NotFound(id)) if id == "gemini");
    }

    #[tokio::test]
    async fn it_does_not_activate_the_target_when_it_has_no_stored_row() {
        // Arrange
        let pool = test_pool().await;
        ai_configurations::upsert_and_activate(&pool, "claude", "claude-creds")
            .await
            .expect("upsert claude");

        // Act
        let _ = ai_configurations::activate(&pool, "gemini").await;

        // Assert: claude (the only real row) remains active since the transaction
        // rolled back after failing to find the target row.
        let claude = ai_configurations::find_by_provider(&pool, "claude")
            .await
            .expect("find claude")
            .expect("present");
        assert!(claude.is_active);
    }
}

mod find_active {
    use super::*;

    #[tokio::test]
    async fn it_returns_none_when_no_provider_is_active() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let active = ai_configurations::find_active(&pool).await;

        // Assert
        assert_matches!(active, Ok(None));
    }

    #[tokio::test]
    async fn it_returns_the_single_active_provider() {
        // Arrange
        let pool = test_pool().await;
        ai_configurations::upsert_and_activate(&pool, "gemini", "gemini-creds")
            .await
            .expect("upsert");

        // Act
        let active = ai_configurations::find_active(&pool)
            .await
            .expect("find_active")
            .expect("present");

        // Assert
        assert_eq!(active.provider_id, "gemini");
    }
}

mod find_all {
    use super::*;

    #[tokio::test]
    async fn it_returns_an_empty_list_when_no_providers_are_configured() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let all = ai_configurations::find_all(&pool).await;

        // Assert
        assert_matches!(all, Ok(rows) if rows.is_empty());
    }

    #[tokio::test]
    async fn it_returns_every_configured_provider() {
        // Arrange
        let pool = test_pool().await;
        ai_configurations::upsert_and_activate(&pool, "gemini", "gemini-creds")
            .await
            .expect("upsert gemini");
        ai_configurations::upsert_and_activate(&pool, "claude", "claude-creds")
            .await
            .expect("upsert claude");

        // Act
        let all = ai_configurations::find_all(&pool).await.expect("find_all");

        // Assert
        assert_eq!(all.len(), 2);
    }
}

mod clear {
    use super::*;

    #[tokio::test]
    async fn it_resets_credentials_and_active_state_for_the_provider() {
        // Arrange
        let pool = test_pool().await;
        ai_configurations::upsert_and_activate(&pool, "gemini", "gemini-creds")
            .await
            .expect("upsert");

        // Act
        ai_configurations::clear(&pool, "gemini").await.expect("clear");

        // Assert
        let row = ai_configurations::find_by_provider(&pool, "gemini")
            .await
            .expect("find")
            .expect("present");
        assert_eq!(row.credentials_json, "");
        assert!(!row.is_active);
    }

    #[tokio::test]
    async fn it_succeeds_as_a_no_op_when_the_provider_has_no_row() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let result = ai_configurations::clear(&pool, "gemini").await;

        // Assert
        assert!(result.is_ok());
    }
}
