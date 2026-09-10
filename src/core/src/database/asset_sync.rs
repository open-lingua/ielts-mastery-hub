use std::path::PathBuf;

/// Outcome of a seed-asset sync pass (`writing_assets_migration::sync_writing_assets_from_dir`
/// / `listening_assets_migration::sync_listening_assets_from_dir`), shared by both modules so
/// callers (`database::init` and tests) can assert on what actually happened rather than
/// inferring it from `eprintln!` side effects or a bare `Ok(())`.
///
/// A missing seed source directory is **never** treated as a hard failure here: it's a
/// legitimate state (e.g. a build that intentionally ships without seed assets, or a `tauri
/// dev` environment where bundled resources aren't laid out the same way as a packaged app).
/// `Err` is reserved for genuine hard failures unrelated to the seed directory itself (e.g. a
/// missing `$HOME`).
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum AssetSyncOutcome {
    /// The seed source directory existed and was walked; `copied` is the number of files
    /// actually written to local storage (files already present at their destination are not
    /// counted, since the sync is idempotent/additive).
    Synced { copied: usize },
    /// The seed source directory did not exist, so nothing was copied. This is logged at
    /// `warn!` level by the caller (see `writing_assets_migration`/`listening_assets_migration`)
    /// so it's loudly visible in dev/packaged-build logs, even though it doesn't fail startup.
    SourceMissing { source_dir: PathBuf },
}
