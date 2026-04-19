# 这层装配 bash 的环境初始化：先补齐 XDG，再接共享环境和 PATH。

if [ -n "${BASH_ENV_MAIN_LOADED:-}" ]; then
  return
fi
export BASH_ENV_MAIN_LOADED=1

. "${XDG_CONFIG_HOME:-$HOME/.config}/bash/env/xdg.sh"
. "$XDG_CONFIG_HOME/bash/env/shared.sh"

# 将目录插到 PATH 最前；若该目录已在 PATH 中（整段匹配）则跳过，避免重复。
_bash_path_prepend() {
  # 用冒号包裹 PATH，便于把「目录」当作 :dir: 片段匹配，而不是子串误伤。
  case ":$PATH:" in
    *":$1:"*) ;;
    # PATH 为空时只赋值为 $1，否则为 $1:$PATH，避免出现开头的多余冒号。
    *) PATH="$1${PATH:+:$PATH}" ;;
  esac
}

_bash_path_prepend "$FVM_CACHE_PATH/default/bin"
_bash_path_prepend "$CARGO_HOME/bin"
_bash_path_prepend "$GOPATH/bin"
_bash_path_prepend "$HOME/bin"
export PATH

if [ -r "${CARGO_HOME}/env" ]; then
  . "${CARGO_HOME}/env"
fi

if [ -r "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
fi

unset -f _bash_path_prepend
