# Add coreutils.
# Add coreutils manuals.
# Add homebrew installed packages.

# Homebrew directory for Apple M1 ARM chip
if [ -f /opt/homebrew/bin/brew ]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
else
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/sbin:$PATH"
  export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
fi

# Remove duplicates from PATH.
typeset -U PATH
