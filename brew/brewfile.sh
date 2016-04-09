install_brews() {
    # system formulae
    brew install zsh
    brew install tmux
    brew install tmate
    brew install coreutils
    brew install ctags
    brew install git
    brew install reattach-to-user-namespace
    brew install vim --override-system-vi

    # homebrew cask formulae
    brew install caskroom/cask/brew-cask

    # development formulae
    brew install rbenv
    brew install rbenv-vars
    brew install rbenv-gem-rehash
    brew install rbenv-default-gems
    brew install ruby-build
    brew install go

    # clean up
    brew cleanup
}
