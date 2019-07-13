if command -v gpg >/dev/null; then
  export "GPG_TTY=$(tty)"
  export "SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh"
fi
