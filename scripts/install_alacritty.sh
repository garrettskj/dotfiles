#!/bin/bash

# This installs alacritty terminal on ubuntu (https://github.com/jwilm/alacritty)
# You have to have rust/cargo installed for this to work

# Install required tools
sudo apt-get install -y cmake libfreetype6-dev libfontconfig1-dev xclip cargo pkg-config libxcb-xfixes0-dev python3

# Download, compile and install Alacritty
mkdir -p ~/gitrepos
git clone https://github.com/jwilm/alacritty ~/gitrepos/alacritty
cd ~/gitrepos/alacritty
cargo install alacritty

# Add Man-Page entries
sudo mkdir -p /usr/local/share/man/man1
gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null

# Add shell completion for bash
mkdir -p ~/.bash_completion.d
cp extra/completions/alacritty.bash ~/.bash_completion.d/alacritty
echo "source ~/.bash_completion.d/alacritty" >> ~/.bashrc

# Copy default config into home dir
# if it doesn't already exist
if [ ! -e ~/.alacritty.yml ]
 cp alacritty.yml ~/.alacritty.yml
fi

# Create desktop file
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database

# Copy binary to path
sudo cp ~/.cargo/bin/alacritty /usr/local/bin

# Use Alacritty as default terminal (Ctrl + Alt + T)
gsettings set org.gnome.desktop.default-applications.terminal exec 'alacritty'

## Add it to the update alternatives
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/alacritty 50

# Config as default
sudo update-alternatives --config x-terminal-emulator


# Remove temporary dir
#rm -r alacritty
