# ------------------------------------------------------------------------------
# 主提示符
# ------------------------------------------------------------------------------

typeset -g lf_prompt_last=""
typeset -g lf_prompt_symbol="%(?:%{$lf_prompt_colors[success]%}❯%{$reset_color%}:%{$lf_prompt_colors[error]%}❯%{$reset_color%})"
typeset -g lf_prompt_git_status=""

lf_prompt_precmd() {
  lf_prompt_async_tasks
  lf_prompt_render
}

lf_prompt_reset() {
  zle && zle .reset-prompt
}

lf_prompt_render() {
  local prompt_newline=$'\n%{\r%}'
  local -a prompt_statuses=(
    "%{$lf_prompt_colors[dir]%}%~%{$reset_color%}"
    "$lf_prompt_git_status"
    "$(lf_node_get_version)"
    "$(lf_jobs_get)"
  )
  local -a prompt_parts=(
    "$prompt_newline"
    "${(j. .)prompt_statuses}"
    "$prompt_newline"
    "$lf_prompt_symbol"
    ' '
  )

  PROMPT=${(j..)prompt_parts}

  local expanded_prompt="${(S%%)PROMPT}"
  if [[ $lf_prompt_last != $expanded_prompt ]]; then
    lf_prompt_reset
  fi

  lf_prompt_last=$expanded_prompt
}

lf_prompt_init() {
  zmodload zsh/zle
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd lf_prompt_precmd
}

lf_prompt_init
