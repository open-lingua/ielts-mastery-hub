use crate::db::Database;
use rusqlite::params;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct UserRole {
    pub id: String,
    pub user_id: String,
    pub role: String,
    pub created_at: String,
}

pub fn find_by_user(db: &Database, user_id: &str) -> Result<Vec<UserRole>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let mut stmt = conn
        .prepare("SELECT id, user_id, role, created_at FROM user_roles WHERE user_id = ?1")
        .map_err(|e| e.to_string())?;
    let result: Vec<UserRole> = stmt
        .query_map(params![user_id], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn find_all(db: &Database) -> Result<Vec<UserRole>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let mut stmt = conn
        .prepare("SELECT id, user_id, role, created_at FROM user_roles")
        .map_err(|e| e.to_string())?;
    let result: Vec<UserRole> = stmt
        .query_map([], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn insert(db: &Database, role: &UserRole) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "INSERT INTO user_roles (id, user_id, role, created_at) VALUES (?1, ?2, ?3, ?4)",
        params![role.id, role.user_id, role.role, role.created_at],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn delete(db: &Database, id: &str) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute("DELETE FROM user_roles WHERE id = ?1", params![id])
        .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn has_role(db: &Database, user_id: &str, role: &str) -> Result<bool, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let count: i64 = conn
        .query_row(
            "SELECT COUNT(*) FROM user_roles WHERE user_id = ?1 AND role = ?2",
            params![user_id, role],
            |row| row.get(0),
        )
        .map_err(|e| e.to_string())?;
    Ok(count > 0)
}

fn map_row(row: &rusqlite::Row) -> rusqlite::Result<UserRole> {
    Ok(UserRole {
        id: row.get(0)?,
        user_id: row.get(1)?,
        role: row.get(2)?,
        created_at: row.get(3)?,
    })
}
