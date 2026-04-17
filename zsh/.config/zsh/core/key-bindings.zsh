my-backward-delete-word() {
  local WORDCHARS=''
  zle backward-delete-word
}

# zvm 初始化后注册键位，避免与插件初始化时序冲突。
init_key_bindings() {
  zle -N my-backward-delete-word

  # Ctrl-W 按“路径片段 / 单词”删除，而不是把 /.- 这类字符也吞掉。
  bindkey '^W' my-backward-delete-word

  # Ctrl-D：与 Emacs 键表一致，删光标下字符；在行尾则列出补全（delete-char-or-list）。
  bindkey -M viins '^D' delete-char-or-list

  local ShiftTabKey="${terminfo[kcbt]:-}"
  if [[ -n ${ShiftTabKey} ]]; then
    # Shift-Tab 在支持的终端里反向切补全候选。
    bindkey "${ShiftTabKey}" reverse-menu-complete
  fi
}

zvm_after_init_commands+=(init_key_bindings)
