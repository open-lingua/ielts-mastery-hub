use serde::{Deserialize, Serialize};

use crate::db::Db;
use crate::error::AppError;

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct ReadingQuestion {
    pub id: String,
    pub group_id: String,
    pub question_order: i64,
    pub text: String,
    pub answer: Option<String>,
    pub options: String,
    pub matching_pairs: String,
    pub completion_gaps: String,
    pub accepted_answers: String,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateReadingQuestion {
    pub group_id: String,
    pub question_order: Option<i64>,
    pub text: Option<String>,
    pub answer: Option<String>,
    pub options: Option<String>,
    pub matching_pairs: Option<String>,
    pub completion_gaps: Option<String>,
    pub accepted_answers: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateReadingQuestion {
    pub question_order: Option<i64>,
    pub text: Option<String>,
    pub answer: Option<String>,
    pub options: Option<String>,
    pub matching_pairs: Option<String>,
    pub completion_gaps: Option<String>,
    pub accepted_answers: Option<String>,
}

pub async fn find_by_id(
    pool: &Db,
    id: &str,
    user_id: &str,
) -> Result<Option<ReadingQuestion>, AppError> {
    let result = sqlx::query_as!(
        ReadingQuestion,
        "SELECT q.id, q.group_id, q.question_order, q.text, q.answer, q.options,
         q.matching_pairs, q.completion_gaps, q.accepted_answers, q.created_at
         FROM reading_questions q
         JOIN reading_question_groups g ON g.id = q.group_id
         JOIN reading_passages p ON p.id = g.passage_id
         JOIN reading_tests t ON t.id = p.test_id
         WHERE q.id = ? AND (t.created_by = ? OR t.status = 'published')",
        id,
        user_id
    )
    .fetch_optional(pool)
    .await?;
    Ok(result)
}

pub async fn find_all(pool: &Db, user_id: &str) -> Result<Vec<ReadingQuestion>, AppError> {
    let result = sqlx::query_as!(
        ReadingQuestion,
        "SELECT q.id, q.group_id, q.question_order, q.text, q.answer, q.options,
         q.matching_pairs, q.completion_gaps, q.accepted_answers, q.created_at
         FROM reading_questions q
         JOIN reading_question_groups g ON g.id = q.group_id
         JOIN reading_passages p ON p.id = g.passage_id
         JOIN reading_tests t ON t.id = p.test_id
         WHERE t.created_by = ? OR t.status = 'published'",
        user_id
    )
    .fetch_all(pool)
    .await?;
    Ok(result)
}

pub async fn insert(
    pool: &Db,
    input: &CreateReadingQuestion,
    user_id: &str,
) -> Result<String, AppError> {
    let owned: i64 = sqlx::query_scalar!(
        "SELECT COUNT(*) FROM reading_question_groups g
         JOIN reading_passages p ON p.id = g.passage_id
         JOIN reading_tests t ON t.id = p.test_id
         WHERE g.id = ? AND t.created_by = ?",
        input.group_id,
        user_id
    )
    .fetch_one(pool)
    .await?;
    if owned == 0 {
        return Err(AppError::Validation("not authorized".to_string()));
    }
    let id = uuid::Uuid::new_v4().to_string();
    let now = chrono::Utc::now().to_rfc3339();
    let question_order = input.question_order.unwrap_or(0);
    let text = input.text.as_deref().unwrap_or("");
    let options = input.options.as_deref().unwrap_or("[]");
    let matching_pairs = input.matching_pairs.as_deref().unwrap_or("[]");
    let completion_gaps = input.completion_gaps.as_deref().unwrap_or("[]");
    let accepted_answers = input.accepted_answers.as_deref().unwrap_or("[]");
    sqlx::query!(
        "INSERT INTO reading_questions
         (id, group_id, question_order, text, answer, options, matching_pairs, completion_gaps, accepted_answers, created_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        id,
        input.group_id,
        question_order,
        text,
        input.answer,
        options,
        matching_pairs,
        completion_gaps,
        accepted_answers,
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
    input: &UpdateReadingQuestion,
) -> Result<(), AppError> {
    sqlx::query!(
        "UPDATE reading_questions SET
         question_order = COALESCE(?, question_order),
         text = COALESCE(?, text),
         answer = COALESCE(?, answer),
         options = COALESCE(?, options),
         matching_pairs = COALESCE(?, matching_pairs),
         completion_gaps = COALESCE(?, completion_gaps),
         accepted_answers = COALESCE(?, accepted_answers)
         WHERE id = ? AND EXISTS (
           SELECT 1 FROM reading_question_groups g
           JOIN reading_passages p ON p.id = g.passage_id
           JOIN reading_tests t ON t.id = p.test_id
           WHERE g.id = group_id AND t.created_by = ?
         )",
        input.question_order,
        input.text,
        input.answer,
        input.options,
        input.matching_pairs,
        input.completion_gaps,
        input.accepted_answers,
        id,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}

pub async fn delete(pool: &Db, id: &str, user_id: &str) -> Result<(), AppError> {
    sqlx::query!(
        "DELETE FROM reading_questions WHERE id = ? AND EXISTS (
           SELECT 1 FROM reading_question_groups g
           JOIN reading_passages p ON p.id = g.passage_id
           JOIN reading_tests t ON t.id = p.test_id
           WHERE g.id = group_id AND t.created_by = ?
         )",
        id,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}
