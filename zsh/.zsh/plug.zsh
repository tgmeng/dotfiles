# Plugins

source ~/.zplug/init.zsh

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/history", from:oh-my-zsh
zplug "plugins/autojump", from:oh-my-zsh
zplug "plugins/emoji", from:oh-my-zsh
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "mafredri/zsh-async", from:"github", use:"async.zsh"

zplug load --verbose
