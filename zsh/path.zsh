##################
# prepend to PATH.

##
# if exists, export heroku postgres.app to PATH.
if [[ -e "/Applications/Postgres.app" ]]; then export PATH="/Applications/Postgres.app/Contents/Versions/9.3/bin:$PATH"; fi

##
# if go is installed export GOPATH
if [[ ( -e `which go` && -e "$HOME/go" ) ]]; then export GOPATH=$HOME/go && export PATH="$GOPATH/bin:$PATH"; fi

##
# search for rbenv.
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

##
# add coreutils.
# add coreutils manuals.
# add homebrew installed packages.
# last export will be the first in path!
export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
export MANPATH="$(brew --prefix coreutils)/libexec/gnuman:$MANPATH"

##
# if exists, add path for homebrew installed python.
if [[ -e "/usr/local/share/python" ]]; then export PATH="/usr/local/share/python:$PATH"; fi

##
# remove duplicates from PATH.
typeset -U PATH
