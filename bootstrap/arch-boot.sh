#!/usr/bin/env sh
BOOT_CONF_FILE="/boot/loader/loader.conf"
BOOT_ENTRY_DIR="/boot/loader/entries"
DEFAULT_BOOT_ENTRY="arch.conf"

log "setting up arch boot entries..."
# sanity checks
if [ ! -d "$BOOT_ENTRY_DIR" ]; then
  log "entry directory not found, skipping systemd-boot configuration"
  exit 0
fi

if [ ! -f "$BOOT_CONF_FILE" ]; then
  log "loader.conf not found, skipping systemd-boot configuration"
  exit 0
fi

log "configuring systemd-boot"

# --- find newest entry by filename ---
NEWEST_ENTRY="$(ls -1 "$BOOT_ENTRY_DIR"/*.conf 2>/dev/null | sort | tail -n 1)"

if [ -z "$NEWEST_ENTRY" ]; then
  log "no boot entries found, skipping"
  exit 0
fi

NEWEST_BASENAME="$(basename "$NEWEST_ENTRY")"

# --- rename newest entry to arch.conf if needed ---
if [ "$NEWEST_BASENAME" != "$DEFAULT_BOOT_ENTRY" ]; then
  log "renaming newest boot entry $NEWEST_BASENAME -> $DEFAULT_BOOT_ENTRY"
  sudo mv "$NEWEST_ENTRY" "$BOOT_ENTRY_DIR/$DEFAULT_BOOT_ENTRY"
else
  log "newest boot entry already named $DEFAULT_BOOT_ENTRY"
fi

# --- timeout: replace or append ---
if grep -qE '^[[:space:]]*timeout[[:space:]]+' "$BOOT_CONF_FILE"; then
  log "replacing existing timeout with 0"
  sudo sed -i 's/^[[:space:]]*timeout[[:space:]]\+.*/timeout 0/' "$BOOT_CONF_FILE"
else
  log "appending boot timeout 0"
  echo "timeout 0" | sudo tee -a "$BOOT_CONF_FILE" > /dev/null
fi

# --- default entry: replace or append ---
if grep -qE '^[[:space:]]*default[[:space:]]+' "$BOOT_CONF_FILE"; then
  log "changing default boot entry to arch.conf"
  sudo sed -i "s|^[[:space:]]*default[[:space:]]\+.*|default $DEFAULT_BOOT_ENTRY|" "$BOOT_CONF_FILE"
else
  log "appending default boot entry to arch.conf"
  echo "default $DEFAULT_BOOT_ENTRY" | sudo tee -a "$BOOT_CONF_FILE" > /dev/null
fi

