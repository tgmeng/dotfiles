export TERM="xterm-256color"
export LANG="en_US.UTF-8"

export PNPM_HOME="$HOME/Library/pnpm"
export GEM_HOME="$HOME/.gem"
export VCPKG_ROOT="$HOME/dev/vcpkg"

export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"

export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"

# 让 Homebrew 把 PATH / MANPATH / INFOPATH 等基础环境接到当前 shell。
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# `path` 和 `PATH` 在 zsh 中是联动的；`-U` 会自动去重并保留首次出现的位置。
# 这里用数组而不是字符串拼接，便于明确表达命令查找优先级。
typeset -gU path PATH

# 第一段放最通用的用户级命令目录。
# 它们要排在系统 PATH 前面，这样本地安装的脚本能优先被找到。
path=(
  "$HOME/bin"
  "$HOME/.yarn/bin"
  "$PNPM_HOME"
  "$GOPATH/bin"
  "$CARGO_HOME/bin"
  $path
)

# 某些工具会把额外环境变量写到这里；存在时再加载。
[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# 第二段再插入“需要覆盖默认版本”的工具链路径。
# 这样 Ruby / Flutter 等命令会优先命中用户指定版本，而不是系统自带版本。
path=(
  "$FVM_CACHE_PATH/default/bin"
  "/opt/homebrew/opt/ruby/bin"
  "$GEM_HOME/bin"
  $path
)

export PATH
