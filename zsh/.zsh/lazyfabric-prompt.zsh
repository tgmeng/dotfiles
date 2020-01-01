# ------------------------------------------------------------------------------
# Color
# ------------------------------------------------------------------------------

typeset -gA lf_prompt_colors
lf_prompt_colors=(
  dir $fg[cyan]
  symbol $fg[blue]
  git:icon $fg[blue]
  git:border $fg[blue]
  git:untracked $fg[white]
  git:added $fg[green]
  git:modified $fg[blue]
  git:renamed $fg[blue]
  git:deleted $fg[red]
  git:stashed $fg[yellow]
  git:unmerged $fg[red]
  jobs $fg[white]
)

# ------------------------------------------------------------------------------
# Git
# ------------------------------------------------------------------------------

# Git Prompt
typeset -g lf_git_prompt_icon=$(echo -e '\uf418')
typeset -g lf_git_prompt_prefix="%{$lf_prompt_colors[git:border]%}[%{$lf_prompt_colors[git:icon]%}%{$lf_git_prompt_icon%}%{$reset_color%} "
typeset -g lf_git_prompt_suffix="%{$lf_prompt_colors[git:border]%}]%{$reset_color%}"
typeset -g lf_git_prompt_loading="${lf_git_prompt_prefix}⏳ loading${lf_git_prompt_suffix}"

lf_git_status_async() {
  local ref
  ref=$(command git symbolic-ref HEAD 2>/dev/null) ||
    ref=$(command git rev-parse --short HEAD 2>/dev/null) || return 0

  typeset -A info 
  info[pwd]=$PWD
  info[data]="${lf_git_prompt_prefix}${ref#refs/heads/}$(lf_git_status)${lf_git_prompt_suffix}"

  print -r - ${(@kvq)info}
}

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

typeset -g lf_jobs_symbol="$emoji[clock_face_ten_oclock]"
typeset -g lf_jobs_color="%{$lf_prompt_colors[jobs]%}"
typeset -g lf_jobs_amount_threshold="${lf_jobs_amount_threshold=1}"

# Show icon if there's a working jobs in the background
lf_jobs() {
  local jobs_amount=$(jobs -d | awk '!/pwd/' | wc -l | tr -d " ")

  [[ $jobs_amount -gt 0 ]] || return

  if [[ $jobs_amount -le $lf_jobs_amount_threshold ]]; then
    jobs_amount=''
  else
    jobs_amount=" $jobs_amount"
  fi

  echo "${lf_jobs_color}[${lf_jobs_symbol}${jobs_amount}]"
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
typeset -g lf_prompt_ret_status="%(?:$emoji[smiling_face_with_sunglasses]:$emoji[dizzy_face])"
typeset -g lf_prompt_symbol="%{$lf_prompt_colors[symbol]%}❯%{$reset_color%}"
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
    $lf_prompt_ret_status
    %{$lf_prompt_colors[dir]%}%~%{$reset_color%}
    $lf_prompt_git_status
    `lf_jobs`
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
