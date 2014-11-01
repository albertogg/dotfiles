install: change-shell \
         install-homebrew \
         install-dotfiles

# install only the dotfiles.
install-dotfiles:
	scripts/install

# install hombrew and applications if the user wants.
# The applications that are going to be installed are in the
# brew directory.
install-homebrew:
	scripts/install-homebrew

# change shell will change the default shell to zsh.
change-shell:
	scripts/change-shell

# install vim vundle
install-vundle:
	git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# This will link hombrew completions for zsh.
link-brew-completion:
	ln -s /usr/local/Library/Contributions/brew_zsh_completion.zsh /usr/local/share/zsh/site-functions/_brew

# Will run osx custom comfiguration based on the mathias bynens osx.sh.
install-osx:
	system/osx

# This command will only remove the linkend dotfiles.
uninstall:
	scripts/uninstall
