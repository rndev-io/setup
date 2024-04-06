set -x EDITOR nvim
set -x LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8
set -x DYLD_LIBRARY_PATH (brew --prefix)/lib
set -x LIBRARY_PATH (brew --prefix)/lib
#####################
# Add pyenv executable to PATH by running
# the following interactively:

set -Ux PYENV_ROOT $HOME/.pyenv
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths

# Load pyenv automatically by appending
# the following to ~/.config/fish/config.fish:

pyenv init - | source


# Restart your shell for the changes to take effect.
#################

add_to_path $HOME/.cargo/bin
add_to_path $HOME/go/bin
add_to_path $HOME/bin
add_to_path $HOME/.local/bin
add_to_path $HOME/yandex-cloud/bin


alias ycs3='aws s3 --endpoint-url=https://storage.yandexcloud.net'
alias ls="ls -lahUtr"
alias e="nvim"
alias rgf='rg --files | rg'
alias readlink='greadlink'

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

if status is-interactive
    set -gx ATUIN_NOBIND "true"
    atuin init fish | source
    bind \cr _atuin_search
    bind -M insert \cr _atuin_search
end


alias urldecode 'python -c "import sys, urllib as ul; print(ul.unquote(sys.argv[1]))"'
alias urlencode 'python -c "import sys, urllib as ul; print(ul.quote(sys.argv[1]))"'


function postexec_noti --on-event fish_postexec
  if set -q CMD_DURATION; and test $CMD_DURATION -gt 3000
    noti -t (status current-command) -m "$argv: "(math $CMD_DURATION / 1000)"sec"
  end
end
