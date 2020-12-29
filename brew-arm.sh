# System formulae
arch -x86_64 brew install stow
arch -x86_64 brew install openssl
arch -x86_64 brew install gpg
arch -x86_64 brew install zsh
arch -x86_64 brew install tmux
arch -x86_64 brew install tmate
arch -x86_64 brew install tree
arch -x86_64 brew install coreutils
arch -x86_64 brew install git
arch -x86_64 brew install fzf
arch -x86_64 brew install ripgrep
arch -x86_64 brew install vim
arch -x86_64 brew install reattach-to-user-namespace

# Development formulae
arch -x86_64 brew install direnv
arch -x86_64 brew install rbenv
arch -x86_64 brew install rbenv-vars
arch -x86_64 brew install rbenv-default-gems
arch -x86_64 brew install ruby-build
arch -x86_64 brew install go
arch -x86_64 brew install jenv
arch -x86_64 brew install rustup-init

# Yubikey
arch -x86_64 brew install ykman
arch -x86_64 brew install ykclient
arch -x86_64 brew install ykpers
arch -x86_64 brew install yubico-piv-tool
arch -x86_64 brew install pam_yubico

# Taps
brew tap homebrew/cask-versions
brew tap homebrew/cask-drivers # required for logitech-options

# Applications
brew install appcleaner
brew install dropbox
arch -x86_64 brew install homebrew/cask/transmission
arch -x86_64 brew install homebrew/cask/gitup
brew install tunnelblick
brew install nordvpn
brew install keybase
brew install yubico-yubikey-piv-manager
brew install logitech-options
