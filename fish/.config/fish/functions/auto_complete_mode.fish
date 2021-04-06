#!/usr/bin/env fish
# Clone from https://github.com/Baspar/dotfiles/blob/master/fish/.config/fish/functions/auto_complete_mode.fish
function auto_complete_mode
  function _get_headers
    echo -e (echo -e $argv"\n" | head -n 1 | sed 's/ \{2,\}/\\\\n/g')
  end

  function _fzf
    set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
    set FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS --layout=reverse --header-lines=1"
    echo "fzf $FZF_DEFAULT_OPTS $argv"
  end

  function fzf_search
    set DATA $argv[1..-2]
    set INDEX $argv[-1]

    set HEADERS (_get_headers $DATA)
    set NB_HEADERS (count $HEADERS)
    set QUERY ""

    set REPLACEMENT (printf '\e[91m')'&'(printf '\e[0m')

    while true
      set HEADER "$HEADERS[$INDEX]"
      echo -e $DATA"\n" \
        | sed 's/^ //' \
        | sed "1 s/ $HEADER /$REPLACEMENT/; 1 s/^$HEADER /$REPLACEMENT/; 1 s/ $HEADER\$/$REPLACEMENT/;" \
        | eval (_fzf "-q \"$QUERY\" --print-query --expect=left,right --ansi --color=header:3") \
        | sed "s/ \{2,\}/|/g" \
        | cut -d\| -f$INDEX \
        | read -L -l Q COMMAND RES; or return
      if [ ! $COMMAND ]
        echo $RES
        return
      end

      if [ $COMMAND = "left" ]
        set INDEX (math "($INDEX + $NB_HEADERS - 2) % $NB_HEADERS + 1")
      else if [ $COMMAND = "right" ]
        set INDEX (math "$INDEX % $NB_HEADERS + 1")
      end
      set QUERY $Q
    end
  end
  function jira-help
    set OUT (env BUFFER=(commandline) /Users/phonglk/source/shopee/devtool/jira_helper.sh)

    commandline -i -- "$OUT"
    commandline -f repaint
  end

  function autocomplete_all
    echo ""
    echo -e "K8S\nGit Branch\nJira Issue\nPlaceholder2" \
      | eval (_fzf) \
      | read -l MODE; or return

    switch "$MODE"
      case "Git Branch"
        set BRANCH (git branch -a \
          | eval (_fzf --header="Branch" --header-lines=0) \
          | sed "s/*//;s/remotes\/origin\///;s/^ *//")

        commandline -i -- "$BRANCH"
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

  function fzf-branch
    set BRANCH (git branch -a | fzf --height=40% --layout=reverse $FZF_DEFAULT_OPTS | sed "s/*//;s/remotes\/origin\///")

    commandline -i -- "$BRANCH"
    commandline -f repaint
  end
  if bind -M gitsuggest > /dev/null 2>&1
    bind \ce -M gitsuggest --sets-mode insert edit_command_buffer
    bind \cc -M gitsuggest --sets-mode insert force-repaint
    bind \e  -M gitsuggest --sets-mode insert force-repaint
    bind b   -M gitsuggest --sets-mode insert fzf-branch
    # bind j   -M autocomplete --sets-mode insert jira-help
  end

  bind --erase --preset -M insert \cg fish_clipboard_copy
  bind --erase --preset \cg fish_clipboard_copy
  bind --erase --preset -M visual \cg fish_clipboard_copy
  if bind -M insert > /dev/null 2>&1
    bind -M insert \cg --sets-mode gitsuggest force-repaint
  end
end
