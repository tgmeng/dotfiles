# Env
export TERM="xterm-256color"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$PATH

autoload -U colors && colors

# http://zsh.sourceforge.net/Doc/Release/Options.html

# if you type foo, and it isn't a command, and it is a directory in your cdpath, go there
setopt auto_cd
setopt multios

# enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt prompt_subst

# zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

source ~/.zsh/plug.zsh
source ~/.zsh/key-bindings.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/history.zsh
source ~/.zsh/completion.zsh

source ~/.zsh/lazyfabric-prompt.zsh

[ -f ~/.git-custom-complete ] && source ~/.git-custom-complete

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

