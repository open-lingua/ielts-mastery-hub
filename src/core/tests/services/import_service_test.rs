use app_lib::repositories::{reading_tests, writing_tasks, writing_tests};
use app_lib::services::import_service::{
    errors_to_string, find_duplicate_listening_title, find_duplicate_reading_title,
    find_duplicate_writing_title, import_listening, import_reading, import_writing,
    validate_listening, validate_reading, validate_writing, AudioAssignment, AudioMeta,
    ImportError,
};
use serde_json::json;

use crate::common::builders::{CreateReadingTestBuilder, CreateWritingTestBuilder};
use crate::common::fixtures::test_pool;

const OWNER_ID: &str = "owner-1";

fn good_reading_json() -> serde_json::Value {
    let question = json!({ "question_order": 1, "text": "Is this true?", "answer": "TRUE" });
    let group = json!({
        "group_order": 0,
        "question_type": "true-false-not-given",
        "instructions": "Answer TRUE/FALSE/NOT GIVEN.",
        "questions": [question]
    });
    let passage = |n: i64| {
        json!({
            "passage_number": n,
            "title": format!("Passage {n}"),
            "content": "Some content",
            "question_groups": if n == 1 { vec![group.clone()] } else { vec![] }
        })
    };
    json!({ "title": "Sample Reading Test", "passages": [passage(1), passage(2), passage(3)] })
}

fn good_writing_json() -> serde_json::Value {
    json!({
        "title": "Sample Writing Test",
        "tasks": [
            { "task_number": 1, "title": "Task One", "prompt": "Describe the chart.", "figure_description": "A line graph showing rainfall over 12 months." },
            { "task_number": 2, "title": "Task Two", "prompt": "Give your opinion." }
        ]
    })
}

fn good_listening_sections() -> Vec<serde_json::Value> {
    (1..=4)
        .map(|n| json!({ "section_number": n, "title": format!("Section {n}"), "transcript": "t", "question_groups": [] }))
        .collect()
}

fn good_listening_audios() -> Vec<AudioMeta> {
    (1..=4)
        .map(|n| AudioMeta {
            section_number: n,
            file_name: "a.mp3".to_string(),
            size: 0,
        })
        .collect()
}

mod errors_to_string_fn {
    use super::*;

    #[test]
    fn it_joins_each_errors_message_onto_its_own_line() {
        // Arrange
        let errors = vec![
            ImportError {
                path: "title".to_string(),
                message: "Field cannot be empty.".to_string(),
            },
            ImportError {
                path: "tasks".to_string(),
                message: "Must contain exactly 2 tasks.".to_string(),
            },
        ];

        // Act
        let joined = errors_to_string(&errors);

        // Assert
        assert_eq!(
            joined,
            "Field cannot be empty. (at `title`)\nMust contain exactly 2 tasks. (at `tasks`)"
        );
    }

    #[test]
    fn it_returns_an_empty_string_when_there_are_no_errors() {
        // Arrange
        let errors: Vec<ImportError> = Vec::new();

        // Act
        let joined = errors_to_string(&errors);

        // Assert
        assert_eq!(joined, "");
    }
}

mod validate_reading_edge_cases {
    use super::*;

    #[test]
    fn it_rejects_a_duplicate_id_reused_across_two_nodes() {
        // Arrange
        let mut raw = good_reading_json();
        raw["passages"][0]["id"] = json!("shared-id");
        raw["passages"][1]["id"] = json!("shared-id");

        // Act
        let errors = validate_reading(&raw).unwrap_err();

        // Assert
        assert!(errors
            .iter()
            .any(|e| e.message.contains("Duplicate id `shared-id`")));
    }

    #[test]
    fn it_rejects_a_question_group_with_an_unknown_question_type() {
        // Arrange
        let mut raw = good_reading_json();
        raw["passages"][0]["question_groups"][0]["question_type"] = json!("not-a-real-type");

        // Act
        let errors = validate_reading(&raw).unwrap_err();

        // Assert
        assert!(errors
            .iter()
            .any(|e| e.path.ends_with("question_type") && e.message.contains("Unknown")));
    }

    #[test]
    fn it_rejects_non_contiguous_passage_numbers() {
        // Arrange
        let mut raw = good_reading_json();
        raw["passages"][2]["passage_number"] = json!(5);

        // Act
        let errors = validate_reading(&raw).unwrap_err();

        // Assert
        assert!(errors
            .iter()
            .any(|e| e.message.contains("must be contiguous starting at 1")));
    }

    #[test]
    fn it_rejects_being_pointed_at_a_writing_schema_file() {
        // Arrange
        let raw = good_writing_json();

        // Act
        let errors = validate_reading(&raw).unwrap_err();

        // Assert
        assert!(errors
            .iter()
            .any(|e| e.message.contains("Did you mean to import as Writing")));
    }
}

mod validate_writing_edge_cases {
    use super::*;

    #[test]
    fn it_validates_a_well_formed_writing_test() {
        // Arrange
        let raw = good_writing_json();

        // Act
        let result = validate_writing(&raw);

        // Assert
        assert!(result.is_ok(), "{:?}", result.err());
    }

    #[test]
    fn it_rejects_the_wrong_task_count() {
        // Arrange
        let mut raw = good_writing_json();
        raw["tasks"].as_array_mut().unwrap().pop();

        // Act
        let errors = validate_writing(&raw).unwrap_err();

        // Assert
        assert!(errors.iter().any(|e| e.message.contains("exactly 2 tasks")));
    }

    #[test]
    fn it_rejects_a_blank_prompt() {
        // Arrange
        let mut raw = good_writing_json();
        raw["tasks"][0]["prompt"] = json!("");

        // Act
        let errors = validate_writing(&raw).unwrap_err();

        // Assert
        assert!(errors.iter().any(|e| e.path == "tasks[0].prompt"));
    }

    #[test]
    fn it_rejects_duplicate_task_numbers() {
        // Arrange
        let mut raw = good_writing_json();
        raw["tasks"][1]["task_number"] = json!(1);

        // Act
        let errors = validate_writing(&raw).unwrap_err();

        // Assert
        assert!(errors
            .iter()
            .any(|e| e.message.contains("Duplicate `task_number` value")));
    }
}

mod validate_listening_edge_cases {
    use super::*;

    #[test]
    fn it_validates_a_well_formed_listening_test_with_matching_audio() {
        // Arrange
        let raw =
            json!({ "title": "Sample Listening Test", "sections": good_listening_sections() });
        let audios = good_listening_audios();

        // Act
        let result = validate_listening(&raw, &audios);

        // Assert
        assert!(result.is_ok(), "{:?}", result.err());
    }

    #[test]
    fn it_rejects_a_section_missing_its_audio_assignment() {
        // Arrange
        let raw =
            json!({ "title": "Sample Listening Test", "sections": good_listening_sections() });
        let audios: Vec<AudioMeta> = good_listening_audios()
            .into_iter()
            .filter(|a| a.section_number != 2)
            .collect();

        // Act
        let errors = validate_listening(&raw, &audios).unwrap_err();

        // Assert
        assert!(errors.iter().any(|e| e
            .message
            .contains("No audio file was assigned to Section 2")));
    }

    #[test]
    fn it_rejects_an_unsupported_audio_extension() {
        // Arrange
        let raw =
            json!({ "title": "Sample Listening Test", "sections": good_listening_sections() });
        let mut audios = good_listening_audios();
        audios[0].file_name = "a.exe".to_string();

        // Act
        let errors = validate_listening(&raw, &audios).unwrap_err();

        // Assert
        assert!(errors
            .iter()
            .any(|e| e.message.contains("Unsupported audio format")));
    }

    #[test]
    fn it_rejects_an_audio_file_over_the_size_limit() {
        // Arrange
        let raw =
            json!({ "title": "Sample Listening Test", "sections": good_listening_sections() });
        let mut audios = good_listening_audios();
        audios[0].size = 51 * 1024 * 1024;

        // Act
        let errors = validate_listening(&raw, &audios).unwrap_err();

        // Assert
        assert!(errors
            .iter()
            .any(|e| e.message.contains("exceeds the 50MB limit")));
    }

    #[test]
    fn it_rejects_the_wrong_section_count() {
        // Arrange
        let mut sections = good_listening_sections();
        sections.pop();
        let raw = json!({ "title": "Sample Listening Test", "sections": sections });
        let audios = good_listening_audios();

        // Act
        let errors = validate_listening(&raw, &audios).unwrap_err();

        // Assert
        assert!(errors
            .iter()
            .any(|e| e.message.contains("exactly 4 sections")));
    }
}

mod find_duplicate_title {
    use super::*;

    #[tokio::test]
    async fn it_finds_the_id_of_an_existing_reading_test_with_the_same_title_and_owner() {
        // Arrange
        let pool = test_pool().await;
        let input = CreateReadingTestBuilder::default()
            .with_title("Duplicate Title")
            .build();
        let existing_id = reading_tests::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");

        // Act
        let found = find_duplicate_reading_title(&pool, OWNER_ID, "Duplicate Title").await;

        // Assert
        assert_eq!(found.expect("query"), Some(existing_id));
    }

    #[tokio::test]
    async fn it_returns_none_when_no_reading_test_shares_the_title() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let found = find_duplicate_reading_title(&pool, OWNER_ID, "Never Used Title").await;

        // Assert
        assert_eq!(found.expect("query"), None);
    }

    #[tokio::test]
    async fn it_ignores_a_matching_title_owned_by_a_different_user() {
        // Arrange
        let pool = test_pool().await;
        let input = CreateWritingTestBuilder::default()
            .with_title("Shared Title")
            .build();
        writing_tests::insert(&pool, &input, "someone-else")
            .await
            .expect("insert");

        // Act
        let found = find_duplicate_writing_title(&pool, OWNER_ID, "Shared Title").await;

        // Assert
        assert_eq!(found.expect("query"), None);
    }

    #[tokio::test]
    async fn it_returns_none_for_listening_when_no_test_exists() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let found = find_duplicate_listening_title(&pool, OWNER_ID, "No Such Test").await;

        // Assert
        assert_eq!(found.expect("query"), None);
    }
}

mod import_reading_fn {
    use super::*;

    #[tokio::test]
    async fn it_persists_the_test_and_its_full_passage_tree() {
        // Arrange
        let pool = test_pool().await;
        let data = validate_reading(&good_reading_json()).expect("valid fixture");

        // Act
        let test_id = import_reading(&pool, OWNER_ID, data)
            .await
            .expect("import_reading");

        // Assert
        let found = reading_tests::find_by_id(&pool, &test_id, OWNER_ID)
            .await
            .expect("find")
            .expect("present");
        assert_eq!(found.title, "Sample Reading Test");
    }

    #[tokio::test]
    async fn it_creates_one_passage_row_per_imported_passage() {
        // Arrange
        let pool = test_pool().await;
        let data = validate_reading(&good_reading_json()).expect("valid fixture");
        let test_id = import_reading(&pool, OWNER_ID, data)
            .await
            .expect("import_reading");

        // Act
        let passages = app_lib::repositories::reading_passages::find_all(&pool, OWNER_ID)
            .await
            .expect("find_all")
            .into_iter()
            .filter(|p| p.test_id == test_id)
            .count();

        // Assert
        assert_eq!(passages, 3);
    }
}

mod import_writing_fn {
    use super::*;

    #[tokio::test]
    async fn it_persists_the_test_and_its_tasks() {
        // Arrange
        let pool = test_pool().await;
        let data = validate_writing(&good_writing_json()).expect("valid fixture");

        // Act
        let test_id = import_writing(&pool, OWNER_ID, data)
            .await
            .expect("import_writing");

        // Assert
        let found = writing_tests::find_by_id(&pool, &test_id, OWNER_ID)
            .await
            .expect("find")
            .expect("present");
        assert_eq!(found.title, "Sample Writing Test");

        let tasks = writing_tasks::find_all(&pool, OWNER_ID)
            .await
            .expect("find tasks");
        let task_one = tasks
            .iter()
            .find(|t| t.test_id == test_id && t.task_number == 1)
            .expect("task one present");
        assert_eq!(
            task_one.figure_description.as_deref(),
            Some("A line graph showing rainfall over 12 months.")
        );
    }

    #[tokio::test]
    async fn it_uses_the_provided_task_id_when_present() {
        // Arrange
        let pool = test_pool().await;
        let mut json = good_writing_json();
        json["tasks"][0]["id"] = json!("explicit-task-id");
        let data = validate_writing(&json).expect("valid fixture");

        // Act
        let test_id = import_writing(&pool, OWNER_ID, data)
            .await
            .expect("import_writing");

        // Assert
        let task = writing_tasks::find_by_id(&pool, "explicit-task-id", OWNER_ID)
            .await
            .expect("find")
            .expect("present");
        assert_eq!(task.test_id, test_id);
    }
}

mod import_listening_fn {
    use super::*;

    /// `import_listening` persists audio to a real `$HOME/.imh/...`
    /// directory (there is no injectable filesystem seam). This test cleans
    /// up everything it writes so no artifacts are left behind.
    #[tokio::test]
    async fn it_persists_the_test_and_writes_its_assigned_audio_to_disk() {
        // Arrange
        let pool = test_pool().await;
        let raw = json!({ "title": "Disk Audio Test", "sections": good_listening_sections() });
        let audios_meta = good_listening_audios();
        let data = validate_listening(&raw, &audios_meta).expect("valid fixture");
        let assignments: Vec<AudioAssignment> = (1..=4)
            .map(|n| AudioAssignment {
                section_number: n,
                file_name: "a.mp3".to_string(),
                data: vec![1, 2, 3],
            })
            .collect();

        // Act
        let test_id = import_listening(&pool, OWNER_ID, data, assignments)
            .await
            .expect("import_listening");

        // Assert
        let home = std::env::var("HOME").expect("HOME must be set");
        let dir = std::path::Path::new(&home)
            .join(".imh")
            .join("listening-tests");
        let entry = std::fs::read_dir(&dir)
            .expect("read test dir")
            .filter_map(|e| e.ok())
            .find(|e| e.file_name().to_string_lossy().starts_with(&test_id));
        assert!(
            entry.is_some(),
            "expected a directory for the imported test's audio files"
        );

        // Cleanup: remove the directory this test created so no real-disk artifacts remain.
        if let Some(entry) = entry {
            let _ = std::fs::remove_dir_all(entry.path());
        }
    }
}
