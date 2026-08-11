use serde::{Deserialize, Serialize};
use tauri::State;

use crate::database::Db;

const MAX_RESPONSE_LEN: usize = 10_000;
const MAX_PROMPT_LEN: usize = 5_000;

const SYSTEM_PROMPT: &str = r#"You are an expert IELTS examiner with years of experience. Grade the following user response to the provided IELTS writing prompt. Evaluate strictly according to the official IELTS band descriptors.

You must return ONLY a valid JSON object with this exact structure (no markdown, no extra text):
{
  "overallBand": <number between 0 and 9, in 0.5 increments>,
  "criteria": {
    "taskAchievement": <number>,
    "coherenceCohesion": <number>,
    "lexicalResource": <number>,
    "grammaticalRange": <number>
  },
  "feedback": {
    "strengths": ["<string>", "<string>"],
    "weaknesses": ["<string>", "<string>"],
    "improvements": "<string with specific actionable advice>"
  }
}

Rules:
- All band scores must be between 0.0 and 9.0 in 0.5 increments.
- overallBand is the average of the 4 criteria scores, rounded to nearest 0.5.
- Be fair but rigorous. Do not inflate scores.
- strengths and weaknesses should each have 2-4 bullet points.
- improvements should be 2-3 sentences of actionable advice."#;

#[derive(Debug, Deserialize)]
pub struct GradeWritingInput {
    pub user_id: String,
    pub task_type: String,
    pub prompt: String,
    pub user_response: String,
    pub session_id: Option<String>,
    pub ai_api_key: String,
    pub ai_gateway_url: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct GradingCriteria {
    #[serde(rename = "taskAchievement")]
    pub task_achievement: f64,
    #[serde(rename = "coherenceCohesion")]
    pub coherence_cohesion: f64,
    #[serde(rename = "lexicalResource")]
    pub lexical_resource: f64,
    #[serde(rename = "grammaticalRange")]
    pub grammatical_range: f64,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct GradingFeedback {
    pub strengths: Vec<String>,
    pub weaknesses: Vec<String>,
    pub improvements: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct GradingResult {
    #[serde(rename = "overallBand")]
    pub overall_band: f64,
    pub criteria: GradingCriteria,
    pub feedback: GradingFeedback,
}

#[tauri::command]
pub async fn grade_writing(
    _db: State<'_, Db>,
    input: GradeWritingInput,
) -> Result<GradingResult, String> {
    if input.task_type != "task1" && input.task_type != "task2" {
        return Err("taskType must be 'task1' or 'task2'".to_string());
    }
    if input.user_response.len() > MAX_RESPONSE_LEN {
        return Err(format!(
            "userResponse must be under {} characters",
            MAX_RESPONSE_LEN
        ));
    }
    if input.prompt.len() > MAX_PROMPT_LEN {
        return Err(format!(
            "prompt must be under {} characters",
            MAX_PROMPT_LEN
        ));
    }

    let task_label = if input.task_type == "task1" {
        "Task 1"
    } else {
        "Task 2"
    };
    let user_content = format!(
        "IELTS Writing {}\n\nPrompt:\n{}\n\nStudent Response:\n{}",
        task_label, input.prompt, input.user_response
    );

    let request_body = serde_json::json!({
        "model": "google/gemini-2.5-flash",
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": user_content}
        ],
        "temperature": 0.3
    });

    let client = reqwest::Client::new();
    let response = client
        .post(&input.ai_gateway_url)
        .bearer_auth(&input.ai_api_key)
        .json(&request_body)
        .send()
        .await
        .map_err(|e| e.to_string())?;

    if !response.status().is_success() {
        return Err("AI grading failed".to_string());
    }

    let ai_data: serde_json::Value = response.json().await.map_err(|e| e.to_string())?;
    let content = ai_data["choices"][0]["message"]["content"]
        .as_str()
        .unwrap_or("")
        .to_string();

    let json_str = extract_json(&content);
    serde_json::from_str::<GradingResult>(&json_str)
        .map_err(|_| "Invalid AI response format".to_string())
}

fn extract_json(content: &str) -> String {
    if let Some(start) = content.find("```") {
        let after = &content[start + 3..];
        let after = after.trim_start_matches("json").trim_start_matches('\n');
        if let Some(end) = after.find("```") {
            return after[..end].trim().to_string();
        }
    }
    content.trim().to_string()
}
