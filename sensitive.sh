#!/bin/bash

## First login using the following:
#
# 'sensitive.sh $email'
#
LASTPASS='/usr/bin/lpass'

# verify that there is one argument passed at least.
if [[ $# != 1 ]]; then
 echo "Usage: $0 lastpasslogin"
 exit 1
fi

export LPASS_DISABLE_PINENTRY=1

# Login to Lastpass and get status
lplogin=$(exec $LASTPASS login $1)
lpstatus=$(exec $LASTPASS status)

## Check to see if Logged in
if [[ $lpstatus =~ .*Not.* ]]
 then
  echo $lpstatus
 else
  echo $lpstatus
  # If logged in...
  # export out authorized keys
  #
  if [ ! -f ~/.ssh/authorized_keys ]
  then
    echo "Creating & adding authorized_keys"
    mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys
    chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys
    lpcopykeys=$(exec $LASTPASS show --notes authorized_keys >> ~/.ssh/authorized_keys)
  else
   echo "Already Exists! Overwriting.."
   lpcopykeys=$(exec $LASTPASS show --notes authorized_keys > ~/.ssh/authorized_keys)
  fi
fi
