# Add coreutils.
# Add coreutils manuals.
# Add homebrew installed packages.
export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/sbin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# Remove duplicates from PATH.
typeset -U PATH
