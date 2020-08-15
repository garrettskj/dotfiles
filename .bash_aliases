## Standards
alias vi='vim'
alias ta='tmux attach-session -t'

## lastpass specific
alias ght='lpass show --notes "GitHub Token"'
alias lpcli='LPASS_DISABLE_PINENTRY=1 lpass login'

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

# Other Useful
#alias myip="curl --silent https://ipecho.net/plain; echo"
alias myip="curl ifconfig.me/ip"

# Because why else am I using xclip
alias xclip="xclip -selection clipboard"

# because I forget where I am
alias dir='ls'
alias cls='clear'



