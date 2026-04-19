# 这层依赖 XDG 根目录变量，负责共享环境变量。

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export PSQL_HISTORY="${PSQL_HISTORY:-$XDG_STATE_HOME/psql_history}"
export LESSHISTFILE="${LESSHISTFILE:-$XDG_STATE_HOME/lesshst}"
export GNUPGHOME="${GNUPGHOME:-$XDG_DATA_HOME/gnupg}"
export GOPATH="${GOPATH:-$XDG_DATA_HOME/go}"
export NODE_REPL_HISTORY="${NODE_REPL_HISTORY:-$XDG_STATE_HOME/node_repl_history}"
export SQLITE_HISTORY="${SQLITE_HISTORY:-$XDG_STATE_HOME/sqlite_history}"
export PYTHON_HISTORY="${PYTHON_HISTORY:-$XDG_STATE_HOME/python_history}"
export WAKATIME_HOME="${WAKATIME_HOME:-$XDG_CONFIG_HOME/wakatime}"
export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"
export ZPLUG_HOME="${ZPLUG_HOME:-$XDG_DATA_HOME/zplug}"
export CP_HOME_DIR="${CP_HOME_DIR:-$XDG_DATA_HOME/cocoapods}"
export GRADLE_USER_HOME="${GRADLE_USER_HOME:-$XDG_DATA_HOME/gradle}"
export ANDROID_USER_HOME="${ANDROID_USER_HOME:-$XDG_DATA_HOME/android}"
export ANDROID_AVD_HOME="${ANDROID_AVD_HOME:-$ANDROID_USER_HOME/avd}"
export FVM_CACHE_PATH="${FVM_CACHE_PATH:-$XDG_CACHE_HOME/fvm}"
export TLDR_CACHE_DIR="${TLDR_CACHE_DIR:-$XDG_CACHE_HOME/tldr}"
export HAMMERSPOON_CONFIG_FILE="$XDG_CONFIG_HOME/hammerspoon/init.lua"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME/npm/config/npm-init.js"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR/npm"
export NPM_CONFIG_DEVDIR="$XDG_DATA_HOME/node-gyp"

if (( $+commands[defaults] )); then
  defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HAMMERSPOON_CONFIG_FILE" >/dev/null 2>&1
fi
