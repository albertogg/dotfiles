# shellcheck shell=bash
_dotfiles_prepend_path() {
  case ":$PATH:" in
  *":$1:"*) ;;
  *) export PATH="$1${PATH:+:$PATH}" ;;
  esac
}

# The macOS machine uses Apple Silicon Homebrew; Linux uses system packages.
if [[ $(uname -s) == Darwin && -d /opt/homebrew/bin ]]; then
  _dotfiles_prepend_path /opt/homebrew/sbin
  _dotfiles_prepend_path /opt/homebrew/bin
  if [[ -z ${SSH_AUTH_SOCK:-} && -S /opt/homebrew/var/run/yubikey-agent.sock ]]; then
    export SSH_AUTH_SOCK=/opt/homebrew/var/run/yubikey-agent.sock
  fi
fi

IFS=: read -r -a _dotfiles_go_paths <<<"${GOPATH:-$HOME/go}"
for _dotfiles_go_path in "${_dotfiles_go_paths[@]}"; do
  [[ -z $_dotfiles_go_path ]] || _dotfiles_prepend_path "$_dotfiles_go_path/bin"
done
unset _dotfiles_go_paths _dotfiles_go_path
_dotfiles_prepend_path "$HOME/.local/bin"
export EDITOR=nvim
export VISUAL=nvim
