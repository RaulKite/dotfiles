~/.git-prompt.sh

# Add paths that should have been there by default
export PATH=${PATH}:/usr/local/bin
export PATH="~/bin:$PATH"

# Unbreak broken, non-colored terminal
export GREP_OPTIONS="--color"

# Erase duplicates in history
export HISTCONTROL=erasedups
# Store 10k history entries
export HISTSIZE=10000
# Append to the history file when exiting instead of overwriting it
shopt -s histappend

# Git prompt components
function minutes_since_last_commit {
    now=`date +%s`
    last_commit=`git log --pretty=format:'%at' -1`
    seconds_since_last_commit=$((now-last_commit))
    minutes_since_last_commit=$((seconds_since_last_commit/60))
    echo $minutes_since_last_commit
}
grb_git_prompt() {
    local g="$(__gitdir)"
    if [ -n "$g" ]; then
        local MINUTES_SINCE_LAST_COMMIT=`minutes_since_last_commit`
        if [ "$MINUTES_SINCE_LAST_COMMIT" -gt 30 ]; then
            local COLOR=${RED}
        elif [ "$MINUTES_SINCE_LAST_COMMIT" -gt 10 ]; then
            local COLOR=${YELLOW}
        else
            local COLOR=${GREEN}
        fi
        local SINCE_LAST_COMMIT="${COLOR}$(minutes_since_last_commit)m${NORMAL}"
        # The __git_ps1 function inserts the current git branch where %s is
        local GIT_PROMPT=`__git_ps1 "(%s|${SINCE_LAST_COMMIT})"`
        echo ${GIT_PROMPT}
    fi
}

function __docker_prompt {
  if [ -n "$DOCKER_HOST" ]; then
    echo "🐳 "
  fi
}

export CLICOLOR=1
export LSCOLORS='ExFxCxDxBxegedabagaced'

function prompt {
  local BLACK="\[\033[0;30m\]"
  local RED="\[\033[0;31m\]"
  local GREEN="\[\033[0;32m\]"
  local YELLOW="\[\033[0;33m\]"
  local BLUE="\[\033[0;34m\]"
  local PURPLE="\[\033[0;35m\]"
  local CYAN="\[\033[0;36m\]"
  local WHITE="\[\033[0;37m\]"
  local WHITEBOLD="\[\033[1;37m\]"
  export PS1="\h:\$(__docker_prompt)\$(grb_git_prompt)\W \u${WHITE}$ "
  export PS1="\[\033[G\]$PS1"
}

prompt


#PS1="\h:\W\$(grb_git_prompt) \u\$ "

#source ~/bin/git-completion.bash


