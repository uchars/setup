#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/scripts/helpers.sh"

ensure_sudo() {
  sudo -v || { log "sudo is required"; exit 1; }
}

bootstrap_fedora() {
  ensure_sudo

  sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

  PKGS_DNF=(chezmoi ripgrep fzf source-foundry-hack-fonts cmake libxcb-devel xcb-util-devel xcb-util-wm-devel alacritty python3-pip fastfetch make gcc krita opentoonz steam docker picom @base-x cargo wiremix rofi xrandr dunst feh compat-ffmpeg4 golang ninja clang eglinfo git make gcc libXft-devel libX11-devel libXinerama-devel)

  sudo dnf install -y ffmpeg --allowerasing

  log "Updating dnf repositories"
  sudo dnf makecache --refresh || true

  log "Installing DNF packages"
  sudo dnf install -y "${PKGS_DNF[@]}" || log "Some dnf packages failed to install"

  sudo dnf remove -y firefox

  sudo dnf group install -y development-tools

  if command -v docker >/dev/null 2>&1; then
    sudo systemctl enable --now docker || true
    sudo usermod -aG docker "$USER" || true
  fi

  # Flatpaks requested by user
  FLATPAKS=(com.bitwarden.desktop com.discordapp.Discord com.github.jeromerobert.pdfarranger com.visualstudio.code com.yubico.yubioath org.gnome.Extensions com.usebottles.bottles com.google.AndroidStudio org.kde.haruna org.mozilla.firefox io.github.ungoogled_software.ungoogled_chromium)
  install_flatpaks "${FLATPAKS[@]}" || log "Some flatpak installs failed or were skipped"

  log "Installing cargo packages..."
  cargo install bluetui

  log "If Steam requires RPM Fusion or additional repos, add them manually."

  if ! command -v fvm >/dev/null 2>&1; then
    if command -v curl >/dev/null 2>&1; then
      log "Installing fvm via upstream installer"
      curl -fsSL https://fvm.app/install.sh | bash || log "fvm installer failed"
    elif command -v wget >/dev/null 2>&1; then
      log "Installing fvm via upstream installer (wget)"
      wget -qO- https://fvm.app/install.sh | bash || log "fvm installer failed"
    else
      log "curl/wget not found; attempting to install curl via dnf"
      if sudo dnf install -y curl; then
        curl -fsSL https://fvm.app/install.sh | bash || log "fvm installer failed"
      else
        log "Skipping fvm install (no downloader available)"
      fi
    fi
  fi

  log "Fedora bootstrap completed"
}

bootstrap_fedora "$@"
