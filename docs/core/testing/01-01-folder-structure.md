# Folder Structure

Tests are external modules under `src/core/tests/`, compiled only in test builds.
The test tree mirrors the production tree so any file has one obvious home.

## Directory tree

```
src/
└── core/
    ├── mod.rs                     # declares production modules + `#[cfg(test)] mod tests;`
    ├── user/
    │   ├── mod.rs
    │   ├── service.rs
    │   └── repository.rs
    ├── order/
    │   ├── mod.rs
    │   └── service.rs
    └── tests/
        ├── mod.rs                 # declares `common` + one module per production module
        ├── common/
        │   ├── mod.rs
        │   ├── fakes/
        │   │   ├── mod.rs
        │   │   ├── fake_user_repository.rs
        │   │   └── fake_clock.rs
        │   └── builders/
        │       ├── mod.rs
        │       ├── user_builder.rs
        │       └── order_builder.rs
        ├── user/
        │   ├── mod.rs
        │   ├── service_test.rs    # mirrors user/service.rs
        │   └── repository_test.rs # mirrors user/repository.rs
        └── order/
            ├── mod.rs
            └── service_test.rs    # mirrors order/service.rs
```

## Mirroring convention

For a production file `src/core/<area>/<name>.rs`, its tests live at
`src/core/tests/<area>/<name>_test.rs`. One production module, one test module,
same relative path. No `service_test.rs` covering three unrelated files.

## File naming rules

| Pattern | Meaning | Example |
|---------|---------|---------|
| `<name>_test.rs` | Tests for the production file `<name>.rs` | `service_test.rs` |
| `fake_<collaborator>.rs` | Hand-written fake of a trait | `fake_user_repository.rs` |
| `<entity>_builder.rs` | Test data builder for a domain type | `user_builder.rs` |

Shared doubles go in `common/`; nothing test-only lives outside `tests/`.

## Wiring modules in `mod.rs`

Production `src/core/mod.rs` gates the whole test tree behind `cfg(test)`:

```rust
// src/core/mod.rs
pub mod user;
pub mod order;

#[cfg(test)]
mod tests;
```

`src/core/tests/mod.rs` declares shared helpers first, then one module per area:

```rust
// src/core/tests/mod.rs
mod common;

mod user;
mod order;
```

Each area `mod.rs` declares its test files:

```rust
// src/core/tests/user/mod.rs
mod service_test;
mod repository_test;
```

`common/mod.rs` re-exports doubles so tests import from one place:

```rust
// src/core/tests/common/mod.rs
pub mod fakes;
pub mod builders;
```

```rust
// src/core/tests/common/fakes/mod.rs
mod fake_user_repository;
mod fake_clock;

pub use fake_clock::FakeClock;
pub use fake_user_repository::FakeUserRepository;
```

A new test file is unreachable until its `mod` line is added — adding the file
and the `mod` line is a single step.
