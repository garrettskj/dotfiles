
# tmux
if [[ -e ~/.tmux.conf ]]; then
 rm ~/.tmux.conf
 ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
fi

# Xconfig
if [[ -e ~/.Xdefaults ]]; then
 rm ~/.Xdefaults
fi

if [[ -n $DISPLAY ]]; then
 ln -s ~/dotfiles/.Xdefaults ~/.Xdefaults
 xrdb -merge .Xdefaults
fi

# Shell
if [ -e ~/.bash_aliases ]; then
 echo "alias vi='vim'" >> ~/.bash_aliases
fi
