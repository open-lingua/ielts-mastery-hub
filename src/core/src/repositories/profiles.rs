use crate::db::Database;
use rusqlite::params;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Profile {
    pub id: String,
    pub full_name: Option<String>,
    pub avatar_url: Option<String>,
    pub plan_type: String,
    pub email: Option<String>,
    pub is_banned: bool,
    pub ban_reason: Option<String>,
    pub banned_until: Option<String>,
    pub updated_at: String,
}

#[derive(Debug, Deserialize)]
pub struct UpdateProfile {
    pub full_name: Option<String>,
    pub avatar_url: Option<String>,
    pub plan_type: Option<String>,
    pub email: Option<String>,
    pub is_banned: Option<bool>,
    pub ban_reason: Option<String>,
    pub banned_until: Option<String>,
}

pub fn find_by_id(db: &Database, id: &str) -> Result<Option<Profile>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let mut stmt = conn
        .prepare(
            "SELECT id, full_name, avatar_url, plan_type, email, is_banned, ban_reason, banned_until, updated_at \
             FROM profiles WHERE id = ?1",
        )
        .map_err(|e| e.to_string())?;
    let result: Option<Profile> = stmt
        .query_map(params![id], map_row)
        .map_err(|e| e.to_string())?
        .next()
        .transpose()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn find_all(db: &Database) -> Result<Vec<Profile>, String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    let mut stmt = conn
        .prepare(
            "SELECT id, full_name, avatar_url, plan_type, email, is_banned, ban_reason, banned_until, updated_at \
             FROM profiles",
        )
        .map_err(|e| e.to_string())?;
    let result: Vec<Profile> = stmt
        .query_map([], map_row)
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    Ok(result)
}

pub fn insert(db: &Database, profile: &Profile) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "INSERT INTO profiles (id, full_name, avatar_url, plan_type, email, is_banned, ban_reason, banned_until, updated_at) \
         VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9)",
        params![
            profile.id, profile.full_name, profile.avatar_url, profile.plan_type, profile.email,
            profile.is_banned as i32, profile.ban_reason, profile.banned_until, profile.updated_at,
        ],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn update(db: &Database, user_id: &str, upd: &UpdateProfile) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute(
        "UPDATE profiles SET \
         full_name = COALESCE(?1, full_name), avatar_url = COALESCE(?2, avatar_url), \
         plan_type = COALESCE(?3, plan_type), email = COALESCE(?4, email), \
         is_banned = COALESCE(?5, is_banned), ban_reason = COALESCE(?6, ban_reason), \
         banned_until = COALESCE(?7, banned_until), \
         updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now') \
         WHERE id = ?8",
        params![
            upd.full_name, upd.avatar_url, upd.plan_type, upd.email,
            upd.is_banned.map(|b| b as i32), upd.ban_reason, upd.banned_until, user_id,
        ],
    )
    .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn delete(db: &Database, user_id: &str) -> Result<(), String> {
    let conn = db.conn.lock().map_err(|e| e.to_string())?;
    conn.execute("DELETE FROM profiles WHERE id = ?1", params![user_id])
        .map_err(|e| e.to_string())?;
    Ok(())
}

fn map_row(row: &rusqlite::Row) -> rusqlite::Result<Profile> {
    Ok(Profile {
        id: row.get(0)?,
        full_name: row.get(1)?,
        avatar_url: row.get(2)?,
        plan_type: row.get(3)?,
        email: row.get(4)?,
        is_banned: row.get::<_, i32>(5)? != 0,
        ban_reason: row.get(6)?,
        banned_until: row.get(7)?,
        updated_at: row.get(8)?,
    })
}
