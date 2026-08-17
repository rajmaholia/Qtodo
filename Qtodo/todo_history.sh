build_history_data() {
  find "$TODO_DIR" -type f -name "*.todo" -printf "%f\n" |
    sort -r |
    while IFS= read -r file; do
      printf '%s\n<big>%s</big>\n' "$file" "$file"
    done
}

view_history() {
  local file

  while true; do
    file=$(
      build_history_data | yad \
        --list \
        --print-column=1 \
        --no-headers \
        --title="Todo History" \
        --text-align=center \
        --text="<big><big><b>Todo History</b></big></big>" \
        --column="Date:HD" \
        --column="DateLabel" \
        --width="$WIDTH" --height="$HEIGHT" \
        --separator=""
    ) || return 0
    [[ -z "$file" ]] && return 0

    local his_dump
    view_todolist "$TODO_DIR/$file" >/dev/null || :
  done
}
