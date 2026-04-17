# ------------------------------------------------------------------------------
# 颜色
# ------------------------------------------------------------------------------

typeset -gA lf_prompt_colors
lf_prompt_colors=(
  dir "%F{#89b4fa}"            # 蓝色
  git:branch "%F{#cba6f7}"     # 淡紫
  git:border "%F{#6c7086}"     # overlay0
  git:untracked "%F{#7f849c}"  # overlay1
  git:added "%F{#a6e3a1}"      # 绿色
  git:modified "%F{#f9e2af}"   # 黄色
  git:renamed "%F{#74c7ec}"    # 蓝青
  git:deleted "%F{#f38ba8}"    # 红色
  git:stashed "%F{#6c7086}"    # overlay0
  git:unmerged "%F{#eba0ac}"   # 栗色
  node:border "%F{#6c7086}"    # overlay0
  node:version "%F{#a6e3a1}"   # 绿色
  success "%F{#a6e3a1}"        # 绿色
  error "%F{#f38ba8}"          # 红色
  jobs "%F{#a6adc8}"           # subtext0
)
