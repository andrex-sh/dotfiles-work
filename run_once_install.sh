#!/bin/sh
# One-time system setup for a fresh Ubuntu 24.04 machine: packages, Brave's
# apt repo, a manually-installed Nerd Font (not apt-packaged), bluetooth, and
# kanshi's service (the kanshi package ships no unit of its own - the one
# tracked at dot_config/systemd/user/kanshi.service is hand-authored).
# No display-manager setup here: GDM is Ubuntu's default and already
# installed - sway is just selected as the session at the login screen.
# Re-runs if this file's content changes (chezmoi hashes it).
#
# File manager is Nautilus, video/audio is Totem, images are Loupe - reusing
# GNOME's own apps (they run standalone under sway, no gnome-shell needed)
# instead of Thunar/mpv/qimgv. No discrete GPU on this machine, so no
# rocm-smi-lib and no GPU usage/temp reporting anywhere.
set -eu

sudo apt update
sudo apt install -y \
    sway waybar mako swaylock swaybg foot fuzzel kanshi \
    power-profiles-daemon xwayland lxqt-policykit nm-connection-editor \
    network-manager-gnome bluez blueman \
    playerctl brightnessctl grim slurp wl-clipboard pavucontrol \
    gvfs totem loupe libreoffice pipewire \
    xdg-desktop-portal xdg-desktop-portal-wlr gsimplecal libglib2.0-bin

# Brave: no apt package on Ubuntu, install from Brave's own repo.
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
    https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
    | sudo tee /etc/apt/sources.list.d/brave-browser-release.list >/dev/null
sudo apt update
sudo apt install -y brave-browser

# JetBrains Mono Nerd Font: no apt package, install manually.
font_dir="$HOME/.local/share/fonts"
if [ ! -d "$font_dir/JetBrainsMonoNerdFont" ]; then
    tmp="$(mktemp -d)"
    curl -fsSLo "$tmp/JetBrainsMono.zip" \
        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    mkdir -p "$font_dir/JetBrainsMonoNerdFont"
    unzip -q "$tmp/JetBrainsMono.zip" -d "$font_dir/JetBrainsMonoNerdFont"
    rm -rf "$tmp"
    fc-cache -f "$font_dir" >/dev/null
fi

sudo systemctl enable bluetooth.service

systemctl --user daemon-reload
systemctl --user enable kanshi.service

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
