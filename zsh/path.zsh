# prepend to PATH.
# add coreutils.
# add homebrew installed packages.
export PATH="/usr/local/share/python:$PATH"
export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
# remove duplicates from PATH.
typeset -U PATH
