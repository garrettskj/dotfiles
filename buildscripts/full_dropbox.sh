#!/bin/sh

## Setup the custom dropbox mount.
mkdir -p ~/db_mnt
sudo chattr +i ~/db_mnt
truncate -s 15G ~/.Dropbox.ext4

mkfs.ext4 -F ~/.Dropbox.ext4

echo "Setting up /etc/fstab..."
echo "\
/home/$USER/.Dropbox.ext4 /home/$USER/db_mnt ext4 user,noauto,rw,loop,x-gvfs-hide 0 0
" | sudo tee -a /etc/fstab

mkdir -p ~/.config/systemd/user/
touch ~/.config/systemd/user/mountdropbox.service 

echo "\
[Unit]
Description=Mounts a Dropbox ext4 image in the home directory of a user
After=home-$USER.mount
Requires=home-$USER.mount

[Service]
ExecStart=/bin/mount %h/db_mnt
ExecStop=/bin/umount %h/db_mnt
RemainAfterExit=yes

[Install]
WantedBy=default.target
" > ~/.config/systemd/user/mountdropbox.service

systemctl --user enable mountdropbox.service
systemctl --user start mountdropbox.service

sudo chown $USER:$USER ~/db_mnt

###
# install Dropbox now
###

if [ -e ~/Downloads/dropbox.deb ]
then
 echo "installing dropbox..."
 sudo apt install python3-gpg -y
 sudo dpkg -i ~/Downloads/dropbox.deb
else
 echo "I didn't find dropbox.deb in the Downloads directory..."
 echo "Please Download and install the dropbox package file manually."
fi

####
# Configure AutoStart
####

mkdir -p ~/.config/dropbox/
touch ~/.config/dropbox/start_dropbox.sh
chmod +x ~/.config/dropbox/start_dropbox.sh

echo "\
#!/bin/sh
systemctl --user enable mountdropbox.service
systemctl --user start mountdropbox.service
dropbox start -i
" > ~/.config/dropbox/start_dropbox.sh

## Modification of dropbox:
if [ -e ~/.config/autostart/dropbox.desktop ]
then
 echo "Modifying DB Autostart.."
 mv -iv ~/.config/autostart/dropbox.desktop ~/.config/autostart/start_dropbox.desktop
 sudo sed -i "s/Exec=dropbox start -i/Exec=\/home\/$USER\/.config\/dropbox\/start_dropbox.sh/g" ~/.config/autostart/start_dropbox.desktop
 sudo sed -i "s/Exec=dropbox start -i/Exec=\/home\/$USER\/.config\/dropbox\/start_dropbox.sh/g" /usr/share/applications/dropbox.desktop
 cd ~ && ln -vs ~/db_mnt/Dropbox Dropbox
else
 echo "Dropbox must not be installed yet."
fi