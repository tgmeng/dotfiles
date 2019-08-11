# History
# https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/history.zsh

# history command output format: "yyyy-mm-dd"
alias history='fc -il 1'

HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=10000

# append instead of replacing history file.
setopt append_history
# save commands with timestamp and duration.
setopt extended_history
# delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_expire_dups_first
# ignore duplicated commands history list
setopt hist_ignore_dups
# ignore commands that start with space
setopt hist_ignore_space
# show command with history expansion to user before running it
setopt hist_verify
# add history lines incrementally (as soon as they are entered).
setopt inc_append_history
# share history with your zshells on the same host.
setopt share_history
