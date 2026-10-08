# shellcheck shell=bash
if ((BASH_VERSINFO[0] < 5)); then
  printf 'Dotfiles require Bash 5 or newer; macOS: /opt/homebrew/bin/bash\n' >&2
  return 1
fi

# Resolve beside this file: works both after Stow and with --rcfile previews.
_dotfiles_bash_dir="$(dirname -- "${BASH_SOURCE[0]}")/.bash"
# shellcheck source=bash/.bash/environment.bash
source "$_dotfiles_bash_dir/environment.bash" || return 1

# Scripts must not inherit interactive aliases, prompt hooks or tool setup.
if [[ $- != *i* || ${_DOTFILES_BASH_INITIALIZED:-} == 1 ]]; then
  unset _dotfiles_bash_dir
  return 0
fi
_DOTFILES_BASH_INITIALIZED=1

set -o vi
[[ ! -r ${INPUTRC:-$HOME/.inputrc} ]] || bind -f "${INPUTRC:-$HOME/.inputrc}"
alias gss='git status -s'

# Numbered filenames define the initialization order.
for _dotfiles_config in "$_dotfiles_bash_dir"/interactive/*.bash; do
  [[ -f $_dotfiles_config ]] || continue
  # Modules are also checked individually by scripts/check.sh.
  # shellcheck source=/dev/null
  source "$_dotfiles_config"
done
unset _dotfiles_config _dotfiles_bash_dir
