use serde::Serialize;

/// Normalized shape shared across the reading/writing/listening test tables,
/// used to build the combined "All" tab.
#[derive(Debug, Clone)]
pub struct PracticeTestRow {
    pub id: String,
    pub title: String,
    pub module: String,
    pub difficulty: String,
    pub duration: String,
    pub created_at: String,
}

/// A single card in the Practice Library, merging a test row with the
/// current user's session progress (if any).
#[derive(Debug, Clone, Serialize)]
pub struct PracticeTestCard {
    pub id: String,
    pub title: String,
    pub module: String,
    pub difficulty: String,
    pub duration: String,
    pub status: String,
    pub progress_percent: i64,
    pub score_band: Option<f64>,
    pub last_active_at: Option<String>,
    pub session_id: Option<String>,
    pub created_at: String,
}
