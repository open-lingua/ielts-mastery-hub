use crate::db::Database;
use rusqlite::params;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct UserTestSession {
    pub id: String,
    pub user_id: String,
    pub test_id: String,
    pub test_type: String,
    pub status: String,
    pub progress_percent: i32,
    pub score_band: Option<f64>,
    pub attempt_number: i32,
    pub answers: Option<String>,
    pub feedback_data: Option<String>,
    pub started_at: String,
    pub completed_at: Option<String>,
    pub last_active_at: String,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct NewUserTestSession {
    pub id: String,
    pub user_id: String,
    pub test_id: String,
    pub test_type: String,
    pub attempt_number: i32,
}

#[derive(Debug, Deserialize)]
pub struct UpdateUserTestSession {
    pub status: Option<String>,
    pub progress_percent: Option<i32>,
    pub score_band: Option<f64>,
    pub answers: Option<String>,
    pub feedback_data: Option<String>,
    pub completed_at: Option<String>,
    pub last_active_at: Option<String>,
}

const SELECT_COLS: &str =
    "id, user_id, test_id, test_type, status, progress_percent, score_band, \
     attempt_number, answers, feedback_data, started_at, completed_at, last_active_at, created_at";

pub fn find_by_id(db: &Database, id: &str, user_id: &str) -> Result<Option<UserTestSession>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let sql = format!("SELECT {SELECT_COLS} FROM user_test_sessions WHERE id = ?1 AND user_id = ?2");
    let mut stmt = conn.prepare(&sql).map_err(|e| e.to_string())?;
    let result: Option<UserTestSession> = stmt
        .query_map(params![id, user_id], map_row)
        .map_err(|e| e.to_string())?
        .next()
        .transpose()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn find_all(db: &Database, user_id: &str) -> Result<Vec<UserTestSession>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let sql = format!(
        "SELECT {SELECT_COLS} FROM user_test_sessions WHERE user_id = ?1 ORDER BY created_at DESC"
    );
    let mut stmt = conn.prepare(&sql).map_err(|e| e.to_string())?;
    let result: Vec<UserTestSession> = stmt
        .query_map(params![user_id], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn find_by_test(db: &Database, test_id: &str, user_id: &str) -> Result<Vec<UserTestSession>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let sql = format!(
        "SELECT {SELECT_COLS} FROM user_test_sessions \
         WHERE test_id = ?1 AND user_id = ?2 ORDER BY attempt_number DESC"
    );
    let mut stmt = conn.prepare(&sql).map_err(|e| e.to_string())?;
    let result: Vec<UserTestSession> = stmt
        .query_map(params![test_id, user_id], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn insert(db: &Database, s: &NewUserTestSession) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "INSERT INTO user_test_sessions (id, user_id, test_id, test_type, attempt_number) \
         VALUES (?1, ?2, ?3, ?4, ?5)",
        params![s.id, s.user_id, s.test_id, s.test_type, s.attempt_number],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn update(db: &Database, id: &str, user_id: &str, u: &UpdateUserTestSession) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "UPDATE user_test_sessions SET \
         status = COALESCE(?1, status), progress_percent = COALESCE(?2, progress_percent), \
         score_band = COALESCE(?3, score_band), answers = COALESCE(?4, answers), \
         feedback_data = COALESCE(?5, feedback_data), completed_at = COALESCE(?6, completed_at), \
         last_active_at = COALESCE(?7, last_active_at) \
         WHERE id = ?8 AND user_id = ?9",
        params![u.status, u.progress_percent, u.score_band, u.answers, u.feedback_data,
                u.completed_at, u.last_active_at, id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn delete(db: &Database, id: &str, user_id: &str) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "DELETE FROM user_test_sessions WHERE id = ?1 AND user_id = ?2",
        params![id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

fn map_row(row: &rusqlite::Row) -> rusqlite::Result<UserTestSession> {
    Ok(UserTestSession {
        id: row.get(0)?,
        user_id: row.get(1)?,
        test_id: row.get(2)?,
        test_type: row.get(3)?,
        status: row.get(4)?,
        progress_percent: row.get(5)?,
        score_band: row.get(6)?,
        attempt_number: row.get(7)?,
        answers: row.get(8)?,
        feedback_data: row.get(9)?,
        started_at: row.get(10)?,
        completed_at: row.get(11)?,
        last_active_at: row.get(12)?,
        created_at: row.get(13)?,
    })
}
