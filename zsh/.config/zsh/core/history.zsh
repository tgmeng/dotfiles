# 历史记录
# 参考：https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/history.zsh

# `history` 直接显示带日期的记录，便于排查最近执行过什么。
alias history='fc -il 1'

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

# 追加写入，而不是每次覆盖整个 history 文件。
setopt append_history
# 保存时间戳和耗时，便于回看命令执行时间。
setopt extended_history
# 当 HISTFILE 超出大小时，优先删除重复项。
setopt hist_expire_dups_first
# 历史列表里忽略重复命令。
setopt hist_ignore_dups
# 忽略以空格开头的命令。
setopt hist_ignore_space
# 历史展开后先展示给用户确认，再决定是否执行。
setopt hist_verify
# 命令一输入就增量写入 history。
setopt inc_append_history
# 在同一台机器上的多个 zsh 之间共享 history。
setopt share_history
