# ------------------------------------------------------------------------------
# 异步
# ------------------------------------------------------------------------------

typeset -g lf_prompt_async_init=0
typeset -g lf_prompt_async_render_flag=0

lf_prompt_async_callback() {
  setopt local_options no_sh_word_split

  local job=$1
  local code=$2
  local output=$3
  local next_pending=$6
  local do_render=0

  local -A info
  if [[ -n $output ]]; then
    info=("${(Q@)${(z)output}}")
  fi

  if [[ -n ${info[pwd]:-} && ${info[pwd]} != $PWD ]]; then
    return
  fi

  case $job in
    \[async])
      # code 为 2 表示 worker 已死亡，需要在下次重新初始化。
      if [[ $code -eq 2 ]]; then
        lf_prompt_async_init=0
      fi
      ;;
    lf_git_status_async)
      lf_prompt_git_status="${info[data]}"
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

lf_prompt_async_available() {
  (( ${+functions[async_start_worker]} )) &&
    (( ${+functions[async_register_callback]} )) &&
    (( ${+functions[async_worker_eval]} )) &&
    (( ${+functions[async_job]} ))
}

lf_prompt_async_tasks() {
  if ! lf_prompt_async_available; then
    if command git rev-parse --git-dir >/dev/null 2>&1; then
      lf_prompt_set_git_status_sync
    else
      lf_prompt_git_status=""
    fi
    return
  fi

  if (( ! lf_prompt_async_init )); then
    async_start_worker "lf_prompt" -n
    async_register_callback "lf_prompt" lf_prompt_async_callback
    lf_prompt_async_init=1
  fi

  # 把当前目录同步给后台 worker，确保 git 查询发生在正确目录。
  async_worker_eval "lf_prompt" builtin cd -q "$PWD"

  lf_prompt_git_status=""
  if command git rev-parse --git-dir >/dev/null 2>&1; then
    lf_prompt_git_status="$lf_git_prompt_loading"
    async_job "lf_prompt" lf_git_status_async
  fi
}
