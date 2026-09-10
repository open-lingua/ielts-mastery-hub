use std::collections::HashMap;

use crate::error::AppError;

const OPENAI_CHAT_COMPLETIONS_URL: &str = "https://api.openai.com/v1/chat/completions";
const ANTHROPIC_MESSAGES_URL: &str = "https://api.anthropic.com/v1/messages";
const ANTHROPIC_VERSION: &str = "2023-06-01";
const GEMINI_MODEL_URL: &str =
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";

const OPENAI_MODEL: &str = "gpt-4o-mini";
const CLAUDE_MODEL: &str = "claude-3-5-sonnet-latest";
const CLAUDE_MAX_TOKENS: u32 = 2048;

fn get_required<'a>(
    credentials: &'a HashMap<String, String>,
    field: &str,
) -> Result<&'a str, AppError> {
    credentials
        .get(field)
        .map(|s| s.as_str())
        .filter(|s| !s.trim().is_empty())
        .ok_or_else(|| AppError::Validation(format!("missing required credential field `{field}`")))
}

/// Dispatches an AI grading completion request to the appropriate provider, isolating
/// every provider-specific request/response shape from `grade_writing`. Returns the raw
/// completion text (still containing whatever markdown/JSON wrapping the model chose to
/// use — parsed further by the caller).
pub async fn complete(
    provider_id: &str,
    credentials: &HashMap<String, String>,
    system_prompt: &str,
    user_content: &str,
) -> Result<String, AppError> {
    match provider_id {
        "chatgpt" => {
            let api_key = get_required(credentials, "apiKey")?;
            openai_compatible_completion(OPENAI_CHAT_COMPLETIONS_URL, Some(api_key), OPENAI_MODEL, system_prompt, user_content).await
        }
        "claude" => {
            let api_key = get_required(credentials, "apiKey")?;
            claude_completion(api_key, system_prompt, user_content).await
        }
        "gemini" => {
            let api_key = get_required(credentials, "apiKey")?;
            gemini_completion(api_key, system_prompt, user_content).await
        }
        "local" => {
            let endpoint = get_required(credentials, "endpoint")?;
            let url = format!("{}/chat/completions", endpoint.trim_end_matches('/'));
            openai_compatible_completion(&url, None, OPENAI_MODEL, system_prompt, user_content).await
        }
        "general" => {
            let endpoint = get_required(credentials, "endpoint")?;
            let header_name = get_required(credentials, "headerName")?;
            let api_key = credentials.get("apiKey").map(|s| s.as_str()).filter(|s| !s.trim().is_empty());
            general_completion(endpoint, header_name, api_key, system_prompt, user_content).await
        }
        other => Err(AppError::Validation(format!("unknown AI provider: {other}"))),
    }
}

async fn openai_compatible_completion(
    url: &str,
    bearer_token: Option<&str>,
    model: &str,
    system_prompt: &str,
    user_content: &str,
) -> Result<String, AppError> {
    let body = serde_json::json!({
        "model": model,
        "messages": [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_content}
        ],
        "temperature": 0.3
    });

    let client = reqwest::Client::new();
    let mut request = client.post(url).json(&body);
    if let Some(token) = bearer_token {
        request = request.bearer_auth(token);
    }

    let response = request
        .send()
        .await
        .map_err(|e| AppError::Validation(format!("AI request failed: {e}")))?;

    if !response.status().is_success() {
        return Err(AppError::Validation("AI grading failed".to_string()));
    }

    let data: serde_json::Value = response
        .json()
        .await
        .map_err(|e| AppError::Validation(format!("AI response was not valid JSON: {e}")))?;

    Ok(data["choices"][0]["message"]["content"]
        .as_str()
        .unwrap_or("")
        .to_string())
}

async fn claude_completion(
    api_key: &str,
    system_prompt: &str,
    user_content: &str,
) -> Result<String, AppError> {
    let body = serde_json::json!({
        "model": CLAUDE_MODEL,
        "max_tokens": CLAUDE_MAX_TOKENS,
        "system": system_prompt,
        "messages": [
            {"role": "user", "content": user_content}
        ]
    });

    let client = reqwest::Client::new();
    let response = client
        .post(ANTHROPIC_MESSAGES_URL)
        .header("x-api-key", api_key)
        .header("anthropic-version", ANTHROPIC_VERSION)
        .json(&body)
        .send()
        .await
        .map_err(|e| AppError::Validation(format!("AI request failed: {e}")))?;

    if !response.status().is_success() {
        return Err(AppError::Validation("AI grading failed".to_string()));
    }

    let data: serde_json::Value = response
        .json()
        .await
        .map_err(|e| AppError::Validation(format!("AI response was not valid JSON: {e}")))?;

    Ok(data["content"][0]["text"].as_str().unwrap_or("").to_string())
}

fn urlencode(value: &str) -> String {
    url::form_urlencoded::byte_serialize(value.as_bytes()).collect()
}

async fn gemini_completion(
    api_key: &str,
    system_prompt: &str,
    user_content: &str,
) -> Result<String, AppError> {
    let body = serde_json::json!({
        "systemInstruction": {
            "parts": [{"text": system_prompt}]
        },
        "contents": [
            {"role": "user", "parts": [{"text": user_content}]}
        ],
        "generationConfig": {"temperature": 0.3}
    });

    let client = reqwest::Client::new();
    let url = format!("{GEMINI_MODEL_URL}?key={}", urlencode(api_key));
    let response = client
        .post(&url)
        .json(&body)
        .send()
        .await
        .map_err(|e| AppError::Validation(format!("AI request failed: {e}")))?;

    if !response.status().is_success() {
        return Err(AppError::Validation("AI grading failed".to_string()));
    }

    let data: serde_json::Value = response
        .json()
        .await
        .map_err(|e| AppError::Validation(format!("AI response was not valid JSON: {e}")))?;

    Ok(data["candidates"][0]["content"]["parts"][0]["text"]
        .as_str()
        .unwrap_or("")
        .to_string())
}

async fn general_completion(
    endpoint: &str,
    header_name: &str,
    api_key: Option<&str>,
    system_prompt: &str,
    user_content: &str,
) -> Result<String, AppError> {
    let body = serde_json::json!({
        "model": OPENAI_MODEL,
        "messages": [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_content}
        ],
        "temperature": 0.3
    });

    let client = reqwest::Client::new();
    let mut request = client.post(endpoint).json(&body);
    if let Some(key) = api_key {
        request = request.header(header_name, key);
    }

    let response = request
        .send()
        .await
        .map_err(|e| AppError::Validation(format!("AI request failed: {e}")))?;

    if !response.status().is_success() {
        return Err(AppError::Validation("AI grading failed".to_string()));
    }

    let data: serde_json::Value = response
        .json()
        .await
        .map_err(|e| AppError::Validation(format!("AI response was not valid JSON: {e}")))?;

    Ok(data["choices"][0]["message"]["content"]
        .as_str()
        .unwrap_or("")
        .to_string())
}

#[cfg(test)]
mod tests {
    use wiremock::matchers::{header, method, path};
    use wiremock::{Mock, MockServer, ResponseTemplate};

    use super::*;

    fn creds(pairs: &[(&str, &str)]) -> HashMap<String, String> {
        pairs
            .iter()
            .map(|(k, v)| (k.to_string(), v.to_string()))
            .collect()
    }

    #[tokio::test]
    async fn it_rejects_an_unknown_provider() {
        let result = complete("unknown", &HashMap::new(), "sys", "user").await;
        assert!(matches!(result, Err(AppError::Validation(_))));
    }

    #[tokio::test]
    async fn it_rejects_a_provider_missing_its_required_field() {
        let result = complete("chatgpt", &HashMap::new(), "sys", "user").await;
        assert!(matches!(result, Err(AppError::Validation(_))));
    }

    #[tokio::test]
    async fn it_calls_local_as_an_openai_compatible_chat_completions_endpoint() {
        let server = MockServer::start().await;
        Mock::given(method("POST"))
            .and(path("/chat/completions"))
            .respond_with(ResponseTemplate::new(200).set_body_json(serde_json::json!({
                "choices": [{"message": {"content": "local-response"}}]
            })))
            .mount(&server)
            .await;

        let credentials = creds(&[("endpoint", &server.uri())]);
        let result = complete("local", &credentials, "sys", "user").await.expect("complete");

        assert_eq!(result, "local-response");
    }

    #[tokio::test]
    async fn it_sends_the_configured_header_and_key_for_the_general_provider() {
        let server = MockServer::start().await;
        Mock::given(method("POST"))
            .and(header("X-Custom-Auth", "secret-value"))
            .respond_with(ResponseTemplate::new(200).set_body_json(serde_json::json!({
                "choices": [{"message": {"content": "general-response"}}]
            })))
            .mount(&server)
            .await;

        let credentials = creds(&[
            ("endpoint", &server.uri()),
            ("headerName", "X-Custom-Auth"),
            ("apiKey", "secret-value"),
        ]);
        let result = complete("general", &credentials, "sys", "user").await.expect("complete");

        assert_eq!(result, "general-response");
    }

    #[tokio::test]
    async fn it_omits_the_auth_header_for_general_when_no_api_key_is_set() {
        let server = MockServer::start().await;
        Mock::given(method("POST"))
            .respond_with(ResponseTemplate::new(200).set_body_json(serde_json::json!({
                "choices": [{"message": {"content": "no-auth-response"}}]
            })))
            .mount(&server)
            .await;

        let credentials = creds(&[("endpoint", &server.uri()), ("headerName", "X-Custom-Auth")]);
        let result = complete("general", &credentials, "sys", "user").await.expect("complete");

        assert_eq!(result, "no-auth-response");
    }

    #[tokio::test]
    async fn it_surfaces_an_error_when_the_provider_returns_a_failure_status() {
        let server = MockServer::start().await;
        Mock::given(method("POST"))
            .respond_with(ResponseTemplate::new(500))
            .mount(&server)
            .await;

        let credentials = creds(&[("endpoint", &server.uri())]);
        let result = complete("local", &credentials, "sys", "user").await;

        assert!(matches!(result, Err(AppError::Validation(_))));
    }
}
