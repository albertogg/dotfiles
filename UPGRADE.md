# Upgrade

This file will get you on how to upgrade between breaking changes.

## v5.1.0 -> v5.2+

This version bump I'm leaving behind gnupg with the GPG Agent to move into the
Yubikey Agent.

- Prior upgrading execute `stow --delete gnupg` to remove gnupg configuration
- Install via the `brew.sh` script the dependencies or install the following
  dependencies manually
    - `brew install yubikey-personalization`
    - `brew install yubikey-agent`
    - `brew services start yubikey-agent`
- Run `stow zsh` to add the configuration for the Yubikey agent
- Run the `yubikey-agent -setup` to configure the new SSH keys

## v4.99.0 -> v5.0.0

- Prior upgrading execute the uninstall script
- Install Stow
- Link all of the dotfiles using Stow (Look in the README for more information)
