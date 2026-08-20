use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct ListeningQuestion {
    pub id: String,
    pub group_id: String,
    pub question_order: i64,
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
pub struct CreateListeningQuestion {
    pub group_id: String,
    pub question_order: Option<i64>,
    pub text: Option<String>,
    pub answer: Option<String>,
    pub options: Option<String>,
    pub matching_pairs: Option<String>,
    pub completion_gaps: Option<String>,
    pub accepted_answers: Option<String>,
    pub timestamp: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateListeningQuestion {
    pub question_order: Option<i64>,
    pub text: Option<String>,
    pub answer: Option<String>,
    pub options: Option<String>,
    pub matching_pairs: Option<String>,
    pub completion_gaps: Option<String>,
    pub accepted_answers: Option<String>,
    pub timestamp: Option<String>,
}
