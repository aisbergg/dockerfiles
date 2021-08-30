# System-wide .bashrc file for interactive bash(1) shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#######################################
# general
#######################################

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# correct mistyped directory names on cd
shopt -s cdspell
# include dotfiles in wildcard expansion
shopt -s dotglob

# enable bash completion in interactive shells
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

#######################################
# prompt
#######################################

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    GREEN_BOLD="\[\e[1;32m\]"
    RED_BOLD="\[\e[1;31m\]"
    WHITE_BOLD="\[\e[1;37m\]"
    RESET='\[\e[0m\]'
    #check if root
    if [[ ${EUID} == 0 ]] ; then
        PS1="$RED_BOLD[\u@\h:$WHITE_BOLD\W$RED_BOLD]# $RESET"
    else
        PS1="$GREEN_BOLD[\u@\h:$WHITE_BOLD\W$GREEN_BOLD]\\$ $RESET"
    fi
else
    if [[ ${EUID} == 0 ]] ; then
        PS1="[\u@\h:\W]# "
    else
        PS1="[\u@\h:\W]\\$ "
    fi
fi

case "$TERM" in
    xterm)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
        ;;
    *)
        ;;
esac

#######################################
# alias
#######################################

# switch to parent dir
alias ..='cd ..'
alias ...='cd ../..'

# list dirs and files as list
alias lla='ls -la --color=always '
alias ll='ls -lA --color=always '
alias l='ls -A --color=always '

# list the size of dirs, files and both
alias ld='du -h --max-depth=1'
alias lf='ls -hasp | grep -v /'
alias ldf='echo "Dirs:" && du -h --max-depth=1 && echo "" && echo "Files:" && ls -hasp | grep -v /'

# man pages color
alias man="TERMINFO=~/.terminfo TERM=mostlike LESS=C PAGER=less man"

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#######################################
# env
#######################################

export TEMP=/tmp
export TMP=/tmp
export TMPDIR=/tmp
