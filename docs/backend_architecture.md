# Backend Architecture

Rust + Tauri 2.x desktop app. SQLite via `sqlx`, async via `tokio`. Only API surface is Tauri commands invoked over IPC.

## Layers

```
Frontend  →  invoke('command', args)
              ↓ Tauri IPC (camelCase ⇄ snake_case)
Commands  (src/core/src/commands/)     — IPC entry points, thin validation, delegate to repos
              ↓
Repos     (src/core/src/repositories/) — all SQL, entity structs, auth checks
              ↓ sqlx
Database  (src/core/src/database/)    — pool init, migrations, seeds
              ↓
         ielts.db  (app_data_dir)
```

## Key Rules

| | |
|---|---|
| Command return | `Result<T, String>` — always `.map_err(Into::into)` |
| Repo return | `Result<T, AppError>` |
| SQL | `sqlx::query!` macros only — no string queries |
| Authorization | In SQL `WHERE` clauses, not middleware |
| Migrations | Immutable — never edit; always add a new timestamped file |
| Registration | Every command in `commands/mod.rs` AND `generate_handler![...]` in `lib.rs` |
| No `unwrap()` | Propagate with `?` everywhere |
| Secrets | Never return API keys in command responses |

## Error Flow

```
AppError  →  .map_err(Into::into)  →  String  →  Tauri rejects promise  →  try/catch in lib/tauri.ts
```

`AppError` variants: `Database`, `Migration`, `Serialization`, `NotFound(String)`, `Validation(String)`.

## Adding a Feature

1. Migration — `src/core/src/database/migrations/<timestamp>_name.sql`
2. Repository — `repositories/{domain}.rs` with entity + `Create*`/`Update*` structs and CRUD fns. Register in `repositories/mod.rs`.
3. Command — `commands/{domain}.rs` with `#[tauri::command]` fns delegating to repo. Register in `commands/mod.rs` + `generate_handler!`.
4. Frontend — typed `invoke<T>` wrapper in `src/ui/lib/tauri.ts` + mirror types in `src/ui/types/`.
