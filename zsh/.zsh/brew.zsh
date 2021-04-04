# Auto update once a day
export HOMEBREW_AUTO_UPDATE_SECS=86400
# Install casks at /Applications
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Homebrew directory for Apple M1 ARM chip
if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# How to make brew completions work in ZSH:
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
