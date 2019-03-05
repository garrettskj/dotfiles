
# Add a list of all the standard dotfiles here

FILES=(
'.tmux.conf' \
'.Xdefaults' \
'.bash_aliases' \
'.bashrc' \
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

## Modification of Ubuntu Release Manager:
if [ -e /etc/update-manager/release-upgrades ]
then
 echo "Changing Ubuntu LTS to normal"
 sudo sed -i 's/'Prompt=lts'/'Prompt=normal'/g' /etc/update-manager/release-upgrades
else
 echo "Not an ubuntu release..."
fi
