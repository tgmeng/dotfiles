# unset to not insert the first match immediately.
unsetopt menu_complete
# unset to disable output flow control via start/stop characters (usually assigned to ^S/Q).
unsetopt flow_control

# use menu completion by pressing the tab key repeatedly.
setopt auto_menu
# do completion from both ends of the word.
setopt complete_in_word
# when full completion is inserted, the cursor is moved to the end of the word.
setopt always_to_end

# use menu like selection mode.
zstyle ':completion:*:*:*:*:*' menu select

zmodload -i zsh/complist

# autoload completion
autoload -U compinit && compinit
