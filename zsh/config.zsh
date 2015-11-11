# Completion
setopt always_to_end
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word  # cursor is set to the end of the word if completion is started
unsetopt menu_complete   # do not autoselect the first completion entry

# History settings
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history
setopt bang_hist

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Directories
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_minus
setopt extendedglob

# vi mode
bindkey -v
bindkey "^F" vi-cmd-mode
bindkey jj vi-cmd-mode

# handy keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"
