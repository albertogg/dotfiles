install_brews() {
    # system formulae
    brew install openssl
    brew install zsh
    brew install tmux
    brew install tmate
    brew install coreutils
    brew install ctags
    brew install git
    brew install vim --override-system-vi

    # development formulae
    brew install rbenv
    brew install rbenv-vars
    brew install rbenv-default-gems
    brew install ruby-build
    brew install go
    brew install jenv

    # clean up
    brew cleanup
}
