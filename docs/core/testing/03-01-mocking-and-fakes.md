# Mocking and Fakes

Collaborators are injected as trait objects or generics and replaced with test
doubles. A unit test never touches a real database, filesystem, network, or
clock.

## Two kinds of double

| Double | Use it for | Verifies |
|--------|-----------|----------|
| **Fake** (hand-written) | Stateful collaborators you query repeatedly (repositories, caches, clocks) | State / behavior via its own query methods. |
| **Mock** (`mockall`) | Interaction-heavy collaborators where the *call* is the behavior (event emitters, one-shot clients) | That specific calls happened, with specific args. |

Prefer a fake when the double holds data. Prefer a mock when the test's point is
"this method was called with these arguments".

## Hand-written fake structure

A fake implements the same trait as the real thing, backed by in-memory state,
with query methods a test can assert against. Fakes live in
`tests/common/fakes/fake_<collaborator>.rs`.

```rust
// src/core/tests/common/fakes/fake_user_repository.rs
use std::collections::HashMap;
use crate::core::user::repository::UserRepository;
use crate::core::user::User;
use crate::core::CoreError;

#[derive(Default)]
pub struct FakeUserRepository {
    users: HashMap<u64, User>,
}

impl FakeUserRepository {
    pub fn new() -> Self {
        Self::default()
    }

    /// Arrange helper: preload a user without going through `save`.
    pub fn with_user(mut self, user: User) -> Self {
        self.users.insert(user.id, user);
        self
    }

    /// Assert helper: let tests inspect stored state.
    pub fn saved_count(&self) -> usize {
        self.users.len()
    }
}

impl UserRepository for FakeUserRepository {
    fn find(&self, id: u64) -> Result<User, CoreError> {
        self.users.get(&id).cloned().ok_or(CoreError::NotFound)
    }

    fn save(&mut self, user: User) -> Result<(), CoreError> {
        self.users.insert(user.id, user);
        Ok(())
    }
}
```

A fake is behavior-complete for the trait, deterministic, and has no I/O. Its
`with_*` methods arrange state; its plain getters assert it.

## `mockall` usage and when to prefer it

Annotate the trait with `#[cfg_attr(test, automock)]` so the mock exists only in
test builds:

```rust
use mockall::automock;

#[cfg_attr(test, automock)]
pub trait EventEmitter {
    fn emit(&self, name: &str, payload: &str) -> Result<(), CoreError>;
}
```

Set expectations in Arrange; `mockall` verifies them on drop:

```rust
use mockall::predicate::eq;

#[test]
fn it_emits_created_event_when_user_is_registered() {
    // Arrange
    let mut emitter = MockEventEmitter::new();
    emitter
        .expect_emit()
        .with(eq("user_created"), eq(VALID_EMAIL))
        .times(1)
        .returning(|_, _| Ok(()));
    let sut = UserService::new(emitter);

    // Act
    let result = sut.register(VALID_EMAIL);

    // Assert
    assert!(result.is_ok());
    // `emitter` drop asserts emit was called exactly once with those args.
}
```

Use `mockall` when the assertion is about the interaction (call count, arguments,
ordering). Use a fake when the assertion is about resulting state.

## Strict no-real-I/O rule

Unit tests must not:

- open, read, or write files,
- open sockets or make HTTP calls,
- connect to a database,
- read `SystemTime::now()`, `Instant::now()`, or environment variables,
- spawn OS processes.

Every such dependency sits behind a trait and is injected. A `Clock` trait with a
`FakeClock` replaces wall-clock time; a `Repository` trait replaces the database.
If a unit cannot be tested without real I/O, the seam is missing — add the trait,
do not weaken the rule.
