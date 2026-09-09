#!/bin/sh
#
# IELTS Mastery Hub - Unix installer (Linux / macOS)
#
# Copyright (C) 2026-present
# Licensed under the MIT License.
#
# TODO(everyone): Keep this script simple and easily auditable.
#
# Usage:
#   curl -fsSL https://ielts-mastery-hub.dev/install/install.sh | sh
#
# Env vars:
#   v            Version to install (e.g. "1.0.0"). Defaults to the
#                latest GitHub release.
#   IMH_INSTALL  Install directory. Defaults to "$HOME/.ielts-mastery-hub".
#   IMH_PACKAGE  Package format to install. One of:
#                  appimage | deb | rpm | dmg | app
#                Defaults to an OS/tool auto-detected format.

set -e

REPO="open-lingua/ielts-mastery-hub"
APP_NAME="ielts-mastery-hub"

# ----------------------------------------------------------------------------
# Output helpers
# ----------------------------------------------------------------------------

info() {
  printf '==> %s\n' "$1"
}

err() {
  printf 'error: %s\n' "$1" >&2
}

die() {
  err "$1"
  exit 1
}

# ----------------------------------------------------------------------------
# --help
# ----------------------------------------------------------------------------

show_help() {
  cat <<'EOF'
IELTS Mastery Hub installer (Linux / macOS)

Usage:
  curl -fsSL https://ielts-mastery-hub.dev/install/install.sh | sh
  sh install.sh [--help]

Environment variables:
  v            Version to install, e.g. v=1.0.1-rc.2 (defaults to latest
               GitHub release).
  IMH_INSTALL  Install directory (defaults to "$HOME/.ielts-mastery-hub").
  IMH_PACKAGE  Package format to install: appimage | deb | rpm | dmg | app
               (defaults to an auto-detected format for your platform).

Examples:
  v=1.0.1-rc.2 sh install.sh
  IMH_PACKAGE=deb sh install.sh
  IMH_INSTALL="$HOME/apps/imh" sh install.sh
EOF
}

for arg in "$@"; do
  case "$arg" in
    --help|-h)
      show_help
      exit 0
      ;;
  esac
done

# ----------------------------------------------------------------------------
# OS check (Windows is not supported by this script)
# ----------------------------------------------------------------------------

check_os() {
  if [ "${OS:-}" = "Windows_NT" ]; then
    die "this script only supports Linux and macOS. On Windows, download an installer manually from https://github.com/${REPO}/releases"
  fi
}

# ----------------------------------------------------------------------------
# Dependency checks
# ----------------------------------------------------------------------------

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    die "required command '$1' not found. Please install it and re-run this script."
  fi
}

# ----------------------------------------------------------------------------
# Platform / architecture detection
# ----------------------------------------------------------------------------

detect_platform() {
  uname_sm=$(uname -sm)

  case "$uname_sm" in
    "Darwin arm64")
      platform="macos"
      arch="aarch64"
      ;;
    "Darwin x86_64")
      platform="macos"
      arch="x64"
      ;;
    "Linux aarch64" | "Linux arm64")
      platform="linux"
      arch="aarch64"
      ;;
    "Linux x86_64")
      platform="linux"
      arch="amd64"
      ;;
    *)
      die "unsupported platform: '$uname_sm'. IELTS Mastery Hub only ships prebuilt binaries for macOS (arm64/x86_64) and Linux (x86_64/aarch64)."
      ;;
  esac
}

# ----------------------------------------------------------------------------
# Version resolution
# ----------------------------------------------------------------------------

resolve_version() {
  if [ -n "${v:-}" ]; then
    version=$(printf '%s' "$v" | sed 's/^v//')
    return
  fi

  info "resolving latest release..."

  api_url="https://api.github.com/repos/${REPO}/releases/latest"
  release_json=$(curl --fail --silent --location "$api_url") ||
    die "could not reach $api_url to resolve the latest version. Set 'v=<version>' to skip this step."

  # Portable "tag_name" extraction (no grep -P, which is unavailable on
  # macOS/BSD grep): isolate the tag_name line, then strip everything but
  # the quoted value.
  tag=$(printf '%s\n' "$release_json" |
    tr -d '\r' |
    grep '"tag_name"' |
    head -n 1 |
    sed 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

  [ -n "$tag" ] || die "could not determine the latest version from the GitHub API response. Set 'v=<version>' to skip this step."

  version=$(printf '%s' "$tag" | sed 's/^v//')
}

# ----------------------------------------------------------------------------
# Package format selection
# ----------------------------------------------------------------------------

select_package() {
  if [ -n "${IMH_PACKAGE:-}" ]; then
    package="$IMH_PACKAGE"
  elif [ "$platform" = "macos" ]; then
    package="dmg"
  else
    if command -v dpkg >/dev/null 2>&1; then
      package="deb"
    elif command -v rpm >/dev/null 2>&1; then
      package="rpm"
    else
      package="appimage"
    fi
  fi

  case "$package" in
    appimage | deb | rpm | dmg | app) ;;
    *) die "unsupported IMH_PACKAGE '$package'. Expected one of: appimage, deb, rpm, dmg, app" ;;
  esac

  # Validate the package makes sense for the detected platform.
  if [ "$platform" = "macos" ]; then
    case "$package" in
      dmg | app) ;;
      *) die "IMH_PACKAGE='$package' is not valid on macOS. Use 'dmg' or 'app'." ;;
    esac
  else
    case "$package" in
      appimage | deb | rpm) ;;
      *) die "IMH_PACKAGE='$package' is not valid on Linux. Use 'appimage', 'deb', or 'rpm'." ;;
    esac
  fi

  # Check only the dependency actually needed by the chosen path.
  case "$package" in
    deb)
      require_cmd sudo
      require_cmd dpkg
      ;;
    rpm)
      require_cmd sudo
      require_cmd rpm
      ;;
    dmg)
      require_cmd hdiutil
      ;;
    app)
      require_cmd tar
      ;;
  esac
}

# ----------------------------------------------------------------------------
# Asset filename / URL construction
# ----------------------------------------------------------------------------

asset_name() {
  if [ "$platform" = "macos" ]; then
    case "$package" in
      dmg) printf '%s_%s_%s.dmg' "$APP_NAME" "$version" "$arch" ;;
      app) printf '%s_%s.app.tar.gz' "$APP_NAME" "$arch" ;;
    esac
    return
  fi

  # Linux
  case "$arch" in
    amd64)
      case "$package" in
        appimage) printf '%s_%s_amd64.AppImage' "$APP_NAME" "$version" ;;
        deb) printf '%s_%s_amd64.deb' "$APP_NAME" "$version" ;;
        rpm) printf '%s-%s-1.x86_64.rpm' "$APP_NAME" "$version" ;;
      esac
      ;;
    aarch64)
      case "$package" in
        appimage) printf '%s_%s_aarch64.AppImage' "$APP_NAME" "$version" ;;
        deb) printf '%s_%s_arm64.deb' "$APP_NAME" "$version" ;;
        rpm) printf '%s-%s-1.aarch64.rpm' "$APP_NAME" "$version" ;;
      esac
      ;;
  esac
}

# ----------------------------------------------------------------------------
# Download
# ----------------------------------------------------------------------------

tmp_dir=""

cleanup() {
  if [ -n "$tmp_dir" ] && [ -d "$tmp_dir" ]; then
    rm -rf "$tmp_dir"
  fi
}

download() {
  asset=$(asset_name)
  [ -n "$asset" ] || die "could not determine a download asset for platform='$platform' arch='$arch' package='$package'"

  url="https://github.com/${REPO}/releases/download/${version}/${asset}"

  tmp_dir=$(mktemp -d)
  trap cleanup EXIT INT TERM

  archive_path="$tmp_dir/$asset"

  info "downloading $asset (version $version)..."
  if ! curl --fail --location --progress-bar --output "$archive_path" "$url"; then
    die "failed to download '$asset'. This may mean version '$version' has no '$package' asset for your platform. Try a different IMH_PACKAGE, or check https://github.com/${REPO}/releases"
  fi
}

# ----------------------------------------------------------------------------
# Checksum verification
# ----------------------------------------------------------------------------

verify_checksum() {
  api_url="https://api.github.com/repos/${REPO}/releases/tags/${version}"
  release_json=$(curl --fail --silent --location "$api_url") || {
    info "could not fetch release metadata to verify checksum; skipping."
    return
  }

  # Extract the "digest" field for the object whose "name" matches our asset.
  # Portable, line-oriented parse (no jq dependency): walk the JSON text
  # looking for the asset's name, then the next digest field after it.
  expected_digest=$(printf '%s\n' "$release_json" |
    tr -d '\r' |
    tr ',' '\n' |
    awk -v asset="$asset" '
      index($0, "\"name\"") && index($0, asset) { found=1 }
      found && index($0, "\"digest\"") {
        line=$0
        sub(/.*"digest"[[:space:]]*:[[:space:]]*"/, "", line)
        sub(/".*/, "", line)
        print line
        exit
      }
    ')

  expected_sha256=$(printf '%s' "$expected_digest" | sed -n 's/^sha256://p')

  [ -n "$expected_sha256" ] || {
    info "no checksum published for '$asset'; skipping verification."
    return
  }

  if command -v sha256sum >/dev/null 2>&1; then
    actual_sha256=$(sha256sum "$archive_path" | awk '{print $1}')
  elif command -v shasum >/dev/null 2>&1; then
    actual_sha256=$(shasum -a 256 "$archive_path" | awk '{print $1}')
  else
    info "warning: neither sha256sum nor shasum is available; skipping checksum verification."
    return
  fi

  [ "$actual_sha256" = "$expected_sha256" ] ||
    die "checksum mismatch for '$asset': expected $expected_sha256, got $actual_sha256"

  info "checksum verified."
}

# ----------------------------------------------------------------------------
# Install directory
# ----------------------------------------------------------------------------

install_dir="${IMH_INSTALL:-$HOME/.ielts-mastery-hub}"
bin_dir="$install_dir/bin"

# ----------------------------------------------------------------------------
# Package-specific installation
# ----------------------------------------------------------------------------

install_appimage() {
  mkdir -p "$bin_dir"
  cp "$archive_path" "$bin_dir/$APP_NAME"
  chmod +x "$bin_dir/$APP_NAME"
  ln -sf "$bin_dir/$APP_NAME" "$bin_dir/imh"
  did_install_binary=1
}

install_deb() {
  info "installing .deb package (requires sudo)..."
  if ! sudo dpkg -i "$archive_path"; then
    info "resolving missing dependencies via apt-get..."
    sudo apt-get install -f -y
  fi
}

install_rpm() {
  info "installing .rpm package (requires sudo)..."
  if command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y "$archive_path"
  else
    sudo rpm -i "$archive_path"
  fi
}

app_target_dir() {
  if [ -w "/Applications" ]; then
    printf '/Applications'
  else
    mkdir -p "$HOME/Applications"
    printf '%s' "$HOME/Applications"
  fi
}

install_dmg() {
  info "mounting disk image..."
  mount_point="$tmp_dir/mnt"
  mkdir -p "$mount_point"

  hdiutil attach "$archive_path" -mountpoint "$mount_point" -nobrowse -quiet ||
    die "failed to mount '$archive_path'"

  app_bundle=$(find "$mount_point" -maxdepth 1 -name '*.app' | head -n 1)
  [ -n "$app_bundle" ] || {
    hdiutil detach "$mount_point" -quiet 2>/dev/null || true
    die "no .app bundle found inside the downloaded disk image"
  }

  target_dir=$(app_target_dir)
  info "installing app to $target_dir..."
  cp -R "$app_bundle" "$target_dir/"

  hdiutil detach "$mount_point" -quiet
  installed_app_path="$target_dir/$(basename "$app_bundle")"
}

install_app_tarball() {
  info "extracting app bundle..."
  tar -xzf "$archive_path" -C "$tmp_dir"

  app_bundle=$(find "$tmp_dir" -maxdepth 2 -name '*.app' | head -n 1)
  [ -n "$app_bundle" ] || die "no .app bundle found inside the downloaded archive"

  target_dir=$(app_target_dir)
  info "installing app to $target_dir..."
  cp -R "$app_bundle" "$target_dir/"
  installed_app_path="$target_dir/$(basename "$app_bundle")"
}

did_install_binary=0
installed_app_path=""

install_package() {
  case "$package" in
    appimage) install_appimage ;;
    deb) install_deb ;;
    rpm) install_rpm ;;
    dmg) install_dmg ;;
    app) install_app_tarball ;;
  esac
}

# ----------------------------------------------------------------------------
# PATH setup (only relevant for the AppImage/binary install)
# ----------------------------------------------------------------------------

profile_file() {
  shell_name=$(basename "${SHELL:-}")
  case "$shell_name" in
    zsh) printf '%s/.zshrc' "$HOME" ;;
    bash) printf '%s/.bashrc' "$HOME" ;;
    fish) printf '%s/.config/fish/config.fish' "$HOME" ;;
    *) printf '%s/.profile' "$HOME" ;;
  esac
}

setup_path() {
  [ "$did_install_binary" = "1" ] || return 0

  if command -v "$APP_NAME" >/dev/null 2>&1; then
    return 0
  fi

  profile="$(profile_file)"
  mkdir -p "$(dirname "$profile")"
  touch "$profile"

  if grep -q "IMH_INSTALL=" "$profile" 2>/dev/null; then
    info "PATH already configured in $profile"
    return 0
  fi

  info "adding $bin_dir to PATH via $profile"

  shell_name=$(basename "${SHELL:-}")
  if [ "$shell_name" = "fish" ]; then
    printf '\n# Added by the IELTS Mastery Hub installer\nset -gx IMH_INSTALL "%s"\nset -gx PATH "$IMH_INSTALL/bin" $PATH\n' "$install_dir" >>"$profile"
  else
    printf '\n# Added by the IELTS Mastery Hub installer\nexport IMH_INSTALL="%s"\nexport PATH="$IMH_INSTALL/bin:$PATH"\n' "$install_dir" >>"$profile"
  fi

  path_updated=1
}

path_updated=0

# ----------------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------------

main() {
  check_os
  require_cmd curl

  detect_platform
  resolve_version
  select_package

  download
  verify_checksum
  install_package
  setup_path

  info "IELTS Mastery Hub $version installed successfully."

  if [ "$did_install_binary" = "1" ]; then
    printf 'Installed to: %s\n' "$bin_dir/$APP_NAME"
    printf 'Run it with: imh (or %s/imh)\n' "$bin_dir"
    if [ "$path_updated" = "1" ]; then
      printf 'Restart your shell (or source your profile) to update PATH.\n'
    fi
  elif [ -n "$installed_app_path" ]; then
    printf 'Installed to: %s\n' "$installed_app_path"
    printf 'Launch it from Applications or Spotlight as "IELTS Mastery Hub".\n'
  else
    printf 'Installed via %s package.\n' "$package"
    printf 'Launch "IELTS Mastery Hub" from your applications menu.\n'
  fi
}

main "$@"
