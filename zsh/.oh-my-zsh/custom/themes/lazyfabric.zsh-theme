local icon=$emoji[rightwards_arrow_with_hook]
local icon_node=$(echo -e '\uf898')

function check_node_version () {
    if [[ -f package.json ]] then;
        local version=$(node --version)
        echo "%{$fg[white]%}[%{$fg[green]%}%{$icon_node%} %{$version%}%{$fg[white]%}]%{$reset_color%}"
    fi
}

local ret_status="%(?:$emoji[smiling_face_with_sunglasses]:$emoji[dizzy_face])"

PROMPT='
%{$ret_status%} \
%{$fg[cyan]%}%~%{$reset_color%} \
$(git_prompt_info) \
$(check_node_version)
$icon '

local branch_icon=$(echo -e '\uf418')
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}[%{$branch_icon%}%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}"
