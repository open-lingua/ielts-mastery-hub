# Testing Philosophy

A unit test documents one behavior of one unit and fails for exactly one reason.
Everything below serves that goal.

## AAA — Arrange, Act, Assert

Every test has three blocks, in order, separated by a blank line. No block is
skipped, none is reordered.

- **Arrange** — build inputs and doubles, put the system into the starting state.
- **Act** — call the one function under test. Exactly one call.
- **Assert** — check the outcome.

```rust
#[test]
fn it_returns_total_when_cart_has_two_items() {
    // Arrange
    let cart = CartBuilder::default()
        .with_item("apple", 150)
        .with_item("pear", 200)
        .build();

    // Act
    let total = cart.total();

    // Assert
    assert_eq!(total, 350);
}
```

If "Act" needs more than one call, the unit is doing too much or the test is
covering more than one concept.

## One concept per test

A test asserts a single behavior. Multiple `assert_eq!` calls are fine *only* if
they describe the same concept (e.g. the two fields of one returned struct).

```rust
// Good: one concept (the parsed result), two facets of it.
#[test]
fn it_parses_both_fields_when_input_is_valid() {
    let parsed = parse("name=ada;age=36").unwrap();

    assert_eq!(parsed.name, "ada");
    assert_eq!(parsed.age, 36);
}

// Bad: two concepts. Split into two tests.
#[test]
fn it_parses_and_rejects() {
    assert!(parse("name=ada").is_ok());
    assert!(parse("garbage").is_err()); // <-- second concept
}
```

## No logic in tests

Test bodies contain no control flow (`if`, `match`, `for`, `while`) and no
computation. A test that computes its own expected value can reproduce the bug
it is meant to catch.

```rust
// Bad: the test recomputes the answer.
#[test]
fn it_doubles_each_value() {
    let input = vec![1, 2, 3];
    let out = double_all(&input);
    for (i, v) in input.iter().enumerate() {
        assert_eq!(out[i], v * 2); // logic + duplicated formula
    }
}

// Good: parameterized cases, literal expectations.
#[rstest]
#[case(1, 2)]
#[case(2, 4)]
#[case(3, 6)]
fn it_doubles_the_value(#[case] input: i32, #[case] expected: i32) {
    assert_eq!(double(input), expected);
}
```

Iteration over cases is expressed with `rstest`, never with a loop in the body.

## Required dev-dependencies

```toml
[dev-dependencies]
tokio = { version = "1.40", features = ["macros", "rt", "test-util", "time"] }
mockall = "0.13"
rstest = "0.23"
pretty_assertions = "1.4"
assert_matches = "1.5"
```

- `tokio` — async test runtime; `test-util` enables time control, `macros` enables `#[tokio::test]`.
- `mockall` — generated mocks for trait collaborators.
- `rstest` — fixtures and parameterized cases.
- `pretty_assertions` — colored, aligned diffs for `assert_eq!` / `assert_ne!`.
- `assert_matches` — assert a value matches an exact enum variant / pattern.

Pin the minor version. Bump deliberately, never as a side effect of another change.
