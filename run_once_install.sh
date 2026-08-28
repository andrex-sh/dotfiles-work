#!/bin/sh
# Fresh Ubuntu 24.04 setup. Re-runs when this file changes (chezmoi hashes it).
# Display manager is GDM, already installed - pick Sway at the login screen.
set -eu

sudo apt update
sudo apt install -y \
    sway waybar sway-notification-center swaylock swaybg foot fuzzel kanshi \
    power-profiles-daemon xwayland lxqt-policykit \
    network-manager-gnome bluez blueman \
    playerctl brightnessctl grim slurp wl-clipboard pavucontrol \
    gvfs totem loupe libreoffice pipewire \
    xdg-desktop-portal xdg-desktop-portal-wlr gsimplecal libglib2.0-bin

# mako claims the same D-Bus name as swaync; with both installed, which one
# starts is a coin flip.
sudo apt purge -y mako-notifier || true

# Brave: no apt package, use Brave's own repo.
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
    https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
    | sudo tee /etc/apt/sources.list.d/brave-browser-release.list >/dev/null
sudo apt update
sudo apt install -y brave-browser

# JetBrains Mono Nerd Font: no apt package.
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
