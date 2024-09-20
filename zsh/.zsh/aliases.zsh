# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/common-aliases/common-aliases.plugin.zsh

# Safety first
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Colorize output, make ls human readable and classify...
if [[ $(uname) == Darwin ]]; then
  alias dircolors='gdircolors'
  alias ls='eza --color=automatic -F'
fi

alias l='eza -lF'              #size, show type, human readable
alias la='eza -laF'            #long list, show almost all, show type, human readable
alias lr='eza -RF --sort date' #sorted by date, recursive, show type, human readable
alias lt='eza -lF --sort date' #long list, sorted by date, show type, human readable

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
alias mkr='make rebuild'
alias mki='make install'
alias mkwd='make web_dev'
alias rma='rm -rf *'
alias rmf='rm -rf'

alias gbc="git branch | sed -n '/\* /s///p'"
alias gh="git reflog --format='%C(auto)%h %<|(20)%gd %D'"
alias gch="git rev-parse HEAD"

# postgres
alias pg-start="pg_ctl -D /usr/local/var/postgres start"
alias pg-stop="pg_ctl -D /usr/local/var/postgres stop"
alias pg-restart="pg_ctl -D /usr/local/var/postgres restart"

# MacOS
alias pbc="pbcopy"
alias pbp="pbpaste"

alias fq="export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890"

function lk {
  cd "$(walk "$@")"
}
