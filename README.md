# dotfiles

🔧 我的 dotfiles

## Security Notes

此仓库中的共享配置不得包含真实凭据。令牌、API 密钥和 npm 认证信息只应保存在本机文件中，例如 `~/.zsh/secret.zsh` 或用户级的
`~/.npmrc`。

请使用 `zsh/.zsh/secret.example.zsh` 作为本地 shell 密钥模板。真实的
`~/.zsh/secret.zsh` 文件会被 Git 有意忽略，并且应始终只保留在本地。

对于 npm 认证，不要将 registry 凭据放在 `etc/.npmrc` 中。应改用 `npm login`，或将认证信息添加到用户级的
`~/.npmrc`。

如果真实密钥曾出现在此仓库、终端日志或聊天记录中，应立即轮换，而不只是删除文件。
