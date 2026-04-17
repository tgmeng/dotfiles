# 登录 shell 才会执行这里。
# 这层只负责环境变量和 PATH，避免把交互逻辑混进登录态初始化。
source "$ZDOTDIR/env/main.zsh"

# .zshrc 里会根据这个标记决定是否补载 env 层，避免登录 shell 重复初始化。
typeset -g ZSH_ENV_LOADED_BY_ZPROFILE=1
