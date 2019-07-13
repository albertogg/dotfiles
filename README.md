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
- Vim
- Tmux
- Git
- Ruby
- Direnv

### Setting up Vim

My installation of Vim includes my `.vimrc` and all of the Vim plugins. Install
the Vim dotfiles:

    stow vim

Install [vim-plug][vim-plug] and all of the dependencies:

    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +PlugInstall +qall

### Setting up Git

Link the dotfiles:

    stow git

Then setup your Git. Copy your current user credentials to `~/.gitconfig.local`
or set them globally.

    git config --global user.name "Your Name"
    git config --global user.email "you@email.com"

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
[vim-plug]: https://github.com/junegunn/vim-plug
[zsh]: http://www.zsh.org
[git]: https://git-scm.com
[stow]: https://www.gnu.org/software/stow/
[brew]: https://brew.sh
