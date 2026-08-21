use app_lib::repositories::reading_passages;
use assert_matches::assert_matches;

use crate::common::builders::{
    default_reading_test, CreateReadingPassageBuilder, UpdateReadingPassageBuilder,
};
use crate::common::fixtures::test_pool;

const OWNER_ID: &str = "owner-1";
const OTHER_USER_ID: &str = "other-user";
const UNKNOWN_ID: &str = "unknown-id";

/// Inserts a reading test owned by `OWNER_ID` and returns its id — the
/// required parent row for every passage in these tests.
async fn given_owned_test(pool: &app_lib::database::Db) -> String {
    let input = default_reading_test();
    app_lib::repositories::reading_tests::insert(pool, &input, OWNER_ID)
        .await
        .expect("insert parent test")
}

mod insert {
    use super::*;

    #[tokio::test]
    async fn it_creates_a_passage_when_the_user_owns_the_parent_test() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateReadingPassageBuilder::default()
            .with_test_id(&test_id)
            .build();

        // Act
        let result = reading_passages::insert(&pool, &input, OWNER_ID).await;

        // Assert
        assert_matches!(result, Ok(_));
    }

    #[tokio::test]
    async fn it_rejects_the_insert_when_the_user_does_not_own_the_parent_test() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateReadingPassageBuilder::default()
            .with_test_id(&test_id)
            .build();

        // Act
        let result = reading_passages::insert(&pool, &input, OTHER_USER_ID).await;

        // Assert
        assert_matches!(result, Err(app_lib::error::AppError::Validation(_)));
    }
}

mod find_by_id {
    use super::*;

    #[tokio::test]
    async fn it_finds_the_passage_when_owner_looks_it_up() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateReadingPassageBuilder::default()
            .with_test_id(&test_id)
            .with_title("Ocean Currents")
            .build();
        let id = reading_passages::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");

        // Act
        let found = reading_passages::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(Some(passage)) if passage.title == "Ocean Currents");
    }

    #[tokio::test]
    async fn it_returns_none_when_id_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let found = reading_passages::find_by_id(&pool, UNKNOWN_ID, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }
}

mod find_all {
    use super::*;

    #[tokio::test]
    async fn it_returns_an_empty_list_when_no_passages_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let all = reading_passages::find_all(&pool, OWNER_ID).await;

        // Assert
        assert_matches!(all, Ok(passages) if passages.is_empty());
    }
}

mod update {
    use super::*;

    #[tokio::test]
    async fn it_updates_only_the_provided_field() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateReadingPassageBuilder::default()
            .with_test_id(&test_id)
            .with_title("Original Title")
            .build();
        let id = reading_passages::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");
        let update = UpdateReadingPassageBuilder::default()
            .with_content("New content")
            .build();

        // Act
        reading_passages::update(&pool, &id, OWNER_ID, &update)
            .await
            .expect("update");
        let found = reading_passages::find_by_id(&pool, &id, OWNER_ID)
            .await
            .expect("find")
            .expect("present");

        // Assert
        assert_eq!(found.title, "Original Title");
        assert_eq!(found.content, "New content");
    }
}

mod delete {
    use super::*;

    #[tokio::test]
    async fn it_removes_the_passage_when_owner_deletes_it() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateReadingPassageBuilder::default()
            .with_test_id(&test_id)
            .build();
        let id = reading_passages::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");

        // Act
        reading_passages::delete(&pool, &id, OWNER_ID)
            .await
            .expect("delete");
        let found = reading_passages::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }

    #[tokio::test]
    async fn it_succeeds_as_a_no_op_when_the_passage_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let result = reading_passages::delete(&pool, UNKNOWN_ID, OWNER_ID).await;

        // Assert
        assert!(result.is_ok());
    }
}
