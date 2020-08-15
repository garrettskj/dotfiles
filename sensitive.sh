#!/bin/bash

## First login using the following:
#
# 'sensitive.sh $email'
#
#LASTPASS='/usr/bin/lpass'

# verify that there is one argument passed at least.
if [[ ! -z $PASSWORD_STORE ]]
 then
  echo "Store Set"
 else
  echo "Not Set"
  exit 1
fi

if [ ! -e /usr/local/bin/gp.sh ]
 then
  sudo cp $(pwd)/scripts/gp.sh /usr/local/bin/
  echo "Creating & adding authorized_keys"
  mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys
  chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys
  /usr/local/bin/gp.sh -nc files/authorized_keys >> ~/.ssh/authorized_keys
 else
  echo "Password Manager already exists, keys should already exist.." 
  #/usr/local/bin/gp.sh -nc files/authorized_keys > ~/.ssh/authorized_keys
fi
