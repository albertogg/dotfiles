# Set the environment with fnm
if command -v fnm >/dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)";
fi
