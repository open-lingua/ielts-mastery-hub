use crate::db::Database;
use rusqlite::params;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct ReadingTest {
    pub id: String,
    pub created_by: String,
    pub title: String,
    pub test_type: String,
    pub difficulty: String,
    pub duration: String,
    pub status: String,
    pub created_at: String,
    pub updated_at: String,
}

#[derive(Debug, Deserialize)]
pub struct NewReadingTest {
    pub id: String,
    pub created_by: String,
    pub title: String,
    pub test_type: String,
    pub difficulty: String,
    pub duration: String,
    pub status: String,
}

#[derive(Debug, Deserialize)]
pub struct UpdateReadingTest {
    pub title: Option<String>,
    pub test_type: Option<String>,
    pub difficulty: Option<String>,
    pub duration: Option<String>,
    pub status: Option<String>,
}

pub fn find_by_id(db: &Database, id: &str, user_id: &str) -> Result<Option<ReadingTest>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let mut stmt = conn
        .prepare(
            "SELECT id, created_by, title, test_type, difficulty, duration, status, created_at, updated_at \
             FROM reading_tests WHERE id = ?1 AND (created_by = ?2 OR status = 'published')",
        )
        .map_err(|e| e.to_string())?;
    let result: Option<ReadingTest> = stmt
        .query_map(params![id, user_id], map_row)
        .map_err(|e| e.to_string())?
        .next()
        .transpose()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn find_all(db: &Database, user_id: &str) -> Result<Vec<ReadingTest>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let mut stmt = conn
        .prepare(
            "SELECT id, created_by, title, test_type, difficulty, duration, status, created_at, updated_at \
             FROM reading_tests WHERE created_by = ?1 OR status = 'published'",
        )
        .map_err(|e| e.to_string())?;
    let result: Vec<ReadingTest> = stmt
        .query_map(params![user_id], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn insert(db: &Database, t: &NewReadingTest) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "INSERT INTO reading_tests (id, created_by, title, test_type, difficulty, duration, status) \
         VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7)",
        params![t.id, t.created_by, t.title, t.test_type, t.difficulty, t.duration, t.status],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn update(db: &Database, id: &str, user_id: &str, u: &UpdateReadingTest) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "UPDATE reading_tests SET \
         title = COALESCE(?1, title), test_type = COALESCE(?2, test_type), \
         difficulty = COALESCE(?3, difficulty), duration = COALESCE(?4, duration), \
         status = COALESCE(?5, status), \
         updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now') \
         WHERE id = ?6 AND created_by = ?7",
        params![u.title, u.test_type, u.difficulty, u.duration, u.status, id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn delete(db: &Database, id: &str, user_id: &str) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "DELETE FROM reading_tests WHERE id = ?1 AND created_by = ?2",
        params![id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

fn map_row(row: &rusqlite::Row) -> rusqlite::Result<ReadingTest> {
    Ok(ReadingTest {
        id: row.get(0)?,
        created_by: row.get(1)?,
        title: row.get(2)?,
        test_type: row.get(3)?,
        difficulty: row.get(4)?,
        duration: row.get(5)?,
        status: row.get(6)?,
        created_at: row.get(7)?,
        updated_at: row.get(8)?,
    })
}
