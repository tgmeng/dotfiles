# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export PATH=$PATH:$HOME/bin

# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.
# For example, I see 'Bold Red' as 'orange' on my screen,
# hence the 'Green' 'BRed' 'Red' sequence I often use in my prompt. 

# Normal Colors
BLACK='\033[0;30m'        # Black
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green
YELLOW='\033[0;33m'       # Yellow
BLUE='\033[0;34m'         # Blue
PURPLE='\033[0;35m'       # Purple
CYAN='\033[0;36m'         # Cyan
WHITE='\033[0;37m'        # White

# Bold
BBLACK='\033[1;30m'       # Black
BRED='\033[1;31m'         # Red
BGREEN='\033[1;32m'       # Green
BYELLOW='\033[1;33m'      # Yellow
BBLUE='\033[1;34m'        # Blue
BPURPLE='\033[1;35m'      # Purple
BCYAN='\033[1;36m'        # Cyan
BWHITE='\033[1;37m'       # White

# Background
ON_BLACK='\033[40m'       # Black
ON_RED='\033[41m'         # Red
ON_GREEN='\033[42m'       # Green
ON_YELLOW='\033[43m'      # Yellow
ON_BLUE='\033[44m'        # Blue
ON_PURPLE='\033[45m'      # Purple
ON_CYAN='\033[46m'        # Cyan
ON_WHITE='\033[47m'       # White

NC="\033[m"               # Color Reset

ALERT=${BWHITE}${ON_RED} # Bold White on red background

# Hello Message
echo -e "${BCYAN}This is BASH ${BRED}${BASH_VERSION%.*}${BCYAN}\
- DISPLAY on ${BRED}$DISPLAY${NC}\n"
date

user=`whoami`

if [ "${user}" == "root" ]; then
	export PS1="[${RED}\h ${BLUE}\W${NC}]# "
else
	export PS1="[${GREEN}\u@\h ${BLUE}\W${NC}]\$ "
fi

# alias

# nice ls formats
alias ll='ls -lh'
alias la='ls -a'
alias lla='ls -alh'
alias l='ls -alh'

alias rm="rm -i"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
