# Dotfiles

![v5terminal](https://dl.dropboxusercontent.com/s/zybadcuwcm5lyda/v5terminal.png)

## Dependencies

To use the dotfiles you'll need the following dependencies, you can install any
of these dependencies with [homebrew][brew].

- [Zsh][zsh]
- [Git][git]
- [Stow][stow]

You must make Zsh your default shell:

    chsh -s $(which zsh)

If you want you can install all of my default brews, those will include Stow and
other dependencies.

    ./brew.sh

## Installing

To setup the dotfiles:

    git clone https://github.com/albertogg/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles

After that you can link any of the dotfiles by using Stow, for example, Zsh:

    stow zsh

### Current dotfiles

- Zsh
- Neovim
- Tmux
- Git
- Ruby
- GnuPG
- Direnv

### Setting up Neovim

Installing Neovim is more or less the same that with other dotfiles.

    stow config -t ~/.config/

**Note:** plugin manager and plugins will be installed when nvim is opened.

### Setting up Git

Link the dotfiles:

    stow git

Then setup your Git. Set the user credentials to `~/.gitconfig.local` or set
them globally.

    git config --file ~/.gitconfig.local user.name "Your Name"
    git config --file ~/.gitconfig.local user.email "you@email.com"

## macOS

If you want to install my macOS settings just run the following command:

    ./macos.sh

Those settings are based on Mathias Bynens `http://mths.be/osx`.

## Terminal

In the `terminal` dir you can find my macOS Terminal profile. To install it just
add it from the Terminal.

## License

[MIT License][mit]

[mit]: https://github.com/albertogg/dotfiles/blob/master/LICENSE
[zsh]: http://www.zsh.org
[git]: https://git-scm.com
[stow]: https://www.gnu.org/software/stow/
[brew]: https://brew.sh
