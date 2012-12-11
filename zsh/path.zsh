# prepend to PATH.

# export heroku postgres.app to PATH if exists.
if [[ -e /Applications/Postgres.app ]]; then export PATH="/Applications/Postgres.app/Contents/MacOS/bin:$PATH"; fi

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
