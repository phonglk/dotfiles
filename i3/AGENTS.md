# Agent Orientation: i3

This package contains the Linux i3 desktop configuration.

## What It Owns

- `.config/i3/config` for i3 keybindings, workspace placement, bar setup, and
  session commands.
- `.config/i3blocks/config` for the i3blocks status bar.
- `.bin/battery.sh` helper used by i3blocks.
- `pre-install`, which creates i3 and i3blocks config directories.

## Install Notes

- Installed with `./install.sh i3`.
- The config references helpers under `~/.bin`; check the `bin` package before
  changing those command names.

## Change Notes

- Keep this package Linux-specific.
- Preserve workspace/output assumptions unless the user asks to update monitor
  layout.
