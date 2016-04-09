all: install

install: shell \
         brew \
         dotfiles \
         golang \
         vim

# install only the dotfiles.
dotfiles:
	scripts/install

# install hombrew and applications if the user wants.
# The applications that are going to be installed are in the
# brew directory.
brew:
	scripts/install-homebrew

# change shell will change the default shell to zsh.
shell:
	scripts/change-shell

# install vim-plug and vim plugins with vim-plug
vim:
	scripts/install-vim

# Will run osx custom comfiguration based on the mathias bynens osx.sh.
osx:
	osx/setup.sh

# Golang things
golang:
	scripts/install-golang

# This command will only remove the linkend dotfiles.
uninstall:
	scripts/uninstall

.PHONY: all install dotfiles brew shell vim osx golang uninstall
