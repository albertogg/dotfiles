install: change-shell \
         install-homebrew \
         install-dotfiles \
         create-golang-workspace \
         install-vim-plug \
         install-vim-plugins

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

# install vim-plug
install-vim-plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install all vim plugins using vim-plug
install-vim-plugins:
	vim PlugInstall +qall

# This will link hombrew completions for zsh.
link-brew-completion:
	ln -s /usr/local/Library/Contributions/brew_zsh_completion.zsh /usr/local/share/zsh/site-functions/_brew

# Will run osx custom comfiguration based on the mathias bynens osx.sh.
install-osx:
	osx/setup.sh

create-golang-workspace:
	mkdir -p ~/go

# This command will only remove the linkend dotfiles.
uninstall:
	scripts/uninstall
