set -U fish_user_paths $HOME/bin /usr/local/bin /Applications/Xcode.app/Contents/Developer/usr/bin/ $HOME/Projects/go/bin $fish_user_paths
set -gx LANG en_US.UTF-8
set -gx LC_CTYPE en_US.UTF-8
set -gx PYENV_ROOT $HOME/.pyenv

set -gx DRONE_SERVER (keychain-account drone)
set -gx DRONE_TOKEN (keychain-password drone)
ssh-add -K

set -gx GOPATH /Users/perseus/Projects/go
