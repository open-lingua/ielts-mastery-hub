use thiserror::Error;

#[derive(Debug, Error)]
pub enum AppError {
    #[error("database error: {0}")]
    Database(#[from] sqlx::Error),
    #[error("not found: {0}")]
    NotFound(String),
    #[error("validation error: {0}")]
    Validation(String),
    #[error("serialization error: {0}")]
    Serialization(#[from] serde_json::Error),
}

impl From<AppError> for String {
    fn from(e: AppError) -> String {
        e.to_string()
    }
}
