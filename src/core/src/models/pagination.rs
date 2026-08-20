use serde::{Deserialize, Serialize};

/// Sensible defaults/limits applied when normalizing pagination query params.
const DEFAULT_PAGE: i64 = 1;
const DEFAULT_PAGE_SIZE: i64 = 10;
const MAX_PAGE_SIZE: i64 = 100;

/// Raw `page` / `page_size` query params as received from the frontend.
#[derive(Debug, Clone, Copy, Deserialize)]
pub struct PaginationParams {
    pub page: Option<i64>,
    pub page_size: Option<i64>,
}

impl PaginationParams {
    /// Clamp `page` to `>= 1` and `page_size` to `1..=MAX_PAGE_SIZE`, applying
    /// defaults when not provided. Returns `(page, page_size)`.
    pub fn normalize(&self) -> (i64, i64) {
        let page = self.page.unwrap_or(DEFAULT_PAGE).max(1);
        let page_size = self
            .page_size
            .unwrap_or(DEFAULT_PAGE_SIZE)
            .clamp(1, MAX_PAGE_SIZE);
        (page, page_size)
    }
}

/// Pagination metadata returned alongside paginated data. Field names are kept
/// as literal snake_case on the wire (no `rename_all = "camelCase"`) to match
/// the standard API contract and the existing snake_case convention used
/// throughout Tauri command payloads in this codebase.
#[derive(Debug, Clone, Serialize)]
pub struct PaginationMeta {
    pub page: i64,
    pub page_size: i64,
    pub total_pages: i64,
    pub total_items: i64,
    pub has_next: bool,
    pub has_prev: bool,
}

/// Standard pagination envelope: `{ data: [...], pagination: {...} }`.
#[derive(Debug, Serialize)]
pub struct PaginatedResponse<T> {
    pub data: Vec<T>,
    pub pagination: PaginationMeta,
}

/// Builds `PaginationMeta` from an already-normalized `page`/`page_size` and
/// the total number of items available.
pub fn build_pagination(page: i64, page_size: i64, total_items: i64) -> PaginationMeta {
    let total_pages = if total_items == 0 {
        0
    } else {
        (total_items + page_size - 1) / page_size
    };
    PaginationMeta {
        page,
        page_size,
        total_pages,
        total_items,
        has_next: page < total_pages,
        has_prev: page > 1 && total_pages > 0,
    }
}

/// Computes the SQL `OFFSET` for a normalized `page`/`page_size`.
pub fn offset_for(page: i64, page_size: i64) -> i64 {
    (page - 1) * page_size
}
