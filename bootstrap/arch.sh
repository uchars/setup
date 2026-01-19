#!/usr/bin/env bash
set -euo pipefail

log "Arch / CachyOS bootstrap"

is_installed() {
  pacman -Qi "$1" &>/dev/null
}

log "Installing base packages"
sudo pacman -S --noconfirm --needed base-devel git curl

if ! command_exists yay; then
  log "Installing yay (AUR helper)"
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT

  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  pushd "$tmpdir/yay" >/dev/null
  makepkg -si --noconfirm
  popd >/dev/null
else
  log "yay already installed"
fi

aur_install() {
  yay -S --noconfirm --needed "$@"
}
export -f aur_install

if [[ -f packages/arch.txt ]]; then
  log "Installing pacman packages"
  sudo pacman -S --noconfirm --needed $(grep -vE '^\s*#|^\s*$' packages/arch.txt)
fi

if [[ -f packages/arch-aur.txt ]]; then
  log "Installing AUR packages"
  mapfile -t aur_pkgs < packages/arch-aur.txt
  [[ ${#aur_pkgs[@]} -gt 0 ]] && aur_install "${aur_pkgs[@]}"
fi

