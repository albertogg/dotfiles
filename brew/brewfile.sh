install_brews() {
    # system formulae
    brew install openssl
    brew install zsh
    brew install tmux
    brew install tmate
    brew install tree
    brew install coreutils
    brew install git
    brew install ripgrep
    brew install vim
    brew install reattach-to-user-namespace

    # development formulae
    brew install rbenv
    brew install rbenv-vars
    brew install rbenv-default-gems
    brew install ruby-build
    brew install go
    brew install jenv

    # yubikey
    brew install ykclient
    brew install ykpers
    brew install yubico-piv-tool
    brew install pam_yubico

    # clean up
    brew cleanup
}
