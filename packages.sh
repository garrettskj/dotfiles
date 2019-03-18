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
	# Install the signing keys
	wget -qO - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add - > /dev/null 2>&1
	wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add - > /dev/null 2>&1
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - > /dev/null 2>&1
	wget -qO - https://packagecloud.io/slacktechnologies/slack/gpgkey | sudo apt-key add - > /dev/null 2>&1
	
	## Update PPAs
	# Chrome
	sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome-beta.list'

	# sublime
	sudo sh -c 'echo "deb https://download.sublimetext.com/ apt/dev/" > /etc/apt/sources.list.d/sublime.list' 

	# atom
	sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'

	#slack
	sudo sh -c 'echo "deb https://packagecloud.io/slacktechnologies/slack/debian/ jessie main" > /etc/apt/sources.list.d/slack.list'

	### install updated packages
	sudo apt update
	sudo apt install htop scrot ffmpeg slack-desktop remmina atom wireshark filezilla google-chrome-beta vlc xz-utils exfat-utils net-tools xclip vim-gnome pinta tmux deluge curl minicom irssi openssh-server mplayer -y
fi

if [ $OS = "manjarolinux" ]; then
	sudo pacman -Syu remmina wireshark filezilla vim tmux net-tools xclip irssi openssh vlc-nightly weechat minicom deluge curl python-pip python2-pip intel-ucode --noconfirm
	yaourt -S google-chrome-beta --noconfirm
fi

if [ ! -f /usr/bin/lpass ]; then
 echo "Installing Lastpass"
 sudo cp ~/dotfiles/binaries/lpass /usr/bin/lpass
else
 echo "Lastpass already installed..."
fi

if [ ! -f /usr/bin/dbxcli-linux-amd64 ]; then
 echo "Installing Dropbox CLI"
 mkdir -p ~/.config/dbxcli
 sudo cp ~/dotfiles/binaries/dbxcli-linux-amd64 /usr/bin/dbxcli-linux-amd64
else 
 echo "Dropbox CLI already installed..."
fi

## pip install python modules
## sudo pip2 install websocket_client
## sudo pip3 install websocket_client
