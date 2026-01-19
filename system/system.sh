#!/usr/bin/env bash
set -euo pipefail

log "System configuration"

if grep -q '^#en_US.UTF-8 UTF-8' /etc/locale.gen; then
  log "Configuring locale"
  sudo sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
  sudo locale-gen
fi

# ---- services ------------------------------------------------

enable_service() {
  sudo systemctl is-enabled "$1" &>/dev/null || sudo systemctl enable "$1"
}

enable_service NetworkManager
enable_service bluetooth

git config --global user.name "Nils"
git config --global user.email "40796807+uchars@users.noreply.github.com"

log "Rebuilding font cache"
fc-cache -fv &>/dev/null || true


TARGET_SHELL="/bin/bash"

if command_exists bash; then
  # Only change shell if it's not already bash
  if [[ "$SHELL" != "$TARGET_SHELL" ]]; then
      log "Changing default shell to $TARGET_SHELL..."
      chsh -s "$TARGET_SHELL"
  else
      log "Default shell is already bash, skipping"
  fi
fi
