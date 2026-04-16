# fnm 会在进入目录时按 `.node-version` / `.nvmrc` 自动切换 Node 版本。
# recursive 策略允许从当前目录向上查找版本文件，兼容 monorepo。
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"
fi

# 保持 j 这个短命令，兼容之前的使用习惯。
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd j)"
fi

# 插件只提供 widget，这里手动把常见终端的上下键绑定到对应搜索动作。
# 优先使用 terminfo，兼容不同终端发送的真实按键序列；
# 再补一份常见 ANSI 转义，避免 terminfo 缺失时方向键失效。
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
