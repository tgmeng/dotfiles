# nvm 只在这里做一次权威初始化，避免入口文件里重复 source。
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
fi

# 保留 bash_completion 是为了复用 nvm 自带补全脚本。
if [[ -s "$NVM_DIR/bash_completion" ]]; then
  source "$NVM_DIR/bash_completion"
fi

# 保持 j 这个短命令，兼容之前的使用习惯。
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd j)"
fi

# 插件只提供 widget，这里把常见终端的上下键绑定到对应搜索动作。
if (( ${+widgets[history-substring-search-up]} )); then
  if [[ -n ${terminfo[kcuu1]:-} ]]; then
    bindkey "${terminfo[kcuu1]}" history-substring-search-up
  fi
  bindkey '^[[A' history-substring-search-up
fi

if (( ${+widgets[history-substring-search-down]} )); then
  if [[ -n ${terminfo[kcud1]:-} ]]; then
    bindkey "${terminfo[kcud1]}" history-substring-search-down
  fi
  bindkey '^[[B' history-substring-search-down
fi
