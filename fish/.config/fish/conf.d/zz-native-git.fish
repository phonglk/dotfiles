# Keep upstream Git ahead of Canva's optional Git shim, including when a
# system-managed config prepends the shim after user conf.d files are loaded.
function __dotfiles_prefer_native_git --on-variable PATH
    set -q __dotfiles_native_git_path_updating; and return

    set -e GIT_USER_AGENT
    set -e GIT_HTTP_USER_AGENT

    set -l canva_git_bin "$HOME/.local/share/canva-git/bin"
    contains -- "$canva_git_bin" $PATH; or return

    set -l clean_path_entries
    for path_entry in $PATH
        test "$path_entry" = "$canva_git_bin"; and continue
        set -a clean_path_entries "$path_entry"
    end

    set -g __dotfiles_native_git_path_updating 1
    set -gx PATH $clean_path_entries
    set -e __dotfiles_native_git_path_updating
end

__dotfiles_prefer_native_git
