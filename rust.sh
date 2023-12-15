#!/usr/bin/env bash

if command -v rustup-init >/dev/null; then
  # Install rustup and the default tooling
  # Use custom install without any PATH modifications as this is provided by
  # the .dotfiles.
  rustup-init -v
else
  echo "Missing rust-init, exiting..."
  exit 1
fi

# Install rust-analyzer for completions, docs, and clippy.
rustup component add rust-analyzer rustfmt rust-docs clippy
