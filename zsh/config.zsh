# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# History settings
setopt hist_ignore_all_dups
setopt inc_append_history
setopt hist_reduce_blanks
setopt extended_history
setopt share_history
if [ -z $HISTFILE ]; then
    HISTFILE=$HOME/.zsh_history
fi
HISTSIZE=10000
SAVEHIST=10000

# Awesome cd movements
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

setopt no_bg_nice # don't nice background tasks
setopt no_hup
setopt no_list_beep
setopt local_options # allow functions to have local options
setopt local_traps # allow functions to have local traps
setopt complete_in_word
unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt always_to_end

# Enable extended globing
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
