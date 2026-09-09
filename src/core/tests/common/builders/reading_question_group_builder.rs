use app_lib::models::reading_question_groups::{
    CreateReadingQuestionGroup, UpdateReadingQuestionGroup,
};

const DEFAULT_GROUP_ORDER: i64 = 0;
const DEFAULT_QUESTION_TYPE: &str = "multiple-choice";
const DEFAULT_INSTRUCTIONS: &str = "Answer the following questions.";
const DEFAULT_HAS_WORD_BANK: bool = false;
const DEFAULT_WORD_BANK: &str = "[]";
const DEFAULT_SEQUENTIAL_ORDER: bool = true;
const DEFAULT_MULTIPLE_SELECTION: bool = false;
const DEFAULT_SELECT_COUNT: i64 = 1;

/// Builder for `CreateReadingQuestionGroup`.
pub struct CreateReadingQuestionGroupBuilder {
    passage_id: String,
    group_order: Option<i64>,
    question_type: Option<String>,
    instructions: Option<String>,
    word_limit: Option<String>,
    has_word_bank: Option<bool>,
    word_bank: Option<String>,
    sequential_order: Option<bool>,
    multiple_selection: Option<bool>,
    select_count: Option<i64>,
}

impl Default for CreateReadingQuestionGroupBuilder {
    fn default() -> Self {
        Self {
            passage_id: "placeholder-passage-id".to_string(),
            group_order: Some(DEFAULT_GROUP_ORDER),
            question_type: Some(DEFAULT_QUESTION_TYPE.to_string()),
            instructions: Some(DEFAULT_INSTRUCTIONS.to_string()),
            word_limit: None,
            has_word_bank: Some(DEFAULT_HAS_WORD_BANK),
            word_bank: Some(DEFAULT_WORD_BANK.to_string()),
            sequential_order: Some(DEFAULT_SEQUENTIAL_ORDER),
            multiple_selection: Some(DEFAULT_MULTIPLE_SELECTION),
            select_count: Some(DEFAULT_SELECT_COUNT),
        }
    }
}

impl CreateReadingQuestionGroupBuilder {
    pub fn with_passage_id(mut self, passage_id: &str) -> Self {
        self.passage_id = passage_id.to_string();
        self
    }

    #[allow(dead_code)]
    pub fn with_group_order(mut self, group_order: i64) -> Self {
        self.group_order = Some(group_order);
        self
    }

    pub fn with_question_type(mut self, question_type: &str) -> Self {
        self.question_type = Some(question_type.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_instructions(mut self, instructions: &str) -> Self {
        self.instructions = Some(instructions.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_word_limit(mut self, word_limit: &str) -> Self {
        self.word_limit = Some(word_limit.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_has_word_bank(mut self, has_word_bank: bool) -> Self {
        self.has_word_bank = Some(has_word_bank);
        self
    }

    #[allow(dead_code)]
    pub fn with_word_bank(mut self, word_bank: &str) -> Self {
        self.word_bank = Some(word_bank.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_sequential_order(mut self, sequential_order: bool) -> Self {
        self.sequential_order = Some(sequential_order);
        self
    }

    #[allow(dead_code)]
    pub fn with_multiple_selection(mut self, multiple_selection: bool) -> Self {
        self.multiple_selection = Some(multiple_selection);
        self
    }

    #[allow(dead_code)]
    pub fn with_select_count(mut self, select_count: i64) -> Self {
        self.select_count = Some(select_count);
        self
    }

    pub fn build(self) -> CreateReadingQuestionGroup {
        CreateReadingQuestionGroup {
            passage_id: self.passage_id,
            group_order: self.group_order,
            question_type: self.question_type,
            instructions: self.instructions,
            word_limit: self.word_limit,
            has_word_bank: self.has_word_bank,
            word_bank: self.word_bank,
            sequential_order: self.sequential_order,
            multiple_selection: self.multiple_selection,
            select_count: self.select_count,
        }
    }
}

#[allow(dead_code)]
#[allow(dead_code)]
pub fn default_reading_question_group() -> CreateReadingQuestionGroup {
    CreateReadingQuestionGroupBuilder::default().build()
}

/// Builder for `UpdateReadingQuestionGroup`. Every field starts as `None`, meaning
/// "no change" per the repository's `COALESCE` update semantics.
#[derive(Default)]
pub struct UpdateReadingQuestionGroupBuilder {
    group_order: Option<i64>,
    question_type: Option<String>,
    instructions: Option<String>,
    word_limit: Option<String>,
    has_word_bank: Option<bool>,
    word_bank: Option<String>,
    sequential_order: Option<bool>,
    multiple_selection: Option<bool>,
    select_count: Option<i64>,
}

impl UpdateReadingQuestionGroupBuilder {
    pub fn with_group_order(mut self, group_order: i64) -> Self {
        self.group_order = Some(group_order);
        self
    }

    #[allow(dead_code)]
    pub fn with_question_type(mut self, question_type: &str) -> Self {
        self.question_type = Some(question_type.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_instructions(mut self, instructions: &str) -> Self {
        self.instructions = Some(instructions.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_word_limit(mut self, word_limit: &str) -> Self {
        self.word_limit = Some(word_limit.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_has_word_bank(mut self, has_word_bank: bool) -> Self {
        self.has_word_bank = Some(has_word_bank);
        self
    }

    #[allow(dead_code)]
    pub fn with_word_bank(mut self, word_bank: &str) -> Self {
        self.word_bank = Some(word_bank.to_string());
        self
    }

    #[allow(dead_code)]
    pub fn with_sequential_order(mut self, sequential_order: bool) -> Self {
        self.sequential_order = Some(sequential_order);
        self
    }

    #[allow(dead_code)]
    pub fn with_multiple_selection(mut self, multiple_selection: bool) -> Self {
        self.multiple_selection = Some(multiple_selection);
        self
    }

    #[allow(dead_code)]
    pub fn with_select_count(mut self, select_count: i64) -> Self {
        self.select_count = Some(select_count);
        self
    }

    pub fn build(self) -> UpdateReadingQuestionGroup {
        UpdateReadingQuestionGroup {
            group_order: self.group_order,
            question_type: self.question_type,
            instructions: self.instructions,
            word_limit: self.word_limit,
            has_word_bank: self.has_word_bank,
            word_bank: self.word_bank,
            sequential_order: self.sequential_order,
            multiple_selection: self.multiple_selection,
            select_count: self.select_count,
        }
    }
}
