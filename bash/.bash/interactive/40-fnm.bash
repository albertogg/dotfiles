# shellcheck shell=bash
if command -v fnm >/dev/null 2>&1; then
  if _dotfiles_init=$(fnm env --use-on-cd --shell bash); then
    # Replace the parent's multishell path only after initialization succeeds.
    if [[ -n ${FNM_MULTISHELL_PATH:-} ]]; then
      # The sentinel preserves empty PATH entries, including a trailing one.
      IFS=: read -r -a _dotfiles_paths <<<"$PATH:"
      _dotfiles_new_path=
      for _dotfiles_path in "${_dotfiles_paths[@]}"; do
        [[ $_dotfiles_path == "$FNM_MULTISHELL_PATH/bin" ]] && continue
        _dotfiles_new_path+="$_dotfiles_path:"
      done
      export PATH="${_dotfiles_new_path%:}"
      unset _dotfiles_paths _dotfiles_path _dotfiles_new_path
    fi
    eval "$_dotfiles_init"
    # Select an installed project/default version; never install a missing one.
    fnm use --log-level quiet || :
  fi
fi
unset _dotfiles_init
