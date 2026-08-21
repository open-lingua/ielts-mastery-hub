use app_lib::models::reading_question_groups::{
    CreateReadingQuestionGroup, UpdateReadingQuestionGroup,
};
use serde_json::json;

mod create_reading_question_groups {
    use super::*;

    #[test]
    fn it_defaults_optional_fields_to_none_when_only_required_fields_are_present() {
        // Arrange
        let payload = json!({ "passage_id": "passage-1" });

        // Act
        let parsed: CreateReadingQuestionGroup =
            serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.group_order, None);
        assert_eq!(parsed.question_type, None);
        assert_eq!(parsed.instructions, None);
        assert_eq!(parsed.word_limit, None);
        assert_eq!(parsed.has_word_bank, None);
        assert_eq!(parsed.word_bank, None);
        assert_eq!(parsed.sequential_order, None);
        assert_eq!(parsed.multiple_selection, None);
        assert_eq!(parsed.select_count, None);
    }

    #[test]
    fn it_fails_to_deserialize_when_a_required_field_is_missing() {
        // Arrange
        let payload = json!({});

        // Act
        let result = serde_json::from_value::<CreateReadingQuestionGroup>(payload);

        // Assert
        assert!(result.is_err());
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "passage_id": "passage-1", "question_type": "matching-headings" });

        // Act
        let parsed: CreateReadingQuestionGroup =
            serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.question_type, Some("matching-headings".to_string()));
    }
}

mod update_reading_question_groups {
    use super::*;

    #[test]
    fn it_defaults_all_fields_to_none_when_payload_is_empty() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: UpdateReadingQuestionGroup =
            serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.group_order, None);
        assert_eq!(parsed.question_type, None);
        assert_eq!(parsed.instructions, None);
        assert_eq!(parsed.word_limit, None);
        assert_eq!(parsed.has_word_bank, None);
        assert_eq!(parsed.word_bank, None);
        assert_eq!(parsed.sequential_order, None);
        assert_eq!(parsed.multiple_selection, None);
        assert_eq!(parsed.select_count, None);
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "question_type": "matching-headings" });

        // Act
        let parsed: UpdateReadingQuestionGroup =
            serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.question_type, Some("matching-headings".to_string()));
    }
}
