use chrono::Utc;
use uuid::Uuid;

#[tauri::command]
pub async fn upload_writing_asset(
    task_id: String,
    file_name: String,
    file_data: Vec<u8>,
) -> Result<String, String> {
    save_writing_asset(&task_id, &file_name, file_data)
        .await
        .map_err(|e| e.to_string())
}

#[tauri::command]
pub async fn upload_listening_audio(
    user_id: String,
    file_name: String,
    file_data: Vec<u8>,
) -> Result<String, String> {
    save_file("listening-audio", &user_id, &file_name, file_data)
        .await
        .map_err(|e| e.to_string())
}

async fn save_writing_asset(
    task_id: &str,
    file_name: &str,
    data: Vec<u8>,
) -> std::io::Result<String> {
    let ext = file_name.rsplit('.').next().unwrap_or("bin");
    let stored_name = format!("{}.{}", task_id, ext);

    let home =
        std::env::var("HOME").map_err(|e| std::io::Error::new(std::io::ErrorKind::NotFound, e))?;

    let dir = std::path::Path::new(&home)
        .join(".ielts-hub")
        .join("writing-assets");

    tokio::fs::create_dir_all(&dir).await?;

    let path = dir.join(&stored_name);
    tokio::fs::write(&path, data).await?;

    Ok(path.to_string_lossy().into_owned())
}

async fn save_file(
    domain: &str,
    user_id: &str,
    file_name: &str,
    data: Vec<u8>,
) -> std::io::Result<String> {
    let ext = file_name.rsplit('.').next().unwrap_or("bin");
    let stored_name = format!(
        "{}-{}.{}",
        Utc::now().timestamp_millis(),
        Uuid::new_v4(),
        ext
    );

    let home =
        std::env::var("HOME").map_err(|e| std::io::Error::new(std::io::ErrorKind::NotFound, e))?;

    let dir = std::path::Path::new(&home)
        .join(".ielts-hub")
        .join(domain)
        .join(user_id);

    tokio::fs::create_dir_all(&dir).await?;

    let path = dir.join(&stored_name);
    tokio::fs::write(&path, data).await?;

    Ok(path.to_string_lossy().into_owned())
}
