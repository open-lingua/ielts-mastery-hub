use app_lib::models::reading_passages::{CreateReadingPassage, UpdateReadingPassage};

const DEFAULT_PASSAGE_NUMBER: i64 = 1;
const DEFAULT_TITLE: &str = "Sample Passage";
const DEFAULT_CONTENT: &str = "Sample passage content.";

/// Builder for `CreateReadingPassage`.
pub struct CreateReadingPassageBuilder {
    test_id: String,
    passage_number: Option<i64>,
    title: Option<String>,
    content: Option<String>,
    notes: Option<String>,
}

impl Default for CreateReadingPassageBuilder {
    fn default() -> Self {
        Self {
            test_id: "placeholder-test-id".to_string(),
            passage_number: Some(DEFAULT_PASSAGE_NUMBER),
            title: Some(DEFAULT_TITLE.to_string()),
            content: Some(DEFAULT_CONTENT.to_string()),
            notes: None,
        }
    }
}

impl CreateReadingPassageBuilder {
    pub fn with_test_id(mut self, test_id: &str) -> Self {
        self.test_id = test_id.to_string();
        self
    }

    pub fn with_passage_number(mut self, passage_number: i64) -> Self {
        self.passage_number = Some(passage_number);
        self
    }

    pub fn with_title(mut self, title: &str) -> Self {
        self.title = Some(title.to_string());
        self
    }

    pub fn with_content(mut self, content: &str) -> Self {
        self.content = Some(content.to_string());
        self
    }

    pub fn with_notes(mut self, notes: &str) -> Self {
        self.notes = Some(notes.to_string());
        self
    }

    pub fn build(self) -> CreateReadingPassage {
        CreateReadingPassage {
            test_id: self.test_id,
            passage_number: self.passage_number,
            title: self.title,
            content: self.content,
            notes: self.notes,
        }
    }
}

#[allow(dead_code)]
pub fn default_reading_passage() -> CreateReadingPassage {
    CreateReadingPassageBuilder::default().build()
}

/// Builder for `UpdateReadingPassage`. Every field starts as `None`, meaning
/// "no change" per the repository's `COALESCE` update semantics.
#[derive(Default)]
pub struct UpdateReadingPassageBuilder {
    passage_number: Option<i64>,
    title: Option<String>,
    content: Option<String>,
    notes: Option<String>,
}

impl UpdateReadingPassageBuilder {
    pub fn with_passage_number(mut self, passage_number: i64) -> Self {
        self.passage_number = Some(passage_number);
        self
    }

    pub fn with_title(mut self, title: &str) -> Self {
        self.title = Some(title.to_string());
        self
    }

    pub fn with_content(mut self, content: &str) -> Self {
        self.content = Some(content.to_string());
        self
    }

    pub fn with_notes(mut self, notes: &str) -> Self {
        self.notes = Some(notes.to_string());
        self
    }

    pub fn build(self) -> UpdateReadingPassage {
        UpdateReadingPassage {
            passage_number: self.passage_number,
            title: self.title,
            content: self.content,
            notes: self.notes,
        }
    }
}
