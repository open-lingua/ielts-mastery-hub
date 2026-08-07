use crate::db::Database;
use rusqlite::params;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct WritingTest {
    pub id: String,
    pub created_by: String,
    pub title: String,
    pub status: String,
    pub created_at: String,
    pub updated_at: String,
}

#[derive(Debug, Deserialize)]
pub struct NewWritingTest {
    pub id: String,
    pub created_by: String,
    pub title: String,
    pub status: String,
}

#[derive(Debug, Deserialize)]
pub struct UpdateWritingTest {
    pub title: Option<String>,
    pub status: Option<String>,
}

pub fn find_by_id(db: &Database, id: &str, user_id: &str) -> Result<Option<WritingTest>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let mut stmt = conn
        .prepare(
            "SELECT id, created_by, title, status, created_at, updated_at \
             FROM writing_tests WHERE id = ?1 AND (created_by = ?2 OR status = 'published')",
        )
        .map_err(|e| e.to_string())?;
    let result: Option<WritingTest> = stmt
        .query_map(params![id, user_id], map_row)
        .map_err(|e| e.to_string())?
        .next()
        .transpose()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn find_all(db: &Database, user_id: &str) -> Result<Vec<WritingTest>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let mut stmt = conn
        .prepare(
            "SELECT id, created_by, title, status, created_at, updated_at \
             FROM writing_tests WHERE created_by = ?1 OR status = 'published'",
        )
        .map_err(|e| e.to_string())?;
    let result: Vec<WritingTest> = stmt
        .query_map(params![user_id], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn insert(db: &Database, t: &NewWritingTest) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "INSERT INTO writing_tests (id, created_by, title, status) VALUES (?1, ?2, ?3, ?4)",
        params![t.id, t.created_by, t.title, t.status],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn update(db: &Database, id: &str, user_id: &str, u: &UpdateWritingTest) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "UPDATE writing_tests SET \
         title = COALESCE(?1, title), status = COALESCE(?2, status), \
         updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now') \
         WHERE id = ?3 AND created_by = ?4",
        params![u.title, u.status, id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn delete(db: &Database, id: &str, user_id: &str) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "DELETE FROM writing_tests WHERE id = ?1 AND created_by = ?2",
        params![id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

fn map_row(row: &rusqlite::Row) -> rusqlite::Result<WritingTest> {
    Ok(WritingTest {
        id: row.get(0)?,
        created_by: row.get(1)?,
        title: row.get(2)?,
        status: row.get(3)?,
        created_at: row.get(4)?,
        updated_at: row.get(5)?,
    })
}
