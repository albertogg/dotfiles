function precmd() {
  print -rP '%{$fg[cyan]%}%n@%M %{$fg[white]%}➜ %{$fg[yellow]%}%c %{$fg[
  white]%}$(git_prompt_info)'
}

PROMPT='%{$reset_color%}%# '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ✗ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✓%{$reset_color%} "