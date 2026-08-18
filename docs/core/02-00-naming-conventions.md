# Naming Conventions

Names are the primary documentation of a test suite. A reader should understand
what broke from the failing test's name alone, without opening the body.

## Test function pattern

```
it_<verb>_<outcome>_when_<condition>
```

- `<verb>` — what the unit does (`returns`, `rejects`, `retries`, `emits`).
- `<outcome>` — the observable result (`total`, `not_found_error`, `empty_list`).
- `<condition>` — the input state that triggers it (`cart_is_empty`, `user_missing`).

```rust
#[test]
fn it_returns_zero_when_cart_is_empty() { /* ... */ }

#[test]
fn it_rejects_negative_price_when_item_is_added() { /* ... */ }

#[test]
fn it_returns_not_found_error_when_user_is_missing() { /* ... */ }
```

Drop the `when_<condition>` suffix only when the behavior is unconditional:

```rust
#[test]
fn it_starts_with_an_empty_history() { /* ... */ }
```

If a name needs `and`, the test covers two concepts — split it.

## Module names

Test modules are named after what they group, not after the fact that they are
tests. Group by the production unit or by the behavior under test.

```rust
mod total {          // groups all tests about Cart::total
    use super::*;
    // ...
}

mod checkout {       // groups all tests about Cart::checkout
    use super::*;
    // ...
}
```

Never `mod tests_1`, `mod misc`, or `mod other`.

## Helper function names

Helpers read as plain verbs and say what they produce, not that they are helpers.

| Role | Pattern | Example |
|------|---------|---------|
| System-under-test factory | `make_sut` | `make_sut()` |
| Builder shortcut | `default_<entity>` | `default_user()` |
| Fake constructor | `fake_<collaborator>` | `fake_repository()` |
| Arrange helper | `given_<state>` | `given_registered_user()` |

Avoid `setup`, `helper`, `util`, `do_test`, `test_helper` — they say nothing.

## Constant naming policy

No magic values. Every literal that carries meaning becomes an `UPPER_SNAKE_CASE`
constant with a name that states its role, declared at the top of the module.

```rust
const VALID_EMAIL: &str = "ada@example.com";
const UNKNOWN_USER_ID: u64 = 9_999;
const DEFAULT_PRICE_CENTS: u32 = 150;

#[test]
fn it_returns_not_found_error_when_user_is_missing() {
    let sut = make_sut();

    let result = sut.find(UNKNOWN_USER_ID);

    assert_matches!(result, Err(CoreError::NotFound));
}
```

Purely structural throwaway values (a `0` index, an empty `vec![]`) need no
constant. Anything a reader might ask "why this number?" about does.
