tmuxp-save() {
  local kill_after_save=0
  local session=""
  local tmuxp_dir="${XDG_CONFIG_HOME:-$HOME/.config}/tmuxp"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -k|--kill)
        kill_after_save=1
        ;;
      -*)
        echo "usage: tmuxp-save [-k|--kill] [session-name]" >&2
        return 2
        ;;
      *)
        if [[ -n "$session" ]]; then
          echo "usage: tmuxp-save [-k|--kill] [session-name]" >&2
          return 2
        fi

        session="$1"
        ;;
    esac
    shift
  done

  if [[ -z "$session" ]]; then
    if [[ -z "${TMUX:-}" ]]; then
      echo "usage: tmuxp-save [-k|--kill] <session-name>" >&2
      return 2
    fi

    session="$(tmux display-message -p '#S')"
  fi

  mkdir -p "$tmuxp_dir"
  tmuxp freeze "$session" -o "$tmuxp_dir/$session.yaml" -y || return

  if [[ "$kill_after_save" -eq 1 ]]; then
    if [[ -n "${TMUX:-}" && "$session" == "$(tmux display-message -p '#S')" ]]; then
      local next_session
      next_session="$(tmux list-sessions -F '#S' | while IFS= read -r candidate_session; do
        if [[ "$candidate_session" != "$session" ]]; then
          printf '%s\n' "$candidate_session"
          break
        fi
      done)"

      if [[ -n "$next_session" ]]; then
        tmux switch-client -t "$next_session" || return
      fi
    fi

    tmux kill-session -t "$session"
  fi
}
