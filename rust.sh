#!/usr/bin/env bash

if command -v rustup-init >/dev/null; then
  # Install rustup and the default tooling
  rustup-init -v
else
  echo "Missing rust-init, exiting..."
  exit 1
fi

# Install rust-src for racer completions
rustup component add rust-src¬
# Install the nightly toolchain to be able to install racer
rustup toolchain add nightly
cargo +nightly install racer
