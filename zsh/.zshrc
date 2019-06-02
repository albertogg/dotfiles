# Taken from:
#   https://github.com/holman/dotfiles/blob/master/zsh/zshrc.symlink

# Path to this dotfiles is $ZSH
export ZSH="$HOME/.dotfiles"

# Get all the .zsh files
typeset -U config_files
config_files=($ZSH/**/*.zsh)

# load custom executable functions
for function in $ZSH/zsh/functions/*
do
  source $function
done

# Load all path.zsh files
for file in ${(M)config_files:#*/path.zsh}
do
  source $file
done

# Load all .zsh files except path and completion files
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}
do
  source $file
done

# Initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit

# Load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}
do
  source $file
done

unset config_files
