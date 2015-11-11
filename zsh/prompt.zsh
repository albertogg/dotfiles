git_prompt_info() {
  current_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  if [[ -n $current_branch ]]; then
    echo " %B%F{241}$current_branch%{$reset_color%}%b"
  fi
}
setopt promptsubst
export PS1='%B%F{044}%c%f%b%{$reset_color%}$(git_prompt_info) %# '
