# System formulae
brew install stow
brew install openssl
brew install zsh
brew install tmux
brew install tmate
brew install tree
brew install coreutils
brew install git
brew install fzf
brew install ripgrep
brew install vim
brew install reattach-to-user-namespace

# Development formulae
brew install direnv
brew install rbenv
brew install rbenv-vars
brew install rbenv-default-gems
brew install ruby-build
brew install go
brew install jenv
brew install rustup-init

# Yubikey
brew install ykman
brew install yubikey-personalization
brew install yubikey-agent
brew services start yubikey-agent # Start the service

# Taps
brew tap homebrew/cask-versions

# Applications
brew install appcleaner
brew install dropbox
brew install transmission
brew install gitup --cask
brew install tunnelblick
brew install keybase
brew install logi-options-plus
brew install spotify

# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
chmod -R go-w "$(brew --prefix)/share"
