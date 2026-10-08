# shellcheck shell=bash
# Do not source the obsolete ~/.profile Cargo setup.
# Environment is shared with non-login shells; .bashrc guards interactive work.
if [[ -r $HOME/.bashrc ]]; then
  # shellcheck source=bash/.bashrc
  source "$HOME/.bashrc"
fi
