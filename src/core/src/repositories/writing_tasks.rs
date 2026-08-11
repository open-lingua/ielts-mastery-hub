use serde::{Deserialize, Serialize};

use crate::database::Db;
use crate::error::AppError;

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct WritingTask {
    pub id: String,
    pub test_id: String,
    pub task_number: i64,
    pub task_type: String,
    pub title: String,
    pub difficulty: String,
    pub suggested_time: String,
    pub prompt: String,
    pub min_words: i64,
    pub max_words: Option<String>,
    pub image_url: Option<String>,
    pub include_model_answer: bool,
    pub model_answer: Option<String>,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateWritingTask {
    pub test_id: String,
    pub task_number: Option<i64>,
    pub task_type: Option<String>,
    pub title: Option<String>,
    pub difficulty: Option<String>,
    pub suggested_time: Option<String>,
    pub prompt: Option<String>,
    pub min_words: Option<i64>,
    pub max_words: Option<String>,
    pub image_url: Option<String>,
    pub include_model_answer: Option<bool>,
    pub model_answer: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateWritingTask {
    pub task_number: Option<i64>,
    pub task_type: Option<String>,
    pub title: Option<String>,
    pub difficulty: Option<String>,
    pub suggested_time: Option<String>,
    pub prompt: Option<String>,
    pub min_words: Option<i64>,
    pub max_words: Option<String>,
    pub image_url: Option<String>,
    pub include_model_answer: Option<bool>,
    pub model_answer: Option<String>,
}

pub async fn find_by_id(
    pool: &Db,
    id: &str,
    user_id: &str,
) -> Result<Option<WritingTask>, AppError> {
    let result = sqlx::query_as!(
        WritingTask,
        r#"SELECT wt.id, wt.test_id, wt.task_number, wt.task_type, wt.title, wt.difficulty,
           wt.suggested_time, wt.prompt, wt.min_words, wt.max_words, wt.image_url,
           wt.include_model_answer AS "include_model_answer: bool", wt.model_answer, wt.created_at
           FROM writing_tasks wt JOIN writing_tests t ON t.id = wt.test_id
           WHERE wt.id = ? AND (t.created_by = ? OR t.status = 'published')"#,
        id,
        user_id
    )
    .fetch_optional(pool)
    .await?;
    Ok(result)
}

pub async fn find_all(pool: &Db, user_id: &str) -> Result<Vec<WritingTask>, AppError> {
    let result = sqlx::query_as!(
        WritingTask,
        r#"SELECT wt.id, wt.test_id, wt.task_number, wt.task_type, wt.title, wt.difficulty,
           wt.suggested_time, wt.prompt, wt.min_words, wt.max_words, wt.image_url,
           wt.include_model_answer AS "include_model_answer: bool", wt.model_answer, wt.created_at
           FROM writing_tasks wt JOIN writing_tests t ON t.id = wt.test_id
           WHERE t.created_by = ? OR t.status = 'published'"#,
        user_id
    )
    .fetch_all(pool)
    .await?;
    Ok(result)
}

pub async fn insert(
    pool: &Db,
    input: &CreateWritingTask,
    user_id: &str,
) -> Result<String, AppError> {
    let owned: i64 = sqlx::query_scalar!(
        "SELECT COUNT(*) FROM writing_tests WHERE id = ? AND created_by = ?",
        input.test_id,
        user_id
    )
    .fetch_one(pool)
    .await?;
    if owned == 0 {
        return Err(AppError::Validation("not authorized".to_string()));
    }
    let id = uuid::Uuid::new_v4().to_string();
    let now = chrono::Utc::now().to_rfc3339();
    let task_number = input.task_number.unwrap_or(1);
    let task_type = input.task_type.as_deref().unwrap_or("task1");
    let title = input.title.as_deref().unwrap_or("");
    let difficulty = input.difficulty.as_deref().unwrap_or("7");
    let suggested_time = input.suggested_time.as_deref().unwrap_or("20 mins");
    let prompt = input.prompt.as_deref().unwrap_or("");
    let min_words = input.min_words.unwrap_or(150);
    let include_model_answer = input.include_model_answer.unwrap_or(false) as i64;
    sqlx::query!(
        "INSERT INTO writing_tasks
         (id, test_id, task_number, task_type, title, difficulty, suggested_time, prompt,
          min_words, max_words, image_url, include_model_answer, model_answer, created_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        id,
        input.test_id,
        task_number,
        task_type,
        title,
        difficulty,
        suggested_time,
        prompt,
        min_words,
        input.max_words,
        input.image_url,
        include_model_answer,
        input.model_answer,
        now
    )
    .execute(pool)
    .await?;
    Ok(id)
}

pub async fn update(
    pool: &Db,
    id: &str,
    user_id: &str,
    input: &UpdateWritingTask,
) -> Result<(), AppError> {
    let include_model_answer = input.include_model_answer.map(|b| b as i64);
    sqlx::query!(
        "UPDATE writing_tasks SET
         task_number = COALESCE(?, task_number),
         task_type = COALESCE(?, task_type),
         title = COALESCE(?, title),
         difficulty = COALESCE(?, difficulty),
         suggested_time = COALESCE(?, suggested_time),
         prompt = COALESCE(?, prompt),
         min_words = COALESCE(?, min_words),
         max_words = COALESCE(?, max_words),
         image_url = COALESCE(?, image_url),
         include_model_answer = COALESCE(?, include_model_answer),
         model_answer = COALESCE(?, model_answer)
         WHERE id = ? AND EXISTS (
           SELECT 1 FROM writing_tests t WHERE t.id = test_id AND t.created_by = ?
         )",
        input.task_number,
        input.task_type,
        input.title,
        input.difficulty,
        input.suggested_time,
        input.prompt,
        input.min_words,
        input.max_words,
        input.image_url,
        include_model_answer,
        input.model_answer,
        id,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}

pub async fn delete(pool: &Db, id: &str, user_id: &str) -> Result<(), AppError> {
    sqlx::query!(
        "DELETE FROM writing_tasks WHERE id = ? AND EXISTS (
           SELECT 1 FROM writing_tests t WHERE t.id = test_id AND t.created_by = ?
         )",
        id,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}
