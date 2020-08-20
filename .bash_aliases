## Standards
alias vi='vim'
alias ta='tmux attach-session -t'

## Credentials specific
alias ght='/usr/local/bin/gp.sh -n "GitHub Token"'
alias getpass='/usr/local/bin/gp.sh'
alias passlist='keepassxc-cli ls $PASSWORD_STORE'

## Utility
alias kclean='dpkg -l | egrep "linux\-(*image*|*headers*)\-[0-9]" | egrep -v "`uname -r | awk -F- '\''{print $1"-"$2}'\''`" | cut -d" " -f 3'

## because I can't type
alias python='python3'
alias pythong='python3'
alias py='python3'

# AnyConnect
alias vpn='/opt/cisco/anyconnect/bin/vpn'
alias vpnui='/opt/cisco/anyconnect/bin/vpnui'
alias vpn_to_work='~/gitrepos/ac_patcher/gs_ac_login.sh'

# Other Useful
#alias myip="curl --silent https://ipecho.net/plain; echo"
alias myip="curl ifconfig.me/ip"

# Because why else am I using xclip
alias xclip="xclip -selection clipboard"

# because I forget where I am
alias dir='ls'
alias cls='clear'

# adding flags
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

# youtube-dl --GRABBED FROM DISTROTUBE--
alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias yta-opus="youtube-dl --extract-audio --audio-format opus "
alias yta-vorbis="youtube-dl --extract-audio --audio-format vorbis "
alias yta-wav="youtube-dl --extract-audio --audio-format wav "
alias ytv-best="youtube-dl -f bestvideo+bestaudio "

