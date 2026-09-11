use app_lib::models::ai_configurations::{AiConfigurationSummary, SaveAiConfiguration};
use serde_json::json;

mod ai_configuration_summary {
    use super::*;

    #[test]
    fn it_serializes_fields_as_camel_case_and_excludes_credentials() {
        // Arrange
        let summary = AiConfigurationSummary {
            provider_id: "gemini".to_string(),
            is_active: true,
            configured: true,
            updated_at: "2026-01-01T00:00:00Z".to_string(),
        };

        // Act
        let value = serde_json::to_value(&summary).expect("serialize");

        // Assert
        assert_eq!(
            value,
            json!({
                "providerId": "gemini",
                "isActive": true,
                "configured": true,
                "updatedAt": "2026-01-01T00:00:00Z"
            })
        );
    }
}

mod save_ai_configuration {
    use super::*;

    #[test]
    fn it_deserializes_provider_id_and_credentials_map() {
        // Arrange
        let payload = json!({
            "provider_id": "gemini",
            "credentials": { "apiKey": "sk-test" }
        });

        // Act
        let parsed: SaveAiConfiguration = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.provider_id, "gemini");
        assert_eq!(
            parsed.credentials.get("apiKey"),
            Some(&"sk-test".to_string())
        );
    }
}
