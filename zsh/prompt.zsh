git_prompt_info() {
  current_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  if [[ -n $current_branch ]]; then
    echo " %B%F{241}$current_branch%f%b$(parse_git_dirty)%{$reset_color%}"
  fi
}

parse_git_dirty() {
  if [[ $(command git status --porcelain --ignore-submodules -unormal) != "" ]]; then
    echo " %B%F{220}*%f%b"
  fi
}

setopt promptsubst
PS1='%B%F{044}%c%f%b%{$reset_color%}$(git_prompt_info) %# '
