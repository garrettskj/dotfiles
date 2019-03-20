
# Add a list of all the standard dotfiles here

FILES=(
'.tmux.conf' \
'.Xdefaults' \
'.bash_aliases' \
'.bashrc' \
'.vimrc' \
)

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
if [ ! -d ~/.vim/colors ]; then
 echo "Setting up VIM colors..."
 mkdir -p ~/.vim/colors
 cp ~/dotfiles/potato.vim ~/.vim/colors/potato.vim
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
