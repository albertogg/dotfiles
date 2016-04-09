# albertogg dotfiles

![v5terminal](https://dl.dropboxusercontent.com/s/zybadcuwcm5lyda/v5terminal.png)

## Installation

Dependencies needed for the installation.

- git
- make

Simply clone the repo.

```sh
$ git clone https://github.com/albertogg/dotfiles.git ~/.dotfiles
```

Running the install script will do the following:

- Change the default shell of the current `$USER` to ZSH
- Install Homebrew if it isn't installed. It asks to install brews and casks
- Symlink the dotfiles to their proper place
- Create the golang workspace `~/go`
- Install `vim-plug` and all vim plugins

```sh
$ make install
```

> The symlinks are linked by their extension. If the file only contain a `.symlink`
> extension they are placed in the $HOME dir as a dotfile.

## OS X

If you want to install my OS X settings just run the following command:

```sh
$ make install-osx
```

It's based on Mathias Bynens `http://mths.be/osx`.

## Hombrew

You can run an individual task to check if Homebrew is installed and also to
install my default Homebrew Apps (git, coreutils, tree, rbenv, tmux, etc...)

To achieve this you can use this command:

```sh
$ make install-hombrew
```

## License

[MIT License][mit] as usual!

[mit]: https://github.com/albertogg/dotfiles/blob/master/LICENSE
