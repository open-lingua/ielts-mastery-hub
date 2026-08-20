//! Mirrors `src/error.rs` (a root-level source file, not under a subfolder),
//! hence living at `tests/root/` rather than a name-mirrored subdirectory.

use app_lib::error::AppError;
use assert_matches::assert_matches;

const NOT_FOUND_MESSAGE: &str = "missing test";
const VALIDATION_MESSAGE: &str = "title is required";

mod display {
    use super::*;

    #[test]
    fn it_formats_not_found_with_the_wrapped_message() {
        // Arrange
        let error = AppError::NotFound(NOT_FOUND_MESSAGE.to_string());

        // Act
        let message = error.to_string();

        // Assert
        assert_eq!(message, format!("not found: {NOT_FOUND_MESSAGE}"));
    }

    #[test]
    fn it_formats_validation_with_the_wrapped_message() {
        // Arrange
        let error = AppError::Validation(VALIDATION_MESSAGE.to_string());

        // Act
        let message = error.to_string();

        // Assert
        assert_eq!(message, format!("validation error: {VALIDATION_MESSAGE}"));
    }

    #[test]
    fn it_formats_serialization_with_the_wrapped_message() {
        // Arrange
        let json_error = serde_json::from_str::<serde_json::Value>("not json").unwrap_err();
        let error = AppError::from(json_error);

        // Act
        let message = error.to_string();

        // Assert
        assert!(message.starts_with("serialization error: "));
    }
}

mod into_string {
    use super::*;

    #[test]
    fn it_converts_not_found_into_its_display_message() {
        // Arrange
        let error = AppError::NotFound(NOT_FOUND_MESSAGE.to_string());

        // Act
        let message: String = error.into();

        // Assert
        assert_eq!(message, format!("not found: {NOT_FOUND_MESSAGE}"));
    }

    #[test]
    fn it_converts_validation_into_its_display_message() {
        // Arrange
        let error = AppError::Validation(VALIDATION_MESSAGE.to_string());

        // Act
        let message: String = error.into();

        // Assert
        assert_eq!(message, format!("validation error: {VALIDATION_MESSAGE}"));
    }
}

mod from_conversions {
    use super::*;

    #[test]
    fn it_wraps_a_serde_json_error_as_serialization_variant() {
        // Arrange
        let json_error = serde_json::from_str::<serde_json::Value>("not json").unwrap_err();

        // Act
        let error = AppError::from(json_error);

        // Assert
        assert_matches!(error, AppError::Serialization(_));
    }
}
