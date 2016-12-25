install_brews() {
    # taps
    brew tap universal-ctags/universal-ctags

    # system formulae
    brew install openssl
    brew install zsh
    brew install tmux
    brew install tmate
    brew install coreutils
    brew install --HEAD universal-ctags
    brew install git
    brew install vim --with-lua --with-override-system-vi
    brew install reattach-to-user-namespace --with-wrap-pbcopy-and-pbpaste

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
