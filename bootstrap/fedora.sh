#!/usr/bin/env bash
set -euo pipefail

bootstrap_fedora() {
  ensure_sudo

  sudo dnf update -y

  sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
  sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
  sudo dnf install -y ffmpeg --allowerasing
  sudo dnf install -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
  sudo dnf install -y mesa-va-drivers-freeworld

  PKGS_DNF=(kcolorchooser pipx yt-dlp firefox wiremix pipewire-libs dbus-devel pkgconf-pkg-config runc cups chezmoi ripgrep fzf source-foundry-hack-fonts cmake libxcb-devel xcb-util-devel xcb-util-wm-devel alacritty python3-pip fastfetch make gcc krita opentoonz steam docker picom @base-x rofi xrandr dunst feh compat-ffmpeg4 golang ninja clang eglinfo git make gcc libXft-devel libX11-devel libXinerama-devel xorg-x11-server-Xorg xorg-x11-xinit)

  log "Updating dnf repositories"
  sudo dnf makecache --refresh || true

  log "Installing DNF packages"
  sudo dnf install -y "${PKGS_DNF[@]}" || log "Some dnf packages failed to install"

  sudo dnf group install -y development-tools
  sudo dnf group install -y virtualization

  if command_exists docker; then
    sudo systemctl enable --now docker || true
    sudo usermod -aG docker "$USER" || true
  fi

  if [ ! -f /etc/dracut.conf.d/ble.conf ]; then
    sudo mkdir -p /etc/dracut.conf.d
    echo 'add_dracutmodules+=" bluetooth "' | sudo tee /etc/dracut.conf.d/ble.conf > /dev/null
    sudo dracut --regenerate-all --force
  fi

  pipx install konsave

  sudo dnf install -y kernel-devel
  sudo dnf config-manager addrepo --overwrite --from-repofile=https://download.opensuse.org/repositories/hardware:razer/Fedora_$(rpm -E %fedora)/hardware:razer.repo
  sudo dnf install -y openrazer-meta
  sudo usermod -aG plugdev "${SUDO_USER:-$USER}"
  sudo dnf config-manager addrepo --overwrite --from-repofile=https://openrazer.github.io/hardware:razer.repo
  sudo dnf install -y polychromatic


  log "Fedora bootstrap completed"
}

bootstrap_fedora "$@"
