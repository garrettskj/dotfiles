# If not running interactively, don't do anything
[ -z "$PS1" ] && return

## Set timezone :)
TZ='America/Los_Angeles'; export TZ

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

## set history file
HISTFILENAME="$(date +%Y%m%d-%H%M)_${HOSTNAME}_$$"
HISTFILE="${HOME}/bash_history/$HISTFILENAME"

export HISTFILE

## Sync macro for copying history
## If NextCloud is installed, copy the file there too.
sync_history() {
 ### Create a new history directory if it doesn't exist
 if [ ! -d ~/bash_history ]; then
  mkdir -p ~/bash_history
 fi 
 # sync the history file every time "enter" is hit.
 history -a "$HISTFILE" # append to the existing history file
 history -c # clear out existing history
 history -r "$HISTFILE" # Re-read it into the history buffer
 # if Nextcloud exists, we can assume we should copy our bash history there.
 if [ -d ~/Nextcloud/bash_history ]; then
  cp -f "$HISTFILE" "${HOME}/Nextcloud/bash_history/$HISTFILENAME" > /dev/null 2>&1
 fi
}

## Terminal Reset
TRESET="\[\e[0m\]"
#TRESET="\[$(tput sgr0)\]"

## COLORS
CYAN="\[\033[38;5;14m\]"
WHITE="\[\033[38;5;15m\]"
TEAL="\[\033[38;5;6m\]"
LIGHTGREY="\[\033[38;5;7m\]"
RED="\[\033[38;5;1m\]"
YELLOW="\[\033[38;5;11m\]"

_PROMPT() {
    _EXIT_STATUS=$?
    [ $_EXIT_STATUS != 0 ] && _EXIT_STATUS_STR="${TRESET}${LIGHTGREY} [${TRESET}${RED}$_EXIT_STATUS${TRESET}${LIGHTGREY}]${TRESET}"

	_BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! $_BRANCH == "" ]
	then
		_BRANCH_STR="[${TRESET}${YELLOW}$_BRANCH${TRESET}${LIGHTGREY}]"
	else
		_BRANCH_STR=""
	fi

    PS1="${CYAN}\u${TRESET}${WHITE}@${TRESET}${TEAL}\h${TRESET} ${LIGHTGREY}╺─╸${TRESET}${LIGHTGREY} [${TRESET}${CYAN}\W${TRESET}${LIGHTGREY}]${TRESET}${LIGHTGREY} $_BRANCH_STR${TRESET}${WHITE} \n${TRESET}${LIGHTGREY}[${TRESET}${YELLOW}\A${TRESET}${LIGHTGREY}]$_EXIT_STATUS_STR${TRESET}${LIGHTGREY} >>${TRESET} "
	
    # Update command line history
    sync_history

    unset _EXIT_STATUS_STR
	unset _EXIT_STATUS
	unset _BRANCH_STR
	unset _BRANCH
}

PROMPT_COMMAND=_PROMPT

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# # set variable identifying the chroot you work in (used in the prompt below)
# if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
#     debian_chroot=$(cat /etc/debian_chroot)
# fi

# # set a fancy prompt (non-color, unless we know we "want" color)
# case "$TERM" in
#     xterm-color) color_prompt=yes;;
# esac

# export CLICOLOR=1

# # BSD
# export LSCOLORS='GxFxCxDxBxegedabagacedkk'

# # Linux
# export LS_COLORS='di=1;33:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=34;43'
# alias ls='ls --color=auto'

# [[ $- != *i* ]] && return

# # uncomment for a colored prompt, if the terminal has the capability; turned
# # off by default to not distract the user: the focus in a terminal window
# # should be on the output of commands, not on the prompt
# #force_color_prompt=yes

# if [ -n "$force_color_prompt" ]; then
#     if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
#   # We have color support; assume it's compliant with Ecma-48
#   # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
#   # a case would tend to support setf rather than setaf.)
#   color_prompt=yes
#     else
#   color_prompt=
#     fi
# fi

# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi
# unset color_prompt force_color_prompt

# colors() {
# 	local fgc bgc vals seq0

# 	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
# 	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
# 	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
# 	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

# 	# foreground colors
# 	for fgc in {30..37}; do
# 		# background colors
# 		for bgc in {40..47}; do
# 			fgc=${fgc#37} # white
# 			bgc=${bgc#40} # black

# 			vals="${fgc:+$fgc;}${bgc}"
# 			vals=${vals%%;}

# 			seq0="${vals:+\e[${vals}m}"
# 			printf "  %-9s" "${seq0:-(default)}"
# 			printf " ${seq0}TEXT\e[m"
# 			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
# 		done
# 		echo; echo
# 	done
# }

#### custom editor config
export EDITOR='vim'
export VISUAL='vim'

#### Check for and start SSH Agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
 touch ~/.ssh-agent.info
 ssh-agent > ~/.ssh-agent-info
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
 eval "$(<~/.ssh-agent-info)"
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
fi

# Function definitions.
# Moving all functions outside of .bashrc
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

. ~/.bash_completion.d/alacritty

### Bonus bashrc syntax
[[ -f ~/.extend.bashrc ]] && . ~/.extend.bashrc

## Export Android-sdk
export ANDROID_HOME=~/android-sdk
export ANDROID_SDK_ROOT=~/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools/
source ~/.bash_completion.d/alacritty
