install: brew fish tmux git vscode editorconfig alacritty karabiner


brew:
	@command -v brew > /dev/null || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

fish: brew
	@rm -r $(HOME)/.config/fish
	@ln -s $(CURDIR)/fish $(HOME)/.config/fish

tmux: brew
	@rm -f $(HOME)/.tmux.conf $(HOME)/.tmux.conf.local
	@ln -s -f $(CURDIR)/tmux/tmux.conf $(HOME)/.tmux.conf
	@ln -s -f $(CURDIR)/tmux/tmux.conf.local $(HOME)/.tmux.conf.local

git: brew
	@rm -f $(HOME)/.gitconfig
	@ln -s $(CURDIR)/git/gitconfig $(HOME)/.gitconfig

VSCODE = "$(HOME)/Library/Application Support/Code/User"
vscode: brew
	@rm -f ${VSCODE}/keybindings.json ${VSCODE}/locale.json ${VSCODE}/settings.json ${VSCODE}/snippets/rusnasonov.code-snippets
	@ln -s $(CURDIR)/vscode/keybindings.json ${VSCODE}/keybindings.json
	@ln -s $(CURDIR)/vscode/locale.json ${VSCODE}/locale.json
	@ln -s $(CURDIR)/vscode/settings.json ${VSCODE}/settings.json
	@ln -s $(CURDIR)/vscode/rusnasonov.code-snippets ${VSCODE}/snippets/rusnasonov.code-snippets

karabiner: brew
	@rm -f $(HOME)/.config/karabiner/karabiner.json
	@ln -sf $(CURDIR)/karabiner/karabiner.json $(HOME)/.config/karabiner/karabiner.json

rust:
	@rm -f $(HOME)/.cargo/.crates.toml
	@ln -s $(CURDIR)/rust/crates.toml $(HOME)/.cargo/.crates.toml

editorconfig:
	@rm -f $(HOME)/.editorconfig
	@ln -s $(CURDIR)/.editorconfig $(HOME)/.editorconfig


alacritty: brew
	@rm -f $(HOME)/.config/alacritty/alacritty.yml
	@ln -s $(CURDIR)/alacritty/alacritty.yml $(HOME)/.config/alacritty/alacritty.yml
