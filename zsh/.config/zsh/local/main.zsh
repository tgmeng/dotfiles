typeset -g ZSH_LOCAL_SECRET_FILE="$ZDOTDIR/local/secret.zsh"

if [[ -r "$ZSH_LOCAL_SECRET_FILE" ]]; then
  source "$ZSH_LOCAL_SECRET_FILE"
fi

[[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/git/git-custom-complete" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/git/git-custom-complete"
[[ -r "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && source "$HOME/.dart-cli-completion/zsh-config.zsh"
