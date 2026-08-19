# dotfiles-work

[sway](https://swaywm.org/) desktop setup for Ubuntu 24.04, managed with [chezmoi](https://www.chezmoi.io/). This repo *is* the chezmoi source directory. Sibling of [dotfiles](https://github.com/andrex-sh/dotfiles), which targets Arch/CachyOS instead - this one is apt-based and has no discrete GPU.

## Tracked

sway, waybar, mako, swaylock, foot, fuzzel, the sway power-menu/screenshot/hwstatus scripts, kanshi's workspace-assignment helper + service, and nvim.

Display manager is GDM (Ubuntu's default, already installed) - sway is just selected as the session at the login screen. No ly here.

Notifications are handled by mako - popup-only, no history/control-center panel; `$mod+n` (`makoctl restore`) re-shows the last dismissed notification, the closest equivalent.

File manager, video/audio, and images are Nautilus, Totem, and Loupe - reused GNOME apps rather than Thunar/mpv/qimgv, since none of those (or their AUR equivalents) are simple apt installs, and these GTK apps run fine standalone under sway without gnome-shell running.

Brave has no apt package - installed from Brave's own apt repo (`brave-browser`), not the AUR `brave-bin` name.

The hardware status script reports CPU and memory only - this machine has no discrete GPU, so no GPU usage/temp code exists here (unlike the CachyOS repo's version).

Wifi/VPN and bluetooth are handled by tray applets - `nm-applet` and `blueman-applet` (both `exec`'d in `sway/config`, shown via waybar's `tray` module) - same as the CachyOS setup. `nm-connection-editor` (ships inside the `network-manager-gnome` package) is there too, for importing a VPN profile: `nmcli connection import type openvpn file foo.ovpn` or `nm-connection-editor`. No VPN profile is pre-configured.

## Not tracked

- `~/.config/kanshi/config` - monitor layout is per-machine, write it by hand (see `man kanshi` and `dot_config/kanshi/executable_docked-workspaces.sh`).
- fish config - machine-local.
- `~/.gitconfig` and `~/.ssh/config` - kept out of the repo entirely (identity/host details), set up by hand per machine.

## Bootstrap on a new machine

```sh
curl -fsSL https://raw.githubusercontent.com/andrex-sh/dotfiles-work/main/bootstrap.sh | sh
```

`bootstrap.sh` clones this repo to `~/Projects/dotfiles-work`, installs chezmoi, and runs `chezmoi init --apply` - equivalent to running these by hand:

```sh
git clone https://github.com/andrex-sh/dotfiles-work.git ~/Projects/dotfiles-work
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
~/.local/bin/chezmoi init --source ~/Projects/dotfiles-work --apply
```

First `apply` runs `run_once_install.sh`: installs packages via apt, adds Brave's apt repo, installs the JetBrains Mono Nerd Font manually (not apt-packaged), enables `bluetooth.service`/`kanshi.service`. Answer the sudo prompt, then log out and pick "Sway" from GDM's session menu.

Then hand-write `~/.config/kanshi/config` for that machine.

## Daily workflow

```sh
chezmoi diff      # preview
chezmoi apply     # write
git add -A && git commit -m "..." && git push
```
