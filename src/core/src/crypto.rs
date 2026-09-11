use std::path::Path;

use aes_gcm::aead::{Aead, Generate, KeyInit};
use aes_gcm::{Aes256Gcm, Key, Nonce};
use base64::engine::general_purpose::STANDARD as BASE64;
use base64::Engine;

use crate::error::AppError;

const KEY_LEN: usize = 32;
const NONCE_LEN: usize = 12;
const KEY_FILE_NAME: &str = "ai_config.key";

/// Loads the AES-256 key used to encrypt/decrypt stored AI provider credentials,
/// generating and persisting a new random key on first run. The key file is stored
/// as a sibling of the SQLite database file, *not* inside the database itself, so a
/// copy of the `.db` file alone does not expose credentials.
pub fn load_or_create_key(db_path: &Path) -> Result<[u8; KEY_LEN], AppError> {
    let key_path = db_path
        .parent()
        .unwrap_or_else(|| Path::new("."))
        .join(KEY_FILE_NAME);

    if key_path.exists() {
        let bytes = std::fs::read(&key_path).map_err(|e| AppError::Validation(e.to_string()))?;
        return bytes
            .try_into()
            .map_err(|_| AppError::Validation("ai_config.key has an unexpected length".into()));
    }

    let key = Key::<Aes256Gcm>::generate();
    let key_bytes: [u8; KEY_LEN] = key.into();

    std::fs::write(&key_path, key_bytes).map_err(|e| AppError::Validation(e.to_string()))?;
    set_owner_only_permissions(&key_path)?;

    Ok(key_bytes)
}

#[cfg(unix)]
fn set_owner_only_permissions(path: &Path) -> Result<(), AppError> {
    use std::os::unix::fs::PermissionsExt;
    let perms = std::fs::Permissions::from_mode(0o600);
    std::fs::set_permissions(path, perms).map_err(|e| AppError::Validation(e.to_string()))
}

#[cfg(not(unix))]
fn set_owner_only_permissions(_path: &Path) -> Result<(), AppError> {
    Ok(())
}

/// Encrypts `plaintext` with AES-256-GCM using a fresh random nonce, returning
/// `base64(nonce || ciphertext)`.
pub fn encrypt(key: &[u8; KEY_LEN], plaintext: &str) -> Result<String, AppError> {
    let key_arr: Key<Aes256Gcm> = (*key).into();
    let cipher = Aes256Gcm::new(&key_arr);
    let nonce = Nonce::generate();
    let ciphertext = cipher
        .encrypt(&nonce, plaintext.as_bytes())
        .map_err(|_| AppError::Validation("failed to encrypt credentials".into()))?;

    let mut combined = Vec::with_capacity(NONCE_LEN + ciphertext.len());
    combined.extend_from_slice(nonce.as_slice());
    combined.extend_from_slice(&ciphertext);

    Ok(BASE64.encode(combined))
}

/// Reverses [`encrypt`]: decodes the base64 envelope, splits off the nonce, and
/// decrypts the remaining ciphertext.
pub fn decrypt(key: &[u8; KEY_LEN], encoded: &str) -> Result<String, AppError> {
    let combined = BASE64
        .decode(encoded)
        .map_err(|_| AppError::Validation("invalid credentials envelope".into()))?;

    if combined.len() < NONCE_LEN {
        return Err(AppError::Validation("invalid credentials envelope".into()));
    }
    let (nonce_bytes, ciphertext) = combined.split_at(NONCE_LEN);
    let nonce = Nonce::try_from(nonce_bytes)
        .map_err(|_| AppError::Validation("invalid credentials envelope".into()))?;

    let key_arr: Key<Aes256Gcm> = (*key).into();
    let cipher = Aes256Gcm::new(&key_arr);
    let plaintext = cipher
        .decrypt(&nonce, ciphertext)
        .map_err(|_| AppError::Validation("failed to decrypt credentials".into()))?;

    String::from_utf8(plaintext)
        .map_err(|_| AppError::Validation("decrypted data was not valid UTF-8".into()))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn test_key() -> [u8; KEY_LEN] {
        [7u8; KEY_LEN]
    }

    #[test]
    fn it_round_trips_encrypt_and_decrypt() {
        let key = test_key();
        let plaintext = r#"{"apiKey":"sk-test-123"}"#;

        let encrypted = encrypt(&key, plaintext).expect("encrypt");
        let decrypted = decrypt(&key, &encrypted).expect("decrypt");

        assert_eq!(decrypted, plaintext);
    }

    #[test]
    fn it_produces_different_ciphertext_for_the_same_plaintext() {
        let key = test_key();
        let plaintext = "same-secret";

        let first = encrypt(&key, plaintext).expect("encrypt 1");
        let second = encrypt(&key, plaintext).expect("encrypt 2");

        assert_ne!(first, second, "nonces should differ across calls");
    }

    #[test]
    fn it_fails_to_decrypt_with_the_wrong_key() {
        let key = test_key();
        let other_key = [9u8; KEY_LEN];
        let encrypted = encrypt(&key, "top-secret").expect("encrypt");

        let result = decrypt(&other_key, &encrypted);

        assert!(result.is_err());
    }

    #[test]
    fn it_fails_to_decrypt_tampered_ciphertext() {
        let key = test_key();
        let mut encrypted = encrypt(&key, "top-secret").expect("encrypt");
        encrypted.pop();
        encrypted.push(if encrypted.ends_with('A') { 'B' } else { 'A' });

        let result = decrypt(&key, &encrypted);

        assert!(result.is_err());
    }

    #[test]
    fn it_fails_on_malformed_envelope() {
        let key = test_key();
        let result = decrypt(&key, "not-valid-base64!!!");
        assert!(result.is_err());
    }

    #[test]
    fn it_generates_and_persists_a_key_file() {
        let dir = std::env::temp_dir().join(format!("imh-crypto-test-{}", uuid::Uuid::new_v4()));
        std::fs::create_dir_all(&dir).expect("create temp dir");
        let db_path = dir.join("imh.db");

        let first = load_or_create_key(&db_path).expect("first load");
        let second = load_or_create_key(&db_path).expect("second load");

        assert_eq!(first, second, "key must persist across calls");
        assert!(dir.join(KEY_FILE_NAME).exists());

        std::fs::remove_dir_all(&dir).ok();
    }
}
