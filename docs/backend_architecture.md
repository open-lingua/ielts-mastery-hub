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
         imh.db  (OS default dir, or DATABASE_URL override)
```

## Database Path Resolution

`database::resolve_database_url()` picks the SQLite connection URL at
runtime:

1. If `DATABASE_URL` is set (non-empty) in the environment, it's used
   verbatim — this overrides everything below.
2. Otherwise, a default path is derived per OS via `database::default_db_path()`
   using only `std::env` (no `dirs`/`directories` crate):

| OS | Default path |
|---|---|
| macOS | `$HOME/Library/Application Support/com.openlingua.ieltsmasteryhub/imh.db` |
| Linux | `$HOME/.local/share/com.openlingua.ieltsmasteryhub/imh.db` |
| Windows | `%APPDATA%\com.openlingua.ieltsmasteryhub\imh.db` |

The identifier segment matches `identifier` in `tauri.conf.json`. If the
required env var (`HOME` on macOS/Linux, `APPDATA` on Windows) is missing,
resolution fails with `AppError::Validation`. `database::init()` creates the
parent directory (`create_dir_all`) before opening the pool.

If you need to run `sqlx` CLI commands (e.g. `sqlx migrate run`), set
`DATABASE_URL` to point to the app's SQLite file:

**macOS**
```bash
export DATABASE_URL="sqlite:///Users/$(whoami)/Library/Application Support/com.openlingua.ieltsmasteryhub/imh.db"
```

**Linux**
```bash
export DATABASE_URL="sqlite:///home/$(whoami)/.local/share/com.openlingua.ieltsmasteryhub/imh.db"
```

**Windows (PowerShell)**
```powershell
$env:DATABASE_URL = "sqlite:///$env:APPDATA\com.openlingua.ieltsmasteryhub\imh.db"
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
