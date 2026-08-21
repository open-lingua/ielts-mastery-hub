use app_lib::database::Db;
use app_lib::repositories::{listening_sections, listening_tests};
use assert_matches::assert_matches;

use crate::common::builders::{
    default_listening_test, CreateListeningSectionBuilder, UpdateListeningSectionBuilder,
};
use crate::common::fixtures::test_pool;

const OWNER_ID: &str = "owner-1";
const OTHER_USER_ID: &str = "other-user";
const UNKNOWN_ID: &str = "unknown-id";

async fn given_owned_test(pool: &Db) -> String {
    let input = default_listening_test();
    listening_tests::insert(pool, &input, OWNER_ID)
        .await
        .expect("insert parent test")
}

mod insert {
    use super::*;

    #[tokio::test]
    async fn it_creates_a_section_when_the_user_owns_the_parent_test() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateListeningSectionBuilder::default()
            .with_test_id(&test_id)
            .build();

        // Act
        let result = listening_sections::insert(&pool, &input, OWNER_ID).await;

        // Assert
        assert_matches!(result, Ok(_));
    }

    #[tokio::test]
    async fn it_rejects_the_insert_when_the_user_does_not_own_the_parent_test() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateListeningSectionBuilder::default()
            .with_test_id(&test_id)
            .build();

        // Act
        let result = listening_sections::insert(&pool, &input, OTHER_USER_ID).await;

        // Assert
        assert_matches!(result, Err(app_lib::error::AppError::Validation(_)));
    }
}

mod find_by_id {
    use super::*;

    #[tokio::test]
    async fn it_finds_the_section_when_owner_looks_it_up() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateListeningSectionBuilder::default()
            .with_test_id(&test_id)
            .with_title("Section One")
            .build();
        let id = listening_sections::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");

        // Act
        let found = listening_sections::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(Some(section)) if section.title == "Section One");
    }

    #[tokio::test]
    async fn it_returns_none_when_id_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let found = listening_sections::find_by_id(&pool, UNKNOWN_ID, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }
}

mod find_all {
    use super::*;

    #[tokio::test]
    async fn it_returns_an_empty_list_when_no_sections_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let all = listening_sections::find_all(&pool, OWNER_ID).await;

        // Assert
        assert_matches!(all, Ok(sections) if sections.is_empty());
    }
}

mod update {
    use super::*;

    #[tokio::test]
    async fn it_updates_only_the_provided_field() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateListeningSectionBuilder::default()
            .with_test_id(&test_id)
            .with_title("Original Title")
            .build();
        let id = listening_sections::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");
        let update = UpdateListeningSectionBuilder::default()
            .with_audio_url("https://example.com/audio.mp3")
            .build();

        // Act
        listening_sections::update(&pool, &id, OWNER_ID, &update)
            .await
            .expect("update");
        let found = listening_sections::find_by_id(&pool, &id, OWNER_ID)
            .await
            .expect("find")
            .expect("present");

        // Assert
        assert_eq!(found.title, "Original Title");
        assert_eq!(
            found.audio_url,
            Some("https://example.com/audio.mp3".to_string())
        );
    }
}

mod delete {
    use super::*;

    #[tokio::test]
    async fn it_removes_the_section_when_owner_deletes_it() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateListeningSectionBuilder::default()
            .with_test_id(&test_id)
            .build();
        let id = listening_sections::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");

        // Act
        listening_sections::delete(&pool, &id, OWNER_ID)
            .await
            .expect("delete");
        let found = listening_sections::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }

    #[tokio::test]
    async fn it_succeeds_as_a_no_op_when_the_section_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let result = listening_sections::delete(&pool, UNKNOWN_ID, OWNER_ID).await;

        // Assert
        assert!(result.is_ok());
    }
}
