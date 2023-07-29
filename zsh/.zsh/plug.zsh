# Plugins

source ~/.zplug/init.zsh

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/history", from:oh-my-zsh
zplug "plugins/asdf", from:oh-my-zsh
zplug "plugins/emoji", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "softmoth/zsh-vim-mode", from:"github"
zplug "mafredri/zsh-async", from:"github", use:"async.zsh"
zplug "tgmeng/zsh-auto-nvm-use", from:"github", use:"zsh-auto-nvm-use.zsh"

zplug load
