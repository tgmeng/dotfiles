# 仅在需要时启用 zprof，避免日常启动输出性能报告。
# ZSH_PROFILE_ZPROF=1 zsh -i -c exit
if [[ -n ${ZSH_PROFILE_ZPROF:-} ]]; then
  zmodload zsh/zprof
fi

# 非登录交互 shell 不会经过 .zprofile，需要在这里补一次 env 层。
if [[ -z ${ZSH_ENV_LOADED_BY_ZPROFILE:-} ]]; then
  source "$ZDOTDIR/env/main.zsh"
fi

source "$ZDOTDIR/core/main.zsh"
source "$ZDOTDIR/plugins/main.zsh"
source "$ZDOTDIR/completion/main.zsh"
source "$ZDOTDIR/prompt/main.zsh"
source "$ZDOTDIR/local/main.zsh"

if [[ -n ${ZSH_PROFILE_ZPROF:-} ]]; then
  zprof
fi
