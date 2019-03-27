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

### Create a new history directory if it doesn't exist
if [ ! -d ~/bash_history ]; then
 mkdir -p ~/bash_history
fi

## set history file
HISTFILENAME="$(date +%Y%m%d-%H%M)_${HOSTNAME}_$$"
HISTFILE="${HOME}/bash_history/$HISTFILENAME"

export HISTFILE

## Check for DB login
if [ ! -f ~/.config/dbxcli/auth.json ]; then
    echo "You don't have valid dropbox credentials installed."
    echo "Consider setting up valid credentials with the following:"
    echo "lpass show --notes db-auth.json > ~/.config/dbxcli/auth.json"
fi

### Play twitch streams
twitch() {
 if [ ! -z "$1" ]
 then
  mpv https://www.twitch.tv/$1 ytdl-format="bestvideo[height<=?720]+bestaudio/best" --autofit=50% --quiet 2>&1
 else
  echo "Usage: twitch [ kitboga riotgames ] "
 fi
}


### Listen to Di.FM
difm() {
 if [ ! -z "$1" ]
 then
  # get the key from lastpass
  DIKEY=`lpass show --notes "DIFM-listenKey"`
  # wrap around the mplayer output and just get the song title
  mpv --cache=no http://prem1.di.fm/$1?$DIKEY --quiet 2>&1 | while read -r line; do
  if grep "icy" <<< "$line" &>/dev/null; then
   song=$(grep -Po "icy-title: \K.*?(?=$)" <<< $line);
   echo "Playing: $song";
   notify-send mpvCLI "$song";
  fi;
  done
 else
  echo "Radio Station List: difm [chillstep, 00sclubhits, vocaltrance]"
  echo "For more: https://www.di.fm/settings"
 fi
}

### TV Time!
watchtv() {
 if [ ! -z "$1" ]
 then
  # fix this with DNS at some point
  mpv http://192.168.1.39:5004/auto/v"$1" --geometry=50%
 else 
  echo 'Enter the channel to watch: $0 $channel:'
 fi
}

### Generate a random string based on length
pwgen() {
 if [ ! -z "$1" ]
 then
  < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-$1};echo;
 else 
  echo 'Enter the length: pwgen $length'
 fi
}

## Sync macro to sync to db
sync_history_to_db() {
 # sync my history to dropbox, if authkey is there
 if [ -f ~/.config/dbxcli/auth.json ]; then
  /usr/bin/dbxcli-linux-amd64 put "$HISTFILE" "bash_history/$HISTFILENAME" > /dev/null 2>&1
 fi
}

### sync the history file every time "enter" is hit.
PROMPT_COMMAND="history -a >(tee -a $HISTFILE | sync_history_to_db)"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

export CLICOLOR=1

# BSD
export LSCOLORS='GxFxCxDxBxegedabagacedkk'

# Linux
export LS_COLORS='di=1;33:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=34;43'
alias ls='ls --color=auto'

[[ $- != *i* ]] && return

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # We have color support; assume it's compliant with Ecma-48
  # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
  # a case would tend to support setf rather than setaf.)
  color_prompt=yes
    else
  color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

### Last pass function:
lpssh() {
 if [ ! -z "$1" ]
 then
  lpstatus=$(exec lpass status)
  if [[ ! $lpstatus =~ .*Not.* ]]
  then
   echo "Loading key: " "$1"
   lpass show --notes "$1" --field 'Private Key' | ssh-add -
  else
   echo "login to lastpass first..."
  fi
 else
  echo "I need a key to load!"
 fi
}

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

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
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
### Bonus bashrc syntax
[[ -f ~/.extend.bashrc ]] && . ~/.extend.bashrc
