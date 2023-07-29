# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/common-aliases/common-aliases.plugin.zsh

# Safety first
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Colorize output, make ls human readable and classify...
if [[ $(uname) == Darwin ]]; then
  alias dircolors='gdircolors'
  alias ls='exa --color=automatic -F'
fi

alias l='exa -lF'              #size, show type, human readable
alias la='exa -laF'            #long list, show almost all, show type, human readable
alias lr='exa -RF --sort date' #sorted by date, recursive, show type, human readable
alias lt='exa -lF --sort date' #long list, sorted by date, show type, human readable

# Colorize output and some exclusions
alias grep="grep --color=auto --exclude-dir={.git,.svn,node_modules}"

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'

alias kce='eval `keychain --eval id_rsa`'

alias c='code'
alias cc='code .'
alias f='fork'
alias o='open'
alias oo='open .'
alias y='yarn'
alias mk='make'
alias t='tig'
alias v='mvim'
alias p='pnpm'
alias px='pnpx'

alias mkd='make dev'
alias mke='make electron'

alias gbc="git branch | sed -n '/\* /s///p'"
alias gref="git reflog"

# postgres
alias pg-start="pg_ctl -D /usr/local/var/postgres start"
alias pg-stop="pg_ctl -D /usr/local/var/postgres stop"
alias pg-restart="pg_ctl -D /usr/local/var/postgres restart"

# MacOS
alias pbc="pbcopy"
alias pbp="pbpaste"
