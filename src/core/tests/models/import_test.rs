use app_lib::models::import::{
    ListeningImport, PassageImport, QuestionGroupImport, QuestionImport, ReadingImport,
    SectionImport, TaskImport, WritingImport,
};
use serde_json::json;

mod reading_import {
    use super::*;

    #[test]
    fn it_defaults_passages_to_empty_vec_when_absent() {
        // Arrange
        let payload = json!({ "title": "Sample" });

        // Act
        let parsed: ReadingImport = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.passages.len(), 0);
    }

    #[test]
    fn it_parses_nested_passages_and_question_groups() {
        // Arrange
        let payload = json!({
            "title": "Sample",
            "passages": [{
                "title": "Passage One",
                "question_groups": [{
                    "question_type": "multiple-choice",
                    "questions": [{ "text": "What year?" }]
                }]
            }]
        });

        // Act
        let parsed: ReadingImport = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(
            parsed.passages[0].question_groups[0].questions[0].text,
            Some("What year?".to_string())
        );
    }
}

mod passage_import {
    use super::*;

    #[test]
    fn it_defaults_question_groups_to_empty_vec_when_absent() {
        // Arrange
        let payload = json!({ "title": "Passage One" });

        // Act
        let parsed: PassageImport = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.question_groups.len(), 0);
    }
}

mod writing_import {
    use super::*;

    #[test]
    fn it_defaults_tasks_to_empty_vec_when_absent() {
        // Arrange
        let payload = json!({ "title": "Sample" });

        // Act
        let parsed: WritingImport = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.tasks.len(), 0);
    }

    #[test]
    fn it_parses_a_task_when_present() {
        // Arrange
        let payload = json!({ "title": "Sample", "tasks": [{ "task_type": "task1" }] });

        // Act
        let parsed: WritingImport = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.tasks[0].task_type, Some("task1".to_string()));
    }
}

mod task_import {
    use super::*;

    #[test]
    fn it_defaults_all_optional_fields_to_none_when_absent() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: TaskImport = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.task_type, None);
        assert_eq!(parsed.include_model_answer, None);
        assert_eq!(parsed.figure_description, None);
    }
}

mod listening_import {
    use super::*;

    #[test]
    fn it_defaults_sections_to_empty_vec_when_absent() {
        // Arrange
        let payload = json!({ "title": "Sample" });

        // Act
        let parsed: ListeningImport = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.sections.len(), 0);
    }
}

mod section_import {
    use super::*;

    #[test]
    fn it_defaults_question_groups_to_empty_vec_when_absent() {
        // Arrange
        let payload = json!({ "title": "Section One" });

        // Act
        let parsed: SectionImport = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.question_groups.len(), 0);
    }
}

mod question_group_import {
    use super::*;

    #[test]
    fn it_defaults_questions_to_empty_vec_when_absent() {
        // Arrange
        let payload = json!({ "question_type": "multiple-choice" });

        // Act
        let parsed: QuestionGroupImport = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.questions.len(), 0);
    }

    #[test]
    fn it_parses_word_bank_as_arbitrary_json_value() {
        // Arrange
        let payload = json!({ "word_bank": ["alpha", "beta"] });

        // Act
        let parsed: QuestionGroupImport = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.word_bank, Some(json!(["alpha", "beta"])));
    }
}

mod question_import {
    use super::*;

    #[test]
    fn it_defaults_all_optional_fields_to_none_when_absent() {
        // Arrange
        let payload = json!({});

        // Act
        let parsed: QuestionImport = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.text, None);
        assert_eq!(parsed.answer, None);
        assert_eq!(parsed.options, None);
    }

    #[test]
    fn it_parses_options_as_arbitrary_json_value() {
        // Arrange
        let payload = json!({ "options": ["A", "B", "C"] });

        // Act
        let parsed: QuestionImport = serde_json::from_value(payload).expect("deserialize");

        // Assert
        assert_eq!(parsed.options, Some(json!(["A", "B", "C"])));
    }
}
