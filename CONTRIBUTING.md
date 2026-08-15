# Contributing to IELTS Mastery Hub

Thanks for your interest in contributing. This guide covers what you need to set up the project and submit changes.

## Prerequisites

- Node.js (LTS) and npm
- Rust (stable toolchain) and Cargo
- [Tauri CLI prerequisites](https://tauri.app/start/prerequisites/) for your OS (required to build/run the desktop app)
- `sqlx-cli` (only if you're adding database migrations):
  ```bash
  cargo install sqlx-cli --no-default-features --features sqlite
  ```

## Local Setup

```bash
git clone https://github.com/open-lingua/ielts-mastery-hub.git
cd ielts-mastery-hub
npm install
npm run tauri dev
```

> If you need to run `sqlx` CLI commands, set `DATABASE_URL` first — see [Environment Variables](#environment-variables) below.

Do not run the Rust binary directly with `cargo run` — Tauri manages the build and links it with the frontend.

## Project Structure

- `src/ui/` — TypeScript/React frontend (Vite)
- `src/core/` — Rust backend (Tauri commands, database, migrations)
- `website/` — Docusaurus documentation site

See `src/core/README.md` for backend-specific details (module layout, adding commands, migrations).

## Making Changes

### Frontend (`src/ui`)

```bash
npm run lint       # check
npm run lint:fix    # auto-fix
npm run format      # format with Biome
npm run check       # lint + format, write mode
npm run test         # run tests once
npm run test:watch   # watch mode
```

Run `npm run check` before opening a PR.

### Backend (`src/core`)

```bash
cd src/core
cargo clippy -- -D warnings
cargo fmt
```

Fix warnings with `cargo clippy --fix` when appropriate, but understand what changed before committing.

### Database Migrations

Create migrations from `src/core/`:

```bash
sqlx migrate add --source src/database/migrations <description>
```

Never rename or edit an existing migration file — add a new one instead. Migrations run automatically on app startup.

### Environment Variables

Backend secrets/config go in `src/core/.env` and are never exposed to the frontend.

If you need to run `sqlx` CLI commands (e.g. `sqlx migrate run`), set `DATABASE_URL` to point to the app's SQLite file. The path varies by OS:

**macOS**
```bash
export DATABASE_URL="sqlite:///Users/$(whoami)/Library/Application Support/com.openlingua.ieltsmasteryhub/ielts.db"
```

**Linux**
```bash
export DATABASE_URL="sqlite:///home/$(whoami)/.local/share/com.openlingua.ieltsmasteryhub/ielts.db"
```

**Windows (PowerShell)**
```powershell
$env:DATABASE_URL = "sqlite:///$env:APPDATA\com.openlingua.ieltsmasteryhub\ielts.db"
```

## Branching

Branch off `main`. Use a descriptive, prefixed branch name, e.g. `feature/writing-score-export` or `fix/listening-audio-sync`.

## Commit Messages

Keep commits focused and messages in the imperative mood (e.g. `Add reading timer reset`, `Fix migration ordering bug`).

## Pull Requests

- Open PRs against `main`.
- Ensure `npm run check`, `npm run test`, and (if you touched Rust code) `cargo clippy -- -D warnings` and `cargo fmt` all pass before requesting review.
- Describe what changed and why; link related issues if applicable.
- Keep PRs scoped to a single change — avoid bundling unrelated fixes or refactors.
