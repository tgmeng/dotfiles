# 非登录交互 shell 不会经过 .zprofile，需要在这里补一次 env 层。
if [[ -z ${ZSH_ENV_LOADED_BY_ZPROFILE:-} ]]; then
  source "$ZDOTDIR/env/main.zsh"
fi

source "$ZDOTDIR/core/main.zsh"
source "$ZDOTDIR/plugins/main.zsh"
source "$ZDOTDIR/plugins/nvm-auto.zsh"
source "$ZDOTDIR/completion/main.zsh"
source "$ZDOTDIR/prompt/main.zsh"
source "$ZDOTDIR/local/main.zsh"
