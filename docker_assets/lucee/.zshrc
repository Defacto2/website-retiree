# Path to your oh-my-zsh installation.
export ZSH="/root/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=90

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load?
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    debian
)

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR='nano'

alias cls="clear"

function follow () {
    tail -f $@ | bat --paging=never -l log
}

# Prefix to prompt
PROMPT="(defacto2 webapp)"$PROMPT