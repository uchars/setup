#!/usr/bin/env bash

log() {
  printf "\n==> %s\n" "$1"
}

command_exists() {
  command -v "$1" &>/dev/null
}

