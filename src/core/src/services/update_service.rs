use std::time::Duration;

use serde::{Deserialize, Serialize};

use crate::error::AppError;

/// Base URL for the GitHub API, pointed at this repo. Passed into [`check_for_update`] so tests
/// can swap in a `wiremock` server instead of hitting the real GitHub API.
pub const GITHUB_API_BASE: &str = "https://api.github.com/repos/open-lingua/ielts-mastery-hub";

const USER_AGENT: &str = "ielts-mastery-hub-updater";
const REQUEST_TIMEOUT: Duration = Duration::from_secs(5);

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct UpdateCheckResult {
    pub latest_version: String,
    /// The GitHub release page URL (`html_url` from the API response), opened in the user's
    /// default browser when they explicitly click the "Update available" control.
    pub release_url: String,
}

/// Shape of the fields we care about from GitHub's `GET /releases/latest` response. Other fields
/// present on the real payload are ignored.
#[derive(Debug, Deserialize)]
struct ReleaseResponse {
    tag_name: Option<String>,
    html_url: Option<String>,
}

/// Validates a version string against this repo's tag convention (see `install.sh`/`install.ps1`):
/// `X.Y.Z` or `X.Y.Z-rc.N`.
fn is_valid_version(version: &str) -> bool {
    let mut parts = version.splitn(2, '-');
    let core = parts.next().unwrap_or_default();
    let prerelease = parts.next();

    let core_valid = {
        let segments: Vec<&str> = core.split('.').collect();
        segments.len() == 3
            && segments
                .iter()
                .all(|s| !s.is_empty() && s.chars().all(|c| c.is_ascii_digit()))
    };
    if !core_valid {
        return false;
    }

    match prerelease {
        None => true,
        Some(pre) => {
            let pre_parts: Vec<&str> = pre.splitn(2, '.').collect();
            pre_parts.len() == 2
                && pre_parts[0] == "rc"
                && !pre_parts[1].is_empty()
                && pre_parts[1].chars().all(|c| c.is_ascii_digit())
        }
    }
}

/// Pure parsing/validation of a GitHub "latest release" JSON body — no network involved, so this
/// is fully unit-testable in isolation.
pub(crate) fn parse_release(body: &str) -> Result<UpdateCheckResult, AppError> {
    let release: ReleaseResponse = serde_json::from_str(body)
        .map_err(|e| AppError::UpdateCheck(format!("could not parse release response: {e}")))?;

    let tag_name = release
        .tag_name
        .ok_or_else(|| AppError::UpdateCheck("release response missing `tag_name`".into()))?;
    let release_url = release
        .html_url
        .ok_or_else(|| AppError::UpdateCheck("release response missing `html_url`".into()))?;

    let latest_version = tag_name.strip_prefix('v').unwrap_or(&tag_name).to_string();

    if !is_valid_version(&latest_version) {
        return Err(AppError::UpdateCheck(format!(
            "release tag `{tag_name}` is not a recognized version format"
        )));
    }

    Ok(UpdateCheckResult {
        latest_version,
        release_url,
    })
}

/// Fetches the latest GitHub release for this repo and returns its parsed version + release URL.
/// `base_url` is injectable so tests can point this at a mock server instead of real GitHub.
pub async fn check_for_update(base_url: &str) -> Result<UpdateCheckResult, AppError> {
    let client = reqwest::Client::builder()
        .timeout(REQUEST_TIMEOUT)
        .build()
        .map_err(|e| AppError::UpdateCheck(format!("could not build HTTP client: {e}")))?;

    let url = format!("{base_url}/releases/latest");

    let response = client
        .get(&url)
        .header("User-Agent", USER_AGENT)
        .send()
        .await
        .map_err(|e| AppError::UpdateCheck(format!("could not reach GitHub releases API: {e}")))?;

    if !response.status().is_success() {
        return Err(AppError::UpdateCheck(format!(
            "GitHub releases API returned status {}",
            response.status()
        )));
    }

    let body = response
        .text()
        .await
        .map_err(|e| AppError::UpdateCheck(format!("could not read response body: {e}")))?;

    parse_release(&body)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn body(tag_name: &str, html_url: &str) -> String {
        format!(r#"{{"tag_name":"{tag_name}","html_url":"{html_url}"}}"#)
    }

    #[test]
    fn it_strips_a_leading_v_from_the_tag() {
        let result = parse_release(&body("v1.2.3", "https://example.com/releases/v1.2.3")).unwrap();
        assert_eq!(result.latest_version, "1.2.3");
        assert_eq!(result.release_url, "https://example.com/releases/v1.2.3");
    }

    #[test]
    fn it_accepts_a_tag_without_a_leading_v() {
        let result = parse_release(&body("1.2.3", "https://example.com")).unwrap();
        assert_eq!(result.latest_version, "1.2.3");
    }

    #[test]
    fn it_accepts_a_release_candidate_tag() {
        let result = parse_release(&body("v1.2.3-rc.4", "https://example.com")).unwrap();
        assert_eq!(result.latest_version, "1.2.3-rc.4");
    }

    #[test]
    fn it_rejects_a_malformed_version() {
        let err = parse_release(&body("not-a-version", "https://example.com")).unwrap_err();
        assert!(matches!(err, AppError::UpdateCheck(_)));
    }

    #[test]
    fn it_rejects_an_incomplete_semver() {
        let err = parse_release(&body("v1.2", "https://example.com")).unwrap_err();
        assert!(matches!(err, AppError::UpdateCheck(_)));
    }

    #[test]
    fn it_rejects_a_malformed_prerelease_suffix() {
        let err = parse_release(&body("v1.2.3-beta.1", "https://example.com")).unwrap_err();
        assert!(matches!(err, AppError::UpdateCheck(_)));
    }

    #[test]
    fn it_errors_when_tag_name_is_missing() {
        let json = r#"{"html_url":"https://example.com"}"#;
        let err = parse_release(json).unwrap_err();
        assert!(matches!(err, AppError::UpdateCheck(_)));
    }

    #[test]
    fn it_errors_when_html_url_is_missing() {
        let json = r#"{"tag_name":"v1.2.3"}"#;
        let err = parse_release(json).unwrap_err();
        assert!(matches!(err, AppError::UpdateCheck(_)));
    }

    #[test]
    fn it_errors_on_malformed_json() {
        let err = parse_release("not json").unwrap_err();
        assert!(matches!(err, AppError::UpdateCheck(_)));
    }
}
