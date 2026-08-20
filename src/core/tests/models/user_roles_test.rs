use app_lib::models::user_roles::{CreateUserRole, UpdateUserRole, UserRole};
use serde_json::json;

const USER_ID: &str = "user-1";
const ROLE: &str = "admin";

mod user_role_row {
    use super::*;

    #[test]
    fn it_round_trips_through_json() {
        // Arrange
        let row = UserRole {
            id: "role-1".to_string(),
            user_id: USER_ID.to_string(),
            role: ROLE.to_string(),
            created_at: "2024-01-01T00:00:00Z".to_string(),
        };

        // Act
        let value = serde_json::to_value(&row).expect("serialize");
        let parsed: UserRole = serde_json::from_value(value).expect("deserialize");

        // Assert
        assert_eq!(parsed.user_id, USER_ID);
        assert_eq!(parsed.role, ROLE);
    }
}

mod create_user_role {
    use super::*;

    #[test]
    fn it_deserializes_both_required_fields_when_present() {
        // Arrange
        let payload = json!({ "user_id": USER_ID, "role": ROLE });

        // Act
        let parsed: CreateUserRole = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.user_id, USER_ID);
        assert_eq!(parsed.role, ROLE);
    }

    #[test]
    fn it_fails_to_deserialize_when_role_is_missing() {
        // Arrange
        let payload = json!({ "user_id": USER_ID });

        // Act
        let result = serde_json::from_value::<CreateUserRole>(payload);

        // Assert
        assert!(result.is_err());
    }

    #[test]
    fn it_fails_to_deserialize_when_user_id_is_missing() {
        // Arrange
        let payload = json!({ "role": ROLE });

        // Act
        let result = serde_json::from_value::<CreateUserRole>(payload);

        // Assert
        assert!(result.is_err());
    }
}

mod update_user_role {
    use super::*;

    #[test]
    fn it_defaults_role_to_none_when_payload_is_empty() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: UpdateUserRole = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.role, None);
    }

    #[test]
    fn it_populates_role_when_present_in_payload() {
        // Arrange
        let payload = json!({ "role": ROLE });

        // Act
        let parsed: UpdateUserRole = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.role, Some(ROLE.to_string()));
    }
}
