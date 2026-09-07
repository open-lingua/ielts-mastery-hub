use serde::{Deserialize, Serialize};

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
    pub figure_description: Option<String>,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateWritingTask {
    pub id: Option<String>,
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
    pub figure_description: Option<String>,
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
    pub figure_description: Option<String>,
}
