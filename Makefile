all: install

install: dotfiles \
         shell \
         brew \
         golang \
         ruby \
         vim

# Shell will change the default shell to zsh
shell:
	scripts/shell

# install hombrew and applications if the user wants.
# The applications that are going to be installed are in the
# brew directory.
brew:
	scripts/brew

# install only the dotfiles.
dotfiles:
	scripts/install

# Golang things
golang:
	scripts/golang

# Ruby things
ruby:
	scripts/ruby

# Install vim-plug and vim plugins with vim-plug
vim:
	scripts/vim

# Will run osx custom comfiguration based on the mathias bynens osx.sh
osx:
	osx/setup.sh

# This command will only remove the linkend dotfiles
uninstall:
	scripts/uninstall

.PHONY: all install shell brew dotfiles golang ruby vim osx uninstall
