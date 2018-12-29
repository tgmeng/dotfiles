# Powered By https://github.com/denysdovhan/spaceship-prompt

# ------------------------------------------------------------------------------
# Icon
# ------------------------------------------------------------------------------

local icon_nl=$emoji[rightwards_arrow_with_hook]
local icon_node=$(echo -e '\uf898')
local icon_branch=$(echo -e '\uf418')


# ------------------------------------------------------------------------------
# Git
# ------------------------------------------------------------------------------

# Git Prompt
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}[%{$icon_branch%}%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}"

function lf_git_prompt_info() {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref#refs/heads/}$(lf_git_status)${ZSH_THEME_GIT_PROMPT_SUFFIX}"
  fi
}

# Git status
LF_GIT_STATUS_SHOW="${LF_GIT_STATUS_SHOW=true}"
LF_GIT_STATUS_PREFIX="${LF_GIT_STATUS_PREFIX=" "}"
LF_GIT_STATUS_SUFFIX="${LF_GIT_STATUS_SUFFIX="$reset_color"}"
LF_GIT_STATUS_UNTRACKED="${LF_GIT_STATUS_UNTRACKED="%{$fg[white]%}?"}"
LF_GIT_STATUS_ADDED="${LF_GIT_STATUS_ADDED="%{$fg[green]%}+"}"
LF_GIT_STATUS_MODIFIED="${LF_GIT_STATUS_MODIFIED="%{$fg[blue]%}!"}"
LF_GIT_STATUS_RENAMED="${LF_GIT_STATUS_RENAMED="%{$fg[blue]»"}"
LF_GIT_STATUS_DELETED="${LF_GIT_STATUS_DELETED="%{$fg[red]%}✘"}"
LF_GIT_STATUS_STASHED="${LF_GIT_STATUS_STASHED="%{$fg[yellow]%}$"}"
LF_GIT_STATUS_UNMERGED="${LF_GIT_STATUS_UNMERGED="%{$fg[red]%}="}"
LF_GIT_STATUS_AHEAD="${LF_GIT_STATUS_AHEAD="⇡"}"
LF_GIT_STATUS_BEHIND="${LF_GIT_STATUS_BEHIND="⇣"}"
LF_GIT_STATUS_DIVERGED="${LF_GIT_STATUS_DIVERGED="⇕"}"

function lf_git_status() {
  local INDEX git_status=""

  INDEX=$(command git status --porcelain -b 2> /dev/null)

  # Check for untracked files
  if $(echo "$INDEX" | command grep -E '^\?\? ' &> /dev/null); then
    git_status="$LF_GIT_STATUS_UNTRACKED$git_status"
  fi

  # Check for staged files
  if $(echo "$INDEX" | command grep '^A[ MDAU] ' &> /dev/null); then
    git_status="$LF_GIT_STATUS_ADDED$git_status"
  elif $(echo "$INDEX" | command grep '^M[ MD] ' &> /dev/null); then
    git_status="$LF_GIT_STATUS_ADDED$git_status"
  elif $(echo "$INDEX" | command grep '^UA' &> /dev/null); then
    git_status="$LF_GIT_STATUS_ADDED$git_status"
  fi

  # Check for modified files
  if $(echo "$INDEX" | command grep '^[ MARC]M ' &> /dev/null); then
    git_status="$LF_GIT_STATUS_MODIFIED$git_status"
  fi

  # Check for renamed files
  if $(echo "$INDEX" | command grep '^R[ MD] ' &> /dev/null); then
    git_status="$LF_GIT_STATUS_RENAMED$git_status"
  fi

  # Check for deleted files
  if $(echo "$INDEX" | command grep '^[MARCDU ]D ' &> /dev/null); then
    git_status="$LF_GIT_STATUS_DELETED$git_status"
  elif $(echo "$INDEX" | command grep '^D[ UM] ' &> /dev/null); then
    git_status="$LF_GIT_STATUS_DELETED$git_status"
  fi

  # Check for stashes
  if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
    git_status="$LF_GIT_STATUS_STASHED$git_status"
  fi

  # Check for unmerged files
  if $(echo "$INDEX" | command grep '^U[UDA] ' &> /dev/null); then
    git_status="$LF_GIT_STATUS_UNMERGED$git_status"
  elif $(echo "$INDEX" | command grep '^AA ' &> /dev/null); then
    git_status="$LF_GIT_STATUS_UNMERGED$git_status"
  elif $(echo "$INDEX" | command grep '^DD ' &> /dev/null); then
    git_status="$LF_GIT_STATUS_UNMERGED$git_status"
  elif $(echo "$INDEX" | command grep '^[DA]U ' &> /dev/null); then
    git_status="$LF_GIT_STATUS_UNMERGED$git_status"
  fi

  # Check whether branch is ahead
  local is_ahead=false
  if $(echo "$INDEX" | command grep '^## [^ ]\+ .*ahead' &> /dev/null); then
    is_ahead=true
  fi

  # Check whether branch is behind
  local is_behind=false
  if $(echo "$INDEX" | command grep '^## [^ ]\+ .*behind' &> /dev/null); then
    is_behind=true
  fi

  # Check wheather branch has diverged
  if [[ "$is_ahead" == true && "$is_behind" == true ]]; then
    git_status="$LF_GIT_STATUS_DIVERGED$git_status"
  else
    [[ "$is_ahead" == true ]] && git_status="${LF_GIT_STATUS_AHEAD}$git_status"
    [[ "$is_behind" == true ]] && git_status="${LF_GIT_STATUS_BEHIND}$git_status"
  fi

  if [[ -n $git_status ]]; then
    # Status prefixes are colorized
    echo "${LF_GIT_STATUS_PREFIX}${git_status}${LF_GIT_STATUS_SUFFIX}"
  fi
}

# ------------------------------------------------------------------------------
# Background jobs
# ------------------------------------------------------------------------------

LF_JOBS_SHOW="${LF_JOBS_SHOW=true}"
LF_JOBS_PREFIX="${LF_JOBS_PREFIX=""}"
LF_JOBS_SUFFIX="${LF_JOBS_SUFFIX=" "}"
LF_JOBS_SYMBOL="${LF_JOBS_SYMBOL="✦"}"
LF_JOBS_COLOR="${LF_JOBS_COLOR="%{$fg[green]%}"}"
LF_JOBS_AMOUNT_PREFIX="${LF_JOBS_AMOUNT_PREFIX=""}"
LF_JOBS_AMOUNT_SUFFIX="${LF_JOBS_AMOUNT_SUFFIX=""}"
LF_JOBS_AMOUNT_THRESHOLD="${LF_JOBS_AMOUNT_THRESHOLD=1}"

# Show icon if there's a working jobs in the background
lf_jobs() {
  [[ $LF_JOBS_SHOW == false ]] && return

  local jobs_amount=$( jobs -d | awk '!/pwd/' | wc -l | tr -d " ")

  [[ $jobs_amount -gt 0 ]] || return

  if [[ $jobs_amount -le $LF_JOBS_AMOUNT_THRESHOLD ]]; then
    jobs_amount=''
    LF_JOBS_AMOUNT_PREFIX=''
    LF_JOBS_AMOUNT_SUFFIX=''
  fi

  echo "$LF_JOBS_COLOR" \
    "$LF_JOBS_PREFIX" \
    "${LF_JOBS_SYMBOL}${LF_JOBS_AMOUNT_PREFIX}${jobs_amount}${LF_JOBS_AMOUNT_SUFFIX}" \
    "$LF_JOBS_SUFFIX"
}

# ------------------------------------------------------------------------------
# Node
# ------------------------------------------------------------------------------
function lf_check_node_version () {
    if [[ -f package.json ]] then;
        local version=$(node --version)
        echo "%{$fg[white]%}[%{$fg[green]%}${icon_node} ${version}%{$fg[white]%}]%{$reset_color%}"
    fi
}

# ------------------------------------------------------------------------------
# Prompt
# ------------------------------------------------------------------------------

local ret_status="%(?:$emoji[smiling_face_with_sunglasses]:$emoji[dizzy_face])"

PROMPT='
$ret_status \
%{$fg[cyan]%}%~%{$reset_color%} \
$(lf_git_prompt_info) \
$(lf_check_node_version) \
$(lf_jobs)
$icon_nl '

