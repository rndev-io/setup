set -x LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8
set -x PYENV_ROOT $HOME/.pyenv

add_to_path /usr/local/bin

ssh-add -K

alias ls="ls -lah"
alias e="nvim"
