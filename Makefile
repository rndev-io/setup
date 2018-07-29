install: brew fish tmux git unar vscode

.PHONY : vscode


brew:  ## The missing package manager for macOS // https://brew.sh/index_ru
	@command -v brew > /dev/null || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

fish: brew  ## Fish is a smart and user-friendly command line shell // https://fishshell.com/
	@command -v fish > /dev/null || brew install fish
	@rm -r $(HOME)/.config/fish
	@ln -s $(CURDIR)/fish $(HOME)/.config/fish

tmux: brew ## Tmux is a terminal multiplexer // https://github.com/tmux/tmux
	@command -v tmux > /dev/null || brew install tmux
	@rm -f $(HOME)/.tmux.conf
	@ln -s $(CURDIR)/tmux/tmux.conf $(HOME)/.tmux.conf

git: brew ## Git is a free and open source distributed version control system  // https://git-scm.com/
	@command -v git > /dev/null || brew install git
	@rm -f $(HOME)/.gitconfig
	@ln -s $(CURDIR)/git/gitconfig $(HOME)/.gitconfig

unar: brew ## The Unarchiver command line tools // https://theunarchiver.com/command-line
	@command -v unar > /dev/null || brew install unar

VSCODE = "$(HOME)/Library/Application Support/Code/User"
vscode: ## Visual Studio Code -- text editor from Microsoft // https://code.visualstudio.com/docs/setup/mac
	@command -v code > /dev/null || echo "---> Install vscode manually, https://code.visualstudio.com/docs/setup/mac"
	@rm -f ${VSCODE}/keybindings.json ${VSCODE}/locale.json ${VSCODE}/settings.json
	@ln -s $(CURDIR)/vscode/keybindings.json ${VSCODE}/keybindings.json
	@ln -s $(CURDIR)/vscode/locale.json ${VSCODE}/locale.json
	@ln -s $(CURDIR)/vscode/settings.json ${VSCODE}/settings.json

hugo: brew ## Hugo is a static site generator // https://gohugo.io/
	@command -v code > /dev/null || brew install hugo
	