# albertogg dotfiles

![v5terminal](https://dl.dropboxusercontent.com/s/zybadcuwcm5lyda/v5terminal.png)

## Installation

Dependencies needed for the installation.

- git
- make
- curl

Simply clone the repo.

```sh
git clone https://github.com/albertogg/dotfiles.git ~/.dotfiles
```

Running the install script will do the following:

- Change the default shell of the current `$USER` to ZSH
- Install Homebrew if it isn't installed. It asks to install brews and casks
- Symlink the dotfiles to their proper place
- Create the golang workspace `~/go`
- Install `vim-plug` and all vim plugins

```sh
make install
```

> The symlinks are linked by their extension. If the file only contain a `.symlink`
> extension they are placed in the $HOME dir as a dotfile.

## Setting up Git

Once you've ran the `install` it's time to set up Git with your credentials.

    git config --global user.name "Your Name"
    git config --global user.email "you@email.com"

Then if possible [tell git about your GPG key][gpg-key]. Once this is ready you
are good to go.

## macOS

If you want to install my macOS settings just run the following command:

```sh
make macos
```

It's based on Mathias Bynens `http://mths.be/osx`.

## Hombrew

You can run an individual task to check if Homebrew is installed and also to
install my default Homebrew Apps (git, coreutils, tree, rbenv, tmux, etc...)

To achieve this you can use this command:

```sh
make install-hombrew
```

## License

[MIT License][mit] as usual!

[mit]: https://github.com/albertogg/dotfiles/blob/master/LICENSE
[gpg-key]: https://help.github.com/articles/telling-git-about-your-gpg-key/
