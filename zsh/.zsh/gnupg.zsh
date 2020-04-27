if command -v gpg >/dev/null; then
  export "GPG_TTY=$(tty)"
  export "SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)"
  gpg-connect-agent updatestartuptty /bye &>/dev/null
fi
