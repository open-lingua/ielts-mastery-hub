# Async Tests

Async units are tested on the Tokio runtime. They stay deterministic: time is
controlled, not observed, and no state leaks between tests.

## `#[tokio::test]`

Replace `#[test]` with `#[tokio::test]` for `async fn` tests. Keep AAA and all
naming rules unchanged.

```rust
#[tokio::test]
async fn it_returns_the_user_when_id_exists() {
    // Arrange
    let sut = make_sut();

    // Act
    let user = sut.find(KNOWN_USER_ID).await.unwrap();

    // Assert
    assert_eq!(user.id, KNOWN_USER_ID);
}
```

Choose the smallest runtime the test needs. Single-threaded is the default and
keeps ordering predictable:

```rust
#[tokio::test(flavor = "current_thread")]
async fn it_completes_without_spawning() { /* ... */ }
```

Only use `flavor = "multi_thread"` when the unit genuinely spawns concurrent tasks
that must run in parallel.

## Time control with `tokio::time::pause()`

Never sleep in real time. Pause the clock, then advance it deliberately. This
requires the `test-util` feature (see `01-00-testing-philosophy.md`).

```rust
use std::time::Duration;
use tokio::time::{advance, pause};

#[tokio::test(start_paused = true)]
async fn it_times_out_when_response_is_slow() {
    // Arrange — clock is paused from the start.
    let sut = make_sut();
    let call = sut.fetch_with_timeout(Duration::from_secs(5));

    // Act — jump past the deadline instantly; no real waiting.
    advance(Duration::from_secs(6)).await;
    let result = call.await;

    // Assert
    assert_matches!(result, Err(CoreError::Timeout));
}
```

`start_paused = true` is equivalent to calling `pause()` first thing. A paused
test that exercises a 30-second timeout finishes in microseconds.

## Async trait fakes

Async collaborators sit behind async traits. Fakes implement them with
`async fn` and in-memory state — still no I/O.

```rust
use crate::core::CoreError;
use crate::core::user::User;

pub trait AsyncUserRepository {
    async fn find(&self, id: u64) -> Result<User, CoreError>;
}

#[derive(Default)]
pub struct FakeAsyncUserRepository {
    users: std::collections::HashMap<u64, User>,
}

impl FakeAsyncUserRepository {
    pub fn with_user(mut self, user: User) -> Self {
        self.users.insert(user.id, user);
        self
    }
}

impl AsyncUserRepository for FakeAsyncUserRepository {
    async fn find(&self, id: u64) -> Result<User, CoreError> {
        self.users.get(&id).cloned().ok_or(CoreError::NotFound)
    }
}
```

`mockall` supports async traits too; annotate with `#[automock]` and use
`.returning(|_| Box::pin(async { Ok(...) }))` when the interaction is the point.

## No shared async state between tests

Each test owns its state. Do not share a runtime, a connection pool, a global
registry, or a `static` across tests.

```rust
// Bad: shared mutable global; tests interfere and order matters.
static CACHE: Lazy<Mutex<HashMap<u64, User>>> = Lazy::new(Default::default);

// Good: fresh state per test, built in Arrange.
fn make_sut() -> UserService<FakeAsyncUserRepository> {
    UserService::new(FakeAsyncUserRepository::default())
}
```

Tests run concurrently by default. Shared state makes them flaky and
order-dependent. Every `#[tokio::test]` starts from a clean slate it constructed
itself.
