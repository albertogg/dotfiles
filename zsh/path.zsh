# prepend to PATH.
# add coreutils.
# add homebrew installed packages.
PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
# remove duplicates from PATH.
typeset -U PATH