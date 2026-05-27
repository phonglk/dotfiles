# Agent Orientation: tmux

This package owns tmux configuration and plugin setup.

## What It Owns

- `.tmux.conf`, the main tmux configuration.
- `.tmux/plugins.tmux`, the TPM plugin list.
- `.tmux/config_extra.tmux`, extra plugin/status configuration.
- `.tmux/tmux.terminfo`.
- `pre-install`, which creates `~/.tmux/plugins`, clones TPM, and installs the
  terminfo file.

## Install Notes

- Installed with `./install.sh tmux`.
- The hook performs network access through `git clone` and writes terminfo via
  `tic`.

## Change Notes

- The prefix is `C-s`, default shell is `/opt/homebrew/bin/fish`, and mouse
  support is enabled.
- The status line uses Nerd Font and plugin-provided segments.
- Run tmux config validation manually only when tmux is available and the user is
  comfortable with local tmux interaction.
