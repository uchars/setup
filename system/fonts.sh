#!/usr/bin/env bash
set -euo pipefail

if ! declare -F log >/dev/null 2>&1 || ! declare -F command_exists >/dev/null 2>&1; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
  source "$ROOT_DIR/scripts/helpers.sh"
fi

NERD_FONTS=(Hack SourceCodePro 3270)

download_font_zip() {
  local url="$1"
  local out="$2"

  if command_exists curl; then
    curl -fL "$url" -o "$out"
  elif command_exists wget; then
    wget -qO "$out" "$url"
  else
    log "curl/wget not found; cannot download fonts"
    return 1
  fi
}

nerd_font_exists() {
  local font_name="$1"
  local install_dir="$HOME/.local/share/fonts/NerdFonts/$font_name"

  compgen -G "$install_dir/*.ttf" >/dev/null || \
    compgen -G "$install_dir/*.otf" >/dev/null || \
    compgen -G "$install_dir/*.ttc" >/dev/null || \
    compgen -G "$install_dir/*.otc" >/dev/null
}

install_nerd_font() {
  local font_name="$1"
  local install_dir="$HOME/.local/share/fonts/NerdFonts/$font_name"
  local zip_path="$TMP_DIR/$font_name.zip"
  local url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font_name.zip"

  if nerd_font_exists "$font_name"; then
    log "$font_name Nerd Font already installed, skipping"
    return 0
  fi

  log "Installing $font_name Nerd Font"
  mkdir -p "$install_dir"
  download_font_zip "$url" "$zip_path"
  unzip -o "$zip_path" -d "$install_dir" >/dev/null
}

log "Installing Nerd Fonts"
all_fonts_installed=true
for font_name in "${NERD_FONTS[@]}"; do
  if ! nerd_font_exists "$font_name"; then
    all_fonts_installed=false
    break
  fi
done

if [[ "$all_fonts_installed" == true ]]; then
  log "All configured Nerd Fonts already installed, skipping"
  return 0 2>/dev/null || exit 0
fi

if ! command_exists unzip; then
  log "unzip unavailable; skipping Nerd Fonts installation"
  return 0 2>/dev/null || exit 0
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

for font_name in "${NERD_FONTS[@]}"; do
  install_nerd_font "$font_name" || log "Failed to install $font_name Nerd Font"
done

if command_exists fc-cache; then
  fc-cache -fv >/dev/null 2>&1 || true
fi

log "Nerd Fonts installation complete"
