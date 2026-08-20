// Mirrors src/core/src/models/pagination.rs — fields are kept snake_case on
// the wire (no camelCase transform), matching the standard API contract and
// the rest of this codebase's Tauri command payloads.

export interface PaginationMeta {
  page: number;
  page_size: number;
  total_pages: number;
  total_items: number;
  has_next: boolean;
  has_prev: boolean;
}

export interface PaginatedResponse<T> {
  data: T[];
  pagination: PaginationMeta;
}
