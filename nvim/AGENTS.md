# Agent Orientation: nvim

This package does not contain the Neovim config itself. It bootstraps a separate
repository.

## What It Owns

- `pre-install`, which runs `git clone https://github.com/phonglk/nvim.git
  ~/.config/nvim`.

## Install Notes

- Installed with `./install.sh nvim`.
- Running the hook performs network access and writes directly to
  `~/.config/nvim`.

## Change Notes

- Do not add Neovim configuration here unless the user explicitly wants to move
  it into this dotfiles repo.
- If Neovim behavior needs changing, inspect the external `phonglk/nvim` checkout
  instead.
