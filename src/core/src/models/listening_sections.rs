use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct ListeningSection {
    pub id: String,
    pub test_id: String,
    pub section_number: i64,
    pub title: String,
    pub transcript: Option<String>,
    pub audio_url: Option<String>,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateListeningSection {
    pub test_id: String,
    pub section_number: Option<i64>,
    pub title: Option<String>,
    pub transcript: Option<String>,
    pub audio_url: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateListeningSection {
    pub section_number: Option<i64>,
    pub title: Option<String>,
    pub transcript: Option<String>,
    pub audio_url: Option<String>,
}
