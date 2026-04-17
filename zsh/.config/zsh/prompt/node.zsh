# ------------------------------------------------------------------------------
# Node 版本
# ------------------------------------------------------------------------------

lf_node_render_prompt() {
  print -r -- "%{$lf_prompt_colors[node:border]%}[%{$lf_prompt_colors[node:version]%}node:$1%{$lf_prompt_colors[node:border]%}]%{$reset_color%}"
}

# 只有当前目录像一个 Node 项目时才展示版本，避免普通目录也去调用 `node`。
lf_node_get_version() {
  if [[ -f package.json ]] && command -v node >/dev/null 2>&1; then
    lf_node_render_prompt "$(node -v)"
  fi
}
