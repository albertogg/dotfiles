git_prompt_info() {
  current_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  if [[ -n $current_branch ]]; then
    parse_git_dirty
  fi
}

parse_git_dirty() {
  if [[ $(git status --porcelain 2> /dev/null) != "" ]]; then
    set_git_prompt_color 214 # orange color for dirty branch
  else
    set_git_prompt_color 241 # gray color for clean branch
  fi
}

set_git_prompt_color() {
  echo " %B%F{$1}$current_branch%f%b%{$reset_color%}"
}

setopt promptsubst
export PS1='%B%F{044}%c%f%b%{$reset_color%}$(git_prompt_info) %# '
