#!/usr/bin/env bats
# Test programs are passed literally to child shells for expansion there.
# shellcheck disable=SC2016

setup() {
  REPO="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  BASH_BIN="$(command -v bash)"
  TEST_HOME="$BATS_TEST_TMPDIR/home with spaces"
  STUB_BIN="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$TEST_HOME" "$STUB_BIN"
  ln -s "$REPO/bash/.bashrc" "$TEST_HOME/.bashrc"
  ln -s "$REPO/bash/.bash_profile" "$TEST_HOME/.bash_profile"
  ln -s "$REPO/bash/.inputrc" "$TEST_HOME/.inputrc"
  ln -s "$REPO/bash/.bash" "$TEST_HOME/.bash"
  # Exclude Homebrew and user tools; platform-dependent tools are stubbed.
  printf '#!/bin/sh\nprintf "Linux\\n"\n' >"$STUB_BIN/uname"
  chmod +x "$STUB_BIN/uname"
}

stub_integrations() {
  cat >"$STUB_BIN/fnm" <<'STUB'
#!/bin/sh
printf '%s\n' "fnm $1" >> "$HOME/tool-calls"
case "$1" in
  env)
    printf 'export FNM_MULTISHELL_PATH="$HOME/fnm-%s"\n' "$$"
    printf 'export PATH="$FNM_MULTISHELL_PATH/bin:$PATH"\n'
    ;;
  use) ;;
  *) exit 1 ;;
esac
STUB
  cat >"$STUB_BIN/direnv" <<'STUB'
#!/bin/sh
printf '%s\n' "direnv $*" >> "$HOME/tool-calls"
printf '%s\n' '_test_direnv_hook() { :; }' 'PROMPT_COMMAND=(_test_direnv_hook "${PROMPT_COMMAND[@]}")'
STUB
  cat >"$STUB_BIN/herdr" <<'STUB'
#!/bin/sh
printf '%s\n' "herdr $*" >> "$HOME/tool-calls"
printf '%s\n' 'complete -W "session config" herdr'
STUB
  chmod +x "$STUB_BIN/fnm" "$STUB_BIN/direnv" "$STUB_BIN/herdr"
}

shell() {
  env -i HOME="$TEST_HOME" PATH="$STUB_BIN:/usr/bin:/bin" \
    XDG_CONFIG_HOME="$TEST_HOME/.config" XDG_DATA_HOME="$TEST_HOME/.local/share" \
    XDG_CACHE_HOME="$TEST_HOME/.cache" XDG_STATE_HOME="$TEST_HOME/.local/state" \
    TERM=dumb LC_ALL=C SHELL="$BASH_BIN" BASH_BIN="$BASH_BIN" "$BASH_BIN" --noprofile --norc "$@"
}

@test "noninteractive initialization is quiet and supplies the editor and user paths" {
  run shell -c '
    source "$HOME/.bashrc"
    [[ $EDITOR == nvim && $VISUAL == nvim ]] || exit 1
    [[ :$PATH: == *":$HOME/.local/bin:"* ]] || exit 1
    [[ :$PATH: == *":$HOME/go/bin:"* ]] || exit 1
  '
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "interactive Bash has vi editing, separate history and no retired runtime aliases" {
  run shell -ic '
    exec 2>"$HOME/startup-errors"
    source "$HOME/.bashrc"
    [[ $HISTFILE == "$HOME/.bash_history" ]] || exit 1
    shopt -q histappend || exit 1
    [[ -o vi ]] || exit 1
    alias gss >/dev/null || exit 1
    ! alias be >/dev/null 2>&1 || exit 1
    ! alias tmux >/dev/null 2>&1 || exit 1
    [[ ! -s "$HOME/startup-errors" ]] || exit 1
    printf READY
  '
  [ "$status" -eq 0 ]
  [[ "$output" == *READY ]]
}

@test "login profile supplies environment silently without running interactive tools" {
  stub_integrations
  run shell --login -c '
    source "$HOME/.bash_profile"
    [[ $EDITOR == nvim ]] || exit 1
    [[ ! -e "$HOME/tool-calls" ]] || exit 1
    [[ ! -v PROMPT_COMMAND ]] || exit 1
  '
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "re-sourcing preserves prompt commands and runs tool integrations only once" {
  stub_integrations
  run shell -ic '
    exec 2>"$HOME/startup-errors"
    PROMPT_COMMAND="printf existing > \"\$HOME/prompt-marker\""
    SSH_AUTH_SOCK="$HOME/forwarded.sock"
    source "$HOME/.bashrc"
    before_path=$PATH
    before_hooks=$(declare -p PROMPT_COMMAND)
    source "$HOME/.bashrc"
    [[ $PATH == "$before_path" ]] || exit 1
    [[ $(declare -p PROMPT_COMMAND) == "$before_hooks" ]] || exit 1
    [[ $SSH_AUTH_SOCK == "$HOME/forwarded.sock" ]] || exit 1
    for hook in "${PROMPT_COMMAND[@]}"; do eval "$hook"; done
    [[ $(<"$HOME/prompt-marker") == existing ]] || exit 1
    [[ $(<"$HOME/tool-calls") == $'"'"'fnm env\nfnm use\ndirenv hook bash\nherdr completion bash'"'"' ]] || exit 1
    [[ ! -s "$HOME/startup-errors" ]] || exit 1
    printf READY
  '
  [ "$status" -eq 0 ]
  [[ "$output" == *READY ]]
}

@test "nested shells replace inherited fnm paths rather than accumulating them" {
  stub_integrations
  run shell -ic '
    exec 2>"$HOME/startup-errors"
    source "$HOME/.bashrc"
    export PARENT_FNM_BIN="$FNM_MULTISHELL_PATH/bin"
    "$BASH_BIN" --noprofile --norc -ic '\''
      source "$HOME/.bashrc"
      [[ :$PATH: != *":$PARENT_FNM_BIN:"* ]] || exit 1
      [[ :$PATH: == *":$FNM_MULTISHELL_PATH/bin:"* ]] || exit 1
      [[ :$PATH: != *":$HOME/.local/bin:$HOME/.local/bin:"* ]] || exit 1
    '\'' || exit 1
    printf READY
  '
  [ "$status" -eq 0 ]
  [[ "$output" == *READY ]]
}

@test "failed fnm initialization leaves the inherited Node path usable" {
  printf '#!/bin/sh\nexit 1\n' >"$STUB_BIN/fnm"
  chmod +x "$STUB_BIN/fnm"
  run shell -ic '
    exec 2>"$HOME/startup-errors"
    export FNM_MULTISHELL_PATH="$HOME/parent-fnm"
    export PATH="$FNM_MULTISHELL_PATH/bin:$PATH"
    source "$HOME/.bashrc"
    [[ :$PATH: == *":$FNM_MULTISHELL_PATH/bin:"* ]] || exit 1
    [[ ! -s "$HOME/startup-errors" ]] || exit 1
    printf READY
  '
  [ "$status" -eq 0 ]
  [[ "$output" == *READY ]]
}

@test "array prompt commands survive initialization and history keeps exit status" {
  run shell -ic '
    exec 2>"$HOME/startup-errors"
    PROMPT_COMMAND=("printf first" "printf second")
    source "$HOME/.bashrc"
    [[ ${PROMPT_COMMAND[0]} == "printf first" ]] || exit 1
    [[ ${PROMPT_COMMAND[1]} == "printf second" ]] || exit 1
    history -s "echo from-first-session"
    (exit 7)
    eval "${PROMPT_COMMAND[2]}"
    [[ $? == 7 ]] || exit 1
    [[ $(<"$HISTFILE") == *"echo from-first-session"* ]] || exit 1
    [[ ! -e "$HOME/.zsh_history" ]] || exit 1
    printf READY
  '
  [ "$status" -eq 0 ]
  [[ "$output" == *READY ]]
}

@test "prompt expansion is quiet outside Git and shows branch and dirty state inside Git" {
  run shell -ic '
    exec 2>"$HOME/startup-errors"
    cd "$HOME" || exit 1
    source "$HOME/.bashrc"
    printf "%s" "${PS1@P}" > "$HOME/plain-prompt"
    [[ ! -s "$HOME/startup-errors" ]] || exit 1
    git init -q -b audit "$HOME/repo" || exit 1
    cd "$HOME/repo" || exit 1
    [[ ${PS1@P} == *audit* ]] || exit 1
    [[ ${PS1@P} != *" *"* ]] || exit 1
    printf changed > untracked
    printf "%s" "${PS1@P}" > "$HOME/dirty-prompt"
    [[ ! -s "$HOME/startup-errors" ]] || exit 1
    printf READY
  '
  [ "$status" -eq 0 ]
  [[ "$output" == *READY ]]
  dirty_prompt="$(<"$TEST_HOME/dirty-prompt")"
  dirty_prompt="${dirty_prompt//$'\001'/}"
  dirty_prompt="${dirty_prompt//$'\002'/}"
  [[ "$dirty_prompt" == *$'\e[0;38;2;192;202;245m audit'* ]]
  [[ "$dirty_prompt" == *$'\e[38;2;224;175;104m *'* ]]
}

@test "prompt renders Tokyo Night colors with Readline-safe escapes and resets" {
  run shell -ic '
    exec 2>"$HOME/startup-errors"
    source "$HOME/.bashrc" || exit 1
    printf "%s" "${PS1@P}" > "$HOME/rendered-prompt"
    printf "%s" "$PS1" > "$HOME/prompt-template"
    [[ ! -s "$HOME/startup-errors" ]] || exit 1
    printf READY
  '
  [ "$status" -eq 0 ]
  prompt="$(<"$TEST_HOME/rendered-prompt")"
  template="$(<"$TEST_HOME/prompt-template")"
  [[ "$prompt" == *$'\e[1;38;2;122;162;247m'* ]]
  [[ "$prompt" == *$'\e[0;38;2;192;202;245m'* ]]
  [[ "$prompt" == *$'\e[38;2;224;175;104m'* ]]
  [[ "$prompt" == *$'\e[38;2;192;202;245m'* ]]
  [[ "$template" == *'\[\e[1;38;2;122;162;247m\]'* ]]
  [[ "$template" == *'\[\e[0;38;2;192;202;245m\]'* ]]
  [[ "$template" == *'\[\e[38;2;224;175;104m\]'* ]]
  [[ "$template" == *'\[\e[38;2;192;202;245m\]'* ]]
  [[ "$template" == *'\[\e[0m\] ' ]]
}

@test "rcfile preview finds its modules without deploying a home .bash directory" {
  rm "$TEST_HOME/.bash"
  run shell -ic '
    exec 2>"$HOME/startup-errors"
    source "$1" || exit 1
    [[ $EDITOR == nvim && -o vi ]] || exit 1
    [[ $HISTFILE == "$HOME/.bash_history" ]] || exit 1
    [[ ! -s "$HOME/startup-errors" ]] || exit 1
    printf READY
  ' bash "$REPO/bash/.bashrc"
  [ "$status" -eq 0 ]
  [[ "$output" == *READY ]]
}

@test "numbered modules run in order once and never in noninteractive shells" {
  candidate="$BATS_TEST_TMPDIR/candidate with spaces"
  cp -R "$REPO/bash" "$candidate"
  printf 'printf first >> "$HOME/module-order"\n' >"$candidate/.bash/interactive/05-marker.bash"
  printf 'printf second >> "$HOME/module-order"\n' >"$candidate/.bash/interactive/75-marker.bash"
  run shell -c 'source "$1"' bash "$candidate/.bashrc"
  [ "$status" -eq 0 ]
  [ ! -e "$TEST_HOME/module-order" ]
  run shell -ic '
    exec 2>"$HOME/startup-errors"
    source "$1" || exit 1
    source "$1" || exit 1
    [[ $(<"$HOME/module-order") == firstsecond ]] || exit 1
    [[ ! -s "$HOME/startup-errors" ]] || exit 1
    printf READY
  ' bash "$candidate/.bashrc"
  [ "$status" -eq 0 ]
  [[ "$output" == *READY ]]
}

@test "Stow dry-run is nonmutating and two deployments produce the same links" {
  target="$BATS_TEST_TMPDIR/stow target"
  mkdir -p "$target"
  run stow --dir="$REPO" --target="$target" --no-folding --simulate bash
  [ "$status" -eq 0 ]
  [ -z "$(find "$target" -mindepth 1 -print)" ]

  run stow --dir="$REPO" --target="$target" --no-folding bash
  [ "$status" -eq 0 ]
  for file in .bashrc .bash_profile .inputrc .bash/environment.bash; do
    [ -L "$target/$file" ]
  done
  for file in "$REPO"/bash/.bash/interactive/*.bash; do
    [ -L "$target/.bash/interactive/${file##*/}" ]
    cmp "$file" "$target/.bash/interactive/${file##*/}"
  done
  before="$(find "$target" -type l -exec readlink {} \;)"
  run stow --dir="$REPO" --target="$target" --no-folding bash
  [ "$status" -eq 0 ]
  [ "$(find "$target" -type l -exec readlink {} \;)" = "$before" ]
}

@test "Stow rejects an unmanaged startup file without changing anything" {
  target="$BATS_TEST_TMPDIR/conflict target"
  mkdir -p "$target"
  printf user-owned >"$target/.bashrc"
  run stow --dir="$REPO" --target="$target" --no-folding bash
  [ "$status" -ne 0 ]
  [ "$(<"$target/.bashrc")" = user-owned ]
  [ ! -L "$target/.bashrc" ]
  [ ! -e "$target/.bash_profile" ]
  [ ! -e "$target/.inputrc" ]
  [ ! -e "$target/.bash" ]
}
