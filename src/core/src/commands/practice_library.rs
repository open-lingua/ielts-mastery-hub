use tauri::State;

use crate::database::Db;
use crate::error::AppError;
use crate::models::pagination::{
    build_pagination, offset_for, PaginatedResponse, PaginationParams,
};
use crate::models::practice_library::PracticeTestCard;
use crate::repositories::practice_library;

#[tauri::command]
pub async fn list_practice_tests(
    db: State<'_, Db>,
    user_id: String,
    module: Option<String>,
    page: Option<i64>,
    page_size: Option<i64>,
) -> Result<PaginatedResponse<PracticeTestCard>, String> {
    let (page, page_size) = PaginationParams { page, page_size }.normalize();
    let offset = offset_for(page, page_size);

    let (rows, total_items) = match module.as_deref() {
        Some("reading") => {
            let rows = practice_library::find_reading_page(&db, offset, page_size).await?;
            let total = practice_library::count_reading_published(&db).await?;
            (rows, total)
        }
        Some("writing") => {
            let rows = practice_library::find_writing_page(&db, offset, page_size).await?;
            let total = practice_library::count_writing_published(&db).await?;
            (rows, total)
        }
        Some("listening") => {
            let rows = practice_library::find_listening_page(&db, offset, page_size).await?;
            let total = practice_library::count_listening_published(&db).await?;
            (rows, total)
        }
        None => practice_library::find_all_page(&db, offset, page_size).await?,
        Some(other) => {
            return Err(AppError::Validation(format!(
                "invalid module '{other}': expected one of reading, writing, listening"
            ))
            .into())
        }
    };

    let data = practice_library::merge_sessions(&db, &user_id, rows).await?;
    let pagination = build_pagination(page, page_size, total_items);
    Ok(PaginatedResponse { data, pagination })
}
