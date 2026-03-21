#!/usr/bin/env bash
set -euo pipefail

log "Starting GNOME extensions installation"

if command -v gext >/dev/null 2>&1; then
  log "gnome-extensions-cli (gext) already available"
else
  if command -v python3 >/dev/null 2>&1; then
    log "Installing gnome-extensions-cli via pip (user)"
    python3 -m pip install --user gnome-extensions-cli || log "pip install failed"
    export PATH="$HOME/.local/bin:$PATH"
  else
    log "python3 not available; cannot install gnome-extensions-cli"
    exit 1
  fi
fi

EXTS=(
  dash-to-panel@jderose9.github.com
  blur-my-shell@aunetx
  drive-menu@gnome-shell-extensions.gcampax.github.com
  arcmenu@arcmenu.com
  appindicatorsupport@rgcjonas.gmail.com
  just-perfection-desktop@just-perfection
  quake-terminal@diegodario88.github.io
  space-bar@luchrioh
  static-workspace-background@CleoMenezesJr.github.io
  user-theme@gnome-shell-extensions.gcampax.github.com
)

for ext in "${EXTS[@]}"; do
  log "Installing GNOME extension: $ext"
  gext install "$ext" || log "gext install failed for $ext"
done

GDM_CONF="$ROOT_DIR/configs/gdm_autologin.conf"
GDM_CONF_DIR="/etc/gdm/custom.conf"
sudo cp "$GDM_CONF" "$GDM_CONF_DIR"

log "GNOME extensions installation complete"
