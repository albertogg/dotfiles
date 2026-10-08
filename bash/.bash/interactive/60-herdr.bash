# shellcheck shell=bash
if command -v herdr >/dev/null 2>&1; then
  if _dotfiles_init=$(herdr completion bash); then
    eval "$_dotfiles_init"
  fi
fi
unset _dotfiles_init
