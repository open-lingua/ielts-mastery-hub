use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct ReadingTest {
    pub id: String,
    pub created_by: String,
    pub title: String,
    pub test_type: String,
    pub difficulty: String,
    pub duration: String,
    pub status: String,
    pub created_at: String,
    pub updated_at: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateReadingTest {
    pub title: Option<String>,
    pub test_type: Option<String>,
    pub difficulty: Option<String>,
    pub duration: Option<String>,
    pub status: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateReadingTest {
    pub title: Option<String>,
    pub test_type: Option<String>,
    pub difficulty: Option<String>,
    pub duration: Option<String>,
    pub status: Option<String>,
}
