# Test Organization

Where a test lives and how a module is shaped are conventions, not preferences.

## Inline vs external placement

| Test kind | Location | Reason |
|-----------|----------|--------|
| Private-function unit tests | Inline `#[cfg(test)] mod tests` in the production file | Needs access to private items. |
| Public-behavior unit tests | External `src/core/tests/<area>/<name>_test.rs` | Keeps production files short; exercises the public surface. |

Default to **external**. Use inline only when a test genuinely must reach a
private item that should stay private.

```rust
// src/core/user/service.rs  — inline, private helper only
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_normalizes_email_to_lowercase() {
        assert_eq!(normalize_email("ADA@EXAMPLE.COM"), "ada@example.com");
    }
}
```

```rust
// src/core/tests/user/service_test.rs — external, public behavior
use crate::core::tests::common::builders::UserBuilder;
use crate::core::tests::common::fakes::FakeUserRepository;
use crate::core::user::service::UserService;
```

## `make_sut()` factory pattern

Every external test module constructs its system-under-test through one
`make_sut()` factory. This centralizes wiring so a constructor change touches one
line, not every test. "SUT" = system under test.

```rust
fn make_sut() -> UserService<FakeUserRepository> {
    UserService::new(FakeUserRepository::new())
}
```

When a test needs a pre-configured collaborator, accept it as a parameter and
keep the zero-arg form as the common case:

```rust
fn make_sut_with(repo: FakeUserRepository) -> UserService<FakeUserRepository> {
    UserService::new(repo)
}

fn make_sut() -> UserService<FakeUserRepository> {
    make_sut_with(FakeUserRepository::new())
}
```

Tests then read uniformly:

```rust
#[test]
fn it_returns_not_found_error_when_user_is_missing() {
    let sut = make_sut();

    let result = sut.find(UNKNOWN_USER_ID);

    assert_matches!(result, Err(CoreError::NotFound));
}
```

## Sub-module grouping by behavior

Group tests into sub-modules named after the behavior, one module per public
method or scenario cluster. Shared constants and `make_sut` sit in the parent.

```rust
const KNOWN_USER_ID: u64 = 1;
const UNKNOWN_USER_ID: u64 = 9_999;

fn make_sut() -> UserService<FakeUserRepository> { /* ... */ }

mod find {
    use super::*;

    #[test]
    fn it_returns_the_user_when_id_exists() { /* ... */ }

    #[test]
    fn it_returns_not_found_error_when_user_is_missing() { /* ... */ }
}

mod register {
    use super::*;

    #[test]
    fn it_rejects_registration_when_email_is_taken() { /* ... */ }
}
```

## `rstest` parameterized tests

Use `rstest` for the same assertion over many inputs. One `#[case]` per row,
literal input and literal expectation. This replaces loops in the body.

```rust
use rstest::rstest;

#[rstest]
#[case("ada@example.com", true)]
#[case("no-at-sign", false)]
#[case("", false)]
fn it_validates_email_format(#[case] input: &str, #[case] expected: bool) {
    assert_eq!(is_valid_email(input), expected);
}
```

Fixtures inject shared arrange-state:

```rust
#[fixture]
fn sut() -> UserService<FakeUserRepository> {
    make_sut()
}

#[rstest]
fn it_starts_with_no_users(sut: UserService<FakeUserRepository>) {
    assert_eq!(sut.count(), 0);
}
```

Reach for `rstest` when cases share one assertion; keep separate `#[test]`
functions when each scenario asserts something different.
