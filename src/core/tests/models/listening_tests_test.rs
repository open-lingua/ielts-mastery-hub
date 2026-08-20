use app_lib::models::listening_tests::{CreateListeningTest, UpdateListeningTest};
use serde_json::json;

mod create_listening_tests {
    use super::*;

    #[test]
    fn it_defaults_all_fields_to_none_when_payload_is_empty() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: CreateListeningTest = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.title, None);
        assert_eq!(parsed.difficulty, None);
        assert_eq!(parsed.duration, None);
        assert_eq!(parsed.status, None);
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "duration": "45 mins" });

        // Act
        let parsed: CreateListeningTest = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.duration, Some("45 mins".to_string()));
    }
}

mod update_listening_tests {
    use super::*;

    #[test]
    fn it_defaults_all_fields_to_none_when_payload_is_empty() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: UpdateListeningTest = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.title, None);
        assert_eq!(parsed.difficulty, None);
        assert_eq!(parsed.duration, None);
        assert_eq!(parsed.status, None);
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "duration": "45 mins" });

        // Act
        let parsed: UpdateListeningTest = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.duration, Some("45 mins".to_string()));
    }
}
