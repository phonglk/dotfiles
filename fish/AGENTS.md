# Agent Orientation: fish

This package bootstraps Fish shell directories and Fisher plugins.

## What It Owns

- `fish_plugins`, the Fisher plugin list.
- `.dircolors/*` color scheme files.
- `pre-install`, which creates Fish config directories, ensures the macOS
  Homebrew formulas required by the Fish config (`fish`, `fd`, `fzf`,
  `coreutils`, `fnm`, and Python 3 with `curses`), and links `fish_plugins` into
  `~/.config/fish`.
- `post-install`, which installs Fisher if missing, runs `fisher update`,
  repairs the external config's Fish 4-incompatible Ctrl-X erase bindings,
  registers the Fish binary in `/etc/shells` when needed, and makes Fish the
  current user's default login shell. On macOS it also updates the active GUI
  launch environment so newly started apps inherit `SHELL` as Fish.
- `.config/fish/conf.d/00-fish4-bind-compat.fish`, which applies the same narrow
  binding repair before interactive key bindings load, including after a
  standalone `fisher update`.
- `.config/fish/hotkeys.psv`, `.config/fish/hotkey_guide.py`,
  `functions/fish_hotkeys.fish`, and `conf.d/99-hotkey-guide.fish`, which
  provide the shared searchable shortcut catalog, Ctrl-G guide binding,
  clickable and keyboard-switchable tabs, and a random colored startup tip.

## Install Notes

- Installed with `./install.sh fish`.
- The post-install hook performs network access via `curl` and updates Fish
  plugins. Do not run it unless the user wants shell bootstrap work.
- Setting the default shell may request administrator access on macOS. The
  change applies to new login sessions; it does not replace the current shell.
- Existing macOS GUI apps must be fully quit and relaunched before they inherit
  the updated `SHELL` value. The launch-environment override lasts only for the
  current macOS login session; future logins use the account shell.
- Set `DOTFILES_HOTKEY_TIPS_DISABLED` to suppress the once-per-shell shortcut
  tip.

## Change Notes

- The full Fish config appears to come from the external
  `phonglk/phonglk-fish-config` Fisher plugin.
- Keep generated Fisher function files ignored rather than committed.
- Keep `hotkeys.psv` descriptions free of `|`; it is the field separator.
- Keep its final tab field to one of `fish`, `builtin`, `kitty`, or `tmux`.
- The shortcut guide is read-only: selecting a row must never execute it.
- Keep the guide's All, Fish, Built-in, Kitty, and tmux tabs backed by the same
  runtime-evaluated catalog rather than duplicating shortcut data.
- Keep the visible shortcut table limited to Shortcut and Description. Runtime
  binding and dependency status may affect styling, but must not add columns.
- The clickable guide requires Python 3's standard-library `curses` module and
  falls back to the plain two-column renderer if it is unavailable at runtime.
- Run `bash -n` on edited install hooks.
