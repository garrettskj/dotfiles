#!/usr/bin/sh

## First  login

LASTPASS = ~/dotfiles/binaries/lpass

$LASTPASS login

#
## export out authorized keys
#
if [ ! -e ~/.ssh/authorized_keys]
 then
  mkdir ~/.ssh && touch ~/.ssh/authorized_keys
  chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys
  $LASTPASS show --notes authorized_keys >> ~/.ssh/authorized_keys
fi

# to show
# $LASTPASS show --notes $notename
# $LASTPASS show --notes $notename

# to use for authentication
#