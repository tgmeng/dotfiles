# 进入目录时自动寻找最近的 .nvmrc，并切到对应的 Node 版本。
# 找不到 .nvmrc 时保持当前版本不动，避免无意义地来回切换。

_nvm_auto_find_nvmrc() {
  local dir="$PWD"
  local nvmrc_path

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

_nvm_auto_use() {
  local nvmrc_path
  local nvmrc_version
  local current_version

  if ! command -v nvm >/dev/null 2>&1; then
    return
  fi

  nvmrc_path=$(_nvm_auto_find_nvmrc)
  if [[ -z "$nvmrc_path" ]]; then
    return
  fi

  nvmrc_version=$(<"$nvmrc_path")
  nvmrc_version="${nvmrc_version//[[:space:]]/}"
  if [[ -z "$nvmrc_version" ]]; then
    return
  fi

  current_version=$(nvm current 2>/dev/null)

  if [[ "$current_version" != "$nvmrc_version" ]] && [[ "$current_version" != "v$nvmrc_version" ]]; then
    nvm use "$nvmrc_version" >/dev/null 2>&1
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _nvm_auto_use

# 启动 shell 时先执行一次，确保当前目录立即生效。
_nvm_auto_use
