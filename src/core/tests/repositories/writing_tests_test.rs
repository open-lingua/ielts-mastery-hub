use app_lib::repositories::writing_tests;
use assert_matches::assert_matches;

use crate::common::builders::{CreateWritingTestBuilder, UpdateWritingTestBuilder, default_writing_test};
use crate::common::fixtures::test_pool;

const OWNER_ID: &str = "owner-1";
const OTHER_USER_ID: &str = "other-user";
const UNKNOWN_ID: &str = "unknown-id";

mod insert_and_find_by_id {
    use super::*;

    #[tokio::test]
    async fn it_finds_the_test_when_owner_looks_it_up() {
        // Arrange
        let pool = test_pool().await;
        let input = CreateWritingTestBuilder::default().with_title("Opinion Essays").build();
        let id = writing_tests::insert(&pool, &input, OWNER_ID).await.expect("insert");

        // Act
        let found = writing_tests::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(Some(test)) if test.title == "Opinion Essays");
    }

    #[tokio::test]
    async fn it_returns_none_when_id_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let found = writing_tests::find_by_id(&pool, UNKNOWN_ID, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }

    #[tokio::test]
    async fn it_finds_a_published_test_when_looked_up_by_a_non_owner() {
        // Arrange
        let pool = test_pool().await;
        let input = CreateWritingTestBuilder::default().with_status("published").build();
        let id = writing_tests::insert(&pool, &input, OWNER_ID).await.expect("insert");

        // Act
        let found = writing_tests::find_by_id(&pool, &id, OTHER_USER_ID).await;

        // Assert
        assert_matches!(found, Ok(Some(_)));
    }

    #[tokio::test]
    async fn it_returns_none_when_a_draft_test_is_looked_up_by_a_non_owner() {
        // Arrange
        let pool = test_pool().await;
        let input = CreateWritingTestBuilder::default().with_status("draft").build();
        let id = writing_tests::insert(&pool, &input, OWNER_ID).await.expect("insert");

        // Act
        let found = writing_tests::find_by_id(&pool, &id, OTHER_USER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }
}

mod find_all {
    use super::*;

    #[tokio::test]
    async fn it_returns_an_empty_list_when_no_tests_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let all = writing_tests::find_all(&pool, OWNER_ID).await;

        // Assert
        assert_matches!(all, Ok(tests) if tests.is_empty());
    }

    #[tokio::test]
    async fn it_excludes_other_users_drafts() {
        // Arrange
        let pool = test_pool().await;
        let input = CreateWritingTestBuilder::default().with_status("draft").build();
        writing_tests::insert(&pool, &input, OWNER_ID).await.expect("insert");

        // Act
        let all = writing_tests::find_all(&pool, OTHER_USER_ID).await.expect("find_all");

        // Assert
        assert!(all.is_empty());
    }
}

mod update {
    use super::*;

    #[tokio::test]
    async fn it_updates_only_the_provided_field() {
        // Arrange
        let pool = test_pool().await;
        let input = CreateWritingTestBuilder::default().with_title("Original Title").build();
        let id = writing_tests::insert(&pool, &input, OWNER_ID).await.expect("insert");
        let update = UpdateWritingTestBuilder::default().with_status("published").build();

        // Act
        writing_tests::update(&pool, &id, OWNER_ID, &update).await.expect("update");
        let found = writing_tests::find_by_id(&pool, &id, OWNER_ID).await.expect("find").expect("present");

        // Assert
        assert_eq!(found.title, "Original Title");
        assert_eq!(found.status, "published");
    }

    #[tokio::test]
    async fn it_does_not_update_a_test_owned_by_another_user() {
        // Arrange
        let pool = test_pool().await;
        let input = CreateWritingTestBuilder::default().with_title("Original Title").build();
        let id = writing_tests::insert(&pool, &input, OWNER_ID).await.expect("insert");
        let update = UpdateWritingTestBuilder::default().with_title("Hijacked Title").build();

        // Act
        writing_tests::update(&pool, &id, OTHER_USER_ID, &update).await.expect("update");
        let found = writing_tests::find_by_id(&pool, &id, OWNER_ID).await.expect("find").expect("present");

        // Assert
        assert_eq!(found.title, "Original Title");
    }
}

mod delete {
    use super::*;

    #[tokio::test]
    async fn it_removes_the_test_when_owner_deletes_it() {
        // Arrange
        let pool = test_pool().await;
        let input = default_writing_test();
        let id = writing_tests::insert(&pool, &input, OWNER_ID).await.expect("insert");

        // Act
        writing_tests::delete(&pool, &id, OWNER_ID).await.expect("delete");
        let found = writing_tests::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }

    #[tokio::test]
    async fn it_does_not_remove_a_test_owned_by_another_user() {
        // Arrange
        let pool = test_pool().await;
        let input = default_writing_test();
        let id = writing_tests::insert(&pool, &input, OWNER_ID).await.expect("insert");

        // Act
        writing_tests::delete(&pool, &id, OTHER_USER_ID).await.expect("delete");
        let found = writing_tests::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(Some(_)));
    }

    #[tokio::test]
    async fn it_succeeds_as_a_no_op_when_the_test_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let result = writing_tests::delete(&pool, UNKNOWN_ID, OWNER_ID).await;

        // Assert
        assert!(result.is_ok());
    }
}
