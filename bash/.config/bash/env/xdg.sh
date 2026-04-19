# 这层定义 XDG 根目录变量，并准备相关目录。

: "${XDG_STATE_HOME:=$HOME/.local/state}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"

export XDG_STATE_HOME
export XDG_DATA_HOME
export XDG_CONFIG_HOME
export XDG_CACHE_HOME

mkdir -p "$XDG_STATE_HOME" "$XDG_DATA_HOME" "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME"

if [ -z "${XDG_RUNTIME_DIR:-}" ]; then
  XDG_RUNTIME_DIR="${TMPDIR:-/tmp}"
  XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR%/}/xdg-runtime-${UID:-$(id -u)}"
fi
export XDG_RUNTIME_DIR

if [ ! -d "$XDG_RUNTIME_DIR" ]; then
  mkdir -p "$XDG_RUNTIME_DIR"
  chmod 700 "$XDG_RUNTIME_DIR" 2>/dev/null
fi

mkdir -p "$XDG_STATE_HOME/bash"
touch "$XDG_STATE_HOME/bash/history"
