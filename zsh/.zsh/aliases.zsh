# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/common-aliases/common-aliases.plugin.zsh

# Safety first
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Colorize output, make ls human readable and classify...
if [[ $(uname) == Darwin ]]; then
  alias dircolors='gdircolors'
  alias ls='gls --color=auto -hF'
fi

alias l='ls -lFh'   #size, show type, human readable
alias la='ls -lAFh' #long list, show almost all, show type, human readable
alias lr='ls -tRFh' #sorted by date, recursive, show type, human readable
alias lt='ls -ltFh' #long list, sorted by date, show type, human readable

# Colorize output and some exclusions
alias grep="grep --color=auto --exclude-dir={.git,.svn,node_modules}"

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'

alias kce='eval `keychain --eval id_rsa`'

alias zshrc='mvim ~/.zshrc'

alias c='code'
alias f='fork'
alias o='open'
alias y='yarn'
alias m='make'
alias t='tig'
alias v='mvim'

# postgres
alias pg-start="pg_ctl -D /usr/local/var/postgres start"
alias pg-stop="pg_ctl -D /usr/local/var/postgres stop"
alias pg-restart="pg_ctl -D /usr/local/var/postgres restart"
