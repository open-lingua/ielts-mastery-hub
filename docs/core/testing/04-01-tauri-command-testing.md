# Tauri Command Testing

`#[tauri::command]` functions are wiring, not logic. They are kept thin so the
real behavior lives in plain functions that need no Tauri runtime to test.

## Thin-command pattern

A command does three things and nothing more: pull dependencies out of
`tauri::State`, delegate to an `_inner` function, map the result to the wire type.
No business logic in the command body.

```rust
// src/core/user/command.rs
use tauri::State;
use crate::core::AppState;
use crate::core::user::User;

#[tauri::command]
pub async fn get_user(id: u64, state: State<'_, AppState>) -> Result<User, String> {
    get_user_inner(id, state.user_repository.as_ref())
        .await
        .map_err(|e| e.to_string())
}
```

The command holds no branching, no validation, no computation — only extraction
and delegation.

## Extract an `_inner` function

The `_inner` function takes plain trait objects (or generics), returns the domain
`Result`, and contains all the logic. It is unit-testable with a fake — no
`tauri::State`, no `AppHandle`, no runtime.

```rust
use crate::core::user::repository::UserRepository;
use crate::core::user::User;
use crate::core::CoreError;

pub async fn get_user_inner(
    id: u64,
    repository: &dyn UserRepository,
) -> Result<User, CoreError> {
    let user = repository.find(id)?;
    if user.is_banned {
        return Err(CoreError::Forbidden);
    }
    Ok(user)
}
```

Tests target `_inner` directly:

```rust
// src/core/tests/user/command_test.rs
use crate::core::tests::common::builders::UserBuilder;
use crate::core::tests::common::fakes::FakeUserRepository;
use crate::core::user::command::get_user_inner;
use crate::core::CoreError;

const KNOWN_USER_ID: u64 = 1;

#[tokio::test]
async fn it_returns_forbidden_error_when_user_is_banned() {
    // Arrange
    let banned = UserBuilder::default()
        .with_id(KNOWN_USER_ID)
        .with_banned(true)
        .build();
    let repository = FakeUserRepository::new().with_user(banned);

    // Act
    let result = get_user_inner(KNOWN_USER_ID, &repository).await;

    // Assert
    assert_matches!(result, Err(CoreError::Forbidden));
}
```

## `AppState` with trait objects for injection

`AppState` holds collaborators as trait objects (or generics), never concrete
I/O types. Production wires the real implementation; tests never build `AppState`
at all — they pass fakes straight to `_inner`.

```rust
// src/core/mod.rs
use std::sync::Arc;
use crate::core::user::repository::UserRepository;

pub struct AppState {
    pub user_repository: Arc<dyn UserRepository + Send + Sync>,
}
```

```rust
// production wiring (e.g. in lib.rs setup)
let state = AppState {
    user_repository: Arc::new(SqliteUserRepository::connect(&db_url)?),
};
```

Because the field is a trait object, the same `_inner` runs against
`SqliteUserRepository` in production and `FakeUserRepository` in tests.

## What not to test at the command layer

Do not write unit tests that:

- construct `tauri::State`, `AppHandle`, or a real `Builder`,
- assert the command's `String` error formatting (test `CoreError` variants at
  the `_inner` level instead),
- re-test logic already covered by `_inner` tests,
- exercise the IPC serialization boundary.

The command's only untested surface is the trivial extract-delegate-map glue.
Cover the glue integration once, end to end, in a separate integration test — not
in the unit suite. Everything with a decision in it lives in `_inner` and is
tested there.
