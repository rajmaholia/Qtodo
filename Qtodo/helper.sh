singleton() {
  mkdir -p "$STATE_DIR"

  exec 9>"$LOCK_FILE"

  if ! flock -n 9; then
    exit 0
  fi
}

today_file() {
  printf "%s/%s.todo\n" \
    "$TODO_DIR" \
    "$(date +%d-%m-%Y)"
}

date_now() {
  printf "%s" "$(date +%d-%m-%Y)"
}

ensure_today() {
  [[ -f "$TODAY_FILE" ]] || touch "$TODAY_FILE"
}

get_todo_status_icon() {
  local done=$1
  if [[ "$done" == "TRUE" ]]; then
    todo_status_icons=""
  else
    todo_status_icons=""
  fi
  printf "%s" "$todo_status_icons"
}

get_filename() {
  local fullpath=$1
  local filename
  filename="${fullpath##*/}" # Remove path
  filename="${filename%.*}"  # Remove extension
  printf "%s" "$filename"
}
