use crate::db::Database;
use rusqlite::params;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct ReadingPassage {
    pub id: String,
    pub test_id: String,
    pub passage_number: i32,
    pub title: String,
    pub content: String,
    pub notes: Option<String>,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct NewReadingPassage {
    pub id: String,
    pub test_id: String,
    pub passage_number: i32,
    pub title: String,
    pub content: String,
    pub notes: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateReadingPassage {
    pub passage_number: Option<i32>,
    pub title: Option<String>,
    pub content: Option<String>,
    pub notes: Option<String>,
}

pub fn find_by_id(db: &Database, id: &str, user_id: &str) -> Result<Option<ReadingPassage>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let mut stmt = conn
        .prepare(
            "SELECT p.id, p.test_id, p.passage_number, p.title, p.content, p.notes, p.created_at \
             FROM reading_passages p JOIN reading_tests t ON t.id = p.test_id \
             WHERE p.id = ?1 AND (t.created_by = ?2 OR t.status = 'published')",
        )
        .map_err(|e| e.to_string())?;
    let result: Option<ReadingPassage> = stmt
        .query_map(params![id, user_id], map_row)
        .map_err(|e| e.to_string())?
        .next()
        .transpose()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn find_by_test(db: &Database, test_id: &str, user_id: &str) -> Result<Vec<ReadingPassage>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let mut stmt = conn
        .prepare(
            "SELECT p.id, p.test_id, p.passage_number, p.title, p.content, p.notes, p.created_at \
             FROM reading_passages p JOIN reading_tests t ON t.id = p.test_id \
             WHERE p.test_id = ?1 AND (t.created_by = ?2 OR t.status = 'published') \
             ORDER BY p.passage_number",
        )
        .map_err(|e| e.to_string())?;
    let result: Vec<ReadingPassage> = stmt
        .query_map(params![test_id, user_id], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn find_all(db: &Database, user_id: &str) -> Result<Vec<ReadingPassage>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let mut stmt = conn
        .prepare(
            "SELECT p.id, p.test_id, p.passage_number, p.title, p.content, p.notes, p.created_at \
             FROM reading_passages p JOIN reading_tests t ON t.id = p.test_id \
             WHERE t.created_by = ?1 OR t.status = 'published'",
        )
        .map_err(|e| e.to_string())?;
    let result: Vec<ReadingPassage> = stmt
        .query_map(params![user_id], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn insert(db: &Database, p: &NewReadingPassage, user_id: &str) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let owned: i64 = conn
        .query_row(
            "SELECT COUNT(*) FROM reading_tests WHERE id = ?1 AND created_by = ?2",
            params![p.test_id, user_id],
            |row| row.get(0),
        )
        .map_err(|e| e.to_string())?;
    if owned == 0 {
        return Err("not authorized".to_string());
    }
    conn.execute(
        "INSERT INTO reading_passages (id, test_id, passage_number, title, content, notes) \
         VALUES (?1, ?2, ?3, ?4, ?5, ?6)",
        params![p.id, p.test_id, p.passage_number, p.title, p.content, p.notes],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn update(db: &Database, id: &str, user_id: &str, u: &UpdateReadingPassage) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "UPDATE reading_passages SET \
         passage_number = COALESCE(?1, passage_number), title = COALESCE(?2, title), \
         content = COALESCE(?3, content), notes = COALESCE(?4, notes) \
         WHERE id = ?5 AND EXISTS (SELECT 1 FROM reading_tests t WHERE t.id = test_id AND t.created_by = ?6)",
        params![u.passage_number, u.title, u.content, u.notes, id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn delete(db: &Database, id: &str, user_id: &str) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "DELETE FROM reading_passages WHERE id = ?1 \
         AND EXISTS (SELECT 1 FROM reading_tests t WHERE t.id = test_id AND t.created_by = ?2)",
        params![id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

fn map_row(row: &rusqlite::Row) -> rusqlite::Result<ReadingPassage> {
    Ok(ReadingPassage {
        id: row.get(0)?,
        test_id: row.get(1)?,
        passage_number: row.get(2)?,
        title: row.get(3)?,
        content: row.get(4)?,
        notes: row.get(5)?,
        created_at: row.get(6)?,
    })
}
