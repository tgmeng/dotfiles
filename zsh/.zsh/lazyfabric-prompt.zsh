# ------------------------------------------------------------------------------
# Color
# ------------------------------------------------------------------------------

typeset -gA lf_prompt_colors
lf_prompt_colors=(
  dir "%F{#89b4fa}"            # blue
  git:branch "%F{#cba6f7}"     # mauve
  git:border "%F{#6c7086}"     # overlay0
  git:untracked "%F{#7f849c}"  # overlay1
  git:added "%F{#a6e3a1}"      # green
  git:modified "%F{#f9e2af}"   # yellow
  git:renamed "%F{#74c7ec}"    # sapphire
  git:deleted "%F{#f38ba8}"    # red
  git:stashed "%F{#6c7086}"    # overlay0
  git:unmerged "%F{#eba0ac}"   # maroon
  node:border "%F{#6c7086}"    # overlay0
  node:version "%F{#a6e3a1}"   # green
  success "%F{#a6e3a1}"        # green
  error "%F{#f38ba8}"          # red
  jobs "%F{#a6adc8}"           # subtext0
)

# ------------------------------------------------------------------------------
# Git
# ------------------------------------------------------------------------------

# Git Prompt
typeset -g lf_git_prompt_prefix="%{$lf_prompt_colors[git:border]%}[%{$reset_color%}"
typeset -g lf_git_prompt_suffix="%{$lf_prompt_colors[git:border]%}]%{$reset_color%}"

lf_git_render_prompt() {
  echo "${lf_git_prompt_prefix}%{$lf_prompt_colors[git:branch]%}$@${lf_git_prompt_suffix}"
}

lf_git_status_async() {
  local ref
  ref=$(command git symbolic-ref HEAD 2>/dev/null) ||
    ref=$(command git rev-parse --short HEAD 2>/dev/null) || return 0

  local git_state
  git_state=$(lf_git_status)
  [[ -n $git_state ]] && git_state=" $git_state"

  typeset -A info 
  info[pwd]=$PWD
  info[data]=$(lf_git_render_prompt "${ref#refs/heads/}${git_state}")

  print -r - ${(@kvq)info}
}

typeset -g lf_git_prompt_loading="%{$lf_prompt_colors[git:border]%}[%{$lf_prompt_colors[git:branch]%}…%{$lf_prompt_colors[git:border]%}]%{$reset_color%}"

# Git status
typeset -g lf_git_status_untracked="%{$lf_prompt_colors[git:untracked]%}?"
typeset -g lf_git_status_added="%{$lf_prompt_colors[git:added]%}+"
typeset -g lf_git_status_modified="%{$lf_prompt_colors[git:modified]%}!"
typeset -g lf_git_status_renamed="%{$lf_prompt_colors[git:renamed]%}»"
typeset -g lf_git_status_deleted="%{$lf_prompt_colors[git:deleted]%}✘"
typeset -g lf_git_status_stashed="%{$lf_prompt_colors[git:stashed]%}$"
typeset -g lf_git_status_unmerged="%{$lf_prompt_colors[git:unmerged]%}="
typeset -g lf_git_status_ahead="⇡"
typeset -g lf_git_status_behind="⇣"
typeset -g lf_git_status_diverged="⇕"

lf_git_status() {
  local INDEX git_status=""

  INDEX=$(command git status --porcelain -b 2>/dev/null)

  # Check for untracked files
  if $(echo "$INDEX" | command grep -E '^\?\? ' &>/dev/null); then
    git_status="$lf_git_status_untracked$git_status"
  fi

  # Check for staged files
  if $(echo "$INDEX" | command grep '^A[ MDAU] ' &>/dev/null); then
    git_status="$lf_git_status_added$git_status"
  elif $(echo "$INDEX" | command grep '^M[ MD] ' &>/dev/null); then
    git_status="$lf_git_status_added$git_status"
  elif $(echo "$INDEX" | command grep '^UA' &>/dev/null); then
    git_status="$lf_git_status_added$git_status"
  fi

  # Check for modified files
  if $(echo "$INDEX" | command grep '^[ MARC]M ' &>/dev/null); then
    git_status="$lf_git_status_modified$git_status"
  fi

  # Check for renamed files
  if $(echo "$INDEX" | command grep '^R[ MD] ' &>/dev/null); then
    git_status="$lf_git_status_renamed$git_status"
  fi

  # Check for deleted files
  if $(echo "$INDEX" | command grep '^[MARCDU ]D ' &>/dev/null); then
    git_status="$lf_git_status_deleted$git_status"
  elif $(echo "$INDEX" | command grep '^D[ UM] ' &>/dev/null); then
    git_status="$lf_git_status_deleted$git_status"
  fi

  # Check for stashes
  if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
    git_status="$lf_git_status_stashed$git_status"
  fi

  # Check for unmerged files
  if $(echo "$INDEX" | command grep '^U[UDA] ' &>/dev/null); then
    git_status="$lf_git_status_unmerged$git_status"
  elif $(echo "$INDEX" | command grep '^AA ' &>/dev/null); then
    git_status="$lf_git_status_unmerged$git_status"
  elif $(echo "$INDEX" | command grep '^DD ' &>/dev/null); then
    git_status="$lf_git_status_unmerged$git_status"
  elif $(echo "$INDEX" | command grep '^[DA]U ' &>/dev/null); then
    git_status="$lf_git_status_unmerged$git_status"
  fi

  # Check whether branch is ahead
  local is_ahead=false
  if $(echo "$INDEX" | command grep '^## [^ ]\+ .*ahead' &>/dev/null); then
    is_ahead=true
  fi

  # Check whether branch is behind
  local is_behind=false
  if $(echo "$INDEX" | command grep '^## [^ ]\+ .*behind' &>/dev/null); then
    is_behind=true
  fi

  # Check wheather branch has diverged
  if [[ "$is_ahead" == true && "$is_behind" == true ]]; then
    git_status="$lf_git_status_diverged$git_status"
  else
    [[ "$is_ahead" == true ]] && git_status="${lf_git_status_ahead}$git_status"
    [[ "$is_behind" == true ]] && git_status="${lf_git_status_behind}$git_status"
  fi

  if [[ -n $git_status ]]; then
    # Status prefixes are colorized
    echo "${git_status}${reset_color}"
  fi
}

# ------------------------------------------------------------------------------
# Background jobs
# ------------------------------------------------------------------------------

typeset -g lf_jobs_symbol="⚙"
typeset -g lf_jobs_color="%{$lf_prompt_colors[jobs]%}"
typeset -g lf_jobs_amount_threshold="${lf_jobs_amount_threshold=1}"

# Show icon if there's a working jobs in the background
lf_jobs_get() {
  local jobs_amount=$(jobs -d | awk '!/pwd/' | wc -l | tr -d " ")

  [[ $jobs_amount -gt 0 ]] || return

  if [[ $jobs_amount -le $lf_jobs_amount_threshold ]]; then
    jobs_amount=''
  else
    jobs_amount=":$jobs_amount"
  fi

  echo "${lf_jobs_color}[${lf_jobs_symbol}${jobs_amount}]"
}

# ------------------------------------------------------------------------------
# Node
# ------------------------------------------------------------------------------

lf_node_render_prompt() {
  echo "%{$lf_prompt_colors[node:border]%}[%{$lf_prompt_colors[node:version]%}node:$@%{$lf_prompt_colors[node:border]%}]%{$reset_color%}"
}

lf_node_get_version() {
  if [[ -f package.json ]]; then
    local version=$(node -v)
    echo $(lf_node_render_prompt "$version")
  fi
}

# ------------------------------------------------------------------------------
# Async
# ------------------------------------------------------------------------------

typeset -g lf_prompt_async_init=0
typeset -g lf_prompt_async_render_flag=0

lf_prompt_async_callback() {
  setopt local_options no_sh_word_split

  local job=$1 code=$2 output=$3 exec_time=$4 next_pending=$6

  local do_render=0

  local -A info
  if [[ -n $output ]]; then
    info=("${(Q@)${(z)output}}")
  fi

  if [[ $info[pwd] && $info[pwd] != $PWD ]]; then
    return
  fi

  case $job in
  \[async])
    # code is 1 for corrupted worker output and 2 for dead worker
    if [[ $code -eq 2 ]]; then
      # worker died unexpectedly
      lf_prompt_async_init=0
    fi
    ;;
  lf_git_status_async)
    lf_prompt_git_status="$info[data]"
    do_render=1
    ;;
  esac

	if (( next_pending )); then
		(( do_render )) && lf_prompt_async_render_flag=1
		return
	fi

	[[ ${lf_prompt_async_render_flag} = 1 || ${do_render} = 1 ]] && lf_prompt_render
	lf_prompt_async_render_flag=0
}

lf_prompt_async_tasks() {
  # init the async worker
  ((!${lf_prompt_async_init})) && {
    async_start_worker "lf_prompt" -n
    async_register_callback "lf_prompt" lf_prompt_async_callback
    lf_prompt_async_init=1
  }

  # update the current working directory of the async worker
  async_worker_eval "lf_prompt" builtin cd -q $PWD

  lf_prompt_git_status=""
  if git rev-parse --git-dir &> /dev/null
  then
    lf_prompt_git_status="$lf_git_prompt_loading"
    async_job "lf_prompt" lf_git_status_async
  fi
}

# ------------------------------------------------------------------------------
# Prompt
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
  local -a prompt_statuses=(
    %{$lf_prompt_colors[dir]%}%~%{$reset_color%}
    $lf_prompt_git_status
    $(lf_node_get_version)
    $(lf_jobs_get)
  )

  local prompt_newline=$'\n%{\r%}'

  local -a prompt_parts=(
    $prompt_newline
    ${(j. .)prompt_statuses}
    $prompt_newline
    $lf_prompt_symbol 
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
