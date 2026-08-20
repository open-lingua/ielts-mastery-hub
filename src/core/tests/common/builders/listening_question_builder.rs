use app_lib::models::listening_questions::{CreateListeningQuestion, UpdateListeningQuestion};

const DEFAULT_QUESTION_ORDER: i64 = 0;
const DEFAULT_TEXT: &str = "Sample question audio prompt?";
const DEFAULT_OPTIONS: &str = "[]";
const DEFAULT_MATCHING_PAIRS: &str = "[]";
const DEFAULT_COMPLETION_GAPS: &str = "[]";
const DEFAULT_ACCEPTED_ANSWERS: &str = "[]";

/// Builder for `CreateListeningQuestion`.
pub struct CreateListeningQuestionBuilder {
    group_id: String,
    question_order: Option<i64>,
    text: Option<String>,
    answer: Option<String>,
    options: Option<String>,
    matching_pairs: Option<String>,
    completion_gaps: Option<String>,
    accepted_answers: Option<String>,
    timestamp: Option<String>,
}

impl Default for CreateListeningQuestionBuilder {
    fn default() -> Self {
        Self {
            group_id: "placeholder-group-id".to_string(),
            question_order: Some(DEFAULT_QUESTION_ORDER),
            text: Some(DEFAULT_TEXT.to_string()),
            answer: None,
            options: Some(DEFAULT_OPTIONS.to_string()),
            matching_pairs: Some(DEFAULT_MATCHING_PAIRS.to_string()),
            completion_gaps: Some(DEFAULT_COMPLETION_GAPS.to_string()),
            accepted_answers: Some(DEFAULT_ACCEPTED_ANSWERS.to_string()),
            timestamp: None,
        }
    }
}

impl CreateListeningQuestionBuilder {
    pub fn with_group_id(mut self, group_id: &str) -> Self {
        self.group_id = group_id.to_string();
        self
    }

    pub fn with_question_order(mut self, question_order: i64) -> Self {
        self.question_order = Some(question_order);
        self
    }

    pub fn with_text(mut self, text: &str) -> Self {
        self.text = Some(text.to_string());
        self
    }

    pub fn with_answer(mut self, answer: &str) -> Self {
        self.answer = Some(answer.to_string());
        self
    }

    pub fn with_options(mut self, options: &str) -> Self {
        self.options = Some(options.to_string());
        self
    }

    pub fn with_matching_pairs(mut self, matching_pairs: &str) -> Self {
        self.matching_pairs = Some(matching_pairs.to_string());
        self
    }

    pub fn with_completion_gaps(mut self, completion_gaps: &str) -> Self {
        self.completion_gaps = Some(completion_gaps.to_string());
        self
    }

    pub fn with_accepted_answers(mut self, accepted_answers: &str) -> Self {
        self.accepted_answers = Some(accepted_answers.to_string());
        self
    }

    pub fn with_timestamp(mut self, timestamp: &str) -> Self {
        self.timestamp = Some(timestamp.to_string());
        self
    }

    pub fn build(self) -> CreateListeningQuestion {
        CreateListeningQuestion {
            group_id: self.group_id,
            question_order: self.question_order,
            text: self.text,
            answer: self.answer,
            options: self.options,
            matching_pairs: self.matching_pairs,
            completion_gaps: self.completion_gaps,
            accepted_answers: self.accepted_answers,
            timestamp: self.timestamp,
        }
    }
}

#[allow(dead_code)]
pub fn default_listening_question() -> CreateListeningQuestion {
    CreateListeningQuestionBuilder::default().build()
}

/// Builder for `UpdateListeningQuestion`. Every field starts as `None`, meaning
/// "no change" per the repository's `COALESCE` update semantics.
#[derive(Default)]
pub struct UpdateListeningQuestionBuilder {
    question_order: Option<i64>,
    text: Option<String>,
    answer: Option<String>,
    options: Option<String>,
    matching_pairs: Option<String>,
    completion_gaps: Option<String>,
    accepted_answers: Option<String>,
    timestamp: Option<String>,
}

impl UpdateListeningQuestionBuilder {
    pub fn with_question_order(mut self, question_order: i64) -> Self {
        self.question_order = Some(question_order);
        self
    }

    pub fn with_text(mut self, text: &str) -> Self {
        self.text = Some(text.to_string());
        self
    }

    pub fn with_answer(mut self, answer: &str) -> Self {
        self.answer = Some(answer.to_string());
        self
    }

    pub fn with_options(mut self, options: &str) -> Self {
        self.options = Some(options.to_string());
        self
    }

    pub fn with_matching_pairs(mut self, matching_pairs: &str) -> Self {
        self.matching_pairs = Some(matching_pairs.to_string());
        self
    }

    pub fn with_completion_gaps(mut self, completion_gaps: &str) -> Self {
        self.completion_gaps = Some(completion_gaps.to_string());
        self
    }

    pub fn with_accepted_answers(mut self, accepted_answers: &str) -> Self {
        self.accepted_answers = Some(accepted_answers.to_string());
        self
    }

    pub fn with_timestamp(mut self, timestamp: &str) -> Self {
        self.timestamp = Some(timestamp.to_string());
        self
    }

    pub fn build(self) -> UpdateListeningQuestion {
        UpdateListeningQuestion {
            question_order: self.question_order,
            text: self.text,
            answer: self.answer,
            options: self.options,
            matching_pairs: self.matching_pairs,
            completion_gaps: self.completion_gaps,
            accepted_answers: self.accepted_answers,
            timestamp: self.timestamp,
        }
    }
}
