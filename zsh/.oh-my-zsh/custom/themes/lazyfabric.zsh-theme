local icon=$emoji[rightwards_arrow_with_hook]
local ret_status="%(?:$emoji[smiling_face_with_sunglasses]:$emoji[dizzy_face])"

PROMPT='
$ret_status \
%{$fg[cyan]%}%~%{$reset_color%} \
$(git_prompt_info)
$icon '

local branch_icon=$(printf '\xef\x90\x98')
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}[%{$branch_icon%}%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"
