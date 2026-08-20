use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct ListeningQuestionGroup {
    pub id: String,
    pub section_id: String,
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
pub struct CreateListeningQuestionGroup {
    pub section_id: String,
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
pub struct UpdateListeningQuestionGroup {
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
