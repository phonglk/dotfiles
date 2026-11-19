# dotfiles
dotfiles for my Arch/MacOS env

![image](https://user-images.githubusercontent.com/2889732/113503363-f59dea00-9563-11eb-9c6e-82c7457808d6.png)

# Prerequisite

- stow
- fish
- nodejs

# Tools

- fzf, ripgrep, the_silver_searcher

# Arch Config

# Fix keychron fn
`echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode`

# Install specific package

`./install.sh <package_name>`

## Fish AI commands

Press `Ctrl+O` in Fish to open the command assistant with folder context and
keyboard hints. At `[AI] PROMPT >`, type a request such as
`search for TODO in TypeScript files here`, and press Enter. Codex returns
three commands in an fzf picker with an exact command preview and explanation.
Typing in the picker filters the current suggestions.

The Panelled layout separates the command list and exact preview, with keyboard
help kept in the footer. Cyan marks the active choice, amber marks follow-up
input, and green confirms a command is ready to edit. Command previews highlight
the executable, flags, and quoted text. Narrow terminals stack the preview
below the choices. The layout uses your terminal background and remains usable
with `NO_COLOR=1` or `TERM=dumb`. `Ctrl+/` toggles the preview; very short
terminals initially hide it to leave room for the choices and key hints.

While Codex works, a spinner shows elapsed time and the Ctrl+C cancellation
hint. Generation is cyan and refinement is amber. The loading line clears
before the picker or an error appears. Dumb terminals and redirected output
receive one plain status line; `NO_COLOR=1` keeps the spinner monochrome.

- Enter inserts the selected command into the normal Fish prompt for editing.
  Press Enter there when you want to run it.
- Each option's preview shows a follow-up action and three suggested changes
  specific to that command. Ctrl+O opens `[AI · REFINE] REFINE >` with the
  original request, selected command, explanation, and suggested follow-ups
  visible above it. Type your own change, or enter `1`, `2`, or `3` to use a
  suggestion, then press Enter for revised choices. Repeat as needed.
- Esc backs out one step. Ctrl+O from the initial AI prompt, or Ctrl+C,
  exits and restores the original shell draft and cursor.

This uses your saved Codex CLI login. On macOS it also finds the CLI bundled
with ChatGPT if `codex` is absent from your terminal's PATH. Python 3 and fzf
come from the Fish setup. Generation runs with shell tools disabled in a
read-only, temporary Codex session. Suggested commands are checked for Fish
syntax; they are never executed by the assistant.

Run `./install.sh fish` to link the files. New Fish terminals load the
binding automatically. For an already-open Fish terminal after installation:

```fish
source ~/.config/fish/functions/fish_ai.fish
fish_ai --install-bindings
```

`FISH_AI_CODEX_TIMEOUT` sets the generation timeout in seconds, with a default
of 120. Temporary request and selection state is removed when AI mode exits.
