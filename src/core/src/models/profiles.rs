use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct Profile {
    pub id: String,
    pub full_name: Option<String>,
    pub avatar_url: Option<String>,
    pub plan_type: String,
    pub email: Option<String>,
    pub is_banned: bool,
    pub ban_reason: Option<String>,
    pub banned_until: Option<String>,
    pub updated_at: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateProfile {
    pub full_name: Option<String>,
    pub avatar_url: Option<String>,
    pub plan_type: Option<String>,
    pub email: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateProfile {
    pub full_name: Option<String>,
    pub avatar_url: Option<String>,
    pub plan_type: Option<String>,
    pub email: Option<String>,
    pub is_banned: Option<bool>,
    pub ban_reason: Option<String>,
    pub banned_until: Option<String>,
}
