use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct ReadingImport {
    pub title: Option<String>,
    pub test_type: Option<String>,
    pub difficulty: Option<String>,
    pub duration: Option<String>,
    pub status: Option<String>,
    #[serde(default)]
    pub passages: Vec<PassageImport>,
}

#[derive(Debug, Deserialize)]
pub struct PassageImport {
    pub passage_number: Option<i64>,
    pub title: Option<String>,
    pub content: Option<String>,
    pub notes: Option<String>,
    #[serde(default)]
    pub question_groups: Vec<QuestionGroupImport>,
}

#[derive(Debug, Deserialize)]
pub struct WritingImport {
    pub title: Option<String>,
    pub difficulty: Option<String>,
    pub status: Option<String>,
    #[serde(default)]
    pub tasks: Vec<TaskImport>,
}

#[derive(Debug, Deserialize)]
pub struct TaskImport {
    pub id: Option<String>,
    pub task_number: Option<i64>,
    pub task_type: Option<String>,
    pub title: Option<String>,
    pub difficulty: Option<String>,
    pub suggested_time: Option<String>,
    pub prompt: Option<String>,
    pub min_words: Option<i64>,
    pub max_words: Option<String>,
    pub image_url: Option<String>,
    pub include_model_answer: Option<bool>,
    pub model_answer: Option<String>,
    pub figure_description: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct ListeningImport {
    pub title: Option<String>,
    pub difficulty: Option<String>,
    pub duration: Option<String>,
    pub status: Option<String>,
    #[serde(default)]
    pub sections: Vec<SectionImport>,
}

#[derive(Debug, Deserialize)]
pub struct SectionImport {
    pub section_number: Option<i64>,
    pub title: Option<String>,
    pub transcript: Option<String>,
    #[serde(default)]
    pub question_groups: Vec<QuestionGroupImport>,
}

#[derive(Debug, Deserialize)]
pub struct QuestionGroupImport {
    pub group_order: Option<i64>,
    pub question_type: Option<String>,
    pub instructions: Option<String>,
    pub word_limit: Option<String>,
    pub has_word_bank: Option<bool>,
    pub word_bank: Option<serde_json::Value>,
    pub sequential_order: Option<bool>,
    pub multiple_selection: Option<bool>,
    pub select_count: Option<i64>,
    #[serde(default)]
    pub questions: Vec<QuestionImport>,
}

#[derive(Debug, Deserialize)]
pub struct QuestionImport {
    pub question_order: Option<i64>,
    pub text: Option<String>,
    pub answer: Option<String>,
    pub options: Option<serde_json::Value>,
    pub matching_pairs: Option<serde_json::Value>,
    pub completion_gaps: Option<serde_json::Value>,
    pub accepted_answers: Option<serde_json::Value>,
    pub timestamp: Option<String>,
}
