use app_lib::models::listening_questions::{CreateListeningQuestion, UpdateListeningQuestion};
use serde_json::json;

mod create_listening_questions {
    use super::*;

    #[test]
    fn it_defaults_optional_fields_to_none_when_only_required_fields_are_present() {
        // Arrange
        let payload = json!({ "group_id": "group-1" });

        // Act
        let parsed: CreateListeningQuestion = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.question_order, None);
        assert_eq!(parsed.text, None);
        assert_eq!(parsed.answer, None);
        assert_eq!(parsed.options, None);
        assert_eq!(parsed.matching_pairs, None);
        assert_eq!(parsed.completion_gaps, None);
        assert_eq!(parsed.accepted_answers, None);
        assert_eq!(parsed.timestamp, None);
    }

    #[test]
    fn it_fails_to_deserialize_when_a_required_field_is_missing() {
        // Arrange
        let payload = json!({});

        // Act
        let result = serde_json::from_value::<CreateListeningQuestion>(payload);

        // Assert
        assert!(result.is_err());
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "group_id": "group-1", "timestamp": "00:01:23" });

        // Act
        let parsed: CreateListeningQuestion = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.timestamp, Some("00:01:23".to_string()));
    }
}

mod update_listening_questions {
    use super::*;

    #[test]
    fn it_defaults_all_fields_to_none_when_payload_is_empty() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: UpdateListeningQuestion = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.question_order, None);
        assert_eq!(parsed.text, None);
        assert_eq!(parsed.answer, None);
        assert_eq!(parsed.options, None);
        assert_eq!(parsed.matching_pairs, None);
        assert_eq!(parsed.completion_gaps, None);
        assert_eq!(parsed.accepted_answers, None);
        assert_eq!(parsed.timestamp, None);
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "timestamp": "00:01:23" });

        // Act
        let parsed: UpdateListeningQuestion = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.timestamp, Some("00:01:23".to_string()));
    }
}
