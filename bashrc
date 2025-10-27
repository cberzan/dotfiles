# If not running interactively, don't process this file any further.
[ -z "$PS1" ] && return

##############################################################################
# Account-specific stuff not stored in git.

if [ -f ~/.bash_private_before ]; then
    . ~/.bash_private_before
fi

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
# Bash options:

# Completion.
# This is commented out by default in /etc/bash.bashrc.
# Put it here so we don't have to store /etc/bash.bashrc in this repo.
if [ -f /etc/bash_completion ]; then
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

# virtualenvwrapper
source /usr/share/virtualenvwrapper/virtualenvwrapper.sh

# Convenience commands for virtualenvs created by uv
alias activate=". .venv/bin/activate"
alias cdproject='cd $(dirname $(python -c "import sys; print(sys.prefix)"))'
alias cdsitepackages='cd $(python -c "import site; print(site.getsitepackages()[0])")'


##############################################################################
# Aliases:

# Color support for ls and grep.
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
fi
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Aliases for ripgrep, fd.
alias rgu='rg -u'
alias fd='fdfind'
alias fdu='fdfind -u'

# Aliases for ls.
alias ll='ls -l'
alias l='ls -CF'
alias la='ls -A'
alias lla='ll -A'
alias lh='ll -h'

# Aliases for git + completion for them.
source /usr/share/bash-completion/completions/git
alias gc="git checkout"
__git_complete gc _git_checkout
alias gcm="git checkout master"
alias gg="git gui &"
alias gl="git log --decorate"
__git_complete gl _git_log
alias glga="git log --decorate --graph --all"
alias gp="git pull"
alias gs="git status"
__git_complete gs _git_status
alias gw="git show"
__git_complete gw _git_show

# Misc shortcuts.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias j='jobs'
alias l='less'
alias o='xdg-open'
alias h='history 30'
alias dh='df -h'
alias dhh='dh /'
alias calc='bc -ql'
alias trash='gio trash'

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

# "is installed": ii upower
alias ii='dpkg -l |grep -i'

# "lsof grep": lg filename
alias lg='lsof -n |grep -i '

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

# delete compiled files
alias rmpyc="find . -name '*.pyc' -delete"
alias rmclass="find . -name '*.class' -delete"


##############################################################################
# Utils for handling files in ~/Downloads:

DOWNLOADS_DIR="$HOME/Downloads"

function lsdl() {
    ls --color -1 -t "$DOWNLOADS_DIR" |head |nl
}

function cpdl() {
    if [ "a$1" == 'a-h' ] || [ "a$1" == 'a--help' ]; then
        echo "Usage examples:"
        echo "    cpdl        # copy most recent download into pwd"
        echo "    cpdl 3      # copy 3rd most recent download into pwd"
        echo "    cpdl 3 foo  # copy 3rd most recent download into foo"
        return 0
    fi

    # Using "${parameter:-default}" construct.
    index=${1:-1}
    dest=${2:-.}
    filename=$(ls -1 -t ~/Downloads/ |sed -n "$index p")
    echo "$filename"
    src="$DOWNLOADS_DIR/$filename"
    cp "$src" "$dest"
}

function mvdl() {
    if [ "a$1" == 'a-h' ] || [ "a$1" == 'a--help' ]; then
        echo "Usage examples:"
        echo "    mvdl        # move most recent download into pwd"
        echo "    mvdl 3      # move 3rd most recent download into pwd"
        echo "    mvdl 3 foo  # move 3rd most recent download into foo"
        return 0
    fi

    # Using "${parameter:-default}" construct.
    index=${1:-1}
    dest=${2:-.}
    filename=$(ls -1 -t ~/Downloads/ |sed -n "$index p")
    echo "$filename"
    src="$DOWNLOADS_DIR/$filename"
    mv "$src" "$dest"
}


##############################################################################
# Account-specific stuff not stored in git.

if [ -f ~/.bash_private ]; then
    . ~/.bash_private
fi
