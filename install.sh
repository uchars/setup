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

source "$ROOT_DIR/bootstrap/fedora.sh" || true

log "Applying dotfiles"
chezmoi init --apply https://github.com/uchars/.files.git --force

source "$ROOT_DIR/system/system.sh" || true
source "$ROOT_DIR/system/fonts.sh" || true
source "$ROOT_DIR/system/dwm.sh" || true
source "$ROOT_DIR/system/npm.sh" || true
source "$ROOT_DIR/system/nvim.sh" || true
source "$ROOT_DIR/system/fvm.sh" || true

log "Done"

