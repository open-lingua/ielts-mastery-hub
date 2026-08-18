# Assertions

Pick the narrowest assertion that expresses the intent. A precise assertion
fails with a precise message.

## Macro selection table

| Situation | Macro | Source |
|-----------|-------|--------|
| Two values are equal | `assert_eq!(actual, expected)` | `pretty_assertions` |
| Two values differ | `assert_ne!(actual, unexpected)` | `pretty_assertions` |
| A boolean condition holds | `assert!(condition)` | std |
| Value matches an enum variant / pattern | `assert_matches!(actual, Pattern)` | `assert_matches` |
| Exact error variant on a `Result` | `assert_matches!(result, Err(Variant))` | `assert_matches` |
| Result is `Ok`, value irrelevant | `assert!(result.is_ok())` | std |

Import `pretty_assertions` so `assert_eq!`/`assert_ne!` produce aligned diffs:

```rust
use pretty_assertions::{assert_eq, assert_ne};
use assert_matches::assert_matches;
```

Prefer `assert_eq!` over `assert!(a == b)` — the former prints both values, the
latter prints only `false`.

## Argument order: `(actual, expected)`

Actual first, expected second — always. Consistency lets a reader trust the diff
direction without checking.

```rust
// Good
assert_eq!(cart.total(), 350);

// Bad: reversed, diff reads backwards
assert_eq!(350, cart.total());
```

The expected side is a literal or a named constant, never a recomputation of the
production formula.

## Asserting exact error variants

Never settle for `is_err()` when the variant matters. `assert_matches!` pins the
exact case and lets you bind inner fields.

```rust
// Weak: any error passes, even the wrong one.
assert!(sut.withdraw(1_000).is_err());

// Strong: only this variant passes.
assert_matches!(sut.withdraw(1_000), Err(BankError::InsufficientFunds));

// With a field check on the bound value.
assert_matches!(
    sut.withdraw(1_000),
    Err(BankError::InsufficientFunds { available }) if available == 250
);
```

See `05-00-error-handling-in-tests.md` for the full error-path policy.

## Custom assertion helper rules

Write a helper only when the same multi-line check repeats across tests. A helper
must:

- take `actual` first,
- assert internally (return `()`), never return a bool,
- name the property it checks: `assert_is_sorted`, `assert_valid_email`,
- carry no branching logic beyond the assertion itself.

```rust
fn assert_is_sorted(values: &[i32]) {
    assert!(
        values.windows(2).all(|w| w[0] <= w[1]),
        "expected sorted, got {values:?}"
    );
}

#[test]
fn it_returns_ascending_order_when_sorted() {
    let sut = make_sut();

    let out = sut.sort(vec![3, 1, 2]);

    assert_is_sorted(&out);
}
```

One helper, one property. Do not build a mini-framework.
