use crate::db::Database;
use rusqlite::params;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct WritingTask {
    pub id: String,
    pub test_id: String,
    pub task_number: i32,
    pub task_type: String,
    pub title: String,
    pub difficulty: String,
    pub suggested_time: String,
    pub prompt: String,
    pub min_words: i32,
    pub max_words: Option<String>,
    pub image_url: Option<String>,
    pub include_model_answer: bool,
    pub model_answer: Option<String>,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct NewWritingTask {
    pub id: String,
    pub test_id: String,
    pub task_number: i32,
    pub task_type: String,
    pub title: String,
    pub difficulty: String,
    pub suggested_time: String,
    pub prompt: String,
    pub min_words: i32,
    pub max_words: Option<String>,
    pub image_url: Option<String>,
    pub include_model_answer: bool,
    pub model_answer: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateWritingTask {
    pub task_number: Option<i32>,
    pub task_type: Option<String>,
    pub title: Option<String>,
    pub difficulty: Option<String>,
    pub suggested_time: Option<String>,
    pub prompt: Option<String>,
    pub min_words: Option<i32>,
    pub max_words: Option<String>,
    pub image_url: Option<String>,
    pub include_model_answer: Option<bool>,
    pub model_answer: Option<String>,
}

const SELECT_COLS: &str =
    "wt.id, wt.test_id, wt.task_number, wt.task_type, wt.title, wt.difficulty, \
     wt.suggested_time, wt.prompt, wt.min_words, wt.max_words, wt.image_url, \
     wt.include_model_answer, wt.model_answer, wt.created_at";

pub fn find_by_test(db: &Database, test_id: &str, user_id: &str) -> Result<Vec<WritingTask>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let sql = format!(
        "SELECT {SELECT_COLS} FROM writing_tasks wt JOIN writing_tests t ON t.id = wt.test_id \
         WHERE wt.test_id = ?1 AND (t.created_by = ?2 OR t.status = 'published') ORDER BY wt.task_number"
    );
    let mut stmt = conn.prepare(&sql).map_err(|e| e.to_string())?;
    let result: Vec<WritingTask> = stmt
        .query_map(params![test_id, user_id], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn find_by_id(db: &Database, id: &str, user_id: &str) -> Result<Option<WritingTask>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let sql = format!(
        "SELECT {SELECT_COLS} FROM writing_tasks wt JOIN writing_tests t ON t.id = wt.test_id \
         WHERE wt.id = ?1 AND (t.created_by = ?2 OR t.status = 'published')"
    );
    let mut stmt = conn.prepare(&sql).map_err(|e| e.to_string())?;
    let result: Option<WritingTask> = stmt
        .query_map(params![id, user_id], map_row)
        .map_err(|e| e.to_string())?
        .next()
        .transpose()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn find_all(db: &Database, user_id: &str) -> Result<Vec<WritingTask>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let sql = format!(
        "SELECT {SELECT_COLS} FROM writing_tasks wt JOIN writing_tests t ON t.id = wt.test_id \
         WHERE t.created_by = ?1 OR t.status = 'published'"
    );
    let mut stmt = conn.prepare(&sql).map_err(|e| e.to_string())?;
    let result: Vec<WritingTask> = stmt
        .query_map(params![user_id], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn insert(db: &Database, task: &NewWritingTask, user_id: &str) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let owned: i64 = conn
        .query_row(
            "SELECT COUNT(*) FROM writing_tests WHERE id = ?1 AND created_by = ?2",
            params![task.test_id, user_id],
            |row| row.get(0),
        )
        .map_err(|e| e.to_string())?;
    if owned == 0 {
        return Err("not authorized".to_string());
    }
    conn.execute(
        "INSERT INTO writing_tasks \
         (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt, \
          min_words, max_words, image_url, include_model_answer, model_answer) \
         VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12, ?13)",
        params![task.id, task.test_id, task.task_number, task.task_type, task.title,
                task.difficulty, task.suggested_time, task.prompt, task.min_words,
                task.max_words, task.image_url, task.include_model_answer as i32, task.model_answer],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn update(db: &Database, id: &str, user_id: &str, u: &UpdateWritingTask) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "UPDATE writing_tasks SET \
         task_number = COALESCE(?1, task_number), task_type = COALESCE(?2, task_type), \
         title = COALESCE(?3, title), difficulty = COALESCE(?4, difficulty), \
         suggested_time = COALESCE(?5, suggested_time), prompt = COALESCE(?6, prompt), \
         min_words = COALESCE(?7, min_words), max_words = COALESCE(?8, max_words), \
         image_url = COALESCE(?9, image_url), \
         include_model_answer = COALESCE(?10, include_model_answer), \
         model_answer = COALESCE(?11, model_answer) \
         WHERE id = ?12 AND EXISTS (SELECT 1 FROM writing_tests t WHERE t.id = test_id AND t.created_by = ?13)",
        params![u.task_number, u.task_type, u.title, u.difficulty, u.suggested_time, u.prompt,
                u.min_words, u.max_words, u.image_url,
                u.include_model_answer.map(|b| b as i32), u.model_answer, id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn delete(db: &Database, id: &str, user_id: &str) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "DELETE FROM writing_tasks WHERE id = ?1 \
         AND EXISTS (SELECT 1 FROM writing_tests t WHERE t.id = test_id AND t.created_by = ?2)",
        params![id, user_id],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

fn map_row(row: &rusqlite::Row) -> rusqlite::Result<WritingTask> {
    Ok(WritingTask {
        id: row.get(0)?,
        test_id: row.get(1)?,
        task_number: row.get(2)?,
        task_type: row.get(3)?,
        title: row.get(4)?,
        difficulty: row.get(5)?,
        suggested_time: row.get(6)?,
        prompt: row.get(7)?,
        min_words: row.get(8)?,
        max_words: row.get(9)?,
        image_url: row.get(10)?,
        include_model_answer: row.get::<_, i32>(11)? != 0,
        model_answer: row.get(12)?,
        created_at: row.get(13)?,
    })
}
