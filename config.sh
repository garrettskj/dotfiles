
# TMUX
rm ~/.tmux.conf
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf

# Xconfig
rm ~/.Xdefaults
ln -s ~/dotfiles/.Xdefaults ~/.Xdefaults
xrdb -merge .Xdefaults

# Shell
touch ~/.bash_aliases
if [ -f ~/.bash_aliases ]; then
 echo "alias vi='vim'" >> ~/.bash_aliases
fi
