# ------------------------------------------------------------------------------
# 后台任务
# ------------------------------------------------------------------------------

typeset -g lf_jobs_symbol="⚙"
typeset -g lf_jobs_color="%{$lf_prompt_colors[jobs]%}"
typeset -g lf_jobs_amount_threshold="${lf_jobs_amount_threshold=1}"

# 只要有后台任务就显示图标；超过阈值时再显示数量。
lf_jobs_get() {
  local jobs_amount

  jobs_amount=$(jobs -d | awk '!/pwd/' | wc -l | tr -d ' ')
  [[ $jobs_amount -gt 0 ]] || return

  if [[ $jobs_amount -le $lf_jobs_amount_threshold ]]; then
    jobs_amount=''
  else
    jobs_amount=":$jobs_amount"
  fi

  print -r -- "${lf_jobs_color}[${lf_jobs_symbol}${jobs_amount}]"
}
