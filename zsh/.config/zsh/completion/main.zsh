zmodload -i zsh/complist

# 自动加载补全系统。
autoload -U compinit

# 把 compdump 放到 XDG cache，避免在配置目录里反复生成缓存文件。
typeset -g ZSH_COMPLETION_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
typeset -g ZSH_COMPDUMP_FILE="$ZSH_COMPLETION_CACHE_DIR/zcompdump-${ZSH_VERSION}"

command mkdir -p "$ZSH_COMPLETION_CACHE_DIR"
compinit -d "$ZSH_COMPDUMP_FILE" -i

# 某些插件会在 compinit 之前注册补全定义；这里统一回放一次。
if (( ${+functions[zinit]} )); then
  zinit cdreplay -q
fi

# 不要一按 Tab 就直接插入第一个匹配项。
unsetopt menu_complete
# 关闭 ^S/^Q 的流控占用，避免和快捷键冲突。
unsetopt flow_control

# 连续按 Tab 时进入菜单补全。
setopt auto_menu
# 允许在单词中间位置补全。
setopt complete_in_word
# 插入完整补全后，把光标移动到词尾。
setopt always_to_end

# 先做普通补全，再在必要时启用近似匹配。
zstyle ':completion:::::' completer _complete _approximate
# 近似匹配最多允许 2 个错误。
zstyle ':completion:*:approximate:*' max-errors 2
# 使用菜单式补全选择。
zstyle ':completion:*:*:*:*:*' menu select
# 让补全列表复用 LS_COLORS 着色。
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
# 不区分大小写，并支持部分单词 / 子串匹配。
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
