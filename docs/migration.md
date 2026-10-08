# macOS → CachyOS migration

Target: CachyOS + niri + Noctalia, with modern Bash on both platforms.
Keep GNU Stow. Use native package managers, not a new dotfile framework.

## Progress

- [x] Inspect current macOS package inventory and shell baseline.
- [x] Define the minimum macOS migration foundation.
- [x] Approve daily workflow, runtime choices and SSH security requirements.
- [x] Apply the foundation manifest twice without upgrades (all packages already installed).
- [x] Install approved workflow packages and shell-checking dependencies; repeat without upgrades.
- [ ] Provision the selected newer Node 24.x patch and its approved npm-global tools.
- [x] Implement and test staged Bash before changing the login shell.
- [ ] Validate herdr configuration, clipboard and YubiKey integration.
- [ ] Switch macOS login shell to Bash; remove obsolete tracked Zsh setup.
- [ ] Verify CachyOS package names and deploy on the target machine.
- [ ] Validate niri/Noctalia session integration.
- [ ] Complete regression suite and CI.

## Baseline: observed on the current macOS machine

- Bash: `/opt/homebrew/bin/bash`, GNU Bash 5.3.15.
- Account login shell: `/bin/zsh` (queried with `dscl`, not inferred from `$SHELL`).
- Git and Stow: installed under `/opt/homebrew/bin`.
- `/opt/homebrew/bin/bash` is not currently listed in `/etc/shells`.
- `~/.bashrc` is an ordinary file containing a prepend of `~/.local/bin`.
- `~/.profile` is an ordinary file sourcing `~/.cargo/env` unconditionally.
- `~/.bash_profile` was not found.
- `~/.zshrc` links to `.dotfiles/zsh/.zshrc`.
- No configuration was found at `~/.config/ghostty/config`. Other application
  locations have not yet been inspected; this is not evidence of no overrides.
- Homebrew reports `yubikey-agent` started through a user LaunchAgent.
- ShellCheck, shfmt and Bats were not found on PATH.
- `gopls` and `glow` exist outside Homebrew's prefix.
- `rustup` is available, but `cargo` was not found on the current PATH.
- `node` and `pnpm` resolve through an fnm multishell directory.
- `/usr/bin/java` exists; a usable JDK has not been verified.
- No tracked Bash, niri, Noctalia or Ghostty configuration or executable test
  suite was found in this repository.

Pre-existing edits to preserve: `AGENTS.md`,
`config/.config/herdr/config.toml`, and `zsh/.zshrc`.

Do not copy private Git configuration, credentials, keys or shell history into
this repository. An installed executable is not proof of active use.

## Package decisions

### Selected foundation

`packages/Brewfile` contains only `bash`, `git`, and `stow`.
All three are already installed. This is the provisioning foundation, not a
complete replacement for the workstation's existing packages.

Validation: Bundle check succeeded twice. Bundle install with `--no-upgrade`
succeeded twice, reporting `Using bash`, `Using git`, and `Using stow`; no
packages needed installation. `git diff --check` passed. Homebrew emitted an
unrelated installed-dependency metadata warning about a libtiff/webp cycle.
Do not follow its destructive uninstall suggestion as part of this migration;
no repair was attempted.

Check from the repository root:

```sh
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file=packages/Brewfile --no-upgrade
```

Install missing foundation packages, without upgrading installed packages:

```sh
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle install --file=packages/Brewfile --no-upgrade
```

Repeat that install command to verify convergence. Never run Bundle cleanup
against this intentionally small manifest. It must not remove other packages.
Do not run the legacy `brew.sh` as part of this migration: it installs optional
applications, starts an agent service and recursively changes permissions.

### Approved daily workflow

`packages/Brewfile.workflow` contains fnm, Go, herdr, Neovim, fzf, ripgrep,
fd, gh, direnv, git-lfs, jq, tree, rtk, opencode, Python 3.14 and Ghostty. Apply separately
from the foundation, with `--no-upgrade`.
Bundle checks passed for workflow, work and security manifests; all listed
packages are already installed. No additional package installation was needed.
A temporary Python 3.14 venv was created successfully and its pip executed;
the temporary environment was removed. `git diff --check` passed.

| Package | Reason / installation owner |
| --- | --- |
| neovim | Configured editor; Homebrew / Linux package manager. |
| herdr | Replaces tmux; preserve and migrate existing configuration. |
| ripgrep | Explicit use in Neovim and fzf configuration. |
| fzf | Approved; Bash keybindings still need a decision. |
| ghostty | Approved terminal; macOS cask / verified Linux package. |
| gh | Approved GitHub workflow. |
| fd | Approved file-finding utility. |

Direnv is required. git-lfs, jq and tree are approved and included. Keep the
shared Git LFS filters. uv and lazygit are excluded by user choice.

### Runtime selections

User confirmed Node, Go and Python are active workflows. Rust, Ruby and Java are no
longer used and are excluded from the migration. Do not carry their shell
hooks, aliases, runtime installers or dedicated editor integrations into the
new setup. Do not uninstall existing packages automatically; an application
may still require a runtime as a dependency.

fnm is confirmed as the Node version manager. npm is the primary package
manager, with pnpm also used. The current Node is v24.11.1, npm is 11.6.2,
and pnpm is 10.33.4. `npm ls -g pnpm --depth=0` confirms pnpm is already
installed in that fnm Node version's global npm prefix.

Recommended pnpm ownership: the selected fnm Node version's npm global prefix.
No `sudo`, separate Homebrew pnpm/Node, Corepack ownership or standalone
`PNPM_HOME` is needed for this approach. For each approved Node version,
provision an explicit pnpm version only if the installed version differs.
Never install it on shell startup or every directory change. Project
`packageManager` requirements must be checked; npm-global pnpm alone does not
automatically implement per-project version switching.

Node policy: use the latest available 24.x release through fnm when explicitly
provisioning/updating the baseline; do not track another major or download
updates at shell startup. Resolve and record the exact patch for reproducible
installation. Later upgrades are explicit operations, not changes silently
introduced by reapplying configuration. Project-specific Node version files
still take precedence when entering those projects.

pnpm version selection remains separate; do not implicitly upgrade it because
Node's patch changes. Go is selected; verify gopls ownership before changing
its installation.

Python uses standard pip/venv, not uv, Poetry or a new version manager. Preserve
the currently installed Python 3.14 minor on macOS (`python@3.14`, currently
3.14.6); this is a baseline choice, not a claim that every project supports it.
On CachyOS, use the system Python for compatible projects and install another
interpreter only when a project actually requires it. Never modify the system
interpreter to satisfy project dependencies or carry every currently installed
Python version into the new baseline.

Use `python3 -m venv .venv` and the environment's `python -m pip` for project
packages; never `sudo pip`, `--break-system-packages`, or global package
installation. A provisioning script should create a venv only when absent and
validate its interpreter when present, rather than silently replacing it.

### Remaining tooling decisions

| Group | Packages / decisions |
| --- | --- |
| JavaScript | Selected: fnm, latest Node 24.x at explicit provisioning, npm and pnpm. pnpm is npm-global under fnm; pin its approved version. |
| Go | Selected. go; preserve existing gopls installation until its owner is verified. |
| Python | Selected: pip/venv. macOS preserves Python 3.14; Linux uses its system interpreter where compatible. No uv/Poetry/pyenv provisioning. |
| Rust | Excluded: rustup/rustup-init, Cargo shell setup and dedicated Rust editor integration. |
| Ruby | Excluded: rbenv, ruby-build, rbenv-vars/default-gems, Ruby shell aliases and dotfiles. |
| Java | Excluded: jenv and development JDK provisioning. |
| Infrastructure | Approved: tenv, awscli, helm, kubectx, kubectl, Docker and Terragrunt. tenv owns Terragrunt; the user will install needed versions manually. Do not provision tool versions automatically, install tfenv, or install a competing Terragrunt binary. |
| Agent tools | Approved: herdr, rtk, opencode, Pi and ChatGPT desktop. rtk/opencode use existing Homebrew ownership. Preserve Pi's current fnm/npm installation; inspect its provisioning/version before moving Node. Codex CLI and Claude Code are not selected. Do not assume ChatGPT desktop has a Linux package; verify official availability, otherwise use the web application. |
| Utility tools | Approved: direnv (required), git-lfs, jq and tree. Exclude uv and lazygit. |
| YubiKey | Required for SSH key authorization, not commit signing. Preserve agent and touch requirements. `packages/Brewfile.security` retains ykman/yubikey-agent without configuring services or keys. Verify Linux service/socket on the target. |

### SSH security audit

The user requires YubiKey authorization for SSH, not commit signing. Observed:

- `SSH_AUTH_SOCK` is `/opt/homebrew/var/run/yubikey-agent.sock` and exists as a
  Unix socket.
- The user LaunchAgent invokes yubikey-agent with `-l` and that exact socket.
- No effective `commit.gpgsign`, `tag.gpgsign` or `gpg.format` setting was found
  in this repository context. Do not add or alter signing settings.
- Installed support packages: ykman 5.9.2 and yubikey-agent 0.1.6.

This establishes current agent wiring, not a successful SSH authentication or
hardware/backend test. No private keys were read, agent identities enumerated,
remote authentication attempted or touch/security settings changed. Bash must
preserve the local-agent workflow while leaving forwarded SSH sockets alone.
Linux service/socket details remain unverified; do not guess them.

### Herdr configuration audit

The existing `config/.config/herdr/config.toml` has no macOS paths or shell
commands: Tokyo Night theme, Ctrl+S prefix, split bindings, tab naming, agent
labels/panel ordering and terminal toast delivery. Preserve these settings,
including the user's uncommitted edits. The current executable supports
`herdr config check` and Bash completion generation. Verify the same options
against the selected Linux release, then exercise panes/tabs and clipboard
inside Ghostty running Bash. Do not change configuration merely for the
platform move when the existing values validate.

Remove tmux package selection, aliases, configuration and notification branches
when implementing the replacement. Existing agent notifications still contain
a TMUX-specific path; decide herdr vs desktop delivery before replacing it.
Do not stop live sessions or modify the user's configuration during the audit.

Audit checks passed: `herdr config check` reports `config: ok`; generated Bash
completion passes `bash -n`. This does not yet validate the Linux application
or interactive clipboard behavior.

### Editor support — depends on approved language workflows

- tree-sitter-cli, compiler and make for selected parser/plugin builds.
- glow for the configured Markdown preview (currently under `~/.local/bin`).
- Language-server runtimes; choose one owner per server (Mason, runtime manager
  or OS package manager). Neovim enables gopls but does not ensure it via Mason.
- macOS clipboard built-ins; wl-clipboard on the Wayland target.
- Plugin downloads and build operations are separate from shell startup.

### Omit from the new default; do not uninstall automatically

Zsh, tmux, reattach-to-user-namespace, Zsh completion
setup, recursive Homebrew permission changes, old cask tap setup, and the
blanket GUI application list. Linux needs no GNU-coreutils compatibility paths.

Applications such as Dropbox, VPN clients, Logitech tooling and Keybase require
separate decisions. Do not infer Linux replacements from macOS package names.

### Installed explicit formula requests: inventory, not an approved manifest

Homebrew's `installed_on_request` metadata reported:

```text
agent-browser awscli beads cairo cloudflared coreutils cryptography direnv fd
fnm fzf gh giflib git git-lfs glib go graphviz grpcurl harfbuzz helm herdr hugo
jenv jpeg jq kubectx kubernetes-cli lazygit libpng librsvg mkcert mole neovim
nmap openssl@3 pango pkgconf prowler python@3.10 python@3.12 rbenv
rbenv-default-gems rbenv-vars reattach-to-user-namespace ripgrep rtk ruby-build
rustup stow stripe-cli telnet tenv tmux tree tree-sitter-cli uv wimlib ykman
yubikey-agent zsh
```

This metadata may include historical requests. Bash is installed even though
it is not marked as an explicit request. The full dependency inventory is not
an installation list.

Installed casks reported:

```text
android-platform-tools appcleaner balenaetcher brave-browser calibre codex-app
discord docker-desktop drawio dropbox gcloud-cli ghostty gimp keybase
kitlangton-hex libreoffice logi-options+ obs obsidian raspberry-pi-imager
transmission
```

## Staged Bash implementation and validation

Added `bash/.bash_profile`, `bash/.bashrc`, and `bash/.inputrc`, plus
`scripts/check.sh` and `tests/bash.bats`. The approved multi-file layout uses
`bash/.bash/environment.bash` and numbered `bash/.bash/interactive/*.bash`
modules for history, prompt, completion, fnm, direnv, herdr and fzf. `.bashrc`
loads the environment before its interactive/re-sourcing guards. Module paths
resolve beside `.bashrc`, allowing both Stow and undeployed rcfile previews.
Files are staged in the repository,
not deployed to the real home. The account is still `/bin/zsh`; no shell
registration, service change or authentication attempt has been performed.

Implemented:

- Modern Bash 5 requirement, shared login/non-login environment, guarded
  interactive setup, no obsolete Cargo/Ruby/Java hooks or tmux aliases.
- Vi editing, case-insensitive completion, nvim editor and Tokyo Night prompt:
  blue directory (#7aa2f7), neutral Git branch and prompt symbol (#c0caf5),
  yellow dirty marker (#e0af68). Truecolor escapes are Readline-wrapped and
  reset before command input; terminal background/palette remain Ghostty's
  responsibility.
- Separate append-mode Bash history; append/read prompt hook preserves status.
- fnm Bash integration and activation of an already-installed default/project
  version. No install-if-missing or startup downloads; Node remains 24.11.1.
- direnv hook, Bash completion and herdr completion loaded once per shell.
- Existing fzf defaults retained; no new fzf keybindings introduced yet.
- Existing prompt commands preserved; nested fnm shells replace the inherited
  multishell PATH entry instead of accumulating it.
- macOS local YubiKey socket selected only if unset and actually present.
  Existing/forwarded sockets are left alone. Linux agent discovery remains a
  target-machine task.

Installed missing checking tools: ShellCheck, shfmt and Bats Core from
`packages/Brewfile.dev`; Bash completion from the workflow manifest. Both
manifests were applied twice with upgrades and automatic cleanup disabled;
second runs reused all packages. The earlier libtiff/webp metadata warning
remains unrelated and was not repaired.

Validation:

- `./scripts/check.sh`: syntax, ShellCheck, shfmt and all 13 Bats tests passed.
  The prompt regression test verifies Tokyo Night RGB output and Readline-safe
  color/reset escapes.
  Checks include every module. Tests also cover undeployed rcfile previews,
  numbered loading order and one-time interactive-only module execution.
- The same runner passed from `/tmp`; it resolves paths relative to itself.
- Tests use temporary homes (including spaces), controlled PATH, stubbed
  optional integrations and separate temporary Stow targets. Login-file tests
  source the profile explicitly with system profiles disabled for isolation.
- An additional real macOS login smoke check used a temporary Stow target and
  the actual installed fnm/direnv/herdr/completion tools. Node 24.11.1, npm
  11.6.2, pnpm 10.33.4, vi mode and herdr completion resolved correctly;
  SSH_AUTH_SOCK and PATH after re-sourcing were preserved. Only expected
  no-terminal/job-control diagnostics occurred in this non-PTY command runner.
  The temporary target and fnm session state were removed afterward.
- Stow simulation changes nothing; repeated deployments produce identical
  symlink targets; unmanaged conflicts are rejected without partial deployment.

Still needed: a human interactive check in Ghostty/herdr, clipboard and YubiKey
SSH authentication, explicit backup of the existing real `~/.bashrc`, deployment,
registration/login-shell change, Linux validation and CI. Do not treat stubbed
Linux branches as proof of a working CachyOS desktop.

## Bash implementation gate

1. Inspect and preserve existing startup files; Stow must fail on unmanaged
   conflicts, never adopt or overwrite them automatically.
2. Add `.bash_profile`, `.bashrc`, and `.inputrc` as one Stow package.
3. Define explicit startup ordering. Login environment and interactive hooks
   have different responsibilities; GUI session environment is separate again.
4. Guard interactive setup and non-repeatable integrations. Re-sourcing must
   not duplicate PATH entries, prompt hooks or registrations.
5. Translate approved direnv/Node-manager initialization to documented Bash
   forms. Omit obsolete Rust, Ruby and Java hooks and aliases.
6. Keep history separate from `.zsh_history`; preserve the old history file.
7. Validate prompt, completion, vi editing, herdr and clipboard inside Bash
   without changing the account shell first.
8. Verify agent service/socket ownership without overriding forwarded SSH
   sockets or weakening YubiKey signing/touch requirements.
9. Register the exact modern Bash path in `/etc/shells` only if absent, then
   change the account shell only if different. Both are explicit operations.
10. Check terminal/herdr overrides and a fresh login before removing tracked
    Zsh configuration. Keep temporary recovery backups outside the repo.

Recovery before cutover: the current account remains `/bin/zsh` and tracked
Zsh configuration remains available. After cutover, retain a working terminal
while checking fresh sessions. Do not automate rollback of unrelated changes.

## CachyOS / niri / Noctalia gate

- Verify package names and already-installed components on the actual target.
- Use pacman `--needed`; upgrades are a separate operation. Never use `pacman
  -Sy` followed by selective installation (partial upgrades are unsupported).
- Review any needed AUR package before building; never run an AUR helper as root.
- Change the account shell to system Bash, not by deleting fish.
- Inspect vendor session integration before replacing it.
- Have one owner for Noctalia startup and notification delivery.
- Verify portals, PipeWire, polkit, clipboard, fonts and selected hardware
  services; do not install duplicates by assumption.
- Keep GUI/session environment independent of `.bashrc`.
- Validate compositor config, notifications, clipboard, screen sharing, lock,
  suspend/resume, and a repeated provisioning run on the target machine.

## Idempotency contract

- Reapplication converges to the same managed state; success alone is insufficient.
- Install only missing approved packages; no implicit upgrades or removals.
- Separate package installation, configuration, services and account changes.
- Correct existing symlinks are reused; unmanaged conflicts stop deployment.
- Write generated files only when content differs; avoid truncated replacement.
- No installation, network access or service startup in Bash initialization.
- Prompt/PATH/hook setup must tolerate re-sourcing and nested shells.
- Dry-run operations perform no configuration writes or privileged changes.
- Errors stop dependent operations; no blanket suppression of provisioning errors.
- Elevate individual required operations, never the whole deployment.

## Regression suite gate

Introduce checks alongside each behavior change, then complete the suite:

- `bash -n`, ShellCheck, shfmt, and Bats Core.
- Temporary HOME and XDG directories, controlled PATH and stubbed external tools.
- Login, interactive and noninteractive startup; optional tools absent.
- Re-source twice and launch nested Bash: no duplicated PATH or hooks.
- Preserve unrelated prompt hooks and forwarded SSH sockets.
- Stow twice into a temporary home: compare managed files and symlink targets.
- Unmanaged-file conflicts, dry-run nonmutation and failure propagation.
- Herdr config validation and isolated completion-generation tests; isolated
  Neovim data directories. Do not attach tests to active herdr sessions.
- CI on macOS with modern Bash and an Arch userland environment.
- Real CachyOS desktop and YubiKey checks remain manual integration tests;
  containers and stubs cannot establish graphical or hardware correctness.

Existing script issues to address when their phase is implemented:

- `rust.sh` reruns the installer instead of checking the chosen toolchain.
- `update-skills.sh` targets `config/opencode/skills`, not the tracked
  `config/.config/opencode/skills`; it deletes before copying and lacks failure
  cleanup. Stage validated content before replacing anything if retained.
- `macos.sh` is not a Bash migration prerequisite; audit separately before use.
