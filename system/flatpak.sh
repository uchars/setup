#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/scripts/helpers.sh"

FLATPAKS=(com.bitwarden.desktop com.discordapp.Discord com.github.jeromerobert.pdfarranger com.visualstudio.code com.yubico.yubioath org.gnome.Extensions com.usebottles.bottles com.google.AndroidStudio org.kde.haruna org.mozilla.firefox io.github.ungoogled_software.ungoogled_chromium io.github.OpenToonz com.valvesoftware.Steam)
install_flatpaks "${FLATPAKS[@]}" || log "Some flatpak installs failed or were skipped"
