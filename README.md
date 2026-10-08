# Dotfiles

![v5terminal](https://dl.dropboxusercontent.com/s/zybadcuwcm5lyda/v5terminal.png)

## Migration to Bash and CachyOS

The migration is in progress. See [the package audit and phase gates](docs/migration.md).
**macOS stays on Zsh; Bash deployment is for CachyOS only.** The existing
macOS startup files and login shell will remain unchanged.

The Homebrew manifests serve as the macOS audit/reference and test dependencies,
not a macOS Bash cutover. For the minimal checking foundation, use:

```sh
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file=packages/Brewfile --no-upgrade
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle install --file=packages/Brewfile --no-upgrade
```

This selects only Bash, Git and Stow. It does not change your login shell,
start services or remove other packages. Do not use Bundle cleanup with this
minimal manifest, or run the legacy `brew.sh` for the migration.

Approved daily tools (including fnm, Go and herdr) are listed separately in
`packages/Brewfile.workflow`; approved work tools are in `packages/Brewfile.work`.
Required YubiKey SSH packages are in `packages/Brewfile.security`.
Use the same Bundle commands with the appropriate `--file` path. Node/pnpm and
Terragrunt versions are separate provisioning decisions; see the audit.

## Staged Bash configuration and checks

The `bash/` Stow package is staged for **CachyOS** and ready for testing. It has
not been deployed, and it will not replace the macOS shell.

```text
bash/
├── .bash_profile
├── .bashrc
├── .inputrc
└── .bash/
    ├── environment.bash
    └── interactive/
        ├── 10-history.bash
        ├── 20-prompt.bash
        ├── 30-completion.bash
        ├── 40-fnm.bash
        ├── 50-direnv.bash
        ├── 60-herdr.bash
        └── 70-fzf.bash
```

`.bashrc` loads the shared environment first, then the numbered interactive
modules once per shell. Modules resolve relative to `.bashrc`, so the same
loader works with Stow and with the undeployed `--rcfile` preview below.

Checking dependencies live in `packages/Brewfile.dev`. Bash completion is
included in the workflow manifest. Install missing entries with `--no-upgrade`
and `HOMEBREW_NO_INSTALL_CLEANUP=1`.

Run all managed-shell checks (also works from outside the repository):

```sh
./scripts/check.sh
```

Checks on macOS require Homebrew Bash 5, not `/bin/bash`; using it to run tests
does not change your login shell. Optional preview in a child shell, for testing
only (not macOS deployment):

```sh
cd ~/.dotfiles
INPUTRC="$PWD/bash/.inputrc" /opt/homebrew/bin/bash --noprofile --rcfile "$PWD/bash/.bashrc" -i
```

Run `exit` to return to your current shell. On CachyOS, validate Node/npm/pnpm,
direnv, completion, herdr, clipboard and YubiKey SSH before cutover. The preview
does not install or upgrade Node versions.

On **CachyOS only**, check conflicts before deployment:

```sh
stow --simulate --no-folding --target="$HOME" bash
```

On CachyOS, explicitly back up any unmanaged conflicting startup files; do not
use `--adopt` or overwrite them automatically. Switch the CachyOS login shell
only after validation. Keep the macOS Zsh package, startup files and account
shell unchanged; do not deploy the Bash package into the macOS home.

## Dependencies (existing Zsh setup)

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
