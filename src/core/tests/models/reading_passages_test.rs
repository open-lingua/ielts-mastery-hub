use app_lib::models::reading_passages::{CreateReadingPassage, UpdateReadingPassage};
use serde_json::json;

mod create_reading_passages {
    use super::*;

    #[test]
    fn it_defaults_optional_fields_to_none_when_only_required_fields_are_present() {
        // Arrange
        let payload = json!({ "test_id": "test-1" });

        // Act
        let parsed: CreateReadingPassage = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.passage_number, None);
        assert_eq!(parsed.title, None);
        assert_eq!(parsed.content, None);
        assert_eq!(parsed.notes, None);
    }

    #[test]
    fn it_fails_to_deserialize_when_a_required_field_is_missing() {
        // Arrange
        let payload = json!({});

        // Act
        let result = serde_json::from_value::<CreateReadingPassage>(payload);

        // Assert
        assert!(result.is_err());
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "test_id": "test-1", "title": "Climate Change" });

        // Act
        let parsed: CreateReadingPassage = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.title, Some("Climate Change".to_string()));
    }
}

mod update_reading_passages {
    use super::*;

    #[test]
    fn it_defaults_all_fields_to_none_when_payload_is_empty() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: UpdateReadingPassage = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.passage_number, None);
        assert_eq!(parsed.title, None);
        assert_eq!(parsed.content, None);
        assert_eq!(parsed.notes, None);
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "title": "Climate Change" });

        // Act
        let parsed: UpdateReadingPassage = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.title, Some("Climate Change".to_string()));
    }
}
