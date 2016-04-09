if command -v gls >/dev/null; then
  alias ls="gls --color"
fi

if command -v docker-machine >/dev/null; then
  alias dm='docker-machine'
fi
