#!/usr/bin/env bash
set -euo pipefail

ENABLE_NVIDIA=false

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ROOT_DIR

source "$ROOT_DIR/scripts/helpers.sh"

RUN_PLYMOUTH=false
RUN_GNOME=false
RUN_KDE=false
RUN_FLATPAK=true
for arg in "$@"; do
  case "$arg" in
    --nvidia)
      log "enable nvidia support"
      ENABLE_NVIDIA=true
      ;;
    --plymouth)
      log "enable plymouth step"
      RUN_PLYMOUTH=true
      ;;
    --gnome)
      log "enable gnome extensions step"
      RUN_GNOME=true
      ;;
    --kde)
      log "enable kde step"
      RUN_KDE=true
      ;;
  esac
done
export ENABLE_NVIDIA

DISTRO="$(. /etc/os-release && echo "$ID")"
log "Detected distro: $DISTRO"

case "$DISTRO" in
  arch|cachyos)
  source "$ROOT_DIR/bootstrap/arch.sh" | tee $HOME/.local/bootstrap.log
  RUN_FLATPAK=false
  ;;
  linuxmint|debian)
  source "$ROOT_DIR/bootstrap/mint.sh" | tee $HOME/.local/bootstrap-mint.log
  ;;
  fedora)
  source "$ROOT_DIR/bootstrap/fedora.sh" | tee $HOME/.local/bootstrap-fedora.log
  ;;
  *)
  log "Unsupported distro: $DISTRO"
  exit 1
  ;;
esac

log "Applying dotfiles"
$HOME/.local/bin/chezmoi init --apply https://github.com/uchars/.files.git --force

if [ "$RUN_FLATPAK" = true ] && [ -f "$ROOT_DIR/system/flatpak.sh" ]; then
  source "$ROOT_DIR/system/flatpak.sh" | tee $HOME/.local/flatpaks.log
fi
source "$ROOT_DIR/system/system.sh" | tee $HOME/.local/system.log
source "$ROOT_DIR/system/fonts.sh" | tee $HOME/.local/fonts.log
if [ "$RUN_PLYMOUTH" = true ] && [ -f "$ROOT_DIR/system/plymouth.sh" ]; then
  source "$ROOT_DIR/system/plymouth.sh" | tee $HOME/.local/plymouth.log
fi
if [ "$RUN_GNOME" = true ] && [ -f "$ROOT_DIR/system/gnome.sh" ]; then
  source "$ROOT_DIR/system/gnome.sh" | tee $HOME/.local/gnome.log
fi
source "$ROOT_DIR/system/dwm.sh" | tee $HOME/.local/dwm.log
source "$ROOT_DIR/system/wallpaper.sh" | tee $HOME/.local/wallpaper.log
source "$ROOT_DIR/system/npm.sh" | tee $HOME/.local/npm.log
source "$ROOT_DIR/system/nvim.sh" | tee $HOME/.local/nvim.log
source "$ROOT_DIR/system/fvm.sh" | tee $HOME/.local/fvm.log
if [ "$RUN_KDE" = true ] && [ -f "$ROOT_DIR/system/kde.sh" ]; then
  source "$ROOT_DIR/system/kde.sh" | tee $HOME/.local/kde.log
fi

log "Done"

