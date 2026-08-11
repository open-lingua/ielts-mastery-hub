use sqlx::sqlite::SqlitePoolOptions;
use tauri::Manager;

use crate::error::AppError;

pub type Db = sqlx::SqlitePool;

pub async fn init(app_handle: &tauri::AppHandle) -> Result<Db, AppError> {
    let data_dir = app_handle
        .path()
        .app_data_dir()
        .map_err(|e| AppError::Validation(e.to_string()))?;
    std::fs::create_dir_all(&data_dir)
        .map_err(|e| AppError::Validation(e.to_string()))?;
    let db_path = data_dir.join("ielts.db");
    let db_url = format!("sqlite://{}?mode=rwc", db_path.to_string_lossy());
    let pool = SqlitePoolOptions::new()
        .max_connections(5)
        .connect(&db_url)
        .await?;
    sqlx::query("PRAGMA journal_mode=WAL").execute(&pool).await?;
    sqlx::query("PRAGMA foreign_keys=ON").execute(&pool).await?;
    sqlx::migrate!("./migrations").run(&pool).await?;
    Ok(pool)
}
