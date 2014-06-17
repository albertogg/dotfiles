install: change-shell \
         install-homebrew \
         install-dotfiles

install-dotfiles:
	scripts/install

install-homebrew:
	scripts/install-homebrew

change-shell:
	scripts/change-shell

install-osx:
	system/osx

uninstall:
	scripts/uninstall
