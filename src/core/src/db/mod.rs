use rusqlite::Connection;
use std::sync::Mutex;
use tauri::Manager;

pub struct Database {
    pub conn: Mutex<Connection>,
}

const SCHEMA: &str = include_str!("schema.sql");

pub fn init(app: &tauri::App) -> Result<Database, Box<dyn std::error::Error>> {
    let data_dir = app.path().app_data_dir()?;
    std::fs::create_dir_all(&data_dir)?;
    let db_path = data_dir.join("ielts.db");
    let conn = Connection::open(&db_path)?;
    conn.execute_batch("PRAGMA journal_mode=WAL; PRAGMA foreign_keys=ON;")?;
    conn.execute_batch(SCHEMA)?;
    Ok(Database {
        conn: Mutex::new(conn),
    })
}
