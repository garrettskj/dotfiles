### Check the linux distribution:

OS=$(awk '/DISTRIB_ID=/' /etc/*-release | sed 's/DISTRIB_ID=//' | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
VERSION=$(awk '/DISTRIB_RELEASE=/' /etc/*-release | sed 's/DISTRIB_RELEASE=//' | sed 's/[.]/./')

if [ -z "$OS" ]; then
    OS=$(awk '{print $1}' /etc/*-release | tr '[:upper:]' '[:lower:]')
fi

if [ -z "$VERSION" ]; then
    VERSION=$(awk '{print $3}' /etc/*-release)
fi

if [ $OS = "ubuntu" ]; then
	echo "Installing Packages"
	sudo apt install xclip vim tmux minicom irssi -y
fi

if [ $OS = "manjarolinux" ]; then
	sudo pacman -S vim tmux xlip irssi weechat minicom python-pip python2-pip intel-ucode --noconfirm
	yaourt -S google-chrome-beta --noconfirm
fi

## pip install python modules
## sudo pip2 install websocket_client
## sudo pip3 install websocket_client


