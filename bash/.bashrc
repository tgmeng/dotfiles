# 非登录交互 shell 不会经过 .bash_profile，所以也要在入口补一次 env 层。
. "${XDG_CONFIG_HOME:-$HOME/.config}/bash/env/main.sh"

# 后续会加载 prompt、别名、补全等交互专属逻辑；非交互会话不应执行这些，以免拖慢脚本或让子进程继承意外行为。
# $- 为当前 shell 的选项标志串，含字母 i 时表示 interactive。
case $- in
  *i*) ;;
  *) return ;;
esac

. "$XDG_CONFIG_HOME/bash/core/main.sh"
