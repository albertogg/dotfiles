install: install-oh-my-zsh \
         change-shell \
         install-homebrew \
         install-dotfiles

install-dotfiles:
	scripts/install

install-oh-my-zsh:
	curl -L http://install.ohmyz.sh | sh

install-homebrew:
	scripts/install-homebrew

change-shell:
	scripts/change-shell
