use crate::db::Database;
use rusqlite::params;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct ListeningTest {
    pub id: String,
    pub created_by: String,
    pub title: String,
    pub difficulty: String,
    pub duration: String,
    pub status: String,
    pub created_at: String,
    pub updated_at: String,
}

#[derive(Debug, Deserialize)]
pub struct NewListeningTest {
    pub id: String,
    pub created_by: String,
    pub title: String,
    pub difficulty: String,
    pub duration: String,
    pub status: String,
}

#[derive(Debug, Deserialize)]
pub struct UpdateListeningTest {
    pub title: Option<String>,
    pub difficulty: Option<String>,
    pub duration: Option<String>,
    pub status: Option<String>,
}

pub fn find_by_id(db: &Database, id: &str, user_id: &str) -> Result<Option<ListeningTest>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let mut stmt = conn
        .prepare(
            "SELECT id, created_by, title, difficulty, duration, status, created_at, updated_at \
             FROM listening_tests WHERE id = ?1 AND (created_by = ?2 OR status = 'published')",
        )
        .map_err(|e| e.to_string())?;
    let result: Option<ListeningTest> = stmt
        .query_map(params![id, user_id], map_row)
        .map_err(|e| e.to_string())?
        .next()
        .transpose()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn find_all(db: &Database, user_id: &str) -> Result<Vec<ListeningTest>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let mut stmt = conn
        .prepare(
            "SELECT id, created_by, title, difficulty, duration, status, created_at, updated_at \
             FROM listening_tests WHERE created_by = ?1 OR status = 'published'",
        )
        .map_err(|e| e.to_string())?;
    let result: Vec<ListeningTest> = stmt
        .query_map(params![user_id], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn insert(db: &Database, t: &NewListeningTest) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "INSERT INTO listening_tests (id, created_by, title, difficulty, duration, status) \
         VALUES (?1, ?2, ?3, ?4, ?5, ?6)",
        params![t.id, t.created_by, t.title, t.difficulty, t.duration, t.status],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn update(db: &Database, id: &str, user_id: &str, u: &UpdateListeningTest) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "UPDATE listening_tests SET \
         title = COALESCE(?1, title), difficulty = COALESCE(?2, difficulty), \
         duration = COALESCE(?3, duration), status = COALESCE(?4, status), \
         updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now') \
         WHERE id = ?5 AND created_by = ?6",
        params![u.title, u.difficulty, u.duration, u.status, id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn delete(db: &Database, id: &str, user_id: &str) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "DELETE FROM listening_tests WHERE id = ?1 AND created_by = ?2",
        params![id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

fn map_row(row: &rusqlite::Row) -> rusqlite::Result<ListeningTest> {
    Ok(ListeningTest {
        id: row.get(0)?,
        created_by: row.get(1)?,
        title: row.get(2)?,
        difficulty: row.get(3)?,
        duration: row.get(4)?,
        status: row.get(5)?,
        created_at: row.get(6)?,
        updated_at: row.get(7)?,
    })
}
