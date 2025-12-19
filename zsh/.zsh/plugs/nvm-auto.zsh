# NVM Auto - 自动查找并使用 .nvmrc 文件
# 从当前目录向上查找 .nvmrc 文件，找到后自动执行 nvm use

# 查找 .nvmrc 文件的函数
_nvm_auto_find_nvmrc() {
  local dir="$PWD"
  local nvmrc_path

  # 从当前目录一直向上查找，直到找到 .nvmrc 或到达根目录
  while [[ "$dir" != "/" ]]; do
    nvmrc_path="$dir/.nvmrc"
    if [[ -f "$nvmrc_path" ]]; then
      echo "$nvmrc_path"
      return 0
    fi
    dir=$(dirname "$dir")
  done

  return 1
}

# 自动使用 nvm 版本的函数
_nvm_auto_use() {
  local nvmrc_path
  local nvmrc_version
  local current_version

  # 检查 nvm 是否已加载
  if ! command -v nvm &> /dev/null; then
    return
  fi

  # 查找 .nvmrc 文件
  nvmrc_path=$(_nvm_auto_find_nvmrc)
  if [[ -z "$nvmrc_path" ]]; then
    return
  fi

  # 读取 .nvmrc 中的版本号
  nvmrc_version=$(cat "$nvmrc_path" | tr -d '[:space:]')
  if [[ -z "$nvmrc_version" ]]; then
    return
  fi

  # 获取当前使用的 Node 版本
  current_version=$(nvm current 2>/dev/null)

  # 如果版本不同，则切换
  if [[ "$current_version" != "$nvmrc_version" ]] && [[ "$current_version" != "v$nvmrc_version" ]]; then
    nvm use "$nvmrc_version" > /dev/null 2>&1
  fi
}

# 在切换目录时自动执行
autoload -U add-zsh-hook
add-zsh-hook chpwd _nvm_auto_use

# 初始加载时也执行一次
_nvm_auto_use
