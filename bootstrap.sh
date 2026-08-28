#!/bin/sh
# curl -fsSL https://raw.githubusercontent.com/andrex-sh/dotfiles-work/main/bootstrap.sh | sh
set -eu

sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
"$HOME/.local/bin/chezmoi" init --apply \
    --source "$HOME/Projects/dotfiles-work" \
    https://github.com/andrex-sh/dotfiles-work.git
