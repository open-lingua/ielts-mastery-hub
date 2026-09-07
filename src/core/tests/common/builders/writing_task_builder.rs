use app_lib::models::writing_tasks::{CreateWritingTask, UpdateWritingTask};

const DEFAULT_TASK_NUMBER: i64 = 1;
const DEFAULT_TASK_TYPE: &str = "task1";
const DEFAULT_TITLE: &str = "Sample Writing Task";
const DEFAULT_DIFFICULTY: &str = "7";
const DEFAULT_SUGGESTED_TIME: &str = "20 mins";
const DEFAULT_PROMPT: &str = "Describe the chart.";
const DEFAULT_MIN_WORDS: i64 = 150;
const DEFAULT_INCLUDE_MODEL_ANSWER: bool = false;

/// Builder for `CreateWritingTask`.
pub struct CreateWritingTaskBuilder {
    id: Option<String>,
    test_id: String,
    task_number: Option<i64>,
    task_type: Option<String>,
    title: Option<String>,
    difficulty: Option<String>,
    suggested_time: Option<String>,
    prompt: Option<String>,
    min_words: Option<i64>,
    max_words: Option<String>,
    image_url: Option<String>,
    include_model_answer: Option<bool>,
    model_answer: Option<String>,
    figure_description: Option<String>,
}

impl Default for CreateWritingTaskBuilder {
    fn default() -> Self {
        Self {
            id: None,
            test_id: "placeholder-test-id".to_string(),
            task_number: Some(DEFAULT_TASK_NUMBER),
            task_type: Some(DEFAULT_TASK_TYPE.to_string()),
            title: Some(DEFAULT_TITLE.to_string()),
            difficulty: Some(DEFAULT_DIFFICULTY.to_string()),
            suggested_time: Some(DEFAULT_SUGGESTED_TIME.to_string()),
            prompt: Some(DEFAULT_PROMPT.to_string()),
            min_words: Some(DEFAULT_MIN_WORDS),
            max_words: None,
            image_url: None,
            include_model_answer: Some(DEFAULT_INCLUDE_MODEL_ANSWER),
            model_answer: None,
            figure_description: None,
        }
    }
}

impl CreateWritingTaskBuilder {
    pub fn with_id(mut self, id: &str) -> Self {
        self.id = Some(id.to_string());
        self
    }

    pub fn with_test_id(mut self, test_id: &str) -> Self {
        self.test_id = test_id.to_string();
        self
    }

    pub fn with_task_number(mut self, task_number: i64) -> Self {
        self.task_number = Some(task_number);
        self
    }

    pub fn with_task_type(mut self, task_type: &str) -> Self {
        self.task_type = Some(task_type.to_string());
        self
    }

    pub fn with_title(mut self, title: &str) -> Self {
        self.title = Some(title.to_string());
        self
    }

    pub fn with_difficulty(mut self, difficulty: &str) -> Self {
        self.difficulty = Some(difficulty.to_string());
        self
    }

    pub fn with_suggested_time(mut self, suggested_time: &str) -> Self {
        self.suggested_time = Some(suggested_time.to_string());
        self
    }

    pub fn with_prompt(mut self, prompt: &str) -> Self {
        self.prompt = Some(prompt.to_string());
        self
    }

    pub fn with_min_words(mut self, min_words: i64) -> Self {
        self.min_words = Some(min_words);
        self
    }

    pub fn with_max_words(mut self, max_words: &str) -> Self {
        self.max_words = Some(max_words.to_string());
        self
    }

    pub fn with_image_url(mut self, image_url: &str) -> Self {
        self.image_url = Some(image_url.to_string());
        self
    }

    pub fn with_include_model_answer(mut self, include_model_answer: bool) -> Self {
        self.include_model_answer = Some(include_model_answer);
        self
    }

    pub fn with_model_answer(mut self, model_answer: &str) -> Self {
        self.model_answer = Some(model_answer.to_string());
        self
    }

    pub fn with_figure_description(mut self, figure_description: &str) -> Self {
        self.figure_description = Some(figure_description.to_string());
        self
    }

    pub fn build(self) -> CreateWritingTask {
        CreateWritingTask {
            id: self.id,
            test_id: self.test_id,
            task_number: self.task_number,
            task_type: self.task_type,
            title: self.title,
            difficulty: self.difficulty,
            suggested_time: self.suggested_time,
            prompt: self.prompt,
            min_words: self.min_words,
            max_words: self.max_words,
            image_url: self.image_url,
            include_model_answer: self.include_model_answer,
            model_answer: self.model_answer,
            figure_description: self.figure_description,
        }
    }
}

#[allow(dead_code)]
pub fn default_writing_task() -> CreateWritingTask {
    CreateWritingTaskBuilder::default().build()
}

/// Builder for `UpdateWritingTask`. Every field starts as `None`, meaning
/// "no change" per the repository's `COALESCE` update semantics.
#[derive(Default)]
pub struct UpdateWritingTaskBuilder {
    task_number: Option<i64>,
    task_type: Option<String>,
    title: Option<String>,
    difficulty: Option<String>,
    suggested_time: Option<String>,
    prompt: Option<String>,
    min_words: Option<i64>,
    max_words: Option<String>,
    image_url: Option<String>,
    include_model_answer: Option<bool>,
    model_answer: Option<String>,
    figure_description: Option<String>,
}

impl UpdateWritingTaskBuilder {
    pub fn with_task_number(mut self, task_number: i64) -> Self {
        self.task_number = Some(task_number);
        self
    }

    pub fn with_task_type(mut self, task_type: &str) -> Self {
        self.task_type = Some(task_type.to_string());
        self
    }

    pub fn with_title(mut self, title: &str) -> Self {
        self.title = Some(title.to_string());
        self
    }

    pub fn with_difficulty(mut self, difficulty: &str) -> Self {
        self.difficulty = Some(difficulty.to_string());
        self
    }

    pub fn with_suggested_time(mut self, suggested_time: &str) -> Self {
        self.suggested_time = Some(suggested_time.to_string());
        self
    }

    pub fn with_prompt(mut self, prompt: &str) -> Self {
        self.prompt = Some(prompt.to_string());
        self
    }

    pub fn with_min_words(mut self, min_words: i64) -> Self {
        self.min_words = Some(min_words);
        self
    }

    pub fn with_max_words(mut self, max_words: &str) -> Self {
        self.max_words = Some(max_words.to_string());
        self
    }

    pub fn with_image_url(mut self, image_url: &str) -> Self {
        self.image_url = Some(image_url.to_string());
        self
    }

    pub fn with_include_model_answer(mut self, include_model_answer: bool) -> Self {
        self.include_model_answer = Some(include_model_answer);
        self
    }

    pub fn with_model_answer(mut self, model_answer: &str) -> Self {
        self.model_answer = Some(model_answer.to_string());
        self
    }

    pub fn with_figure_description(mut self, figure_description: &str) -> Self {
        self.figure_description = Some(figure_description.to_string());
        self
    }

    pub fn build(self) -> UpdateWritingTask {
        UpdateWritingTask {
            task_number: self.task_number,
            task_type: self.task_type,
            title: self.title,
            difficulty: self.difficulty,
            suggested_time: self.suggested_time,
            prompt: self.prompt,
            min_words: self.min_words,
            max_words: self.max_words,
            image_url: self.image_url,
            include_model_answer: self.include_model_answer,
            model_answer: self.model_answer,
            figure_description: self.figure_description,
        }
    }
}
