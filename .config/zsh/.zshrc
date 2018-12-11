

#
# User configuration sourced by interactive shells
#

# XDG Compliant Structure
XDG_CONFIG_HOME=$HOME/.config
source "$XDG_CONFIG_HOME/zsh/zshenv"


# Start zim
[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh


# Load helpers
[[ -s ${ZDOTDIR}/aliases ]] && source ${ZDOTDIR}/aliases
[[ -s ${ZDOTDIR}/functions ]] && source ${ZDOTDIR}/functions


# Python helpers
[[ -e /usr/local/bin/virtualenvwrapper.sh ]] && source /usr/local/bin/virtualenvwrapper.sh

# Homebrew path
export PATH=/usr/local/bin:$PATH