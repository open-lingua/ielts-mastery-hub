use app_lib::models::writing_tasks::{CreateWritingTask, UpdateWritingTask};
use serde_json::json;

mod create_writing_tasks {
    use super::*;

    #[test]
    fn it_defaults_optional_fields_to_none_when_only_required_fields_are_present() {
        // Arrange
        let payload = json!({ "test_id": "test-1" });

        // Act
        let parsed: CreateWritingTask = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.task_number, None);
        assert_eq!(parsed.task_type, None);
        assert_eq!(parsed.title, None);
        assert_eq!(parsed.difficulty, None);
        assert_eq!(parsed.suggested_time, None);
        assert_eq!(parsed.prompt, None);
        assert_eq!(parsed.min_words, None);
        assert_eq!(parsed.max_words, None);
        assert_eq!(parsed.image_url, None);
        assert_eq!(parsed.include_model_answer, None);
        assert_eq!(parsed.model_answer, None);
    }

    #[test]
    fn it_fails_to_deserialize_when_a_required_field_is_missing() {
        // Arrange
        let payload = json!({});

        // Act
        let result = serde_json::from_value::<CreateWritingTask>(payload);

        // Assert
        assert!(result.is_err());
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "test_id": "test-1", "min_words": 200 });

        // Act
        let parsed: CreateWritingTask = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.min_words, Some(200));
    }
}

mod update_writing_tasks {
    use super::*;

    #[test]
    fn it_defaults_all_fields_to_none_when_payload_is_empty() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: UpdateWritingTask = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.task_number, None);
        assert_eq!(parsed.task_type, None);
        assert_eq!(parsed.title, None);
        assert_eq!(parsed.difficulty, None);
        assert_eq!(parsed.suggested_time, None);
        assert_eq!(parsed.prompt, None);
        assert_eq!(parsed.min_words, None);
        assert_eq!(parsed.max_words, None);
        assert_eq!(parsed.image_url, None);
        assert_eq!(parsed.include_model_answer, None);
        assert_eq!(parsed.model_answer, None);
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "min_words": 200 });

        // Act
        let parsed: UpdateWritingTask = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.min_words, Some(200));
    }
}
