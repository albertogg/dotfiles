# Set the environment with direnv
if command -v fzf >/dev/null; then
  export FZF_DEFAULT_OPTS="--height=25% --multi --tiebreak=begin"
  export FZF_DEFAULT_COMMAND="rg --files --follow --hidden --ignore-case --no-ignore --glob '!.git/*' --glob '!vendor/*' --glob '!node_modules/*'"
fi
