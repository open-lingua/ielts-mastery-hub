use app_lib::database::Db;
use app_lib::repositories::{listening_sections, listening_question_groups, listening_tests};
use assert_matches::assert_matches;

use crate::common::builders::{
    CreateListeningQuestionGroupBuilder, CreateListeningSectionBuilder,
    UpdateListeningQuestionGroupBuilder, default_listening_test,
};
use crate::common::fixtures::test_pool;

const OWNER_ID: &str = "owner-1";
const OTHER_USER_ID: &str = "other-user";
const UNKNOWN_ID: &str = "unknown-id";

async fn given_owned_section(pool: &Db) -> String {
    let test_input = default_listening_test();
    let test_id = listening_tests::insert(pool, &test_input, OWNER_ID).await.expect("insert test");
    let section_input = CreateListeningSectionBuilder::default().with_test_id(&test_id).build();
    listening_sections::insert(pool, &section_input, OWNER_ID).await.expect("insert section")
}

mod insert {
    use super::*;

    #[tokio::test]
    async fn it_creates_a_group_when_the_user_owns_the_parent_section() {
        // Arrange
        let pool = test_pool().await;
        let section_id = given_owned_section(&pool).await;
        let input = CreateListeningQuestionGroupBuilder::default().with_section_id(&section_id).build();

        // Act
        let result = listening_question_groups::insert(&pool, &input, OWNER_ID).await;

        // Assert
        assert_matches!(result, Ok(_));
    }

    #[tokio::test]
    async fn it_rejects_the_insert_when_the_user_does_not_own_the_parent_section() {
        // Arrange
        let pool = test_pool().await;
        let section_id = given_owned_section(&pool).await;
        let input = CreateListeningQuestionGroupBuilder::default().with_section_id(&section_id).build();

        // Act
        let result = listening_question_groups::insert(&pool, &input, OTHER_USER_ID).await;

        // Assert
        assert_matches!(result, Err(app_lib::error::AppError::Validation(_)));
    }
}

mod find_by_id {
    use super::*;

    #[tokio::test]
    async fn it_finds_the_group_when_owner_looks_it_up() {
        // Arrange
        let pool = test_pool().await;
        let section_id = given_owned_section(&pool).await;
        let input = CreateListeningQuestionGroupBuilder::default()
            .with_section_id(&section_id)
            .with_question_type("matching")
            .build();
        let id = listening_question_groups::insert(&pool, &input, OWNER_ID).await.expect("insert");

        // Act
        let found = listening_question_groups::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(Some(group)) if group.question_type == "matching");
    }

    #[tokio::test]
    async fn it_returns_none_when_id_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let found = listening_question_groups::find_by_id(&pool, UNKNOWN_ID, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }
}

mod find_all {
    use super::*;

    #[tokio::test]
    async fn it_returns_an_empty_list_when_no_groups_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let all = listening_question_groups::find_all(&pool, OWNER_ID).await;

        // Assert
        assert_matches!(all, Ok(groups) if groups.is_empty());
    }
}

mod update {
    use super::*;

    #[tokio::test]
    async fn it_updates_only_the_provided_field() {
        // Arrange
        let pool = test_pool().await;
        let section_id = given_owned_section(&pool).await;
        let input = CreateListeningQuestionGroupBuilder::default()
            .with_section_id(&section_id)
            .with_question_type("multiple-choice")
            .build();
        let id = listening_question_groups::insert(&pool, &input, OWNER_ID).await.expect("insert");
        let update = UpdateListeningQuestionGroupBuilder::default().with_group_order(4).build();

        // Act
        listening_question_groups::update(&pool, &id, OWNER_ID, &update).await.expect("update");
        let found = listening_question_groups::find_by_id(&pool, &id, OWNER_ID)
            .await
            .expect("find")
            .expect("present");

        // Assert
        assert_eq!(found.question_type, "multiple-choice");
        assert_eq!(found.group_order, 4);
    }
}

mod delete {
    use super::*;

    #[tokio::test]
    async fn it_removes_the_group_when_owner_deletes_it() {
        // Arrange
        let pool = test_pool().await;
        let section_id = given_owned_section(&pool).await;
        let input = CreateListeningQuestionGroupBuilder::default().with_section_id(&section_id).build();
        let id = listening_question_groups::insert(&pool, &input, OWNER_ID).await.expect("insert");

        // Act
        listening_question_groups::delete(&pool, &id, OWNER_ID).await.expect("delete");
        let found = listening_question_groups::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }

    #[tokio::test]
    async fn it_succeeds_as_a_no_op_when_the_group_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let result = listening_question_groups::delete(&pool, UNKNOWN_ID, OWNER_ID).await;

        // Assert
        assert!(result.is_ok());
    }
}
