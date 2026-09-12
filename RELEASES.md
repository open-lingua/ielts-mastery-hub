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
> `src/core/tauri.conf.json` / `src/core/tauri.windows.msi.conf.json` versions — see below for the
> one supported way to cut a release.

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
   - Computes the next `X.Y.Z-rc.N` version from the accumulated conventional commits.
   - Updates `package.json`, `src/core/Cargo.toml`, and `src/core/tauri.conf.json` to the same
     version, in the same commit (config: [`release-please-config.json`](release-please-config.json),
     seeded version: [`.release-please-manifest.json`](.release-please-manifest.json)).
   - Prepends a new dated section to this file (`RELEASES.md`), grouped by commit type
     (Features/Bug Fixes/Chores/etc.), from the commits since the last release.
   - Refreshes `src/core/Cargo.lock`'s core-crate version entry, and regenerates
     `src/core/tauri.windows.msi.conf.json`'s WiX version (via
     [`scripts/sync-msi-version.mjs`](scripts/sync-msi-version.mjs)), via a follow-up job and
     pushes both onto the same PR branch in a single commit.
3. Merging that Release PR tags the release as `X.Y.Z-rc.N` (no `v`/component prefix, matching
   this repo's existing tag history) and publishes the GitHub Release — which is what triggers
   `release.yml` above, unchanged.
4. A `version-consistency` CI job ([`.github/workflows/ci-linux.yml`](.github/workflows/ci-linux.yml),
   backed by `scripts/check-version-consistency.mjs`) fails any PR where the three version-bearing
   files disagree, or where `src/core/tauri.windows.msi.conf.json`'s WiX version doesn't match the
   value derived from the canonical version, as defense in depth against manual edits
   reintroducing drift.

**MSI/WiX version overlay:** Tauri's `msi` bundle target (built with WiX on Windows) requires an
all-numeric 4-part version (each field ≤ 65535), so a semver pre-release like `1.0.1-rc.2` fails to
bundle as-is — `nsis`, `dmg`, `deb`, `rpm`, and `appimage` don't have this restriction.
`src/core/tauri.windows.msi.conf.json` is a **generated** overlay config (`bundle.windows.wix.version`,
e.g. `1.0.1-rc.2` → `1.0.1.2`) applied only for Windows builds via `--config`
(see [`.github/workflows/release.yml`](.github/workflows/release.yml) and the
`tauri:build:windows` npm script) — never hand-edit it; regenerate it with
`npm run sync:msi-version` if it's ever out of sync locally.



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

## [1.8.0](https://github.com/open-lingua/ielts-mastery-hub/compare/1.7.4...1.8.0) (2026-09-12)


### Features

* add Abort button and session abandonment flow to Writing, Reading, and Listening modules ([8b4308c](https://github.com/open-lingua/ielts-mastery-hub/commit/8b4308cf8dffc74e9946cb49da2b1b9afd25894f))
* add activate and delete flows to AI Configurations page ([b0b3fce](https://github.com/open-lingua/ielts-mastery-hub/commit/b0b3fcea8868f0f51a441ff90ae4b5285fd8771b))
* add activate_ai_configuration command ([85fbcaf](https://github.com/open-lingua/ielts-mastery-hub/commit/85fbcaf33198d478b8861db3eca5e4413854b243))
* add AES-GCM encryption key infrastructure for AI credentials ([aeb53bd](https://github.com/open-lingua/ielts-mastery-hub/commit/aeb53bdff59b71e2fc0c8ce57b14f728e9e98767))
* add AI configuration model, repository, service, and commands ([ef6576d](https://github.com/open-lingua/ielts-mastery-hub/commit/ef6576d5347bf49fa588198fce096c98cc765911))
* add AI Configurations admin page and nav entry ([6df72b2](https://github.com/open-lingua/ielts-mastery-hub/commit/6df72b2a5d4bfb969922a5f99d653bd2db1a2c03))
* add GitHub release update check service and Tauri command ([9ccf808](https://github.com/open-lingua/ielts-mastery-hub/commit/9ccf80817b4ca67e45b92c95f3d71f981ea03cad))
* add IELTS academic reading seed — Band 6.0 test 001 ([4e5180b](https://github.com/open-lingua/ielts-mastery-hub/commit/4e5180b84c867a4c8f88ab845bffede22f6d0038))
* add IELTS academic reading seed — Band 6.0 test 002 ([1e40125](https://github.com/open-lingua/ielts-mastery-hub/commit/1e401255f030a0de70d9d86cdf585bc45802071e))
* add IELTS academic reading seed — Band 7.0 test 002 ([fc03054](https://github.com/open-lingua/ielts-mastery-hub/commit/fc03054a91925fd12fbfc797a1d5ea0c6145678b))
* add IELTS academic reading seed — Band 7.0 test 003 ([10b3145](https://github.com/open-lingua/ielts-mastery-hub/commit/10b3145e662af0c59b0faefde4aaa226423d59f1))
* add IELTS academic reading seed — Band 8.0 test 002 ([95a3ce7](https://github.com/open-lingua/ielts-mastery-hub/commit/95a3ce73291eaeb7e016934a19a31e1ad49576ef))
* add IELTS academic reading seed — Band 8.0 test 003 ([5963afc](https://github.com/open-lingua/ielts-mastery-hub/commit/5963afc116f9fe5d93b443d56f075c53ad39de9f))
* add IELTS academic reading seed — Band 9.0 test 002 ([f756df4](https://github.com/open-lingua/ielts-mastery-hub/commit/f756df4514ac647a6a0ce3b12dabc84520842e02))
* add IELTS general training reading seed — Band 6.0 test 001 ([2cd9d98](https://github.com/open-lingua/ielts-mastery-hub/commit/2cd9d98023e3600189f2195f0ec1ada27834ed36))
* add IELTS general training reading seed — Band 6.0 test 002 ([c4f1212](https://github.com/open-lingua/ielts-mastery-hub/commit/c4f121250d4840362e1004cbb19f2b39251796f1))
* add IELTS general training reading seed — Band 7.0 test 001 ([cf316c6](https://github.com/open-lingua/ielts-mastery-hub/commit/cf316c604f24fbb319337c60b8d9eeffe3d23227))
* add IELTS general training reading seed — Band 7.0 test 002 ([e25f05f](https://github.com/open-lingua/ielts-mastery-hub/commit/e25f05f6cc1959db638da537f3fd51214bb74c43))
* add IELTS general training reading seed — Band 7.0 test 003 ([e6e7429](https://github.com/open-lingua/ielts-mastery-hub/commit/e6e742906ddd47a5d02952ff58d34e93a2f2c986))
* add IELTS general training reading seed — Band 8.0 test 001 ([d5a24c8](https://github.com/open-lingua/ielts-mastery-hub/commit/d5a24c8cbae4ee366a0b5866a4ecbc914ce9f025))
* add IELTS general training reading seed — Band 8.0 test 002 ([e5adb4f](https://github.com/open-lingua/ielts-mastery-hub/commit/e5adb4fb315956c7166b5e498984460ab770dd65))
* add IELTS general training reading seed — Band 8.0 test 003 ([9506c45](https://github.com/open-lingua/ielts-mastery-hub/commit/9506c4560bde1e55d70902824a94d2b55357da40))
* add IELTS general training reading seed — Band 9.0 test 001 ([0b40f25](https://github.com/open-lingua/ielts-mastery-hub/commit/0b40f25a81c299dace7b01815b4e3e3f08780b44))
* add IELTS general training reading seed — Band 9.0 test 002 ([7ecd581](https://github.com/open-lingua/ielts-mastery-hub/commit/7ecd581b53f7929eb7cc0b18d762567981e60f12))
* add IELTS Mastery Hub icons ([cc07050](https://github.com/open-lingua/ielts-mastery-hub/commit/cc07050af362a38fdb9cb17d44bb7f1ba88a89ee))
* add ListeningQuestion structs to models ([3ac66bf](https://github.com/open-lingua/ielts-mastery-hub/commit/3ac66bf1e3e8b07bd05aecb7bedb9c6dba89929b))
* add ListeningQuestionGroup structs to models ([f205b31](https://github.com/open-lingua/ielts-mastery-hub/commit/f205b31837d113cc06c3c620f481541eef9d5bc0))
* add ListeningSection structs to models ([f09d7d2](https://github.com/open-lingua/ielts-mastery-hub/commit/f09d7d200e4aad6e641a4f3138582f8f10a7310d))
* add ListeningTest structs to models ([8c7b348](https://github.com/open-lingua/ielts-mastery-hub/commit/8c7b3484e9a94bdd6903703466eb6b68ade7816f))
* add local search plugin to docs site ([2aa22a3](https://github.com/open-lingua/ielts-mastery-hub/commit/2aa22a3d32779622fd53f945894336dc744d4ebd))
* add locked state to TestStartOverlay ([2078db6](https://github.com/open-lingua/ielts-mastery-hub/commit/2078db64137cc10c2ad23bf859e62e58e17e8e2a))
* add log/env_logger and initialize logger at startup ([42f5558](https://github.com/open-lingua/ielts-mastery-hub/commit/42f5558119f42bfc43b3233f38b6f9fc0f6ec3c6))
* add model name field to local and general provider forms ([f6412d4](https://github.com/open-lingua/ielts-mastery-hub/commit/f6412d41d550d182e58121c3385a4f94a72a27b0))
* add PracticeTestRow/PracticeTestCard structs to models ([eb63657](https://github.com/open-lingua/ielts-mastery-hub/commit/eb636577078a8377e3a4b9bb63fcc79488c9ebbb))
* add preStartContent slot to TestStartOverlay ... ([015078e](https://github.com/open-lingua/ielts-mastery-hub/commit/015078ec2f1fff04a00d06540952b1b54fce7f4d))
* add Profile structs to models ([94cceae](https://github.com/open-lingua/ielts-mastery-hub/commit/94cceae85a5f55a08cb18849e201579a50fd4408))
* add ReadingPassage structs to models ([0f08b3c](https://github.com/open-lingua/ielts-mastery-hub/commit/0f08b3cd77f236c693773a923d9a4ee802ecb865))
* add ReadingQuestion structs to models ([9e6abaf](https://github.com/open-lingua/ielts-mastery-hub/commit/9e6abafc43f9d9a98192767653d861574bded427))
* add ReadingQuestionGroup structs to models ([5f1bde8](https://github.com/open-lingua/ielts-mastery-hub/commit/5f1bde88b35ca2b5b093ea393ef188228861a3f7))
* add ReadingTest structs to models ([a8a12a1](https://github.com/open-lingua/ielts-mastery-hub/commit/a8a12a1cfed0aa2b13c7c380547ded046e85f788))
* add unscored mode to Writing test ... ([e660480](https://github.com/open-lingua/ielts-mastery-hub/commit/e660480e99bc10b52a32c28172468dd3d1701aa7))
* add UserRole structs to models ([457d8c1](https://github.com/open-lingua/ielts-mastery-hub/commit/457d8c1d1d4e8dd974aad2bbeae898163400439c))
* add UserTestSession structs to models ([49e4079](https://github.com/open-lingua/ielts-mastery-hub/commit/49e40795bc2f89aea8fcdb5f5bdb5b62f4e5bb32))
* add WritingTask structs to models ([ab1e5ca](https://github.com/open-lingua/ielts-mastery-hub/commit/ab1e5ca463b8a7cd69acd8ee96dd2ce576072cfa))
* add WritingTest structs to models ([4ea3990](https://github.com/open-lingua/ielts-mastery-hub/commit/4ea3990b917fda06d1676091fe67e7355dbb5974))
* **ci:** add MSI/WiX version overlay for Windows builds ([8095df9](https://github.com/open-lingua/ielts-mastery-hub/commit/8095df95df2665a170f499a62827bbc5387969d6))
* **core:** add import JSON contract models for Reading/Writing/Listening ([6633aeb](https://github.com/open-lingua/ielts-mastery-hub/commit/6633aeb6c2268de49bc871886e9fa477c08272b0))
* **core:** add import Tauri commands (validate + import per test type) ([6fc6097](https://github.com/open-lingua/ielts-mastery-hub/commit/6fc60978cd44a3b3226dc4ebe583be6ed40b6386))
* **core:** add import validation and transactional insert service ([7060e7a](https://github.com/open-lingua/ielts-mastery-hub/commit/7060e7ade4bc36759219785a72dae39fc5f15970))
* **core:** add sqlx migrations with database/migrations structure ([40593b1](https://github.com/open-lingua/ielts-mastery-hub/commit/40593b170733a916415b18e418a278134f203692))
* **core:** add sqlx migrations with database/migrations structure ([7752174](https://github.com/open-lingua/ielts-mastery-hub/commit/7752174d1d5562f58d20e6bd73e2185d0c5370ca))
* **core:** add upload_writing_asset and upload_listening_audio commands ([45fdc4a](https://github.com/open-lingua/ielts-mastery-hub/commit/45fdc4ac4f4b3f76f1a528995f525e19a3816dc6))
* **core:** add writing_assets_migration module with sync logic and tests ([3c66a28](https://github.com/open-lingua/ielts-mastery-hub/commit/3c66a28a31b03f7a862bd6dec11a6c5bb661e4dc))
* **core:** backfill audio_url for listening sections when syncing seed assets ([91fc0e2](https://github.com/open-lingua/ielts-mastery-hub/commit/91fc0e2bec8a10b29b29265444c36cd83b1b3ce3))
* **core:** enable asset protocol for ~/.ielts-hub ([b88bab7](https://github.com/open-lingua/ielts-mastery-hub/commit/b88bab7af475e655da3efd4a8edcc59663bc4970))
* **core:** migrate to sqlx built-in migration runner ([d3bef1a](https://github.com/open-lingua/ielts-mastery-hub/commit/d3bef1a85c1c9bbe2be77e748ef92ee9b1108a81))
* **core:** migrate to sqlx built-in migration runner part 2 ([feade4f](https://github.com/open-lingua/ielts-mastery-hub/commit/feade4f5238ef4ba8cf55a8d1ceb26fb0e950f44))
* **core:** register storage module ([f9b56db](https://github.com/open-lingua/ielts-mastery-hub/commit/f9b56db3b6709faa4aa8c3f93f52bf6115fc6508))
* **core:** rename listening-tests to listening-assets with startup migration ([763058c](https://github.com/open-lingua/ielts-mastery-hub/commit/763058cbe73ca0a06bf4b3ee4c1414c8ed451981))
* **core:** sync seed listening assets to local storage on app startup ([da96ff5](https://github.com/open-lingua/ielts-mastery-hub/commit/da96ff5c900e5583cc3e212495f8bf842f9f1d9d))
* **core:** sync seed writing assets to local storage on app startup ([477c99f](https://github.com/open-lingua/ielts-mastery-hub/commit/477c99fe20a044e6d9ca1798f155a2fd3b932779))
* **core:** thread client-supplied task id through storage, import, and repository ([90ad1fc](https://github.com/open-lingua/ielts-mastery-hub/commit/90ad1fcc6fdb13ef2eb62cb4671f4a14953b97b0))
* **core:** wire import models/services modules and register import commands ([ffc1217](https://github.com/open-lingua/ielts-mastery-hub/commit/ffc12176d82abeb6d2f8735068c207673de0445a))
* **core:** wire storage commands into invoke handler ([179ed1d](https://github.com/open-lingua/ielts-mastery-hub/commit/179ed1d55528ae074abae1730bccf5028e36612a))
* **db:** add ai_configurations migration ([ffb0a5c](https://github.com/open-lingua/ielts-mastery-hub/commit/ffb0a5c7c5db97b1b53f0a1fb1e45c327c51277f))
* **db:** add band 6.0 test 001 listening seed ([07bbf08](https://github.com/open-lingua/ielts-mastery-hub/commit/07bbf0875d5d8ada4219258b0fbeef7161582746))
* **db:** add band 6.0 test 002 listening seed ([ae6f8bb](https://github.com/open-lingua/ielts-mastery-hub/commit/ae6f8bb041e242cb8339bb0bb7726b2df46016bb))
* **db:** add band 7.0 test 001 listening seed ([f41570d](https://github.com/open-lingua/ielts-mastery-hub/commit/f41570de26c32a41eb1e93730584dd00ee4c148f))
* **db:** add band 7.0 test 002 listening seed ([8981535](https://github.com/open-lingua/ielts-mastery-hub/commit/8981535b988b00a64110e216a6ae5aba3c4eafa3))
* **db:** add band 8.0 test 002 listening seed ([6a185c0](https://github.com/open-lingua/ielts-mastery-hub/commit/6a185c0171778fe3574295293f8577493534c037))
* **db:** add band 9.0 test 002 listening seed ([9f95ad9](https://github.com/open-lingua/ielts-mastery-hub/commit/9f95ad90d92ae4ade0f59a1e72f013b7a66eadd7))
* **db:** add migration to allow 'aborted' user_test_session status ([5747e96](https://github.com/open-lingua/ielts-mastery-hub/commit/5747e9645485ea2cd38bef2e8663eb441e9d5b61))
* **db:** update band 8.0 test 001 seed – freight shipping, airport layout, marine biology & supply chains ([47fd966](https://github.com/open-lingua/ielts-mastery-hub/commit/47fd96606b080a9626f2e317374a2dba929a878a))
* **db:** update band 9.0 test 001 listening seed ([75caca5](https://github.com/open-lingua/ielts-mastery-hub/commit/75caca551b3cb3b0bf0631a17efcf239009b85e3))
* display app version in sidebar with LTS update badge ([5c0edcb](https://github.com/open-lingua/ielts-mastery-hub/commit/5c0edcb10b4307af88d59c79d5af6bc980fec014))
* extract seed data runner and bundle full seed directories as resources ([8d7722e](https://github.com/open-lingua/ielts-mastery-hub/commit/8d7722e232fe818bc56e95e59bceb4e5da86dd05))
* gate Writing test start on an active AI configuration ([99a91bc](https://github.com/open-lingua/ielts-mastery-hub/commit/99a91bcadfc3ad438cb2c072dc4771bbd7070c66))
* handle aborted session status in TestLibrary card styles ([c473f19](https://github.com/open-lingua/ielts-mastery-hub/commit/c473f19908b3d17a060374f845e8131bb4276606))
* make ChatGPT model name configurable; update docs ([e6f4ced](https://github.com/open-lingua/ielts-mastery-hub/commit/e6f4ced5225da44066e94d38967407068c123473))
* make Claude model name configurable to fix 404 on retired model aliases ([cc14618](https://github.com/open-lingua/ielts-mastery-hub/commit/cc1461857722bc09967c399e2a96934cd0457605))
* make Gemini model name configurable; update default to gemini-2.5-flash ([22f70ef](https://github.com/open-lingua/ielts-mastery-hub/commit/22f70ef8671f45c3992fb01a9e62f9ef45391882))
* make model name configurable for local/general providers; improve failure errors ([2775e8d](https://github.com/open-lingua/ielts-mastery-hub/commit/2775e8de0cbedc77a6f63c8229978bf5ea2adcf7))
* persist figure_description across full stack for writing tasks ([c530f03](https://github.com/open-lingua/ielts-mastery-hub/commit/c530f0330bf28d63bcd27d2a6b309f7da57d0c5a))
* remove landing page and boot directly into dashboard ([b85458b](https://github.com/open-lingua/ielts-mastery-hub/commit/b85458b6927f8815c25f07343d6331bfeb15cd2d))
* remove User Management feature from admin portal ([f361f21](https://github.com/open-lingua/ielts-mastery-hub/commit/f361f2129307954769036eab425fd5325d78ad3a))
* replace deleteUserTestSession with abortSession in all test modules ([2801611](https://github.com/open-lingua/ielts-mastery-hub/commit/2801611a386c07004ccf00b36ef3d8d905dcf35e))
* resolve DATABASE_URL from OS default paths at runtime ([afcee97](https://github.com/open-lingua/ielts-mastery-hub/commit/afcee971f4b5d547a19464026d84edd4b8912d71))
* resolve seed asset paths at runtime via Tauri resource API ([99c51c1](https://github.com/open-lingua/ielts-mastery-hub/commit/99c51c1e058cfd91b8f12e402641a8d6d38d961d))
* run seeds automatically after migrations on DB init ([d9d258b](https://github.com/open-lingua/ielts-mastery-hub/commit/d9d258bf56958f49c05af74acce3c11057c2ed68))
* **seeds:** add band 7 listening seed with college enrollment & rec center tour test ([4c90a4e](https://github.com/open-lingua/ielts-mastery-hub/commit/4c90a4e9309291235a6a3250a506f65dc3bfa468))
* **seeds:** add section 1-2 audio for listening test 4bb75c40 ([3019b96](https://github.com/open-lingua/ielts-mastery-hub/commit/3019b96dedd97f90cec790e97b23363fe28d4815))
* **seeds:** add section 3-4 audio for listening test 4bb75c40 ([7bfb90e](https://github.com/open-lingua/ielts-mastery-hub/commit/7bfb90eacc9e559f144a6b949bf1b96fc9836e9a))
* **seeds:** add section audio for band 7 test 001 listening seed ([7bc0d08](https://github.com/open-lingua/ielts-mastery-hub/commit/7bc0d08cd96c99aa45353a8585906cf3ff14585a))
* **seeds:** add section audio for band 8 test 002 listening seed ([fa1c2f1](https://github.com/open-lingua/ielts-mastery-hub/commit/fa1c2f13d73f1ebaad40b1326d597443b643475a))
* **seeds:** add section audio for band 9 test 001 listening seed ([25823ac](https://github.com/open-lingua/ielts-mastery-hub/commit/25823ace0f8bb6f5b69eb64ffa90433f7c4a2d49))
* **seeds:** add Task 1 figure asset for band 6 academic seed ([59e96ba](https://github.com/open-lingua/ielts-mastery-hub/commit/59e96ba2120d758518c0ef572a53972039add8a9))
* **seeds:** add Task 1 figure asset for band 6.5 academic seed ([559667e](https://github.com/open-lingua/ielts-mastery-hub/commit/559667e2440c4556d8a91d040735b612f7e42628))
* **seeds:** add Task 1 figure asset for band 7 academic seed ([ceff8d4](https://github.com/open-lingua/ielts-mastery-hub/commit/ceff8d4b9de72cc61839c6d3d23cd12d92c866cc))
* **seeds:** add Task 1 figure asset for band 7.5 academic seed ([9428a0d](https://github.com/open-lingua/ielts-mastery-hub/commit/9428a0dedda15e4fe9505f478f48a45567572646))
* **seeds:** add Task 1 figure asset for band 8 academic seed ([5934b6c](https://github.com/open-lingua/ielts-mastery-hub/commit/5934b6c59f494b8e204f5729d210665b16706bec))
* **seeds:** add Task 1 figure asset for band 9 academic seed ([78894a4](https://github.com/open-lingua/ielts-mastery-hub/commit/78894a43833f18c6293aa6228a79170afb0015fd))
* **seeds:** add TTS configs for band 7 test 001 listening seed ([f35c465](https://github.com/open-lingua/ielts-mastery-hub/commit/f35c4659a5dc790bc15beac8372b6466d45e046e))
* **seeds:** add TTS configs for band 8 test 002 listening seed ([416dc6a](https://github.com/open-lingua/ielts-mastery-hub/commit/416dc6afa1258204ffec077b54bd218d3fa8bc32))
* **seeds:** add TTS configs for band 9 test 001 listening seed ([da7a318](https://github.com/open-lingua/ielts-mastery-hub/commit/da7a3181062b189f977f182afc2030e65221a619))
* **seeds:** replace band 6 academic seed with university enrollment & free education test ([4cb0aca](https://github.com/open-lingua/ielts-mastery-hub/commit/4cb0aca0605ee98d4fee4adf714286c2fe257ceb))
* **seeds:** replace band 6.5 academic seed with water consumption & remote work test ([aaa66d9](https://github.com/open-lingua/ielts-mastery-hub/commit/aaa66d921d641882ccb8024be768fe1f162bd2fb))
* **seeds:** replace band 7 academic seed with geothermal energy & space exploration test ([3382958](https://github.com/open-lingua/ielts-mastery-hub/commit/33829587b2279018391cfee7d5bbaff12baa62fe))
* **seeds:** replace band 7.5 academic seed with student enrollment & AI in professions test ([8f1605a](https://github.com/open-lingua/ielts-mastery-hub/commit/8f1605a48f0f6c72741c83bb7db1e66aa3b69688))
* **seeds:** replace band 8 academic seed with government expenditure & family structures test ([02787d2](https://github.com/open-lingua/ielts-mastery-hub/commit/02787d2aee04fb14e141fae290e0a9632b56e02b))
* **seeds:** replace band 8 test 002 listening seed with corporate retreat & sustainable library test ([55b885d](https://github.com/open-lingua/ielts-mastery-hub/commit/55b885dc2eeb3aefe49179c75e18f1f1dc45d251))
* **seeds:** replace band 9 academic seed with global energy transition & cognitive delegation test ([d90fea9](https://github.com/open-lingua/ielts-mastery-hub/commit/d90fea937ee92ae8f29c65191dfa469b9b4f92d9))
* **seeds:** replace band 9 listening seed with high-altitude logistics & urban agriculture test ([9c5252a](https://github.com/open-lingua/ielts-mastery-hub/commit/9c5252ab561d5da9d3d41ff3ae80a219adf40a03))
* **seeds:** update TTS config for band 9 test 001 section 4 (LiDAR archaeology) ([23fe9fa](https://github.com/open-lingua/ielts-mastery-hub/commit/23fe9fa19e6ebcb7c0e79a96367c0931a4ce2846))
* structured AssetSyncOutcome + replace eprintln with log macros ([3b6c993](https://github.com/open-lingua/ielts-mastery-hub/commit/3b6c9936a038696ab7a2e494e567983d3626281b))
* **test-library:** add Unresolved filter to show incomplete tests ([09deff6](https://github.com/open-lingua/ielts-mastery-hub/commit/09deff6712781a773dd820c832e81d9dc8ddd4a7))
* **ui:** add Admin Import Dataset page ([0f43495](https://github.com/open-lingua/ielts-mastery-hub/commit/0f434950a4c2cae4c52758cffc169170bc92d236))
* **ui:** add client-side import parsing and validation helpers ([0173868](https://github.com/open-lingua/ielts-mastery-hub/commit/0173868838a17452cf6c5eb1639dda6600960c84))
* **ui:** add Import Dataset item to admin sidebar nav ([23cb14d](https://github.com/open-lingua/ielts-mastery-hub/commit/23cb14dca1e3807b1e7c3860e00f8680eb5b07a0))
* **ui:** add Task 1 image upload to writing dataset import ([30ca22b](https://github.com/open-lingua/ielts-mastery-hub/commit/30ca22bd5d25c190c64c6b43f04d14949a3aeb36))
* **ui:** add typed import invoke wrappers and toPlayableUrl helper ([1253989](https://github.com/open-lingua/ielts-mastery-hub/commit/125398961f0528b7aa96d2d6f2978da6aa75b492))
* **ui:** add uploadWritingAsset and uploadListeningAudio typed wrappers ([f3a87fe](https://github.com/open-lingua/ielts-mastery-hub/commit/f3a87fec60a17cd7bf35cdc1bf625bf2721879d4))
* **ui:** generate and propagate task id before writing asset upload ([665a841](https://github.com/open-lingua/ielts-mastery-hub/commit/665a84185865359e4fdb549050fe80f5343ddbf9))
* **ui:** route /admin/import to ImportDataset page ([ba1881f](https://github.com/open-lingua/ielts-mastery-hub/commit/ba1881f6f74b4ce4c9b4c5b723e4430674149c1c))
* **update:** wire real update check via GitHub API and open release URL with tauri-plugin-opener ([882e440](https://github.com/open-lingua/ielts-mastery-hub/commit/882e440fb611aae76fcc4f5d5be6ea20d9be320b))
* **website:** add HomepageSections components and hooks for landing page ([9a4e931](https://github.com/open-lingua/ielts-mastery-hub/commit/9a4e9312fae0d72bffb43824588fc8553036b915))
* **website:** add PowerShell Windows installer script ([bb5a652](https://github.com/open-lingua/ielts-mastery-hub/commit/bb5a652328ab310ca974f2578a2953692f23389f))
* **website:** add Unix installer script and fix sidebar position ([21290a1](https://github.com/open-lingua/ielts-mastery-hub/commit/21290a1e228aa616a8782b0218bc6b6f0f2a5fa3))
* **website:** replace default homepage with IELTS landing page sections ([3c6ecc3](https://github.com/open-lingua/ielts-mastery-hub/commit/3c6ecc3f08a2200735fb274ef6f86ac6b5e6e719))
* wire AI Configurations page to backend ([2705870](https://github.com/open-lingua/ielts-mastery-hub/commit/27058706f05b4ec4011570e9a6d10d90590ad0e5))


### Bug Fixes

* add explicit type=button to button elements ([897ec0f](https://github.com/open-lingua/ielts-mastery-hub/commit/897ec0f9c6683ab3cdf104f3d7a98e838cc89522))
* **biome:** resolve lint errors from Biome migration ([016a085](https://github.com/open-lingua/ielts-mastery-hub/commit/016a085daa4d51a56816d6a55e6638994fb2bf12))
* **core:** store asset:// URL in image_url instead of raw file path ([5842821](https://github.com/open-lingua/ielts-mastery-hub/commit/58428216db932616190a27591b9713facce7af97))
* correct question order and remove duplicate group insert in band 9.0 listening seed ([5992a73](https://github.com/open-lingua/ielts-mastery-hub/commit/5992a7324b18d41db6ebf62b9e5bfe47887d685f))
* correct question order in band 8.0 Section 2 matching questions ([a2dd0be](https://github.com/open-lingua/ielts-mastery-hub/commit/a2dd0be5b548725449cf694055e52c095ae85de2))
* correct Section 2 matching question options and answers in band 8.0 listening seed ([7f1529a](https://github.com/open-lingua/ielts-mastery-hub/commit/7f1529a0f0f0bb905cf09b348a3005cf256a3741))
* correct Section 2 matching question options and answers in band 9.0 listening seed ([23f6a01](https://github.com/open-lingua/ielts-mastery-hub/commit/23f6a011a7469090a7c1de4c10c97c8ee99ff98a))
* correct Section 2 matching question options and answers in listening seed ([f521f52](https://github.com/open-lingua/ielts-mastery-hub/commit/f521f52c3e96513872ded4bac7c9c6cfdb00b230))
* Fix pagination not advancing pages due to unstable setSearchParams dependency ([198f7d6](https://github.com/open-lingua/ielts-mastery-hub/commit/198f7d6aa81e2fd3187397302651b15a23201abb))
* fix unresolved filter with newest and oldest filter ([d790e42](https://github.com/open-lingua/ielts-mastery-hub/commit/d790e42617cb178b5a85d7c6aea6d27b3fa26a57))
* **navigation:** redirect Writing, Reading and Listening nav links to Test Library with tab filter ([e165567](https://github.com/open-lingua/ielts-mastery-hub/commit/e16556736418e3fdcf89d93a8679410c33c3ad94))
* pass camelCase userId to Tauri 2 IPC commands ([aaba981](https://github.com/open-lingua/ielts-mastery-hub/commit/aaba981230654f4e9ee5cdcbbef7f70d7287e6f9))
* postcss and tailwind ([e9f0370](https://github.com/open-lingua/ielts-mastery-hub/commit/e9f0370143465dafdff95bc0b05d831accbf9bbe))
* remove duplicate group/question inserts from band 7.0 and 8.0 listening seeds ([c29e949](https://github.com/open-lingua/ielts-mastery-hub/commit/c29e949e194ddf426666069021d9f38654e89294))
* remove loadContent from effect deps to prevent infinite fetch loop ([590e48b](https://github.com/open-lingua/ielts-mastery-hub/commit/590e48b264f2bf4096873456e1857a0d2d2f1f25))
* repair broken tests ([ce60577](https://github.com/open-lingua/ielts-mastery-hub/commit/ce60577357badc27514fb30fb103aaee22268b06))
* resolve duplicate UUIDs and broken FK references in seed files ([6b0bd68](https://github.com/open-lingua/ielts-mastery-hub/commit/6b0bd68fb412dc515ce6ff2cc33fa2f9828adef2))
* resolve Vite 8.x __SERVER_FORWARD_CONSOLE__ undefined and CSS 500 error in Tauri 2 WebKit ([9b8c506](https://github.com/open-lingua/ielts-mastery-hub/commit/9b8c506c726c813506516ad555f274edbc5d4bbd))
* set crossorigin to 'anonymous' on fonts.gstatic.com preconnect tag ([950720f](https://github.com/open-lingua/ielts-mastery-hub/commit/950720f2997ec5a6533f8b0cfea0ff831bf2437b))
* sync tauri.conf.json version with Cargo.toml ([895a7f7](https://github.com/open-lingua/ielts-mastery-hub/commit/895a7f7cce80c8a59b6705e7eb8641f311b632b0))
* **test:** replace ResizeObserver mock with class implementation in CountryPicker test ([69b0f33](https://github.com/open-lingua/ielts-mastery-hub/commit/69b0f337ed804d31e013aeb95ba8724ee7af0a79))
* **ui:** convert stored audio_url to a playable URL in listeningPracticeService ([e4fd431](https://github.com/open-lingua/ielts-mastery-hub/commit/e4fd4311d2208a5923a2f7e7c86e0c7d1e9ceae9))
* **ui:** convert stored audio_url to a playable URL in listeningService ([b16b43e](https://github.com/open-lingua/ielts-mastery-hub/commit/b16b43ef614c6d3d16c20f9a097eac6a09e06b20))
* **ui:** rename invoke params to camelCase and add error logging to import pipeline ([81ff990](https://github.com/open-lingua/ielts-mastery-hub/commit/81ff990e5427859537be829b1334ae03866ccaa2))
* update bun.lockb to include missing autoprefixer dependency ([ed4522a](https://github.com/open-lingua/ielts-mastery-hub/commit/ed4522a48a10d364863f4e5bc5cedd3b69b7e964))
* use HOME/USERPROFILE fallback for Windows compatibility ([e257e35](https://github.com/open-lingua/ielts-mastery-hub/commit/e257e35c3da18829d9a6153ef0a2658243ca1239))


### Refactors

* **admin:** simplify AdminDashboard and UserManagement pages ([e8d9c82](https://github.com/open-lingua/ielts-mastery-hub/commit/e8d9c82ca856c44e1bfbe29b1d77bb7e0e4544cb))
* **core:** extract writing asset sync logic into database::writing_assets_migration module ([012f2da](https://github.com/open-lingua/ielts-mastery-hub/commit/012f2dafe850cc2780ad87d9c37c4e88b094cab7))
* **core:** reorganize db module and consolidate migrations ([97875c9](https://github.com/open-lingua/ielts-mastery-hub/commit/97875c9d2d04323e981bca7ba341026a89c5afcb))
* **core:** replace listening_assets_migration with a shared LISTENING_ASSETS_DIR_NAME constant ([c890db3](https://github.com/open-lingua/ielts-mastery-hub/commit/c890db3cf1ba2e10105a6e842e1b5f0a7037a68f))
* **core:** store writing assets as &lt;task_id&gt;/figure.&lt;ext&gt; instead of &lt;task_id&gt;.&lt;ext&gt; ([0025b0a](https://github.com/open-lingua/ielts-mastery-hub/commit/0025b0a85475541dfd13aa68cbbd1aadbbf213f4))
* **core:** use test id alone as listening audio folder name, drop title slug ([f740f88](https://github.com/open-lingua/ielts-mastery-hub/commit/f740f88f4e72404ccaf839cac87b3fd9cd8e4e21))
* **dashboard:** simplify StudyHeatmap component ([3e8f21d](https://github.com/open-lingua/ielts-mastery-hub/commit/3e8f21de078949a32416470e47dcb74639ab93dd))
* declare new model submodules in models/mod.rs ([74c5da2](https://github.com/open-lingua/ielts-mastery-hub/commit/74c5da228499e8656ee8b408b097b21782280be9))
* **hooks:** simplify useAutoSaveAnswers logic ([4b669ee](https://github.com/open-lingua/ielts-mastery-hub/commit/4b669ee112a58b6671e2abcffe864e480097b782))
* import ListeningQuestion structs from models in listening_questions.rs ([57bfb21](https://github.com/open-lingua/ielts-mastery-hub/commit/57bfb21bfb60211958a3895fe93e48c21b3d7326))
* import ListeningQuestionGroup structs from models in listening_question_groups.rs ([3ef2a1f](https://github.com/open-lingua/ielts-mastery-hub/commit/3ef2a1fd7523a6144ce94fdfd959e98f6d8042e2))
* import ListeningSection structs from models in listening_sections.rs ([149a33c](https://github.com/open-lingua/ielts-mastery-hub/commit/149a33c5881bf8319b94c4795bebd6a5fedbd6e8))
* import ListeningTest structs from models in listening_tests.rs ([8146c7b](https://github.com/open-lingua/ielts-mastery-hub/commit/8146c7bbe4db0452e27fcff380ade2b24d375385))
* import PracticeTestCard from models in practice_library.rs ([5f72674](https://github.com/open-lingua/ielts-mastery-hub/commit/5f726749e8d672c502a0d26973236bbb6bf0873e))
* import Profile structs from models in profiles.rs ([75c95fc](https://github.com/open-lingua/ielts-mastery-hub/commit/75c95fce5b3b254c426d9b8607a8b186e1dfe78d))
* import ReadingPassage structs from models in reading_passages.rs ([5792d5b](https://github.com/open-lingua/ielts-mastery-hub/commit/5792d5b5a8514dba37bc9fdaba3846aec2432d86))
* import ReadingQuestion structs from models in reading_questions.rs ([5b504a4](https://github.com/open-lingua/ielts-mastery-hub/commit/5b504a4f54103d2320c1363a4e2a941063a8a541))
* import ReadingQuestion/ListeningQuestion from models in export_service.rs ([cf347bb](https://github.com/open-lingua/ielts-mastery-hub/commit/cf347bb6ebb71bfd1c40bd1929e9c5cd9477b960))
* import ReadingQuestionGroup structs from models in reading_question_groups.rs ([3b32ed7](https://github.com/open-lingua/ielts-mastery-hub/commit/3b32ed78854f079358cd2aecf126b5e42bf449c6))
* import ReadingTest structs from models in reading_tests.rs ([2a17dd9](https://github.com/open-lingua/ielts-mastery-hub/commit/2a17dd9e0a313ed77fa9f6bd618d53438f26705d))
* import UserRole structs from models in user_roles.rs ([8ce365b](https://github.com/open-lingua/ielts-mastery-hub/commit/8ce365b0493ec0b120454679cc39c2a31555d74b))
* import UserTestSession structs from models in user_test_sessions.rs ([337cc56](https://github.com/open-lingua/ielts-mastery-hub/commit/337cc56c55025d5129c2691c8e438ed069c8a003))
* import WritingTask structs from models in writing_tasks.rs ([d1cd4bd](https://github.com/open-lingua/ielts-mastery-hub/commit/d1cd4bd56d038a9f696daa91b3508e8e453fb012))
* import WritingTest structs from models in writing_tests.rs ([f1a80b7](https://github.com/open-lingua/ielts-mastery-hub/commit/f1a80b73fa33c574cbe921af8d90b26fd35a1903))
* **ImportDataset:** redesign UI with step-based layout and custom drop zones ([b66215c](https://github.com/open-lingua/ielts-mastery-hub/commit/b66215c945a98c79f5ba784c14980ebe26336c5b))
* move test-001 TTS configs into per-test subfolder ([5d8cfcb](https://github.com/open-lingua/ielts-mastery-hub/commit/5d8cfcbaae2ab7eedc111a0dc3c0216905f6f455))
* move tests to integration suite and expose db path helpers ([7bb5336](https://github.com/open-lingua/ielts-mastery-hub/commit/7bb53366221f750be1b4952185603c108c49422f))
* **pages:** update Dashboard page ([9966bf5](https://github.com/open-lingua/ielts-mastery-hub/commit/9966bf536aa2aa2d979de5ec44e663ca8fa97f9b))
* remove ListeningQuestion structs from repositories/listening_questions.rs ([f235046](https://github.com/open-lingua/ielts-mastery-hub/commit/f235046b920c0b4353520d3489597db2c08acb49))
* remove ListeningQuestionGroup structs from repositories/listening_question_groups.rs ([dd3ee8a](https://github.com/open-lingua/ielts-mastery-hub/commit/dd3ee8add6a12e15ed884007ee800bd6f703f242))
* remove ListeningSection structs from repositories/listening_sections.rs ([3ac050b](https://github.com/open-lingua/ielts-mastery-hub/commit/3ac050b661388f0acb94c8a547f6a045ac687d2b))
* remove ListeningTest structs from repositories/listening_tests.rs ([ff85cb3](https://github.com/open-lingua/ielts-mastery-hub/commit/ff85cb33b711ecade95486a922385893c68ba17c))
* remove PracticeTestRow/PracticeTestCard structs from repositories/practice_library.rs ([ec3d692](https://github.com/open-lingua/ielts-mastery-hub/commit/ec3d692924fe8b52a550e259af6baf793774258b))
* remove Profile structs from repositories/profiles.rs ([4e8c32b](https://github.com/open-lingua/ielts-mastery-hub/commit/4e8c32bb128a4f8b7639667c1e7b1bef3383ce6d))
* remove ReadingPassage structs from repositories/reading_passages.rs ([cd6341b](https://github.com/open-lingua/ielts-mastery-hub/commit/cd6341bf81fc7c258291400a297510eda39d7ef4))
* remove ReadingQuestion structs from repositories/reading_questions.rs ([e02bcc3](https://github.com/open-lingua/ielts-mastery-hub/commit/e02bcc3cdf4935fb51c2895a53b02465a8307434))
* remove ReadingQuestionGroup structs from repositories/reading_question_groups.rs ([e295a83](https://github.com/open-lingua/ielts-mastery-hub/commit/e295a835b282965fe2fc4fa6aac2bbd6065e5d5a))
* remove ReadingTest structs from repositories/reading_tests.rs ([e419724](https://github.com/open-lingua/ielts-mastery-hub/commit/e419724cd7d1983555c5b0cd4f4bf0816435bfd2))
* remove UserRole structs from repositories/user_roles.rs ([a995392](https://github.com/open-lingua/ielts-mastery-hub/commit/a9953929c4464892b5353bc59aaca35f54431d98))
* remove UserTestSession structs from repositories/user_test_sessions.rs ([64b866c](https://github.com/open-lingua/ielts-mastery-hub/commit/64b866c6c46f8eaccef2e8ce7987fbdd4b375f01))
* remove WritingTask structs from repositories/writing_tasks.rs ([04f5673](https://github.com/open-lingua/ielts-mastery-hub/commit/04f5673b7b861fa47c0c90b9db45eedc9b4ba0e8))
* remove WritingTest structs from repositories/writing_tests.rs ([d04ce51](https://github.com/open-lingua/ielts-mastery-hub/commit/d04ce517f84aea77083afcc9fdcf55975a3106b7))
* **services:** simplify aiGradingService ([e903d76](https://github.com/open-lingua/ielts-mastery-hub/commit/e903d763497fcfb48cbbdd19df9f788e90682f3e))
* **services:** simplify dashboardService ([fd2b994](https://github.com/open-lingua/ielts-mastery-hub/commit/fd2b994c50a95e97c2d1d983d1875d1ee8df1451))
* **services:** simplify listening services ([587e677](https://github.com/open-lingua/ielts-mastery-hub/commit/587e6775a79e82c7c4bd17c275e6ce50068f831b))
* **services:** simplify practiceLibraryService ([db735ba](https://github.com/open-lingua/ielts-mastery-hub/commit/db735ba28f1d3b6b7f57c72b9121c03e39f1bfc0))
* **services:** simplify reading services ([b193bde](https://github.com/open-lingua/ielts-mastery-hub/commit/b193bdeb8525db3e2a20606f62cc2aa1365cfc37))
* **services:** simplify writing services ([3568cde](https://github.com/open-lingua/ielts-mastery-hub/commit/3568cde54da52df2a5c77f8066c946703b707383))
* **services:** update contentService ([06bb8e3](https://github.com/open-lingua/ielts-mastery-hub/commit/06bb8e370cd9c5c6cf4b4139b3c3cb152fd8a422))
* **ui:** replace Supabase audio upload with Tauri command in listeningService ([ae1f7a8](https://github.com/open-lingua/ielts-mastery-hub/commit/ae1f7a86ea73a6ee0938862bf4359d97838ac272))
* **ui:** replace Supabase calls with Tauri 2 commands in src/ui ([bdaace0](https://github.com/open-lingua/ielts-mastery-hub/commit/bdaace0061decdb140b161c230290930f753a5fe))
* **ui:** replace Supabase image upload with Tauri command in writingService ([65de370](https://github.com/open-lingua/ielts-mastery-hub/commit/65de3703a290f7184ab8b039b3ea0a15faefc641))
* wire grade_writing to use stored AI config instead of env vars ([7bb0c0b](https://github.com/open-lingua/ielts-mastery-hub/commit/7bb0c0b5619695d3dfff038e7819618c502322d7))


### Documentation

* add admin docs ([65f8997](https://github.com/open-lingua/ielts-mastery-hub/commit/65f899788015fb1691fcba4df5328cdfc4a978e6))
* add admin portal user guides (overview, creating tests, content library, import/export, students) ([12e0efc](https://github.com/open-lingua/ielts-mastery-hub/commit/12e0efc769d52d5d27fc9d0c3a2c09dd5ad63f57))
* add api-reference docs ([14846cb](https://github.com/open-lingua/ielts-mastery-hub/commit/14846cb2ca82c13ccba452c1a3a745077d943579))
* add architecture docs ([c0df190](https://github.com/open-lingua/ielts-mastery-hub/commit/c0df190f903f94204140a164c462eca83dcae01d))
* add backend architecture reference ([a4b0eed](https://github.com/open-lingua/ielts-mastery-hub/commit/a4b0eedbebce15a0ed8f01b16e43016f7d010eee))
* add CODE_OF_CONDUCT ([b17eee7](https://github.com/open-lingua/ielts-mastery-hub/commit/b17eee7addee1679bf9911df2e8eae9ddb02fa68))
* add contributing docs ([861ba0d](https://github.com/open-lingua/ielts-mastery-hub/commit/861ba0dd8206ca875c68917776d6d3364fbba6f9))
* add CONTRIBUTING guide ([81cde62](https://github.com/open-lingua/ielts-mastery-hub/commit/81cde6287c6a1a90d8e22b0b0fdbcf611f1a45ff))
* Add CONTRIBUTING.md with setup, workflow, and PR guidelines ([7c71656](https://github.com/open-lingua/ielts-mastery-hub/commit/7c71656ba2a0680ac6925d079a8e11b3a751c356))
* add DATABASE_URL export to quick start setup ([1a5d1c3](https://github.com/open-lingua/ielts-mastery-hub/commit/1a5d1c3755f4cc016dd134184f44e09f67d074ed))
* add DATABASE_URL export to quick-start setup steps ([5e8889e](https://github.com/open-lingua/ielts-mastery-hub/commit/5e8889e4214afc0780bb46f8e73001c16e26e002))
* add DATABASE_URL setup instructions for sqlx CLI across platforms ([83bf008](https://github.com/open-lingua/ielts-mastery-hub/commit/83bf008472aaffa85e3d818e47dbf5294c9aad2f))
* add demo video to intro page ([23ba89b](https://github.com/open-lingua/ielts-mastery-hub/commit/23ba89b381d8da4c47c3445a5013caee0d3dbfa8))
* add desktop docs ([a464f56](https://github.com/open-lingua/ielts-mastery-hub/commit/a464f563e85295b5731cdff74630ff06a87b8064))
* add development database reset guide ([8c65e40](https://github.com/open-lingua/ielts-mastery-hub/commit/8c65e40b396b9f897071365037bf86d20c2fc94e))
* add Docusaurus website with TypeScript and Bun ([a2cfd37](https://github.com/open-lingua/ielts-mastery-hub/commit/a2cfd377f0ca9ad8cbdb6c32d0db8068c6932698))
* add export test to zip spec ([3b0df86](https://github.com/open-lingua/ielts-mastery-hub/commit/3b0df8617e979019cb9cbc85eaab337469a40c39))
* add FAQ and troubleshooting reference guide ([5f9baff](https://github.com/open-lingua/ielts-mastery-hub/commit/5f9baff79a97e4b3482e5090860d662eefa84385))
* add features docs ([524694e](https://github.com/open-lingua/ielts-mastery-hub/commit/524694e284a6405572d1229a67d5cff35da5cf60))
* add folder structure reference for AI context ([f5e498d](https://github.com/open-lingua/ielts-mastery-hub/commit/f5e498d460c8665b5040cd7fe822358124a5247d))
* add getting-started docs ([a8213c6](https://github.com/open-lingua/ielts-mastery-hub/commit/a8213c6d99673eea3cf63c2918bcd6cd67509b05))
* add getting-started user guides (welcome, progress saving) ([11ff0dc](https://github.com/open-lingua/ielts-mastery-hub/commit/11ff0dcc39723d16ef0e63190cffde9687c3443c))
* add IELTS trademark disclaimer to README ([1a085a7](https://github.com/open-lingua/ielts-mastery-hub/commit/1a085a73436dc9215b454000c765e9339fef738a))
* add IELTS trademark disclaimer to README part 2 ([ead2b31](https://github.com/open-lingua/ielts-mastery-hub/commit/ead2b31ef49e9e2727ee76f6e9cf70ee0f620728))
* add IELTS trademark disclaimer to README part 3 ([1f94555](https://github.com/open-lingua/ielts-mastery-hub/commit/1f94555a1780503a8771b12ff21d45b82b87974b))
* add intro doc ([d99bcc8](https://github.com/open-lingua/ielts-mastery-hub/commit/d99bcc8147fcbcccc2cbf46aaada9adfc82009f3))
* add missing _category_.json files for Docusaurus sidebar structure ([244424b](https://github.com/open-lingua/ielts-mastery-hub/commit/244424b3107e73bbde9ae8835fdbdbafd289e847))
* add one-line install commands for macOS/Linux and Windows ([2072fce](https://github.com/open-lingua/ielts-mastery-hub/commit/2072fce8a4542710372bafdca4c2f6b45021e627))
* add platform badge to README ([911acfa](https://github.com/open-lingua/ielts-mastery-hub/commit/911acfa7f839486576c16f49bceafedef6b0fe7f))
* add practicing user guides (practice library, reading, listening, writing, exam simulation) ([091dcdc](https://github.com/open-lingua/ielts-mastery-hub/commit/091dcdc73a5245cbf9b006575b6ba2eb3e5f0438))
* add preview GIF and demo video to README ([8be4b59](https://github.com/open-lingua/ielts-mastery-hub/commit/8be4b59e90b8c3bc253a566b414a3c4cb127b02f))
* add product docs ([7461ee0](https://github.com/open-lingua/ielts-mastery-hub/commit/7461ee0c95ade52c343f6e7d7d00ae2e1dcb57fe))
* add project banner image to README ([bc5dd81](https://github.com/open-lingua/ielts-mastery-hub/commit/bc5dd819c7e537db3031017391cdab734b2f5292))
* add project README ([ce1b251](https://github.com/open-lingua/ielts-mastery-hub/commit/ce1b25141f0c108642007c7f0af260c3c7cf23f7))
* add reference docs ([56dbaa1](https://github.com/open-lingua/ielts-mastery-hub/commit/56dbaa111dbad30e46090f4495d03bc70fe82d99))
* add social post generator prompt for IELTS Mastery Hub ([a910e83](https://github.com/open-lingua/ielts-mastery-hub/commit/a910e83c3677bc400ac23c5b18255547b0cd96e2))
* add Technical Docs sidebar category for internals ([53df71d](https://github.com/open-lingua/ielts-mastery-hub/commit/53df71d7e18f1d993d885eb3a3941ed835f489d4))
* add testing docs ([d9a03d0](https://github.com/open-lingua/ielts-mastery-hub/commit/d9a03d0aa153752f3bba8231985f509dab7527b1))
* add tracking-progress user guides (dashboard, band score) ([27174f4](https://github.com/open-lingua/ielts-mastery-hub/commit/27174f4bf62286521b377c859856549bd15b8cdd))
* add Usage Guides sidebar category for guides ([2c7a484](https://github.com/open-lingua/ielts-mastery-hub/commit/2c7a484d37a29d73db566df3d441240a77317855))
* add work-in-progress disclaimer and remove stale DATABASE_URL step ([5adfaee](https://github.com/open-lingua/ielts-mastery-hub/commit/5adfaee104331b5f2de2010b1e8e2fc3b546a01e))
* **admin:** add spec for dataset import feature ([e1611b5](https://github.com/open-lingua/ielts-mastery-hub/commit/e1611b5b338b50929bb7c948b9ca93051e439ddd))
* automate release process with release-please ([1ff96d3](https://github.com/open-lingua/ielts-mastery-hub/commit/1ff96d3ee332bebd03d14123feafd4462aac64a6))
* change license badge color to yellow ([c8e66d4](https://github.com/open-lingua/ielts-mastery-hub/commit/c8e66d48c1b8e9740167168dad3355c22170aec0))
* **ci:** fix comment punctuation in release-please workflow ([0ce0908](https://github.com/open-lingua/ielts-mastery-hub/commit/0ce0908535acec16b311d5feb3b3d99d592c906e))
* clarify app is desktop-native in description ([0c4ce2a](https://github.com/open-lingua/ielts-mastery-hub/commit/0c4ce2ae6d3714cc407a6e92f0f16674c9e2a39f))
* consolidate DATABASE_URL setup instructions into backend_architecture.md ([9be70d0](https://github.com/open-lingua/ielts-mastery-hub/commit/9be70d0ba81e9c2432ec43d6029e979dfb827bcd))
* **core:** add README with dev workflow and migration guide ([f6639d6](https://github.com/open-lingua/ielts-mastery-hub/commit/f6639d68bb1b8a1a9299a2f7a24e04af0774d31a))
* **core:** move testing conventions into docs/core/testing/ ([fc8a753](https://github.com/open-lingua/ielts-mastery-hub/commit/fc8a7534ab70cd298064d3b8fe9602d062ca3acd))
* disable sidebar autoCollapseCategories to keep both sections open ([51e73ed](https://github.com/open-lingua/ielts-mastery-hub/commit/51e73ed23633926aa25ee513d1bc207857643997))
* document MSI/WiX version overlay and Windows build process ([37389e0](https://github.com/open-lingua/ielts-mastery-hub/commit/37389e02d1e899b5c8263047078115eb6c39e354))
* document seed asset sync logging and troubleshooting ([fb92ba4](https://github.com/open-lingua/ielts-mastery-hub/commit/fb92ba49ce11d32370046e3a8513366e50eed551))
* expand Technical Docs sidebar category by default ([5224358](https://github.com/open-lingua/ielts-mastery-hub/commit/52243588e07142f447ef6bc5373f188173b09611))
* expand Usage Guides sidebar category by default ([090c8ad](https://github.com/open-lingua/ielts-mastery-hub/commit/090c8adc428dc970135b35e953f8770cc9e11185))
* fix broken relative links in intro.mdx to point into internals/ ([2f939b6](https://github.com/open-lingua/ielts-mastery-hub/commit/2f939b62d459a04f3e20e672d55c379da53ca386))
* fix bundle identifier mismatch in database reset guide ([02fc50e](https://github.com/open-lingua/ielts-mastery-hub/commit/02fc50ef1c589abc702f6725d29a2fd9e2de3f24))
* fix double period in docs link ([db8f23f](https://github.com/open-lingua/ielts-mastery-hub/commit/db8f23f6182fbb3d2c1c30db693378d6872d9e74))
* fix markdown link syntax, add update tip to install section ([e3c1747](https://github.com/open-lingua/ielts-mastery-hub/commit/e3c1747c782cce6557dd5abd28fde1009b36cb9a))
* move seed generator prompts to docs/prompts/ ([743eb2c](https://github.com/open-lingua/ielts-mastery-hub/commit/743eb2c5622056d9b583ffd39ddda01924296137))
* pin Tauri@2 and React@19 versions in tech stack ([f965be1](https://github.com/open-lingua/ielts-mastery-hub/commit/f965be1910d47a48e255154c60e1b1f4fdd43a20))
* **prompts:** add agent execution workflow and fix dialogue format in listening seed generator ([8dd559f](https://github.com/open-lingua/ielts-mastery-hub/commit/8dd559ffafdc79d4b171a5651bdb7717e1ac909a))
* **prompts:** add figure_description rules to DB seed generator prompt ([65ffb46](https://github.com/open-lingua/ielts-mastery-hub/commit/65ffb46335d040a8b6b3a1d8274e4b53ffe988ff))
* **prompts:** add transcript generator prompts for listening sections 1-2 and 3-4 ([a6f9dca](https://github.com/open-lingua/ielts-mastery-hub/commit/a6f9dcaf9035237d6bd60e79a822efb5a3f80f0a))
* **prompts:** add transcript technical specs per section to DB seed generator ([71e3dca](https://github.com/open-lingua/ielts-mastery-hub/commit/71e3dcadb480f9378596e4c5038448b51353023e))
* **prompts:** clarify dialogue format and word count rules in listening seed generator ([42b073c](https://github.com/open-lingua/ielts-mastery-hub/commit/42b073c598239977239f895303da8ba7f4a0bd42))
* **prompts:** update listening transcript generator prompts ([07cd317](https://github.com/open-lingua/ielts-mastery-hub/commit/07cd3171552401f1c66f61ca2e9dc32aa2583469))
* **prompts:** update listening transcript generator prompts ([43f9ff2](https://github.com/open-lingua/ielts-mastery-hub/commit/43f9ff28be2f07f7d9066a51fe1c4f2c323708dc))
* **prompts:** update sections 1-2 transcript generator prompt ([8317e66](https://github.com/open-lingua/ielts-mastery-hub/commit/8317e662128a9722d91d09af25194324625f9222))
* **prompts:** update transcript word count ranges for all listening sections ([51043e4](https://github.com/open-lingua/ielts-mastery-hub/commit/51043e4ab523150e1e892cbf051e3b96b9c9e240))
* remove legacy AI env vars from .env.example ([ca578eb](https://github.com/open-lingua/ielts-mastery-hub/commit/ca578eb2e341d7d60c3218defdba960b36a69443))
* remove unused info in intro ([b370682](https://github.com/open-lingua/ielts-mastery-hub/commit/b3706828f97d3167dc6a007cdd85095ca4ab5302))
* rename AGENTS.md header from Project Context to Agent Context ([d544eb9](https://github.com/open-lingua/ielts-mastery-hub/commit/d544eb90a9fe85b547b83975ee69987b22f93da9))
* rename files to lowercase ([887d843](https://github.com/open-lingua/ielts-mastery-hub/commit/887d8436ce3e252e130c4fbbb0dbd3128b871307))
* rename files to lowercase ([98cba30](https://github.com/open-lingua/ielts-mastery-hub/commit/98cba30c92ef3e71243ff9f67647c4584f563864))
* reorganize all docs under internals/ subdirectory ([81d5f2a](https://github.com/open-lingua/ielts-mastery-hub/commit/81d5f2a5571ff9355fb8c00ad85ff3d939ac9824))
* replace docs site build instructions with link to published docs ([74ad329](https://github.com/open-lingua/ielts-mastery-hub/commit/74ad329774fc565c47811b336798f35ff3aa01bd))
* replace npm/node references with bun across all docs ([f4b34ac](https://github.com/open-lingua/ielts-mastery-hub/commit/f4b34acb66e8f05e13e2947bee6c24f3ecc33c88))
* **testing:** add unit testing conventions for core module ([9cf1db7](https://github.com/open-lingua/ielts-mastery-hub/commit/9cf1db7347e99cafd87e47179c424827f28e5b6b))
* update internals docs for AI Configurations feature ([ba40994](https://github.com/open-lingua/ielts-mastery-hub/commit/ba4099444b40f6f68e4af7358c0890e27a673509))
* update preview GIF asset URL ([90ae4cd](https://github.com/open-lingua/ielts-mastery-hub/commit/90ae4cd595b12f9ff2967f2f50d5fdea8e8cd894))
* update README title to @open-lingua/ielts-mastery-hub ([9c8a90b](https://github.com/open-lingua/ielts-mastery-hub/commit/9c8a90bd4db53397b7da76d867b747afbffa8c70))
* update social post prompt to output Docusaurus MDX format with filename suggestions ([1652568](https://github.com/open-lingua/ielts-mastery-hub/commit/165256853fffbe3cf39fb3c131306e592a339d72))
* update storage and import docs to reflect task-id-based asset naming ([c63e7e9](https://github.com/open-lingua/ielts-mastery-hub/commit/c63e7e96f59dec27dd835faf113c8a0aae68a653))
* use uploaded GIF asset URL and link to preview.mp4 for audio ([aca9097](https://github.com/open-lingua/ielts-mastery-hub/commit/aca90979c42718470567e69a1e93d26bfcb5dc48))
* use uploaded GIF asset URL and link to preview.mp4 for audio ([55bf8e0](https://github.com/open-lingua/ielts-mastery-hub/commit/55bf8e00573b02f9ce31ae436d338352ad33c59a))
* **website:** add installing the app guide with Unix installer instructions ([c00f1e2](https://github.com/open-lingua/ielts-mastery-hub/commit/c00f1e2c16780ad894c64fbc886a3379c8af5a43))
* **website:** add Windows PowerShell installer instructions to install guide ([f59c5b7](https://github.com/open-lingua/ielts-mastery-hub/commit/f59c5b756005d496752459766a8032fe51cb9308))
* **website:** fix HTML entity and remove version env var from install guide ([76d484e](https://github.com/open-lingua/ielts-mastery-hub/commit/76d484e1b691a8b9db5c7e466563e3e8f99235b7))


### CI/CD

* add cargo fmt --check step to backend CI job ([aafdc81](https://github.com/open-lingua/ielts-mastery-hub/commit/aafdc81885f5761ddbbf9bb16907908bd384e3c7))
* add clippy lint step to backend job ([860a30f](https://github.com/open-lingua/ielts-mastery-hub/commit/860a30fbecbbb39c8e87360fce53e24b5b20b992))
* add cross-platform release workflow for macOS, Linux, and Windows ([de7bee9](https://github.com/open-lingua/ielts-mastery-hub/commit/de7bee9a189a287f106748a2ee75ad2d91bc2e31))
* add frontend lint step and simplify job names ([6fb8074](https://github.com/open-lingua/ielts-mastery-hub/commit/6fb80749b7a06ecd99601101240b5a30f7c6020c))
* add GitHub Pages docs deployment workflow ([398118c](https://github.com/open-lingua/ielts-mastery-hub/commit/398118ce9b2e44f1030fbdc3cca397132de55742))
* add macOS and Windows CI workflows ([511ce83](https://github.com/open-lingua/ielts-mastery-hub/commit/511ce8328ee3a85b0a51e3bbf0e2eb1a8635f308))
* add Rust/Tauri test job to CI workflow ([dd90ca9](https://github.com/open-lingua/ielts-mastery-hub/commit/dd90ca9977a029401abc4060a128f48b2c624be8))
* enable release workflow trigger and permissions ([2986849](https://github.com/open-lingua/ielts-mastery-hub/commit/298684909ab1cd978fd53797f4475a04b41c8b15))
* fallback to GITHUB_TOKEN when RELEASE_PLEASE_TOKEN is unset ([cf99b7d](https://github.com/open-lingua/ielts-mastery-hub/commit/cf99b7d8dbc77aec75144262a61422aecc95e9c0))
* install xdg-utils on Linux runners to fix aarch64 AppImage bundling ([0a2b902](https://github.com/open-lingua/ielts-mastery-hub/commit/0a2b90252b3c2cdabab21734a071928b89b30d98))
* migrate all workflows from node/npm to bun ([40d3129](https://github.com/open-lingua/ielts-mastery-hub/commit/40d3129550549b1b5003df667081361fcfca8f36))
* optimize backend job with sqlx offline mode and stable cargo cache ([3d9f7c0](https://github.com/open-lingua/ielts-mastery-hub/commit/3d9f7c0cf4f778e700e7735abd35abf20d5843cb))
* optimize Rust cache and apt install on Linux ([ea54fc2](https://github.com/open-lingua/ielts-mastery-hub/commit/ea54fc2642d8434424556e3206f7458651189a8d))
* rename ci.yml to ci-linux.yml ([ce556d5](https://github.com/open-lingua/ielts-mastery-hub/commit/ce556d5c8b40d5d2334ef9e333ef35698d075d33))
* replace SQLX_OFFLINE with DATABASE_URL for clippy and build steps ([2146e06](https://github.com/open-lingua/ielts-mastery-hub/commit/2146e061d2f92da26aabfc1efb531e086aca6b93))
* sync MSI overlay and test scripts in release and CI workflows ([9285fc2](https://github.com/open-lingua/ielts-mastery-hub/commit/9285fc2ee997367fb5916563815e2587b215d4cc))


### Tests

* add activate tests for ai_configurations repository and service ([4389f4a](https://github.com/open-lingua/ielts-mastery-hub/commit/4389f4ad35a6fe32ca1f038411b9b47c5a0e252f))
* add AiConfigurations page tests ([b402f36](https://github.com/open-lingua/ielts-mastery-hub/commit/b402f3643867dc48c507893fa0f4a65db2e6fa13))
* add integration and unit tests for update check ([583b950](https://github.com/open-lingua/ielts-mastery-hub/commit/583b9504457ab78223ce6fe613f07cd8ad4ea94e))
* add locked state tests to TestStartOverlay; wrap renders in TooltipProvider ([66a2791](https://github.com/open-lingua/ielts-mastery-hub/commit/66a27916802a8a3c7a4b2fa1577a3e828a3257d8))
* add practiceLibraryService unit tests ([16dc9d5](https://github.com/open-lingua/ielts-mastery-hub/commit/16dc9d5da2ae31275be94bd3fede553696da2a37))
* add repo test for marking an abandoned session as aborted ([da86037](https://github.com/open-lingua/ielts-mastery-hub/commit/da86037dbb3b450fb7cd99014b308dec6fd32bee))
* add seed_data integration tests ([a61870a](https://github.com/open-lingua/ielts-mastery-hub/commit/a61870a969f8755f581888653c48c72e33f24ccf))
* add tests for AI configuration model, repository, and service ([7a661ed](https://github.com/open-lingua/ielts-mastery-hub/commit/7a661ede50530767b1792a32573b962bdcb9681c))
* add WritingSimulator abort tests ([bae3a51](https://github.com/open-lingua/ielts-mastery-hub/commit/bae3a518f723473db278d14743e606dcc8741a77))
* add WritingSimulator integration tests for AI configuration gate ([833930b](https://github.com/open-lingua/ielts-mastery-hub/commit/833930ba6a71c652f19c093cb48b793cf8d1041a))
* assert AI Configurations nav item renders in AdminLayout ([58d16db](https://github.com/open-lingua/ielts-mastery-hub/commit/58d16db67d00235444e273b635cd8ec9b1200dbb))
* **core:** add shared test fixtures and data builders for src/core tests ([6f0f6d7](https://github.com/open-lingua/ielts-mastery-hub/commit/6f0f6d725283a2fcd5a7eb972cb7691000725797))
* **core:** add unit tests for src/core models ([bd26c60](https://github.com/open-lingua/ielts-mastery-hub/commit/bd26c60fdf41d72cee359670a3fb7fe1abd27e93))
* **core:** add unit tests for src/core repositories ([b816034](https://github.com/open-lingua/ielts-mastery-hub/commit/b816034a8b8501230b1469bcb5502d22da87a9dc))
* **core:** add unit tests for src/core root-level error handling ([73f7e9d](https://github.com/open-lingua/ielts-mastery-hub/commit/73f7e9db539b46b411615ebd29f272df6288b16d))
* **core:** add unit tests for src/core services ([e3bd2ff](https://github.com/open-lingua/ielts-mastery-hub/commit/e3bd2ff4c843651d00cf2593da2b5372873fbe03))
* **core:** allow(dead_code) on unused listening builder setters ([f68414c](https://github.com/open-lingua/ielts-mastery-hub/commit/f68414c10f6e5e585242f35f04bbb1322141ac40))
* **core:** allow(dead_code) on unused reading builder setters ([6cbd083](https://github.com/open-lingua/ielts-mastery-hub/commit/6cbd08378a94f1c544fcb0dc2ea98fcf05062e9b))
* **core:** allow(dead_code) on unused writing/profile/session builder setters ([8f3bc44](https://github.com/open-lingua/ielts-mastery-hub/commit/8f3bc44ac7edab8c4d571e58311d80b86b404649))
* **core:** drop unused default_* fixture re-exports from builders::mod ([91db6c4](https://github.com/open-lingua/ielts-mastery-hub/commit/91db6c459598cecaa3116f15e1fa1a5766f80d7a))
* **core:** remove unnecessary mut in export_service_test ([896288d](https://github.com/open-lingua/ielts-mastery-hub/commit/896288d22eb029a62cdbbdf1c7131cd84eb18505))
* **core:** wire up integration test entry point for src/core tests ([49965db](https://github.com/open-lingua/ielts-mastery-hub/commit/49965db1344ae8486ae2b6621c5649c7d1e4528b))
* extend AiConfigurations page tests for activate and delete flows ([d53372e](https://github.com/open-lingua/ielts-mastery-hub/commit/d53372e044fb22572264d1c5c3764a5c4fcdc598))
* extract shared ENV_LOCK/with_env_var helper; fix HOME assumptions in tests ([2df81f8](https://github.com/open-lingua/ielts-mastery-hub/commit/2df81f88c8513757bd314f1002930a1bddb5f6e4))
* **ui:** assert Import Dataset nav item renders in AdminLayout ([6ac8a9d](https://github.com/open-lingua/ielts-mastery-hub/commit/6ac8a9d77499d990f09431fc854e705b22755cd5))
* update asset sync tests to assert on AssetSyncOutcome ([bf436e3](https://github.com/open-lingua/ielts-mastery-hub/commit/bf436e3d575c19a775a6cd4d649ae535fd050b48))


### Chores

* add 1.0.0-beta.1 release notes to RELEASES.md ([9f5382e](https://github.com/open-lingua/ielts-mastery-hub/commit/9f5382eb901bec073555aee8de025130d3123c46))
* add bug report issue template ([4e978b5](https://github.com/open-lingua/ielts-mastery-hub/commit/4e978b54f894894eb95944abd9fceaf2a5321581))
* add CODEOWNERS ([2710bcd](https://github.com/open-lingua/ielts-mastery-hub/commit/2710bcd991f55f6d8d3321bc774d98d43ef7b12f))
* add Copilot CLI instructions via symlink to AGENTS.md ([f5b9588](https://github.com/open-lingua/ielts-mastery-hub/commit/f5b95881ae184916848e3fbe8fb6dd6bff0288dc))
* add feature request issue template ([2e23d28](https://github.com/open-lingua/ielts-mastery-hub/commit/2e23d28104a8f887d396aa2dfcfc09b8511f46be))
* add issue template config ([a70e881](https://github.com/open-lingua/ielts-mastery-hub/commit/a70e88129058e016906f231405f0189652f83299))
* add MIT LICENSE ([2871632](https://github.com/open-lingua/ielts-mastery-hub/commit/287163267469e8b64d7086cadf7be2d78dc5610b))
* add pull request template ([277881b](https://github.com/open-lingua/ielts-mastery-hub/commit/277881bf09ecc967949c4c63e9f6ef2efd712b0c))
* apply cargo fmt formatting ([9e7ec6f](https://github.com/open-lingua/ielts-mastery-hub/commit/9e7ec6ffbb9e30b2062d0c0486d786c5e2d03411))
* bump reqwest to 0.13.4 and fix rustls feature name ([47d7737](https://github.com/open-lingua/ielts-mastery-hub/commit/47d773797a4507e698c894e6f049eb3a5bbd3f53))
* bump sqlx to 0.9.0 ([6cba691](https://github.com/open-lingua/ielts-mastery-hub/commit/6cba691027c42650dfcff81f8ed7a1bbaee824c4))
* bump tauri-build to 2.6.3 ([43c4353](https://github.com/open-lingua/ielts-mastery-hub/commit/43c435326b04f5696aed18c0d2ffe9555139b610))
* bump thiserror to 2.0.20 ([05e7419](https://github.com/open-lingua/ielts-mastery-hub/commit/05e741900595a1cc039ef5133441b53a9f53b204))
* bump typescript to 7.0.2 ([22e5a85](https://github.com/open-lingua/ielts-mastery-hub/commit/22e5a859bf560c799c2cec54771d30f5a7f49e1f))
* bump version to 1.0.0-beta.1 and drop version from website package ([a23ba5c](https://github.com/open-lingua/ielts-mastery-hub/commit/a23ba5ca89c26a4d16f2f3bc21c2f8ad17cf34c2))
* bump version to 1.0.0-beta.12 ([0271118](https://github.com/open-lingua/ielts-mastery-hub/commit/0271118bb12f1157d628623e4602f3b9c18f2e0d))
* bump vitest to 4.1.11 ([49f6c10](https://github.com/open-lingua/ielts-mastery-hub/commit/49f6c10782cabf90a8254c1ad766a22b785f49b0))
* bump website deps (js-yaml, svgo, fast-uri, qs) via overrides ([f9d60af](https://github.com/open-lingua/ielts-mastery-hub/commit/f9d60af0e49baf3f1e42ff656f226b36b2c80941))
* clean up RELEASES.md and switch release-please versioning to default ([9528cdf](https://github.com/open-lingua/ielts-mastery-hub/commit/9528cdfdfe7d245267021978a603040dfa1eaed6))
* **core:** add dev-dependencies required for src/core test suite ([8d64e40](https://github.com/open-lingua/ielts-mastery-hub/commit/8d64e4013d1bcf4be8d4ce0750225c0e216729e8))
* **core:** register import command module ([a2442b8](https://github.com/open-lingua/ielts-mastery-hub/commit/a2442b8169fffe2a8297900dea4145af05789c8a))
* downgrade typescript to 5.8.3 and clean up lockfile ([9421ee9](https://github.com/open-lingua/ielts-mastery-hub/commit/9421ee94ea2b9d90918cee6175e750d6e7578a82))
* downgrade typescript to 6.0.3 for typescript-eslint compatibility ([c7600d4](https://github.com/open-lingua/ielts-mastery-hub/commit/c7600d4d2c565e42beaa6ebc7128313b776d1bc9))
* **main:** release 1.0.0-beta.14 ([#24](https://github.com/open-lingua/ielts-mastery-hub/issues/24)) ([3ec7b99](https://github.com/open-lingua/ielts-mastery-hub/commit/3ec7b992ab96b4c91767cad64ee8679534039cc2))
* **main:** release 1.0.0-beta.15 ([#25](https://github.com/open-lingua/ielts-mastery-hub/issues/25)) ([b79a9b4](https://github.com/open-lingua/ielts-mastery-hub/commit/b79a9b438df2045a8c7c2f06299aad9e65a66473))
* **main:** release 1.0.0-beta.16 ([#26](https://github.com/open-lingua/ielts-mastery-hub/issues/26)) ([cb2ae3f](https://github.com/open-lingua/ielts-mastery-hub/commit/cb2ae3f8c0353abadd62b4b41f974f7a549c7c87))
* **main:** release 1.0.0-beta.17 ([#28](https://github.com/open-lingua/ielts-mastery-hub/issues/28)) ([7237fc5](https://github.com/open-lingua/ielts-mastery-hub/commit/7237fc593bf36b182581364e89868156ed62dd90))
* **main:** release 1.0.0-beta.18 ([#36](https://github.com/open-lingua/ielts-mastery-hub/issues/36)) ([4ce1c9a](https://github.com/open-lingua/ielts-mastery-hub/commit/4ce1c9ab7a85b2835ea61d0a8b6f80a62d1a201c))
* **main:** release 1.0.0-beta.19 ([#39](https://github.com/open-lingua/ielts-mastery-hub/issues/39)) ([d109a9d](https://github.com/open-lingua/ielts-mastery-hub/commit/d109a9dbd630a8093f33d2db5ad715adf551c35f))
* **main:** release 1.0.0-beta.20 ([#40](https://github.com/open-lingua/ielts-mastery-hub/issues/40)) ([f8f2c85](https://github.com/open-lingua/ielts-mastery-hub/commit/f8f2c8560c1cc9b7cabefbac4e9da28a3192d1d1))
* **main:** release 1.0.0-beta.21 ([#41](https://github.com/open-lingua/ielts-mastery-hub/issues/41)) ([530ff77](https://github.com/open-lingua/ielts-mastery-hub/commit/530ff77fe636a1315bce01af5c77a3224cd50e80))
* **main:** release 1.0.0-beta.22 ([#42](https://github.com/open-lingua/ielts-mastery-hub/issues/42)) ([953bfa4](https://github.com/open-lingua/ielts-mastery-hub/commit/953bfa4afe927b23b7a9d21d2e9ddf14e8fff376))
* **main:** release 1.0.0-beta.23 ([#47](https://github.com/open-lingua/ielts-mastery-hub/issues/47)) ([96073fb](https://github.com/open-lingua/ielts-mastery-hub/commit/96073fb84e03891e711f5e835a047f5e2a448912))
* **main:** release 1.0.0-rc.2 ([#49](https://github.com/open-lingua/ielts-mastery-hub/issues/49)) ([47f2eb2](https://github.com/open-lingua/ielts-mastery-hub/commit/47f2eb2ae0752e8cc158d26d031ecd15813cf088))
* **main:** release 1.0.1-rc.2 ([#51](https://github.com/open-lingua/ielts-mastery-hub/issues/51)) ([bab306e](https://github.com/open-lingua/ielts-mastery-hub/commit/bab306e4f029c5d603554f4057306b7b0968a306))
* **main:** release 1.1.0-rc.2 ([#52](https://github.com/open-lingua/ielts-mastery-hub/issues/52)) ([1ad4527](https://github.com/open-lingua/ielts-mastery-hub/commit/1ad4527e0db9bf08ec0404b62e2f61c9960ec1a3))
* **main:** release 1.2.0-rc.2 ([#53](https://github.com/open-lingua/ielts-mastery-hub/issues/53)) ([a33e481](https://github.com/open-lingua/ielts-mastery-hub/commit/a33e481fe875d00117d4aba720b8b8f2559a8023))
* **main:** release 1.3.0-rc.2 ([#54](https://github.com/open-lingua/ielts-mastery-hub/issues/54)) ([5cafaa1](https://github.com/open-lingua/ielts-mastery-hub/commit/5cafaa1861d404438b2332be2710afd973076d99))
* **main:** release 1.3.1-rc.2 ([#55](https://github.com/open-lingua/ielts-mastery-hub/issues/55)) ([f9ded88](https://github.com/open-lingua/ielts-mastery-hub/commit/f9ded88c8062159c19a4f4dc4e2f633c021603c4))
* **main:** release 1.4.0-rc.2 ([#56](https://github.com/open-lingua/ielts-mastery-hub/issues/56)) ([4f31075](https://github.com/open-lingua/ielts-mastery-hub/commit/4f31075a8eb2722a112f12d1f203b395e1ad47c2))
* **main:** release 1.5.0-rc.2 ([#57](https://github.com/open-lingua/ielts-mastery-hub/issues/57)) ([807086d](https://github.com/open-lingua/ielts-mastery-hub/commit/807086dc90c43a46ed03403b62cc639215cd68b0))
* **main:** release 1.6.0-rc.2 ([#59](https://github.com/open-lingua/ielts-mastery-hub/issues/59)) ([8ad51fd](https://github.com/open-lingua/ielts-mastery-hub/commit/8ad51fda35a68297c5e37695340faf8fcd34cfef))
* **main:** release 1.7.0-rc.2 ([#60](https://github.com/open-lingua/ielts-mastery-hub/issues/60)) ([09381e3](https://github.com/open-lingua/ielts-mastery-hub/commit/09381e363f26d8b77032b87220ed9d98f54ad165))
* **main:** release 1.7.1-rc.2 ([#61](https://github.com/open-lingua/ielts-mastery-hub/issues/61)) ([464e11f](https://github.com/open-lingua/ielts-mastery-hub/commit/464e11f9129eb5b4d56dffaaa59e82d009e1abfe))
* **main:** release 1.7.2-rc.2 ([#62](https://github.com/open-lingua/ielts-mastery-hub/issues/62)) ([68ee923](https://github.com/open-lingua/ielts-mastery-hub/commit/68ee923c9b66da3ce8a7e49a4b3bc85eb07199d7))
* **main:** release 1.7.3-rc.2 ([#64](https://github.com/open-lingua/ielts-mastery-hub/issues/64)) ([6284854](https://github.com/open-lingua/ielts-mastery-hub/commit/6284854486ee8ee84d964c1ea27a8f7a786edb6b))
* **main:** release 1.7.4-rc.2 ([#65](https://github.com/open-lingua/ielts-mastery-hub/issues/65)) ([429faeb](https://github.com/open-lingua/ielts-mastery-hub/commit/429faeba22faa28283b22df2bed78195a6bfa454))
* mark .mdx files as documentation in gitattributes ([604a5ff](https://github.com/open-lingua/ielts-mastery-hub/commit/604a5ff602a90fd2cc8b9812e54cced0ced8879f))
* mark .sh and .ps1 as linguist-detectable=false ([06b4ee6](https://github.com/open-lingua/ielts-mastery-hub/commit/06b4ee6b93221a29c76c986b540ec25b292aee8b))
* mark .sh and .ps1 installer scripts in .gitattributes ([ae7fd21](https://github.com/open-lingua/ielts-mastery-hub/commit/ae7fd21fa0fc4c8fe23968fac5065549a2cb57b5))
* mark release-please config as prerelease ([64743fc](https://github.com/open-lingua/ielts-mastery-hub/commit/64743fcf97c9cc555b2f98ec67765ad9874fa765))
* mark scripts directory as linguist-generated ([5e7aa5e](https://github.com/open-lingua/ielts-mastery-hub/commit/5e7aa5e22d4c6cf37d90d29ec1d3c7aac0bb6b38))
* mark website docs and blog as documentation in gitattributes ([42dffdf](https://github.com/open-lingua/ielts-mastery-hub/commit/42dffdf9658f1e2fefe84e678e8f38efb918554d))
* migrate bun lockfile to new format ([cd71b10](https://github.com/open-lingua/ielts-mastery-hub/commit/cd71b1035d88e15248de82edafd197de22fbfd78))
* migrate from ESLint to Biome for linting and formatting ([3798a24](https://github.com/open-lingua/ielts-mastery-hub/commit/3798a24de61c7508d6811da699a8a10fecbb24b5))
* promote prerelease channel from beta to rc, bump to 1.0.0-rc.1 ([22443f6](https://github.com/open-lingua/ielts-mastery-hub/commit/22443f6ba1bfd9249158c2efb1039caa2b811884))
* reformat check-version-consistency.mjs to 2-space indent ([1cfaafc](https://github.com/open-lingua/ielts-mastery-hub/commit/1cfaafcfb2b867fe0a4b3727b5a8efdbbc2b348b))
* release 1.0.0-beta.9 ([063bc77](https://github.com/open-lingua/ielts-mastery-hub/commit/063bc779090439469abf57ef3aebf70fe7bb7d08))
* release 1.7.4 ([1af68a6](https://github.com/open-lingua/ielts-mastery-hub/commit/1af68a62f64574325809478717e37d9947083431))
* release v1.0.0-beta.10 ([3d1a20a](https://github.com/open-lingua/ielts-mastery-hub/commit/3d1a20af2ec13b93dd6e02e6fe72ff1c709724ef))
* release v1.0.0-beta.11 ([98628f1](https://github.com/open-lingua/ielts-mastery-hub/commit/98628f13c843790ad3379256f566807f6d883850))
* **release:** bump version to 1.0.0-beta.3 and add changelog entry ([b7d37c8](https://github.com/open-lingua/ielts-mastery-hub/commit/b7d37c8b5656c8049201f683dbb454e3c44a35bc))
* **release:** bump version to 1.0.0-beta.4 and add changelog entry ([11430ee](https://github.com/open-lingua/ielts-mastery-hub/commit/11430ee04bd6e58056499bd0cbc0b767e259aac0))
* **release:** bump version to 1.0.0-beta.5 and add changelog entry ([0c61fd9](https://github.com/open-lingua/ielts-mastery-hub/commit/0c61fd9f5d30b1110de4f3bbe35e2f9f90dd7fa4))
* **release:** bump version to 1.0.0-beta.6 ([767e4d4](https://github.com/open-lingua/ielts-mastery-hub/commit/767e4d41e26772fa2b8faa70b741bae8a79d6bb7))
* **release:** bump version to 1.0.0-beta.7 ([5367179](https://github.com/open-lingua/ielts-mastery-hub/commit/5367179e5e56dadc3f3194e0280c05716039d4a3))
* remove dev.db from tracking ([becc4b1](https://github.com/open-lingua/ielts-mastery-hub/commit/becc4b12414abed5a9790cc7be0190b8a106d327))
* remove legacy SQL seed files, replace with assets/examples ([cdfbd38](https://github.com/open-lingua/ielts-mastery-hub/commit/cdfbd38fec83bca274f42391a4640ebe7e47a030))
* remove Lovable branding and lovable-tagger dependency ([c4d48b8](https://github.com/open-lingua/ielts-mastery-hub/commit/c4d48b872c863c4138ebed0946924397eb446f9b))
* remove Lovable branding and lovable-tagger dependency ([7130bc3](https://github.com/open-lingua/ielts-mastery-hub/commit/7130bc3240c2a55f0f7ccbf612439f6e294704e6))
* remove Supabase backend and migrate docs to Tauri/SQLite architecture ([d767659](https://github.com/open-lingua/ielts-mastery-hub/commit/d76765948c852d17a485d6624d3c7d4cac7d2a70))
* remove Supabase legacy code and references ([370ff10](https://github.com/open-lingua/ielts-mastery-hub/commit/370ff10bbc1a031fc2cccf97ab16fae00fd648d0))
* remove Supabase secrets requirement and patch website deps ([e2eb09a](https://github.com/open-lingua/ielts-mastery-hub/commit/e2eb09a31c8fe3972ef124497afe245da3d7e5d2))
* rename asset files to app-banner and app-logo ([9836b02](https://github.com/open-lingua/ielts-mastery-hub/commit/9836b02f92ff230ec8c8c1d2291f91573f4ceaac))
* rename core crate to open-lingua-ielts-mastery-hub-core ([e6949bb](https://github.com/open-lingua/ielts-mastery-hub/commit/e6949bb3a5db3f78c4fe281f028cf668588741d0))
* rename database file from ielts.db to imh.db ([e8d159a](https://github.com/open-lingua/ielts-mastery-hub/commit/e8d159a03ebfc5c9dfacd0467fb9af44b9e4e2be))
* rename local storage root from .ielts-hub to .imh ([b76ecca](https://github.com/open-lingua/ielts-mastery-hub/commit/b76ecca706276ec99e5f995e38f95664f591340b))
* rename package to @open-lingua/ielts-mastery-hub and bump version to 0.1.0 ([1f574a6](https://github.com/open-lingua/ielts-mastery-hub/commit/1f574a61b9dc9a0c9277699393c8416a83d1e419))
* rename website package to @open-lingua/ielts-mastery-hub-website and bump version to 0.1.0 ([c8850bb](https://github.com/open-lingua/ielts-mastery-hub/commit/c8850bbf936e9fd7f76054f0de41ea6b076a60fd))
* replace default Docusaurus branding with app assets ([618c1f9](https://github.com/open-lingua/ielts-mastery-hub/commit/618c1f990db7014d5868dfc940182cb72d8ebf2b))
* replace pnpm to npm ([735f7e2](https://github.com/open-lingua/ielts-mastery-hub/commit/735f7e29b45f6fe4954107b6f09b421b5671403c))
* resolve merge conflict in useVersionCheck ([4659f08](https://github.com/open-lingua/ielts-mastery-hub/commit/4659f08f23901916e9045a7936ba30accc73a01c))
* restore prerelease versioning strategy in release-please config ([916ad1c](https://github.com/open-lingua/ielts-mastery-hub/commit/916ad1c261ad32c998bda65d6881979d6c42fb11))
* **seeds:** remove band 6 test 001 listening seed and its assets ([0de38ec](https://github.com/open-lingua/ielts-mastery-hub/commit/0de38ec0e564e9fed86fb7797a9019fbc9ce39ec))
* **seeds:** remove legacy tts-config flat directory ([5f18e65](https://github.com/open-lingua/ielts-mastery-hub/commit/5f18e65c5a7c46c57a6a3ad09d82fd3827e277c9))
* **seeds:** remove outdated listening seed files and their associated TTS configs ([4b8131e](https://github.com/open-lingua/ielts-mastery-hub/commit/4b8131e43960215c926d8829fe498bdb0eafb4cd))
* **seeds:** rename TTS config files from section-N-tts-config.json to section-N.json ([78b7a1b](https://github.com/open-lingua/ielts-mastery-hub/commit/78b7a1b3bd6b64dd3ea0c6e4c93b6198ad1501b0))
* **seeds:** rename writing asset files to match task UUIDs ([5e54968](https://github.com/open-lingua/ielts-mastery-hub/commit/5e549688e69a6b9e57694dd2d536e3258d07d4b8))
* **seeds:** reorganize TTS configs into per-test UUID subdirectories ([134a0fa](https://github.com/open-lingua/ielts-mastery-hub/commit/134a0fa19eb6bc907359477654a310bcc1686132))
* switch release-please versioning back to default ([13a8d9d](https://github.com/open-lingua/ielts-mastery-hub/commit/13a8d9d6db6aa3b5c17784d62af4ef0ff9bd59a4))
* update bun.lock for vitest 4.1.11 ([3e1a448](https://github.com/open-lingua/ielts-mastery-hub/commit/3e1a448b128c45f895d55b01e216d30f9976d08a))
* update IELTS Mastery Hub brand ([3b8cbd8](https://github.com/open-lingua/ielts-mastery-hub/commit/3b8cbd8148cdf54fcd917c7c85abd0a8b2a274b5))
* update npm dependencies part 1 ([ca31584](https://github.com/open-lingua/ielts-mastery-hub/commit/ca315848b7e6ed29a5b894c408186756b6378be2))
* update npm dependencies part 10 ([7daf9eb](https://github.com/open-lingua/ielts-mastery-hub/commit/7daf9ebd62c5e1cc1c161ae378bd9c8ae01ad670))
* update npm dependencies part 2 ([8c237c8](https://github.com/open-lingua/ielts-mastery-hub/commit/8c237c8f9f87814c0be91bd947c60e733cb6ba49))
* update npm dependencies part 3 ([024343e](https://github.com/open-lingua/ielts-mastery-hub/commit/024343ea580251c8a5c15790c242dd27b93d32d8))
* update npm dependencies part 4 ([d01e929](https://github.com/open-lingua/ielts-mastery-hub/commit/d01e92957c2398577376c5e54504e7921cfaf302))
* update npm dependencies part 5 ([aac2e1b](https://github.com/open-lingua/ielts-mastery-hub/commit/aac2e1b73619407262c2eca29a71e3fdbd02fdb0))
* update npm dependencies part 6 ([152d94f](https://github.com/open-lingua/ielts-mastery-hub/commit/152d94f84e1cc82c13890acf277c0f158bb1dd45))
* update npm dependencies part 7 ([8409d6e](https://github.com/open-lingua/ielts-mastery-hub/commit/8409d6e6ff5a8f40797ef65557d0ac5a07ea7f3d))
* update npm dependencies part 8 ([6097786](https://github.com/open-lingua/ielts-mastery-hub/commit/60977863bda2a937d9a0b16ccfa5b516f20f6f00))
* update npm dependencies part 9 ([bc936e3](https://github.com/open-lingua/ielts-mastery-hub/commit/bc936e3c3cf529b1d67629927648d12fbf4bcd05))
* update package-lock.json ([b9e62fe](https://github.com/open-lingua/ielts-mastery-hub/commit/b9e62fe9d3238272235056861bd497e223980055))
* update website/bun.lock for dep bumps (js-yaml, svgo, fast-uri, qs) ([abee8fc](https://github.com/open-lingua/ielts-mastery-hub/commit/abee8fcdbd6d5fc2b7db219159c5bfcdce08980b))
* **website:** configure site for IELTS Mastery Hub (title, org, url) ([5453ca7](https://github.com/open-lingua/ielts-mastery-hub/commit/5453ca77b873ce5461914402ab77cf61ef58e680))
* **website:** switch to GitHub Pages URL and add docs site deploy instructions ([97c7064](https://github.com/open-lingua/ielts-mastery-hub/commit/97c706470d02cb96c043d47c84196be9340cdeb7))

## [1.7.4-rc.2](https://github.com/open-lingua/ielts-mastery-hub/compare/1.7.3-rc.2...1.7.4-rc.2) (2026-09-11)


### Bug Fixes

* correct question order and remove duplicate group insert in band 9.0 listening seed ([93641a6](https://github.com/open-lingua/ielts-mastery-hub/commit/93641a682949e6630ffb566a15ae713d59ed0303))
* correct question order in band 8.0 Section 2 matching questions ([c091d26](https://github.com/open-lingua/ielts-mastery-hub/commit/c091d266745e28fe7817d916ea0a31b276a771d4))
* correct Section 2 matching question options and answers in band 8.0 listening seed ([8715c74](https://github.com/open-lingua/ielts-mastery-hub/commit/8715c7428115eb674cba3196ba147f337448b9e6))
* correct Section 2 matching question options and answers in band 9.0 listening seed ([d997a7e](https://github.com/open-lingua/ielts-mastery-hub/commit/d997a7e11bf420b1e41ad0e65f720d11d8bb33b7))
* correct Section 2 matching question options and answers in listening seed ([57c0a27](https://github.com/open-lingua/ielts-mastery-hub/commit/57c0a27e518591ed458f22164372ca44e1cbb469))
* remove duplicate group/question inserts from band 7.0 and 8.0 listening seeds ([daea642](https://github.com/open-lingua/ielts-mastery-hub/commit/daea64274539e7e1a9decc06747aa614c9abb907))


### Documentation

* add DATABASE_URL export to quick-start setup steps ([6aef990](https://github.com/open-lingua/ielts-mastery-hub/commit/6aef99092d61143b531de6e2a6d5d3ca1d51248b))
* add demo video to intro page ([1c8ee79](https://github.com/open-lingua/ielts-mastery-hub/commit/1c8ee796fdfdf572253c2bb42798ef7d9fbe56f1))


### CI/CD

* add GitHub Pages docs deployment workflow ([642c95d](https://github.com/open-lingua/ielts-mastery-hub/commit/642c95daad7bdbed74b43d8a187d0529ea4f2ad8))

## [1.7.3-rc.2](https://github.com/open-lingua/ielts-mastery-hub/compare/1.7.2-rc.2...1.7.3-rc.2) (2026-09-11)


### Bug Fixes

* use HOME/USERPROFILE fallback for Windows compatibility ([ad5a292](https://github.com/open-lingua/ielts-mastery-hub/commit/ad5a292bfad2c933fda10f2ad06cd0105eb5004b))


### Documentation

* add social post generator prompt for IELTS Mastery Hub ([a7124c7](https://github.com/open-lingua/ielts-mastery-hub/commit/a7124c7d8a5b701d7d12b44ee76f041c9e92042b))
* fix double period in docs link ([9e0bf0a](https://github.com/open-lingua/ielts-mastery-hub/commit/9e0bf0ae1b4315056b3a0fdc0303ab558825d18e))
* update social post prompt to output Docusaurus MDX format with filename suggestions ([ee91387](https://github.com/open-lingua/ielts-mastery-hub/commit/ee913876d33254b744e8e06c339530945dd1af6d))


### CI/CD

* add macOS and Windows CI workflows ([a9984ba](https://github.com/open-lingua/ielts-mastery-hub/commit/a9984ba1f5afa617ec2ffd41392c483ab0ebcc65))


### Tests

* extract shared ENV_LOCK/with_env_var helper; fix HOME assumptions in tests ([71f9905](https://github.com/open-lingua/ielts-mastery-hub/commit/71f9905983b679c7e0076a1c813acdb3ecc0190b))

## [1.7.2-rc.2](https://github.com/open-lingua/ielts-mastery-hub/compare/1.7.1-rc.2...1.7.2-rc.2) (2026-09-11)


### Documentation

* add preview GIF and demo video to README ([5aa8dd9](https://github.com/open-lingua/ielts-mastery-hub/commit/5aa8dd93b98e6a8daf1761911e913207d0061c0d))
* fix markdown link syntax, add update tip to install section ([e10b4df](https://github.com/open-lingua/ielts-mastery-hub/commit/e10b4df345fd748ccba3dd7d3fd1d0fe7ce7dc58))
* update preview GIF asset URL ([c4c0f3c](https://github.com/open-lingua/ielts-mastery-hub/commit/c4c0f3cde066025921fbe8bd40b400aa1c977cf7))
* use uploaded GIF asset URL and link to preview.mp4 for audio ([beea43f](https://github.com/open-lingua/ielts-mastery-hub/commit/beea43f09fa7c8f05b5151b1958cc7504c879ddc))
* use uploaded GIF asset URL and link to preview.mp4 for audio ([43e34c8](https://github.com/open-lingua/ielts-mastery-hub/commit/43e34c86c8a1fce56a60833d75b7c0b0317709f2))

## [1.7.1-rc.2](https://github.com/open-lingua/ielts-mastery-hub/compare/1.7.0-rc.2...1.7.1-rc.2) (2026-09-11)


### Documentation

* replace npm/node references with bun across all docs ([dd193ef](https://github.com/open-lingua/ielts-mastery-hub/commit/dd193effc2bf208de7dfa05ece74b860a170fde2))


### CI/CD

* add cargo fmt --check step to backend CI job ([3bac947](https://github.com/open-lingua/ielts-mastery-hub/commit/3bac947956ff650dad84025c3e7190dbd6639762))
* migrate all workflows from node/npm to bun ([e901875](https://github.com/open-lingua/ielts-mastery-hub/commit/e901875e6ae7923cd5051f633b2c2311e8b5accc))


### Chores

* update bun.lock for vitest 4.1.11 ([3e6bee7](https://github.com/open-lingua/ielts-mastery-hub/commit/3e6bee7a47dc61dd4ee8e01c8cbf0b8748e092c9))
* update website/bun.lock for dep bumps (js-yaml, svgo, fast-uri, qs) ([c880410](https://github.com/open-lingua/ielts-mastery-hub/commit/c8804106dc6935b8918a8938f1889495f77b26b6))

## [1.7.0-rc.2](https://github.com/open-lingua/ielts-mastery-hub/compare/1.6.0-rc.2...1.7.0-rc.2) (2026-09-11)


### Features

* **db:** add migration to allow 'aborted' user_test_session status ([b2b3cec](https://github.com/open-lingua/ielts-mastery-hub/commit/b2b3cece0a62fcaed837a15627d10f98bf4092ff))
* handle aborted session status in TestLibrary card styles ([8d1fb0a](https://github.com/open-lingua/ielts-mastery-hub/commit/8d1fb0af76085bb9210a505178c3f44e461c7f88))
* replace deleteUserTestSession with abortSession in all test modules ([1844234](https://github.com/open-lingua/ielts-mastery-hub/commit/1844234ee528b1053a8c3b6292852aa21160562a))


### Documentation

* add one-line install commands for macOS/Linux and Windows ([4193fe2](https://github.com/open-lingua/ielts-mastery-hub/commit/4193fe2886ebe49041a5d96365fcd04a5c4ce568))
* add work-in-progress disclaimer and remove stale DATABASE_URL step ([02bd993](https://github.com/open-lingua/ielts-mastery-hub/commit/02bd9930a9d83291ea8e667cb48ce1a66e7fac2e))
* replace docs site build instructions with link to published docs ([92f71c4](https://github.com/open-lingua/ielts-mastery-hub/commit/92f71c431bf61c2de12e656a9705ee344ba50542))


### Tests

* add practiceLibraryService unit tests ([19bd127](https://github.com/open-lingua/ielts-mastery-hub/commit/19bd127aa63bd6a33b0b8a1b6a62840aa95b46d9))
* add repo test for marking an abandoned session as aborted ([4903765](https://github.com/open-lingua/ielts-mastery-hub/commit/4903765f37a1675049419856cf968d3b30268721))
* add WritingSimulator abort tests ([156a2fa](https://github.com/open-lingua/ielts-mastery-hub/commit/156a2fa7e5d5f40bed7c7e9d0761c7b73ce54eae))


### Chores

* bump vitest to 4.1.11 ([e29c17d](https://github.com/open-lingua/ielts-mastery-hub/commit/e29c17d25d459a66a3b36e9b9271453a6af995be))
* bump website deps (js-yaml, svgo, fast-uri, qs) via overrides ([3ea81c0](https://github.com/open-lingua/ielts-mastery-hub/commit/3ea81c0d2dbe6e8cb0c10ba9d353d38f00a0e734))

## [1.6.0-rc.2](https://github.com/open-lingua/ielts-mastery-hub/compare/1.5.0-rc.2...1.6.0-rc.2) (2026-09-10)


### Features

* add log/env_logger and initialize logger at startup ([1b67992](https://github.com/open-lingua/ielts-mastery-hub/commit/1b67992d9936ca91eab2a4341a2a8b46ac34ef6c))
* structured AssetSyncOutcome + replace eprintln with log macros ([1e986c4](https://github.com/open-lingua/ielts-mastery-hub/commit/1e986c49fbd601497207f8262259c5d5d945e376))


### Documentation

* document seed asset sync logging and troubleshooting ([d3a2dff](https://github.com/open-lingua/ielts-mastery-hub/commit/d3a2dff0332bef814284bec02fb36e79a5ae8ca8))


### Tests

* update asset sync tests to assert on AssetSyncOutcome ([f509d58](https://github.com/open-lingua/ielts-mastery-hub/commit/f509d582235c85305ab3a116d9daff4b3c5d3198))

## [1.5.0-rc.2](https://github.com/open-lingua/ielts-mastery-hub/compare/1.4.0-rc.2...1.5.0-rc.2) (2026-09-10)


### Features

* add preStartContent slot to TestStartOverlay ... ([e4f59cc](https://github.com/open-lingua/ielts-mastery-hub/commit/e4f59cc9f5ec662ed4719bfa05643ee5c71599ed))
* add unscored mode to Writing test ... ([f414938](https://github.com/open-lingua/ielts-mastery-hub/commit/f41493824dcb0305ac3cf4a59afb2c32ca54502d))
* make ChatGPT model name configurable; update docs ([7e99014](https://github.com/open-lingua/ielts-mastery-hub/commit/7e99014d97ad6aad504bdfb77055fbb17e7eb88d))
* make Claude model name configurable to fix 404 on retired model aliases ([000c63f](https://github.com/open-lingua/ielts-mastery-hub/commit/000c63f9d493b23f026e7499e06b5a8ac499ac04))
* make Gemini model name configurable; update default to gemini-2.5-flash ([ee89ed2](https://github.com/open-lingua/ielts-mastery-hub/commit/ee89ed2ccbbac16911c7154a609f54ac8174995c))


### Tests

* add WritingSimulator integration tests for AI configuration gate ([ee9c61a](https://github.com/open-lingua/ielts-mastery-hub/commit/ee9c61acd36d286b44636bb23acfe4e1c2a8a2b4))


### Chores

* mark .sh and .ps1 as linguist-detectable=false ([5360921](https://github.com/open-lingua/ielts-mastery-hub/commit/5360921c2994bb27f871417cd07ebd9d15ccfd0d))

## [1.4.0-rc.2](https://github.com/open-lingua/ielts-mastery-hub/compare/1.3.1-rc.2...1.4.0-rc.2) (2026-09-10)


### Features

* add activate and delete flows to AI Configurations page ([3a7e343](https://github.com/open-lingua/ielts-mastery-hub/commit/3a7e34367395e0307aa7f3e819fac582a137f8a0))
* add activate_ai_configuration command ([fd4b453](https://github.com/open-lingua/ielts-mastery-hub/commit/fd4b4535b829bd25159a328aa81b22a03d72dbc5))
* add AES-GCM encryption key infrastructure for AI credentials ([90f80fa](https://github.com/open-lingua/ielts-mastery-hub/commit/90f80faf3230fde764504a6f81397d88e44e91c5))
* add AI configuration model, repository, service, and commands ([d2afa57](https://github.com/open-lingua/ielts-mastery-hub/commit/d2afa57a021c1e4cca500002acb2194ce9b8041e))
* add AI Configurations admin page and nav entry ([be31819](https://github.com/open-lingua/ielts-mastery-hub/commit/be31819b282cb2ee83c53329476cd6c55550f6b2))
* add locked state to TestStartOverlay ([14e5e85](https://github.com/open-lingua/ielts-mastery-hub/commit/14e5e856e3d23655c6e4c9e6816ddd6202c9b5e3))
* add model name field to local and general provider forms ([67ef7d1](https://github.com/open-lingua/ielts-mastery-hub/commit/67ef7d17c36e21e24b35c247835c4ba5fc9168b8))
* **db:** add ai_configurations migration ([83690fa](https://github.com/open-lingua/ielts-mastery-hub/commit/83690fafb0e873da7fff12df05a4c733bc131853))
* extract seed data runner and bundle full seed directories as resources ([ae60a20](https://github.com/open-lingua/ielts-mastery-hub/commit/ae60a206f8fe7e17e9ee52f658bfbcbd44636da7))
* gate Writing test start on an active AI configuration ([2fd1f00](https://github.com/open-lingua/ielts-mastery-hub/commit/2fd1f0043c05934b944f9566744de0c88c53acd0))
* make model name configurable for local/general providers; improve failure errors ([942518c](https://github.com/open-lingua/ielts-mastery-hub/commit/942518c938de7ac534542a1c0da80e4a91e66d0f))
* wire AI Configurations page to backend ([485c217](https://github.com/open-lingua/ielts-mastery-hub/commit/485c2173f1ce562188c5e702348b922faa50cc0e))


### Refactors

* wire grade_writing to use stored AI config instead of env vars ([57b5256](https://github.com/open-lingua/ielts-mastery-hub/commit/57b5256f86d14fef74e75af0bb113500e992c782))


### Documentation

* remove legacy AI env vars from .env.example ([9e53a9b](https://github.com/open-lingua/ielts-mastery-hub/commit/9e53a9ba15cf602fde325deea258771ac4ed6625))
* update internals docs for AI Configurations feature ([b252db0](https://github.com/open-lingua/ielts-mastery-hub/commit/b252db07d224a6a07f5f171f99dd2c9c4b1ba879))


### CI/CD

* install xdg-utils on Linux runners to fix aarch64 AppImage bundling ([88adf8f](https://github.com/open-lingua/ielts-mastery-hub/commit/88adf8ff32acf883bd38b4cde95808db9f3e2de5))


### Tests

* add activate tests for ai_configurations repository and service ([8164d9d](https://github.com/open-lingua/ielts-mastery-hub/commit/8164d9de63cde75254fcfbc4546c8fac946de804))
* add AiConfigurations page tests ([060baee](https://github.com/open-lingua/ielts-mastery-hub/commit/060baeed390f688b6d19f6fa26ae4f5d31a84c58))
* add locked state tests to TestStartOverlay; wrap renders in TooltipProvider ([6f80383](https://github.com/open-lingua/ielts-mastery-hub/commit/6f8038379b2dc0fcfe77388766c6f823e08d10fe))
* add seed_data integration tests ([8f6e2da](https://github.com/open-lingua/ielts-mastery-hub/commit/8f6e2daa7dac54e72714a9c610996363078e492c))
* add tests for AI configuration model, repository, and service ([d50e744](https://github.com/open-lingua/ielts-mastery-hub/commit/d50e7448ee2437926eb8ebf9f5728f8095b50a3d))
* assert AI Configurations nav item renders in AdminLayout ([1c6982e](https://github.com/open-lingua/ielts-mastery-hub/commit/1c6982e7d3fc8c1a8116a34ea535f68324f62860))
* extend AiConfigurations page tests for activate and delete flows ([ab9f7fd](https://github.com/open-lingua/ielts-mastery-hub/commit/ab9f7fdc10983c803f6856ab438e0fdeda5e1471))

## [1.3.1-rc.2](https://github.com/open-lingua/ielts-mastery-hub/compare/1.3.0-rc.2...1.3.1-rc.2) (2026-09-10)


### Bug Fixes

* update bun.lockb to include missing autoprefixer dependency ([9686782](https://github.com/open-lingua/ielts-mastery-hub/commit/96867824a6de1a1962117b307b14285cd957990d))


### Chores

* migrate bun lockfile to new format ([e4cf2ea](https://github.com/open-lingua/ielts-mastery-hub/commit/e4cf2ea65ca4d2d7e001e73d96d19441bdc1c708))

## [1.3.0-rc.2](https://github.com/open-lingua/ielts-mastery-hub/compare/1.2.0-rc.2...1.3.0-rc.2) (2026-09-10)


### Features

* add GitHub release update check service and Tauri command ([1ae6399](https://github.com/open-lingua/ielts-mastery-hub/commit/1ae6399b7882e97bb7c130960c431c0773edcf0c))
* resolve seed asset paths at runtime via Tauri resource API ([e012c65](https://github.com/open-lingua/ielts-mastery-hub/commit/e012c659ec13d4400bdade5cc4173ce0acb30c29))
* **update:** wire real update check via GitHub API and open release URL with tauri-plugin-opener ([01eb417](https://github.com/open-lingua/ielts-mastery-hub/commit/01eb417ea3530798d11840dd85a55db3db0caa14))


### Documentation

* **website:** fix HTML entity and remove version env var from install guide ([1bb6d9c](https://github.com/open-lingua/ielts-mastery-hub/commit/1bb6d9c2fad1cd28a8f6afee4452f9a7e42a4e0f))


### Tests

* add integration and unit tests for update check ([cd564ca](https://github.com/open-lingua/ielts-mastery-hub/commit/cd564ca4dab7b8e0f9bf4e8dd17a74d6b0b6889a))


### Chores

* mark .sh and .ps1 installer scripts in .gitattributes ([f0b9e49](https://github.com/open-lingua/ielts-mastery-hub/commit/f0b9e497ae72eaafa958244c9da2d34d7989d116))

## [1.2.0-rc.2](https://github.com/open-lingua/ielts-mastery-hub/compare/1.1.0-rc.2...1.2.0-rc.2) (2026-09-09)


### Features

* **website:** add PowerShell Windows installer script ([9bbee6d](https://github.com/open-lingua/ielts-mastery-hub/commit/9bbee6deeee8b619d5493f5095e3919a709f1dcf))


### Documentation

* **website:** add Windows PowerShell installer instructions to install guide ([eda0f62](https://github.com/open-lingua/ielts-mastery-hub/commit/eda0f62086a48bd22d3883f43c59b1cd3cbbfb8b))

## [1.1.0-rc.2](https://github.com/open-lingua/ielts-mastery-hub/compare/1.0.1-rc.2...1.1.0-rc.2) (2026-09-09)


### Features

* **ci:** add MSI/WiX version overlay for Windows builds ([8f2cd82](https://github.com/open-lingua/ielts-mastery-hub/commit/8f2cd828ee70fbefbdcbeefdf424419b03aa4f86))
* **website:** add Unix installer script and fix sidebar position ([d3beb77](https://github.com/open-lingua/ielts-mastery-hub/commit/d3beb771eec957b1f8139bd106e9199df93ae1f3))


### Documentation

* document MSI/WiX version overlay and Windows build process ([4bd7785](https://github.com/open-lingua/ielts-mastery-hub/commit/4bd7785da8ad2e3ad9e3b91f510fb21198ec4314))
* **website:** add installing the app guide with Unix installer instructions ([a4e8fea](https://github.com/open-lingua/ielts-mastery-hub/commit/a4e8fea047d764722e9201f62254b16b2676025d))


### CI/CD

* sync MSI overlay and test scripts in release and CI workflows ([6b9c7db](https://github.com/open-lingua/ielts-mastery-hub/commit/6b9c7dbae7e025a5504741044335e4560ea57cd3))


### Chores

* **website:** switch to GitHub Pages URL and add docs site deploy instructions ([63d2daa](https://github.com/open-lingua/ielts-mastery-hub/commit/63d2daa00fb4049f904c2d5e8b81fce8158e9b53))

## [1.0.1-rc.2](https://github.com/open-lingua/ielts-mastery-hub/compare/1.0.0-rc.2...1.0.1-rc.2) (2026-09-09)


### Documentation

* **ci:** fix comment punctuation in release-please workflow ([755c637](https://github.com/open-lingua/ielts-mastery-hub/commit/755c637fca860ec7e3d8ace56d12ddbce768f3da))


### Chores

* clean up RELEASES.md and switch release-please versioning to default ([5c10d1a](https://github.com/open-lingua/ielts-mastery-hub/commit/5c10d1ac0ba529544355bf0681ab79fc528f4736))
* restore prerelease versioning strategy in release-please config ([37744d8](https://github.com/open-lingua/ielts-mastery-hub/commit/37744d8de09d98e498c58189a940bfebcd3a58a5))
* switch release-please versioning back to default ([c6d84df](https://github.com/open-lingua/ielts-mastery-hub/commit/c6d84df72711fde0943fcc6d35830e808ae7e0c6))

## [1.0.0-rc.2](https://github.com/open-lingua/ielts-mastery-hub/compare/1.0.0-rc.1...1.0.0-rc.2) (2026-09-09)

## [1.0.0-beta.23](https://github.com/open-lingua/ielts-mastery-hub/compare/1.0.0-beta.22...1.0.0-beta.23) (2026-09-09)


### Features

* **seeds:** add section audio for band 7 test 001 listening seed ([553af6e](https://github.com/open-lingua/ielts-mastery-hub/commit/553af6e27fddd91564ff0d3c31702d286f8668da))
* **seeds:** add section audio for band 8 test 002 listening seed ([c609ffc](https://github.com/open-lingua/ielts-mastery-hub/commit/c609ffc191f4c3500dce52b8e8bd596cad17092d))
* **seeds:** add section audio for band 9 test 001 listening seed ([4d949db](https://github.com/open-lingua/ielts-mastery-hub/commit/4d949dbec0dfac0c57b84c382031972aac43b90b))
* **seeds:** update TTS config for band 9 test 001 section 4 (LiDAR archaeology) ([37db498](https://github.com/open-lingua/ielts-mastery-hub/commit/37db4986824750d53409770829295659660fd83e))


### Chores

* **seeds:** remove band 6 test 001 listening seed and its assets ([89d2526](https://github.com/open-lingua/ielts-mastery-hub/commit/89d2526897a1064b3a45e2ea93220fa31e668810))

## [1.0.0-beta.22](https://github.com/open-lingua/ielts-mastery-hub/compare/1.0.0-beta.21...1.0.0-beta.22) (2026-09-08)


### Features

* **core:** backfill audio_url for listening sections when syncing seed assets ([e0d3d9c](https://github.com/open-lingua/ielts-mastery-hub/commit/e0d3d9cf8da6859ba8e95b9c5f7bd4e8148b4080))
* **seeds:** add band 7 listening seed with college enrollment & rec center tour test ([c00b188](https://github.com/open-lingua/ielts-mastery-hub/commit/c00b1882eca5469f2fe804e9c938847bdb6c69a6))
* **seeds:** add section 1-2 audio for listening test 4bb75c40 ([7091931](https://github.com/open-lingua/ielts-mastery-hub/commit/7091931bcb1c9d325089274ee8f0dab39383a822))
* **seeds:** add section 3-4 audio for listening test 4bb75c40 ([164f8ae](https://github.com/open-lingua/ielts-mastery-hub/commit/164f8ae702afb8aba35000c51eb0612c8aed4061))
* **seeds:** add TTS configs for band 7 test 001 listening seed ([0561d01](https://github.com/open-lingua/ielts-mastery-hub/commit/0561d0167e081250e067702aadbab88e49e86a9f))
* **seeds:** add TTS configs for band 8 test 002 listening seed ([93faaae](https://github.com/open-lingua/ielts-mastery-hub/commit/93faaae6c0c641f28ac7f7bb86efc54c24a02174))
* **seeds:** add TTS configs for band 9 test 001 listening seed ([e631243](https://github.com/open-lingua/ielts-mastery-hub/commit/e63124340b9ac4b55eaec086a32bb0706a633d50))
* **seeds:** replace band 8 test 002 listening seed with corporate retreat & sustainable library test ([0ff3b89](https://github.com/open-lingua/ielts-mastery-hub/commit/0ff3b89ff28dda1ae0bc98c905bb1f5b1d6e4564))
* **seeds:** replace band 9 listening seed with high-altitude logistics & urban agriculture test ([33927e1](https://github.com/open-lingua/ielts-mastery-hub/commit/33927e140f8b0446c9ce154771bddf32e6ca0eb9))


### Documentation

* **prompts:** add agent execution workflow and fix dialogue format in listening seed generator ([c326e2e](https://github.com/open-lingua/ielts-mastery-hub/commit/c326e2e346e9c9356cd05ee789c8aafd7a22ca59))
* **prompts:** add transcript generator prompts for listening sections 1-2 and 3-4 ([0305d01](https://github.com/open-lingua/ielts-mastery-hub/commit/0305d0133ab4720aa3f8d45128b2b89b4bca845a))
* **prompts:** clarify dialogue format and word count rules in listening seed generator ([587184b](https://github.com/open-lingua/ielts-mastery-hub/commit/587184be326bac6739113de8ec2914e046e5c393))
* **prompts:** update listening transcript generator prompts ([6154cfe](https://github.com/open-lingua/ielts-mastery-hub/commit/6154cfe850567d2409525b6f070d557abba72e2e))
* **prompts:** update listening transcript generator prompts ([a092438](https://github.com/open-lingua/ielts-mastery-hub/commit/a09243867effe6e8277160355d065fbaf1a10a07))
* **prompts:** update sections 1-2 transcript generator prompt ([1144fae](https://github.com/open-lingua/ielts-mastery-hub/commit/1144fae383a18a6222768c3932cca744b836488f))
* **prompts:** update transcript word count ranges for all listening sections ([72b4140](https://github.com/open-lingua/ielts-mastery-hub/commit/72b41403cc4387f2535535a03374e0a3ddb8f437))


### Chores

* **seeds:** remove outdated listening seed files and their associated TTS configs ([e6d5ae0](https://github.com/open-lingua/ielts-mastery-hub/commit/e6d5ae0afb606aff11523e3760ce214f0e452703))
* **seeds:** rename TTS config files from section-N-tts-config.json to section-N.json ([d53e3f4](https://github.com/open-lingua/ielts-mastery-hub/commit/d53e3f4323fe645e76de210b2bf97044d5423fb0))

## [1.0.0-beta.21](https://github.com/open-lingua/ielts-mastery-hub/compare/1.0.0-beta.20...1.0.0-beta.21) (2026-09-08)


### Features

* **core:** rename listening-tests to listening-assets with startup migration ([eeaea33](https://github.com/open-lingua/ielts-mastery-hub/commit/eeaea33e26b42dfea31a1846fdaa625ff624cb66))
* **core:** sync seed listening assets to local storage on app startup ([21ce576](https://github.com/open-lingua/ielts-mastery-hub/commit/21ce576d4d904471a32c5ef50c7fe5251611a451))


### Refactors

* **core:** replace listening_assets_migration with a shared LISTENING_ASSETS_DIR_NAME constant ([2b33024](https://github.com/open-lingua/ielts-mastery-hub/commit/2b33024953c896e3e6e64a1a01b7ffe98acf373f))


### Chores

* **seeds:** remove legacy tts-config flat directory ([22eb494](https://github.com/open-lingua/ielts-mastery-hub/commit/22eb49481289f4070be18ed0b0244dc75db8fc48))
* **seeds:** reorganize TTS configs into per-test UUID subdirectories ([83804e4](https://github.com/open-lingua/ielts-mastery-hub/commit/83804e48ccc89620282de30e6ba7c85f451463af))

## [1.0.0-beta.20](https://github.com/open-lingua/ielts-mastery-hub/compare/1.0.0-beta.19...1.0.0-beta.20) (2026-09-08)


### Features

* **core:** add writing_assets_migration module with sync logic and tests ([5155eb0](https://github.com/open-lingua/ielts-mastery-hub/commit/5155eb0dc875ca403789dfa03fc4e361b248d524))


### Refactors

* **core:** extract writing asset sync logic into database::writing_assets_migration module ([c14f80e](https://github.com/open-lingua/ielts-mastery-hub/commit/c14f80e12ba3d458b6339affdaacc96a33289cf2))
* **core:** store writing assets as &lt;task_id&gt;/figure.&lt;ext&gt; instead of &lt;task_id&gt;.&lt;ext&gt; ([e53d130](https://github.com/open-lingua/ielts-mastery-hub/commit/e53d130a386549b31bb64f71e0a628e81a5d8a84))
* **core:** use test id alone as listening audio folder name, drop title slug ([4f85522](https://github.com/open-lingua/ielts-mastery-hub/commit/4f855225dea0751bad487f295454217004586c9e))


### Chores

* rename database file from ielts.db to imh.db ([e4112ea](https://github.com/open-lingua/ielts-mastery-hub/commit/e4112ea26c287853f589b41fc4a8632e2f995050))

## [1.0.0-beta.19](https://github.com/open-lingua/ielts-mastery-hub/compare/1.0.0-beta.18...1.0.0-beta.19) (2026-09-08)


## [1.0.0-beta.18](https://github.com/open-lingua/ielts-mastery-hub/compare/1.0.0-beta.17...1.0.0-beta.18) (2026-09-07)


### Features

* persist figure_description across full stack for writing tasks ([4911bc1](https://github.com/open-lingua/ielts-mastery-hub/commit/4911bc17b9cd4a2deadfdf77d57b05ca0b7175b8))
* **seeds:** replace band 6 academic seed with university enrollment & free education test ([d293db8](https://github.com/open-lingua/ielts-mastery-hub/commit/d293db82fe43c354ef7e941ce935d46d819a2cb4))
* **seeds:** replace band 6.5 academic seed with water consumption & remote work test ([aea5add](https://github.com/open-lingua/ielts-mastery-hub/commit/aea5add0ed75186e035ab01ea44b588d9fb2db6e))
* **seeds:** replace band 7 academic seed with geothermal energy & space exploration test ([d30a51b](https://github.com/open-lingua/ielts-mastery-hub/commit/d30a51b2393d35b64ea17442aa33763fb3b6d319))
* **seeds:** replace band 7.5 academic seed with student enrollment & AI in professions test ([9bad2f2](https://github.com/open-lingua/ielts-mastery-hub/commit/9bad2f24e2e8d481531449ba85540ff65eb833f9))
* **seeds:** replace band 8 academic seed with government expenditure & family structures test ([0c23af7](https://github.com/open-lingua/ielts-mastery-hub/commit/0c23af7703be41d8d04811d86620646a01e29e4a))
* **seeds:** replace band 9 academic seed with global energy transition & cognitive delegation test ([5aa2d07](https://github.com/open-lingua/ielts-mastery-hub/commit/5aa2d071434343509281c4a57da5b2e86d49229e))
* **ui:** add Task 1 image upload to writing dataset import ([cf0d447](https://github.com/open-lingua/ielts-mastery-hub/commit/cf0d4479bec5dc21ea446d0353129f1bce158e7a))


### Refactors

* move test-001 TTS configs into per-test subfolder ([68a67ee](https://github.com/open-lingua/ielts-mastery-hub/commit/68a67ee1562a1db42d42265875f20a8195ed5057))


### Documentation

* **prompts:** add figure_description rules to DB seed generator prompt ([2a72840](https://github.com/open-lingua/ielts-mastery-hub/commit/2a72840c72ff3f9c55137338561c0e8d658dad75))

## [1.0.0-beta.17](https://github.com/open-lingua/ielts-mastery-hub/compare/1.0.0-beta.16...1.0.0-beta.17) (2026-08-31)


### Features

* **db:** add band 6.0 test 001 listening seed ([620c1d9](https://github.com/open-lingua/ielts-mastery-hub/commit/620c1d9a5e931831301280df31ec2d28860d18e4))
* **db:** add band 6.0 test 002 listening seed ([c143f84](https://github.com/open-lingua/ielts-mastery-hub/commit/c143f84d902a283ea760a5d64eb19746ebb0f9a3))
* **db:** add band 7.0 test 001 listening seed ([8a13dfd](https://github.com/open-lingua/ielts-mastery-hub/commit/8a13dfd4d16a476a6677a7704a1ebc4d4e85505c))
* **db:** add band 7.0 test 002 listening seed ([27f80c7](https://github.com/open-lingua/ielts-mastery-hub/commit/27f80c7ff7a083317f1deedab186046465a44bcf))
* **db:** add band 8.0 test 002 listening seed ([78632d3](https://github.com/open-lingua/ielts-mastery-hub/commit/78632d3e093a873da7862c6396f2811b25228923))
* **db:** add band 9.0 test 002 listening seed ([a591aaa](https://github.com/open-lingua/ielts-mastery-hub/commit/a591aaa20857bf049fe240314e0541d27304130c))
* **db:** update band 8.0 test 001 seed – freight shipping, airport layout, marine biology & supply chains ([c6bbbeb](https://github.com/open-lingua/ielts-mastery-hub/commit/c6bbbebd537db5e4bfb1af94ba990b434f03379b))
* **db:** update band 9.0 test 001 listening seed ([9e83d7e](https://github.com/open-lingua/ielts-mastery-hub/commit/9e83d7e7624c0c17e46c7b2693d412c15f47e039))


### Bug Fixes

* **ui:** rename invoke params to camelCase and add error logging to import pipeline ([dff027b](https://github.com/open-lingua/ielts-mastery-hub/commit/dff027b030756594a2f860364c3f06574d0c7f94))


### Documentation

* **prompts:** add transcript technical specs per section to DB seed generator ([3442064](https://github.com/open-lingua/ielts-mastery-hub/commit/34420644acb10b51891a9a6a46e62b01c66838e5))

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
- feat(core): enable asset protocol for ~/.imh
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
