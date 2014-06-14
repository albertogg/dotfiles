install: install-oh-my-zsh \
         install-files

install-files:
	scripts/install.sh

install-oh-my-zsh:
	curl -L http://install.ohmyz.sh | sh
