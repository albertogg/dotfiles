install: change-shell \
         install-homebrew \
         install-dotfiles

install-dotfiles:
	scripts/install

install-homebrew:
	scripts/install-homebrew

change-shell:
	scripts/change-shell

link-brew-completion:
	ln -s /usr/local/Library/Contributions/brew_zsh_completion.zsh /usr/local/share/zsh/site-functions/_brew

install-osx:
	system/osx

uninstall:
	scripts/uninstall
