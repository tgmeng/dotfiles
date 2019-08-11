# key-binding
bindkey -e

# [Backspace] - delete backward
bindkey '^?' backward-delete-char
if [[ "${terminfo[kdch1]}" != "" ]]; then
  # [Delete] - delete forward
  bindkey "${terminfo[kdch1]}" delete-char
fi

# when pressing Shift-Tab move through the completion menu backwards.
if [[ "${terminfo[kcbt]}" != "" ]]; then
  bindkey "${terminfo[kcbt]}" reverse-menu-complete
fi

# zsh-users/zsh-history-substring-search
if [[ "${terminfo[kcuu1]}" != "" ]]; then
  bindkey "${terminfo[kcuu1]}" history-substring-search-up
fi
bindkey '^[[A' history-substring-search-up

if [[ "${terminfo[kcuu1]}" != "" ]]; then
  bindkey "${terminfo[kcud1]}" history-substring-search-down
fi
bindkey '^[[B' history-substring-search-down
