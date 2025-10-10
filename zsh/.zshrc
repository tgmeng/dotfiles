# Env
export TERM="xterm-256color"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$PATH
export PATH=$PATH:~/.yarn/bin

export PNPM_HOME=~/Library/pnpm
export PATH="$PNPM_HOME:$PATH"

export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules --preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_ALT_C_OPTS="--walker-skip .git,node_modules --preview 'tree -C {}'"

autoload -U colors && colors

# http://zsh.sourceforge.net/Doc/Release/Options.html

# if you type foo, and it isn't a command, and it is a directory in your cdpath, go there
setopt auto_cd
setopt multios

# enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt prompt_subst

# zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1

source ~/.zsh/plug.zsh
source ~/.zsh/key-bindings.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/history.zsh
source ~/.zsh/completion.zsh


source ~/.zsh/lazyfabric-prompt.zsh

[ -f ~/.zsh/secret.zsh ] && source ~/.zsh/secret.zsh

[ -f ~/.git-custom-complete ] && source ~/.git-custom-complete

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(zoxide init zsh --cmd j)"
