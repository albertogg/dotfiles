#!/usr/bin/env bash
set -euo pipefail

if ((BASH_VERSINFO[0] < 5)); then
  printf 'Checks require Bash 5 or newer; macOS: /opt/homebrew/bin/bash\n' >&2
  exit 1
fi

cd "$(dirname "${BASH_SOURCE[0]}")/.."
# Nested test shells must use this interpreter, not macOS /bin/bash.
PATH="$(dirname "$BASH"):$PATH"
export PATH
for tool in shellcheck shfmt bats stow; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf 'Missing check dependency: %s\n' "$tool" >&2
    exit 1
  fi
done

shell_files=(bash/.bashrc bash/.bash_profile bash/.bash/environment.bash
  bash/.bash/interactive/*.bash scripts/check.sh)
for file in "${shell_files[@]}"; do
  bash -n "$file"
done
shellcheck -s bash "${shell_files[@]}" tests/bash.bats
shfmt -d -ln bash -i 2 "${shell_files[@]}"
shfmt -d -ln bats -i 2 tests/bash.bats
bats tests/bash.bats
