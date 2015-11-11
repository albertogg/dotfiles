##################
# prepend to PATH.

##
# if exists, export heroku postgres.app to PATH.
if [[ -e "/Applications/Postgres.app" ]]; then
  export PATH="/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH"
fi

##
# if go is installed export GOPATH
if [[ ( -e `which go` && -e "$HOME/go" ) ]]; then
  export GOPATH=$HOME/go
  export PATH="$GOPATH/bin:$PATH"
  export PATH="$PATH:/usr/local/opt/go/libexec/bin"
fi

##
# search for rbenv.
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

##
# add coreutils.
# add coreutils manuals.
# add homebrew installed packages.
# last export will be the first in path!
export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/sbin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

##
# remove duplicates from PATH.
typeset -U PATH
