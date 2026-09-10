/// Holds the AES-256 key used to encrypt/decrypt stored AI provider credentials.
/// Managed as Tauri app state so commands can access it via `tauri::State`.
pub struct AiConfigKey(pub [u8; 32]);
