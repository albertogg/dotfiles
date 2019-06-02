# if go is installed export GOPATH
if command -v go >/dev/null; then
  export GOPATH=~/go
  export PATH="$GOPATH/bin:$PATH"
  export PATH="/usr/local/opt/go/libexec/bin:$PATH"
fi
