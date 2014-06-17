completion="$(brew --prefix)/share/zsh/site-functions/go"

if test -f $completion
then
  source <(cat $completion)
fi
