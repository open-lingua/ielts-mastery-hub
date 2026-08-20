use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct UserRole {
    pub id: String,
    pub user_id: String,
    pub role: String,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateUserRole {
    pub user_id: String,
    pub role: String,
}

#[derive(Debug, Deserialize)]
pub struct UpdateUserRole {
    pub role: Option<String>,
}
