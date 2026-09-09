use app_lib::models::user_test_sessions::{CreateUserTestSession, UpdateUserTestSession};

const DEFAULT_ATTEMPT_NUMBER: i64 = 1;

/// Builder for `CreateUserTestSession`.
pub struct CreateUserTestSessionBuilder {
    test_id: String,
    test_type: String,
    attempt_number: Option<i64>,
}

impl Default for CreateUserTestSessionBuilder {
    fn default() -> Self {
        Self {
            test_id: "placeholder-test-id".to_string(),
            test_type: "reading".to_string(),
            attempt_number: Some(DEFAULT_ATTEMPT_NUMBER),
        }
    }
}

impl CreateUserTestSessionBuilder {
    pub fn with_test_id(mut self, test_id: &str) -> Self {
        self.test_id = test_id.to_string();
        self
    }

    pub fn with_test_type(mut self, test_type: &str) -> Self {
        self.test_type = test_type.to_string();
        self
    }

    pub fn with_attempt_number(mut self, attempt_number: i64) -> Self {
        self.attempt_number = Some(attempt_number);
        self
    }

    pub fn build(self) -> CreateUserTestSession {
        CreateUserTestSession {
            test_id: self.test_id,
            test_type: self.test_type,
            attempt_number: self.attempt_number,
        }
    }
}

pub fn default_user_test_session() -> CreateUserTestSession {
    CreateUserTestSessionBuilder::default().build()
}

/// Builder for `UpdateUserTestSession`. Every field starts as `None`, meaning
/// "no change" per the repository's `COALESCE` update semantics.
#[derive(Default)]
pub struct UpdateUserTestSessionBuilder {
    status: Option<String>,
    progress_percent: Option<i64>,
    score_band: Option<f64>,
    answers: Option<String>,
    feedback_data: Option<String>,
    completed_at: Option<String>,
    last_active_at: Option<String>,
}

impl UpdateUserTestSessionBuilder {
    pub fn with_status(mut self, status: &str) -> Self {
        self.status = Some(status.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_progress_percent(mut self, progress_percent: i64) -> Self {
        self.progress_percent = Some(progress_percent);
        self
    }

    #[allow(dead_code)]
    pub fn with_score_band(mut self, score_band: f64) -> Self {
        self.score_band = Some(score_band);
        self
    }

    #[allow(dead_code)]
    pub fn with_answers(mut self, answers: &str) -> Self {
        self.answers = Some(answers.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_feedback_data(mut self, feedback_data: &str) -> Self {
        self.feedback_data = Some(feedback_data.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_completed_at(mut self, completed_at: &str) -> Self {
        self.completed_at = Some(completed_at.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_last_active_at(mut self, last_active_at: &str) -> Self {
        self.last_active_at = Some(last_active_at.to_string());
        self
    }

    pub fn build(self) -> UpdateUserTestSession {
        UpdateUserTestSession {
            status: self.status,
            progress_percent: self.progress_percent,
            score_band: self.score_band,
            answers: self.answers,
            feedback_data: self.feedback_data,
            completed_at: self.completed_at,
            last_active_at: self.last_active_at,
        }
    }
}
