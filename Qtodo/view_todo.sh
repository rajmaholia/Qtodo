build_todo_data() {
  local todo_file=$1

  while IFS= read -r line; do
    [[ -z ${line//[[:space:]]/} ]] && continue

    IFS='|' read -r id done task <<<"$line"

    printf '%s\n%s\n%s\n' \
      "$id" "$done" "$task"
  done <"$todo_file"
}

view_todolist() {
  [[ -f "$1" ]] || return

  local todo_file=$1
  local readonly=${2:-true}
  local updated_todo_content
  local filename=$(get_filename "$todo_file")
  local label
  local today_date=$(date_now)

  if [[ "$filename" == $today_date ]]; then
    label="Today"
  else
    label="$filename"
  fi

  local yad_args=(
    --list
    --no-headers
    --print-all
    --title="Todo"
    --width="450"
    --height="450"
    --column="ID:HD"
    --column="Status:CHK"
    --column="Task"
    --escape-ok
    --text-align=center
    --text="<big><big><b>$label</b></big></big>"
  )

  if [[ "$readonly" == "false" ]]; then
    yad_args+=(
      --button="Add:10"
      --button="Save:0"
      --button="Modify:11"
      --button="History:12"
    )
  fi
  yad_args+=(
    --button="Close:1"
  )

  if updated_todo_content=$(
    build_todo_data "$todo_file" |
      yad "${yad_args[@]}"
  ); then
    status=0
  else
    status=$?
  fi

  printf "%s" "$updated_todo_content"
  return $status
}
