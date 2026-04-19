# dotfiles

🔧 我的 dotfiles

## Zsh Layout

Zsh 配置现在按 XDG 路径和启动阶段拆分：

- `zsh/.zshenv`: 唯一的 home 级薄入口，只负责定位并加载早期 env 层。
- `zsh/.config/zsh/env/xdg.zsh`: 定义 XDG 根目录变量，并准备相关目录与 `XDG_RUNTIME_DIR`。
- `zsh/.config/zsh/env/shared.zsh`: 定义 `ZDOTDIR`、Hammerspoon 配置路径和其他依赖 XDG 的共享环境变量。
- `zsh/.config/zsh/.zprofile`: 登录 shell 环境初始化。
- `zsh/.config/zsh/.zshrc`: 交互 shell 初始化。
- `zsh/.config/zsh/env/main.zsh`: 非 XDG 的环境变量与 PATH。
- `zsh/.config/zsh/core/main.zsh`: core 入口，显式加载选项、history、按键和 aliases。
- `zsh/.config/zsh/plugins/main.zsh`: plugins 入口，显式加载 env、zinit、third-party 和 integrations。
- `zsh/.config/zsh/plugins/nvm-auto.zsh`: `.nvmrc` 自动切换。
- `zsh/.config/zsh/completion/main.zsh`: `compinit` 和补全样式。
- `zsh/.config/zsh/prompt/main.zsh`: prompt 入口，继续按职责加载颜色、git、async 等实现。
- `zsh/.config/zsh/local/main.zsh`: 本机私有覆盖层入口和额外补全。

当前结构保留目录分层，但大部分目录只保留一个主文件，加载顺序直接写在 `.zshrc` / `.zprofile` 中，不再依赖目录扫描。

## Bash Layout

Bash 也按启动阶段和职责拆分：

- `bash/.bash_profile`: login shell 入口，先加载 env 层，再转交给 `.bashrc`。
- `bash/.bashrc`: interactive shell 入口；非登录交互 shell 会在这里补一次 env 层，再加载 core。
- `bash/.config/bash/env/xdg.sh`: 定义 XDG 根目录变量，并准备相关目录与 `XDG_RUNTIME_DIR`。
- `bash/.config/bash/env/shared.sh`: 定义 `HISTFILE`、Hammerspoon 配置路径和其他依赖 XDG 的共享环境变量。
- `bash/.config/bash/env/main.sh`: env 装配层，显式加载 `xdg`、`shared` 和 PATH。
- `bash/.config/bash/core/main.sh`: core 入口，显式加载 history、prompt、aliases 和 integrations。
- `bash/.config/bash/core/history.sh`: history 目录初始化和行为设置。
- `bash/.config/bash/core/prompt.sh`: prompt 和颜色定义。
- `bash/.config/bash/core/aliases.sh`: 常用别名。
- `bash/.config/bash/core/integrations.sh`: `fzf` 等交互集成。

## macOS Helpers

- `etc/bin/configure-hammerspoon`: 把 Hammerspoon 的 `MJConfigFile` 指到 `~/.config/hammerspoon/init.lua`。

## Security Notes

此仓库中的共享配置不得包含真实凭据。令牌、API 密钥和 npm 认证信息只应保存在本机文件中，例如 `~/.config/zsh/local/secret.zsh` 或用户级的
`~/.npmrc`。

请使用 `zsh/.config/zsh/local/secret.example.zsh` 作为本地 shell 密钥模板。真实的
`zsh/.config/zsh/local/secret.zsh` 文件会被 Git 有意忽略，并且应始终只保留在本地。

如果真实密钥曾出现在此仓库、终端日志或聊天记录中，应立即轮换，而不只是删除文件。
