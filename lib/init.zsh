#!/usr/bin/env zsh

export SHERPA_ENABLED=true
export SHERPA_LOG_LEVEL='info' # debug, info, no talking

if [ -n "$ZSH_VERSION" ]; then
  SHERPA_PATH=$( cd -- "$(dirname "$(dirname "$0")")" >/dev/null 2>&1 ; pwd -P )
else
  _DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  SHERPA_PATH="$(dirname "$_DIR")"
fi

SHERPA_CHECKSUM_DIR="$HOME/.local/share/local_sherpa"

# Load dependencies
source "$SHERPA_PATH/vendor/smartcd/arrays"
source "$SHERPA_PATH/vendor/smartcd/varstash"

# Load sherpa
source "$SHERPA_PATH/lib/sherpa.zsh"

# Hook into cd
if [ -n "$ZSH_VERSION" ]; then
  # ZSH
  function sherpa_chpwd_handler() {
    # Changed directory?
    if [[ -n $OLDPWD && $PWD != $OLDPWD ]]; then
      alert_sherpa_we_changed_dir
    fi
  }

  autoload -U add-zsh-hook
  add-zsh-hook chpwd sherpa_chpwd_handler
else
  # BASH
  : # Do nothing
  # Todo: add CHPWD_COMMAND
fi

# When loading the shell, we need to make sure that the sherpa is doing its job
load_local_env










typeset -g CHPWD_COMMAND=""

_chpwd_hook() {
  # shopt -s nullglob

  local f

  # run commands in CHPWD_COMMAND variable on dir change
  if [[ "$PREVPWD" != "$PWD" ]]; then
    local IFS=$';'
    for f in $CHPWD_COMMAND; do
      "$f"
    done
    unset IFS
  fi
  # refresh last working dir record
  export PREVPWD="$PWD"
}

# add `;` after _chpwd_hook if PROMPT_COMMAND is not empty
PROMPT_COMMAND="_chpwd_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

# append the command into CHPWD_COMMAND
CHPWD_COMMAND="${CHPWD_COMMAND:+$CHPWD_COMMAND;}alert_sherpa_we_changed_dir"
