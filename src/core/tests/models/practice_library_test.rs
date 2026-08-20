use app_lib::models::practice_library::{PracticeTestCard, PracticeTestRow};

fn default_row() -> PracticeTestRow {
    PracticeTestRow {
        id: "test-1".to_string(),
        title: "Sample Test".to_string(),
        module: "reading".to_string(),
        difficulty: "7".to_string(),
        duration: "60 mins".to_string(),
        created_at: "2024-01-01T00:00:00Z".to_string(),
    }
}

mod practice_test_row {
    use super::*;

    #[test]
    fn it_clones_independently_of_the_original() {
        // Arrange
        let row = default_row();

        // Act
        let mut cloned = row.clone();
        cloned.title = "Changed".to_string();

        // Assert
        assert_eq!(row.title, "Sample Test");
    }
}

mod practice_test_card {
    use super::*;

    fn not_started_card() -> PracticeTestCard {
        PracticeTestCard {
            id: "test-1".to_string(),
            title: "Sample Test".to_string(),
            module: "reading".to_string(),
            difficulty: "7".to_string(),
            duration: "60 mins".to_string(),
            status: "not_started".to_string(),
            progress_percent: 0,
            score_band: None,
            last_active_at: None,
            session_id: None,
            created_at: "2024-01-01T00:00:00Z".to_string(),
        }
    }

    #[test]
    fn it_serializes_absent_session_fields_as_null() {
        // Arrange
        let card = not_started_card();

        // Act
        let value = serde_json::to_value(&card).expect("serialize");

        // Assert
        assert_eq!(value["score_band"], serde_json::Value::Null);
        assert_eq!(value["session_id"], serde_json::Value::Null);
        assert_eq!(value["last_active_at"], serde_json::Value::Null);
    }

    #[test]
    fn it_serializes_score_band_when_present() {
        // Arrange
        let mut card = not_started_card();
        card.score_band = Some(6.5);

        // Act
        let value = serde_json::to_value(&card).expect("serialize");

        // Assert
        assert_eq!(value["score_band"], serde_json::json!(6.5));
    }
}
