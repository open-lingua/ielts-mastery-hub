# Test Data Builders

Builders construct domain objects for tests with valid defaults, so each test
overrides only the field it cares about. This kills constructor churn and makes
the *relevant* field of a test visible.

## Builder struct with `with_*` methods and valid defaults

A builder mirrors one domain type, starts from valid defaults via `Default`, and
exposes one chainable `with_<field>` per attribute. Builders live in
`tests/common/builders/<entity>_builder.rs`.

```rust
// src/core/tests/common/builders/user_builder.rs
use crate::core::user::User;

const DEFAULT_ID: u64 = 1;
const DEFAULT_EMAIL: &str = "user@example.com";

pub struct UserBuilder {
    id: u64,
    email: String,
    is_banned: bool,
}

impl Default for UserBuilder {
    fn default() -> Self {
        Self {
            id: DEFAULT_ID,
            email: DEFAULT_EMAIL.to_string(),
            is_banned: false,
        }
    }
}

impl UserBuilder {
    pub fn with_id(mut self, id: u64) -> Self {
        self.id = id;
        self
    }

    pub fn with_email(mut self, email: &str) -> Self {
        self.email = email.to_string();
        self
    }

    pub fn with_banned(mut self, is_banned: bool) -> Self {
        self.is_banned = is_banned;
        self
    }

    pub fn build(self) -> User {
        User {
            id: self.id,
            email: self.email,
            is_banned: self.is_banned,
        }
    }
}
```

Each test states only what matters to it:

```rust
let banned = UserBuilder::default().with_banned(true).build();
```

## `default_<entity>()` shortcut

For the very common "any valid instance, I don't care about the fields" case,
provide a free function so tests don't repeat `UserBuilder::default().build()`.

```rust
pub fn default_user() -> User {
    UserBuilder::default().build()
}
```

```rust
#[test]
fn it_stores_the_user_when_saved() {
    let user = default_user();
    // ...
}
```

## `build()` must never panic from defaults

The defaults are a valid object. `UserBuilder::default().build()` and
`default_user()` always succeed — no `unwrap`, no validation error, no panic
inside `build()`. If a valid default is impossible without a fallible step, keep
the fallible work behind an explicit `with_*` the caller opts into; the default
path stays infallible.

```rust
// Good: build() cannot panic; defaults are already valid.
pub fn build(self) -> User { User { id: self.id, email: self.email, is_banned: self.is_banned } }

// Bad: build() can blow up, so every test risks an unrelated panic.
pub fn build(self) -> User { User::parse(&self.raw).unwrap() }
```

This is what lets tests trust Arrange and reserve failure for the Act result.

## `#[cfg(test)]`-only scope

Builders are test infrastructure and must never compile into the shipped binary.
The entire test tree is already gated by `#[cfg(test)] mod tests;` in
`src/core/mod.rs` (see `01-01-folder-structure.md`), so builders under
`tests/common/builders/` are test-only by construction. Do not place a builder in
a production module; if one leaks out, move it under `tests/`.

## Module registration pattern

Register each builder file and re-export its type from `builders/mod.rs` so tests
import from a single path.

```rust
// src/core/tests/common/builders/mod.rs
mod user_builder;
mod order_builder;

pub use order_builder::{default_order, OrderBuilder};
pub use user_builder::{default_user, UserBuilder};
```

```rust
// in a test file
use crate::core::tests::common::builders::{default_user, UserBuilder};
```

One builder per domain type, one `pub use` line per builder, imported from
`common::builders`. Adding a builder means adding its file, its `mod` line, and
its `pub use` in the same step.
