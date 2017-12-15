# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

#######################################
# prompt declaration and colors
#######################################
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
else
    color_prompt=
fi

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWDIRTYSTATE="yes"
GIT_PS1_SHOWUNTRACKEDFILES="yes"
if [ "$color_prompt" = yes ]; then
    BLUE_BOLD="\[\e[1;34m\]"
    GREEN_BOLD="\[\e[1;32m\]"
    YELLOW_BOLD="\[\e[1;33m\]"
    RED_BOLD="\[\e[1;31m\]"
    WHITE_BOLD="\[\e[1;37m\]"
    RESET='\[\e[0m\]'
    #check if root
    if [[ ${EUID} == 0 ]]; then
        PS1="$YELLOW_BOLD${debian_chroot:+($debian_chroot)}$RED_BOLD[\u@\h:$WHITE_BOLD\W$RED_BOLD]\$(__git_ps1 \"$BLUE_BOLD(%s)$RED_BOLD\")\\$ $RESET"
    else
        PS1="$YELLOW_BOLD${debian_chroot:+($debian_chroot)}$GREEN_BOLD[\u@\h:$WHITE_BOLD\W$GREEN_BOLD]\$(__git_ps1 \"$BLUE_BOLD(%s)$GREEN_BOLD\")\\$ $RESET"
    fi
else
    PS1="${debian_chroot:+($debian_chroot)}[\u@\h:\W] \$(__git_ps1 \"(%s) \")\\$ "
fi
unset color_prompt

# enable bash completion in interactive shells
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
        function command_not_found_handle {
                # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
                   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
                   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
                else
                   printf "%s: command not found\n" "$1" >&2
                   return 127
                fi
        }
fi
