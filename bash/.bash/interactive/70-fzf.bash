# shellcheck shell=bash
if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS---height=25% --multi --tiebreak=begin}"
  if command -v rg >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND="${FZF_DEFAULT_COMMAND-rg --files --follow --hidden --ignore-case --no-ignore --glob '!.git/*' --glob '!vendor/*' --glob '!node_modules/*'}"
  fi
fi
