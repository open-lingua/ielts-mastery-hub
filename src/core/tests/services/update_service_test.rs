use app_lib::error::AppError;
use app_lib::services::update_service;
use assert_matches::assert_matches;
use wiremock::matchers::{method, path};
use wiremock::{Mock, MockServer, ResponseTemplate};

#[tokio::test]
async fn it_returns_the_parsed_version_on_a_successful_response() {
    // Arrange
    let server = MockServer::start().await;
    Mock::given(method("GET"))
        .and(path("/releases/latest"))
        .respond_with(ResponseTemplate::new(200).set_body_json(serde_json::json!({
            "tag_name": "v1.3.0",
            "html_url": "https://github.com/open-lingua/ielts-mastery-hub/releases/tag/v1.3.0",
        })))
        .mount(&server)
        .await;

    // Act
    let result = update_service::check_for_update(&server.uri()).await;

    // Assert
    let result = result.expect("expected a successful update check");
    assert_eq!(result.latest_version, "1.3.0");
    assert_eq!(
        result.release_url,
        "https://github.com/open-lingua/ielts-mastery-hub/releases/tag/v1.3.0"
    );
}

#[tokio::test]
async fn it_returns_an_update_check_error_on_a_non_success_status() {
    // Arrange
    let server = MockServer::start().await;
    Mock::given(method("GET"))
        .and(path("/releases/latest"))
        .respond_with(ResponseTemplate::new(404))
        .mount(&server)
        .await;

    // Act
    let result = update_service::check_for_update(&server.uri()).await;

    // Assert
    assert_matches!(result, Err(AppError::UpdateCheck(_)));
}

#[tokio::test]
async fn it_returns_an_update_check_error_when_rate_limited() {
    // Arrange
    let server = MockServer::start().await;
    Mock::given(method("GET"))
        .and(path("/releases/latest"))
        .respond_with(ResponseTemplate::new(403).set_body_string("rate limit exceeded"))
        .mount(&server)
        .await;

    // Act
    let result = update_service::check_for_update(&server.uri()).await;

    // Assert
    assert_matches!(result, Err(AppError::UpdateCheck(_)));
}

#[tokio::test]
async fn it_returns_an_update_check_error_on_malformed_json_body() {
    // Arrange
    let server = MockServer::start().await;
    Mock::given(method("GET"))
        .and(path("/releases/latest"))
        .respond_with(ResponseTemplate::new(200).set_body_string("not json"))
        .mount(&server)
        .await;

    // Act
    let result = update_service::check_for_update(&server.uri()).await;

    // Assert
    assert_matches!(result, Err(AppError::UpdateCheck(_)));
}
