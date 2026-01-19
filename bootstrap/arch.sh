#!/usr/bin/env bash
set -euo pipefail

log "Arch / CachyOS bootstrap"

is_installed() {
  pacman -Qi "$1" &>/dev/null
}

install_pacman() {
  sudo pacman -S --noconfirm --needed "$@"
}

log "Installing base packages"
install_pacman base-devel git curl

if ! command_exists paru; then
  log "Installing paru (AUR helper)"
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT

  git clone https://aur.archlinux.org/paru.git "$tmpdir/paru"
  pushd "$tmpdir/paru" >/dev/null
  makepkg -si --noconfirm
  popd >/dev/null
else
  log "paru already installed"
fi

aur_install() {
  paru -S --noconfirm --needed "$@"
}
export -f aur_install

if [[ -f packages/arch.txt ]]; then
  log "Installing pacman packages"
  sudo pacman -S --noconfirm --needed - < packages/arch.txt
fi

if [[ -f packages/arch-aur.txt ]]; then
  log "Installing AUR packages"
  mapfile -t aur_pkgs < packages/arch-aur.txt
  [[ ${#aur_pkgs[@]} -gt 0 ]] && aur_install "${aur_pkgs[@]}"
fi

