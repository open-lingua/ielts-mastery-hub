use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct UserTestSession {
    pub id: String,
    pub user_id: String,
    pub test_id: String,
    pub test_type: String,
    pub status: String,
    pub progress_percent: i64,
    pub score_band: Option<f64>,
    pub attempt_number: i64,
    pub answers: Option<String>,
    pub feedback_data: Option<String>,
    pub started_at: String,
    pub completed_at: Option<String>,
    pub last_active_at: String,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateUserTestSession {
    pub test_id: String,
    pub test_type: String,
    pub attempt_number: Option<i64>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateUserTestSession {
    pub status: Option<String>,
    pub progress_percent: Option<i64>,
    pub score_band: Option<f64>,
    pub answers: Option<String>,
    pub feedback_data: Option<String>,
    pub completed_at: Option<String>,
    pub last_active_at: Option<String>,
}
