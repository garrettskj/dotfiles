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

## Package installation
if [ $OS = "ubuntu" ]; then
	sudo apt update vlc xz-utils exfat-utils xclip vim tmux deluge curl minicom irssi openssh-server -y
fi

if [ $OS = "manjarolinux" ]; then
	sudo pacman -Su vim tmux xclip irssi openssh vlc-nightly weechat minicom deluge curl python-pip python2-pip intel-ucode --noconfirm
	yaourt -Su google-chrome-beta --noconfirm
fi

if [ ! -f /usr/bin/lpass ]; then
 echo "Installing Lastpass"
 sudo cp ~/dotfiles/binaries/lpass /usr/bin/lpass
fi

## pip install python modules
## sudo pip2 install websocket_client
## sudo pip3 install websocket_client


