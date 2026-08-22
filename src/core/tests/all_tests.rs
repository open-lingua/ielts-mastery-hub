//! Single Cargo integration-test entry point.
//!
//! `src/core/tests/` is a sibling of `src/core/src/`, so Cargo auto-compiles
//! every `.rs` file placed directly under `tests/` as its own test binary.
//! This is the *only* file that lives directly at `tests/` root — every other
//! test module is reached from here via `mod` declarations, so the whole
//! suite compiles and runs as a single binary with no edits to any existing
//! source file (see `docs/core/testing/01-01-folder-structure.md`).

mod common;
mod database;
mod models;
mod repositories;
mod root;
mod services;
