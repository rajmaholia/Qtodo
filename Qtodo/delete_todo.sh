delete_ui() {
  yad \
    --list \
    --checklist \
    --print-all \
    --title="Delete Todos" \
    --width="$WIDTH" \
    --height="$HEIGHT" \
    --separator="|" \
    --column="Delete:CHK" \
    --column="ID:HD" \
    --column="Task" \
    --column="DONE:HD" \
    --column="Status"
}

build_delete_ui() {
  local file=$1
  while IFS='|' read -r id done task _; do
    local todo_status_icons
    if [[ $done == "TRUE" ]]; then
      todo_status_icons=""
    else
      todo_status_icons=""
    fi

    printf '%s\n%s\n%s\n%s\n%s\n' \
      "FALSE" \
      "$id" \
      "$task" \
      "$done" \
      "$todo_status_icons"
  done <"$file"
}

delete_todo() {
  [[ -n "${1:-}" ]] || return

  local todo_file=$1

  local action
  local tmp

  action=$(build_delete_ui "$todo_file" | delete_ui) || return

  tmp=$(mktemp)

  while IFS='|' read -r delete id task done todo_status_icons _; do
    [[ "$delete" == "TRUE" ]] && continue

    printf '%s|%s|%s|\n' \
      "$id" "$done" "$task"
  done <<<"$action" >"$tmp"

  mv "$tmp" "$todo_file"
}
