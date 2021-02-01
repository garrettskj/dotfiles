#!/bin/bash
#
# This is a generatic staging bash script for configuring the environment to my preferences
#

# How this script works.
usage()
{
    echo "usage: packages.sh [-d|--desktop ] | [-h]"
}

DESKTOP=0

## If there are no arguments, display usage
#if [ $# -eq 0 ]; then
#   usage
#   exit 1
#fi

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -d | --desktop )
    DESKTOP=1
    shift
    shift
    ;;
    * )
    usage
    exit 1
esac
done

## Check the linux distribution:
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

    # General PPAs
    sudo add-apt-repository ppa:phoerious/keepassxc -y


    CLI_PACKAGE_LIST="zram-config htop xz-utils exfat-utils net-tools \
                      tmux curl minicom irssi openssh-server python3-pip virtualenv python3-dev \
                      wireguard whois vlan"

    DESKTOP_PACKAGE_LIST="scrot ffmpeg slack-desktop remmina atom wireshark filezilla \
                          google-chrome-beta vlc xclip pinta deluge mpv \
                          android-tools-adb android-tools-fastboot nextcloud-client \
                          keepassxc lib32z1 lib32ncurses6 vim-gtk fonts-dejavu teams sublime-text"

    if [ "$DESKTOP" -eq 1 ]; then
        # Install the signing keys
        wget -qO - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add - > /dev/null 2>&1
        wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add - > /dev/null 2>&1
        wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - > /dev/null 2>&1
        wget -qO - https://packagecloud.io/slacktechnologies/slack/gpgkey | sudo apt-key add - > /dev/null 2>&1
        wget -qO - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add  - > /dev/null 2>&1
    
        ## Update PPAs
        # Chrome
        sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome-beta.list'

        # sublime
        sudo sh -c 'echo "deb https://download.sublimetext.com/ apt/dev/" > /etc/apt/sources.list.d/sublime.list' 

        # atom
        sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'

        # slack
        sudo sh -c 'echo "deb https://packagecloud.io/slacktechnologies/slack/debian/ jessie main" > /etc/apt/sources.list.d/slack.list'

        # MS Teams:
        # Install repository configuration
        curl -sSL https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft-prod.list

        ## Next Cloud Client
        sudo add-apt-repository ppa:nextcloud-devs/client -y

        ### install updated packages
        sudo apt update
        sudo apt install $DESKTOP_PACKAGE_LIST -y

        # Install python packages
        sudo -H pip3 install --upgrade youtube-dl tldr isort yapf pynvim
    fi

    sudo apt update
    sudo apt install $CLI_PACKAGE_LIST -y
fi

if [ $OS = "manjarolinux" ]; then
    sudo pacman -Syyu llvm-libs htop scrot ffmpeg atom remmina wireshark-qt filezilla gvim pinta mpv \
    tmux net-tools xclip irssi openssh vlc-nightly weechat minicom deluge curl python-pip \
    python2-pip intel-ucode youtube-dl mesa \
    --noconfirm
    yaourt -S google-chrome-beta slack-desktop --noconfirm
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
