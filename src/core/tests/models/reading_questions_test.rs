use app_lib::models::reading_questions::{CreateReadingQuestion, UpdateReadingQuestion};
use serde_json::json;

mod create_reading_questions {
    use super::*;

    #[test]
    fn it_defaults_optional_fields_to_none_when_only_required_fields_are_present() {
        // Arrange
        let payload = json!({ "group_id": "group-1" });

        // Act
        let parsed: CreateReadingQuestion = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.question_order, None);
        assert_eq!(parsed.text, None);
        assert_eq!(parsed.answer, None);
        assert_eq!(parsed.options, None);
        assert_eq!(parsed.matching_pairs, None);
        assert_eq!(parsed.completion_gaps, None);
        assert_eq!(parsed.accepted_answers, None);
    }

    #[test]
    fn it_fails_to_deserialize_when_a_required_field_is_missing() {
        // Arrange
        let payload = json!({});

        // Act
        let result = serde_json::from_value::<CreateReadingQuestion>(payload);

        // Assert
        assert!(result.is_err());
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "group_id": "group-1", "text": "What year?" });

        // Act
        let parsed: CreateReadingQuestion = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.text, Some("What year?".to_string()));
    }
}

mod update_reading_questions {
    use super::*;

    #[test]
    fn it_defaults_all_fields_to_none_when_payload_is_empty() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: UpdateReadingQuestion = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.question_order, None);
        assert_eq!(parsed.text, None);
        assert_eq!(parsed.answer, None);
        assert_eq!(parsed.options, None);
        assert_eq!(parsed.matching_pairs, None);
        assert_eq!(parsed.completion_gaps, None);
        assert_eq!(parsed.accepted_answers, None);
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "text": "What year?" });

        // Act
        let parsed: UpdateReadingQuestion = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.text, Some("What year?".to_string()));
    }
}
