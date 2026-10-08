# shellcheck shell=bash
# Completions load before individual tools register their completions.
if [[ $(uname -s) == Darwin && -r /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
  # shellcheck source=/dev/null
  source /opt/homebrew/etc/profile.d/bash_completion.sh
elif [[ -r /usr/share/bash-completion/bash_completion ]]; then
  # shellcheck source=/dev/null
  source /usr/share/bash-completion/bash_completion
fi
