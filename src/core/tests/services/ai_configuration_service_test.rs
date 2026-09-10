use app_lib::models::ai_configurations::SaveAiConfiguration;
use app_lib::services::ai_configuration_service as service;
use app_lib::state::AiConfigKey;
use assert_matches::assert_matches;

use crate::common::fixtures::test_pool;

fn test_key() -> AiConfigKey {
    AiConfigKey([1u8; 32])
}

fn input(provider_id: &str, credentials: &[(&str, &str)]) -> SaveAiConfiguration {
    SaveAiConfiguration {
        provider_id: provider_id.to_string(),
        credentials: credentials
            .iter()
            .map(|(k, v)| (k.to_string(), v.to_string()))
            .collect(),
    }
}

mod save_configuration {
    use super::*;

    #[tokio::test]
    async fn it_rejects_an_unknown_provider() {
        // Arrange
        let pool = test_pool().await;
        let key = test_key();

        // Act
        let result = service::save_configuration(&pool, &key, &input("unknown", &[])).await;

        // Assert
        assert_matches!(result, Err(app_lib::error::AppError::Validation(_)));
    }

    #[tokio::test]
    async fn it_rejects_missing_required_fields() {
        // Arrange
        let pool = test_pool().await;
        let key = test_key();

        // Act
        let result = service::save_configuration(&pool, &key, &input("gemini", &[])).await;

        // Assert
        assert_matches!(result, Err(app_lib::error::AppError::Validation(_)));
    }

    #[tokio::test]
    async fn it_rejects_blank_required_fields() {
        // Arrange
        let pool = test_pool().await;
        let key = test_key();

        // Act
        let result = service::save_configuration(&pool, &key, &input("gemini", &[("apiKey", "   ")])).await;

        // Assert
        assert_matches!(result, Err(app_lib::error::AppError::Validation(_)));
    }

    #[tokio::test]
    async fn it_saves_a_valid_configuration_and_marks_it_active_and_configured() {
        // Arrange
        let pool = test_pool().await;
        let key = test_key();

        // Act
        let summary = service::save_configuration(&pool, &key, &input("gemini", &[("apiKey", "sk-real")]))
            .await
            .expect("save");

        // Assert
        assert_eq!(summary.provider_id, "gemini");
        assert!(summary.is_active);
        assert!(summary.configured);
    }

    #[tokio::test]
    async fn it_only_leaves_one_provider_active_after_saving_a_second_one() {
        // Arrange
        let pool = test_pool().await;
        let key = test_key();
        service::save_configuration(&pool, &key, &input("gemini", &[("apiKey", "sk-real")]))
            .await
            .expect("save gemini");

        // Act
        service::save_configuration(&pool, &key, &input("claude", &[("apiKey", "sk-claude")]))
            .await
            .expect("save claude");

        // Assert
        let all = service::list_configurations(&pool, &key).await.expect("list");
        let active: Vec<_> = all.iter().filter(|c| c.is_active).collect();
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].provider_id, "claude");
    }

    #[tokio::test]
    async fn it_round_trips_credentials_through_encryption_for_get_active_credentials() {
        // Arrange
        let pool = test_pool().await;
        let key = test_key();
        service::save_configuration(&pool, &key, &input("chatgpt", &[("apiKey", "sk-secret")]))
            .await
            .expect("save");

        // Act
        let active = service::get_active_credentials(&pool, &key)
            .await
            .expect("get_active_credentials")
            .expect("some provider active");

        // Assert
        assert_eq!(active.0, "chatgpt");
        assert_eq!(active.1.get("apiKey"), Some(&"sk-secret".to_string()));
    }
}

mod list_configurations {
    use super::*;

    #[tokio::test]
    async fn it_returns_an_empty_list_when_nothing_is_configured() {
        // Arrange
        let pool = test_pool().await;
        let key = test_key();

        // Act
        let all = service::list_configurations(&pool, &key).await;

        // Assert
        assert_matches!(all, Ok(rows) if rows.is_empty());
    }
}

mod delete_configuration {
    use super::*;

    #[tokio::test]
    async fn it_rejects_an_unknown_provider() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let result = service::delete_configuration(&pool, "unknown").await;

        // Assert
        assert_matches!(result, Err(app_lib::error::AppError::Validation(_)));
    }

    #[tokio::test]
    async fn it_clears_a_configured_providers_credentials() {
        // Arrange
        let pool = test_pool().await;
        let key = test_key();
        service::save_configuration(&pool, &key, &input("gemini", &[("apiKey", "sk-real")]))
            .await
            .expect("save");

        // Act
        service::delete_configuration(&pool, "gemini").await.expect("delete");

        // Assert
        let all = service::list_configurations(&pool, &key).await.expect("list");
        let gemini = all.iter().find(|c| c.provider_id == "gemini").expect("present");
        assert!(!gemini.configured);
        assert!(!gemini.is_active);
    }
}

mod get_active_credentials {
    use super::*;

    #[tokio::test]
    async fn it_returns_none_when_no_provider_is_active() {
        // Arrange
        let pool = test_pool().await;
        let key = test_key();

        // Act
        let active = service::get_active_credentials(&pool, &key).await;

        // Assert
        assert_matches!(active, Ok(None));
    }
}

mod activate_configuration {
    use super::*;

    #[tokio::test]
    async fn it_rejects_an_unknown_provider() {
        // Arrange
        let pool = test_pool().await;
        let key = test_key();

        // Act
        let result = service::activate_configuration(&pool, &key, "unknown").await;

        // Assert
        assert_matches!(result, Err(app_lib::error::AppError::Validation(_)));
    }

    #[tokio::test]
    async fn it_rejects_a_provider_with_no_stored_row() {
        // Arrange
        let pool = test_pool().await;
        let key = test_key();

        // Act
        let result = service::activate_configuration(&pool, &key, "gemini").await;

        // Assert
        assert_matches!(result, Err(app_lib::error::AppError::NotFound(_)));
    }

    #[tokio::test]
    async fn it_rejects_a_provider_whose_stored_credentials_are_incomplete() {
        // Arrange
        let pool = test_pool().await;
        let key = test_key();
        service::save_configuration(&pool, &key, &input("gemini", &[("apiKey", "sk-real")]))
            .await
            .expect("save gemini");
        service::delete_configuration(&pool, "gemini").await.expect("clear gemini");

        // Act
        let result = service::activate_configuration(&pool, &key, "gemini").await;

        // Assert
        assert_matches!(result, Err(app_lib::error::AppError::Validation(_)));
    }

    #[tokio::test]
    async fn it_reactivates_a_previously_configured_provider_and_deactivates_the_active_one() {
        // Arrange
        let pool = test_pool().await;
        let key = test_key();
        service::save_configuration(&pool, &key, &input("gemini", &[("apiKey", "sk-real")]))
            .await
            .expect("save gemini");
        service::save_configuration(&pool, &key, &input("claude", &[("apiKey", "sk-claude")]))
            .await
            .expect("save claude (deactivates gemini)");

        // Act
        let summary = service::activate_configuration(&pool, &key, "gemini")
            .await
            .expect("activate gemini");

        // Assert
        assert_eq!(summary.provider_id, "gemini");
        assert!(summary.is_active);
        assert!(summary.configured);

        let all = service::list_configurations(&pool, &key).await.expect("list");
        let active: Vec<_> = all.iter().filter(|c| c.is_active).collect();
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].provider_id, "gemini");
    }
}
