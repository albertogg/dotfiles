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

- Change the default shell of the current `$USER` to ZSH
- Install Homebrew if it isn't and my default apps
- Symlink the dotfiles to their proper place

```sh
$ make install
```

> The symlinks are linked by their extension. If the file only contain a `.symlink`
> extension they are placed in the $HOME dir as a hidden file.

## OS X

If you want to install my OS X settings just run the following command:

```sh
$ make install-osx
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

## MacVim fonts

I use a plugin called `Airline` a successor to Powerline without python.
I also use a custom font for Powerline that has pretty icons and things. To use it
we need to clone the repo into a `~/.fonts` directory and run a command.

```sh
$ git clone git@github.com:Lokaltog/powerline-fonts.git ~/.fonts
$ open ~/.fonts
```

And install the fonts manually on OS X by double clicking the font of your
preference. After that you should successfully have your nice looking Vim and
MacVim.

## License

[MIT License][mit] as usual!

[mit]: https://github.com/albertogg/dotfiles/blob/master/LICENSE
