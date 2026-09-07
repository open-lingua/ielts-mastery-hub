use app_lib::database::Db;
use app_lib::repositories::{writing_tasks, writing_tests};
use assert_matches::assert_matches;

use crate::common::builders::{
    default_writing_test, CreateWritingTaskBuilder, UpdateWritingTaskBuilder,
};
use crate::common::fixtures::test_pool;

const OWNER_ID: &str = "owner-1";
const OTHER_USER_ID: &str = "other-user";
const UNKNOWN_ID: &str = "unknown-id";

async fn given_owned_test(pool: &Db) -> String {
    let input = default_writing_test();
    writing_tests::insert(pool, &input, OWNER_ID)
        .await
        .expect("insert parent test")
}

mod insert {
    use super::*;

    #[tokio::test]
    async fn it_creates_a_task_when_the_user_owns_the_parent_test() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateWritingTaskBuilder::default()
            .with_test_id(&test_id)
            .build();

        // Act
        let result = writing_tasks::insert(&pool, &input, OWNER_ID).await;

        // Assert
        assert_matches!(result, Ok(_));
    }

    #[tokio::test]
    async fn it_uses_the_provided_id_when_present() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateWritingTaskBuilder::default()
            .with_test_id(&test_id)
            .with_id("explicit-task-id")
            .build();

        // Act
        let result = writing_tasks::insert(&pool, &input, OWNER_ID).await;

        // Assert
        assert_matches!(result, Ok(id) if id == "explicit-task-id");
    }

    #[tokio::test]
    async fn it_rejects_the_insert_when_the_user_does_not_own_the_parent_test() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateWritingTaskBuilder::default()
            .with_test_id(&test_id)
            .build();

        // Act
        let result = writing_tasks::insert(&pool, &input, OTHER_USER_ID).await;

        // Assert
        assert_matches!(result, Err(app_lib::error::AppError::Validation(_)));
    }
}

mod find_by_id {
    use super::*;

    #[tokio::test]
    async fn it_finds_the_task_when_owner_looks_it_up() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateWritingTaskBuilder::default()
            .with_test_id(&test_id)
            .with_title("Bar Chart Task")
            .build();
        let id = writing_tasks::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");

        // Act
        let found = writing_tasks::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(Some(task)) if task.title == "Bar Chart Task");
    }

    #[tokio::test]
    async fn it_returns_none_when_id_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let found = writing_tasks::find_by_id(&pool, UNKNOWN_ID, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }

    #[tokio::test]
    async fn it_persists_and_returns_the_figure_description() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateWritingTaskBuilder::default()
            .with_test_id(&test_id)
            .with_figure_description("A line graph showing rainfall over 12 months.")
            .build();
        let id = writing_tasks::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");

        // Act
        let found = writing_tasks::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(
            found,
            Ok(Some(task)) if task.figure_description.as_deref()
                == Some("A line graph showing rainfall over 12 months.")
        );
    }
}

mod find_all {
    use super::*;

    #[tokio::test]
    async fn it_returns_an_empty_list_when_no_tasks_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let all = writing_tasks::find_all(&pool, OWNER_ID).await;

        // Assert
        assert_matches!(all, Ok(tasks) if tasks.is_empty());
    }
}

mod update {
    use super::*;

    #[tokio::test]
    async fn it_updates_only_the_provided_field() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateWritingTaskBuilder::default()
            .with_test_id(&test_id)
            .with_title("Original Title")
            .build();
        let id = writing_tasks::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");
        let update = UpdateWritingTaskBuilder::default()
            .with_min_words(200)
            .build();

        // Act
        writing_tasks::update(&pool, &id, OWNER_ID, &update)
            .await
            .expect("update");
        let found = writing_tasks::find_by_id(&pool, &id, OWNER_ID)
            .await
            .expect("find")
            .expect("present");

        // Assert
        assert_eq!(found.title, "Original Title");
        assert_eq!(found.min_words, 200);
    }

    #[tokio::test]
    async fn it_updates_the_figure_description_when_provided() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateWritingTaskBuilder::default()
            .with_test_id(&test_id)
            .build();
        let id = writing_tasks::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");
        let update = UpdateWritingTaskBuilder::default()
            .with_figure_description("A bar chart comparing sales across regions.")
            .build();

        // Act
        writing_tasks::update(&pool, &id, OWNER_ID, &update)
            .await
            .expect("update");
        let found = writing_tasks::find_by_id(&pool, &id, OWNER_ID)
            .await
            .expect("find")
            .expect("present");

        // Assert
        assert_eq!(
            found.figure_description.as_deref(),
            Some("A bar chart comparing sales across regions.")
        );
    }
}

mod delete {
    use super::*;

    #[tokio::test]
    async fn it_removes_the_task_when_owner_deletes_it() {
        // Arrange
        let pool = test_pool().await;
        let test_id = given_owned_test(&pool).await;
        let input = CreateWritingTaskBuilder::default()
            .with_test_id(&test_id)
            .build();
        let id = writing_tasks::insert(&pool, &input, OWNER_ID)
            .await
            .expect("insert");

        // Act
        writing_tasks::delete(&pool, &id, OWNER_ID)
            .await
            .expect("delete");
        let found = writing_tasks::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }

    #[tokio::test]
    async fn it_succeeds_as_a_no_op_when_the_task_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let result = writing_tasks::delete(&pool, UNKNOWN_ID, OWNER_ID).await;

        // Assert
        assert!(result.is_ok());
    }
}
