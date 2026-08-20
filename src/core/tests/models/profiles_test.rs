use app_lib::models::profiles::{CreateProfile, UpdateProfile};
use serde_json::json;

mod create_profiles {
    use super::*;

    #[test]
    fn it_defaults_all_fields_to_none_when_payload_is_empty() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: CreateProfile = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.full_name, None);
        assert_eq!(parsed.avatar_url, None);
        assert_eq!(parsed.plan_type, None);
        assert_eq!(parsed.email, None);
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "email": "ada@example.com" });

        // Act
        let parsed: CreateProfile = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.email, Some("ada@example.com".to_string()));
    }
}

mod update_profiles {
    use super::*;

    #[test]
    fn it_defaults_all_fields_to_none_when_payload_is_empty() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: UpdateProfile = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.full_name, None);
        assert_eq!(parsed.avatar_url, None);
        assert_eq!(parsed.plan_type, None);
        assert_eq!(parsed.email, None);
        assert_eq!(parsed.is_banned, None);
        assert_eq!(parsed.ban_reason, None);
        assert_eq!(parsed.banned_until, None);
    }

    #[test]
    fn it_populates_a_field_when_present_in_payload() {
        // Arrange
        let payload = json!({ "email": "ada@example.com" });

        // Act
        let parsed: UpdateProfile = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.email, Some("ada@example.com".to_string()));
    }
}
