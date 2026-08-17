add_todo() {
  local file=${1:-}
  [[ -f "$file" ]] || return
  local task
  local id

  if ! task=$(
    yad \
      --entry \
      --title="New Todo" \
      --width=500 \
      --fontname="JetBrainsMonoNerdFont 18" \
      --text-align=center \
      --text="<big><big><b>New Task</b></big></big>"
  ); then
    return
  fi

  [[ -z "$task" ]] && return

  if [[ -s "$file" ]]; then
    id=$(($(tail -n1 "$file" | cut -d'|' -f1) + 1))
  else
    id=1
  fi

  printf '%s|FALSE|<big><big><b>%s</b></big></big>|\n' \
    "$id" "$task" >>"$file"
}
