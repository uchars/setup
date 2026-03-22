#!/usr/bin/env bash

log() {
  printf "\n==> %s\n" "$1"
}

command_exists() {
  command -v "$1" &>/dev/null
}

ensure_flatpak() {
  if ! command_exists flatpak; then
    log "flatpak not found; attempting to install"
    if command_exists apt-get; then
      sudo apt-get update && sudo apt-get install -y flatpak || true
    elif command_exists dnf; then
      sudo dnf install -y flatpak || true
    else
      log "No supported package manager found to install flatpak; please install it manually"
    fi
  fi

  if command_exists flatpak; then
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
  fi
}

install_flatpaks() {
  if [ "$#" -eq 0 ]; then
    return 0
  fi
  ensure_flatpak
  if ! command_exists flatpak; then
    log "Skipping flatpak installs because flatpak is unavailable"
    return 1
  fi

  for id in "$@"; do
    if flatpak list --app | awk '{print $1}' | grep -x "$id" >/dev/null 2>&1; then
      log "Flatpak $id already installed"
    else
      log "Installing flatpak $id"
      sudo flatpak install -y flathub "$id" || log "flatpak install failed for $id"
    fi
  done
}

