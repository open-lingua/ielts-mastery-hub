# Releases

Binary releases can be downloaded manually at:
https://github.com/open-lingua/ielts-mastery-hub/releases

## Release automation

Publishing a GitHub Release (`release: published`) triggers
[`.github/workflows/release.yml`](.github/workflows/release.yml), which builds the desktop app
for macOS (Apple Silicon + Intel), Linux (x64 + ARM64), and Windows (x64 + ARM64) in parallel and
uploads the resulting installers (`.dmg`, `.deb`, `.rpm`, `.AppImage`, `.msi`, NSIS `-setup.exe`)
as assets on that release automatically — no manual steps required beyond tagging/publishing the
release.

> **Note:** Linux ARM64 and Windows ARM64 builds run on native GitHub-hosted ARM64 runners
> (`ubuntu-22.04-arm`, `windows-11-arm`). On private repositories, access to these runners
> requires a GitHub plan that supports ARM64-hosted runners (e.g. Team/Enterprise).

The workflow only requires the built-in `GITHUB_TOKEN` (provided automatically by GitHub Actions)
— no additional repository secrets need to be configured.

## Version bumping & changelog generation

> **This section (and the version headings below it) are now generated content.** Do not hand-edit
> past entries, and do not manually bump `package.json` / `src/core/Cargo.toml` /
> `src/core/tauri.conf.json` versions — see below for the one supported way to cut a release.

Versions used to be bumped by hand across three files (`package.json`, `src/core/Cargo.toml`,
`src/core/tauri.conf.json`), which caused real drift in production (see the
`1.0.0-beta.13` / "fix: sync tauri.conf.json version with Cargo.toml" entry below). This is now
fully automated with [release-please](https://github.com/googleapis/release-please):

1. Merge PRs to `main` with a [Conventional Commits](https://www.conventionalcommits.org/)-style
   title (e.g. `feat: ...`, `fix(core): ...`, `chore: ...`) — this is enforced by
   [`.github/workflows/pr-title-lint.yml`](.github/workflows/pr-title-lint.yml), since squash-merge
   makes the PR title the commit message that release-please parses.
2. [`.github/workflows/release-please.yml`](.github/workflows/release-please.yml) runs on every
   push to `main`. It maintains a standing "Release PR" that:
   - Computes the next `X.Y.Z-beta.N` version from the accumulated conventional commits.
   - Updates `package.json`, `src/core/Cargo.toml`, and `src/core/tauri.conf.json` to the same
     version, in the same commit (config: [`release-please-config.json`](release-please-config.json),
     seeded version: [`.release-please-manifest.json`](.release-please-manifest.json)).
   - Prepends a new dated section to this file (`RELEASES.md`), grouped by commit type
     (Features/Bug Fixes/Chores/etc.), from the commits since the last release.
   - Refreshes `src/core/Cargo.lock`'s core-crate version entry via a follow-up job
     (`cargo generate-lockfile`) and pushes that onto the same PR branch.
3. Merging that Release PR tags the release as `X.Y.Z-beta.N` (no `v`/component prefix, matching
   this repo's existing tag history) and publishes the GitHub Release — which is what triggers
   `release.yml` above, unchanged.
4. A `version-consistency` CI job ([`.github/workflows/ci-linux.yml`](.github/workflows/ci-linux.yml),
   backed by `scripts/check-version-consistency.mjs`) fails any PR where the three version-bearing
   files disagree, as defense in depth against manual edits reintroducing drift.

**Note:** release-please must authenticate with a fine-grained Personal Access Token stored as the
`RELEASE_PLEASE_TOKEN` repository secret, not the default `GITHUB_TOKEN`. This is a hard GitHub
Actions platform constraint — actions performed with the default `GITHUB_TOKEN` never re-trigger
other workflows (to prevent recursive runs), which would otherwise silently prevent the GitHub
Release from triggering `release.yml`. This is the one exception to "no additional secrets."

See
[`website/docs/internals/contributing/release-process.mdx`](website/docs/internals/contributing/release-process.mdx)
for more detail on the changelog format and versioning scheme.

## Known issues / accepted risks

- **`image-size` DoS advisories in the `website/` docs site (GHSA-w3rx-r6r6-pgpr, GHSA-5p2g-fcmc-qvqq):**
  `@docusaurus/mdx-loader` depends on `image-size@2.0.2` (the latest published version), which has
  two open infinite-loop DoS advisories with no patched release available upstream as of this
  writing. This cascades into most first-party Docusaurus packages being flagged by `npm audit`
  (`@docusaurus/core`, `preset-classic`, theme/plugin packages, `@easyops-cn/docusaurus-search-local`,
  etc.), but none of those packages have independent vulnerabilities of their own. `image-size` is
  only invoked at **build time** against **repo-controlled** markdown/image assets, not
  attacker-supplied user uploads, so real-world exploitability for this internal docs site is low.
  Accepted as a tracked risk; revisit once `image-size` ships a patched release.

## [1.0.0-beta.16](https://github.com/open-lingua/ielts-mastery-hub/compare/1.0.0-beta.15...1.0.0-beta.16) (2026-08-23)


### Features

* add IELTS academic reading seed — Band 6.0 test 001 ([89dc0d5](https://github.com/open-lingua/ielts-mastery-hub/commit/89dc0d58165604c95adb518cb716ccbf213e9bfa))
* add IELTS academic reading seed — Band 6.0 test 002 ([dc56666](https://github.com/open-lingua/ielts-mastery-hub/commit/dc56666005ad23084cbc7fcd7818fa3e99d1045a))
* add IELTS academic reading seed — Band 7.0 test 002 ([b41f3e5](https://github.com/open-lingua/ielts-mastery-hub/commit/b41f3e54ee0bd0f6540f37c1e918c35474909329))
* add IELTS academic reading seed — Band 7.0 test 003 ([628e6db](https://github.com/open-lingua/ielts-mastery-hub/commit/628e6db6e673fedbfefc42355caef3e305451213))
* add IELTS academic reading seed — Band 8.0 test 002 ([0aa4419](https://github.com/open-lingua/ielts-mastery-hub/commit/0aa44194453210259aa0573ec6b76e71fb29f90f))
* add IELTS academic reading seed — Band 8.0 test 003 ([688c365](https://github.com/open-lingua/ielts-mastery-hub/commit/688c365d6c4a59c6081d3db23e3e3b39c4a6bbb7))
* add IELTS academic reading seed — Band 9.0 test 002 ([d7932de](https://github.com/open-lingua/ielts-mastery-hub/commit/d7932ded13d8747766e4279a8f5ccf8250ef6578))
* add IELTS general training reading seed — Band 6.0 test 001 ([87eaed4](https://github.com/open-lingua/ielts-mastery-hub/commit/87eaed45ba6425ed62cb16530691e8755815e1bf))
* add IELTS general training reading seed — Band 6.0 test 002 ([0be9649](https://github.com/open-lingua/ielts-mastery-hub/commit/0be9649b7ed0dde72f25a0bb5d24f9ab4a0de1d0))
* add IELTS general training reading seed — Band 7.0 test 001 ([958a23e](https://github.com/open-lingua/ielts-mastery-hub/commit/958a23ee3e1696960a266b5746e0b9d0e8ad0ae3))
* add IELTS general training reading seed — Band 7.0 test 002 ([4e2c817](https://github.com/open-lingua/ielts-mastery-hub/commit/4e2c8171682bd77939c7c0e48f2e8d82667793ec))
* add IELTS general training reading seed — Band 7.0 test 003 ([075795d](https://github.com/open-lingua/ielts-mastery-hub/commit/075795d414a79ba911078ea9910c5cd28407b9a5))
* add IELTS general training reading seed — Band 8.0 test 001 ([ee35993](https://github.com/open-lingua/ielts-mastery-hub/commit/ee3599315e181e215aeca42d14dd09c14c877532))
* add IELTS general training reading seed — Band 8.0 test 002 ([2a3ec08](https://github.com/open-lingua/ielts-mastery-hub/commit/2a3ec0842082d14d2a8cda95d8c6fa329caf02bb))
* add IELTS general training reading seed — Band 8.0 test 003 ([1b72358](https://github.com/open-lingua/ielts-mastery-hub/commit/1b72358361cc4efa119c835e720491cc33df7cfb))
* add IELTS general training reading seed — Band 9.0 test 001 ([37aa8f5](https://github.com/open-lingua/ielts-mastery-hub/commit/37aa8f57eaf21c17bf407083e77bbc82d45d7f86))
* add IELTS general training reading seed — Band 9.0 test 002 ([64bc1c3](https://github.com/open-lingua/ielts-mastery-hub/commit/64bc1c35158147c1c287a439f48590ba5f2613b1))


### Chores

* mark scripts directory as linguist-generated ([faea49a](https://github.com/open-lingua/ielts-mastery-hub/commit/faea49a2f7488574bce6bb5f2d53d0a9a961d9ea))
* resolve merge conflict in useVersionCheck ([10a5609](https://github.com/open-lingua/ielts-mastery-hub/commit/10a56092147505d65eed9a4f363addba2f207c34))

## [1.0.0-beta.15](https://github.com/open-lingua/ielts-mastery-hub/compare/1.0.0-beta.14...1.0.0-beta.15) (2026-08-23)


### Features

* display app version in sidebar with LTS update badge ([cf01419](https://github.com/open-lingua/ielts-mastery-hub/commit/cf01419ba84d9dde26acd016098b6d72cedc4f7d))


### Chores

* reformat check-version-consistency.mjs to 2-space indent ([37dca10](https://github.com/open-lingua/ielts-mastery-hub/commit/37dca1018601a8711d9f980bbbd9d6c722c0bea4))

## [1.0.0-beta.14](https://github.com/open-lingua/ielts-mastery-hub/compare/1.0.0-beta.13...1.0.0-beta.14) (2026-08-23)


### Documentation

* automate release process with release-please ([1ff96d3](https://github.com/open-lingua/ielts-mastery-hub/commit/1ff96d3ee332bebd03d14123feafd4462aac64a6))


### CI/CD

* fallback to GITHUB_TOKEN when RELEASE_PLEASE_TOKEN is unset ([cf99b7d](https://github.com/open-lingua/ielts-mastery-hub/commit/cf99b7d8dbc77aec75144262a61422aecc95e9c0))


### Chores

* mark release-please config as prerelease ([64743fc](https://github.com/open-lingua/ielts-mastery-hub/commit/64743fcf97c9cc555b2f98ec67765ad9874fa765))

### 1.0.0-beta.13 / 2026.08.22

- fix: sync tauri.conf.json version with Cargo.toml

### 1.0.0-beta.12 / 2026.08.22

- ci: enable release workflow trigger and permissions
- chore: remove Supabase secrets requirement and patch website deps
- chore: remove Supabase legacy code and references
- docs: consolidate DATABASE_URL setup instructions into backend_architecture.md
- refactor: move tests to integration suite and expose db path helpers
- feat: resolve DATABASE_URL from OS default paths at runtime
- ci: add cross-platform release workflow for macOS, Linux, and Windows
- ci: add frontend lint step and simplify job names
- ci: replace SQLX_OFFLINE with DATABASE_URL for clippy and build steps
- ci: optimize backend job with sqlx offline mode and stable cargo cache
- ci: add clippy lint step to backend job
- chore: apply cargo fmt formatting
- ci: optimize Rust cache and apt install on Linux
- ci: rename ci.yml to ci-linux.yml
- ci: add Rust/Tauri test job to CI workflow
- feat: remove User Management feature from admin portal
- feat: remove landing page and boot directly into dashboard
- feat: add local search plugin to docs site
- chore: replace default Docusaurus branding with app assets
- docs: add missing _category_.json files for Docusaurus sidebar structure

### 1.0.0-beta.11 / 2026.08.21

- docs: disable sidebar autoCollapseCategories to keep both sections open
- docs: expand Technical Docs sidebar category by default
- docs: expand Usage Guides sidebar category by default
- docs: add Technical Docs sidebar category for internals
- docs: fix broken relative links in intro.mdx to point into internals/
- docs: add Usage Guides sidebar category for guides
- docs: add FAQ and troubleshooting reference guide
- docs: add admin portal user guides (overview, creating tests, content library, import/export, students)
- docs: add tracking-progress user guides (dashboard, band score)
- docs: add getting-started user guides (welcome, progress saving)

### 1.0.0-beta.10 / 2026.08.20

- docs: reorganize all docs under internals/ subdirectory
- docs: add intro doc
- docs: add reference docs
- docs: add desktop docs
- docs: add product docs
- docs: add contributing docs
- docs: add testing docs
- docs: add api-reference docs
- docs: add admin docs
- docs: add features docs
- docs: add architecture docs
- docs: add getting-started docs
- docs: remove unused info in intro

### 1.0.0-beta.9 / 2026.08.20

- chore(core): add dev-dependencies required for src/core test suite
- test(core): wire up integration test entry point for src/core tests
- test(core): add unit tests for src/core services
- test(core): add unit tests for src/core root-level error handling
- test(core): add unit tests for src/core repositories
- test(core): add unit tests for src/core models
- test(core): add shared test fixtures and data builders for src/core tests

### 1.0.0-beta.8 / 2026.08.19

- feat: add WritingTest structs to models
- feat: add WritingTask structs to models
- feat: add UserTestSession structs to models
- feat: add UserRole structs to models
- feat: add ReadingTest structs to models
- feat: add ReadingQuestion structs to models
- feat: add ReadingQuestionGroup structs to models
- feat: add ReadingPassage structs to models
- feat: add Profile structs to models
- feat: add PracticeTestRow/PracticeTestCard structs to models
- feat: add ListeningTest structs to models
- feat: add ListeningSection structs to models
- feat: add ListeningQuestion structs to models
- feat: add ListeningQuestionGroup structs to models
- refactor: import ReadingQuestion/ListeningQuestion from models in export_service.rs
- refactor: remove WritingTest structs from repositories/writing_tests.rs
- refactor: remove WritingTask structs from repositories/writing_tasks.rs
- refactor: remove UserTestSession structs from repositories/user_test_sessions.rs
- refactor: remove UserRole structs from repositories/user_roles.rs
- refactor: remove ReadingTest structs from repositories/reading_tests.rs
- refactor: remove ReadingQuestion structs from repositories/reading_questions.rs
- refactor: remove ReadingQuestionGroup structs from repositories/reading_question_groups.rs
- refactor: remove ReadingPassage structs from repositories/reading_passages.rs
- refactor: remove Profile structs from repositories/profiles.rs
- refactor: remove ListeningTest structs from repositories/listening_tests.rs
- refactor: remove ListeningSection structs from repositories/listening_sections.rs
- refactor: remove ListeningQuestion structs from repositories/listening_questions.rs
- refactor: declare new model submodules in models/mod.rs
- refactor: import WritingTest structs from models in writing_tests.rs
- refactor: import WritingTask structs from models in writing_tasks.rs
- refactor: import UserTestSession structs from models in user_test_sessions.rs
- refactor: import UserRole structs from models in user_roles.rs
- refactor: import ReadingTest structs from models in reading_tests.rs
- refactor: import ReadingQuestion structs from models in reading_questions.rs
- refactor: import ReadingQuestionGroup structs from models in reading_question_groups.rs
- refactor: import ReadingPassage structs from models in reading_passages.rs
- refactor: import Profile structs from models in profiles.rs
- refactor: import PracticeTestCard from models in practice_library.rs
- refactor: import ListeningTest structs from models in listening_tests.rs
- refactor: import ListeningSection structs from models in listening_sections.rs
- refactor: import ListeningQuestion structs from models in listening_questions.rs
- refactor: import ListeningQuestionGroup structs from models in listening_question_groups.rs
- fix: Fix pagination not advancing pages due to unstable setSearchParams dependency
- Add shared pagination model (PaginationParams, PaginationMeta, PaginatedResponse)
- Fix Unresolved filter being overwritten by module tab selection
- fix: fix unresolved filter with newest and oldest filter
- Handle cancelled export (null result) without error toast
- Propagate nullable export result through exportContent
- Update exportTestToZip to return ExportResult | null on cancel
- Wire native Save As dialog into export_test_to_zip command
- Split export service into build_export + default_export_dir for file picker
- Register tauri-plugin-dialog in app builder
- Regenerate Tauri ACL schemas for tauri-plugin-dialog
- Add tauri-plugin-dialog dependency for export file picker
- core: nest export zip contents inside a slug-named folder
- docs: add export test to zip spec
- ui: add Export action to Content Library 3-dot menu
- ui: add exportContent helper to contentService
- ui: add exportTestToZip invoke wrapper and ExportResult type
- core: wire up export_test_to_zip in invoke_handler
- core: register export command module
- core: register export_service module
- core: add export_test_to_zip Tauri command
- core: add export_service to build importable test JSON and zip bundles
- core: add zip crate dependency for test export
- chore: add Copilot CLI instructions via symlink to AGENTS.md

### 1.0.0-beta.7 / 2026.08.18

- docs(core): move testing conventions into docs/core/testing/
- docs(testing): add unit testing conventions for core module
- refactor(ImportDataset): redesign UI with step-based layout and custom drop zones

### 1.0.0-beta.6 / 2026.08.15

- chore: replace pnpm to npm
- test(ui): assert Import Dataset nav item renders in AdminLayout
- feat(ui): add Import Dataset item to admin sidebar nav
- feat(ui): route /admin/import to ImportDataset page
- feat(ui): add Admin Import Dataset page
- feat(ui): add client-side import parsing and validation helpers
- fix(ui): convert stored audio_url to a playable URL in listeningPracticeService
- fix(ui): convert stored audio_url to a playable URL in listeningService
- feat(ui): add typed import invoke wrappers and toPlayableUrl helper
- feat(core): wire import models/services modules and register import commands
- chore(core): register import command module
- feat(core): add import Tauri commands (validate + import per test type)
- feat(core): add import validation and transactional insert service
- feat(core): add import JSON contract models for Reading/Writing/Listening
- docs(admin): add spec for dataset import feature
- fix: add explicit type=button to button elements
- docs: add backend architecture reference
- docs: rename files to lowercase
- docs: add folder structure reference for AI context

### 1.0.0-beta.5 / 2026.08.15

- docs: add DATABASE_URL export to quick start setup
- docs: add DATABASE_URL setup instructions for sqlx CLI across platforms
- chore: update package-lock.json
- chore: remove dev.db from tracking
- docs: fix bundle identifier mismatch in database reset guide
- docs: add development database reset guide
- chore: remove legacy SQL seed files, replace with assets/examples
- fix: remove loadContent from effect deps to prevent infinite fetch loop
- feat: add Abort button and session abandonment flow to Writing, Reading, and Listening modules
- chore(release): bump version to 1.0.0-beta.4 and add changelog entry
- chore: add issue template config

### 1.0.0-beta.4 / 2026.08.14

- chore: add feature request issue template
- chore: add bug report issue template
- chore: add pull request template
- docs: Add CONTRIBUTING.md with setup, workflow, and PR guidelines
- fix: set crossorigin to 'anonymous' on fonts.gstatic.com preconnect tag
- feat(website): add HomepageSections components and hooks for landing page
- feat(website): replace default homepage with IELTS landing page sections
- style(website): replace default Infima theme with IELTS brand system (navy/gold)
- chore(website): configure site for IELTS Mastery Hub (title, org, url)
- chore(release): bump version to 1.0.0-beta.3 and add changelog entry

### 1.0.0-beta.3 / 2026.08.14

- fix(test): replace ResizeObserver mock with class implementation in CountryPicker test
- fix(biome): resolve lint errors from Biome migration
- chore: migrate from ESLint to Biome for linting and formatting
- feat(test-library): add Unresolved filter to show incomplete tests
- chore: remove Supabase backend and migrate docs to Tauri/SQLite architecture

### 1.0.0-beta.2 / 2026.08.14

- fix(navigation): redirect Writing, Reading and Listening nav links to Test Library with tab filter

### 1.0.0-beta.1 / 2026.08.14

- chore: bump version to 1.0.0-beta.1 and drop version from website package
- chore: rename website package to @open-lingua/ielts-mastery-hub-website and bump version to 0.1.0
- chore: rename package to @open-lingua/ielts-mastery-hub and bump version to 0.1.0
- chore: rename core crate to open-lingua-ielts-mastery-hub-core
- chore: downgrade typescript to 5.8.3 and clean up lockfile
- docs: change license badge color to yellow
- docs: add platform badge to README
- chore: downgrade typescript to 6.0.3 for typescript-eslint compatibility
- chore: bump typescript to 7.0.2
- chore: bump reqwest to 0.13.4 and fix rustls feature name
- chore: bump tauri-build to 2.6.3
- chore: bump thiserror to 2.0.20
- chore: bump sqlx to 0.9.0
- chore: add MIT LICENSE
- docs: add CONTRIBUTING guide
- docs: add CODE_OF_CONDUCT
- chore: add CODEOWNERS
- chore: rename asset files to app-banner and app-logo
- docs: move seed generator prompts to docs/prompts/
- docs: clarify app is desktop-native in description
- docs: pin Tauri@2 and React@19 versions in tech stack
- docs: rename AGENTS.md header from Project Context to Agent Context
- fix: repair broken tests
- fix: resolve Vite 8.x __SERVER_FORWARD_CONSOLE__ undefined and CSS 500 error in Tauri 2 WebKit
- fix: postcss and tailwind
- chore: update npm dependencies part 10
- docs: update README title to @open-lingua/ielts-mastery-hub
- docs: add project banner image to README
- chore: update npm dependencies
- docs: add IELTS trademark disclaimer to README
- docs: add project README
- fix: pass camelCase userId to Tauri 2 IPC commands
- fix: resolve duplicate UUIDs and broken FK references in seed files
- feat: run seeds automatically after migrations on DB init
- seed: migrate writing academic band 9.0 test 001 to SQLite
- seed: migrate writing academic band 8.0 test 001 to SQLite
- seed: migrate writing academic band 7.5 test 001 to SQLite
- seed: migrate writing academic band 7.0 test 001 to SQLite
- seed: migrate writing academic band 6.5 test 001 to SQLite
- seed: migrate writing academic band 6.0 test 001 to SQLite
- seed: migrate reading academic band 9.0 test 001 to SQLite
- seed: migrate reading academic band 8.0 test 001 to SQLite
- seed: migrate reading academic band 7.0 test 001 to SQLite
- seed: migrate listening band 9.0 test 001 to SQLite
- seed: migrate listening band 8.0 test 001 to SQLite
- seed: migrate 03_ielts_practice_test to SQLite
- seed: migrate 02_ielts_practice_test to SQLite
- seed: migrate 01_ielts_practice_test to SQLite
- feat: add IELTS Mastery Hub icons
- docs(core): add README with dev workflow and migration guide
- refactor(core): reorganize db module and consolidate migrations
- feat(core): add sqlx migrations with database/migrations structure
- chore: update IELTS Mastery Hub brand
- feat(core): add sqlx migrations with database/migrations structure
- feat(core): migrate to sqlx built-in migration runner part 2
- feat(core): migrate to sqlx built-in migration runner
- chore: remove Lovable branding and lovable-tagger dependency
- refactor(ui): replace Supabase audio upload with Tauri command in listeningService
- refactor(ui): replace Supabase image upload with Tauri command in writingService
- feat(ui): add uploadWritingAsset and uploadListeningAudio typed wrappers
- feat(core): enable asset protocol for ~/.ielts-hub
- feat(core): wire storage commands into invoke handler
- feat(core): register storage module
- feat(core): add upload_writing_asset and upload_listening_audio commands
- refactor(ui): replace Supabase calls with Tauri 2 commands in src/ui
- refactor(services): simplify writing services
- refactor(services): simplify reading services
- refactor(services): simplify practiceLibraryService
- refactor(services): simplify listening services
- refactor(services): simplify dashboardService
- refactor(services): update contentService
- refactor(services): simplify aiGradingService
- refactor(admin): simplify AdminDashboard and UserManagement pages
- refactor(pages): update Dashboard page
- refactor(hooks): simplify useAutoSaveAnswers logic
- refactor(dashboard): simplify StudyHeatmap component
- refactor(dashboard): simplify BandScoreChart component
- feat: add logo IMH
- chore: Remove auth layer and replace with anonymous ID for guest-first, no-login experience
- fix(ui): Fix env file resolution to load from project root in Vite config
- chore: Reorganize docs into layer-specific context files and update AGENTS.md references
- fix: Add global error boundary and unhandled error display for easier debugging
- feat: Add Tauri v2 desktop app integration with dev/build configuration
- chore: add CLAUDE.md and AGENTS.md configuration files for AI assistants
- feat: add .gitattributes file
- feat(core): migrate database layer from rusqlite to sqlx with async repositories and Tauri commands
- feat(core): migrate Supabase backend to local SQLite with Tauri 2 commands
- chore: remove .env from tracking and add env files to .gitignore
- fix: resolve vitest setup path after src/ui restructure
- refactor: move React source to src/ui in preparation for Tauri 2 integration
- docs: add Docusaurus website with TypeScript and Bun
- chore: mark website docs and blog as documentation in gitattributes
- chore: mark .mdx files as documentation in gitattributes
