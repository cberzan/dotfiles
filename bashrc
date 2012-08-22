# If not running interactively, don't process this file any further.
[ -z "$PS1" ] && return


##############################################################################
# Prompt:

# Set variable identifying the chroot you work in.
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set prompt.
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

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
shopt -s globstar

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


##############################################################################
# Aliases:

# Color support for ls and grep.
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Aliases for ls.
alias ll='ls -l'
alias l='ls -CF'
alias la='ls -A'
alias lla='ll -A'
alias lh='ll -h'

# Misc shortcuts.
alias j='jobs'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias e='editor'
alias v='view'
alias m='less'
alias a='cat'
alias h='history 30'
alias hh='history'
alias dh='df -h'
alias dhh='dh ~ /'
alias md='mkdir'
alias calc='bc -ql'

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
# (FIXME: stop it from showing the grep itself in the results
alias ir='ps aux |head -n 1 && ps aux |grep -i $1'

# "is installed": ii package
alias ii='dpkg -l |grep -i' # arg

# "aptitude install"
alias api='sudo aptitude install'

# "apt-cache search"
alias ase='apt-cache search'

# "apt-cache show"
alias ash='apt-cache show'

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
