# Env
export TERM="xterm-256color"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# If you come from bash you might have to change your $PATH.

export PATH=$HOME/bin:$PATH
export PATH=$PATH:~/.yarn/bin

# PNPM
export PNPM_HOME=~/Library/pnpm
export PATH="$PNPM_HOME:$PATH"

. "$HOME/.local/bin/env"

# FZF
export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules --preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_ALT_C_OPTS="--walker-skip .git,node_modules --preview 'tree -C {}'"

# Flutter
export PATH=$HOME/fvm/default/bin:$PATH
export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"

# Ruby
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"
export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

# VCPKG
export VCPKG_ROOT="$HOME/dev/vcpkg"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/fkj/.dart-cli-completion/zsh-config.zsh ]] && . /Users/fkj/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
