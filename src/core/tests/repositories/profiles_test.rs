use app_lib::repositories::profiles;
use assert_matches::assert_matches;

use crate::common::builders::{CreateProfileBuilder, UpdateProfileBuilder, default_profile};
use crate::common::fixtures::test_pool;

const UNKNOWN_ID: &str = "unknown-id";

mod insert_and_find_by_id {
    use super::*;

    #[tokio::test]
    async fn it_finds_the_profile_when_looked_up_by_its_id() {
        // Arrange
        let pool = test_pool().await;
        let input = CreateProfileBuilder::default().with_full_name("Grace Hopper").build();
        let id = profiles::insert(&pool, &input).await.expect("insert");

        // Act
        let found = profiles::find_by_id(&pool, &id).await;

        // Assert
        assert_matches!(found, Ok(Some(profile)) if profile.full_name == Some("Grace Hopper".to_string()));
    }

    #[tokio::test]
    async fn it_returns_none_when_id_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let found = profiles::find_by_id(&pool, UNKNOWN_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }

    #[tokio::test]
    async fn it_defaults_plan_type_to_free_when_not_provided() {
        // Arrange
        let pool = test_pool().await;
        let input = default_profile();
        let id = profiles::insert(&pool, &input).await.expect("insert");

        // Act
        let found = profiles::find_by_id(&pool, &id).await.expect("find").expect("present");

        // Assert
        assert_eq!(found.plan_type, "free");
    }
}

mod find_all {
    use super::*;

    #[tokio::test]
    async fn it_returns_an_empty_list_when_no_profiles_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let all = profiles::find_all(&pool).await;

        // Assert
        assert_matches!(all, Ok(profiles) if profiles.is_empty());
    }

    #[tokio::test]
    async fn it_returns_every_profile_that_exists() {
        // Arrange
        let pool = test_pool().await;
        profiles::insert(&pool, &default_profile()).await.expect("insert 1");
        profiles::insert(&pool, &default_profile()).await.expect("insert 2");

        // Act
        let all = profiles::find_all(&pool).await.expect("find_all");

        // Assert
        assert_eq!(all.len(), 2);
    }
}

mod update {
    use super::*;

    #[tokio::test]
    async fn it_updates_only_the_provided_field() {
        // Arrange
        let pool = test_pool().await;
        let input = CreateProfileBuilder::default().with_full_name("Original Name").build();
        let id = profiles::insert(&pool, &input).await.expect("insert");
        let update = UpdateProfileBuilder::default().with_is_banned(true).build();

        // Act
        profiles::update(&pool, &id, &update).await.expect("update");
        let found = profiles::find_by_id(&pool, &id).await.expect("find").expect("present");

        // Assert
        assert_eq!(found.full_name, Some("Original Name".to_string()));
        assert_eq!(found.is_banned, true);
    }
}

mod delete {
    use super::*;

    #[tokio::test]
    async fn it_removes_the_profile() {
        // Arrange
        let pool = test_pool().await;
        let input = default_profile();
        let id = profiles::insert(&pool, &input).await.expect("insert");

        // Act
        profiles::delete(&pool, &id).await.expect("delete");
        let found = profiles::find_by_id(&pool, &id).await;

        // Assert
        assert_matches!(found, Ok(None));
    }

    #[tokio::test]
    async fn it_succeeds_as_a_no_op_when_the_profile_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let result = profiles::delete(&pool, UNKNOWN_ID).await;

        // Assert
        assert!(result.is_ok());
    }
}
