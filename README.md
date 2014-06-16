# albertogg dotfiles.

## Installation instructions

Dependencies needed for the installation.

- git
- tmux (not a dep, but awesome)
- reattach-to-user-namespace (use pbcopy in tmux)
- coreutils (not a dep, but very useful)

Simply clone the repo.

```sh
$ git clone https://github.com/albertogg/dotfiles.git ~/.dotfiles
```

Running the install script will do the following:

- Install oh-my-zsh to your `$HOME` directory
- Change the default shell of the current `$USER` to ZSH
- Install Homebrew if it isn't and my default apps
- Symlink the dotfiles to their proper place

```sh
$ make install
```

> The symlinks are linked by their extension. If the file only contain a `.symlink`
> extension they are placed in the $USER $HOME dir as a hidden file. If they
> have something to do with oh-my-zsh they are placed in the `/custom` folder
> inside the `.oh-my-zsh` dir.

## OS X

If you want to install my OS X settings just run the script inside the system
folder.

> This make script is missing

```sh
$ sh osx.sh
```

## Hombrew

You can run an individual task to check if Homebrew is installed and also to
install my default Homebrew Apps (git, coreutils, tree, rbenv, tmux, etc...)

To achieve this you can use this command:

```sh
$ make install-hombrew
```

## iTerm.

I use my custom iTerm2 configuration. To use my configuration open iTerm2
*Preferences > General tab, click the [x] load preferences from custom folder* and
put the direction to the folders configuration.

## License

[MIT License][mit] as usual!

[mit]: https://github.com/albertogg/dotfiles/blob/master/LICENSE
