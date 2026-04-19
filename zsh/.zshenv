# 这是唯一保留在家目录根部的 zsh 入口。
# 它只负责定位 env 层，并把最早期环境初始化交给 XDG 目录中的文件。
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
source "$XDG_CONFIG_HOME/zsh/env/xdg.zsh"
source "$XDG_CONFIG_HOME/zsh/env/shared.zsh"
