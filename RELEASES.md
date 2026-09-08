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


### Features

* add .gitattributes file ([9923a6e](https://github.com/open-lingua/ielts-mastery-hub/commit/9923a6e54fb9b76b7d7f415aad2b55663668d792))
* add .gitattributes file ([7f4272d](https://github.com/open-lingua/ielts-mastery-hub/commit/7f4272d5d3cc1e65be2b978c67402e897a8688a5))
* add .gitattributes file part 2 ([3c32ce2](https://github.com/open-lingua/ielts-mastery-hub/commit/3c32ce23e3494b76817563978ddf73e70a25bd80))
* add .gitattributes file part 3 ([1568b75](https://github.com/open-lingua/ielts-mastery-hub/commit/1568b75adffa3e6a2930966cccb7e95287858bfc))
* add .gitattributes file part 4 ([1a83b9c](https://github.com/open-lingua/ielts-mastery-hub/commit/1a83b9c54bec8ca374af0813df0407018cab9f46))
* add Abort button and session abandonment flow to Writing, Reading, and Listening modules ([8b4308c](https://github.com/open-lingua/ielts-mastery-hub/commit/8b4308cf8dffc74e9946cb49da2b1b9afd25894f))
* Add comprehensive IELTS seed data for Reading, Listening ([d79650a](https://github.com/open-lingua/ielts-mastery-hub/commit/d79650a9ea1b5e92a105dbccac1f3f718f3eb8b7))
* Add comprehensive IELTS seed data for Reading, Listening part 2 ([a2ea938](https://github.com/open-lingua/ielts-mastery-hub/commit/a2ea938bf10e1fc6d9256461acfb24589fb1c931))
* Add comprehensive IELTS seed data for Reading, Listening part 3 ([55ace07](https://github.com/open-lingua/ielts-mastery-hub/commit/55ace07eb1ecf6aa407e37fd7e8db9d3d6304add))
* Add comprehensive IELTS seed data for Reading, Listening part 4 ([c60d217](https://github.com/open-lingua/ielts-mastery-hub/commit/c60d217ffd8dd7fc04b5a42f42ed164d41fc5541))
* Add comprehensive IELTS seed data for Reading, Listening part 4 ([d5bf2f6](https://github.com/open-lingua/ielts-mastery-hub/commit/d5bf2f6263a4269493608c2df5c47f078ad75cc0))
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
* add IELTS Mastery Hub icons ([cc07050](https://github.com/open-lingua/ielts-mastery-hub/commit/cc07050af362a38fdb9cb17d44bb7f1ba88a89ee))
* add ListeningQuestion structs to models ([3ac66bf](https://github.com/open-lingua/ielts-mastery-hub/commit/3ac66bf1e3e8b07bd05aecb7bedb9c6dba89929b))
* add ListeningQuestionGroup structs to models ([f205b31](https://github.com/open-lingua/ielts-mastery-hub/commit/f205b31837d113cc06c3c620f481541eef9d5bc0))
* add ListeningSection structs to models ([f09d7d2](https://github.com/open-lingua/ielts-mastery-hub/commit/f09d7d200e4aad6e641a4f3138582f8f10a7310d))
* add ListeningTest structs to models ([8c7b348](https://github.com/open-lingua/ielts-mastery-hub/commit/8c7b3484e9a94bdd6903703466eb6b68ade7816f))
* add local search plugin to docs site ([2aa22a3](https://github.com/open-lingua/ielts-mastery-hub/commit/2aa22a3d32779622fd53f945894336dc744d4ebd))
* add logo IMH ([d29ef30](https://github.com/open-lingua/ielts-mastery-hub/commit/d29ef309cb4bc001a441faf5627e4144743e7905))
* add PracticeTestRow/PracticeTestCard structs to models ([eb63657](https://github.com/open-lingua/ielts-mastery-hub/commit/eb636577078a8377e3a4b9bb63fcc79488c9ebbb))
* add Profile structs to models ([94cceae](https://github.com/open-lingua/ielts-mastery-hub/commit/94cceae85a5f55a08cb18849e201579a50fd4408))
* add ReadingPassage structs to models ([0f08b3c](https://github.com/open-lingua/ielts-mastery-hub/commit/0f08b3cd77f236c693773a923d9a4ee802ecb865))
* add ReadingQuestion structs to models ([9e6abaf](https://github.com/open-lingua/ielts-mastery-hub/commit/9e6abafc43f9d9a98192767653d861574bded427))
* add ReadingQuestionGroup structs to models ([5f1bde8](https://github.com/open-lingua/ielts-mastery-hub/commit/5f1bde88b35ca2b5b093ea393ef188228861a3f7))
* add ReadingTest structs to models ([a8a12a1](https://github.com/open-lingua/ielts-mastery-hub/commit/a8a12a1cfed0aa2b13c7c380547ded046e85f788))
* add UserRole structs to models ([457d8c1](https://github.com/open-lingua/ielts-mastery-hub/commit/457d8c1d1d4e8dd974aad2bbeae898163400439c))
* add UserTestSession structs to models ([49e4079](https://github.com/open-lingua/ielts-mastery-hub/commit/49e40795bc2f89aea8fcdb5f5bdb5b62f4e5bb32))
* add WritingTask structs to models ([ab1e5ca](https://github.com/open-lingua/ielts-mastery-hub/commit/ab1e5ca463b8a7cd69acd8ee96dd2ce576072cfa))
* add WritingTest structs to models ([4ea3990](https://github.com/open-lingua/ielts-mastery-hub/commit/4ea3990b917fda06d1676091fe67e7355dbb5974))
* **core:** add import JSON contract models for Reading/Writing/Listening ([6633aeb](https://github.com/open-lingua/ielts-mastery-hub/commit/6633aeb6c2268de49bc871886e9fa477c08272b0))
* **core:** add import Tauri commands (validate + import per test type) ([6fc6097](https://github.com/open-lingua/ielts-mastery-hub/commit/6fc60978cd44a3b3226dc4ebe583be6ed40b6386))
* **core:** add import validation and transactional insert service ([7060e7a](https://github.com/open-lingua/ielts-mastery-hub/commit/7060e7ade4bc36759219785a72dae39fc5f15970))
* **core:** add sqlx migrations with database/migrations structure ([40593b1](https://github.com/open-lingua/ielts-mastery-hub/commit/40593b170733a916415b18e418a278134f203692))
* **core:** add sqlx migrations with database/migrations structure ([7752174](https://github.com/open-lingua/ielts-mastery-hub/commit/7752174d1d5562f58d20e6bd73e2185d0c5370ca))
* **core:** add upload_writing_asset and upload_listening_audio commands ([45fdc4a](https://github.com/open-lingua/ielts-mastery-hub/commit/45fdc4ac4f4b3f76f1a528995f525e19a3816dc6))
* **core:** enable asset protocol for ~/.ielts-hub ([b88bab7](https://github.com/open-lingua/ielts-mastery-hub/commit/b88bab7af475e655da3efd4a8edcc59663bc4970))
* **core:** migrate database layer from rusqlite to sqlx with async repositories and Tauri commands ([db20134](https://github.com/open-lingua/ielts-mastery-hub/commit/db20134f90ac0aa939e7f43ddd63a878826bf884))
* **core:** migrate Supabase backend to local SQLite with Tauri 2 commands ([67b1754](https://github.com/open-lingua/ielts-mastery-hub/commit/67b1754529cca00394f9dad32370ac209cb7f9c8))
* **core:** migrate to sqlx built-in migration runner ([d3bef1a](https://github.com/open-lingua/ielts-mastery-hub/commit/d3bef1a85c1c9bbe2be77e748ef92ee9b1108a81))
* **core:** migrate to sqlx built-in migration runner part 2 ([feade4f](https://github.com/open-lingua/ielts-mastery-hub/commit/feade4f5238ef4ba8cf55a8d1ceb26fb0e950f44))
* **core:** register storage module ([f9b56db](https://github.com/open-lingua/ielts-mastery-hub/commit/f9b56db3b6709faa4aa8c3f93f52bf6115fc6508))
* **core:** sync seed writing assets to local storage on app startup ([a736c83](https://github.com/open-lingua/ielts-mastery-hub/commit/a736c83fffcea6c731a321a5b2e54cb5713b07db))
* **core:** thread client-supplied task id through storage, import, and repository ([4be142e](https://github.com/open-lingua/ielts-mastery-hub/commit/4be142e54856011d5f44653416bea2cc72ae7e48))
* **core:** wire import models/services modules and register import commands ([ffc1217](https://github.com/open-lingua/ielts-mastery-hub/commit/ffc12176d82abeb6d2f8735068c207673de0445a))
* **core:** wire storage commands into invoke handler ([179ed1d](https://github.com/open-lingua/ielts-mastery-hub/commit/179ed1d55528ae074abae1730bccf5028e36612a))
* **db:** add band 6.0 test 001 listening seed ([620c1d9](https://github.com/open-lingua/ielts-mastery-hub/commit/620c1d9a5e931831301280df31ec2d28860d18e4))
* **db:** add band 6.0 test 002 listening seed ([c143f84](https://github.com/open-lingua/ielts-mastery-hub/commit/c143f84d902a283ea760a5d64eb19746ebb0f9a3))
* **db:** add band 7.0 test 001 listening seed ([8a13dfd](https://github.com/open-lingua/ielts-mastery-hub/commit/8a13dfd4d16a476a6677a7704a1ebc4d4e85505c))
* **db:** add band 7.0 test 002 listening seed ([27f80c7](https://github.com/open-lingua/ielts-mastery-hub/commit/27f80c7ff7a083317f1deedab186046465a44bcf))
* **db:** add band 8.0 test 002 listening seed ([78632d3](https://github.com/open-lingua/ielts-mastery-hub/commit/78632d3e093a873da7862c6396f2811b25228923))
* **db:** add band 9.0 test 002 listening seed ([a591aaa](https://github.com/open-lingua/ielts-mastery-hub/commit/a591aaa20857bf049fe240314e0541d27304130c))
* **db:** update band 8.0 test 001 seed – freight shipping, airport layout, marine biology & supply chains ([c6bbbeb](https://github.com/open-lingua/ielts-mastery-hub/commit/c6bbbebd537db5e4bfb1af94ba990b434f03379b))
* **db:** update band 9.0 test 001 listening seed ([9e83d7e](https://github.com/open-lingua/ielts-mastery-hub/commit/9e83d7e7624c0c17e46c7b2693d412c15f47e039))
* display app version in sidebar with LTS update badge ([cf01419](https://github.com/open-lingua/ielts-mastery-hub/commit/cf01419ba84d9dde26acd016098b6d72cedc4f7d))
* persist figure_description across full stack for writing tasks ([4911bc1](https://github.com/open-lingua/ielts-mastery-hub/commit/4911bc17b9cd4a2deadfdf77d57b05ca0b7175b8))
* remove landing page and boot directly into dashboard ([b85458b](https://github.com/open-lingua/ielts-mastery-hub/commit/b85458b6927f8815c25f07343d6331bfeb15cd2d))
* remove settings in admin page ([4a3b23a](https://github.com/open-lingua/ielts-mastery-hub/commit/4a3b23afe43dc12dcc69464a325e2dfb8eb6b3d5))
* remove User Management feature from admin portal ([f361f21](https://github.com/open-lingua/ielts-mastery-hub/commit/f361f2129307954769036eab425fd5325d78ad3a))
* resolve DATABASE_URL from OS default paths at runtime ([afcee97](https://github.com/open-lingua/ielts-mastery-hub/commit/afcee971f4b5d547a19464026d84edd4b8912d71))
* run seeds automatically after migrations on DB init ([d9d258b](https://github.com/open-lingua/ielts-mastery-hub/commit/d9d258bf56958f49c05af74acce3c11057c2ed68))
* **seed:** Add IELTS Academic Reading Band 7.0 practice test seed 001 ([e1237c5](https://github.com/open-lingua/ielts-mastery-hub/commit/e1237c5a673cc861066dbb330fb04e54bd9bdc85))
* **seed:** Add IELTS Academic Reading Band 8 practice test seed ([bb7cb5f](https://github.com/open-lingua/ielts-mastery-hub/commit/bb7cb5f5b1a6e21b08b06bd1cf0a0c5d11f3cf3d))
* **seed:** Add IELTS Academic Reading Band 8 practice test seed ([add9327](https://github.com/open-lingua/ielts-mastery-hub/commit/add93274abf8706e6e9ea6ebfd3de256d985259d))
* **seed:** Add IELTS Academic Reading Band 9.0 practice test seed 001 ([2f76d01](https://github.com/open-lingua/ielts-mastery-hub/commit/2f76d01d4087bc1c08c4eb7f020949e927626fd4))
* **seed:** Add IELTS Academic Writing Band 6.0 practice test seed 001 ([90b39e4](https://github.com/open-lingua/ielts-mastery-hub/commit/90b39e42f42ad75fb26842d0e418ed4ec7f5aa83))
* **seed:** Add IELTS Academic Writing Band 6.5 practice test seed 001 ([c7b79e8](https://github.com/open-lingua/ielts-mastery-hub/commit/c7b79e8bedb3f36a91b5a7c8de7e118cf3ee4c6c))
* **seed:** Add IELTS Academic Writing Band 7.0 practice test seed 001 ([c05e82e](https://github.com/open-lingua/ielts-mastery-hub/commit/c05e82e83b48e1db30c915cd3c88bb60ab410012))
* **seed:** Add IELTS Academic Writing Band 7.5 practice test seed 001 ([93fbec8](https://github.com/open-lingua/ielts-mastery-hub/commit/93fbec84d43739ba1f834fa28704f872a0a2ddab))
* **seed:** Add IELTS Academic Writing Band 8 practice test seed ([8f3771c](https://github.com/open-lingua/ielts-mastery-hub/commit/8f3771ccbb8268535c2344fc14a9e6c579b51428))
* **seed:** Add IELTS Academic Writing Band 9.0 practice test seed 001 ([8e2058e](https://github.com/open-lingua/ielts-mastery-hub/commit/8e2058eaf5e92667f3f54b8e9cefb9ac7905d98b))
* **seed:** Add IELTS Listening Band 8 practice test seed 001 ([d1b6661](https://github.com/open-lingua/ielts-mastery-hub/commit/d1b66615f4c24da3fa360016183494f33dfb1c26))
* **seed:** Add IELTS Listening Band 9 practice test seed 001 ([003b694](https://github.com/open-lingua/ielts-mastery-hub/commit/003b69457794f84b274414bdea2ffd1daf3b9ec6))
* **seeds:** add Task 1 figure asset for band 6 academic seed ([ee2c91f](https://github.com/open-lingua/ielts-mastery-hub/commit/ee2c91f8d071e4f504b8708a693b847fa0d28325))
* **seeds:** add Task 1 figure asset for band 6.5 academic seed ([f36b85b](https://github.com/open-lingua/ielts-mastery-hub/commit/f36b85b1b6b8247e2f6f82ec0a9883dc3467a9a0))
* **seeds:** add Task 1 figure asset for band 7 academic seed ([cbac5b9](https://github.com/open-lingua/ielts-mastery-hub/commit/cbac5b9eb8941a8dc5e79bacfb5fdaea2090a552))
* **seeds:** add Task 1 figure asset for band 7.5 academic seed ([cf25c65](https://github.com/open-lingua/ielts-mastery-hub/commit/cf25c6595ccb4b9f0ff3604bdfcc8035c1c002ce))
* **seeds:** add Task 1 figure asset for band 8 academic seed ([b19b7b7](https://github.com/open-lingua/ielts-mastery-hub/commit/b19b7b7e8696f7c15f0cfd211218676964a326a6))
* **seeds:** add Task 1 figure asset for band 9 academic seed ([13ceba0](https://github.com/open-lingua/ielts-mastery-hub/commit/13ceba0a704853d30d7f7b90e736c36d93b9951b))
* **seeds:** replace band 6 academic seed with university enrollment & free education test ([d293db8](https://github.com/open-lingua/ielts-mastery-hub/commit/d293db82fe43c354ef7e941ce935d46d819a2cb4))
* **seeds:** replace band 6.5 academic seed with water consumption & remote work test ([aea5add](https://github.com/open-lingua/ielts-mastery-hub/commit/aea5add0ed75186e035ab01ea44b588d9fb2db6e))
* **seeds:** replace band 7 academic seed with geothermal energy & space exploration test ([d30a51b](https://github.com/open-lingua/ielts-mastery-hub/commit/d30a51b2393d35b64ea17442aa33763fb3b6d319))
* **seeds:** replace band 7.5 academic seed with student enrollment & AI in professions test ([9bad2f2](https://github.com/open-lingua/ielts-mastery-hub/commit/9bad2f24e2e8d481531449ba85540ff65eb833f9))
* **seeds:** replace band 8 academic seed with government expenditure & family structures test ([0c23af7](https://github.com/open-lingua/ielts-mastery-hub/commit/0c23af7703be41d8d04811d86620646a01e29e4a))
* **seeds:** replace band 9 academic seed with global energy transition & cognitive delegation test ([5aa2d07](https://github.com/open-lingua/ielts-mastery-hub/commit/5aa2d071434343509281c4a57da5b2e86d49229e))
* **test-library:** add Unresolved filter to show incomplete tests ([09deff6](https://github.com/open-lingua/ielts-mastery-hub/commit/09deff6712781a773dd820c832e81d9dc8ddd4a7))
* **ui:** add Admin Import Dataset page ([0f43495](https://github.com/open-lingua/ielts-mastery-hub/commit/0f434950a4c2cae4c52758cffc169170bc92d236))
* **ui:** add client-side import parsing and validation helpers ([0173868](https://github.com/open-lingua/ielts-mastery-hub/commit/0173868838a17452cf6c5eb1639dda6600960c84))
* **ui:** add Import Dataset item to admin sidebar nav ([23cb14d](https://github.com/open-lingua/ielts-mastery-hub/commit/23cb14dca1e3807b1e7c3860e00f8680eb5b07a0))
* **ui:** add Task 1 image upload to writing dataset import ([cf0d447](https://github.com/open-lingua/ielts-mastery-hub/commit/cf0d4479bec5dc21ea446d0353129f1bce158e7a))
* **ui:** add typed import invoke wrappers and toPlayableUrl helper ([1253989](https://github.com/open-lingua/ielts-mastery-hub/commit/125398961f0528b7aa96d2d6f2978da6aa75b492))
* **ui:** add uploadWritingAsset and uploadListeningAudio typed wrappers ([f3a87fe](https://github.com/open-lingua/ielts-mastery-hub/commit/f3a87fec60a17cd7bf35cdc1bf625bf2721879d4))
* **ui:** generate and propagate task id before writing asset upload ([60cebad](https://github.com/open-lingua/ielts-mastery-hub/commit/60cebad85a57e646c23d8bf7245b27568f8e3057))
* **ui:** route /admin/import to ImportDataset page ([ba1881f](https://github.com/open-lingua/ielts-mastery-hub/commit/ba1881f6f74b4ce4c9b4c5b723e4430674149c1c))
* update 'upgrade now' link ([7c7a8fa](https://github.com/open-lingua/ielts-mastery-hub/commit/7c7a8fa8a4f98f4ca746f5c8940e680470dcbe85))
* update brand in pricing component ([fa79315](https://github.com/open-lingua/ielts-mastery-hub/commit/fa793157941f482164f3c11616794e42545b81dd))
* Update seed UUIDs for IELTS practice test ([70ea2ba](https://github.com/open-lingua/ielts-mastery-hub/commit/70ea2ba907bec3e15dd5fb0eb318f66746e45bf5))
* Update seed UUIDs for IELTS practice test ([39e6f2d](https://github.com/open-lingua/ielts-mastery-hub/commit/39e6f2de80441c5f7dab72c517e1585357598325))
* Update seed UUIDs for IELTS practice test ([abe65d1](https://github.com/open-lingua/ielts-mastery-hub/commit/abe65d1983c5cc9bce8eeefab04e68b7a3e1d41f))
* Update seed UUIDs for IELTS practice test ([a26b76f](https://github.com/open-lingua/ielts-mastery-hub/commit/a26b76f0ece72a0f7c7c0ef1a96f4c29219739f9))
* **website:** add HomepageSections components and hooks for landing page ([9a4e931](https://github.com/open-lingua/ielts-mastery-hub/commit/9a4e9312fae0d72bffb43824588fc8553036b915))
* **website:** replace default homepage with IELTS landing page sections ([3c6ecc3](https://github.com/open-lingua/ielts-mastery-hub/commit/3c6ecc3f08a2200735fb274ef6f86ac6b5e6e719))


### Bug Fixes

* add explicit type=button to button elements ([897ec0f](https://github.com/open-lingua/ielts-mastery-hub/commit/897ec0f9c6683ab3cdf104f3d7a98e838cc89522))
* Add global error boundary and unhandled error display for easier debugging ([8fa27fd](https://github.com/open-lingua/ielts-mastery-hub/commit/8fa27fd9855dfee7e3cbd23a26063ec2317ca6fa))
* **biome:** resolve lint errors from Biome migration ([016a085](https://github.com/open-lingua/ielts-mastery-hub/commit/016a085daa4d51a56816d6a55e6638994fb2bf12))
* **core:** store asset:// URL in image_url instead of raw file path ([a9afd07](https://github.com/open-lingua/ielts-mastery-hub/commit/a9afd071780a723e9beb0f906fa2815458282b5f))
* Fix pagination not advancing pages due to unstable setSearchParams dependency ([198f7d6](https://github.com/open-lingua/ielts-mastery-hub/commit/198f7d6aa81e2fd3187397302651b15a23201abb))
* fix unresolved filter with newest and oldest filter ([d790e42](https://github.com/open-lingua/ielts-mastery-hub/commit/d790e42617cb178b5a85d7c6aea6d27b3fa26a57))
* **navigation:** redirect Writing, Reading and Listening nav links to Test Library with tab filter ([e165567](https://github.com/open-lingua/ielts-mastery-hub/commit/e16556736418e3fdcf89d93a8679410c33c3ad94))
* pass camelCase userId to Tauri 2 IPC commands ([aaba981](https://github.com/open-lingua/ielts-mastery-hub/commit/aaba981230654f4e9ee5cdcbbef7f70d7287e6f9))
* postcss and tailwind ([e9f0370](https://github.com/open-lingua/ielts-mastery-hub/commit/e9f0370143465dafdff95bc0b05d831accbf9bbe))
* remove loadContent from effect deps to prevent infinite fetch loop ([590e48b](https://github.com/open-lingua/ielts-mastery-hub/commit/590e48b264f2bf4096873456e1857a0d2d2f1f25))
* repair broken tests ([ce60577](https://github.com/open-lingua/ielts-mastery-hub/commit/ce60577357badc27514fb30fb103aaee22268b06))
* resolve duplicate UUIDs and broken FK references in seed files ([6b0bd68](https://github.com/open-lingua/ielts-mastery-hub/commit/6b0bd68fb412dc515ce6ff2cc33fa2f9828adef2))
* resolve Vite 8.x __SERVER_FORWARD_CONSOLE__ undefined and CSS 500 error in Tauri 2 WebKit ([9b8c506](https://github.com/open-lingua/ielts-mastery-hub/commit/9b8c506c726c813506516ad555f274edbc5d4bbd))
* resolve vitest setup path after src/ui restructure ([9d51353](https://github.com/open-lingua/ielts-mastery-hub/commit/9d5135374a4de13dd59fd54a895b62b1766d1223))
* set crossorigin to 'anonymous' on fonts.gstatic.com preconnect tag ([950720f](https://github.com/open-lingua/ielts-mastery-hub/commit/950720f2997ec5a6533f8b0cfea0ff831bf2437b))
* sync tauri.conf.json version with Cargo.toml ([895a7f7](https://github.com/open-lingua/ielts-mastery-hub/commit/895a7f7cce80c8a59b6705e7eb8641f311b632b0))
* **test:** replace ResizeObserver mock with class implementation in CountryPicker test ([69b0f33](https://github.com/open-lingua/ielts-mastery-hub/commit/69b0f337ed804d31e013aeb95ba8724ee7af0a79))
* **ui:** convert stored audio_url to a playable URL in listeningPracticeService ([e4fd431](https://github.com/open-lingua/ielts-mastery-hub/commit/e4fd4311d2208a5923a2f7e7c86e0c7d1e9ceae9))
* **ui:** convert stored audio_url to a playable URL in listeningService ([b16b43e](https://github.com/open-lingua/ielts-mastery-hub/commit/b16b43ef614c6d3d16c20f9a097eac6a09e06b20))
* **ui:** Fix env file resolution to load from project root in Vite config ([58d311b](https://github.com/open-lingua/ielts-mastery-hub/commit/58d311b85cf3143838ff0b1fbb1e2d45d815e45d))
* **ui:** rename invoke params to camelCase and add error logging to import pipeline ([dff027b](https://github.com/open-lingua/ielts-mastery-hub/commit/dff027b030756594a2f860364c3f06574d0c7f94))


### Refactors

* **admin:** simplify AdminDashboard and UserManagement pages ([e8d9c82](https://github.com/open-lingua/ielts-mastery-hub/commit/e8d9c82ca856c44e1bfbe29b1d77bb7e0e4544cb))
* **core:** reorganize db module and consolidate migrations ([97875c9](https://github.com/open-lingua/ielts-mastery-hub/commit/97875c9d2d04323e981bca7ba341026a89c5afcb))
* **dashboard:** simplify BandScoreChart component ([a284276](https://github.com/open-lingua/ielts-mastery-hub/commit/a2842766477fbec5cf4f10c0b073fc0d2ca31142))
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
* move React source to src/ui in preparation for Tauri 2 integration ([8283799](https://github.com/open-lingua/ielts-mastery-hub/commit/82837998fb11caf5d1758b9ff1da4ea88c384750))
* move test-001 TTS configs into per-test subfolder ([68a67ee](https://github.com/open-lingua/ielts-mastery-hub/commit/68a67ee1562a1db42d42265875f20a8195ed5057))
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


### Documentation

* add admin docs ([65f8997](https://github.com/open-lingua/ielts-mastery-hub/commit/65f899788015fb1691fcba4df5328cdfc4a978e6))
* add admin portal user guides (overview, creating tests, content library, import/export, students) ([12e0efc](https://github.com/open-lingua/ielts-mastery-hub/commit/12e0efc769d52d5d27fc9d0c3a2c09dd5ad63f57))
* add api-reference docs ([14846cb](https://github.com/open-lingua/ielts-mastery-hub/commit/14846cb2ca82c13ccba452c1a3a745077d943579))
* add architecture docs ([c0df190](https://github.com/open-lingua/ielts-mastery-hub/commit/c0df190f903f94204140a164c462eca83dcae01d))
* add backend architecture reference ([a4b0eed](https://github.com/open-lingua/ielts-mastery-hub/commit/a4b0eedbebce15a0ed8f01b16e43016f7d010eee))
* add CODE_OF_CONDUCT ([b17eee7](https://github.com/open-lingua/ielts-mastery-hub/commit/b17eee7addee1679bf9911df2e8eae9ddb02fa68))
* Add comprehensive README.md ([c767fbb](https://github.com/open-lingua/ielts-mastery-hub/commit/c767fbb65cd3cd72b4380a267e445450a566a69d))
* Add comprehensive README.md ([072e8e2](https://github.com/open-lingua/ielts-mastery-hub/commit/072e8e23069922ac5f91e880af5eaa401acab0ff))
* Add comprehensive README.md ([48b6a97](https://github.com/open-lingua/ielts-mastery-hub/commit/48b6a97f34795fc76035865338aede8b272f2f5a))
* add contributing docs ([861ba0d](https://github.com/open-lingua/ielts-mastery-hub/commit/861ba0dd8206ca875c68917776d6d3364fbba6f9))
* add CONTRIBUTING guide ([81cde62](https://github.com/open-lingua/ielts-mastery-hub/commit/81cde6287c6a1a90d8e22b0b0fdbcf611f1a45ff))
* Add CONTRIBUTING.md with setup, workflow, and PR guidelines ([7c71656](https://github.com/open-lingua/ielts-mastery-hub/commit/7c71656ba2a0680ac6925d079a8e11b3a751c356))
* add DATABASE_URL export to quick start setup ([1a5d1c3](https://github.com/open-lingua/ielts-mastery-hub/commit/1a5d1c3755f4cc016dd134184f44e09f67d074ed))
* add DATABASE_URL setup instructions for sqlx CLI across platforms ([83bf008](https://github.com/open-lingua/ielts-mastery-hub/commit/83bf008472aaffa85e3d818e47dbf5294c9aad2f))
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
* add platform badge to README ([911acfa](https://github.com/open-lingua/ielts-mastery-hub/commit/911acfa7f839486576c16f49bceafedef6b0fe7f))
* add practicing user guides (practice library, reading, listening, writing, exam simulation) ([091dcdc](https://github.com/open-lingua/ielts-mastery-hub/commit/091dcdc73a5245cbf9b006575b6ba2eb3e5f0438))
* add product docs ([7461ee0](https://github.com/open-lingua/ielts-mastery-hub/commit/7461ee0c95ade52c343f6e7d7d00ae2e1dcb57fe))
* add PRODUCT.md documentation ([ff35c4b](https://github.com/open-lingua/ielts-mastery-hub/commit/ff35c4b58d749a4ab5f0557a3f3cb31b9355cf1d))
* add project banner image to README ([bc5dd81](https://github.com/open-lingua/ielts-mastery-hub/commit/bc5dd819c7e537db3031017391cdab734b2f5292))
* add project README ([ce1b251](https://github.com/open-lingua/ielts-mastery-hub/commit/ce1b25141f0c108642007c7f0af260c3c7cf23f7))
* add reference docs ([56dbaa1](https://github.com/open-lingua/ielts-mastery-hub/commit/56dbaa111dbad30e46090f4495d03bc70fe82d99))
* add Technical Docs sidebar category for internals ([53df71d](https://github.com/open-lingua/ielts-mastery-hub/commit/53df71d7e18f1d993d885eb3a3941ed835f489d4))
* add testing docs ([d9a03d0](https://github.com/open-lingua/ielts-mastery-hub/commit/d9a03d0aa153752f3bba8231985f509dab7527b1))
* add tracking-progress user guides (dashboard, band score) ([27174f4](https://github.com/open-lingua/ielts-mastery-hub/commit/27174f4bf62286521b377c859856549bd15b8cdd))
* add Usage Guides sidebar category for guides ([2c7a484](https://github.com/open-lingua/ielts-mastery-hub/commit/2c7a484d37a29d73db566df3d441240a77317855))
* **admin:** add spec for dataset import feature ([e1611b5](https://github.com/open-lingua/ielts-mastery-hub/commit/e1611b5b338b50929bb7c948b9ca93051e439ddd))
* automate release process with release-please ([1ff96d3](https://github.com/open-lingua/ielts-mastery-hub/commit/1ff96d3ee332bebd03d14123feafd4462aac64a6))
* change license badge color to yellow ([c8e66d4](https://github.com/open-lingua/ielts-mastery-hub/commit/c8e66d48c1b8e9740167168dad3355c22170aec0))
* clarify app is desktop-native in description ([0c4ce2a](https://github.com/open-lingua/ielts-mastery-hub/commit/0c4ce2ae6d3714cc407a6e92f0f16674c9e2a39f))
* consolidate DATABASE_URL setup instructions into backend_architecture.md ([9be70d0](https://github.com/open-lingua/ielts-mastery-hub/commit/9be70d0ba81e9c2432ec43d6029e979dfb827bcd))
* **core:** add README with dev workflow and migration guide ([f6639d6](https://github.com/open-lingua/ielts-mastery-hub/commit/f6639d68bb1b8a1a9299a2f7a24e04af0774d31a))
* **core:** move testing conventions into docs/core/testing/ ([fc8a753](https://github.com/open-lingua/ielts-mastery-hub/commit/fc8a7534ab70cd298064d3b8fe9602d062ca3acd))
* disable sidebar autoCollapseCategories to keep both sections open ([51e73ed](https://github.com/open-lingua/ielts-mastery-hub/commit/51e73ed23633926aa25ee513d1bc207857643997))
* expand Technical Docs sidebar category by default ([5224358](https://github.com/open-lingua/ielts-mastery-hub/commit/52243588e07142f447ef6bc5373f188173b09611))
* expand Usage Guides sidebar category by default ([090c8ad](https://github.com/open-lingua/ielts-mastery-hub/commit/090c8adc428dc970135b35e953f8770cc9e11185))
* fix broken relative links in intro.mdx to point into internals/ ([2f939b6](https://github.com/open-lingua/ielts-mastery-hub/commit/2f939b62d459a04f3e20e672d55c379da53ca386))
* fix bundle identifier mismatch in database reset guide ([02fc50e](https://github.com/open-lingua/ielts-mastery-hub/commit/02fc50ef1c589abc702f6725d29a2fd9e2de3f24))
* move seed generator prompts to docs/prompts/ ([743eb2c](https://github.com/open-lingua/ielts-mastery-hub/commit/743eb2c5622056d9b583ffd39ddda01924296137))
* pin Tauri@2 and React@19 versions in tech stack ([f965be1](https://github.com/open-lingua/ielts-mastery-hub/commit/f965be1910d47a48e255154c60e1b1f4fdd43a20))
* **prompts:** add figure_description rules to DB seed generator prompt ([2a72840](https://github.com/open-lingua/ielts-mastery-hub/commit/2a72840c72ff3f9c55137338561c0e8d658dad75))
* **prompts:** Add IELTS listening database seed generator ([6c82b22](https://github.com/open-lingua/ielts-mastery-hub/commit/6c82b22a9a838780081778ec8554e9727f9bf642))
* **prompts:** Add IELTS reading database seed generator ([c9e01e9](https://github.com/open-lingua/ielts-mastery-hub/commit/c9e01e931e1d5e086279b18f1d6f98b910a7e140))
* **prompts:** Add IELTS writing database seed generator ([880822e](https://github.com/open-lingua/ielts-mastery-hub/commit/880822eeb817dac8df1a38b50d7119c518b63462))
* **prompts:** add transcript technical specs per section to DB seed generator ([3442064](https://github.com/open-lingua/ielts-mastery-hub/commit/34420644acb10b51891a9a6a46e62b01c66838e5))
* remove unused info in intro ([b370682](https://github.com/open-lingua/ielts-mastery-hub/commit/b3706828f97d3167dc6a007cdd85095ca4ab5302))
* rename AGENTS.md header from Project Context to Agent Context ([d544eb9](https://github.com/open-lingua/ielts-mastery-hub/commit/d544eb90a9fe85b547b83975ee69987b22f93da9))
* rename files to lowercase ([887d843](https://github.com/open-lingua/ielts-mastery-hub/commit/887d8436ce3e252e130c4fbbb0dbd3128b871307))
* rename files to lowercase ([98cba30](https://github.com/open-lingua/ielts-mastery-hub/commit/98cba30c92ef3e71243ff9f67647c4584f563864))
* reorganize all docs under internals/ subdirectory ([81d5f2a](https://github.com/open-lingua/ielts-mastery-hub/commit/81d5f2a5571ff9355fb8c00ad85ff3d939ac9824))
* **testing:** add unit testing conventions for core module ([9cf1db7](https://github.com/open-lingua/ielts-mastery-hub/commit/9cf1db7347e99cafd87e47179c424827f28e5b6b))
* update README title to @open-lingua/ielts-mastery-hub ([9c8a90b](https://github.com/open-lingua/ielts-mastery-hub/commit/9c8a90bd4db53397b7da76d867b747afbffa8c70))
* update storage and import docs to reflect task-id-based asset naming ([6b013e8](https://github.com/open-lingua/ielts-mastery-hub/commit/6b013e88240bb3f7a936e40526c2dc3e0fe1f45d))


### CI/CD

* add clippy lint step to backend job ([860a30f](https://github.com/open-lingua/ielts-mastery-hub/commit/860a30fbecbbb39c8e87360fce53e24b5b20b992))
* add cross-platform release workflow for macOS, Linux, and Windows ([de7bee9](https://github.com/open-lingua/ielts-mastery-hub/commit/de7bee9a189a287f106748a2ee75ad2d91bc2e31))
* add frontend lint step and simplify job names ([6fb8074](https://github.com/open-lingua/ielts-mastery-hub/commit/6fb80749b7a06ecd99601101240b5a30f7c6020c))
* add Rust/Tauri test job to CI workflow ([dd90ca9](https://github.com/open-lingua/ielts-mastery-hub/commit/dd90ca9977a029401abc4060a128f48b2c624be8))
* enable release workflow trigger and permissions ([2986849](https://github.com/open-lingua/ielts-mastery-hub/commit/298684909ab1cd978fd53797f4475a04b41c8b15))
* fallback to GITHUB_TOKEN when RELEASE_PLEASE_TOKEN is unset ([cf99b7d](https://github.com/open-lingua/ielts-mastery-hub/commit/cf99b7d8dbc77aec75144262a61422aecc95e9c0))
* optimize backend job with sqlx offline mode and stable cargo cache ([3d9f7c0](https://github.com/open-lingua/ielts-mastery-hub/commit/3d9f7c0cf4f778e700e7735abd35abf20d5843cb))
* optimize Rust cache and apt install on Linux ([ea54fc2](https://github.com/open-lingua/ielts-mastery-hub/commit/ea54fc2642d8434424556e3206f7458651189a8d))
* rename ci.yml to ci-linux.yml ([ce556d5](https://github.com/open-lingua/ielts-mastery-hub/commit/ce556d5c8b40d5d2334ef9e333ef35698d075d33))
* replace SQLX_OFFLINE with DATABASE_URL for clippy and build steps ([2146e06](https://github.com/open-lingua/ielts-mastery-hub/commit/2146e061d2f92da26aabfc1efb531e086aca6b93))


### Tests

* **core:** add shared test fixtures and data builders for src/core tests ([6f0f6d7](https://github.com/open-lingua/ielts-mastery-hub/commit/6f0f6d725283a2fcd5a7eb972cb7691000725797))
* **core:** add unit tests for src/core models ([bd26c60](https://github.com/open-lingua/ielts-mastery-hub/commit/bd26c60fdf41d72cee359670a3fb7fe1abd27e93))
* **core:** add unit tests for src/core repositories ([b816034](https://github.com/open-lingua/ielts-mastery-hub/commit/b816034a8b8501230b1469bcb5502d22da87a9dc))
* **core:** add unit tests for src/core root-level error handling ([73f7e9d](https://github.com/open-lingua/ielts-mastery-hub/commit/73f7e9db539b46b411615ebd29f272df6288b16d))
* **core:** add unit tests for src/core services ([e3bd2ff](https://github.com/open-lingua/ielts-mastery-hub/commit/e3bd2ff4c843651d00cf2593da2b5372873fbe03))
* **core:** wire up integration test entry point for src/core tests ([49965db](https://github.com/open-lingua/ielts-mastery-hub/commit/49965db1344ae8486ae2b6621c5649c7d1e4528b))
* **ui:** assert Import Dataset nav item renders in AdminLayout ([6ac8a9d](https://github.com/open-lingua/ielts-mastery-hub/commit/6ac8a9d77499d990f09431fc854e705b22755cd5))


### Chores

* add 1.0.0-beta.1 release notes to RELEASES.md ([9f5382e](https://github.com/open-lingua/ielts-mastery-hub/commit/9f5382eb901bec073555aee8de025130d3123c46))
* add bug report issue template ([4e978b5](https://github.com/open-lingua/ielts-mastery-hub/commit/4e978b54f894894eb95944abd9fceaf2a5321581))
* Add CI workflow for frontend tests and build ([a328796](https://github.com/open-lingua/ielts-mastery-hub/commit/a328796461c635bc58ecd25e563bbdc0923bb8cb))
* add CLAUDE.md and AGENTS.md configuration files for AI assistants ([4bcfc28](https://github.com/open-lingua/ielts-mastery-hub/commit/4bcfc287246d534c50c46aab9e5b2b6184f1b82e))
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
* **core:** add dev-dependencies required for src/core test suite ([8d64e40](https://github.com/open-lingua/ielts-mastery-hub/commit/8d64e4013d1bcf4be8d4ce0750225c0e216729e8))
* **core:** register import command module ([a2442b8](https://github.com/open-lingua/ielts-mastery-hub/commit/a2442b8169fffe2a8297900dea4145af05789c8a))
* **deps:** bump @radix-ui/react-context-menu from 2.2.15 to 2.2.16 ([#6](https://github.com/open-lingua/ielts-mastery-hub/issues/6)) ([1c885ae](https://github.com/open-lingua/ielts-mastery-hub/commit/1c885ae1737890928d73f4f527bdb84f5e874b89))
* **deps:** bump @radix-ui/react-menubar from 1.1.15 to 1.1.16 ([#5](https://github.com/open-lingua/ielts-mastery-hub/issues/5)) ([aa0c69d](https://github.com/open-lingua/ielts-mastery-hub/commit/aa0c69da07f4c68301c5aeeb799c9721f6c43d26))
* **deps:** bump @tanstack/react-query from 5.83.0 to 5.90.21 ([b8b4ca5](https://github.com/open-lingua/ielts-mastery-hub/commit/b8b4ca59edbe71ff3137b30e1982e7610bf7af4c))
* **deps:** bump @tanstack/react-query from 5.83.0 to 5.90.21 ([b8b4ca5](https://github.com/open-lingua/ielts-mastery-hub/commit/b8b4ca59edbe71ff3137b30e1982e7610bf7af4c))
* downgrade typescript to 5.8.3 and clean up lockfile ([9421ee9](https://github.com/open-lingua/ielts-mastery-hub/commit/9421ee94ea2b9d90918cee6175e750d6e7578a82))
* downgrade typescript to 6.0.3 for typescript-eslint compatibility ([c7600d4](https://github.com/open-lingua/ielts-mastery-hub/commit/c7600d4d2c565e42beaa6ebc7128313b776d1bc9))
* **main:** release 1.0.0-beta.14 ([#24](https://github.com/open-lingua/ielts-mastery-hub/issues/24)) ([2229eaf](https://github.com/open-lingua/ielts-mastery-hub/commit/2229eaff9014a0995b086d61751210d5fd90905a))
* **main:** release 1.0.0-beta.15 ([#25](https://github.com/open-lingua/ielts-mastery-hub/issues/25)) ([fed9cae](https://github.com/open-lingua/ielts-mastery-hub/commit/fed9cae0d293ac8455b316b3ec0199233ac49a24))
* **main:** release 1.0.0-beta.16 ([#26](https://github.com/open-lingua/ielts-mastery-hub/issues/26)) ([69a2afc](https://github.com/open-lingua/ielts-mastery-hub/commit/69a2afc81f56aa2c11b3dcb9c97e3a8f5529aec6))
* **main:** release 1.0.0-beta.17 ([#28](https://github.com/open-lingua/ielts-mastery-hub/issues/28)) ([34b3efe](https://github.com/open-lingua/ielts-mastery-hub/commit/34b3efe76a0d818d3b2e1bdde3e1cba1c47e11ae))
* **main:** release 1.0.0-beta.18 ([#36](https://github.com/open-lingua/ielts-mastery-hub/issues/36)) ([8f0f2b6](https://github.com/open-lingua/ielts-mastery-hub/commit/8f0f2b63e8d3e9fe8174663aee9d67a63fbdd8a9))
* mark .mdx files as documentation in gitattributes ([604a5ff](https://github.com/open-lingua/ielts-mastery-hub/commit/604a5ff602a90fd2cc8b9812e54cced0ced8879f))
* mark release-please config as prerelease ([64743fc](https://github.com/open-lingua/ielts-mastery-hub/commit/64743fcf97c9cc555b2f98ec67765ad9874fa765))
* mark scripts directory as linguist-generated ([faea49a](https://github.com/open-lingua/ielts-mastery-hub/commit/faea49a2f7488574bce6bb5f2d53d0a9a961d9ea))
* mark website docs and blog as documentation in gitattributes ([42dffdf](https://github.com/open-lingua/ielts-mastery-hub/commit/42dffdf9658f1e2fefe84e678e8f38efb918554d))
* migrate from ESLint to Biome for linting and formatting ([3798a24](https://github.com/open-lingua/ielts-mastery-hub/commit/3798a24de61c7508d6811da699a8a10fecbb24b5))
* **prompts:** enforce UUID inventory for reading seed generator ([7b08699](https://github.com/open-lingua/ielts-mastery-hub/commit/7b086997e83f75cb25bd37934cf69831fe498f69))
* reformat check-version-consistency.mjs to 2-space indent ([37dca10](https://github.com/open-lingua/ielts-mastery-hub/commit/37dca1018601a8711d9f980bbbd9d6c722c0bea4))
* release 1.0.0-beta.9 ([063bc77](https://github.com/open-lingua/ielts-mastery-hub/commit/063bc779090439469abf57ef3aebf70fe7bb7d08))
* release v1.0.0-beta.10 ([3d1a20a](https://github.com/open-lingua/ielts-mastery-hub/commit/3d1a20af2ec13b93dd6e02e6fe72ff1c709724ef))
* release v1.0.0-beta.11 ([98628f1](https://github.com/open-lingua/ielts-mastery-hub/commit/98628f13c843790ad3379256f566807f6d883850))
* **release:** bump version to 1.0.0-beta.3 and add changelog entry ([b7d37c8](https://github.com/open-lingua/ielts-mastery-hub/commit/b7d37c8b5656c8049201f683dbb454e3c44a35bc))
* **release:** bump version to 1.0.0-beta.4 and add changelog entry ([11430ee](https://github.com/open-lingua/ielts-mastery-hub/commit/11430ee04bd6e58056499bd0cbc0b767e259aac0))
* **release:** bump version to 1.0.0-beta.5 and add changelog entry ([0c61fd9](https://github.com/open-lingua/ielts-mastery-hub/commit/0c61fd9f5d30b1110de4f3bbe35e2f9f90dd7fa4))
* **release:** bump version to 1.0.0-beta.6 ([767e4d4](https://github.com/open-lingua/ielts-mastery-hub/commit/767e4d41e26772fa2b8faa70b741bae8a79d6bb7))
* **release:** bump version to 1.0.0-beta.7 ([5367179](https://github.com/open-lingua/ielts-mastery-hub/commit/5367179e5e56dadc3f3194e0280c05716039d4a3))
* remove .env from tracking and add env files to .gitignore ([b0e97e8](https://github.com/open-lingua/ielts-mastery-hub/commit/b0e97e8f1059d5a1cfa1b18bc80eba0c622e6fe4))
* Remove auth layer and replace with anonymous ID for guest-first, no-login experience ([b87309f](https://github.com/open-lingua/ielts-mastery-hub/commit/b87309f351eee525331b32b7f23af865404c9b37))
* remove dev.db from tracking ([becc4b1](https://github.com/open-lingua/ielts-mastery-hub/commit/becc4b12414abed5a9790cc7be0190b8a106d327))
* remove legacy SQL seed files, replace with assets/examples ([cdfbd38](https://github.com/open-lingua/ielts-mastery-hub/commit/cdfbd38fec83bca274f42391a4640ebe7e47a030))
* remove Lovable branding and lovable-tagger dependency ([c4d48b8](https://github.com/open-lingua/ielts-mastery-hub/commit/c4d48b872c863c4138ebed0946924397eb446f9b))
* remove Lovable branding and lovable-tagger dependency ([7130bc3](https://github.com/open-lingua/ielts-mastery-hub/commit/7130bc3240c2a55f0f7ccbf612439f6e294704e6))
* remove Supabase backend and migrate docs to Tauri/SQLite architecture ([d767659](https://github.com/open-lingua/ielts-mastery-hub/commit/d76765948c852d17a485d6624d3c7d4cac7d2a70))
* remove Supabase legacy code and references ([370ff10](https://github.com/open-lingua/ielts-mastery-hub/commit/370ff10bbc1a031fc2cccf97ab16fae00fd648d0))
* remove Supabase secrets requirement and patch website deps ([e2eb09a](https://github.com/open-lingua/ielts-mastery-hub/commit/e2eb09a31c8fe3972ef124497afe245da3d7e5d2))
* rename asset files to app-banner and app-logo ([9836b02](https://github.com/open-lingua/ielts-mastery-hub/commit/9836b02f92ff230ec8c8c1d2291f91573f4ceaac))
* rename core crate to open-lingua-ielts-mastery-hub-core ([e6949bb](https://github.com/open-lingua/ielts-mastery-hub/commit/e6949bb3a5db3f78c4fe281f028cf668588741d0))
* rename local storage root from .ielts-hub to .imh ([e6f721b](https://github.com/open-lingua/ielts-mastery-hub/commit/e6f721ba4234cb88d4602306bd7ee93963042ce8))
* rename package to @open-lingua/ielts-mastery-hub and bump version to 0.1.0 ([1f574a6](https://github.com/open-lingua/ielts-mastery-hub/commit/1f574a61b9dc9a0c9277699393c8416a83d1e419))
* rename website package to @open-lingua/ielts-mastery-hub-website and bump version to 0.1.0 ([c8850bb](https://github.com/open-lingua/ielts-mastery-hub/commit/c8850bbf936e9fd7f76054f0de41ea6b076a60fd))
* Reorganize docs into layer-specific context files and update AGENTS.md references ([9b7d561](https://github.com/open-lingua/ielts-mastery-hub/commit/9b7d561003bbc06d6ddcfb49c03e6d76c097135b))
* replace default Docusaurus branding with app assets ([618c1f9](https://github.com/open-lingua/ielts-mastery-hub/commit/618c1f990db7014d5868dfc940182cb72d8ebf2b))
* replace pnpm to npm ([735f7e2](https://github.com/open-lingua/ielts-mastery-hub/commit/735f7e29b45f6fe4954107b6f09b421b5671403c))
* resolve merge conflict in useVersionCheck ([10a5609](https://github.com/open-lingua/ielts-mastery-hub/commit/10a56092147505d65eed9a4f363addba2f207c34))
* Run tests with --silent flag ([31fa8d8](https://github.com/open-lingua/ielts-mastery-hub/commit/31fa8d8902e6177b8f9dbf6bf2aae6c6b68f2c37))
* **seeds:** rename writing asset files to match task UUIDs ([f14a928](https://github.com/open-lingua/ielts-mastery-hub/commit/f14a9281dde426253f7ac2bdc4581e35d42133a1))
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
* **website:** configure site for IELTS Mastery Hub (title, org, url) ([5453ca7](https://github.com/open-lingua/ielts-mastery-hub/commit/5453ca77b873ce5461914402ab77cf61ef58e680))

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
