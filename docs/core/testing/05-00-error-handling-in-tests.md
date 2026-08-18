# Error Handling in Tests

A test's failure message should point at the assertion that failed, not at an
incidental `unwrap` three lines earlier.

## `unwrap` policy: setup only

`unwrap` / `expect` are allowed **only in Arrange**, where a failure means the
test itself is misconfigured. They are banned in Act and Assert.

```rust
#[test]
fn it_returns_the_stored_email_when_user_exists() {
    // Arrange — unwrap is fine; a failure here is a broken fixture.
    let user = UserBuilder::default().with_email(VALID_EMAIL).build();
    let repository = FakeUserRepository::new().with_user(user);
    let sut = make_sut_with(repository);

    // Act — no unwrap; the call's outcome IS the thing under test.
    let result = sut.find(KNOWN_USER_ID);

    // Assert — assert the Result, don't unwrap it.
    assert_matches!(result, Ok(user) if user.email == VALID_EMAIL);
}
```

Prefer `expect("reason")` over bare `unwrap()` in Arrange so a broken fixture
explains itself.

## `?` in test return types

When the happy path threads several fallible setup calls, let the test return
`Result` and use `?` instead of stacking `unwrap`s. This keeps Arrange flat and
readable.

```rust
#[test]
fn it_persists_the_user_when_saved() -> Result<(), CoreError> {
    // Arrange
    let mut sut = make_sut();
    let user = UserBuilder::default().build();

    // Act
    sut.save(user.clone())?;
    let loaded = sut.find(user.id)?;

    // Assert
    assert_eq!(loaded.id, user.id);
    Ok(())
}
```

Use a return type of `Result<(), CoreError>` (or `anyhow::Result<()>` if the
crate already depends on `anyhow`). `?` is for setup convenience — the *asserted*
result still goes through `assert_matches!`, never `?`.

## Asserting exact error variants

Failure-path tests pin the exact variant with `assert_matches!`. `is_err()` is
too weak: it passes for the wrong error.

```rust
#[test]
fn it_returns_conflict_error_when_email_is_taken() {
    // Arrange
    let existing = UserBuilder::default().with_email(TAKEN_EMAIL).build();
    let sut = make_sut_with(FakeUserRepository::new().with_user(existing));

    // Act
    let result = sut.register(TAKEN_EMAIL);

    // Assert — exact variant, and a bound-field check.
    assert_matches!(result, Err(CoreError::Conflict { field }) if field == "email");
}
```

## Fixture string constants

Error-path tests reuse the same sentinel inputs. Declare them once as named
constants so the meaning is explicit and the value lives in one place.

```rust
const VALID_EMAIL: &str = "ada@example.com";
const TAKEN_EMAIL: &str = "taken@example.com";
const MALFORMED_EMAIL: &str = "no-at-sign";
const UNKNOWN_USER_ID: u64 = 9_999;
```

A raw `"taken@example.com"` scattered across five tests hides intent and invites
typos; `TAKEN_EMAIL` states why the value matters. No magic strings in error
tests.
