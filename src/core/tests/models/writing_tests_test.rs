use app_lib::models::writing_tests::{CreateWritingTest, UpdateWritingTest};
use serde_json::json;

mod create_writing_tests {
    use super::*;

    #[test]
    fn it_defaults_all_fields_to_none_when_payload_is_empty() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: CreateWritingTest = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.title, None);
        assert_eq!(parsed.status, None);
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "title": "My Essay" });

        // Act
        let parsed: CreateWritingTest = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.title, Some("My Essay".to_string()));
    }
}

mod update_writing_tests {
    use super::*;

    #[test]
    fn it_defaults_all_fields_to_none_when_payload_is_empty() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: UpdateWritingTest = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.title, None);
        assert_eq!(parsed.status, None);
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "title": "My Essay" });

        // Act
        let parsed: UpdateWritingTest = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.title, Some("My Essay".to_string()));
    }
}
