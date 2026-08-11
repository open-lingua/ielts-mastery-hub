# Core — Rust / Backend

## Run the app

```bash
# From the repo root
pnpm tauri dev
```

Do not run the binary directly with `cargo run`. Tauri manages the build.

## Lint

```bash
cd src/core
cargo clippy -- -D warnings
```

Fix a warning without fully understanding it:

```bash
cargo clippy --fix
```

## Format

```bash
cargo fmt
```

## Add a migration

Install the CLI once:

```bash
cargo install sqlx-cli --no-default-features --features sqlite
```

Then create a migration from `src/core/`:

```bash
sqlx migrate add --source src/database/migrations <description>
```

This generates a timestamped file like `20260812093000_<description>.sql`. Write your SQL there.

The app runs all pending migrations automatically on startup.

> Never rename or edit an existing migration file.

## Module structure

```
src/
├── commands/       # Tauri commands (#[tauri::command])
├── database/
│   ├── mod.rs      # DB pool init + migration runner
│   └── migrations/ # SQL migration files
├── repositories/   # DB queries, one file per domain
├── error.rs        # AppError enum
├── lib.rs          # Tauri builder + invoke_handler
└── main.rs         # Entry point
```

## Add a new command

1. Add a function in `src/commands/<domain>.rs`:

   ```rust
   #[tauri::command]
   pub async fn my_command(db: tauri::State<'_, Db>) -> Result<MyType, AppError> {
       todo!()
   }
   ```

2. Register it in `src/lib.rs` inside `tauri::generate_handler![]`.

## Environment variables

Secrets and config go in `src/core/.env`. They are never exposed to the frontend.
