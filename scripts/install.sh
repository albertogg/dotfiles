#!/usr/bin/env bash

##
# Copied and modified from @jonotrujillo
##

SKIP_ALL=false
OVERWRITE_ALL=false

LINKABLES=$(find * -name "*.symlink")

for linkable in $LINKABLES; do
  SKIP=false
  OVERWRITE=false

  LINKABLE_NAME="${linkable##*/}"

  if [[ $LINKABLE_NAME =~ ".zsh." ]]; then
    TARGET_NAME="${LINKABLE_NAME%.symlink}"
    TARGET="$HOME/Desktop/bolas/zsh/$TARGET_NAME"
  else
    TARGET_NAME=".${LINKABLE_NAME%.symlink}"
    TARGET="$HOME/Desktop/bolas/$TARGET_NAME"
  fi

  if [ -e "$TARGET" ] && ! $OVERWRITE_ALL && ! $SKIP_ALL; then
    until $SKIP || $SKIP_ALL || $OVERWRITE || $OVERWRITE_ALL; do
      echo "File already exists: $TARGET. What do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all"
      read action
      case $action in
        "s" ) SKIP=true;;
        "S" ) SKIP_ALL=true;;
        "o" ) OVERWRITE=true;;
        "O" ) OVERWRITE_ALL=true;;
        *   ) echo "'$action' is not a valid option. Please try again.";;
      esac
    done
  fi

  if [ -e "$TARGET" ] && ( $OVERWRITE || $OVERWRITE_ALL ); then
    rm -r "$TARGET"
  fi

  if [ ! -e "$TARGET" ]; then
    echo "Symlinking $linkable..."
    ln -s "$PWD/$linkable" "$TARGET"
  fi
done
