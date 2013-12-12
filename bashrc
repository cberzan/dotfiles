# If not running interactively, don't process this file any further.
[ -z "$PS1" ] && return

##############################################################################
# Prompt:

# Set variable identifying the chroot you work in.
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set prompt.
# Show git branch and dirty bit if we're inside a git repo.
# PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(__git_ps1 " (%s)") \$ '
GIT_PS1_SHOWDIRTYSTATE=1

# If this is an xterm, set the title to user@host:dir.
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

##############################################################################
# Path:

export PATH=$PATH:~/bin

##############################################################################
# Bash options:

# Completion.
# This is commented out by default in /etc/bash.bashrc.
# Put it here so we don't have to store /etc/bash.bashrc in this repo.
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it.
shopt -s histappend

# Set history length.
HISTSIZE=100000
HISTFILESIZE=100000

# Check the window size after each command and update LINES and COLUMNS.
shopt -s checkwinsize

# Make ** match dirs and files recursively.
if [ ${BASH_VERSINFO[0]} -ge 4 ]
then
    shopt -s globstar
fi

# Don't overwrite files using > by accident.
set -o noclobber

# Vi mode.
set -o vi
bind -m vi-insert "\C-l":clear-screen

##############################################################################
# Misc:

# Non-text file support for less.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Variable to store when you logged in.
LOGGED_IN_AT=$(date)
echo "Logged in at $LOGGED_IN_AT"

# Set up fasd. https://github.com/clvv/fasd
# Skip gracefully if fasd is not installed.
if [[ -x $(which fasd) ]]
then
    eval "$(fasd --init auto)"
else
    echo "fasd is not installed; skipping"
fi

# workon home (for virtualenvwrapper)
# FIXME: that path is not the case if you aptitude install virtualenvwrapper
if [ -x /usr/local/bin/virtualenvwrapper.sh ]
then
    export WORKON_HOME=$HOME/src/virtualenvs
    source /usr/local/bin/virtualenvwrapper.sh
fi


##############################################################################
# Aliases:

# Facilitates completion for aliases.
# See http://ubuntuforums.org/showthread.php?t=733397.
#
# Example for alias api='aptitude install':
# 1) Find out original completion function:
#    $ complete -p aptitude
#    complete -o default -F _aptitude aptitude  # we use the "-o default" and "_aptitude" bits
# 2) Make the completion wrapper:
#    $ make_completion_wrapper _aptitude _api aptitude install
# 3) Register the new completion wrapper:
#    $ complete -o default -F _api api
#
function make_completion_wrapper() {
    local function_name="$2"
    local arg_count=$(($#-3))
    local comp_function_name="$1"
    shift 2
    local function="
function $function_name {
    ((COMP_CWORD+=$arg_count))
    COMP_WORDS=( "$@" \${COMP_WORDS[@]:1} )
    "$comp_function_name"
    return 0
}"
    eval "$function"
    # echo $function_name
    # echo "$function"
}

# Color support for ls and grep.
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
fi
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Aliases for ls.
alias ll='ls -l'
alias l='ls -CF'
alias la='ls -A'
alias lla='ll -A'
alias lh='ll -h'

# Aliases for git + completion for them.
alias gc="git checkout"
make_completion_wrapper _git _gc git checkout
complete -o bashdefault -o default -o nospace -F _gc gc
alias gcm="git checkout master"
alias gl="git log --decorate"
make_completion_wrapper _git _gl git log
complete -o bashdefault -o default -o nospace -F _gl gl
alias gp="git pull"
alias gs="git status"
make_completion_wrapper _git _gs git status
complete -o bashdefault -o default -o nospace -F _gs gs
alias gw="git show"
make_completion_wrapper _git _gw git show
complete -o bashdefault -o default -o nospace -F _gw gw

# Misc shortcuts.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='cat'
alias j='jobs'
alias l='less'
alias m='mplayer'
alias o='xdg-open'
alias v='vim'
alias h='history 30'
alias hh='history'
alias dh='df -h'
alias dhh='dh ~ /'
alias md='mkdir'
alias calc='bc -ql'
alias trash='trash-put'

# Alter the default behavior of these programs.
alias gdb='gdb -q'
alias octave='octave -q'
alias units='units -v'

# Pushing and popping dirs, including across shells.
alias push='pushd .'
alias pop='popd'
alias tpush='rm -f /tmp/pushed_pwd && pwd >/tmp/pushed_pwd && chmod a+rw /tmp/pushed_pwd'
alias tpop='cd "$(cat /tmp/pushed_pwd)"'

# "grep history": gh word
alias gh='history |grep '

# "is running": ir python
# (FIXME: stop it from showing the grep itself in the results)
# (See http://unix.stackexchange.com/a/74186/37542)
alias ir='ps aux |head -n 1 && ps aux |grep -i $1'

# APT / dpkg aliases + completion for them.
alias ii='dpkg -l |grep -i'  # "is installed"
alias api='sudo aptitude install'
make_completion_wrapper _aptitude _api aptitude install
complete -o default -F _api api
alias ase='apt-cache search'
make_completion_wrapper _apt_cache _ase apt-cache search
complete -o default -F _ase ase
alias ash='apt-cache show'
make_completion_wrapper _apt_cache _ash apt-cache show
complete -o default -F _ash ash

# "lsof grep": lg filename
alias lg='lsof -n |grep -i '

# wordnet query: wn word
alias wn="dict -d wn"

# fnd foo: find any files in this dir that have foo in their name
function fnd()
{
    find . -name "*$@*"
}

# fndi foo: like fnd but case insensitive
function fndi()
{
    find . -iname "*$@*"
}

# kill pyc files
alias rmpyc="find . -name '*.pyc' -delete"


##############################################################################
# Obsolete aliases (remove the ones I don't miss):

# # Obsolete:
# alias im='mount |grep sd'
# alias p='pstree -pl'
# alias rmi='rm -i'
# alias cpi='cp -i'
# alias mvi='mv -i'
# alias rmprog='rm -vf *.o *.e *.bak *~ *.out *.class *.gcov *.gcda *.gcno *.hi'
# alias rmexe='find -executable -delete'
# alias ko='kfmclient openURL'
# alias whatip='w3m -dump whatismyip.org'
# 
# # say foo: speak foo using festival.
# function say()
# {
#     echo "$@" |aoss festival --tts
# }


##############################################################################
# Account-specific stuff not stored in git.

if [ -f ~/.bash_private ]; then
    . ~/.bash_private
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
