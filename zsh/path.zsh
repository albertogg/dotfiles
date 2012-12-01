# prepend to PATH.

# search for rbenv.
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# add python path for hombrew version.
export PATH="/usr/local/share/python:$PATH"
# add coreutils.
# add homebrew installed packages.
# last export will be the first in path!
export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"


# remove duplicates from PATH.
typeset -U PATH
