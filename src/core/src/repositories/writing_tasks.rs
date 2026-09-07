use crate::database::Db;
use crate::error::AppError;
use crate::models::writing_tasks::{CreateWritingTask, UpdateWritingTask, WritingTask};

pub async fn find_by_id(
    pool: &Db,
    id: &str,
    user_id: &str,
) -> Result<Option<WritingTask>, AppError> {
    let result = sqlx::query_as!(
        WritingTask,
        r#"SELECT wt.id, wt.test_id, wt.task_number, wt.task_type, wt.title, wt.difficulty,
           wt.suggested_time, wt.prompt, wt.min_words, wt.max_words, wt.image_url,
           wt.include_model_answer AS "include_model_answer: bool", wt.model_answer,
           wt.figure_description, wt.created_at
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
           wt.include_model_answer AS "include_model_answer: bool", wt.model_answer,
           wt.figure_description, wt.created_at
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
    let id = input
        .id
        .clone()
        .unwrap_or_else(|| uuid::Uuid::new_v4().to_string());
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
          min_words, max_words, image_url, include_model_answer, model_answer,
          figure_description, created_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
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
        input.figure_description,
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
         model_answer = COALESCE(?, model_answer),
         figure_description = COALESCE(?, figure_description)
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
        input.figure_description,
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
