# -----------------------------------------------------------------------------
# Set up some paths and export them
# - DOT_BASH
#   Capture the full location of bashrc
# - DOT_ROOT
#   The full path to where the dotfiles were checkouted out to
# - GIT_DIR
#   Full path to git dotfiles
# -----------------------------------------------------------------------------
#
# if bashrc was symbolically linked get the original location
# otherwise just get the real location
if [[ -L ${BASH_SOURCE[0]} ]]; then
    DOT_BASH="$(dirname $(readlink ${BASH_SOURCE[0]}))"
else
    DOT_BASH="$(dirname ${BASH_SOURCE[0]})"
fi
#
export DOT_BASH
export DOT_ROOT="$(cd $DOT_BASH/.. && pwd)"
GIT_DIR="$DOT_ROOT/git"
#
# Add user specific environment
#
PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH

# -----------------------------------------------------------------------------
# Edit the command prompt
# -----------------------------------------------------------------------------
#
# Use colors in the terminal
#
export CLICOLOR=1
#
# Change the default prompt
# If logged in as root make the prompt red
#
if [ $(id -u) -eq 0 ]; then
    PS1="\\[$(tput setaf 1)\\]\\u@\\h:\\w #\\[$(tput sgr0)\\]"
else
    PS1="[\\u@\\h:\\w] $ "
fi
#
# Add some usefule functions
#
if [ -f $DOT_BASH/functions ]; then
    . $DOT_BASH/functions
fi
#
# Source bash_alias if it exists
#
if [ -f $DOT_BASH/bash_alias ]; then
    . $DOT_BASH/bash_alias
fi
#
# Use bash-completion, if available
#
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# -----------------------------------------------------------------------------
# Source files for git
# -----------------------------------------------------------------------------
#
# Use git command completion
#
if [ -f $GIT_DIR/git-completion.sh ]; then
    source $GIT_DIR/git-completion.sh
fi
#
# Add git info to the command prompt
# ex. (master +)
#
if [ -f $GIT_DIR/git-prompt.sh ]; then
    source $GIT_DIR/git-prompt.sh
    # add the branch at the end
    PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'
    # use colors to show different states
    GIT_PS1_SHOWCOLORHINTS=1
    # * for unstaged changes
    # + for staged changes
    GIT_PS1_SHOWDIRTYSTATE=1
    # % for untracked files
    GIT_PS1_SHOWUNTRACKEDFILES=1
fi