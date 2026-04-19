# 登录 shell 入口只负责串起 env 层和交互层。
. "${XDG_CONFIG_HOME:-$HOME/.config}/bash/env/main.sh"

export BASH_ENV_LOADED_BY_PROFILE=1

[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
