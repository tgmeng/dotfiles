# 键位绑定
bindkey -v

my-backward-delete-word() {
  local WORDCHARS=''
  zle backward-delete-word
}
zle -N my-backward-delete-word

# Ctrl-W 按“路径片段 / 单词”删除，而不是把 /.- 这类字符也吞掉。
bindkey '^W' my-backward-delete-word

# Backspace 向后删除一个字符。
bindkey '^?' backward-delete-char

if [[ -n ${terminfo[kdch1]:-} ]]; then
  # Delete 向前删除一个字符。
  bindkey "${terminfo[kdch1]}" delete-char
fi

if [[ -n ${terminfo[kcbt]:-} ]]; then
  # Shift-Tab 在支持的终端里反向切补全候选。
  bindkey "${terminfo[kcbt]}" reverse-menu-complete
fi
