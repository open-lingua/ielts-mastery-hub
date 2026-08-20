use app_lib::models::listening_sections::{CreateListeningSection, UpdateListeningSection};

const DEFAULT_SECTION_NUMBER: i64 = 1;
const DEFAULT_TITLE: &str = "Sample Section";

/// Builder for `CreateListeningSection`.
pub struct CreateListeningSectionBuilder {
    test_id: String,
    section_number: Option<i64>,
    title: Option<String>,
    transcript: Option<String>,
    audio_url: Option<String>,
}

impl Default for CreateListeningSectionBuilder {
    fn default() -> Self {
        Self {
            test_id: "placeholder-test-id".to_string(),
            section_number: Some(DEFAULT_SECTION_NUMBER),
            title: Some(DEFAULT_TITLE.to_string()),
            transcript: None,
            audio_url: None,
        }
    }
}

impl CreateListeningSectionBuilder {
    pub fn with_test_id(mut self, test_id: &str) -> Self {
        self.test_id = test_id.to_string();
        self
    }

    pub fn with_section_number(mut self, section_number: i64) -> Self {
        self.section_number = Some(section_number);
        self
    }

    pub fn with_title(mut self, title: &str) -> Self {
        self.title = Some(title.to_string());
        self
    }

    pub fn with_transcript(mut self, transcript: &str) -> Self {
        self.transcript = Some(transcript.to_string());
        self
    }

    pub fn with_audio_url(mut self, audio_url: &str) -> Self {
        self.audio_url = Some(audio_url.to_string());
        self
    }

    pub fn build(self) -> CreateListeningSection {
        CreateListeningSection {
            test_id: self.test_id,
            section_number: self.section_number,
            title: self.title,
            transcript: self.transcript,
            audio_url: self.audio_url,
        }
    }
}

#[allow(dead_code)]
pub fn default_listening_section() -> CreateListeningSection {
    CreateListeningSectionBuilder::default().build()
}

/// Builder for `UpdateListeningSection`. Every field starts as `None`, meaning
/// "no change" per the repository's `COALESCE` update semantics.
#[derive(Default)]
pub struct UpdateListeningSectionBuilder {
    section_number: Option<i64>,
    title: Option<String>,
    transcript: Option<String>,
    audio_url: Option<String>,
}

impl UpdateListeningSectionBuilder {
    pub fn with_section_number(mut self, section_number: i64) -> Self {
        self.section_number = Some(section_number);
        self
    }

    pub fn with_title(mut self, title: &str) -> Self {
        self.title = Some(title.to_string());
        self
    }

    pub fn with_transcript(mut self, transcript: &str) -> Self {
        self.transcript = Some(transcript.to_string());
        self
    }

    pub fn with_audio_url(mut self, audio_url: &str) -> Self {
        self.audio_url = Some(audio_url.to_string());
        self
    }

    pub fn build(self) -> UpdateListeningSection {
        UpdateListeningSection {
            section_number: self.section_number,
            title: self.title,
            transcript: self.transcript,
            audio_url: self.audio_url,
        }
    }
}
