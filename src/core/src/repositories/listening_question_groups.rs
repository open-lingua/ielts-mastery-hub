use crate::db::Database;
use rusqlite::params;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct ListeningQuestionGroup {
    pub id: String,
    pub section_id: String,
    pub group_order: i32,
    pub question_type: String,
    pub instructions: String,
    pub word_limit: Option<String>,
    pub has_word_bank: bool,
    pub word_bank: String,
    pub sequential_order: bool,
    pub multiple_selection: bool,
    pub select_count: i32,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct NewListeningQuestionGroup {
    pub id: String,
    pub section_id: String,
    pub group_order: i32,
    pub question_type: String,
    pub instructions: String,
    pub word_limit: Option<String>,
    pub has_word_bank: bool,
    pub word_bank: String,
    pub sequential_order: bool,
    pub multiple_selection: bool,
    pub select_count: i32,
}

#[derive(Debug, Deserialize)]
pub struct UpdateListeningQuestionGroup {
    pub group_order: Option<i32>,
    pub question_type: Option<String>,
    pub instructions: Option<String>,
    pub word_limit: Option<String>,
    pub has_word_bank: Option<bool>,
    pub word_bank: Option<String>,
    pub sequential_order: Option<bool>,
    pub multiple_selection: Option<bool>,
    pub select_count: Option<i32>,
}

const SELECT_COLS: &str =
    "g.id, g.section_id, g.group_order, g.question_type, g.instructions, \
     g.word_limit, g.has_word_bank, g.word_bank, g.sequential_order, g.multiple_selection, \
     g.select_count, g.created_at";

const JOIN_OWNERSHIP: &str =
    "JOIN listening_sections s ON s.id = g.section_id \
     JOIN listening_tests t ON t.id = s.test_id";

pub fn find_by_section(db: &Database, section_id: &str, user_id: &str) -> Result<Vec<ListeningQuestionGroup>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let sql = format!(
        "SELECT {SELECT_COLS} FROM listening_question_groups g {JOIN_OWNERSHIP} \
         WHERE g.section_id = ?1 AND (t.created_by = ?2 OR t.status = 'published') ORDER BY g.group_order"
    );
    let mut stmt = conn.prepare(&sql).map_err(|e| e.to_string())?;
    let result: Vec<ListeningQuestionGroup> = stmt
        .query_map(params![section_id, user_id], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn find_by_id(db: &Database, id: &str, user_id: &str) -> Result<Option<ListeningQuestionGroup>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let sql = format!(
        "SELECT {SELECT_COLS} FROM listening_question_groups g {JOIN_OWNERSHIP} \
         WHERE g.id = ?1 AND (t.created_by = ?2 OR t.status = 'published')"
    );
    let mut stmt = conn.prepare(&sql).map_err(|e| e.to_string())?;
    let result: Option<ListeningQuestionGroup> = stmt
        .query_map(params![id, user_id], map_row)
        .map_err(|e| e.to_string())?
        .next()
        .transpose()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn find_all(db: &Database, user_id: &str) -> Result<Vec<ListeningQuestionGroup>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let sql = format!(
        "SELECT {SELECT_COLS} FROM listening_question_groups g {JOIN_OWNERSHIP} \
         WHERE t.created_by = ?1 OR t.status = 'published'"
    );
    let mut stmt = conn.prepare(&sql).map_err(|e| e.to_string())?;
    let result: Vec<ListeningQuestionGroup> = stmt
        .query_map(params![user_id], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn insert(db: &Database, g: &NewListeningQuestionGroup, user_id: &str) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let owned: i64 = conn
        .query_row(
            "SELECT COUNT(*) FROM listening_sections s JOIN listening_tests t ON t.id = s.test_id \
             WHERE s.id = ?1 AND t.created_by = ?2",
            params![g.section_id, user_id],
            |row| row.get(0),
        )
        .map_err(|e| e.to_string())?;
    if owned == 0 {
        return Err("not authorized".to_string());
    }
    conn.execute(
        "INSERT INTO listening_question_groups \
         (id, section_id, group_order, question_type, instructions, word_limit, has_word_bank, word_bank, sequential_order, multiple_selection, select_count) \
         VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11)",
        params![g.id, g.section_id, g.group_order, g.question_type, g.instructions, g.word_limit,
                g.has_word_bank as i32, g.word_bank, g.sequential_order as i32, g.multiple_selection as i32, g.select_count],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn update(db: &Database, id: &str, user_id: &str, u: &UpdateListeningQuestionGroup) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "UPDATE listening_question_groups SET \
         group_order = COALESCE(?1, group_order), question_type = COALESCE(?2, question_type), \
         instructions = COALESCE(?3, instructions), word_limit = COALESCE(?4, word_limit), \
         has_word_bank = COALESCE(?5, has_word_bank), word_bank = COALESCE(?6, word_bank), \
         sequential_order = COALESCE(?7, sequential_order), multiple_selection = COALESCE(?8, multiple_selection), \
         select_count = COALESCE(?9, select_count) \
         WHERE id = ?10 AND EXISTS ( \
           SELECT 1 FROM listening_sections s JOIN listening_tests t ON t.id = s.test_id \
           WHERE s.id = section_id AND t.created_by = ?11)",
        params![u.group_order, u.question_type, u.instructions, u.word_limit,
                u.has_word_bank.map(|b| b as i32), u.word_bank,
                u.sequential_order.map(|b| b as i32), u.multiple_selection.map(|b| b as i32),
                u.select_count, id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn delete(db: &Database, id: &str, user_id: &str) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "DELETE FROM listening_question_groups WHERE id = ?1 AND EXISTS ( \
         SELECT 1 FROM listening_sections s JOIN listening_tests t ON t.id = s.test_id \
         WHERE s.id = section_id AND t.created_by = ?2)",
        params![id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

fn map_row(row: &rusqlite::Row) -> rusqlite::Result<ListeningQuestionGroup> {
    Ok(ListeningQuestionGroup {
        id: row.get(0)?,
        section_id: row.get(1)?,
        group_order: row.get(2)?,
        question_type: row.get(3)?,
        instructions: row.get(4)?,
        word_limit: row.get(5)?,
        has_word_bank: row.get::<_, i32>(6)? != 0,
        word_bank: row.get(7)?,
        sequential_order: row.get::<_, i32>(8)? != 0,
        multiple_selection: row.get::<_, i32>(9)? != 0,
        select_count: row.get(10)?,
        created_at: row.get(11)?,
    })
}
