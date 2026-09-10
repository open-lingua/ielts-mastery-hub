pub mod commands;
pub mod crypto;
pub mod database;
pub mod error;
pub mod models;
pub mod repositories;
pub mod services;
pub mod state;

use tauri::Manager;

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    // Ensure warn!/info!/error! logs (e.g. from database::writing_assets_migration and
    // database::listening_assets_migration) are visible on stderr in both `tauri dev` and
    // packaged builds. Defaults to `info` level when `RUST_LOG` is unset. `try_init` (rather
    // than `init`) is used so a second call (e.g. from tests that also initialize a logger)
    // never panics.
    let _ = env_logger::Builder::from_env(env_logger::Env::default().default_filter_or("info"))
        .try_init();

    tauri::Builder::default()
        .plugin(tauri_plugin_dialog::init())
        .plugin(tauri_plugin_opener::init())
        .setup(|app| {
            if std::env::var("OPEN_DEVTOOLS").as_deref() == Ok("true") {
                if let Some(window) = app.get_webview_window("main") {
                    window.open_devtools();
                }
            }
            let db_url = database::resolve_database_url()?;
            let db_path = database::resolve_db_path(&db_url);
            if let Some(parent) = db_path.parent() {
                std::fs::create_dir_all(parent)?;
            }
            let ai_config_key = crypto::load_or_create_key(&db_path)?;
            app.manage(state::AiConfigKey(ai_config_key));

            let pool = tauri::async_runtime::block_on(database::init(app.handle()))?;
            app.manage(pool);
            Ok(())
        })
        .invoke_handler(tauri::generate_handler![
            commands::grade_writing::grade_writing,
            commands::ai_configurations::list_ai_configurations,
            commands::ai_configurations::save_ai_configuration,
            commands::ai_configurations::delete_ai_configuration,
            commands::ai_configurations::activate_ai_configuration,
            commands::profiles::get_profiles,
            commands::profiles::list_profiles,
            commands::profiles::create_profiles,
            commands::profiles::update_profiles,
            commands::profiles::delete_profiles,
            commands::user_roles::get_user_roles,
            commands::user_roles::list_user_roles,
            commands::user_roles::create_user_roles,
            commands::user_roles::update_user_roles,
            commands::user_roles::delete_user_roles,
            commands::reading_tests::get_reading_tests,
            commands::reading_tests::list_reading_tests,
            commands::reading_tests::create_reading_tests,
            commands::reading_tests::update_reading_tests,
            commands::reading_tests::delete_reading_tests,
            commands::reading_passages::get_reading_passages,
            commands::reading_passages::list_reading_passages,
            commands::reading_passages::create_reading_passages,
            commands::reading_passages::update_reading_passages,
            commands::reading_passages::delete_reading_passages,
            commands::reading_question_groups::get_reading_question_groups,
            commands::reading_question_groups::list_reading_question_groups,
            commands::reading_question_groups::create_reading_question_groups,
            commands::reading_question_groups::update_reading_question_groups,
            commands::reading_question_groups::delete_reading_question_groups,
            commands::reading_questions::get_reading_questions,
            commands::reading_questions::list_reading_questions,
            commands::reading_questions::create_reading_questions,
            commands::reading_questions::update_reading_questions,
            commands::reading_questions::delete_reading_questions,
            commands::writing_tests::get_writing_tests,
            commands::writing_tests::list_writing_tests,
            commands::writing_tests::create_writing_tests,
            commands::writing_tests::update_writing_tests,
            commands::writing_tests::delete_writing_tests,
            commands::writing_tasks::get_writing_tasks,
            commands::writing_tasks::list_writing_tasks,
            commands::writing_tasks::create_writing_tasks,
            commands::writing_tasks::update_writing_tasks,
            commands::writing_tasks::delete_writing_tasks,
            commands::practice_library::list_practice_tests,
            commands::listening_tests::get_listening_tests,
            commands::listening_tests::list_listening_tests,
            commands::listening_tests::create_listening_tests,
            commands::listening_tests::update_listening_tests,
            commands::listening_tests::delete_listening_tests,
            commands::listening_sections::get_listening_sections,
            commands::listening_sections::list_listening_sections,
            commands::listening_sections::create_listening_sections,
            commands::listening_sections::update_listening_sections,
            commands::listening_sections::delete_listening_sections,
            commands::listening_question_groups::get_listening_question_groups,
            commands::listening_question_groups::list_listening_question_groups,
            commands::listening_question_groups::create_listening_question_groups,
            commands::listening_question_groups::update_listening_question_groups,
            commands::listening_question_groups::delete_listening_question_groups,
            commands::listening_questions::get_listening_questions,
            commands::listening_questions::list_listening_questions,
            commands::listening_questions::create_listening_questions,
            commands::listening_questions::update_listening_questions,
            commands::listening_questions::delete_listening_questions,
            commands::user_test_sessions::get_user_test_sessions,
            commands::user_test_sessions::list_user_test_sessions,
            commands::user_test_sessions::create_user_test_sessions,
            commands::user_test_sessions::update_user_test_sessions,
            commands::user_test_sessions::delete_user_test_sessions,
            commands::storage::upload_writing_asset,
            commands::storage::upload_listening_audio,
            commands::export::export_test_to_zip,
            commands::import::validate_import,
            commands::import::import_reading_test,
            commands::import::import_writing_test,
            commands::import::import_listening_test,
            commands::update::check_for_update,
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
