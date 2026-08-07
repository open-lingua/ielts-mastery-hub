pub mod commands;
pub mod db;
pub mod repositories;

use tauri::Manager;

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .setup(|app| {
            let database = db::init(app)?;
            app.manage(database);
            Ok(())
        })
        .invoke_handler(tauri::generate_handler![
            commands::grade_writing::grade_writing,
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
