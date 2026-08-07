use serde::{Deserialize, Serialize};

use crate::db::Db;
use crate::error::AppError;

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct ReadingQuestionGroup {
    pub id: String,
    pub passage_id: String,
    pub group_order: i64,
    pub question_type: String,
    pub instructions: String,
    pub word_limit: Option<String>,
    pub has_word_bank: bool,
    pub word_bank: String,
    pub sequential_order: bool,
    pub multiple_selection: bool,
    pub select_count: i64,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateReadingQuestionGroup {
    pub passage_id: String,
    pub group_order: Option<i64>,
    pub question_type: Option<String>,
    pub instructions: Option<String>,
    pub word_limit: Option<String>,
    pub has_word_bank: Option<bool>,
    pub word_bank: Option<String>,
    pub sequential_order: Option<bool>,
    pub multiple_selection: Option<bool>,
    pub select_count: Option<i64>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateReadingQuestionGroup {
    pub group_order: Option<i64>,
    pub question_type: Option<String>,
    pub instructions: Option<String>,
    pub word_limit: Option<String>,
    pub has_word_bank: Option<bool>,
    pub word_bank: Option<String>,
    pub sequential_order: Option<bool>,
    pub multiple_selection: Option<bool>,
    pub select_count: Option<i64>,
}

pub async fn find_by_id(pool: &Db, id: &str, user_id: &str) -> Result<Option<ReadingQuestionGroup>, AppError> {
    let result = sqlx::query_as!(
        ReadingQuestionGroup,
        r#"SELECT g.id, g.passage_id, g.group_order, g.question_type, g.instructions,
           g.word_limit, g.has_word_bank AS "has_word_bank: bool", g.word_bank,
           g.sequential_order AS "sequential_order: bool",
           g.multiple_selection AS "multiple_selection: bool",
           g.select_count, g.created_at
           FROM reading_question_groups g
           JOIN reading_passages p ON p.id = g.passage_id
           JOIN reading_tests t ON t.id = p.test_id
           WHERE g.id = ? AND (t.created_by = ? OR t.status = 'published')"#,
        id,
        user_id
    )
    .fetch_optional(pool)
    .await?;
    Ok(result)
}

pub async fn find_all(pool: &Db, user_id: &str) -> Result<Vec<ReadingQuestionGroup>, AppError> {
    let result = sqlx::query_as!(
        ReadingQuestionGroup,
        r#"SELECT g.id, g.passage_id, g.group_order, g.question_type, g.instructions,
           g.word_limit, g.has_word_bank AS "has_word_bank: bool", g.word_bank,
           g.sequential_order AS "sequential_order: bool",
           g.multiple_selection AS "multiple_selection: bool",
           g.select_count, g.created_at
           FROM reading_question_groups g
           JOIN reading_passages p ON p.id = g.passage_id
           JOIN reading_tests t ON t.id = p.test_id
           WHERE t.created_by = ? OR t.status = 'published'"#,
        user_id
    )
    .fetch_all(pool)
    .await?;
    Ok(result)
}

pub async fn insert(pool: &Db, input: &CreateReadingQuestionGroup, user_id: &str) -> Result<String, AppError> {
    let owned: i64 = sqlx::query_scalar!(
        "SELECT COUNT(*) FROM reading_passages p
         JOIN reading_tests t ON t.id = p.test_id
         WHERE p.id = ? AND t.created_by = ?",
        input.passage_id,
        user_id
    )
    .fetch_one(pool)
    .await?;
    if owned == 0 {
        return Err(AppError::Validation("not authorized".to_string()));
    }
    let id = uuid::Uuid::new_v4().to_string();
    let now = chrono::Utc::now().to_rfc3339();
    let group_order = input.group_order.unwrap_or(0);
    let question_type = input.question_type.as_deref().unwrap_or("multiple-choice");
    let instructions = input.instructions.as_deref().unwrap_or("");
    let word_bank = input.word_bank.as_deref().unwrap_or("[]");
    let has_word_bank = input.has_word_bank.unwrap_or(false) as i64;
    let sequential_order = input.sequential_order.unwrap_or(true) as i64;
    let multiple_selection = input.multiple_selection.unwrap_or(false) as i64;
    let select_count = input.select_count.unwrap_or(1);
    sqlx::query!(
        "INSERT INTO reading_question_groups
         (id, passage_id, group_order, question_type, instructions, word_limit,
          has_word_bank, word_bank, sequential_order, multiple_selection, select_count, created_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        id,
        input.passage_id,
        group_order,
        question_type,
        instructions,
        input.word_limit,
        has_word_bank,
        word_bank,
        sequential_order,
        multiple_selection,
        select_count,
        now
    )
    .execute(pool)
    .await?;
    Ok(id)
}

pub async fn update(pool: &Db, id: &str, user_id: &str, input: &UpdateReadingQuestionGroup) -> Result<(), AppError> {
    let has_word_bank = input.has_word_bank.map(|b| b as i64);
    let sequential_order = input.sequential_order.map(|b| b as i64);
    let multiple_selection = input.multiple_selection.map(|b| b as i64);
    sqlx::query!(
        "UPDATE reading_question_groups SET
         group_order = COALESCE(?, group_order),
         question_type = COALESCE(?, question_type),
         instructions = COALESCE(?, instructions),
         word_limit = COALESCE(?, word_limit),
         has_word_bank = COALESCE(?, has_word_bank),
         word_bank = COALESCE(?, word_bank),
         sequential_order = COALESCE(?, sequential_order),
         multiple_selection = COALESCE(?, multiple_selection),
         select_count = COALESCE(?, select_count)
         WHERE id = ? AND EXISTS (
           SELECT 1 FROM reading_passages p JOIN reading_tests t ON t.id = p.test_id
           WHERE p.id = passage_id AND t.created_by = ?
         )",
        input.group_order,
        input.question_type,
        input.instructions,
        input.word_limit,
        has_word_bank,
        input.word_bank,
        sequential_order,
        multiple_selection,
        input.select_count,
        id,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}

pub async fn delete(pool: &Db, id: &str, user_id: &str) -> Result<(), AppError> {
    sqlx::query!(
        "DELETE FROM reading_question_groups WHERE id = ? AND EXISTS (
           SELECT 1 FROM reading_passages p JOIN reading_tests t ON t.id = p.test_id
           WHERE p.id = passage_id AND t.created_by = ?
         )",
        id,
        user_id
    )
    .execute(pool)
    .await?;
    Ok(())
}
