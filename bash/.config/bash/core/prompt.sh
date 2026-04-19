# Color definitions (taken from Color Bash Prompt HowTo).

# Normal Colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Bold
BBLACK='\033[1;30m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'
BYELLOW='\033[1;33m'
BBLUE='\033[1;34m'
BPURPLE='\033[1;35m'
BCYAN='\033[1;36m'
BWHITE='\033[1;37m'

# Background
ON_BLACK='\033[40m'
ON_RED='\033[41m'
ON_GREEN='\033[42m'
ON_YELLOW='\033[43m'
ON_BLUE='\033[44m'
ON_PURPLE='\033[45m'
ON_CYAN='\033[46m'
ON_WHITE='\033[47m'

NC="\033[m"
ALERT=${BWHITE}${ON_RED}

echo -e "${BCYAN}This is BASH ${BRED}${BASH_VERSION%.*}${NC}"
date

if [ "$(id -un)" = "root" ]; then
  PS1="\[${RED}\]\h \[${BLUE}\]\W\[${NC}\] > "
else
  PS1="\[${GREEN}\]\u@\h \[${BLUE}\]\W\[${NC}\] > "
fi
export PS1
