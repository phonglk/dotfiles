#!/usr/bin/env fish
# Clone from https://github.com/Baspar/dotfiles/blob/master/fish/.config/fish/functions/auto_complete_mode.fish
function auto_complete_mode
  function jira-help
    set OUT (env BUFFER=(commandline) /Users/phonglk/source/shopee/devtool/jira_helper.sh)

    commandline -i -- "$OUT"
    commandline -f repaint
  end

  function autocomplete_all
    echo ""
    set command "Jira Issue"
    if git branch 1>2 2>/dev/null
      set command "$command\nGit Branch\nWorktree Path"
    end
    echo -e "$command" \
      | fzf \
      | read -l MODE; or return

    switch "$MODE"
      case "Git Branch"
        set BRANCH (git branch -a \
          | fzf \
          | sed "s/*//;s/remotes\/origin\///;s/^ *//")

        commandline -i -- "$BRANCH"
      case "Worktree Path"
        set WORKTREE (git worktree list | fzf | cut -d" " -f 1)

        commandline -i -- "$WORKTREE"
      case "Jira Issue"
        set ISSUE (select_jira_issue)
        commandline -i -- "$ISSUE"
    end

    commandline -f repaint
  end

  # Remove existing <C-x> mapping
  bind --erase --preset -M insert \cx fish_clipboard_copy
  bind --erase --preset \cx fish_clipboard_copy
  bind --erase --preset -M visual \cx fish_clipboard_copy

  if bind -M insert > /dev/null 2>&1
    bind -M insert \cx --sets-mode insert autocomplete_all
  end
  #
  # Git Modes
  #

  # function fzf-branch
  #   set BRANCH (git branch -a | fzf --height=40% --layout=reverse $FZF_DEFAULT_OPTS | sed "s/*//;s/remotes\/origin\///")
  #
  #   commandline -i -- "$BRANCH"
  #   commandline -f repaint
  # end
  # if bind -M gitsuggest > /dev/null 2>&1
  #   bind \ce -M gitsuggest --sets-mode insert edit_command_buffer
  #   bind \cc -M gitsuggest --sets-mode insert force-repaint
  #   bind \e  -M gitsuggest --sets-mode insert force-repaint
  #   bind b   -M gitsuggest --sets-mode insert fzf-branch
  #   # bind j   -M autocomplete --sets-mode insert jira-help
  # end
  #
  # bind --erase --preset -M insert \cg fish_clipboard_copy
  # bind --erase --preset \cg fish_clipboard_copy
  # bind --erase --preset -M visual \cg fish_clipboard_copy
  # if bind -M insert > /dev/null 2>&1
  #   bind -M insert \cg --sets-mode gitsuggest force-repaint
  # end
end
