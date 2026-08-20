use app_lib::models::listening_sections::{CreateListeningSection, UpdateListeningSection};
use serde_json::json;

mod create_listening_sections {
    use super::*;

    #[test]
    fn it_defaults_optional_fields_to_none_when_only_required_fields_are_present() {
        // Arrange
        let payload = json!({ "test_id": "test-1" });

        // Act
        let parsed: CreateListeningSection = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.section_number, None);
        assert_eq!(parsed.title, None);
        assert_eq!(parsed.transcript, None);
        assert_eq!(parsed.audio_url, None);
    }

    #[test]
    fn it_fails_to_deserialize_when_a_required_field_is_missing() {
        // Arrange
        let payload = json!({});

        // Act
        let result = serde_json::from_value::<CreateListeningSection>(payload);

        // Assert
        assert!(result.is_err());
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "test_id": "test-1", "transcript": "Hello, welcome." });

        // Act
        let parsed: CreateListeningSection = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.transcript, Some("Hello, welcome.".to_string()));
    }
}

mod update_listening_sections {
    use super::*;

    #[test]
    fn it_defaults_all_fields_to_none_when_payload_is_empty() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: UpdateListeningSection = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.section_number, None);
        assert_eq!(parsed.title, None);
        assert_eq!(parsed.transcript, None);
        assert_eq!(parsed.audio_url, None);
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "transcript": "Hello, welcome." });

        // Act
        let parsed: UpdateListeningSection = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.transcript, Some("Hello, welcome.".to_string()));
    }
}
