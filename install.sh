#!/usr/bin/env bash
set -euo pipefail

ENABLE_NVIDIA=false

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ROOT_DIR

source "$ROOT_DIR/scripts/helpers.sh"

for arg in "$@"; do
    case "$arg" in
        --nvidia)
        log "enable nvidia support"
        ENABLE_NVIDIA=true
        ;;
    esac
done
export ENABLE_NVIDIA

DISTRO="$(. /etc/os-release && echo "$ID")"
log "Detected distro: $DISTRO"

case "$DISTRO" in
  arch|cachyos)
    source "$ROOT_DIR/bootstrap/arch.sh" | tee $HOME/.local/bootstrap.log
    ;;
  *)
    log "Unsupported distro: $DISTRO"
    exit 1
    ;;
esac

source "$ROOT_DIR/system/system.sh" | tee $HOME/.local/system.log
source "$ROOT_DIR/system/plymouth.sh" | tee $HOME/.local/plymouth.log
source "$ROOT_DIR/system/dwm.sh" | tee $HOME/.local/dwm.log
source "$ROOT_DIR/system/wallpaper.sh" | tee $HOME/.local/wallpaper.log
source "$ROOT_DIR/system/npm.sh" | tee $HOME/.local/npm.log
source "$ROOT_DIR/system/nvim.sh" | tee $HOME/.local/nvim.log
log "Applying dotfiles"
chezmoi init --apply https://github.com/uchars/.files.git

log "Done"

