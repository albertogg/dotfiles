# add coreutils.
# add coreutils manuals.
# add homebrew installed packages.
export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/sbin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# remove duplicates from PATH.
typeset -U PATH
