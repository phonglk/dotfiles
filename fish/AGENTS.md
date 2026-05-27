# Agent Orientation: fish

This package bootstraps Fish shell directories and Fisher plugins.

## What It Owns

- `fish_plugins`, the Fisher plugin list.
- `.dircolors/*` color scheme files.
- `pre-install`, which creates Fish config directories, installs `fzf` on macOS
  if missing, and links `fish_plugins` into `~/.config/fish`.
- `post-install`, which installs Fisher if missing and runs `fisher update`.

## Install Notes

- Installed with `./install.sh fish`.
- The post-install hook performs network access via `curl` and updates Fish
  plugins. Do not run it unless the user wants shell bootstrap work.

## Change Notes

- The full Fish config appears to come from the external
  `phonglk/phonglk-fish-config` Fisher plugin.
- Keep generated Fisher function files ignored rather than committed.
- Run `bash -n` on edited install hooks.
