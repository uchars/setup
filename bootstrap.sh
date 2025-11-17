#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/uchars/archsetup.git"
REPO_DIR="$HOME/archsetup"

echo "[*] Updating system…"
sudo pacman -Syu --noconfirm

echo "[*] Installing Ansible…"
sudo pacman -S --needed --noconfirm ansible git

echo "[*] Cloning Ansible repo…"
if [ -d "$REPO_DIR" ]; then
    echo "[*] Repo already exists, pulling latest changes…"
    git -C "$REPO_DIR" pull
else
    git clone "$REPO_URL" "$REPO_DIR"
fi

cd "$REPO_DIR"

echo "[*] Running Ansible playbook…"
ansible-playbook -i inventory.ini playbook.yml

echo "[✔] Bootstrap complete!"

