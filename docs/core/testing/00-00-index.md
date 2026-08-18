# Unit Testing Conventions — Index

Conventions for unit tests in this Rust + Tauri 2 project. Tests live under
`src/core/tests/`. Each document below owns exactly one topic. Load only what
the current task needs.

## Document map

| File | Topic | Load when… |
|------|-------|-----------|
| `01-00-testing-philosophy.md` | AAA structure, one concept per test, no logic in tests, dev-dependencies | You are writing a brand-new test and need the ground rules or the dependency list. |
| `01-01-folder-structure.md` | Directory tree, module mirroring, file naming, `mod.rs` wiring | You are adding a new test file, fake, or builder and need to know where it goes and how to register it. |
| `02-00-naming-conventions.md` | Test/function/module/constant names | You are naming a test, a helper, a module, or a constant. |
| `02-01-assertions.md` | Assertion macro selection, argument order, error-variant asserts | You are writing an assertion and unsure which macro to use or how to order arguments. |
| `03-00-test-organization.md` | Inline vs external placement, `make_sut()`, sub-modules, `rstest` params | You are structuring a test module or deciding where a test should physically live. |
| `03-01-mocking-and-fakes.md` | Hand-written fakes, `mockall`, no-real-I/O rule | You need a test double for a collaborator (repository, client, clock). |
| `04-00-async-tests.md` | `#[tokio::test]`, time control, async fakes, no shared state | The code under test is `async` or time-dependent. |
| `04-01-tauri-command-testing.md` | Thin commands, `_inner` extraction, `AppState` injection | You are testing logic that sits behind a `#[tauri::command]`. |
| `05-00-error-handling-in-tests.md` | `unwrap` policy, `?` in tests, exact-variant asserts, fixture constants | The test exercises a failure path or you are tempted to `unwrap`. |
| `05-01-test-data-builders.md` | Builder pattern, `with_*`, `default_<entity>()`, `build()` safety | You need to construct domain objects for a test. |

## Quick rules (always apply)

- **AAA layout.** Every test is three visually separated blocks: Arrange, Act, Assert. No interleaving.
- **One concept per test.** A test asserts one behavior. If the name needs "and", split it.
- **No logic in tests.** No `if`, `for`, `while`, or arithmetic in a test body. Loops belong in `rstest` cases, not in the body.
- **Name pattern.** `it_<verb>_<outcome>_when_<condition>`.
- **Argument order.** All equality-style assertions take `(actual, expected)`.
- **`unwrap` is setup-only.** Arrange may `unwrap`. Act/Assert never do — use `?` or `assert_matches!`.
- **No real I/O.** No filesystem, network, database, or wall-clock access in a unit test. Inject a fake.
- **Deterministic.** No randomness, no `SystemTime::now()`, no ordering assumptions. Same input, same result, every run.
- **`build()` never panics.** Builders start from valid defaults; a call with no `with_*` must succeed.
- **Test doubles live under `tests/common/`** and are `#[cfg(test)]`-only. They never ship in the binary.
