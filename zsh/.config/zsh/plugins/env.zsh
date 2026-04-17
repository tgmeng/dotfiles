# 这些变量必须在插件加载前就准备好。
export ZSH_AUTOSUGGEST_USE_ASYNC=1

# zsh-vi-mode 初始化完成后会执行这里追加的命令。
# 把 fzf 集成放在这里，避免它抢在 vi mode 前面改写按键绑定。
zvm_after_init_commands+=('command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)')

export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules --preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_ALT_C_OPTS="--walker-skip .git,node_modules --preview 'tree -C {}'"
