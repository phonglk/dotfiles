#!/usr/bin/env fish
function insert_inline_mode
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
  bind --erase --preset -M insert \ci fish_clipboard_copy
  bind --erase --preset \ci fish_clipboard_copy
  bind --erase --preset -M visual \ci fish_clipboard_copy

  if bind -M insert > /dev/null 2>&1
    bind -M insert \ci --sets-mode insert autocomplete_all
  end
end
