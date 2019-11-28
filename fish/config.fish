set -x LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8
set -x PYENV_ROOT $HOME/.pyenv

add_to_path /usr/local/bin

ssh-add -K

alias ls="ls -lah"
alias e="nvim"

add_to_path $HOME/.cargo/bin
add_to_path $HOME/go/bin

status --is-interactive; and . (jump shell | psub)

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

function fish_user_key_bindings
end
