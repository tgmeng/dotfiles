# 按 zinit 文档推荐的方式加载 oh-my-zsh 片段，而不是手动 source 整个框架。
# 这些片段虽然和补全相关，但放在插件阶段加载更符合它们的归属；compdef 会在 completion 阶段统一回放。

# git 插件的一些别名依赖 lib/git.zsh 里的辅助函数，例如 git_current_branch。
zinit snippet OMZL::git.zsh

# 单文件插件直接按 OMZP:: 简写加载。
for plugin in git history asdf docker docker-compose; do
  zinit snippet "OMZP::$plugin"
done

# emoji 插件会再 source 同目录下的 emoji-char-definitions.zsh。
# GitHub 当前不再提供可用的 SVN trunk 路径，因此这里回退到整仓库 + pick 的方式。
zinit ice depth"1" id-as"omz-emoji" pick"plugins/emoji/emoji.plugin.zsh"
zinit light ohmyzsh/ohmyzsh

# 第三方插件
# 语法高亮必须靠后加载，否则容易被前面的插件或按键设置覆盖。
zinit light mafredri/zsh-async
zinit light jeffreytse/zsh-vi-mode

zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-autosuggestions
zinit ice wait="1" lucid
zinit light MichaelAquilina/zsh-you-should-use
zinit light zsh-users/zsh-syntax-highlighting
