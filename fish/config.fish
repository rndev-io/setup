#if not set -q TMUX
#    set -g TMUX tmux new-session -d -s base
#    eval $TMUX
#    tmux -u attach-session -d -t base
#end

set -x EDITOR nvim
set -x LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8

# === rust
add_to_path $HOME/.cargo/bin
add_to_path $HOME/go/bin
add_to_path $HOME/bin


add_to_path /usr/local/bin
#ssh-add -K &> /dev/null

alias ls="ls -lahUtr"
alias e="nvim"
alias rgf='rg --files | rg'

status --is-interactive && source (jump shell fish | psub)

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

alias urldecode 'python -c "import sys, urllib as ul; print(ul.unquote(sys.argv[1]))"'
alias urlencode 'python -c "import sys, urllib as ul; print(ul.quote(sys.argv[1]))"'


function postexec_noti --on-event fish_postexec
  if set -q CMD_DURATION; and test $CMD_DURATION -gt 3000
    noti -t (status current-command) -m "Duration: "(math $CMD_DURATION / 1000)"sec"
  end
end
fish_add_path /usr/local/opt/openssl@3/bin

