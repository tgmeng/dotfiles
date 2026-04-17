# dotfiles

🔧 我的 dotfiles

## Zsh Layout

Zsh 配置现在按 XDG 路径和启动阶段拆分：

- `zsh/.zshenv`: 唯一的 home 级入口，只负责把 `ZDOTDIR` 指到 `~/.config/zsh`。
- `zsh/.config/zsh/.zprofile`: 登录 shell 环境初始化。
- `zsh/.config/zsh/.zshrc`: 交互 shell 初始化。
- `zsh/.config/zsh/env/main.zsh`: 环境变量与 PATH。
- `zsh/.config/zsh/core/main.zsh`: core 入口，显式加载选项、history、按键和 aliases。
- `zsh/.config/zsh/plugins/main.zsh`: plugins 入口，显式加载 env、zinit、third-party 和 integrations。
- `zsh/.config/zsh/plugins/nvm-auto.zsh`: `.nvmrc` 自动切换。
- `zsh/.config/zsh/completion/main.zsh`: `compinit` 和补全样式。
- `zsh/.config/zsh/prompt/main.zsh`: prompt 入口，继续按职责加载颜色、git、async 等实现。
- `zsh/.config/zsh/local/main.zsh`: 本机私有覆盖层入口和额外补全。

当前结构保留目录分层，但大部分目录只保留一个主文件，加载顺序直接写在 `.zshrc` / `.zprofile` 中，不再依赖目录扫描。

## Security Notes

此仓库中的共享配置不得包含真实凭据。令牌、API 密钥和 npm 认证信息只应保存在本机文件中，例如 `~/.config/zsh/local/secret.zsh` 或用户级的
`~/.npmrc`。

请使用 `zsh/.config/zsh/local/secret.example.zsh` 作为本地 shell 密钥模板。真实的
`zsh/.config/zsh/local/secret.zsh` 文件会被 Git 有意忽略，并且应始终只保留在本地。

如果真实密钥曾出现在此仓库、终端日志或聊天记录中，应立即轮换，而不只是删除文件。
