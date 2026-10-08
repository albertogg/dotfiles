# shellcheck shell=bash
HISTFILE="$HOME/.bash_history"
HISTSIZE=20000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth
shopt -s histappend histverify checkwinsize

_dotfiles_history_sync() {
  local previous_status=$?
  history -a
  history -n
  return "$previous_status"
}
# Keep existing scalar prompt commands as one command, not split on semicolons.
if [[ $(declare -p PROMPT_COMMAND 2>/dev/null) != "declare -a"* ]]; then
  PROMPT_COMMAND=("${PROMPT_COMMAND:-}")
fi
PROMPT_COMMAND+=(_dotfiles_history_sync)
