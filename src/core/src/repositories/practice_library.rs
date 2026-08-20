use serde::Serialize;

use crate::database::Db;
use crate::error::AppError;
use crate::repositories::user_test_sessions;

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

pub async fn count_reading_published(pool: &Db) -> Result<i64, AppError> {
    let count = sqlx::query_scalar!("SELECT COUNT(*) FROM reading_tests WHERE status = 'published'")
        .fetch_one(pool)
        .await?;
    Ok(count)
}

pub async fn count_writing_published(pool: &Db) -> Result<i64, AppError> {
    let count = sqlx::query_scalar!("SELECT COUNT(*) FROM writing_tests WHERE status = 'published'")
        .fetch_one(pool)
        .await?;
    Ok(count)
}

pub async fn count_listening_published(pool: &Db) -> Result<i64, AppError> {
    let count = sqlx::query_scalar!("SELECT COUNT(*) FROM listening_tests WHERE status = 'published'")
        .fetch_one(pool)
        .await?;
    Ok(count)
}

pub async fn find_reading_page(
    pool: &Db,
    offset: i64,
    limit: i64,
) -> Result<Vec<PracticeTestRow>, AppError> {
    let rows = sqlx::query!(
        "SELECT id, title, difficulty, duration, created_at FROM reading_tests
         WHERE status = 'published' ORDER BY created_at DESC LIMIT ? OFFSET ?",
        limit,
        offset
    )
    .fetch_all(pool)
    .await?;
    Ok(rows
        .into_iter()
        .map(|r| PracticeTestRow {
            id: r.id,
            title: r.title,
            module: "reading".to_string(),
            difficulty: r.difficulty,
            duration: r.duration,
            created_at: r.created_at,
        })
        .collect())
}

pub async fn find_writing_page(
    pool: &Db,
    offset: i64,
    limit: i64,
) -> Result<Vec<PracticeTestRow>, AppError> {
    let rows = sqlx::query!(
        "SELECT id, title, created_at FROM writing_tests
         WHERE status = 'published' ORDER BY created_at DESC LIMIT ? OFFSET ?",
        limit,
        offset
    )
    .fetch_all(pool)
    .await?;
    Ok(rows
        .into_iter()
        .map(|r| PracticeTestRow {
            id: r.id,
            title: r.title,
            module: "writing".to_string(),
            difficulty: "7".to_string(),
            duration: "60 mins".to_string(),
            created_at: r.created_at,
        })
        .collect())
}

pub async fn find_listening_page(
    pool: &Db,
    offset: i64,
    limit: i64,
) -> Result<Vec<PracticeTestRow>, AppError> {
    let rows = sqlx::query!(
        "SELECT id, title, difficulty, duration, created_at FROM listening_tests
         WHERE status = 'published' ORDER BY created_at DESC LIMIT ? OFFSET ?",
        limit,
        offset
    )
    .fetch_all(pool)
    .await?;
    Ok(rows
        .into_iter()
        .map(|r| PracticeTestRow {
            id: r.id,
            title: r.title,
            module: "listening".to_string(),
            difficulty: r.difficulty,
            duration: r.duration,
            created_at: r.created_at,
        })
        .collect())
}

/// Fetches every published test across all three modules, merge-sorts them by
/// `created_at DESC`, and slices the requested page in Rust. This app's local
/// dataset is small enough that this avoids the complexity of a dynamic SQL
/// `UNION` (which `sqlx::query_as!`'s compile-time checking doesn't support
/// across differently-shaped tables).
pub async fn find_all_page(
    pool: &Db,
    offset: i64,
    limit: i64,
) -> Result<(Vec<PracticeTestRow>, i64), AppError> {
    let reading = find_reading_page(pool, 0, i64::MAX).await?;
    let writing = find_writing_page(pool, 0, i64::MAX).await?;
    let listening = find_listening_page(pool, 0, i64::MAX).await?;

    let mut all: Vec<PracticeTestRow> = Vec::with_capacity(reading.len() + writing.len() + listening.len());
    all.extend(reading);
    all.extend(writing);
    all.extend(listening);
    all.sort_by(|a, b| b.created_at.cmp(&a.created_at));

    let total = all.len() as i64;
    let start = offset.clamp(0, total) as usize;
    let end = (offset + limit).clamp(0, total) as usize;
    let page = if start < end {
        all[start..end].to_vec()
    } else {
        Vec::new()
    };
    Ok((page, total))
}

/// Merges session progress (status/progress/score/last active/session id) for
/// the given user onto each test row, picking the session with the highest
/// `attempt_number` per test.
pub async fn merge_sessions(
    pool: &Db,
    user_id: &str,
    rows: Vec<PracticeTestRow>,
) -> Result<Vec<PracticeTestCard>, AppError> {
    let sessions = user_test_sessions::find_all(pool, user_id).await?;
    let mut latest: std::collections::HashMap<(String, String), &user_test_sessions::UserTestSession> =
        std::collections::HashMap::new();
    for session in &sessions {
        let key = (session.test_type.clone(), session.test_id.clone());
        match latest.get(&key) {
            Some(existing) if existing.attempt_number >= session.attempt_number => {}
            _ => {
                latest.insert(key, session);
            }
        }
    }

    Ok(rows
        .into_iter()
        .map(|row| {
            let session = latest.get(&(row.module.clone(), row.id.clone()));
            PracticeTestCard {
                id: row.id,
                title: row.title,
                module: row.module,
                difficulty: row.difficulty,
                duration: row.duration,
                status: session
                    .map(|s| s.status.clone())
                    .unwrap_or_else(|| "not_started".to_string()),
                progress_percent: session.map(|s| s.progress_percent).unwrap_or(0),
                score_band: session.and_then(|s| s.score_band),
                last_active_at: session.map(|s| s.last_active_at.clone()),
                session_id: session.map(|s| s.id.clone()),
                created_at: row.created_at,
            }
        })
        .collect())
}
