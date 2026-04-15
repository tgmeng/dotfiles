# 这是唯一保留在家目录根部的 zsh 入口。
# zsh 总会先读取 ~/.zshenv，因此这里只做一件事：把后续配置切到 XDG 目录。
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
