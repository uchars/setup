#!/usr/bin/env bash
set -euo pipefail

if ! command_exists plymouth; then
	log "Plymouth not installed"
	exit 0;
fi

log "adding 'splash quiet loglevel=3' to boot entries"
BOOT_ENTRIES_DIR="/boot/loader/entries"
find $BOOT_ENTRIES_DIR -maxdepth 1 -name '*.conf' -type f | while read -r entry; do
    log "checking $entry"
    [ -f "$entry" ] || continue
    if grep -q '^options' "$entry"; then
        if ! grep -q '^options .*splash' "$entry"; then
            sudo sed -i \
                '/^options / s/$/ splash quiet loglevel=3/' \
                "$entry"
            log "appended plymouth lines to options of $entry"
        fi
    fi
done

if ! grep -q 'plymouth' /etc/mkinitcpio.conf; then
	log "adding plymouth to mkinitcpio"
	if [[ ! -f "$HOME/.local/mkinitcpio.bak" ]]; then
		log "creating backup of initial mkinitcpio"
		cp /etc/mkinitcpio.conf $HOME/.local/mkinitcpio.bak
	else
		log "backup of initial mkinitcpio is already present in $HOME/.local/mkinitcpio.bak"
	fi

    # TODO: handle placing after systemd
    #if echo "$hooks_line" | grep -q 'systemd'; then
    #    log "placing plymouth after systemd"
    #    new_hooks_line=$(echo "$hooks_line" | sed 's/\(systemd\)/\1 plymouth/')
    #else
    #    log "placing plymouth at the third position"
    #    new_hooks_line=$(echo "$hooks_line" | sed -E 's/HOOKS=\((^ ]+ [^ ]+)/HOOKS=(\1 plymouth/')
    #fi
    sudo sed -i -E 's/^(HOOKS=\([[:space:]]*[^[:space:]]+[[:space:]]+[^[:space:]]+[[:space:]]*)/\1plymouth /' "/etc/mkinitcpio.conf"
	sudo mkinitcpio -P
    log "added plymouth"
else
	log "plymouth is already present in mkinitcpio"
fi

log "adding image to the spinner plymouth theme"
THEME_NAME="spinner"
THEME_DIR="/usr/share/plymouth/themes/$THEME_NAME"
PLYMOUTH_IMAGE="$ROOT_DIR/wallpapers/foggy_mountain.jpg"
sudo cp "$PLYMOUTH_IMAGE" "$THEME_DIR/background-tile.jpg"
sudo chmod 644 "$THEME_DIR/background-tile.jpg"

sudo plymouth-set-default-theme -R $THEME_NAME

