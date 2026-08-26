# Agent Orientation

This is a personal GNU Stow dotfiles repo for Arch and macOS. Each top-level
directory is a Stow package that can be linked into `$HOME`.

## Install Model

- Install one package with `./install.sh <package>`.
- `install.sh` validates the package and Stow dependency, runs
  a Stow simulation before making changes, runs `<package>/pre-install` if
  present, then runs Stow with install hooks, `.DS_Store`, and package-local
  `AGENTS.md` files ignored, then runs `<package>/post-install` if present. It
  stops on the first failure.
- Do not run install hooks casually. Several hooks write to `$HOME`, install
  Homebrew packages, clone repositories, run `curl`, update plugin managers, or
  start services.
- Prefer reading package-local `AGENTS.md` files before reading full configs.

## Package Map

- `arch`: Arch/Linux autostart and keyboard configuration.
- `bash`: Bash profiles and personal command-line helpers in `bash/bin`.
- `bin`: Stowed `~/.bin` utilities and backup helpers.
- `fish`: Fish shell bootstrap and Fisher plugin list.
- `i3`: Linux i3, i3blocks, and helper scripts.
- `kitty`: Kitty terminal configuration.
- `nvim`: Bootstrap hook that clones the separate Neovim config.
- `rofi`: Rofi launcher themes and config.
- `sketchybar`: macOS SketchyBar layout, plugins, and PR/CI status widget.
- `skhd`: macOS hotkey bindings for yabai and shell helpers.
- `tmux`: tmux config, TPM plugins, terminfo, and extra status settings.
- `tmuxinator`: tmuxinator session definitions.
- `utils`: Miscellaneous bootstrap scripts.
- `yabai`: macOS yabai tiling-window-manager and limelight config.

## Working Rules

- Preserve existing user changes. This repo often contains local, uncommitted
  machine-specific edits.
- Do not commit secrets, tokens, local `.env` files, or machine-specific PR
  tracking lists unless explicitly requested.
- Use `rg`/`rg --files` for search and inspect the relevant component doc first.
- For shell changes, run syntax checks such as `bash -n` or `sh -n` on touched
  scripts where applicable.
- For Stow behavior changes, reason about both the repo path and the target path
  under `$HOME`; many files are installed as symlinks.
