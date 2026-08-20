use app_lib::models::user_test_sessions::{CreateUserTestSession, UpdateUserTestSession};
use serde_json::json;

mod create_user_test_sessions {
    use super::*;

    #[test]
    fn it_defaults_optional_fields_to_none_when_only_required_fields_are_present() {
        // Arrange
        let payload = json!({ "test_id": "test-1", "test_type": "reading" });

        // Act
        let parsed: CreateUserTestSession = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.attempt_number, None);
    }

    #[test]
    fn it_fails_to_deserialize_when_a_required_field_is_missing() {
        // Arrange
        let payload = json!({});

        // Act
        let result = serde_json::from_value::<CreateUserTestSession>(payload);

        // Assert
        assert!(result.is_err());
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "test_id": "test-1", "test_type": "reading", "attempt_number": 2 });

        // Act
        let parsed: CreateUserTestSession = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.attempt_number, Some(2));
    }
}

mod update_user_test_sessions {
    use super::*;

    #[test]
    fn it_defaults_all_fields_to_none_when_payload_is_empty() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: UpdateUserTestSession = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.status, None);
        assert_eq!(parsed.progress_percent, None);
        assert_eq!(parsed.score_band, None);
        assert_eq!(parsed.answers, None);
        assert_eq!(parsed.feedback_data, None);
        assert_eq!(parsed.completed_at, None);
        assert_eq!(parsed.last_active_at, None);
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "status": "changed" });

        // Act
        let parsed: UpdateUserTestSession = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.status, Some("changed".to_string()));
    }
}
