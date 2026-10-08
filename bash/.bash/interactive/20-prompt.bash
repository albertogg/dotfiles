# shellcheck shell=bash
_dotfiles_git_branch() {
  local branch
  branch=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null) || return 0
  printf ' %s' "$branch"
}
_dotfiles_git_dirty() {
  local dirty
  dirty=$(command git status --porcelain --ignore-submodules 2>/dev/null) || return 0
  [[ -z $dirty ]] || printf ' *'
}
# Tokyo Night: directory #7aa2f7, branch/symbol #c0caf5, dirty #e0af68.
# Wrap every nonprinting escape for Readline; reset before command input.
PS1='\[\e[1;38;2;122;162;247m\]\W\[\e[0;38;2;192;202;245m\]$(_dotfiles_git_branch)\[\e[38;2;224;175;104m\]$(_dotfiles_git_dirty)\[\e[38;2;192;202;245m\] \$\[\e[0m\] '
