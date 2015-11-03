#! /usr/bin/env sh

install_brews() {

    # taps
    brew tap nviennot/tmate

    # system formulae
    brew install zsh
    brew install ack
    brew install coreutils
    brew install git
    brew install hg
    brew install tree
    brew install wget
    brew install ssh-copy-id
    brew install ctags
    brew install reattach-to-user-namespace
    brew install vim

    # homebrew cask formulae
    brew install caskroom/cask/brew-cask

    # development formulae
    brew install rbenv
    brew install rbenv-vars
    brew install rbenv-gem-rehash
    brew install rbenv-default-gems
    brew install ruby-build
    brew install tmux
    brew install tmate
    brew install go

    # clean up
    brew cleanup
}
