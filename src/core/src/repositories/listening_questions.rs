use crate::db::Database;
use rusqlite::params;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct ListeningQuestion {
    pub id: String,
    pub group_id: String,
    pub question_order: i32,
    pub text: String,
    pub answer: Option<String>,
    pub options: String,
    pub matching_pairs: String,
    pub completion_gaps: String,
    pub accepted_answers: String,
    pub timestamp: Option<String>,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct NewListeningQuestion {
    pub id: String,
    pub group_id: String,
    pub question_order: i32,
    pub text: String,
    pub answer: Option<String>,
    pub options: String,
    pub matching_pairs: String,
    pub completion_gaps: String,
    pub accepted_answers: String,
    pub timestamp: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateListeningQuestion {
    pub question_order: Option<i32>,
    pub text: Option<String>,
    pub answer: Option<String>,
    pub options: Option<String>,
    pub matching_pairs: Option<String>,
    pub completion_gaps: Option<String>,
    pub accepted_answers: Option<String>,
    pub timestamp: Option<String>,
}

const SELECT_COLS: &str =
    "q.id, q.group_id, q.question_order, q.text, q.answer, q.options, \
     q.matching_pairs, q.completion_gaps, q.accepted_answers, q.timestamp, q.created_at";

const JOIN_OWNERSHIP: &str =
    "JOIN listening_question_groups g ON g.id = q.group_id \
     JOIN listening_sections s ON s.id = g.section_id \
     JOIN listening_tests t ON t.id = s.test_id";

pub fn find_by_group(db: &Database, group_id: &str, user_id: &str) -> Result<Vec<ListeningQuestion>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let sql = format!(
        "SELECT {SELECT_COLS} FROM listening_questions q {JOIN_OWNERSHIP} \
         WHERE q.group_id = ?1 AND (t.created_by = ?2 OR t.status = 'published') ORDER BY q.question_order"
    );
    let mut stmt = conn.prepare(&sql).map_err(|e| e.to_string())?;
    let result: Vec<ListeningQuestion> = stmt
        .query_map(params![group_id, user_id], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn find_by_id(db: &Database, id: &str, user_id: &str) -> Result<Option<ListeningQuestion>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let sql = format!(
        "SELECT {SELECT_COLS} FROM listening_questions q {JOIN_OWNERSHIP} \
         WHERE q.id = ?1 AND (t.created_by = ?2 OR t.status = 'published')"
    );
    let mut stmt = conn.prepare(&sql).map_err(|e| e.to_string())?;
    let result: Option<ListeningQuestion> = stmt
        .query_map(params![id, user_id], map_row)
        .map_err(|e| e.to_string())?
        .next()
        .transpose()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn find_all(db: &Database, user_id: &str) -> Result<Vec<ListeningQuestion>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let sql = format!(
        "SELECT {SELECT_COLS} FROM listening_questions q {JOIN_OWNERSHIP} \
         WHERE t.created_by = ?1 OR t.status = 'published'"
    );
    let mut stmt = conn.prepare(&sql).map_err(|e| e.to_string())?;
    let result: Vec<ListeningQuestion> = stmt
        .query_map(params![user_id], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn insert(db: &Database, q: &NewListeningQuestion, user_id: &str) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let owned: i64 = conn
        .query_row(
            "SELECT COUNT(*) FROM listening_question_groups g \
             JOIN listening_sections s ON s.id = g.section_id \
             JOIN listening_tests t ON t.id = s.test_id \
             WHERE g.id = ?1 AND t.created_by = ?2",
            params![q.group_id, user_id],
            |row| row.get(0),
        )
        .map_err(|e| e.to_string())?;
    if owned == 0 {
        return Err("not authorized".to_string());
    }
    conn.execute(
        "INSERT INTO listening_questions \
         (id, group_id, question_order, text, answer, options, matching_pairs, completion_gaps, accepted_answers, timestamp) \
         VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10)",
        params![q.id, q.group_id, q.question_order, q.text, q.answer, q.options,
                q.matching_pairs, q.completion_gaps, q.accepted_answers, q.timestamp],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn update(db: &Database, id: &str, user_id: &str, u: &UpdateListeningQuestion) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "UPDATE listening_questions SET \
         question_order = COALESCE(?1, question_order), text = COALESCE(?2, text), \
         answer = COALESCE(?3, answer), options = COALESCE(?4, options), \
         matching_pairs = COALESCE(?5, matching_pairs), completion_gaps = COALESCE(?6, completion_gaps), \
         accepted_answers = COALESCE(?7, accepted_answers), timestamp = COALESCE(?8, timestamp) \
         WHERE id = ?9 AND EXISTS ( \
           SELECT 1 FROM listening_question_groups g \
           JOIN listening_sections s ON s.id = g.section_id \
           JOIN listening_tests t ON t.id = s.test_id \
           WHERE g.id = group_id AND t.created_by = ?10)",
        params![u.question_order, u.text, u.answer, u.options, u.matching_pairs,
                u.completion_gaps, u.accepted_answers, u.timestamp, id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn delete(db: &Database, id: &str, user_id: &str) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "DELETE FROM listening_questions WHERE id = ?1 AND EXISTS ( \
         SELECT 1 FROM listening_question_groups g \
         JOIN listening_sections s ON s.id = g.section_id \
         JOIN listening_tests t ON t.id = s.test_id \
         WHERE g.id = group_id AND t.created_by = ?2)",
        params![id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

fn map_row(row: &rusqlite::Row) -> rusqlite::Result<ListeningQuestion> {
    Ok(ListeningQuestion {
        id: row.get(0)?,
        group_id: row.get(1)?,
        question_order: row.get(2)?,
        text: row.get(3)?,
        answer: row.get(4)?,
        options: row.get(5)?,
        matching_pairs: row.get(6)?,
        completion_gaps: row.get(7)?,
        accepted_answers: row.get(8)?,
        timestamp: row.get(9)?,
        created_at: row.get(10)?,
    })
}
