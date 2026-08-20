use app_lib::models::listening_tests::{CreateListeningTest, UpdateListeningTest};

const DEFAULT_TITLE: &str = "Sample Listening Test";
const DEFAULT_DIFFICULTY: &str = "7";
const DEFAULT_DURATION: &str = "40 mins";
const DEFAULT_STATUS: &str = "draft";

/// Builder for `CreateListeningTest`.
pub struct CreateListeningTestBuilder {
    title: Option<String>,
    difficulty: Option<String>,
    duration: Option<String>,
    status: Option<String>,
}

impl Default for CreateListeningTestBuilder {
    fn default() -> Self {
        Self {
            title: Some(DEFAULT_TITLE.to_string()),
            difficulty: Some(DEFAULT_DIFFICULTY.to_string()),
            duration: Some(DEFAULT_DURATION.to_string()),
            status: Some(DEFAULT_STATUS.to_string()),
        }
    }
}

impl CreateListeningTestBuilder {
    pub fn with_title(mut self, title: &str) -> Self {
        self.title = Some(title.to_string());
        self
    }

    pub fn with_difficulty(mut self, difficulty: &str) -> Self {
        self.difficulty = Some(difficulty.to_string());
        self
    }

    pub fn with_duration(mut self, duration: &str) -> Self {
        self.duration = Some(duration.to_string());
        self
    }

    pub fn with_status(mut self, status: &str) -> Self {
        self.status = Some(status.to_string());
        self
    }

    pub fn build(self) -> CreateListeningTest {
        CreateListeningTest {
            title: self.title,
            difficulty: self.difficulty,
            duration: self.duration,
            status: self.status,
        }
    }
}

pub fn default_listening_test() -> CreateListeningTest {
    CreateListeningTestBuilder::default().build()
}

/// Builder for `UpdateListeningTest`. Every field starts as `None`, meaning
/// "no change" per the repository's `COALESCE` update semantics.
#[derive(Default)]
pub struct UpdateListeningTestBuilder {
    title: Option<String>,
    difficulty: Option<String>,
    duration: Option<String>,
    status: Option<String>,
}

impl UpdateListeningTestBuilder {
    pub fn with_title(mut self, title: &str) -> Self {
        self.title = Some(title.to_string());
        self
    }

    pub fn with_difficulty(mut self, difficulty: &str) -> Self {
        self.difficulty = Some(difficulty.to_string());
        self
    }

    pub fn with_duration(mut self, duration: &str) -> Self {
        self.duration = Some(duration.to_string());
        self
    }

    pub fn with_status(mut self, status: &str) -> Self {
        self.status = Some(status.to_string());
        self
    }

    pub fn build(self) -> UpdateListeningTest {
        UpdateListeningTest {
            title: self.title,
            difficulty: self.difficulty,
            duration: self.duration,
            status: self.status,
        }
    }
}
