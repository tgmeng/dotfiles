# 基础别名参考常用别名集合，再叠加个人习惯。
# 参考：https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/common-aliases/common-aliases.plugin.zsh

# 安全优先
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# 彩色输出，并让 `ls` 显示类型后缀。
if [[ $(uname) == Darwin ]]; then
  alias dircolors='gdircolors'
  alias ls='eza --color=automatic -F'
fi

alias l='eza -lF'              # 显示大小、类型，并使用人类可读格式
alias la='eza -laF'            # 长列表，包含隐藏文件，显示类型和人类可读大小
alias lr='eza -RF --sort date' # 递归列出并按时间排序
alias lt='eza -lF --sort date' # 长列表并按时间排序

# 彩色 grep，并排除常见的大目录。
alias grep="grep --color=auto --exclude-dir={.git,.svn,node_modules}"

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'

alias kce='eval `keychain --eval id_rsa`'

alias c='cursor'
alias cc='cursor .'
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

# 这两个别名有风险，但为了兼容既有习惯先保留。
alias rma='rm -rf *'
alias rmf='rm -rf'

alias gbc="git branch | sed -n '/\\* /s///p'"
alias gh="git reflog --format='%C(auto)%h %<|(20)%gd %D'"
alias gch="git rev-parse HEAD"

# PostgreSQL
alias pg-start="pg_ctl -D /usr/local/var/postgres start"
alias pg-stop="pg_ctl -D /usr/local/var/postgres stop"
alias pg-restart="pg_ctl -D /usr/local/var/postgres restart"

# macOS 剪贴板
alias pbc='pbcopy'
alias pbp='pbpaste'

alias fq="export https_proxy=http://127.0.0.1:6152;export http_proxy=http://127.0.0.1:6152;export all_proxy=socks5://127.0.0.1:6153"

lk() {
  cd "$(walk "$@")"
}

alias sw='swift'
