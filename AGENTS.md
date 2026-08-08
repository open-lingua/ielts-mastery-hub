# IELTS Mastery Hub — Project Context

## Description
Browser-based IELTS preparation platform with timed reading, listening, AI-graded writing, and exam simulations — built as a desktop app with Tauri 2 + React.

## Tech Stack
| Layer    | Technology                              | Location   |
|----------|-----------------------------------------|------------|
| Backend  | Rust, Tauri 2                           | `src/core` |
| Frontend | React [YOUR REACT VERSION], TypeScript  | `src/ui`   |

## Dev & Build Commands

```bash
# Install dependencies
pnpm install   # or npm install / yarn

# Run in development mode (starts both Rust + Vite dev server)
pnpm tauri dev

# Build for production
pnpm tauri build
```

> Rust is compiled by Tauri automatically. Do not run `cargo` commands for the app binary directly unless working on isolated Rust logic.

## Tauri IPC — How the Two Layers Communicate

- **Commands**: Frontend calls Rust functions via `invoke('command_name', { args })`. Commands are defined in `src/core/src/commands/`.
- **Events**: Rust emits events via `app_handle.emit(...)`. Frontend listens with `listen('event_name', handler)` from `@tauri-apps/api/event`.
- All command arguments and return types must be serializable (`serde::Serialize` / `serde::Deserialize` on Rust side; matching TypeScript interfaces on frontend).

## Naming Conventions (Shared Rust ↔ TypeScript)

| Concept         | Rust              | TypeScript          |
|-----------------|-------------------|---------------------|
| Command names   | `snake_case`       | `snake_case` string in `invoke()` |
| Event names     | `snake_case`       | `snake_case` string in `listen()` |
| Struct fields   | `snake_case`       | `camelCase` (auto via `serde(rename_all = "camelCase")`) |
| Types/Interfaces| `PascalCase`       | `PascalCase`        |

## Monorepo Structure

```
/
├── src/
│   ├── core/          # Rust / Tauri 2 backend
│   │   ├── src/
│   │   ├── Cargo.toml
│   │   └── tauri.conf.json
│   └── ui/            # React / TypeScript frontend
│       ├── src/
│       ├── index.html
│       └── vite.config.ts
├── CLAUDE.md
├── package.json
└── [YOUR CONFIG FILE e.g. .env, turbo.json, etc.]
```

## Layer-Specific Context Files

Before modifying code in a layer, read the corresponding context file (both files are identical — pick either):

- **`src/core/*`** (Rust/Tauri backend): `src/core/AGENTS.md` or `src/core/CLAUDE.md` — both files have identical content.
- **`src/ui/*`** (React/TS frontend): `src/ui/AGENTS.md` or `src/ui/CLAUDE.md` — both files have identical content.

## Project Documentation

- **`docs/FRONTEND_ARCHITECTURE.md`** — frontend architecture overview; read before making structural UI changes.
- **`docs/PRODUCT.md`** — product requirements and feature specs; read before adding or changing features.

## Environment Variables & Config

- Frontend env vars: defined in `.env` / `.env.local` — must be prefixed with `VITE_` to be exposed.
- Tauri config: `src/core/tauri.conf.json` — controls permissions, window settings, bundle identifiers.
- **Never expose secrets to the frontend** — secrets must stay in the Rust layer.
- Key env vars in use:
  - `VITE_[YOUR KEY]` — [YOUR PURPOSE]
  - `[YOUR RUST ENV VAR]` — [YOUR PURPOSE]
