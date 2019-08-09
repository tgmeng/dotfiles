export TERM="xterm-256color"

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.jenv/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/tgmeng/.oh-my-zsh

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="lazyfabric"

# disable marking untracked files under VCS as dirty.
# This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# another custom folder than $ZSH/custom
# ZSH_CUSTOM=/path/to/new-custom-folder

# Plugins
plugins=(git autojump history osx zsh-completions zsh-autosuggestions zsh-syntax-highlighting git-flow-avh emoji)

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
export LANG=en_US.UTF-8

source ~/.zsh/aliases.zsh

[ -f ~/.git-custom-complete ] && source ~/.git-custom-complete

[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(jenv init -)"

autoload -U compinit && compinit

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[[ -f /Users/tgmeng/GitProjects/too-lazy-todo/node_modules/tabtab/.completions/electron-forge.zsh ]] && . /Users/tgmeng/GitProjects/too-lazy-todo/node_modules/tabtab/.completions/electron-forge.zsh
