# Agent Orientation: bash

This package owns Bash login/profile files and the main collection of personal
CLI helpers under `bash/bin`.

## What It Owns

- `.bash_profile`, `.profile`, and `.bashrc` for PATH setup, RVM/NVM/FNM/Cargo,
  editor defaults, aliases, and local tool paths.
- `bash/bin/*` helpers for Jira, GCloud, Kubernetes, worktrees, branch cleanup,
  weather, VPN, JetBrains Gateway, Ollama-assisted branch names, and SketchyBar
  PR tracking.
- Utility guards such as `_check_secret`, `_check_ollama`, and
  `_dotfiles_utils_check_brew`.

## Important Helpers

- `bk-track` manages GitHub PRs tracked by the SketchyBar CI widget. It writes to
  `~/.config/sketchybar/buildkite-prs.conf`, uses `gh`, and may trigger
  SketchyBar refreshes.
- `branch_cleanup` and `branch_cleanup.mjs` are interactive branch/worktree
  cleanup tools. Treat them as destructive unless the user explicitly asks to run
  them.
- GCloud/Kubernetes helpers call `gcloud`, `kubectl`, `fzf`, and sometimes edit
  local machine state.
- `_dotfiles_migrate_file` copies a home file into this repo, removes the
  original, symlinks it back, and restows the package. Do not run it casually.

## Change Notes

- Shell files may contain machine-specific paths. Preserve them unless asked to
  clean them up.
- Keep secrets out of committed files. Prefer environment variables or ignored
  local files for API keys.
- Run `bash -n` on touched Bash scripts.
