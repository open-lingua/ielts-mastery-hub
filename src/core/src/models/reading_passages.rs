use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct ReadingPassage {
    pub id: String,
    pub test_id: String,
    pub passage_number: i64,
    pub title: String,
    pub content: String,
    pub notes: Option<String>,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateReadingPassage {
    pub test_id: String,
    pub passage_number: Option<i64>,
    pub title: Option<String>,
    pub content: Option<String>,
    pub notes: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateReadingPassage {
    pub passage_number: Option<i64>,
    pub title: Option<String>,
    pub content: Option<String>,
    pub notes: Option<String>,
}
