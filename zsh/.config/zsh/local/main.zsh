typeset -g ZSH_LOCAL_SECRET_FILE="$ZDOTDIR/local/secret.zsh"

if [[ -r "$ZSH_LOCAL_SECRET_FILE" ]]; then
  source "$ZSH_LOCAL_SECRET_FILE"
fi

[[ -r "$HOME/.git-custom-complete" ]] && source "$HOME/.git-custom-complete"
[[ -r "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && source "$HOME/.dart-cli-completion/zsh-config.zsh"
