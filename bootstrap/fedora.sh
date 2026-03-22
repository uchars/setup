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

  PKGS_DNF=(chezmoi ripgrep fzf source-foundry-hack-fonts cmake libxcb-devel xcb-util-devel xcb-util-wm-devel alacritty python3-pip fastfetch make gcc krita opentoonz steam docker picom @base-x rofi xrandr dunst feh compat-ffmpeg4 golang ninja clang eglinfo git make gcc libXft-devel libX11-devel libXinerama-devel)

  sudo dnf install -y ffmpeg --allowerasing

  log "Updating dnf repositories"
  sudo dnf makecache --refresh || true

  log "Installing DNF packages"
  sudo dnf install -y "${PKGS_DNF[@]}" || log "Some dnf packages failed to install"

  sudo dnf group install -y development-tools

  if command_exists docker; then
    sudo systemctl enable --now docker || true
    sudo usermod -aG docker "$USER" || true
  fi

  log "Fedora bootstrap completed"
}

bootstrap_fedora "$@"
