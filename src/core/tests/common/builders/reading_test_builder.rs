use app_lib::models::reading_tests::{CreateReadingTest, UpdateReadingTest};

const DEFAULT_TITLE: &str = "Sample Reading Test";
const DEFAULT_TEST_TYPE: &str = "Academic";
const DEFAULT_DIFFICULTY: &str = "7";
const DEFAULT_DURATION: &str = "60 mins";
const DEFAULT_STATUS: &str = "draft";

/// Builder for `CreateReadingTest`.
pub struct CreateReadingTestBuilder {
    title: Option<String>,
    test_type: Option<String>,
    difficulty: Option<String>,
    duration: Option<String>,
    status: Option<String>,
}

impl Default for CreateReadingTestBuilder {
    fn default() -> Self {
        Self {
            title: Some(DEFAULT_TITLE.to_string()),
            test_type: Some(DEFAULT_TEST_TYPE.to_string()),
            difficulty: Some(DEFAULT_DIFFICULTY.to_string()),
            duration: Some(DEFAULT_DURATION.to_string()),
            status: Some(DEFAULT_STATUS.to_string()),
        }
    }
}

impl CreateReadingTestBuilder {
    pub fn with_title(mut self, title: &str) -> Self {
        self.title = Some(title.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_test_type(mut self, test_type: &str) -> Self {
        self.test_type = Some(test_type.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_difficulty(mut self, difficulty: &str) -> Self {
        self.difficulty = Some(difficulty.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_duration(mut self, duration: &str) -> Self {
        self.duration = Some(duration.to_string());
        self
    }

    pub fn with_status(mut self, status: &str) -> Self {
        self.status = Some(status.to_string());
        self
    }

    pub fn build(self) -> CreateReadingTest {
        CreateReadingTest {
            title: self.title,
            test_type: self.test_type,
            difficulty: self.difficulty,
            duration: self.duration,
            status: self.status,
        }
    }
}

pub fn default_reading_test() -> CreateReadingTest {
    CreateReadingTestBuilder::default().build()
}

/// Builder for `UpdateReadingTest`. Every field starts as `None`, meaning
/// "no change" per the repository's `COALESCE` update semantics.
#[derive(Default)]
pub struct UpdateReadingTestBuilder {
    title: Option<String>,
    test_type: Option<String>,
    difficulty: Option<String>,
    duration: Option<String>,
    status: Option<String>,
}

impl UpdateReadingTestBuilder {
    pub fn with_title(mut self, title: &str) -> Self {
        self.title = Some(title.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_test_type(mut self, test_type: &str) -> Self {
        self.test_type = Some(test_type.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_difficulty(mut self, difficulty: &str) -> Self {
        self.difficulty = Some(difficulty.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_duration(mut self, duration: &str) -> Self {
        self.duration = Some(duration.to_string());
        self
    }

    pub fn with_status(mut self, status: &str) -> Self {
        self.status = Some(status.to_string());
        self
    }

    pub fn build(self) -> UpdateReadingTest {
        UpdateReadingTest {
            title: self.title,
            test_type: self.test_type,
            difficulty: self.difficulty,
            duration: self.duration,
            status: self.status,
        }
    }
}
