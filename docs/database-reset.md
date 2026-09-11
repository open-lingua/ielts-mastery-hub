# Resetting the Development Database

This guide explains how to delete the local development database and re-apply migrations and seeds from scratch.

## Prerequisites

- `sqlx-cli` with SQLite support:

  ```bash
  cargo install sqlx-cli --no-default-features --features sqlite
  ```

## Steps

### 1. Delete the existing database

```bash
rm -f ~/Library/Application\ Support/com.openlingua.ieltsmasteryhub/imh.db*
ls -la ~/Library/Application\ Support/com.openlingua.ieltsmasteryhub/
```

### 2. Move into the core (Rust) project

```bash
cd src/core
```

### 3. Install sqlx-cli (if not already installed)

```bash
cargo install sqlx-cli --no-default-features --features sqlite   # if you don't have it
```

### 4. Prepare the database directory and DATABASE_URL

```bash
mkdir -p "$HOME/Library/Application Support/com.openlingua.ieltsmasteryhub"

# Point DATABASE_URL to the same file used by the app
export DATABASE_URL="sqlite://$HOME/Library/Application Support/com.openlingua.ieltsmasteryhub/imh.db"
```

### 5. Drop, create, and migrate the database

```bash
sqlx database drop -y
sqlx database create
sqlx migrate run --source src/database/migrations
```

### 6. Apply the seed files

```bash
DB="$HOME/Library/Application Support/com.openlingua.ieltsmasteryhub/imh.db"

for f in src/database/seeds/listening/*.sql \
         src/database/seeds/reading/*.sql \
         src/database/seeds/writing/*.sql; do
  echo "Applying: $f"
  sqlite3 "$DB" < "$f"
done
```

## Notes

- Make sure the `DATABASE_URL` path matches the same location the Tauri app reads from (`app_data_dir()`), otherwise the app will not see the reset data.
- Migrations also run automatically on app startup (`sqlx::migrate!` in `src/core/src/database/mod.rs`), so simply relaunching the app with `bun run tauri dev` after step 1 will also recreate the schema, though the seed files still need to be applied manually as shown in step 6.
