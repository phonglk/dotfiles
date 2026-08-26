# Agent Orientation: fish

This package bootstraps Fish shell directories and Fisher plugins.

## What It Owns

- `fish_plugins`, the Fisher plugin list.
- `.dircolors/*` color scheme files.
- `pre-install`, which creates Fish config directories, ensures the macOS
  Homebrew formulas required by the Fish config (`fish`, `fzf`, `coreutils`,
  and `fnm`), and links `fish_plugins` into `~/.config/fish`.
- `post-install`, which installs Fisher if missing, runs `fisher update`,
  repairs the external config's Fish 4-incompatible Ctrl-X erase bindings,
  registers the Fish binary in `/etc/shells` when needed, and makes Fish the
  current user's default login shell. On macOS it also updates the active GUI
  launch environment so newly started apps inherit `SHELL` as Fish.
- `.config/fish/conf.d/00-fish4-bind-compat.fish`, which applies the same narrow
  binding repair before interactive key bindings load, including after a
  standalone `fisher update`.

## Install Notes

- Installed with `./install.sh fish`.
- The post-install hook performs network access via `curl` and updates Fish
  plugins. Do not run it unless the user wants shell bootstrap work.
- Setting the default shell may request administrator access on macOS. The
  change applies to new login sessions; it does not replace the current shell.
- Existing macOS GUI apps must be fully quit and relaunched before they inherit
  the updated `SHELL` value. The launch-environment override lasts only for the
  current macOS login session; future logins use the account shell.

## Change Notes

- The full Fish config appears to come from the external
  `phonglk/phonglk-fish-config` Fisher plugin.
- Keep generated Fisher function files ignored rather than committed.
- Run `bash -n` on edited install hooks.
