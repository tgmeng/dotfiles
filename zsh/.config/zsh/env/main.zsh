export TERM="xterm-256color"
export LANG="en_US.UTF-8"

export PNPM_HOME="$HOME/Library/pnpm"
export GEM_HOME="$HOME/.gem"
export VCPKG_ROOT="$HOME/dev/vcpkg"
export NVM_DIR="$HOME/.nvm"

export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"

export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"

typeset -gU path PATH

path=(
  "$HOME/bin"
  "$HOME/.yarn/bin"
  "$PNPM_HOME"
  $path
)

# 某些工具会把额外环境变量写到这里；存在时再加载。
[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

path=(
  "$HOME/fvm/default/bin"
  "/opt/homebrew/opt/ruby/bin"
  "$GEM_HOME/bin"
  $path
)

export PATH
