# Set the environment with Rust binaries
if command -v rustup-init >/dev/null; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi
