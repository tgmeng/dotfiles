# 这层定义 XDG 根目录变量，并准备相关目录。

export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

mkdir -p "$XDG_STATE_HOME" "$XDG_DATA_HOME" "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME"

if [[ -z "${XDG_RUNTIME_DIR:-}" ]]; then
  export XDG_RUNTIME_DIR="${${TMPDIR:-/tmp}%/}/xdg-runtime-$UID"
fi

if [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
  mkdir -p "$XDG_RUNTIME_DIR"
  chmod 700 "$XDG_RUNTIME_DIR" 2>/dev/null
fi

mkdir -p "$XDG_STATE_HOME/zsh"
touch "$XDG_STATE_HOME/zsh/history"
