use app_lib::models::writing_tests::{CreateWritingTest, UpdateWritingTest};

const DEFAULT_TITLE: &str = "Sample Writing Test";
const DEFAULT_STATUS: &str = "draft";

/// Builder for `CreateWritingTest`.
pub struct CreateWritingTestBuilder {
    title: Option<String>,
    status: Option<String>,
}

impl Default for CreateWritingTestBuilder {
    fn default() -> Self {
        Self {
            title: Some(DEFAULT_TITLE.to_string()),
            status: Some(DEFAULT_STATUS.to_string()),
        }
    }
}

impl CreateWritingTestBuilder {
    pub fn with_title(mut self, title: &str) -> Self {
        self.title = Some(title.to_string());
        self
    }

    pub fn with_status(mut self, status: &str) -> Self {
        self.status = Some(status.to_string());
        self
    }

    pub fn build(self) -> CreateWritingTest {
        CreateWritingTest {
            title: self.title,
            status: self.status,
        }
    }
}

pub fn default_writing_test() -> CreateWritingTest {
    CreateWritingTestBuilder::default().build()
}

/// Builder for `UpdateWritingTest`. Every field starts as `None`, meaning
/// "no change" per the repository's `COALESCE` update semantics.
#[derive(Default)]
pub struct UpdateWritingTestBuilder {
    title: Option<String>,
    status: Option<String>,
}

impl UpdateWritingTestBuilder {
    pub fn with_title(mut self, title: &str) -> Self {
        self.title = Some(title.to_string());
        self
    }

    pub fn with_status(mut self, status: &str) -> Self {
        self.status = Some(status.to_string());
        self
    }

    pub fn build(self) -> UpdateWritingTest {
        UpdateWritingTest {
            title: self.title,
            status: self.status,
        }
    }
}
