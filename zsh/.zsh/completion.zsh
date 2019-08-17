zmodload -i zsh/complist
# autoload completion
autoload -U compinit && compinit

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

 # activate approximate completion, but only after regular completion (_complete)
zstyle ':completion:::::' completer _complete _approximate
# limit to 2 errors
zstyle ':completion:*:approximate:*' max-errors 2
# or to have a better heuristic, by allowing one error per 3 character typed
# zstyle ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

# use menu like selection mode.
zstyle ':completion:*:*:*:*:*' menu select
# tab completion not using dir_colors
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# case insensitive (all), partial-word and substring completion
# zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
# case insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# case insensitive and hyphen insensitive
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
