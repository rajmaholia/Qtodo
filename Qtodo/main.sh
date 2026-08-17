#!/usr/bin/env bash

set -euo pipefail

###############################################################################
# Configuration
###############################################################################
SCRIPT_ROOT="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

TODO_DIR="$HOME/QuickCenter/Todos"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/todo"
LOCK_FILE="$STATE_DIR/todo.lock"

WIDTH=700
HEIGHT=500
FONT="JetBrainsMonoNerdFont 16"

source "$SCRIPT_ROOT/helper.sh"
source "$SCRIPT_ROOT/add_todo.sh"
source "$SCRIPT_ROOT/delete_todo.sh"
source "$SCRIPT_ROOT/view_todo.sh"
source "$SCRIPT_ROOT/todo_history.sh"

main_loop() {
  local ACTION
  while true; do
    if ACTION=$(view_todolist "$TODAY_FILE" false); then
      STATUS=0
    else
      STATUS=$?
    fi

    case "$STATUS" in
    0)
      printf "$ACTION\n" >"$TODAY_FILE"
      break
      ;;
    10)
      add_todo "$TODAY_FILE"
      ;;
    11)
      delete_todo "$TODAY_FILE" >/dev/null || :
      ;;
    12)
      view_history
      ;;
    *)
      exit 1
      ;;
    esac

  done
}

main() {
  singleton

  mkdir -p "$TODO_DIR"

  TODAY_FILE=$(today_file)
  ensure_today

  main_loop
}

main "$@"
