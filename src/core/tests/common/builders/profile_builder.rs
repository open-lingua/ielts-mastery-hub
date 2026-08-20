use app_lib::models::profiles::{CreateProfile, UpdateProfile};

const DEFAULT_FULL_NAME: &str = "Ada Lovelace";
const DEFAULT_PLAN_TYPE: &str = "free";
const DEFAULT_EMAIL: &str = "ada@example.com";

/// Builder for `CreateProfile`.
pub struct CreateProfileBuilder {
    full_name: Option<String>,
    avatar_url: Option<String>,
    plan_type: Option<String>,
    email: Option<String>,
}

impl Default for CreateProfileBuilder {
    fn default() -> Self {
        Self {
            full_name: Some(DEFAULT_FULL_NAME.to_string()),
            avatar_url: None,
            plan_type: Some(DEFAULT_PLAN_TYPE.to_string()),
            email: Some(DEFAULT_EMAIL.to_string()),
        }
    }
}

impl CreateProfileBuilder {
    pub fn with_full_name(mut self, full_name: &str) -> Self {
        self.full_name = Some(full_name.to_string());
        self
    }

    pub fn with_avatar_url(mut self, avatar_url: &str) -> Self {
        self.avatar_url = Some(avatar_url.to_string());
        self
    }

    pub fn with_plan_type(mut self, plan_type: &str) -> Self {
        self.plan_type = Some(plan_type.to_string());
        self
    }

    pub fn with_email(mut self, email: &str) -> Self {
        self.email = Some(email.to_string());
        self
    }

    pub fn build(self) -> CreateProfile {
        CreateProfile {
            full_name: self.full_name,
            avatar_url: self.avatar_url,
            plan_type: self.plan_type,
            email: self.email,
        }
    }
}

pub fn default_profile() -> CreateProfile {
    CreateProfileBuilder::default().build()
}

/// Builder for `UpdateProfile`. Every field starts as `None`, meaning
/// "no change" per the repository's `COALESCE` update semantics.
#[derive(Default)]
pub struct UpdateProfileBuilder {
    full_name: Option<String>,
    avatar_url: Option<String>,
    plan_type: Option<String>,
    email: Option<String>,
    is_banned: Option<bool>,
    ban_reason: Option<String>,
    banned_until: Option<String>,
}

impl UpdateProfileBuilder {
    pub fn with_full_name(mut self, full_name: &str) -> Self {
        self.full_name = Some(full_name.to_string());
        self
    }

    pub fn with_avatar_url(mut self, avatar_url: &str) -> Self {
        self.avatar_url = Some(avatar_url.to_string());
        self
    }

    pub fn with_plan_type(mut self, plan_type: &str) -> Self {
        self.plan_type = Some(plan_type.to_string());
        self
    }

    pub fn with_email(mut self, email: &str) -> Self {
        self.email = Some(email.to_string());
        self
    }

    pub fn with_is_banned(mut self, is_banned: bool) -> Self {
        self.is_banned = Some(is_banned);
        self
    }

    pub fn with_ban_reason(mut self, ban_reason: &str) -> Self {
        self.ban_reason = Some(ban_reason.to_string());
        self
    }

    pub fn with_banned_until(mut self, banned_until: &str) -> Self {
        self.banned_until = Some(banned_until.to_string());
        self
    }

    pub fn build(self) -> UpdateProfile {
        UpdateProfile {
            full_name: self.full_name,
            avatar_url: self.avatar_url,
            plan_type: self.plan_type,
            email: self.email,
            is_banned: self.is_banned,
            ban_reason: self.ban_reason,
            banned_until: self.banned_until,
        }
    }
}
