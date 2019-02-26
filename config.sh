
# TMUX
rm ~/.tmux.conf
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf

# Xconfig
rm ~/.Xdefaults
if [[ -n $DISPLAY ]]; then
 ln -s ~/dotfiles/.Xdefaults ~/.Xdefaults
 xrdb -merge .Xdefaults
fi

# Shell
touch ~/.bash_aliases
if [ -f ~/.bash_aliases ]; then
 echo "alias vi='vim'" >> ~/.bash_aliases
fi
