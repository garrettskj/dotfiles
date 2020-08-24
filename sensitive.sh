#!/bin/bash

# This will use the local password store that is configured
# Recommended: ~/.pam_environment (processed after successful logon)
# Otherwise:
# in /etc/profile, ~/.profile, or
#
# This script will copy gp.sh and sp.sh into your user local bin.
# and setup SSH access.
#

# Confirm the environment variable has been set.
if [[ ! -z $PASSWORD_STORE ]]
 then
  echo "Store Set"
 else
  echo "\$PASSWORD_STORE Not Set"
  exit 1
fi

# Check if GP already exists.
if [ ! -e /usr/local/bin/gp.sh ]
 then
  sudo cp $(pwd)/scripts/gp.sh /usr/local/bin/
  sudo cp $(pwd)/scripts/sp.sh /usr/local/bin/
  echo "Creating & adding authorized_keys"
  mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys
  chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys
  /usr/local/bin/gp.sh -nc files/authorized_keys >> ~/.ssh/authorized_keys
 else
  echo "Password Manager already exists, keys should already exist.." 
  #/usr/local/bin/gp.sh -nc files/authorized_keys > ~/.ssh/authorized_keys
fi
