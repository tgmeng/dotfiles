# ------------------------------------------------------------------------------
# Git 状态
# ------------------------------------------------------------------------------

# Git 提示符边框和加载中的占位符。
typeset -g lf_git_prompt_prefix="%{$lf_prompt_colors[git:border]%}[%{$reset_color%}"
typeset -g lf_git_prompt_suffix="%{$lf_prompt_colors[git:border]%}]%{$reset_color%}"
typeset -g lf_git_prompt_loading="%{$lf_prompt_colors[git:border]%}[%{$lf_prompt_colors[git:branch]%}…%{$lf_prompt_colors[git:border]%}]%{$reset_color%}"

# Git 状态符号。
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

lf_git_render_prompt() {
  print -r -- "${lf_git_prompt_prefix}%{$lf_prompt_colors[git:branch]%}$1${lf_git_prompt_suffix}"
}

lf_git_status() {
  local index
  local git_status=""
  local is_ahead=false
  local is_behind=false

  index=$(command git status --porcelain -b 2>/dev/null)

  # 未跟踪文件
  if command grep -qE '^\?\? ' <<<"$index"; then
    git_status="$lf_git_status_untracked$git_status"
  fi

  # 已暂存文件
  if command grep -qE '^A[ MDAU] ' <<<"$index" ||
    command grep -qE '^M[ MD] ' <<<"$index" ||
    command grep -qE '^UA' <<<"$index"; then
    git_status="$lf_git_status_added$git_status"
  fi

  # 已修改但未暂存的文件
  if command grep -qE '^[ MARC]M ' <<<"$index"; then
    git_status="$lf_git_status_modified$git_status"
  fi

  # 重命名文件
  if command grep -qE '^R[ MD] ' <<<"$index"; then
    git_status="$lf_git_status_renamed$git_status"
  fi

  # 删除文件
  if command grep -qE '^[MARCDU ]D ' <<<"$index" ||
    command grep -qE '^D[ UM] ' <<<"$index"; then
    git_status="$lf_git_status_deleted$git_status"
  fi

  # stash 标记
  if command git rev-parse --verify refs/stash >/dev/null 2>&1; then
    git_status="$lf_git_status_stashed$git_status"
  fi

  # 冲突文件
  if command grep -qE '^U[UDA] ' <<<"$index" ||
    command grep -qE '^AA ' <<<"$index" ||
    command grep -qE '^DD ' <<<"$index" ||
    command grep -qE '^[DA]U ' <<<"$index"; then
    git_status="$lf_git_status_unmerged$git_status"
  fi

  # 分支领先远端
  if command grep -qE '^## [^ ]+ .*ahead' <<<"$index"; then
    is_ahead=true
  fi

  # 分支落后远端
  if command grep -qE '^## [^ ]+ .*behind' <<<"$index"; then
    is_behind=true
  fi

  # 同时领先且落后表示分叉。
  if [[ "$is_ahead" == true && "$is_behind" == true ]]; then
    git_status="$lf_git_status_diverged$git_status"
  else
    [[ "$is_ahead" == true ]] && git_status="${lf_git_status_ahead}$git_status"
    [[ "$is_behind" == true ]] && git_status="${lf_git_status_behind}$git_status"
  fi

  if [[ -n $git_status ]]; then
    # 状态前缀本身已经带颜色，这里只补回 reset。
    print -r -- "${git_status}${reset_color}"
  fi
}

lf_git_collect_prompt() {
  local ref="$1"
  local git_state

  git_state=$(lf_git_status)
  [[ -n $git_state ]] && git_state=":$git_state"

  lf_git_render_prompt "${ref#refs/heads/}${git_state}"
}

lf_prompt_set_git_status_sync() {
  local ref

  ref=$(command git symbolic-ref HEAD 2>/dev/null) ||
    ref=$(command git rev-parse --short HEAD 2>/dev/null) || {
      lf_prompt_git_status=""
      return 0
    }

  lf_prompt_git_status=$(lf_git_collect_prompt "$ref")
}

lf_git_status_async() {
  local ref

  ref=$(command git symbolic-ref HEAD 2>/dev/null) ||
    ref=$(command git rev-parse --short HEAD 2>/dev/null) || return 0

  typeset -A info
  info[pwd]=$PWD
  info[data]=$(lf_git_collect_prompt "$ref")

  print -r - ${(@kvq)info}
}
