if command -v yubikey-agent >/dev/null; then
  export SSH_AUTH_SOCK="$(brew --prefix)/var/run/yubikey-agent.sock"
fi
