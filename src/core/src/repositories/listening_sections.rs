use crate::db::Database;
use rusqlite::params;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct ListeningSection {
    pub id: String,
    pub test_id: String,
    pub section_number: i32,
    pub title: String,
    pub transcript: Option<String>,
    pub audio_url: Option<String>,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct NewListeningSection {
    pub id: String,
    pub test_id: String,
    pub section_number: i32,
    pub title: String,
    pub transcript: Option<String>,
    pub audio_url: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateListeningSection {
    pub section_number: Option<i32>,
    pub title: Option<String>,
    pub transcript: Option<String>,
    pub audio_url: Option<String>,
}

const SELECT_COLS: &str =
    "s.id, s.test_id, s.section_number, s.title, s.transcript, s.audio_url, s.created_at";

pub fn find_by_test(db: &Database, test_id: &str, user_id: &str) -> Result<Vec<ListeningSection>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let sql = format!(
        "SELECT {SELECT_COLS} FROM listening_sections s JOIN listening_tests t ON t.id = s.test_id \
         WHERE s.test_id = ?1 AND (t.created_by = ?2 OR t.status = 'published') ORDER BY s.section_number"
    );
    let mut stmt = conn.prepare(&sql).map_err(|e| e.to_string())?;
    let result: Vec<ListeningSection> = stmt
        .query_map(params![test_id, user_id], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn find_by_id(db: &Database, id: &str, user_id: &str) -> Result<Option<ListeningSection>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let sql = format!(
        "SELECT {SELECT_COLS} FROM listening_sections s JOIN listening_tests t ON t.id = s.test_id \
         WHERE s.id = ?1 AND (t.created_by = ?2 OR t.status = 'published')"
    );
    let mut stmt = conn.prepare(&sql).map_err(|e| e.to_string())?;
    let result: Option<ListeningSection> = stmt
        .query_map(params![id, user_id], map_row)
        .map_err(|e| e.to_string())?
        .next()
        .transpose()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn find_all(db: &Database, user_id: &str) -> Result<Vec<ListeningSection>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let sql = format!(
        "SELECT {SELECT_COLS} FROM listening_sections s JOIN listening_tests t ON t.id = s.test_id \
         WHERE t.created_by = ?1 OR t.status = 'published'"
    );
    let mut stmt = conn.prepare(&sql).map_err(|e| e.to_string())?;
    let result: Vec<ListeningSection> = stmt
        .query_map(params![user_id], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn insert(db: &Database, s: &NewListeningSection, user_id: &str) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let owned: i64 = conn
        .query_row(
            "SELECT COUNT(*) FROM listening_tests WHERE id = ?1 AND created_by = ?2",
            params![s.test_id, user_id],
            |row| row.get(0),
        )
        .map_err(|e| e.to_string())?;
    if owned == 0 {
        return Err("not authorized".to_string());
    }
    conn.execute(
        "INSERT INTO listening_sections (id, test_id, section_number, title, transcript, audio_url) \
         VALUES (?1, ?2, ?3, ?4, ?5, ?6)",
        params![s.id, s.test_id, s.section_number, s.title, s.transcript, s.audio_url],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn update(db: &Database, id: &str, user_id: &str, u: &UpdateListeningSection) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "UPDATE listening_sections SET \
         section_number = COALESCE(?1, section_number), title = COALESCE(?2, title), \
         transcript = COALESCE(?3, transcript), audio_url = COALESCE(?4, audio_url) \
         WHERE id = ?5 AND EXISTS (SELECT 1 FROM listening_tests t WHERE t.id = test_id AND t.created_by = ?6)",
        params![u.section_number, u.title, u.transcript, u.audio_url, id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn delete(db: &Database, id: &str, user_id: &str) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "DELETE FROM listening_sections WHERE id = ?1 \
         AND EXISTS (SELECT 1 FROM listening_tests t WHERE t.id = test_id AND t.created_by = ?2)",
        params![id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

fn map_row(row: &rusqlite::Row) -> rusqlite::Result<ListeningSection> {
    Ok(ListeningSection {
        id: row.get(0)?,
        test_id: row.get(1)?,
        section_number: row.get(2)?,
        title: row.get(3)?,
        transcript: row.get(4)?,
        audio_url: row.get(5)?,
        created_at: row.get(6)?,
    })
}
