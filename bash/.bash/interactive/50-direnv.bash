# shellcheck shell=bash
if command -v direnv >/dev/null 2>&1; then
  if _dotfiles_init=$(direnv hook bash); then
    eval "$_dotfiles_init"
  fi
fi
unset _dotfiles_init
