#!/usr/bin/env bash

set -e

SOURCE_REPO="https://github.com/mattpocock/skills.git"
FOLDERS=("improve-codebase-architecture" "tdd" "triage-issue" "request-refactor-plan" "write-a-prd" "prd-to-issues" "grill-me")
DEST="./config/opencode/skills"

tmp=$(mktemp -d)
git clone --depth=1 "$SOURCE_REPO" "$tmp"
for f in "${FOLDERS[@]}"; do
  rm -rf "$DEST/$f"
  cp -r "$tmp/$f" "$DEST/$f"
done

rm -rf "$tmp"
echo "Done. Review changes with: git -C $DEST diff"
