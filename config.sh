
# Add a list of all the standard dotfiles here

FILES=(
'.tmux.conf' \
'.Xdefaults' \
'.bash_aliases' \
'.bash_functions' \
'.bashrc' \
'.vimrc' \
'.alacritty.yml' \
)

## Where ever you made the git repo,
## let's symlink dotfiles to it.
ln -s $(pwd) ~/dotfiles

# go through the list, and check for symlinks, and if they aren't symlinked..
# symlink them!
for file in ${FILES[@]}; do
 if [ -L ~/$file ];
 then
  echo "IGNORE: $file symlink already exist"	
 else
  echo "CFG: Adding $file symlink..."	
  rm ~/$file
  ln -s ~/dotfiles/$file ~/$file
 fi
done

# Misc other configurations
## If the display variable is set:
if [ ! -z "$DISPLAY" ]; then
 echo "CFG: Found XSession, setting Xdefaults..."	
 xrdb -merge .Xdefaults
fi

## Check to see if the VIM color folder exists
if [ ! -e ~/.vim/colors/potato.vim ]; then
 echo "Setting up VIM colors..."
 mkdir -p ~/.vim/colors
 cp ~/dotfiles/potato.vim ~/.vim/colors/potato.vim
fi

## Configure MPV to use high quality rendering.
if [ ! -e ~/.config/mpv/mpv.conf ]; then
 echo "Setting up MPV customizations..."
 mkdir -p ~/.config/mpv
 ln -s ~/dotfiles/mpv.conf ~/.config/mpv/mpv.conf
fi

## Modification of Ubuntu Release Manager:
if [ -e /etc/update-manager/release-upgrades ]
then
 echo "Changing Ubuntu LTS to normal"
 sudo sed -i 's/'Prompt=lts'/'Prompt=normal'/g' /etc/update-manager/release-upgrades
else
 echo "Not an ubuntu release..."
fi

## Modification of initramfs:
if [ -e /etc/initramfs-tools/initramfs.conf ]
then
 echo "updating initramfs.conf to use XZ compression"
 sudo sed -i 's/'COMPRESS=gzip'/'COMPRESS=xz'/g' /etc/initramfs-tools/initramfs.conf
else
 echo "Must not be a linux system.. XD"
fi

## Modification of Regolith from LTS to Main
if [ -e /etc/apt/sources.list.d/regolith-linux-ubuntu-release-focal.list ]
 then
  sudo rm -f /etc/apt/sources.list.d/regolith-linux-ubuntu-release-*
  echo "Changing from the Release version of Regolith to Stable"
  sudo add-apt-repository ppa:regolith-linux/stable
 else
  echo "This is most likely not a regolith linux system..."
 fi

## Configure Remmina DataDir
if [ -e ~/.config/remmina/remmina.pref ]
 then
  echo "Updating Remmina Data Directory..."
  sudo sed -i -E "s%datadir_path.*$%datadir_path=$HOME/Nextcloud/protected/infrastructure/remmina_data%" ~/.config/remmina/remmina.pref
 else
  echo "Remmina not installed."
fi

