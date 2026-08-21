use app_lib::database::Db;
use app_lib::models::user_roles::{CreateUserRole, UpdateUserRole};
use app_lib::repositories::user_roles;
use assert_matches::assert_matches;

use crate::common::fixtures::test_pool;

const OWNER_ID: &str = "owner-1";
const OTHER_USER_ID: &str = "other-user";
const UNKNOWN_ID: &str = "unknown-id";

fn super_admin_role_for(user_id: &str) -> CreateUserRole {
    CreateUserRole {
        user_id: user_id.to_string(),
        role: "super_admin".to_string(),
    }
}

/// `user_roles.user_id` has a foreign key to `profiles(id)`, so every test
/// user referenced here must have a matching profile row first.
async fn given_profile(pool: &Db, id: &str) {
    sqlx::query!("INSERT INTO profiles (id, plan_type, updated_at) VALUES (?, 'free', '2024-01-01T00:00:00Z')", id)
        .execute(pool)
        .await
        .expect("insert profile fixture");
}

mod insert_and_find_by_id {
    use super::*;

    #[tokio::test]
    async fn it_finds_the_role_when_owner_looks_it_up() {
        // Arrange
        let pool = test_pool().await;
        given_profile(&pool, OWNER_ID).await;
        let input = super_admin_role_for(OWNER_ID);
        let id = user_roles::insert(&pool, &input).await.expect("insert");

        // Act
        let found = user_roles::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(Some(role)) if role.role == "super_admin");
    }

    #[tokio::test]
    async fn it_returns_none_when_id_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let found = user_roles::find_by_id(&pool, UNKNOWN_ID, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }

    #[tokio::test]
    async fn it_returns_none_when_looked_up_by_a_different_user() {
        // Arrange
        let pool = test_pool().await;
        given_profile(&pool, OWNER_ID).await;
        let input = super_admin_role_for(OWNER_ID);
        let id = user_roles::insert(&pool, &input).await.expect("insert");

        // Act
        let found = user_roles::find_by_id(&pool, &id, OTHER_USER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }
}

mod find_all {
    use super::*;

    #[tokio::test]
    async fn it_returns_an_empty_list_when_the_user_has_no_roles() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let all = user_roles::find_all(&pool, OWNER_ID).await;

        // Assert
        assert_matches!(all, Ok(roles) if roles.is_empty());
    }

    #[tokio::test]
    async fn it_excludes_roles_belonging_to_other_users() {
        // Arrange
        let pool = test_pool().await;
        given_profile(&pool, OTHER_USER_ID).await;
        user_roles::insert(&pool, &super_admin_role_for(OTHER_USER_ID))
            .await
            .expect("insert");

        // Act
        let all = user_roles::find_all(&pool, OWNER_ID)
            .await
            .expect("find_all");

        // Assert
        assert!(all.is_empty());
    }
}

mod update {
    use super::*;

    #[tokio::test]
    async fn it_updates_the_role_when_owned_by_the_user() {
        // Arrange
        let pool = test_pool().await;
        given_profile(&pool, OWNER_ID).await;
        let id = user_roles::insert(&pool, &super_admin_role_for(OWNER_ID))
            .await
            .expect("insert");
        let update = UpdateUserRole {
            role: Some("student".to_string()),
        };

        // Act
        user_roles::update(&pool, &id, OWNER_ID, &update)
            .await
            .expect("update");
        let found = user_roles::find_by_id(&pool, &id, OWNER_ID)
            .await
            .expect("find")
            .expect("present");

        // Assert
        assert_eq!(found.role, "student");
    }

    #[tokio::test]
    async fn it_does_not_update_a_role_owned_by_another_user() {
        // Arrange
        let pool = test_pool().await;
        given_profile(&pool, OWNER_ID).await;
        let id = user_roles::insert(&pool, &super_admin_role_for(OWNER_ID))
            .await
            .expect("insert");
        let update = UpdateUserRole {
            role: Some("student".to_string()),
        };

        // Act
        user_roles::update(&pool, &id, OTHER_USER_ID, &update)
            .await
            .expect("update");
        let found = user_roles::find_by_id(&pool, &id, OWNER_ID)
            .await
            .expect("find")
            .expect("present");

        // Assert
        assert_eq!(found.role, "super_admin");
    }
}

mod delete {
    use super::*;

    #[tokio::test]
    async fn it_removes_the_role_when_owned_by_the_user() {
        // Arrange
        let pool = test_pool().await;
        given_profile(&pool, OWNER_ID).await;
        let id = user_roles::insert(&pool, &super_admin_role_for(OWNER_ID))
            .await
            .expect("insert");

        // Act
        user_roles::delete(&pool, &id, OWNER_ID)
            .await
            .expect("delete");
        let found = user_roles::find_by_id(&pool, &id, OWNER_ID).await;

        // Assert
        assert_matches!(found, Ok(None));
    }

    #[tokio::test]
    async fn it_succeeds_as_a_no_op_when_the_role_does_not_exist() {
        // Arrange
        let pool = test_pool().await;

        // Act
        let result = user_roles::delete(&pool, UNKNOWN_ID, OWNER_ID).await;

        // Assert
        assert!(result.is_ok());
    }
}
