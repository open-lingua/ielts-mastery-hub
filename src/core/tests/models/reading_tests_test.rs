use app_lib::models::reading_tests::{CreateReadingTest, ReadingTest, UpdateReadingTest};
use serde_json::json;

const TEST_ID: &str = "test-1";
const CREATED_BY: &str = "user-1";
const TITLE: &str = "Climate Change";

fn default_reading_test_row() -> ReadingTest {
    ReadingTest {
        id: TEST_ID.to_string(),
        created_by: CREATED_BY.to_string(),
        title: TITLE.to_string(),
        test_type: "Academic".to_string(),
        difficulty: "7".to_string(),
        duration: "60 mins".to_string(),
        status: "draft".to_string(),
        created_at: "2024-01-01T00:00:00Z".to_string(),
        updated_at: "2024-01-01T00:00:00Z".to_string(),
    }
}

mod reading_test_row {
    use super::*;

    #[test]
    fn it_round_trips_all_fields_through_json() {
        // Arrange
        let row = default_reading_test_row();

        // Act
        let value = serde_json::to_value(&row).expect("serialize");
        let parsed: ReadingTest = serde_json::from_value(value).expect("deserialize");

        // Assert
        assert_eq!(parsed.id, TEST_ID);
        assert_eq!(parsed.created_by, CREATED_BY);
        assert_eq!(parsed.title, TITLE);
        assert_eq!(parsed.status, "draft");
    }
}

mod create_reading_test {
    use super::*;

    #[test]
    fn it_defaults_all_fields_to_none_when_payload_is_empty() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: CreateReadingTest = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.title, None);
        assert_eq!(parsed.status, None);
    }

    #[test]
    fn it_populates_title_when_present_in_payload() {
        // Arrange
        let payload = json!({ "title": TITLE });

        // Act
        let parsed: CreateReadingTest = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.title, Some(TITLE.to_string()));
    }
}

mod update_reading_test {
    use super::*;

    #[test]
    fn it_defaults_all_fields_to_none_when_payload_is_empty() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: UpdateReadingTest = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.title, None);
        assert_eq!(parsed.test_type, None);
        assert_eq!(parsed.difficulty, None);
        assert_eq!(parsed.duration, None);
        assert_eq!(parsed.status, None);
    }

    #[test]
    fn it_populates_status_when_present_in_payload() {
        // Arrange
        let payload = json!({ "status": "published" });

        // Act
        let parsed: UpdateReadingTest = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.status, Some("published".to_string()));
    }
}
