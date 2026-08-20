use app_lib::database::Db;
use app_lib::repositories::{reading_passages, reading_question_groups, reading_questions, reading_tests};
use assert_matches::assert_matches;

use crate::common::builders::{
    CreateReadingPassageBuilder, CreateReadingQuestionBuilder, CreateReadingQuestionGroupBuilder,
    UpdateReadingQuestionBuilder, default_reading_test,
};
use crate::common::fixtures::test_pool;

const OWNER_ID: &str = "owner-1";
const OTHER_USER_ID: &str = "other-user";
const UNKNOWN_ID: &str = "unknown-id";

/// Inserts a full reading test -> passage -> question group chain owned by
/// `OWNER_ID` and returns the group id — the required parent row for every
/// question in these tests.
async fn given_owned_group(pool: &Db) -> String {
    let test_input = default_reading_test();
    let test_id = reading_tests::insert(pool, &test_input, OWNER_ID).await.expect("insert test");
    let passage_input = CreateReadingPassageBuilder::default().with_test_id(&test_id).build();
    let passage_id = reading_passages::insert(pool, &passage_input, OWNER_ID).await.expect("insert passage");
    let group_input = CreateReadingQuestionGroupBuilder::default().with_passage_id(&passage_id).build();
    reading_question_groups::insert(pool, &group_input, OWNER_ID).await.expect("insert group")
}

mod insert {
    use super::*;

    #[tokio::test]
    async fn it_creates_a_question_when_the_user_owns_the_parent_group() {
        // Arrange
        let pool = test_pool().await;
        let group_id = given_owned_group(&pool).await;
        let input = CreateReadingQuestionBuilder::default().with_group_id(&group_id).build();

        // Act
        let result = reading_questions::insert(&pool, &input, OWNER_ID).await;

        // Assert
        assert_matches!(result, Ok(_));
    }

    #[tokio::test]
    async fn it_rejects_the_insert_when_the_user_does_not_own_the_parent_group() {
        // Arrange
        let pool = test_pool().await;
        let group_id = given_owned_group(&pool).await;
        let input = CreateReadingQuestionBuilder::default().with_group_id(&group_id).build();

        // Act
        let result = reading_questions::insert(&pool, &input, OTHER_USER_ID).await;

        // Assert
        assert_matches!(result, Err(app_lib::error::AppError::Validation(_)));
    }
}

mod find_by_id {
    use super::*;

    #[tokio::test]
    async fn it_finds_the_question_when_owner_looks_it_up() {
        // Arrange
        let pool = test_pool().await;
        let group_id = given_owned_group(&pool).await;
        let input = CreateReadingQuestionBuilder::default().with_group_id(&group_id).with_text("What is the theme?").build();
        let id = reading_questions::insert(&pool, &input, OWNER_ID).await.expect("insert");

        // Act
        let found = reading_questions::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(Some(question)) if question.text == "What is the theme?");
    }

    #[tokio::test]
    async fn it_returns_none_when_id_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let found = reading_questions::find_by_id(&pool, UNKNOWN_ID, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }
}

mod find_all {
    use super::*;

    #[tokio::test]
    async fn it_returns_an_empty_list_when_no_questions_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let all = reading_questions::find_all(&pool, OWNER_ID).await;

        // Assert
        assert_matches!(all, Ok(questions) if questions.is_empty());
    }
}

mod update {
    use super::*;

    #[tokio::test]
    async fn it_updates_only_the_provided_field() {
        // Arrange
        let pool = test_pool().await;
        let group_id = given_owned_group(&pool).await;
        let input = CreateReadingQuestionBuilder::default()
            .with_group_id(&group_id)
            .with_text("Original text?")
            .build();
        let id = reading_questions::insert(&pool, &input, OWNER_ID).await.expect("insert");
        let update = UpdateReadingQuestionBuilder::default().with_answer("42").build();

        // Act
        reading_questions::update(&pool, &id, OWNER_ID, &update).await.expect("update");
        let found = reading_questions::find_by_id(&pool, &id, OWNER_ID).await.expect("find").expect("present");

        // Assert
        assert_eq!(found.text, "Original text?");
        assert_eq!(found.answer, Some("42".to_string()));
    }
}

mod delete {
    use super::*;

    #[tokio::test]
    async fn it_removes_the_question_when_owner_deletes_it() {
        // Arrange
        let pool = test_pool().await;
        let group_id = given_owned_group(&pool).await;
        let input = CreateReadingQuestionBuilder::default().with_group_id(&group_id).build();
        let id = reading_questions::insert(&pool, &input, OWNER_ID).await.expect("insert");

        // Act
        reading_questions::delete(&pool, &id, OWNER_ID).await.expect("delete");
        let found = reading_questions::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }

    #[tokio::test]
    async fn it_succeeds_as_a_no_op_when_the_question_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let result = reading_questions::delete(&pool, UNKNOWN_ID, OWNER_ID).await;

        // Assert
        assert!(result.is_ok());
    }
}
